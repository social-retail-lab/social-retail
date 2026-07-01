package com.socialretail.backend.service.order.impl;

import com.socialretail.backend.common.exception.BusinessException;
import com.socialretail.backend.dto.request.cart.CartAddDTO;
import com.socialretail.backend.dto.request.cart.CartBatchDeleteDTO;
import com.socialretail.backend.dto.request.cart.CartUpdateDTO;
import com.socialretail.backend.dto.request.cart.CartCheckoutPreviewDTO;
import com.socialretail.backend.entity.order.Cart;
import com.socialretail.backend.entity.product.Product;
import com.socialretail.backend.entity.product.Sku;
import com.socialretail.backend.mapper.order.CartMapper;
import com.socialretail.backend.mapper.product.ProductMapper;
import com.socialretail.backend.mapper.product.SkuMapper;
import com.socialretail.backend.service.order.CartService;
import com.socialretail.backend.vo.CartAddVO;
import com.socialretail.backend.vo.CartBatchDeleteVO;
import com.socialretail.backend.vo.CartItemVO;
import com.socialretail.backend.vo.CartListVO;
import com.socialretail.backend.vo.CartPriceDetailVO;
import com.socialretail.backend.vo.CartUpdateVO;
import com.socialretail.backend.vo.CartCheckoutItemVO;
import com.socialretail.backend.vo.CartCheckoutPreviewVO;
import com.socialretail.backend.vo.CartCheckoutPriceDetailVO;
import com.socialretail.backend.vo.CartActivityInfoVO;
import com.socialretail.backend.vo.CartCouponInfoVO;
import com.socialretail.backend.vo.CartPromotionDetailVO;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Objects;

@Service
public class CartServiceImpl implements CartService {

    private static final int ON_SALE = 1;
    private static final int AUDIT_APPROVED = 1;
    private static final int MAX_QUANTITY = 999;
    private static final BigDecimal ZERO_AMOUNT = new BigDecimal("0.00");

    private final CartMapper cartMapper;
    private final SkuMapper skuMapper;
    private final ProductMapper productMapper;

    public CartServiceImpl(CartMapper cartMapper, SkuMapper skuMapper, ProductMapper productMapper) {
        this.cartMapper = cartMapper;
        this.skuMapper = skuMapper;
        this.productMapper = productMapper;
    }

    @Override
    @Transactional(readOnly = true)
    public CartListVO list(Long userId) {
        List<CartItemVO> items = cartMapper.selectCartItemsByUserId(userId);
        BigDecimal totalAmount = ZERO_AMOUNT;
        int totalQuantity = 0;
        for (CartItemVO item : items) {
            prepareItem(item);
            if (Boolean.TRUE.equals(item.getIsValid())) {
                totalQuantity += item.getQuantity();
                totalAmount = totalAmount.add(item.getItemAmount());
            }
        }
        return new CartListVO(items, totalQuantity, totalAmount, totalAmount);
    }

    @Override
    @Transactional
    public CartAddVO add(Long userId, CartAddDTO dto) {
        Sku sku = requireSku(dto.getSkuId());
        Product product = productMapper.selectById(sku.getProductId());
        requireProductAvailable(product);

        Cart existing = cartMapper.selectByUserIdAndSkuId(userId, dto.getSkuId());
        int quantity = dto.getQuantity() + (existing == null ? 0 : safeQuantity(existing.getQuantity()));
        if (quantity > MAX_QUANTITY) {
            throw new BusinessException(40001, HttpStatus.BAD_REQUEST, "购物车商品数量不能超过999");
        }
        requireStock(sku, quantity);

        if (existing == null) {
            Cart cart = new Cart();
            cart.setUserId(userId);
            cart.setSkuId(dto.getSkuId());
            cart.setQuantity(quantity);
            cartMapper.insert(cart);
            return new CartAddVO(cart.getId(), cart.getSkuId(), cart.getQuantity());
        }

        int updated = cartMapper.updateQuantity(existing.getId(), userId, quantity);
        if (updated == 0) {
            throw cartItemNotFound();
        }
        return new CartAddVO(existing.getId(), existing.getSkuId(), quantity);
    }

