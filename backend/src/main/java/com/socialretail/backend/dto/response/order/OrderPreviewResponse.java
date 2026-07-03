package com.socialretail.backend.dto.response.order;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;
import com.socialretail.backend.vo.CartActivityInfoVO;
import com.socialretail.backend.vo.CartCouponInfoVO;
import com.socialretail.backend.vo.CartPromotionDetailVO;
import com.socialretail.backend.vo.PointsInfoVO;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class OrderPreviewResponse {
    private List<OrderItemResponse> itemList;
    private OrderPreviewPriceDetailResponse priceDetail;
    private PointsInfoVO pointsInfo;
    private List<CartPromotionDetailVO> promotionDetail;
    private OrderAddressInfoResponse addressInfo;
    private OrderPickupPointInfoResponse pickupPointInfo;
    private CartCouponInfoVO couponInfo;
    private CartActivityInfoVO activityInfo;
    private List<Object> availablePromotions;
    private List<Object> availableCoupons;
    private Object promotionSnapshot;
}
