package com.socialretail.backend.controller.promotion;

import com.socialretail.backend.common.result.Result;
import com.socialretail.backend.config.JwtInterceptor;
import com.socialretail.backend.dto.promotion.PromotionApiModels.MyCouponPage;
import com.socialretail.backend.service.promotion.CouponQueryService;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.Positive;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@Validated
@RestController
@RequestMapping("/api/coupons")
public class CouponController {
    private final CouponQueryService couponQueryService;

    public CouponController(CouponQueryService couponQueryService) {
        this.couponQueryService = couponQueryService;
    }

    @GetMapping("/my")
    public Result<MyCouponPage> myCoupons(
            @RequestAttribute(JwtInterceptor.USER_ID_ATTRIBUTE) Long userId,
            @RequestParam(required = false) String source,
            @Min(value = 0, message = "status只能为0、1或2")
            @Max(value = 2, message = "status只能为0、1或2")
            @RequestParam(required = false) Integer status,
            @Positive(message = "merchantId必须大于0") @RequestParam(required = false) Long merchantId,
            @Min(value = 1, message = "page必须大于0") @RequestParam(defaultValue = "1") int page,
            @Min(value = 1, message = "pageSize必须大于0")
            @Max(value = 100, message = "pageSize不能超过100")
            @RequestParam(defaultValue = "10") int pageSize) {
        return Result.success(couponQueryService.myCoupons(
                userId, source, status, merchantId, page, pageSize));
    }
}
