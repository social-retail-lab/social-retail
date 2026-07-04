package com.socialretail.backend.controller.promotion;

import com.socialretail.backend.common.result.Result;
import com.socialretail.backend.dto.promotion.PromotionApiModels.DiscountRuleAvailable;
import com.socialretail.backend.service.promotion.DiscountRuleService;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Digits;
import jakarta.validation.constraints.Positive;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.math.BigDecimal;

@Validated
@RestController
@RequestMapping("/api/discount-rules")
public class DiscountRuleController {
    private final DiscountRuleService discountRuleService;

    public DiscountRuleController(DiscountRuleService discountRuleService) {
        this.discountRuleService = discountRuleService;
    }

    @GetMapping("/available")
    public Result<DiscountRuleAvailable> available(
            @DecimalMin(value = "0.00", message = "orderAmount不能小于0")
            @Digits(integer = 10, fraction = 2, message = "orderAmount最多保留2位小数")
            @RequestParam(required = false) BigDecimal orderAmount,
            @Positive(message = "merchantId必须大于0") @RequestParam Long merchantId,
            @RequestParam(required = false) String scene) {
        return Result.success(discountRuleService.available(orderAmount, merchantId, scene));
    }
}
