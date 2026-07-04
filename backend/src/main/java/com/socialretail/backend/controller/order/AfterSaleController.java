package com.socialretail.backend.controller.order;

import com.socialretail.backend.common.PageResult;
import com.socialretail.backend.common.result.Result;
import com.socialretail.backend.config.JwtInterceptor;
import com.socialretail.backend.dto.request.aftersale.*;
import com.socialretail.backend.dto.response.aftersale.*;
import com.socialretail.backend.enums.aftersale.AfterSaleStatus;
import com.socialretail.backend.service.aftersale.AfterSaleService;
import jakarta.validation.Valid;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.Positive;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

@Validated
@RestController
@RequestMapping("/api/after-sales")
public class AfterSaleController {
    private final AfterSaleService afterSaleService;

    public AfterSaleController(AfterSaleService afterSaleService) {
        this.afterSaleService = afterSaleService;
    }

    @PostMapping
    public Result<AfterSaleCreateResponse> create(
            @RequestAttribute(JwtInterceptor.USER_ID_ATTRIBUTE) Long userId,
            @Valid @RequestBody AfterSaleCreateRequest request) {
        return Result.success("售后申请提交成功", afterSaleService.createAfterSale(userId, request));
    }

    @GetMapping
    public Result<PageResult<AfterSaleListItemResponse>> list(
            @RequestAttribute(JwtInterceptor.USER_ID_ATTRIBUTE) Long userId,
            @RequestParam(required = false) AfterSaleStatus status,
            @RequestParam(defaultValue = "1") @Min(1) int page,
            @RequestParam(defaultValue = "10") @Min(1) @Max(100) int pageSize) {
        return Result.success(afterSaleService.list(userId, status, page, pageSize));
    }

    @GetMapping("/{afterSaleId}")
    public Result<AfterSaleDetailResponse> detail(
            @RequestAttribute(JwtInterceptor.USER_ID_ATTRIBUTE) Long userId,
            @PathVariable @Positive Long afterSaleId) {
        return Result.success(afterSaleService.detail(userId, afterSaleId));
    }

    @PostMapping("/{afterSaleId}/cancel")
    public Result<AfterSaleStatusResponse> cancel(
            @RequestAttribute(JwtInterceptor.USER_ID_ATTRIBUTE) Long userId,
            @PathVariable @Positive Long afterSaleId,
            @Valid @RequestBody(required = false) AfterSaleCancelRequest request) {
        return Result.success("售后申请已取消", afterSaleService.cancel(userId, afterSaleId, request));
    }

    @PostMapping("/{afterSaleId}/images")
    public Result<AfterSaleImagesResponse> appendImages(
            @RequestAttribute(JwtInterceptor.USER_ID_ATTRIBUTE) Long userId,
            @PathVariable @Positive Long afterSaleId,
            @Valid @RequestBody AfterSaleImagesRequest request) {
        return Result.success("上传成功", afterSaleService.appendImages(userId, afterSaleId, request));
    }
}
