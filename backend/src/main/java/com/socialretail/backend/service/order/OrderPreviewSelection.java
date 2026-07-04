package com.socialretail.backend.service.order;

import com.socialretail.backend.dto.request.order.OrderActivityContextRequest;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class OrderPreviewSelection {
    private List<Long> cartItemIds;
    private Integer deliveryType;
    private Long addressId;
    private Long pickupPointId;
    private Long platformCouponUserId;
    private Long merchantCouponUserId;
    private Integer usePointsAmount;
    private OrderActivityContextRequest activityContext;
    private String remark;
}
