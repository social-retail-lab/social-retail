package com.socialretail.backend.service.order.impl;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.socialretail.backend.common.OrderNoUtils;
import com.socialretail.backend.common.OrderStatus;
import com.socialretail.backend.common.ImageUrlResolver;
import com.socialretail.backend.common.exception.BusinessException;
import com.socialretail.backend.config.OrderTimeoutProperties;
import com.socialretail.backend.dto.request.order.OrderCancelRequest;
import com.socialretail.backend.dto.request.order.OrderPreviewRequest;
import com.socialretail.backend.dto.request.order.OrderQueryRequest;
import com.socialretail.backend.dto.request.order.OrderSubmitRequest;
import com.socialretail.backend.dto.response.order.OrderAddressInfoResponse;
import com.socialretail.backend.dto.response.order.OrderDetailResponse;
import com.socialretail.backend.dto.response.order.OrderItemResponse;
import com.socialretail.backend.dto.response.order.OrderListResponse;
import com.socialretail.backend.dto.response.order.OrderPickupPointInfoResponse;
import com.socialretail.backend.dto.response.order.OrderPreviewResponse;
import com.socialretail.backend.dto.response.order.OrderPreviewPriceDetailResponse;
import com.socialretail.backend.dto.response.order.OrderStatusResponse;
import com.socialretail.backend.dto.response.order.OrderSubmitResponse;
import com.socialretail.backend.dto.response.order.OrderSummaryResponse;
import com.socialretail.backend.dto.response.order.OrderReceiverInfoResponse;
import com.socialretail.backend.dto.response.order.OrderPointsInfoResponse;
import com.socialretail.backend.dto.response.order.OrderPaymentInfoResponse;
import com.socialretail.backend.dto.response.order.OrderDeliveryInfoResponse;
import com.socialretail.backend.entity.address.Address;
import com.socialretail.backend.entity.order.Order;
import com.socialretail.backend.entity.order.OrderItem;
import com.socialretail.backend.entity.order.OrderStatusLog;
import com.socialretail.backend.entity.order.PickupPoint;
import com.socialretail.backend.entity.order.Payment;
import com.socialretail.backend.entity.order.Delivery;
import com.socialretail.backend.mapper.address.AddressMapper;
import com.socialretail.backend.mapper.order.CartMapper;
import com.socialretail.backend.mapper.order.OrderMapper;
import com.socialretail.backend.mapper.order.PaymentMapper;
import com.socialretail.backend.mapper.order.DeliveryMapper;
import com.socialretail.backend.service.order.OrderService;
import com.socialretail.backend.service.order.OrderPointsService;
import com.socialretail.backend.service.order.OrderPreviewCacheService;
import com.socialretail.backend.service.order.OrderPreviewSelection;
import com.socialretail.backend.service.order.pricing.OrderItemPrice;
import com.socialretail.backend.service.order.pricing.OrderPricingCommand;
import com.socialretail.backend.service.order.pricing.OrderPricingResult;
import com.socialretail.backend.service.order.pricing.OrderPricingService;
import com.socialretail.backend.service.order.pricing.PlatformCouponPricingService;
import com.socialretail.backend.service.order.pricing.SeckillOrderPricingService;
import com.socialretail.backend.service.order.pricing.MerchantCouponPricingService;
import com.socialretail.backend.utils.PhoneUtil;
import com.socialretail.backend.vo.CartItemVO;
import com.socialretail.backend.vo.CartActivityInfoVO;
import com.socialretail.backend.vo.CartCouponInfoVO;
import com.socialretail.backend.vo.CartPromotionDetailVO;
import com.socialretail.backend.vo.CouponBundleVO;
import com.socialretail.backend.vo.AvailableCouponGroupsVO;
import com.socialretail.backend.vo.PromotionActivityInfoVO;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.math.BigDecimal;
import java.security.SecureRandom;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Objects;
import java.util.Set;
import java.util.LinkedHashMap;
import java.util.Map;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;

@Service
public class OrderServiceImpl implements OrderService {

    public static final int WAIT_PAY = OrderStatus.WAIT_PAY;
    public static final int WAIT_SHIP = OrderStatus.WAIT_ACCEPT;
    public static final int WAIT_PICKUP = OrderStatus.ACCEPTED;
    public static final int DELIVERING = OrderStatus.IN_PROGRESS;
    public static final int COMPLETED = OrderStatus.COMPLETED;
    public static final int CANCELLED = OrderStatus.CANCELLED;
    public static final int CLOSED = OrderStatus.CLOSED;

    private static final int DELIVERY = OrderStatus.DELIVERY;
    private static final int PICKUP = OrderStatus.PICKUP;
    private static final int ON_SALE = 1;
    private static final int AUDIT_APPROVED = 1;
    private static final BigDecimal ZERO = new BigDecimal("0.00");
    private static final SecureRandom RANDOM = new SecureRandom();

    private final OrderMapper orderMapper;
    private final CartMapper cartMapper;
    private final AddressMapper addressMapper;
    private final OrderPricingService pricingService;
    private final OrderTimeoutProperties timeoutProperties;
    private final OrderPointsService orderPointsService;
    private final PlatformCouponPricingService platformCouponPricingService;
    private final PaymentMapper paymentMapper;
    private final DeliveryMapper deliveryMapper;
    private final SeckillOrderPricingService seckillOrderPricingService;
    private final ObjectMapper objectMapper;
    private final MerchantCouponPricingService merchantCouponPricingService;
    private final OrderPreviewCacheService previewCacheService;
    private final ImageUrlResolver imageUrlResolver;

