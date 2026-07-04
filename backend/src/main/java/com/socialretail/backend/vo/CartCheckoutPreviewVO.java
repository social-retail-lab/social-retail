package com.socialretail.backend.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CartCheckoutPreviewVO {
    private List<CartCheckoutItemVO> items;
    private CartCheckoutPriceDetailVO priceDetail;
    private CouponBundleVO couponInfo;
    private PointsInfoVO pointsInfo;
    private List<CartPromotionDetailVO> promotionDetail;
    private PromotionActivityInfoVO activityInfo;
    private List<Object> availablePromotions;
    private AvailableCouponGroupsVO availableCoupons;
    private Integer totalQuantity;
}
