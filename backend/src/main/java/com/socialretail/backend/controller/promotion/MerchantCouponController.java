package com.socialretail.backend.controller.promotion;

import com.socialretail.backend.common.result.Result;
import com.socialretail.backend.config.JwtInterceptor;
import com.socialretail.backend.dto.promotion.PromotionApiModels.MerchantCouponPage;
import com.socialretail.backend.dto.promotion.PromotionApiModels.MerchantCouponReceive;
import com.socialretail.backend.service.promotion.CustomerMerchantCouponService;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.Size;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestAttribute;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@Validated
@RestController
@RequestMapping("/api")
public class MerchantCouponController {
    private final CustomerMerchantCouponService merchantCouponService;

    public MerchantCouponController(CustomerMerchantCouponService merchantCouponService) {
        this.merchantCouponService = merchantCouponService;
    }

    @GetMapping("/merchants/{merchantId}/coupons")
    public Result<MerchantCouponPage> list(
            @RequestAttribute(JwtInterceptor.USER_ID_ATTRIBUTE) Long userId,
            @Positive(message = "merchantId必须大于0") @PathVariable Long merchantId,
            @Min(value = 1, message = "page必须大于0") @RequestParam(defaultValue = "1") int page,
            @Min(value = 1, message = "pageSize必须大于0")
            @Max(value = 100, message = "pageSize不能超过100")
            @RequestParam(defaultValue = "10") int pageSize) {
        return Result.success(merchantCouponService.list(userId, merchantId, page, pageSize));
    }

    @PostMapping("/merchant-coupons/{couponId}/receive")
    public Result<MerchantCouponReceive> receive(
            @RequestAttribute(JwtInterceptor.USER_ID_ATTRIBUTE) Long userId,
            @Positive(message = "couponId必须大于0") @PathVariable Long couponId,
            @NotBlank(message = "X-Idempotent-Key不能为空")
            @Size(max = 100, message = "X-Idempotent-Key不能超过100个字符")
            @RequestHeader("X-Idempotent-Key") String idempotentKey) {
        return Result.success("领取成功",
                merchantCouponService.receive(userId, couponId, idempotentKey.trim()));
    }
}
