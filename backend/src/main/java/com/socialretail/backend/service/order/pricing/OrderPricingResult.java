package com.socialretail.backend.service.order.pricing;

import lombok.AllArgsConstructor;
import lombok.Data;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;
import com.socialretail.backend.vo.PointsInfoVO;
import com.socialretail.backend.vo.CouponOptionVO;

@Data
@AllArgsConstructor
public class OrderPricingResult {
    private BigDecimal originalAmount;
    private BigDecimal discountAmount;
    private BigDecimal deliveryFee;
    private BigDecimal payableAmount;
    private BigDecimal seckillDiscount;
    private BigDecimal bargainDiscount;
    private BigDecimal promotionDiscount;
    private BigDecimal couponDiscount;
    private BigDecimal merchantCouponDiscount;
    private BigDecimal pointsDeduction;
    private Long appliedCouponUserId;
    private Long appliedMerchantCouponUserId;
    private Long appliedSeckillId;
    private Long appliedBargainId;
    private List<Long> appliedPromotionIds;
    private String promotionSnapshot;
    private Map<Long, OrderItemPrice> itemPrices;
    private List<Object> availablePromotions;
    private List<Object> availableCoupons;
    private PointsInfoVO pointsInfo;
    private CouponOptionVO platformCoupon;
    private List<CouponOptionVO> availablePlatformCoupons;
    private CouponOptionVO merchantCoupon;
    private List<CouponOptionVO> availableMerchantCoupons;
}
