package com.socialretail.backend.dto.response.order;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;
import com.socialretail.backend.vo.PromotionActivityInfoVO;
import com.socialretail.backend.vo.CouponBundleVO;
import com.socialretail.backend.vo.AvailableCouponGroupsVO;
import com.socialretail.backend.vo.CartPromotionDetailVO;
import com.socialretail.backend.vo.PointsInfoVO;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class OrderPreviewResponse {
    private String previewToken;
    private Long previewExpireSeconds;
    private List<OrderItemResponse> itemList;
    private OrderPreviewPriceDetailResponse priceDetail;
    private PointsInfoVO pointsInfo;
    private List<CartPromotionDetailVO> promotionDetail;
    private OrderAddressInfoResponse addressInfo;
    private OrderPickupPointInfoResponse pickupPointInfo;
    private CouponBundleVO couponInfo;
    private PromotionActivityInfoVO activityInfo;
    private List<Object> availablePromotions;
    private AvailableCouponGroupsVO availableCoupons;
}
