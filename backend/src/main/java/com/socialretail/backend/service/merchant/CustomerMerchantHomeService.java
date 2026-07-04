package com.socialretail.backend.service.merchant;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.socialretail.backend.common.ImageUrlResolver;
import com.socialretail.backend.common.exception.BusinessException;
import com.socialretail.backend.dto.merchant.MerchantHomeApiModels.MerchantBasic;
import com.socialretail.backend.dto.merchant.MerchantHomeApiModels.MerchantCouponSummary;
import com.socialretail.backend.dto.merchant.MerchantHomeApiModels.MerchantHome;
import com.socialretail.backend.dto.merchant.MerchantHomeApiModels.MerchantProductItem;
import com.socialretail.backend.dto.merchant.MerchantHomeApiModels.MerchantProductPage;
import com.socialretail.backend.dto.merchant.MerchantHomeApiModels.MerchantProductSearchPage;
import com.socialretail.backend.dto.merchant.MerchantHomeApiModels.MerchantProductSummary;
import com.socialretail.backend.dto.merchant.MerchantHomeApiModels.MerchantStatistics;
import com.socialretail.backend.entity.member.Merchant;
import com.socialretail.backend.entity.member.MerchantCoupon;
import com.socialretail.backend.entity.member.MerchantCouponUser;
import com.socialretail.backend.entity.product.Product;
import com.socialretail.backend.entity.product.Sku;
import com.socialretail.backend.mapper.member.MerchantCouponMapper;
import com.socialretail.backend.mapper.member.MerchantCouponUserMapper;
import com.socialretail.backend.mapper.member.MerchantMapper;
import com.socialretail.backend.mapper.product.ProductMapper;
import com.socialretail.backend.mapper.product.SkuMapper;
import com.socialretail.backend.utils.PhoneUtil;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;

@Service
public class CustomerMerchantHomeService {
    private static final int ENABLED = 1;
    private static final int ON_SALE = 1;
    private static final int AUDIT_APPROVED = 1;

    private final MerchantMapper merchantMapper;
    private final ProductMapper productMapper;
    private final SkuMapper skuMapper;
    private final MerchantCouponMapper couponMapper;
    private final MerchantCouponUserMapper couponUserMapper;
    private final ImageUrlResolver imageUrlResolver;

    public CustomerMerchantHomeService(MerchantMapper merchantMapper,
                                       ProductMapper productMapper,
                                       SkuMapper skuMapper,
                                       MerchantCouponMapper couponMapper,
                                       MerchantCouponUserMapper couponUserMapper,
                                       ImageUrlResolver imageUrlResolver) {
        this.merchantMapper = merchantMapper;
        this.productMapper = productMapper;
        this.skuMapper = skuMapper;
        this.couponMapper = couponMapper;
        this.couponUserMapper = couponUserMapper;
        this.imageUrlResolver = imageUrlResolver;
    }

    public MerchantHome home(Long merchantId, Long userId) {
        Merchant merchant = requireMerchant(merchantId);
        if (!Integer.valueOf(ENABLED).equals(merchant.getStatus())) {
            throw new BusinessException(40931, HttpStatus.CONFLICT, "商家当前不可访问",
                    new MerchantStatusData(merchantId, merchant.getStatus()));
        }

        List<Product> availableProducts = productMapper.selectList(Wrappers.<Product>lambdaQuery()
                .eq(Product::getMerchantId, merchantId)
                .eq(Product::getStatus, ON_SALE)
                .eq(Product::getAuditStatus, AUDIT_APPROVED)
                .orderByDesc(Product::getSoldCount)
                .orderByDesc(Product::getId));
        long totalSold = availableProducts.stream().map(Product::getSoldCount)
                .filter(value -> value != null).mapToLong(Long::longValue).sum();
        List<MerchantProductSummary> recommendations = availableProducts.stream().limit(6)
                .map(this::toProductSummary).toList();

        return new MerchantHome(merchant.getId(), merchant.getMerchantName(),
                imageUrlResolver.resolve(merchant.getLogo()), merchant.getShopAddress(),
                merchant.getBusinessHours(), merchant.getIntroduction(),
                PhoneUtil.mask(merchant.getContactPhone()), merchant.getStatus(),
                statusText(merchant.getStatus()),
                new MerchantStatistics(availableProducts.size(), totalSold),
                availableCoupons(merchantId, userId), recommendations);
    }