    public OrderServiceImpl(OrderMapper orderMapper,
                            CartMapper cartMapper,
                            AddressMapper addressMapper,
                            OrderPricingService pricingService,
                            OrderTimeoutProperties timeoutProperties,
                            OrderPointsService orderPointsService,
                            PlatformCouponPricingService platformCouponPricingService,
                            PaymentMapper paymentMapper,
                            DeliveryMapper deliveryMapper,
                            SeckillOrderPricingService seckillOrderPricingService,
                            ObjectMapper objectMapper,
                            MerchantCouponPricingService merchantCouponPricingService,
                            OrderPreviewCacheService previewCacheService,
                            ImageUrlResolver imageUrlResolver) {
        this.orderMapper = orderMapper;
        this.cartMapper = cartMapper;
        this.addressMapper = addressMapper;
        this.pricingService = pricingService;
        this.timeoutProperties = timeoutProperties;
        this.orderPointsService = orderPointsService;
        this.platformCouponPricingService = platformCouponPricingService;
        this.paymentMapper = paymentMapper;
        this.deliveryMapper = deliveryMapper;
        this.seckillOrderPricingService = seckillOrderPricingService;
        this.objectMapper = objectMapper;
        this.merchantCouponPricingService = merchantCouponPricingService;
        this.previewCacheService = previewCacheService;
        this.imageUrlResolver = imageUrlResolver;
    }

    @Override
    @Transactional(readOnly = true)
    public OrderPreviewResponse preview(Long userId, OrderPreviewRequest request) {
        CartContext context = loadCartContext(userId, request.getCartItemIds());
        Fulfillment fulfillment = resolveFulfillment(
                userId, context.merchantId(), request.getDeliveryType(),
                request.getAddressId(), request.getPickupPointId()
        );
        OrderPricingResult pricing = pricingService.calculate(new OrderPricingCommand(
                userId, context.merchantId(), context.items(), request.getUsePlatformCoupon(),
                request.getPlatformCouponUserId(), request.getUseMerchantCoupon(),
                request.getMerchantCouponUserId(), request.getUsePoints(), request.getUsePointsAmount(),
                request.getActivityContext(), false, true
        ));
        OrderPreviewResponse response = new OrderPreviewResponse();
        response.setItemList(context.items().stream()
                .map(item -> toPreviewItem(item, pricing.getItemPrices().get(item.getCartId())))
                .toList());
        applyPreviewPricing(response, pricing);
        response.setActivityInfo(new PromotionActivityInfoVO(
                pricing.getAppliedSeckillId(), pricing.getAppliedBargainId(),
                request.getActivityContext() == null ? null : request.getActivityContext().getGroupId(),
                pricing.getAppliedPromotionIds()));
        response.setCouponInfo(new CouponBundleVO(pricing.getPlatformCoupon(), pricing.getMerchantCoupon()));
        response.setAddressInfo(toAddressInfo(fulfillment.address()));
        response.setPickupPointInfo(toPickupInfo(fulfillment.pickupPoint()));
        com.socialretail.backend.dto.request.order.OrderActivityContextRequest selectedActivity =
                new com.socialretail.backend.dto.request.order.OrderActivityContextRequest();
        selectedActivity.setSeckillProductId(pricing.getAppliedSeckillId());
        selectedActivity.setBargainRecordId(pricing.getAppliedBargainId());
        selectedActivity.setGroupId(request.getActivityContext() == null
                ? null : request.getActivityContext().getGroupId());
        selectedActivity.setPromotionIds(pricing.getAppliedPromotionIds());
        int selectedPoints = value(pricing.getPointsInfo().getUsedPoints());
        OrderPreviewSelection selection = new OrderPreviewSelection(
                distinctIds(request.getCartItemIds()),
                request.getDeliveryType() == null ? DELIVERY : request.getDeliveryType(),
                fulfillment.address() == null ? null : fulfillment.address().getId(),
                fulfillment.pickupPoint() == null ? null : fulfillment.pickupPoint().getId(),
                pricing.getAppliedCouponUserId(), pricing.getAppliedMerchantCouponUserId(),
                selectedPoints > 0 ? selectedPoints : null, selectedActivity,
                StringUtils.hasText(request.getRemark()) ? request.getRemark().trim() : null);
        response.setPreviewToken(previewCacheService.save(userId, selection));
        response.setPreviewExpireSeconds(OrderPreviewCacheService.EXPIRE_SECONDS);
        return response;
    }