    @Override
    @Transactional
    public CartUpdateVO update(Long userId, Long cartItemId, CartUpdateDTO dto) {
        Cart cart = cartMapper.selectByIdAndUserId(cartItemId, userId);
        if (cart == null) {
            throw cartItemNotFound();
        }
        Sku sku = requireSku(cart.getSkuId());
        Product product = productMapper.selectById(sku.getProductId());
        requireProductAvailable(product);
        requireStock(sku, dto.getQuantity());

        int updated = cartMapper.updateQuantity(cartItemId, userId, dto.getQuantity());
        if (updated == 0) {
            throw cartItemNotFound();
        }
        BigDecimal price = sku.getPrice() == null ? ZERO_AMOUNT : sku.getPrice();
        return new CartUpdateVO(
                cartItemId, sku.getId(), dto.getQuantity(), price,
                price.multiply(BigDecimal.valueOf(dto.getQuantity()))
        );
    }

    @Override
    @Transactional
    public void delete(Long userId, Long cartItemId) {
        if (cartMapper.deleteByIdAndUserId(cartItemId, userId) == 0) {
            throw cartItemNotFound();
        }
    }

    @Override
    @Transactional
    public CartBatchDeleteVO batchDelete(Long userId, CartBatchDeleteDTO dto) {
        List<Long> ids = new ArrayList<>(new LinkedHashSet<>(dto.getCartItemIds()));
        int deletedCount = cartMapper.deleteByIdsAndUserId(userId, ids);
        return new CartBatchDeleteVO(deletedCount);
    }

    private CalculationResult calculate(Long userId, CartCheckoutPreviewDTO dto) {
        List<Long> ids = new ArrayList<>(new LinkedHashSet<>(dto.getCartItemIds()));
        List<CartItemVO> items = cartMapper.selectCartItemsByIds(userId, ids);
        if (items.size() != ids.size()) {
            throw cartItemNotFound();
        }

        BigDecimal totalAmount = ZERO_AMOUNT;
        for (CartItemVO item : items) {
            prepareItem(item);
            if (!Objects.equals(item.getProductStatus(), ON_SALE)
                    || !Objects.equals(item.getProductAuditStatus(), AUDIT_APPROVED)) {
                throw productUnavailable();
            }
            if (!Boolean.TRUE.equals(item.getIsValid())) {
                throw inventoryInsufficient(item.getSkuId(), safeStock(item.getStock()));
            }
            totalAmount = totalAmount.add(item.getItemAmount());
        }

        CartPriceDetailVO priceDetail = new CartPriceDetailVO(
                totalAmount, ZERO_AMOUNT, ZERO_AMOUNT, ZERO_AMOUNT,
                ZERO_AMOUNT, ZERO_AMOUNT, totalAmount
        );
        return new CalculationResult(priceDetail, items);
    }

    @Override
    @Transactional(readOnly = true)
    public CartCheckoutPreviewVO checkoutPreview(Long userId, CartCheckoutPreviewDTO dto) {
        CalculationResult calculated = calculate(userId, dto);
        CartPriceDetailVO calculatedPrice = calculated.priceDetail();
        List<CartCheckoutItemVO> items = calculated.items().stream()
                .map(this::toCheckoutItem)
                .toList();
        int totalQuantity = calculated.items().stream()
                .map(CartItemVO::getQuantity)
                .filter(Objects::nonNull)
                .mapToInt(Integer::intValue)
                .sum();

        CartCheckoutPriceDetailVO priceDetail = new CartCheckoutPriceDetailVO(
                calculatedPrice.getTotalAmount(),
                calculatedPrice.getSeckillDiscount(),
                calculatedPrice.getBargainDiscount(),
                ZERO_AMOUNT,
                calculatedPrice.getCouponDiscount(),
                calculatedPrice.getPointsDeduction(),
                calculatedPrice.getDeliveryFee(),
                calculatedPrice.getPayableAmount()
        );
        CartCouponInfoVO couponInfo = dto.getCouponUserId() == null ? null
                : new CartCouponInfoVO(dto.getCouponUserId(), null, calculatedPrice.getCouponDiscount());
        CartActivityInfoVO activityInfo = toActivityInfo(dto.getActivityContext());
        return new CartCheckoutPreviewVO(
                items,
                priceDetail,
                buildPromotionDetails(priceDetail),
                couponInfo,
                activityInfo,
                List.of(),
                List.of(),
                totalQuantity
        );
    }

    private CartCheckoutItemVO toCheckoutItem(CartItemVO item) {
        return new CartCheckoutItemVO(
                item.getCartId(), item.getSkuId(), item.getProductId(), item.getProductName(),
                item.getProductImage(), item.getSkuSpec(), item.getPrice(), item.getPrice(),
                item.getQuantity(), item.getStock(), item.getItemAmount(), item.getItemAmount(),
                null, ZERO_AMOUNT, item.getIsValid(), item.getInvalidReason()
        );
    }