    public MerchantBasic basic(Long merchantId) {
        Merchant merchant = requireMerchant(merchantId);
        return new MerchantBasic(merchant.getId(), merchant.getMerchantName(),
                imageUrlResolver.resolve(merchant.getLogo()), merchant.getShopAddress(),
                merchant.getBusinessHours(), merchant.getIntroduction(), merchant.getContactName(),
                PhoneUtil.mask(merchant.getContactPhone()), merchant.getStatus(),
                statusText(merchant.getStatus()), merchant.getCreateTime());
    }

    public MerchantProductPage products(Long merchantId, String keyword, Integer saleType,
                                        String sort, int page, int pageSize) {
        Merchant merchant = requireMerchant(merchantId);
        IPage<Product> result = productMapper.selectPage(new Page<>(page, pageSize),
                productQuery(merchantId, keyword, saleType, sort));
        Map<Long, ProductPriceStock> priceStocks = loadPriceStocks(result.getRecords());
        List<MerchantProductItem> items = result.getRecords().stream()
                .map(product -> toProductItem(product, merchant, priceStocks.get(product.getId())))
                .toList();
        return new MerchantProductPage(merchantId, merchant.getMerchantName(), items,
                result.getTotal(), result.getPages(), page, pageSize);
    }

    public MerchantProductSearchPage search(Long merchantId, String keyword, int page, int pageSize) {
        if (!StringUtils.hasText(keyword)) {
            throw new BusinessException(40031, HttpStatus.BAD_REQUEST, "搜索关键词不能为空");
        }
        Merchant merchant = requireMerchant(merchantId);
        String normalizedKeyword = keyword.trim();
        IPage<Product> result = productMapper.selectPage(new Page<>(page, pageSize),
                productQuery(merchantId, normalizedKeyword, null, "DEFAULT"));
        Map<Long, ProductPriceStock> priceStocks = loadPriceStocks(result.getRecords());
        List<MerchantProductItem> items = result.getRecords().stream()
                .map(product -> toProductItem(product, merchant, priceStocks.get(product.getId())))
                .toList();
        return new MerchantProductSearchPage(merchantId, merchant.getMerchantName(),
                normalizedKeyword, items, result.getTotal(), result.getPages(), page, pageSize);
    }

    private com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper<Product> productQuery(
            Long merchantId, String keyword, Integer saleType, String sort) {
        var query = Wrappers.<Product>lambdaQuery()
                .eq(Product::getMerchantId, merchantId)
                .eq(Product::getStatus, ON_SALE)
                .eq(Product::getAuditStatus, AUDIT_APPROVED);
        if (StringUtils.hasText(keyword)) {
            String value = keyword.trim();
            query.and(wrapper -> wrapper.like(Product::getTitle, value)
                    .or().like(Product::getSubTitle, value));
        }
        if (saleType != null) {
            query.eq(Product::getSaleType, saleType);
        }
        String normalizedSort = StringUtils.hasText(sort)
                ? sort.trim().toUpperCase(Locale.ROOT) : "DEFAULT";
        switch (normalizedSort) {
            case "NEW_DESC" -> query.orderByDesc(Product::getCreateTime).orderByDesc(Product::getId);
            case "SALES_DESC", "DEFAULT" -> query.orderByDesc(Product::getSoldCount)
                    .orderByDesc(Product::getId);
            default -> throw new BusinessException(40001, HttpStatus.BAD_REQUEST,
                    "sort仅支持DEFAULT、SALES_DESC、NEW_DESC");
        }
        return query;
    }

