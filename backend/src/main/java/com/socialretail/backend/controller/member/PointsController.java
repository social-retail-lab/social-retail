package com.socialretail.backend.controller.member;

import com.socialretail.backend.common.result.Result;
import com.socialretail.backend.config.JwtInterceptor;
import com.socialretail.backend.dto.member.MemberApiModels.*;
import com.socialretail.backend.service.member.PointsService;
import jakarta.validation.Valid;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

@Validated
@RestController
@RequestMapping("/api/points")
public class PointsController {
    private final PointsService pointsService;
    public PointsController(PointsService pointsService) { this.pointsService = pointsService; }

    @GetMapping("/balance")
    public Result<Balance> balance(@RequestAttribute(JwtInterceptor.USER_ID_ATTRIBUTE) Long userId) {
        return Result.success(pointsService.getBalance(userId));
    }

    @GetMapping("/logs")
    public Result<PageData<PointsLogItem>> logs(
            @RequestAttribute(JwtInterceptor.USER_ID_ATTRIBUTE) Long userId,
            @RequestParam(required = false) Integer type,
            @RequestParam(defaultValue = "1") @Min(1) Integer page,
            @RequestParam(defaultValue = "10") @Min(1) @Max(100) Integer pageSize) {
        return Result.success(pointsService.listLogs(userId, type, page, pageSize));
    }

    @PostMapping("/calculate-deduction")
    public Result<Deduction> calculate(@RequestAttribute(JwtInterceptor.USER_ID_ATTRIBUTE) Long userId,
                                       @Valid @RequestBody DeductionRequest request) {
        return Result.success(pointsService.calculateDeduction(userId, request));
    }

    @PostMapping("/exchange/coupon")
    public Result<Exchange> exchange(@RequestAttribute(JwtInterceptor.USER_ID_ATTRIBUTE) Long userId,
                                     @Valid @RequestBody ExchangeRequest request) {
        return Result.success("兑换成功", pointsService.exchangeCoupon(userId, request));
    }

    @PostMapping("/sign-in")
    public Result<SignIn> signIn(@RequestAttribute(JwtInterceptor.USER_ID_ATTRIBUTE) Long userId) {
        return Result.success("签到成功", pointsService.signIn(userId));
    }

    @GetMapping("/sign-in/status")
    public Result<SignInStatus> signInStatus(@RequestAttribute(JwtInterceptor.USER_ID_ATTRIBUTE) Long userId) {
        return Result.success(pointsService.getSignInStatus(userId));
    }
}
