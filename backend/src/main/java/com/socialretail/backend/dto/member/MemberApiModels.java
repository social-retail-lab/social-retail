package com.socialretail.backend.dto.member;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;

import java.math.BigDecimal;
import java.util.List;

public final class MemberApiModels {
    private MemberApiModels() { }

    public record Benefit(String benefitCode, String benefitName, String description) { }
    public record NextLevel(Integer memberLevel, String memberLevelName,
                            Integer requiredGrowthValue, Integer needGrowthValue) { }
    public record MemberInfo(Long userId, Integer memberLevel, String memberLevelName,
                             Integer pointsBalance, Integer growthValue, NextLevel nextLevel,
                             List<Benefit> benefits) { }
    public record LevelRule(Integer memberLevel, String memberLevelName,
                            Integer requiredGrowthValue, String description,
                            List<Benefit> benefits) { }
    public record LevelList(Integer currentLevel, String currentLevelName,
                            Integer growthValue, List<LevelRule> list) { }
    public record UpgradeResult(Integer updatedCount) { }
    public record Balance(Long userId, Integer pointsBalance) { }
    public record PointsLogItem(Long logId, Integer type, String typeText,
                                Integer changePoints, Integer currentPoints,
                                String remark, String createTime) { }
    public record GrowthLogItem(Long logId, Integer type, String typeText,
                                Integer changeGrowth, Integer currentGrowth,
                                String remark, String createTime) { }
    public record PageData<T>(List<T> list, Long total, Long pages,
                              Integer page, Integer pageSize) { }
    public record Deduction(Integer pointsBalance, Integer usePoints,
                            BigDecimal deductionAmount, BigDecimal payAmountAfterDeduction,
                            String deductionRule) { }
    public record Exchange(Long couponUserId, Long couponId, String couponTitle,
                           Integer usePoints, Integer currentPoints, String receiveTime,
                           String validStart, String validEnd) { }
    public record SignIn(Long userId, Integer rewardPoints, Integer currentPoints,
                         String signInDate) { }
    public record SignInStatus(Long userId, Boolean signedIn, String signInDate,
                               Integer rewardPoints, String buttonText) { }

    public record DeductionRequest(
            @NotNull(message = "订单金额不能为空")
            @DecimalMin(value = "0.01", message = "订单金额必须大于0") BigDecimal orderAmount,
            @NotNull(message = "使用积分不能为空")
            @Positive(message = "使用积分必须大于0") Integer usePoints) { }
    public record ExchangeRequest(
            @NotNull(message = "优惠券ID不能为空")
            @Positive(message = "优惠券ID必须大于0") Long couponId,
            @NotNull(message = "使用积分不能为空")
            @Positive(message = "使用积分必须大于0") Integer usePoints) { }
    public record UpgradeRequest(@Positive(message = "用户ID必须大于0") Long userId) { }
}
