package com.socialretail.backend.service.order.pricing;

import com.socialretail.backend.vo.CartItemVO;
import com.socialretail.backend.vo.PointsInfoVO;
import com.socialretail.backend.service.member.PointsCalculationService;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Service
public class DefaultOrderPricingService implements OrderPricingService {

    private static final BigDecimal ZERO = new BigDecimal("0.00");
    private final PointsCalculationService pointsCalculationService;
    private final PlatformCouponPricingService platformCouponPricingService;
    private final MerchantCouponPricingService merchantCouponPricingService;
    private final SeckillOrderPricingService seckillOrderPricingService;
    private final BargainOrderPricingService bargainOrderPricingService;
    private final PromotionPricingService promotionPricingService;

    public DefaultOrderPricingService(PointsCalculationService pointsCalculationService,
                                      PlatformCouponPricingService platformCouponPricingService,
                                      MerchantCouponPricingService merchantCouponPricingService,
                                      SeckillOrderPricingService seckillOrderPricingService,
                                      BargainOrderPricingService bargainOrderPricingService,
                                      PromotionPricingService promotionPricingService) {
        this.pointsCalculationService = pointsCalculationService;
        this.platformCouponPricingService = platformCouponPricingService;
        this.merchantCouponPricingService = merchantCouponPricingService;
        this.seckillOrderPricingService = seckillOrderPricingService;
        this.bargainOrderPricingService = bargainOrderPricingService;
        this.promotionPricingService = promotionPricingService;
    }