    @Override
    @Transactional
    public OrderSubmitResponse submit(Long userId, String idempotentKey, OrderSubmitRequest request) {
        Order existingOrder = orderMapper.selectByUserIdAndIdempotentKey(userId, idempotentKey);
        if (existingOrder != null) {
            return toSubmitResponse(existingOrder, true);
        }
        OrderPreviewSelection selection = previewCacheService.require(userId, request.getPreviewToken());
        List<Long> cartItemIds = distinctIds(selection.getCartItemIds());
        CartContext context = loadCartContext(userId, cartItemIds);
        Fulfillment fulfillment = resolveFulfillment(
                userId, context.merchantId(), selection.getDeliveryType(),
                selection.getAddressId(), selection.getPickupPointId()
        );
        OrderPricingResult pricing = pricingService.calculate(new OrderPricingCommand(
                userId, context.merchantId(), context.items(), selection.getPlatformCouponUserId() != null,
                selection.getPlatformCouponUserId(), selection.getMerchantCouponUserId() != null,
                selection.getMerchantCouponUserId(), selection.getUsePointsAmount() != null,
                selection.getUsePointsAmount(), selection.getActivityContext(), false, false
        ));

        LocalDateTime now = LocalDateTime.now();
        Order order = buildOrder(userId, idempotentKey, selection, context, fulfillment, pricing, now);
        try {
            if (orderMapper.insertOrder(order) != 1 || order.getId() == null) {
                throw new IllegalStateException("订单创建失败");
            }
        } catch (DuplicateKeyException exception) {
            Order duplicated = orderMapper.selectByUserIdAndIdempotentKey(userId, idempotentKey);
            if (duplicated != null) {
                return toSubmitResponse(duplicated, true);
            }
            throw exception;
        }

        orderPointsService.reserve(userId, value(pricing.getPointsInfo().getUsedPoints()), order.getOrderSn());
        platformCouponPricingService.markUsed(pricing.getAppliedCouponUserId(), userId, order.getId(), now);
        merchantCouponPricingService.markUsed(pricing.getAppliedMerchantCouponUserId(), userId, order.getId(), now);
        seckillOrderPricingService.consume(seckillOrderPricingService.quote(
                userId, pricing.getAppliedSeckillId(), context.items()));

        for (CartItemVO cartItem : context.items()) {
            OrderItem item = toOrderItem(
                    order.getId(), cartItem, pricing.getItemPrices().get(cartItem.getCartId())
            );
            if (orderMapper.insertOrderItem(item) != 1) {
                throw new IllegalStateException("订单商品快照保存失败");
            }
            if (orderMapper.decrementStock(cartItem.getSkuId(), cartItem.getQuantity()) != 1) {
                throw inventoryInsufficient(cartItem.getSkuId(), cartItem.getStock());
            }
        }

        int deleted = cartMapper.deleteByIdsAndUserId(userId, cartItemIds);
        if (deleted != cartItemIds.size()) {
            throw cartItemNotFound();
        }
        insertStatusLog(order.getId(), null, WAIT_PAY, userId, "订单创建", now);
        return toSubmitResponse(order, false);
    }

    @Override
    @Transactional(readOnly = true)
    public OrderListResponse list(Long userId, OrderQueryRequest request) {
        int page = request.getPage();
        int pageSize = request.getPageSize();
        long offsetValue = (long) (page - 1) * pageSize;
        if (offsetValue > Integer.MAX_VALUE) {
            throw new BusinessException(40001, HttpStatus.BAD_REQUEST, "页码超出允许范围");
        }
        long total = orderMapper.countOrdersByUserId(userId, request.getStatus());
        List<OrderSummaryResponse> list = orderMapper.selectOrdersByUserId(
                        userId, request.getStatus(), (int) offsetValue, pageSize
                ).stream()
                .map(this::toSummary)
                .toList();
        int pages = (int) ((total + pageSize - 1) / pageSize);
        return new OrderListResponse(list, total, pages, page, pageSize);
    }

    @Override
    @Transactional(readOnly = true)
    public OrderDetailResponse detail(Long userId, Long orderId) {
        Order order = requireOrder(userId, orderId);
        List<OrderItemResponse> items = orderMapper.selectItemsByOrderId(orderId).stream()
                .map(this::toItemResponse)
                .toList();
        PickupPoint pickupPoint = order.getPickupPointId() == null
                ? null : orderMapper.selectPickupPointById(order.getPickupPointId());
        Payment payment = paymentMapper.selectLatestByOrderIdAndUserId(orderId, userId);
        Delivery delivery = deliveryMapper.selectOne(Wrappers.<Delivery>lambdaQuery()
                .eq(Delivery::getOrderId, orderId).orderByDesc(Delivery::getId).last("LIMIT 1"));
        return toDetail(order, items, pickupPoint, payment, delivery);
    }

    @Override
    @Transactional
    public OrderStatusResponse cancel(Long userId, Long orderId, OrderCancelRequest request) {
        Order order = requireOrder(userId, orderId);
        if (!Objects.equals(order.getStatus(), WAIT_PAY)) {
            throw invalidOrderStatus("仅待支付订单可以取消");
        }
        if (orderMapper.cancelWaitPayOrder(orderId, userId) != 1) {
            throw invalidOrderStatus("订单状态已变化，请刷新后重试");
        }
        orderPointsService.release(order);
        platformCouponPricingService.restoreByOrderId(order.getId());
        merchantCouponPricingService.restoreByOrderId(order.getId());
        List<OrderItem> items = orderMapper.selectItemsByOrderId(orderId);
        for (OrderItem item : items) {
            if (item.getSkuId() != null
                    && orderMapper.incrementStock(item.getSkuId(), item.getQuantity()) != 1) {
                throw new IllegalStateException("订单库存恢复失败");
            }
            if ("SECKILL".equals(item.getPromotionType())) {
                seckillOrderPricingService.release(order.getSeckillId(), item.getQuantity());
            }
        }
        LocalDateTime now = LocalDateTime.now();
        String reason = request == null || !StringUtils.hasText(request.getReason())
                ? "用户取消订单" : request.getReason().trim();
        insertStatusLog(orderId, WAIT_PAY, CANCELLED, userId, reason, now);
        return new OrderStatusResponse(CANCELLED, statusText(CANCELLED), now);
    }

