package com.socialretail.backend.controller.promotion;

import com.socialretail.backend.common.result.Result;
import com.socialretail.backend.config.JwtInterceptor;
import com.socialretail.backend.dto.promotion.PromotionApiModels.AvailableCouponResponse;
import com.socialretail.backend.dto.request.promotion.AvailableCouponRequest;
import com.socialretail.backend.service.promotion.CouponQueryService;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/orders")
public class OrderCouponController {
    private final CouponQueryService couponQueryService;

    public OrderCouponController(CouponQueryService couponQueryService) {
        this.couponQueryService = couponQueryService;
    }

    @PostMapping("/available-coupons")
    public Result<AvailableCouponResponse> availableCoupons(
            @RequestAttribute(JwtInterceptor.USER_ID_ATTRIBUTE) Long userId,
            @Valid @RequestBody AvailableCouponRequest request) {
        return Result.success(couponQueryService.availableCoupons(userId, request.getCartItemIds()));
    }
}
