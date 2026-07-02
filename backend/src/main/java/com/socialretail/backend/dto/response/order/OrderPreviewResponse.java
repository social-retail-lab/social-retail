package com.socialretail.backend.dto.response.order;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class OrderPreviewResponse {
    private List<OrderItemResponse> itemList;
    private BigDecimal totalAmount;
    private BigDecimal discountAmount;
    private BigDecimal payAmount;
    private BigDecimal deliveryFee;
    private BigDecimal seckillDiscount;
    private BigDecimal bargainDiscount;
    private BigDecimal promotionDiscount;
    private BigDecimal couponDiscount;
    private BigDecimal pointsDeduction;
    private OrderAddressInfoResponse addressInfo;
    private OrderPickupPointInfoResponse pickupPointInfo;
    private List<Object> availablePromotions;
    private List<Object> availableCoupons;
    private Object promotionSnapshot;
}