    private List<CartPromotionDetailVO> buildPromotionDetails(CartCheckoutPriceDetailVO price) {
        List<CartPromotionDetailVO> details = new ArrayList<>();
        addPromotion(details, "SECKILL", "秒杀活动优惠", price.getSeckillDiscount());
        addPromotion(details, "BARGAIN", "砍价活动优惠", price.getBargainDiscount());
        addPromotion(details, "PROMOTION", "满减满折优惠", price.getPromotionDiscount());
        addPromotion(details, "COUPON", "优惠券优惠", price.getCouponDiscount());
        addPromotion(details, "POINTS", "积分抵扣", price.getPointsDeduction());
        return details;
    }

    private void addPromotion(List<CartPromotionDetailVO> details,
                              String type,
                              String title,
                              BigDecimal discount) {
        if (discount != null && discount.compareTo(BigDecimal.ZERO) > 0) {
            details.add(new CartPromotionDetailVO(type, title, discount));
        }
    }

    private CartActivityInfoVO toActivityInfo(Map<String, Object> context) {
        if (context == null) {
            return new CartActivityInfoVO(null, null, null, List.of());
        }
        return new CartActivityInfoVO(
                toLong(context.get("seckillId")),
                toLong(context.get("bargainId")),
                toLong(context.get("groupId")),
                toLongList(context.get("promotionIds"))
        );
    }

    private Long toLong(Object value) {
        if (value instanceof Number number) {
            return number.longValue();
        }
        if (value instanceof String text && !text.isBlank()) {
            try {
                return Long.valueOf(text);
            } catch (NumberFormatException ignored) {
                return null;
            }
        }
        return null;
    }

    private List<Long> toLongList(Object value) {
        if (!(value instanceof List<?> values)) {
            return List.of();
        }
        return values.stream().map(this::toLong).filter(Objects::nonNull).toList();
    }

    private void prepareItem(CartItemVO item) {
        int quantity = safeQuantity(item.getQuantity());
        BigDecimal price = item.getPrice() == null ? ZERO_AMOUNT : item.getPrice();
        item.setSelected(true);
        item.setItemAmount(price.multiply(BigDecimal.valueOf(quantity)));

        if (!Objects.equals(item.getProductStatus(), ON_SALE)) {
            invalidate(item, "商品已下架");
        } else if (!Objects.equals(item.getProductAuditStatus(), AUDIT_APPROVED)) {
            invalidate(item, "商品不可售");
        } else if (safeStock(item.getStock()) < quantity) {
            invalidate(item, "库存不足");
        } else {
            item.setIsValid(true);
            item.setInvalidReason(null);
        }
    }

    private void invalidate(CartItemVO item, String reason) {
        item.setIsValid(false);
        item.setInvalidReason(reason);
    }

    private Sku requireSku(Long skuId) {
        Sku sku = skuMapper.selectById(skuId);
        if (sku == null) {
            throw productUnavailable();
        }
        return sku;
    }

    private void requireProductAvailable(Product product) {
        if (product == null
                || !Objects.equals(product.getStatus(), ON_SALE)
                || !Objects.equals(product.getAuditStatus(), AUDIT_APPROVED)) {
            throw productUnavailable();
        }
    }

    private void requireStock(Sku sku, int quantity) {
        int stock = safeStock(sku.getStock());
        if (stock < quantity) {
            throw inventoryInsufficient(sku.getId(), stock);
        }
    }

    private int safeQuantity(Integer quantity) {
        return quantity == null ? 0 : quantity;
    }

    private int safeStock(Integer stock) {
        return stock == null ? 0 : stock;
    }

    private BusinessException productUnavailable() {
        return new BusinessException(40402, HttpStatus.NOT_FOUND, "商品不存在或已下架");
    }

    private BusinessException cartItemNotFound() {
        return new BusinessException(40411, HttpStatus.NOT_FOUND, "购物车商品不存在");
    }

    private BusinessException inventoryInsufficient(Long skuId, int stock) {
        return new BusinessException(
                40911, HttpStatus.CONFLICT, "商品库存不足",
                Map.of("skuId", skuId, "stock", stock)
        );
    }

    private record CalculationResult(CartPriceDetailVO priceDetail, List<CartItemVO> items) {
    }
}