    private List<MerchantCouponSummary> availableCoupons(Long merchantId, Long userId) {
        LocalDateTime now = LocalDateTime.now();
        List<MerchantCoupon> coupons = couponMapper.selectList(Wrappers.<MerchantCoupon>lambdaQuery()
                .eq(MerchantCoupon::getMerchantId, merchantId)
                .eq(MerchantCoupon::getStatus, ENABLED)
                .le(MerchantCoupon::getValidStart, now)
                .ge(MerchantCoupon::getValidEnd, now)
                .apply("received_count < total_count")
                .orderByDesc(MerchantCoupon::getCreateTime)
                .last("LIMIT 3"));
        Set<Long> receivedCouponIds = new HashSet<>();
        if (userId != null && !coupons.isEmpty()) {
            List<Long> couponIds = coupons.stream().map(MerchantCoupon::getId).toList();
            couponUserMapper.selectList(Wrappers.<MerchantCouponUser>lambdaQuery()
                            .eq(MerchantCouponUser::getUserId, userId)
                            .in(MerchantCouponUser::getCouponId, couponIds))
                    .forEach(record -> receivedCouponIds.add(record.getCouponId()));
        }
        return coupons.stream().map(coupon -> new MerchantCouponSummary(
                coupon.getId(), coupon.getTitle(), coupon.getType(), couponTypeText(coupon.getType()),
                money(coupon.getMinConsume()), money(coupon.getDiscountAmount()),
                Math.max(zero(coupon.getTotalCount()) - zero(coupon.getReceivedCount()), 0),
                coupon.getPerUserLimit(), receivedCouponIds.contains(coupon.getId()),
                coupon.getValidStart(), coupon.getValidEnd())).toList();
    }

    private Merchant requireMerchant(Long merchantId) {
        Merchant merchant = merchantMapper.selectById(merchantId);
        if (merchant == null) {
            throw new BusinessException(40431, HttpStatus.NOT_FOUND, "商家不存在");
        }
        return merchant;
    }

    private MerchantProductSummary toProductSummary(Product product) {
        return new MerchantProductSummary(product.getId(), product.getTitle(), product.getSubTitle(),
                imageUrlResolver.resolve(product.getMainImage()), soldCount(product));
    }

    private MerchantProductItem toProductItem(Product product, Merchant merchant,
                                              ProductPriceStock priceStock) {
        BigDecimal price = priceStock == null ? null : priceStock.price();
        int stock = priceStock == null ? 0 : priceStock.stock();
        return new MerchantProductItem(product.getId(), product.getTitle(),
                imageUrlResolver.resolve(product.getMainImage()), price, price,
                soldCount(product), stock, List.of(), product.getMerchantId(),
                merchant.getMerchantName(), null);
    }

    private Map<Long, ProductPriceStock> loadPriceStocks(List<Product> products) {
        if (products.isEmpty()) {
            return Map.of();
        }
        List<Long> productIds = products.stream().map(Product::getId).toList();
        List<Sku> skus = skuMapper.selectList(Wrappers.<Sku>lambdaQuery()
                .in(Sku::getProductId, productIds));
        Map<Long, BigDecimal> minimumPrices = new HashMap<>();
        Map<Long, Integer> stocks = new HashMap<>();
        for (Sku sku : skus) {
            if (sku.getPrice() != null) {
                minimumPrices.merge(sku.getProductId(), sku.getPrice(),
                        (left, right) -> left.compareTo(right) <= 0 ? left : right);
            }
            stocks.merge(sku.getProductId(), Math.max(zero(sku.getStock()), 0), Integer::sum);
        }
        Map<Long, ProductPriceStock> result = new HashMap<>();
        for (Long productId : productIds) {
            result.put(productId, new ProductPriceStock(
                    minimumPrices.get(productId), stocks.getOrDefault(productId, 0)));
        }
        return result;
    }

    private String statusText(Integer status) {
        return Integer.valueOf(ENABLED).equals(status) ? "营业中" : "暂停营业";
    }

    private String couponTypeText(Integer type) {
        return Integer.valueOf(1).equals(type) ? "满减券" : "优惠券";
    }

    private long soldCount(Product product) {
        return product.getSoldCount() == null ? 0L : product.getSoldCount();
    }

    private int zero(Integer value) {
        return value == null ? 0 : value;
    }

    private BigDecimal money(BigDecimal value) {
        return value == null ? new BigDecimal("0.00") : value;
    }

    public record MerchantStatusData(Long merchantId, Integer status) {
    }

    private record ProductPriceStock(BigDecimal price, int stock) {
    }
}