    @Override
    @Transactional
    public OrderStatusResponse confirm(Long userId, Long orderId) {
        Order order = requireOrder(userId, orderId);
        if (!Set.of(WAIT_SHIP, WAIT_PICKUP, DELIVERING).contains(order.getStatus())) {
            throw invalidOrderStatus("当前订单状态不可确认收货");
        }
        if (orderMapper.completeOrder(orderId, userId) != 1) {
            throw invalidOrderStatus("订单状态已变化，请刷新后重试");
        }
        LocalDateTime now = LocalDateTime.now();
        insertStatusLog(orderId, order.getStatus(), COMPLETED, userId, "用户确认收货", now);
        return new OrderStatusResponse(COMPLETED, statusText(COMPLETED), now);
    }

    @Override
    @Transactional(readOnly = true)
    public OrderStatusResponse status(Long userId, Long orderId) {
        Order order = requireOrder(userId, orderId);
        LocalDateTime updateTime = order.getUpdateTime() == null
                ? order.getCreateTime() : order.getUpdateTime();
        return new OrderStatusResponse(order.getStatus(), statusText(order.getStatus()), updateTime);
    }

    private CartContext loadCartContext(Long userId, List<Long> requestedIds) {
        List<Long> ids = distinctIds(requestedIds);
        List<CartItemVO> items = cartMapper.selectCartItemsByIds(userId, ids);
        if (items.size() != ids.size()) {
            throw cartItemNotFound();
        }
        Set<Long> merchantIds = new LinkedHashSet<>();
        BigDecimal total = ZERO;
        for (CartItemVO item : items) {
            item.setProductImage(imageUrlResolver.resolve(item.getProductImage()));
            if (!Objects.equals(item.getProductStatus(), ON_SALE)
                    || !Objects.equals(item.getProductAuditStatus(), AUDIT_APPROVED)) {
                throw new BusinessException(40402, HttpStatus.NOT_FOUND, "商品不存在或已下架");
            }
            int stock = item.getStock() == null ? 0 : item.getStock();
            int quantity = item.getQuantity() == null ? 0 : item.getQuantity();
            if (quantity <= 0 || stock < quantity) {
                throw inventoryInsufficient(item.getSkuId(), stock);
            }
            if (item.getMerchantId() == null) {
                throw new BusinessException(40912, HttpStatus.CONFLICT, "商品未关联有效商家");
            }
            merchantIds.add(item.getMerchantId());
            BigDecimal price = item.getPrice() == null ? ZERO : item.getPrice();
            total = total.add(price.multiply(BigDecimal.valueOf(quantity)));
        }
        if (merchantIds.size() != 1) {
            throw new BusinessException(40915, HttpStatus.CONFLICT, "当前订单只能结算同一商家的商品",
                    Map.of("cartItemIds", ids));
        }
        return new CartContext(items, merchantIds.iterator().next(), total);
    }

    private Fulfillment resolveFulfillment(Long userId,
                                           Long merchantId,
                                           Integer deliveryType,
                                           Long addressId,
                                           Long pickupPointId) {
        int type = deliveryType == null ? DELIVERY : deliveryType;
        if (type == DELIVERY) {
            Address address = addressId == null
                    ? addressMapper.selectDefaultByUserId(userId)
                    : addressMapper.selectByIdAndUserId(addressId, userId);
            if (address == null) {
                throw new BusinessException(40001, HttpStatus.BAD_REQUEST, "请选择有效的收货地址");
            }
            return new Fulfillment(address, null);
        }
        if (type == PICKUP) {
            if (pickupPointId == null) {
                throw new BusinessException(40001, HttpStatus.BAD_REQUEST, "请选择自提点");
            }
            PickupPoint pickupPoint = orderMapper.selectPickupPointById(pickupPointId);
            if (pickupPoint == null || !Objects.equals(pickupPoint.getStatus(), 1)
                    || !Objects.equals(pickupPoint.getMerchantId(), merchantId)) {
                throw new BusinessException(40431, HttpStatus.NOT_FOUND, "自提点不存在或不可用");
            }
            return new Fulfillment(null, pickupPoint);
        }
        throw new BusinessException(40001, HttpStatus.BAD_REQUEST, "配送方式仅支持1或2");
    }

