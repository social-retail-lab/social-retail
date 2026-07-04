package com.socialretail.backend.dto.response.order;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import com.socialretail.backend.vo.CouponBundleVO;
import com.socialretail.backend.vo.CartPromotionDetailVO;

@Data
public class OrderDetailResponse {
    private Long orderId;
    private String orderSn;
    private String status;
    private String statusText;
    private String deliveryType;
    private BigDecimal totalAmount;
    private BigDecimal discountAmount;
    private BigDecimal deliveryFee;
    private BigDecimal payAmount;
    private OrderPreviewPriceDetailResponse priceDetail;
    private List<CartPromotionDetailVO> promotionDetail;
    private CouponBundleVO couponInfo;
    private OrderPointsInfoResponse pointsInfo;
    private OrderReceiverInfoResponse receiverInfo;
    private OrderPickupPointInfoResponse pickupPointInfo;
    private OrderPaymentInfoResponse paymentInfo;
    private OrderDeliveryInfoResponse deliveryInfo;
    private List<OrderItemResponse> itemList;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    private LocalDateTime createTime;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    private LocalDateTime payExpireTime;
}