    @Override
    public OrderPricingResult calculate(OrderPricingCommand command) {
        Map<Long, OrderItemPrice> itemPrices = new LinkedHashMap<>();
        BigDecimal originalAmount = ZERO;
        for (CartItemVO item : command.items()) {
            BigDecimal price = item.getOriginalPrice() != null
                    ? item.getOriginalPrice() : item.getPrice() == null ? ZERO : item.getPrice();
            int quantity = item.getQuantity() == null ? 0 : item.getQuantity();
            BigDecimal amount = price.multiply(BigDecimal.valueOf(quantity));
            originalAmount = originalAmount.add(amount);
            itemPrices.put(item.getCartId(), new OrderItemPrice(
                    price, price, amount, amount, "NORMAL"
            ));
        }

        boolean autoSelectAll = Boolean.TRUE.equals(command.autoSelectBenefits());
        boolean autoSelectActivities = autoSelectAll
                || (Boolean.TRUE.equals(command.allowAutoSelectActivities())
                && isEmpty(command.activityContext()));
        Long requestedSeckillProductId = command.activityContext() == null
                ? null : command.activityContext().getSeckillProductId();
        SeckillOrderPricingService.Quote seckill = autoSelectActivities
                ? seckillOrderPricingService.quoteBest(command.userId(), command.items())
                : seckillOrderPricingService.quote(command.userId(), requestedSeckillProductId, command.items());
        if (seckill.applied()) {
            command.items().stream().filter(item -> seckill.skuId().equals(item.getSkuId()))
                    .findFirst().ifPresent(item -> itemPrices.put(item.getCartId(), new OrderItemPrice(
                            seckill.originPrice(), seckill.finalPrice(), seckill.originAmount(),
                            seckill.finalAmount(), "SECKILL")));
        }

        Long requestedBargainRecordId = command.activityContext() == null
                ? null : command.activityContext().getBargainRecordId();
        BargainOrderPricingService.Quote bargain = bargainOrderPricingService.quote(
                command.userId(), requestedBargainRecordId, command.items(),
                autoSelectActivities && !seckill.applied());
        if (seckill.applied() && bargain.applied() && seckill.skuId().equals(bargain.skuId())) {
            throw new com.socialretail.backend.common.exception.BusinessException(40918,
                    org.springframework.http.HttpStatus.CONFLICT, "同一商品不能同时使用秒杀和砍价优惠");
        }
        if (bargain.applied()) {
            command.items().stream().filter(item -> bargain.skuId().equals(item.getSkuId()))
                    .findFirst().ifPresent(item -> itemPrices.put(item.getCartId(), new OrderItemPrice(
                            bargain.originPrice(), bargain.finalPrice(), bargain.originAmount(),
                            bargain.finalAmount(), "BARGAIN")));
        }

        BigDecimal activityDiscountedAmount = originalAmount.subtract(seckill.discount())
                .subtract(bargain.discount()).max(BigDecimal.ZERO);
        List<Long> requestedPromotionIds = command.activityContext() == null
                ? List.of() : command.activityContext().getPromotionIds();
        PromotionPricingService.Pricing promotionPricing = promotionPricingService.resolve(
                command.merchantId(), activityDiscountedAmount, requestedPromotionIds,
                autoSelectActivities);
        BigDecimal discountedGoodsAmount = activityDiscountedAmount.subtract(promotionPricing.discount())
                .max(BigDecimal.ZERO);
        boolean usePlatformCoupon = autoSelectAll || Boolean.TRUE.equals(command.usePlatformCoupon());
        boolean useMerchantCoupon = autoSelectAll || Boolean.TRUE.equals(command.useMerchantCoupon());
        PlatformCouponPricingService.Pricing couponPricing = platformCouponPricingService.resolve(
                command.userId(), command.platformCouponUserId(), discountedGoodsAmount,
                usePlatformCoupon, autoSelectAll || command.platformCouponUserId() == null);
        MerchantCouponPricingService.Pricing merchantCouponPricing = merchantCouponPricingService.resolve(
                command.userId(), command.merchantId(), command.merchantCouponUserId(), discountedGoodsAmount,
                useMerchantCoupon, autoSelectAll || command.merchantCouponUserId() == null);
        BigDecimal merchantCouponDiscount = merchantCouponPricing.discount().min(discountedGoodsAmount);
        BigDecimal platformCouponDiscount = couponPricing.discount()
                .min(discountedGoodsAmount.subtract(merchantCouponDiscount).max(BigDecimal.ZERO));
        if (merchantCouponPricing.selected() != null) {
            merchantCouponPricing.selected().setDiscountAmount(merchantCouponDiscount);
        }
        if (couponPricing.selected() != null) {
            couponPricing.selected().setDiscountAmount(platformCouponDiscount);
        }
        BigDecimal pointsBaseAmount = discountedGoodsAmount.subtract(platformCouponDiscount)
                .subtract(merchantCouponDiscount).max(BigDecimal.ZERO);
        PointsInfoVO pointsInfo = Boolean.TRUE.equals(command.autoSelectBenefits())
                ? pointsCalculationService.calculateDefault(command.userId(), pointsBaseAmount)
                : pointsCalculationService.calculate(command.userId(), pointsBaseAmount,
                        command.usePoints(), command.usePointsAmount());
        BigDecimal pointsDeduction = pointsInfo.getDeductionAmount();
        BigDecimal payableAmount = discountedGoodsAmount.subtract(platformCouponDiscount)
                .subtract(merchantCouponDiscount)
                .subtract(pointsDeduction).max(BigDecimal.ZERO);

        return new OrderPricingResult(
                originalAmount,
                seckill.discount().add(bargain.discount()).add(promotionPricing.discount())
                        .add(platformCouponDiscount).add(merchantCouponDiscount).add(pointsDeduction),
                ZERO,
                payableAmount,
                seckill.discount(),
                bargain.discount(),
                promotionPricing.discount(),
                platformCouponDiscount,
                merchantCouponDiscount,
                pointsDeduction,
                couponPricing.couponUserId(),
                merchantCouponPricing.couponUserId(),
                seckill.seckillProductId(),
                bargain.recordId(),
                promotionPricing.appliedIds(),
                null,
                itemPrices,
                promotionPricing.available(),
                List.of(),
                pointsInfo,
                couponPricing.selected(),
                couponPricing.available(),
                merchantCouponPricing.selected(),
                merchantCouponPricing.available()
        );
    }

    private boolean isEmpty(com.socialretail.backend.dto.request.order.OrderActivityContextRequest context) {
        return context == null
                || (context.getSeckillProductId() == null
                && context.getBargainRecordId() == null
                && context.getGroupId() == null
                && (context.getPromotionIds() == null || context.getPromotionIds().isEmpty()));
    }
}
