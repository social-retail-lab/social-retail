package com.socialretail.backend.controller.promotion;

import com.socialretail.backend.common.result.Result;
import com.socialretail.backend.config.JwtInterceptor;
import com.socialretail.backend.dto.promotion.SeckillApiModels.ActivityInfo;
import com.socialretail.backend.dto.promotion.SeckillApiModels.ProductPage;
import com.socialretail.backend.dto.promotion.SeckillApiModels.Qualification;
import com.socialretail.backend.service.promotion.SeckillService;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.Positive;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

@Validated
@RestController
@RequestMapping("/api/seckill")
public class SeckillController {
    private final SeckillService seckillService;
    public SeckillController(SeckillService seckillService) { this.seckillService = seckillService; }

    @GetMapping("/activities/current")
    public Result<ActivityInfo> currentActivity() {
        return Result.success(seckillService.getCurrentActivity());
    }

    @GetMapping("/activities/current/products")
    public Result<ProductPage> currentProducts(
            @RequestParam(defaultValue = "1") @Min(1) Integer page,
            @RequestParam(defaultValue = "10") @Min(1) @Max(100) Integer pageSize) {
        return Result.success(seckillService.getCurrentProducts(page, pageSize));
    }

    @GetMapping("/products/{seckillProductId}/check")
    public Result<Qualification> check(
            @RequestAttribute(JwtInterceptor.USER_ID_ATTRIBUTE) Long userId,
            @PathVariable @Positive Long seckillProductId) {
        return Result.success(seckillService.checkQualification(userId, seckillProductId));
    }
}
