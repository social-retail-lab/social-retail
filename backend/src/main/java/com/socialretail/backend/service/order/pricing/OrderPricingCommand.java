package com.socialretail.backend.service.order.pricing;

import com.socialretail.backend.dto.request.order.OrderActivityContextRequest;
import com.socialretail.backend.vo.CartItemVO;

import java.util.List;

public record OrderPricingCommand(
        Long userId,
        List<CartItemVO> items,
        Long couponUserId,
        Boolean usePoints,
        Integer usePointsAmount,
        OrderActivityContextRequest activityContext
) {
}
