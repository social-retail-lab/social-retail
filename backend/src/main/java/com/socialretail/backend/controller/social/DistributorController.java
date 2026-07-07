package com.socialretail.backend.controller.social;

import com.socialretail.backend.common.PageResult;
import com.socialretail.backend.common.result.Result;
import com.socialretail.backend.config.JwtInterceptor;
import com.socialretail.backend.dto.request.social.DistributorApplyRequest;
import com.socialretail.backend.dto.request.social.DistributorWithdrawRequest;
import com.socialretail.backend.dto.request.social.ShareLinkRequest;
import com.socialretail.backend.dto.response.social.DistributorResponses;
import com.socialretail.backend.service.social.CommissionService;
import com.socialretail.backend.service.social.DistributorService;
import jakarta.validation.Valid;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.Positive;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.RequestAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@Validated
@RestController
@RequestMapping("/api/distributor")
public class DistributorController {
    private final DistributorService distributorService;
    private final CommissionService commissionService;

    public DistributorController(DistributorService distributorService,
                                 CommissionService commissionService) {
        this.distributorService = distributorService;
        this.commissionService = commissionService;
    }

    @PostMapping("/apply")
    public Result<DistributorResponses.Apply> apply(
            @RequestAttribute(JwtInterceptor.USER_ID_ATTRIBUTE) Long userId,
            @Valid @RequestBody DistributorApplyRequest request) {
        return Result.success("申请成功", distributorService.apply(userId, request));
    }

    @GetMapping("/status")
    public Result<DistributorResponses.Status> status(
            @RequestAttribute(JwtInterceptor.USER_ID_ATTRIBUTE) Long userId) {
        return Result.success(distributorService.status(userId));
    }

    @GetMapping("/dashboard")
    public Result<DistributorResponses.Dashboard> dashboard(
            @RequestAttribute(JwtInterceptor.USER_ID_ATTRIBUTE) Long userId) {
        return Result.success(distributorService.dashboard(userId));
    }

    @GetMapping("/products")
    public Result<PageResult<DistributorResponses.AvailableProduct>> products(
            @RequestAttribute(JwtInterceptor.USER_ID_ATTRIBUTE) Long userId,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) @Positive Long merchantId,
            @RequestParam(defaultValue = "1") @Min(1) int page,
            @RequestParam(defaultValue = "10") @Min(1) @Max(100) int pageSize) {
        return Result.success(distributorService.products(userId, keyword, merchantId, page, pageSize));
    }

    @PostMapping("/products/{distributionProductId}/promote")
    public Result<DistributorResponses.Promote> promote(
            @RequestAttribute(JwtInterceptor.USER_ID_ATTRIBUTE) Long userId,
            @PathVariable @Positive Long distributionProductId) {
        return Result.success("申请成功", distributorService.promote(userId, distributionProductId));
    }

    @PostMapping("/share-link")
    public Result<DistributorResponses.ShareLink> shareLink(
            @RequestAttribute(JwtInterceptor.USER_ID_ATTRIBUTE) Long userId,
            @Valid @RequestBody ShareLinkRequest request) {
        return Result.success(distributorService.shareLink(userId, request.distributorProductId()));
    }

    @GetMapping("/my-products")
    public Result<PageResult<DistributorResponses.MyProduct>> myProducts(
            @RequestAttribute(JwtInterceptor.USER_ID_ATTRIBUTE) Long userId,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) @Min(0) @Max(1) Integer status,
            @RequestParam(defaultValue = "1") @Min(1) int page,
            @RequestParam(defaultValue = "10") @Min(1) @Max(100) int pageSize) {
        return Result.success(distributorService.myProducts(userId, keyword, status, page, pageSize));
    }

    @GetMapping("/my-products/{distributorProductId}")
    public Result<DistributorResponses.MyProductDetail> myProductDetail(
            @RequestAttribute(JwtInterceptor.USER_ID_ATTRIBUTE) Long userId,
            @PathVariable @Positive Long distributorProductId) {
        return Result.success(distributorService.myProductDetail(userId, distributorProductId));
    }

    @PatchMapping("/my-products/{distributorProductId}/disable")
    public Result<DistributorResponses.PromotionStatus> disablePromotion(
            @RequestAttribute(JwtInterceptor.USER_ID_ATTRIBUTE) Long userId,
            @PathVariable @Positive Long distributorProductId) {
        return Result.success("取消推广成功",
                distributorService.disablePromotion(userId, distributorProductId));
    }

    @PatchMapping("/my-products/{distributorProductId}/enable")
    public Result<DistributorResponses.PromotionStatus> enablePromotion(
            @RequestAttribute(JwtInterceptor.USER_ID_ATTRIBUTE) Long userId,
            @PathVariable @Positive Long distributorProductId) {
        return Result.success("恢复推广成功",
                distributorService.enablePromotion(userId, distributorProductId));
    }

    @GetMapping("/orders")
    public Result<PageResult<DistributorResponses.PromotionOrder>> orders(
            @RequestAttribute(JwtInterceptor.USER_ID_ATTRIBUTE) Long userId,
            @RequestParam(required = false) @Min(0) @Max(1) Integer status,
            @RequestParam(required = false) String keyword,
            @RequestParam(defaultValue = "1") @Min(1) int page,
            @RequestParam(defaultValue = "10") @Min(1) @Max(100) int pageSize) {
        return Result.success(commissionService.orders(userId, status, keyword, page, pageSize));
    }

    @GetMapping("/commission/detail")
    public Result<DistributorResponses.SimplePage<DistributorResponses.CommissionDetail>> details(
            @RequestAttribute(JwtInterceptor.USER_ID_ATTRIBUTE) Long userId,
            @RequestParam(required = false) @Min(0) @Max(1) Integer status,
            @RequestParam(defaultValue = "1") @Min(1) int page,
            @RequestParam(defaultValue = "10") @Min(1) @Max(100) int size) {
        return Result.success(commissionService.details(userId, status, page, size));
    }

    @PostMapping("/withdraw/apply")
    public Result<DistributorResponses.Withdraw> withdraw(
            @RequestAttribute(JwtInterceptor.USER_ID_ATTRIBUTE) Long userId,
            @Valid @RequestBody DistributorWithdrawRequest request) {
        return Result.success("提现申请成功", commissionService.withdraw(userId, request));
    }

    @GetMapping("/withdraw/records")
    public Result<DistributorResponses.SimplePage<DistributorResponses.WithdrawRecord>> withdrawRecords(
            @RequestAttribute(JwtInterceptor.USER_ID_ATTRIBUTE) Long userId,
            @RequestParam(required = false) @Min(0) @Max(2) Integer status,
            @RequestParam(defaultValue = "1") @Min(1) int page,
            @RequestParam(defaultValue = "10") @Min(1) @Max(100) int size) {
        return Result.success(commissionService.withdrawRecords(userId, status, page, size));
    }
}