    private Order buildOrder(Long userId,
                             String idempotentKey,
                             OrderPreviewSelection selection,
                             CartContext context,
                             Fulfillment fulfillment,
                             OrderPricingResult pricing,
                             LocalDateTime now) {
        Order order = new Order();
        order.setOrderSn(OrderNoUtils.generate());
        order.setIdempotentKey(idempotentKey);
        order.setUserId(userId);
        order.setMerchantId(context.merchantId());
        order.setPickupPointId(fulfillment.pickupPoint() == null ? null : fulfillment.pickupPoint().getId());
        order.setAddressId(fulfillment.address() == null ? null : fulfillment.address().getId());
        copyAddressSnapshot(order, fulfillment.address());
        order.setTotalAmount(pricing.getOriginalAmount());
        order.setPayAmount(pricing.getPayableAmount());
        order.setDeliveryType(selection.getDeliveryType() == null ? DELIVERY : selection.getDeliveryType());
        order.setStatus(WAIT_PAY);
        order.setCreateTime(now);
        order.setPayExpireTime(now.plusMinutes(timeoutProperties.getTimeoutMinutes()));
        order.setUpdateTime(now);
        order.setDiscountAmount(pricing.getDiscountAmount());
        order.setDeliveryFee(pricing.getDeliveryFee());
        order.setSeckillDiscount(pricing.getSeckillDiscount());
        order.setBargainDiscount(pricing.getBargainDiscount());
        order.setPromotionDiscount(pricing.getPromotionDiscount());
        order.setCouponDiscount(pricing.getCouponDiscount());
        order.setMerchantCouponDiscount(pricing.getMerchantCouponDiscount());
        order.setPointsDeduction(pricing.getPointsDeduction());
        int usedPoints = value(pricing.getPointsInfo().getUsedPoints());
        order.setUsedPoints(usedPoints);
        order.setPointsStatus(usedPoints > 0 ? OrderPointsService.RESERVED : OrderPointsService.NONE);
        order.setCouponUserId(pricing.getAppliedCouponUserId());
        order.setMerchantCouponUserId(pricing.getAppliedMerchantCouponUserId());
        order.setSeckillId(pricing.getAppliedSeckillId());
        order.setBargainId(pricing.getAppliedBargainId());
        order.setPromotionSnapshot(toPromotionSnapshotJson(pricing));
        order.setPickupCode(fulfillment.pickupPoint() == null ? null : generatePickupCode());
        order.setRemark(StringUtils.hasText(selection.getRemark()) ? selection.getRemark().trim() : null);
        return order;
    }

    private void copyAddressSnapshot(Order order, Address address) {
        if (address == null) {
            return;
        }
        order.setConsignee(address.getConsignee());
        order.setPhone(address.getPhone());
        order.setProvince(address.getProvince());
        order.setCity(address.getCity());
        order.setDistrict(address.getDistrict());
        order.setDetailedAddress(address.getDetailedAddress());
    }

    private OrderItem toOrderItem(Long orderId, CartItemVO cartItem, OrderItemPrice itemPrice) {
        OrderItemPrice price = requireItemPrice(cartItem, itemPrice);
        OrderItem item = new OrderItem();
        item.setOrderId(orderId);
        item.setProductId(cartItem.getProductId());
        item.setSkuId(cartItem.getSkuId());
        item.setProductName(cartItem.getProductName());
        item.setProductImage(cartItem.getProductImage());
        item.setSkuSpecs(cartItem.getSkuSpec());
        item.setOriginPrice(price.originPrice());
        item.setFinalPrice(price.finalPrice());
        item.setPrice(price.finalPrice());
        item.setQuantity(cartItem.getQuantity());
        item.setItemOriginAmount(price.originAmount());
        item.setItemFinalAmount(price.finalAmount());
        item.setPromotionType(price.promotionType());
        item.setDistributorProductId(cartItem.getDistributorProductId());
        item.setCommissionRate(cartItem.getCommissionRate());
        item.setAttributionExpiresAt(cartItem.getPromotionExpiresAt());
        return item;
    }

    private void insertStatusLog(Long orderId,
                                 Integer fromStatus,
                                 Integer toStatus,
                                 Long userId,
                                 String remark,
                                 LocalDateTime time) {
        OrderStatusLog log = new OrderStatusLog();
        log.setOrderId(orderId);
        log.setFromStatus(fromStatus);
        log.setToStatus(toStatus);
        log.setStatusText(statusText(toStatus));
        log.setOperatorType("USER");
        log.setOperatorId(userId);
        log.setRemark(remark);
        log.setCreateTime(time);
        if (orderMapper.insertStatusLog(log) != 1) {
            throw new IllegalStateException("订单状态日志保存失败");
        }
    }

    private OrderSummaryResponse toSummary(Order order) {
        OrderSummaryResponse response = new OrderSummaryResponse();
        response.setOrderId(order.getId());
        response.setOrderSn(order.getOrderSn());
        response.setMerchantId(order.getMerchantId());
        response.setStatus(order.getStatus());
        response.setStatusText(statusText(order.getStatus()));
        response.setTotalAmount(order.getTotalAmount());
        response.setPayAmount(order.getPayAmount());
        response.setDeliveryType(order.getDeliveryType());
        response.setCreateTime(order.getCreateTime());
        response.setPayExpireTime(order.getPayExpireTime());
        response.setItemList(orderMapper.selectItemsByOrderId(order.getId()).stream()
                .limit(2).map(this::toItemResponse).toList());
        return response;
    }

