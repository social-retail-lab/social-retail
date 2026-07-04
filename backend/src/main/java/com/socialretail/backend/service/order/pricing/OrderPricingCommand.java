package com.socialretail.backend.service.order.pricing;

import com.socialretail.backend.dto.request.order.OrderActivityContextRequest;
import com.socialretail.backend.vo.CartItemVO;

import java.util.List;

public record OrderPricingCommand(
        Long userId,
        Long merchantId,
        List<CartItemVO> items,
        Boolean usePlatformCoupon,
        Long platformCouponUserId,
        Boolean useMerchantCoupon,
        Long merchantCouponUserId,
        Boolean usePoints,
        Integer usePointsAmount,
        OrderActivityContextRequest activityContext,
        Boolean autoSelectBenefits,
        Boolean allowAutoSelectActivities
) {
}
