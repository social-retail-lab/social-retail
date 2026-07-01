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
    private List<CartPromotionDetailVO> promotionDetail;
    private CartCouponInfoVO couponInfo;
    private CartActivityInfoVO activityInfo;
    private List<Object> availablePromotions;
    private List<Object> availableCoupons;
    private Integer totalQuantity;
}