    private OrderDetailResponse toDetail(Order order,
                                         List<OrderItemResponse> items,
                                         PickupPoint pickupPoint,
                                         Payment payment,
                                         Delivery delivery) {
        OrderDetailResponse response = new OrderDetailResponse();
        response.setOrderId(order.getId());
        response.setOrderSn(order.getOrderSn());
        response.setStatus(OrderStatus.userStatusCode(order.getStatus()));
        response.setStatusText(OrderStatus.userStatusText(order.getStatus(), order.getDeliveryType()));
        response.setDeliveryType(Objects.equals(order.getDeliveryType(), PICKUP) ? "PICKUP" : "DELIVERY");
        response.setTotalAmount(order.getTotalAmount());
        response.setDiscountAmount(zeroIfNull(order.getDiscountAmount()));
        response.setDeliveryFee(zeroIfNull(order.getDeliveryFee()));
        response.setPayAmount(order.getPayAmount());
        response.setPriceDetail(new OrderPreviewPriceDetailResponse(
                zeroIfNull(order.getTotalAmount()), zeroIfNull(order.getSeckillDiscount()),
                zeroIfNull(order.getBargainDiscount()), zeroIfNull(order.getPromotionDiscount()),
                zeroIfNull(order.getMerchantCouponDiscount()), zeroIfNull(order.getCouponDiscount()),
                zeroIfNull(order.getPointsDeduction()), zeroIfNull(order.getDeliveryFee()),
                zeroIfNull(order.getPayAmount())));
        response.setPromotionDetail(buildOrderPromotionDetails(order));
        response.setCouponInfo(new CouponBundleVO(
                platformCouponPricingService.orderCoupon(order.getUserId(), order.getCouponUserId(),
                        order.getCouponDiscount()),
                merchantCouponPricingService.orderCoupon(order.getUserId(), order.getMerchantCouponUserId(),
                        order.getMerchantCouponDiscount())));
        response.setPointsInfo(new OrderPointsInfoResponse(value(order.getUsedPoints()),
                zeroIfNull(order.getPointsDeduction()), "100积分抵扣1元"));
        response.setReceiverInfo(toReceiverInfo(order));
        response.setPickupPointInfo(toPickupInfo(pickupPoint));
        response.setPaymentInfo(toPaymentInfo(payment));
        response.setDeliveryInfo(toDeliveryInfo(delivery));
        response.setItemList(items);
        response.setCreateTime(order.getCreateTime());
        response.setPayExpireTime(order.getPayExpireTime());
        return response;
    }

    private OrderItemResponse toPreviewItem(CartItemVO cartItem, OrderItemPrice itemPrice) {
        OrderItemPrice price = requireItemPrice(cartItem, itemPrice);
        OrderItemResponse response = new OrderItemResponse();
        response.setCartItemId(cartItem.getCartId());
        response.setSkuId(cartItem.getSkuId());
        response.setProductId(cartItem.getProductId());
        response.setProductName(cartItem.getProductName());
        response.setProductImage(cartItem.getProductImage());
        response.setSkuSpecs(cartItem.getSkuSpec());
        response.setOriginPrice(price.originPrice());
        response.setFinalPrice(price.finalPrice());
        response.setQuantity(cartItem.getQuantity());
        response.setItemOriginAmount(price.originAmount());
        response.setItemFinalAmount(price.finalAmount());
        response.setPromotionType(price.promotionType());
        response.setActivityDiscount(price.originAmount().subtract(price.finalAmount()).max(ZERO));
        return response;
    }

    private List<CartPromotionDetailVO> buildOrderPromotionDetails(Order order) {
        List<CartPromotionDetailVO> details = new ArrayList<>();
        addPromotion(details, "SECKILL", "秒杀活动优惠", order.getSeckillDiscount());
        addPromotion(details, "BARGAIN", "砍价活动优惠", order.getBargainDiscount());
        addPromotion(details, "PROMOTION", "满减满折优惠", order.getPromotionDiscount());
        addPromotion(details, "MERCHANT_COUPON", "商家优惠券", order.getMerchantCouponDiscount());
        addPromotion(details, "PLATFORM_COUPON", "平台优惠券", order.getCouponDiscount());
        if (zeroIfNull(order.getPointsDeduction()).compareTo(ZERO) > 0) {
            details.add(new CartPromotionDetailVO("POINTS", "积分抵扣",
                    order.getPointsDeduction(), value(order.getUsedPoints())));
        }
        return details;
    }

    private OrderReceiverInfoResponse toReceiverInfo(Order order) {
        if (order.getAddressId() == null) return null;
        String fullAddress = String.join("", safe(order.getProvince()), safe(order.getCity()),
                safe(order.getDistrict()), safe(order.getDetailedAddress()));
        return new OrderReceiverInfoResponse(order.getConsignee(), PhoneUtil.mask(order.getPhone()), fullAddress);
    }

    private OrderReceiverInfoResponse toReceiverInfo(Address address) {
        if (address == null) return null;
        String fullAddress = String.join("", safe(address.getProvince()), safe(address.getCity()),
                safe(address.getDistrict()), safe(address.getDetailedAddress()));
        return new OrderReceiverInfoResponse(address.getConsignee(), PhoneUtil.mask(address.getPhone()), fullAddress);
    }

    private OrderPaymentInfoResponse toPaymentInfo(Payment payment) {
        if (payment == null) return null;
        String platform = payment.getPayPlatform() == null ? null
                : payment.getPayPlatform() == 2 ? "MOCK" : "ALIPAY";
        String status = payment.getStatus() == null ? "UNKNOWN"
                : payment.getStatus() == 0 ? "UNPAID" : payment.getStatus() == 1 ? "PAID" : "FAILED";
        return new OrderPaymentInfoResponse(payment.getId(), payment.getPaySn(), platform, status, payment.getPayTime());
    }

    private OrderDeliveryInfoResponse toDeliveryInfo(Delivery delivery) {
        if (delivery == null) return null;
        String status = delivery.getStatus() == null ? "UNKNOWN" : switch (delivery.getStatus()) {
            case 0 -> "WAITING"; case 1 -> "DELIVERING"; case 2 -> "COMPLETED"; default -> "UNKNOWN";
        };
        return new OrderDeliveryInfoResponse(delivery.getId(), delivery.getDeliverySn(), status,
                delivery.getDispatcherName(), PhoneUtil.mask(delivery.getDispatcherPhone()),
                delivery.getStartTime(), delivery.getEndTime());
    }

    private String safe(String value) { return value == null ? "" : value; }

    private void applyPreviewPricing(OrderPreviewResponse response, OrderPricingResult pricing) {
        response.setPriceDetail(new OrderPreviewPriceDetailResponse(
                pricing.getOriginalAmount(), pricing.getSeckillDiscount(),
                pricing.getBargainDiscount(), pricing.getPromotionDiscount(),
                pricing.getMerchantCouponDiscount(), pricing.getCouponDiscount(), pricing.getPointsDeduction(),
                pricing.getDeliveryFee(), pricing.getPayableAmount()));
        response.setPointsInfo(pricing.getPointsInfo());
        response.setPromotionDetail(buildPromotionDetails(pricing));
        response.setAvailablePromotions(pricing.getAvailablePromotions());
        response.setAvailableCoupons(new AvailableCouponGroupsVO(
                pricing.getAvailablePlatformCoupons(), pricing.getAvailableMerchantCoupons()));
    }

    private List<CartPromotionDetailVO> buildPromotionDetails(OrderPricingResult pricing) {
        List<CartPromotionDetailVO> details = new ArrayList<>();
        addPromotion(details, "SECKILL", "秒杀活动优惠", pricing.getSeckillDiscount());
        addPromotion(details, "BARGAIN", "砍价活动优惠", pricing.getBargainDiscount());
        addPromotion(details, "PROMOTION", "满减满折优惠", pricing.getPromotionDiscount());
        addPromotion(details, "MERCHANT_COUPON",
                pricing.getMerchantCoupon() == null ? "商家优惠券" : pricing.getMerchantCoupon().getTitle(),
                pricing.getMerchantCouponDiscount());
        addPromotion(details, "PLATFORM_COUPON",
                pricing.getPlatformCoupon() == null ? "平台优惠券" : pricing.getPlatformCoupon().getTitle(),
                pricing.getCouponDiscount());
        if (pricing.getPointsDeduction() != null && pricing.getPointsDeduction().compareTo(ZERO) > 0) {
            details.add(new CartPromotionDetailVO("POINTS", "积分抵扣",
                    pricing.getPointsDeduction(), value(pricing.getPointsInfo().getUsedPoints())));
        }
        return details;
    }

    private Map<String, Object> buildPromotionSnapshot(OrderPricingResult pricing) {
        Map<String, Object> snapshot = new LinkedHashMap<>();
        snapshot.put("totalAmount", pricing.getOriginalAmount());
        snapshot.put("seckillProductId", pricing.getAppliedSeckillId());
        snapshot.put("bargainRecordId", pricing.getAppliedBargainId());
        snapshot.put("promotionIds", pricing.getAppliedPromotionIds());
        snapshot.put("merchantCouponUserId", pricing.getAppliedMerchantCouponUserId());
        snapshot.put("platformCouponUserId", pricing.getAppliedCouponUserId());
        snapshot.put("usedPoints", value(pricing.getPointsInfo().getUsedPoints()));
        snapshot.put("merchantCouponDiscount", pricing.getMerchantCouponDiscount());
        snapshot.put("platformCouponDiscount", pricing.getCouponDiscount());
        snapshot.put("pointsDeduction", pricing.getPointsDeduction());
        snapshot.put("promotionDiscount", pricing.getPromotionDiscount());
        snapshot.put("seckillDiscount", pricing.getSeckillDiscount());
        snapshot.put("bargainDiscount", pricing.getBargainDiscount());
        snapshot.put("finalPayAmount", pricing.getPayableAmount());
        return snapshot;
    }

    private String toPromotionSnapshotJson(OrderPricingResult pricing) {
        try {
            return objectMapper.writeValueAsString(buildPromotionSnapshot(pricing));
        } catch (JsonProcessingException exception) {
            throw new IllegalStateException("订单优惠快照生成失败", exception);
        }
    }

    private void addPromotion(List<CartPromotionDetailVO> details, String type,
                              String title, BigDecimal discount) {
        if (discount != null && discount.compareTo(BigDecimal.ZERO) > 0) {
            details.add(new CartPromotionDetailVO(type, title, discount));
        }
    }

    private OrderItemPrice requireItemPrice(CartItemVO item, OrderItemPrice price) {
        if (price == null) {
            throw new IllegalStateException("商品价格计算结果缺失: cartItemId=" + item.getCartId());
        }
        return price;
    }

    private OrderItemResponse toItemResponse(OrderItem item) {
        OrderItemResponse response = new OrderItemResponse();
        response.setOrderItemId(item.getId());
        response.setSkuId(item.getSkuId());
        response.setProductId(item.getProductId());
        response.setProductName(item.getProductName());
        response.setProductImage(imageUrlResolver.resolve(item.getProductImage()));
        response.setSkuSpecs(item.getSkuSpecs());
        response.setOriginPrice(item.getOriginPrice());
        response.setFinalPrice(item.getFinalPrice());
        response.setQuantity(item.getQuantity());
        response.setItemOriginAmount(item.getItemOriginAmount());
        response.setItemFinalAmount(item.getItemFinalAmount());
        response.setPromotionType(item.getPromotionType());
        response.setActivityDiscount(zeroIfNull(item.getItemOriginAmount())
                .subtract(zeroIfNull(item.getItemFinalAmount())).max(ZERO));
        return response;
    }

    private OrderAddressInfoResponse toAddressInfo(Address address) {
        if (address == null) {
            return null;
        }
        return new OrderAddressInfoResponse(
                address.getId(), address.getConsignee(), PhoneUtil.mask(address.getPhone()),
                address.getProvince(), address.getCity(), address.getDistrict(), address.getDetailedAddress()
        );
    }

    private OrderAddressInfoResponse toAddressInfo(Order order) {
        if (order.getAddressId() == null) {
            return null;
        }
        return new OrderAddressInfoResponse(
                order.getAddressId(), order.getConsignee(), PhoneUtil.mask(order.getPhone()),
                order.getProvince(), order.getCity(), order.getDistrict(), order.getDetailedAddress()
        );
    }

    private OrderPickupPointInfoResponse toPickupInfo(PickupPoint pickupPoint) {
        if (pickupPoint == null) {
            return null;
        }
        return new OrderPickupPointInfoResponse(
                pickupPoint.getId(), pickupPoint.getName(), pickupPoint.getAddress(),
                PhoneUtil.mask(pickupPoint.getContactPhone()), pickupPoint.getBusinessHours()
        );
    }

    private Order requireOrder(Long userId, Long orderId) {
        Order order = orderMapper.selectByIdAndUserId(orderId, userId);
        if (order == null) {
            throw new BusinessException(40421, HttpStatus.NOT_FOUND, "订单不存在");
        }
        return order;
    }

    private List<Long> distinctIds(List<Long> ids) {
        return new ArrayList<>(new LinkedHashSet<>(ids));
    }

    private String generatePickupCode() {
        return String.format("%06d", RANDOM.nextInt(1_000_000));
    }

    private OrderSubmitResponse toSubmitResponse(Order order, boolean idempotent) {
        OrderSubmitResponse response = new OrderSubmitResponse();
        response.setOrderId(order.getId());
        response.setOrderSn(order.getOrderSn());
        response.setStatus(order.getStatus());
        response.setStatusText(statusText(order.getStatus()));
        response.setTotalAmount(zeroIfNull(order.getTotalAmount()));
        response.setSeckillDiscount(zeroIfNull(order.getSeckillDiscount()));
        response.setBargainDiscount(zeroIfNull(order.getBargainDiscount()));
        response.setPromotionDiscount(zeroIfNull(order.getPromotionDiscount()));
        response.setMerchantCouponDiscount(zeroIfNull(order.getMerchantCouponDiscount()));
        response.setPlatformCouponDiscount(zeroIfNull(order.getCouponDiscount()));
        response.setPointsDeduction(zeroIfNull(order.getPointsDeduction()));
        response.setDeliveryFee(zeroIfNull(order.getDeliveryFee()));
        response.setPayAmount(zeroIfNull(order.getPayAmount()));
        response.setExpireTime(order.getPayExpireTime());
        response.setIdempotent(idempotent ? Boolean.TRUE : null);
        return response;
    }

    private int value(Integer number) {
        return number == null ? 0 : number;
    }

    private BigDecimal zeroIfNull(BigDecimal value) {
        return value == null ? ZERO : value;
    }

    private BusinessException cartItemNotFound() {
        return new BusinessException(40411, HttpStatus.NOT_FOUND, "购物车商品不存在");
    }

    private BusinessException inventoryInsufficient(Long skuId, Integer stock) {
        return new BusinessException(
                40912, HttpStatus.CONFLICT, "库存不足",
                java.util.Map.of("skuId", skuId, "availableStock", stock == null ? 0 : stock)
        );
    }

    private BusinessException invalidOrderStatus(String message) {
        return new BusinessException(40921, HttpStatus.CONFLICT, message);
    }

    public static String statusText(Integer status) {
        return OrderStatus.userStatusCode(status);
    }

    private record CartContext(List<CartItemVO> items, Long merchantId, BigDecimal totalAmount) {
    }

    private record Fulfillment(Address address, PickupPoint pickupPoint) {
    }
}
