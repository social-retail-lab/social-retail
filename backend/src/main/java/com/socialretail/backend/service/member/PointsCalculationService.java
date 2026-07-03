package com.socialretail.backend.service.member;

import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.socialretail.backend.common.exception.BusinessException;
import com.socialretail.backend.entity.member.Member;
import com.socialretail.backend.mapper.member.MemberMapper;
import com.socialretail.backend.vo.PointsInfoVO;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.Map;

@Service
public class PointsCalculationService {
    private static final BigDecimal MAX_DEDUCTION_RATE = new BigDecimal("0.10");
    private static final BigDecimal POINTS_PER_YUAN = new BigDecimal("100");
    private static final BigDecimal ZERO = new BigDecimal("0.00");
    private final MemberMapper memberMapper;

    public PointsCalculationService(MemberMapper memberMapper) {
        this.memberMapper = memberMapper;
    }

    public PointsInfoVO calculate(Long userId, BigDecimal discountedGoodsAmount,
                                  Boolean usePoints, Integer requestedPoints) {
        Member member = memberMapper.selectOne(Wrappers.<Member>lambdaQuery()
                .eq(Member::getUserId, userId).last("LIMIT 1"));
        int balance = member == null || member.getPointsBalance() == null
                ? 0 : Math.max(0, member.getPointsBalance());
        BigDecimal goodsAmount = discountedGoodsAmount == null
                ? ZERO : discountedGoodsAmount.max(BigDecimal.ZERO);
        BigDecimal maxDeduction = goodsAmount.multiply(MAX_DEDUCTION_RATE)
                .setScale(2, RoundingMode.DOWN);
        int amountLimitedPoints = maxDeduction.multiply(POINTS_PER_YUAN)
                .setScale(0, RoundingMode.DOWN).intValue();
        int maxUsablePoints = Math.min(balance, amountLimitedPoints);
        boolean canUse = maxUsablePoints > 0;

        int usedPoints = 0;
        if (Boolean.TRUE.equals(usePoints)) {
            if (requestedPoints != null && requestedPoints > balance) {
                throw new BusinessException(40951, HttpStatus.CONFLICT, "积分余额不足",
                        Map.of("pointsBalance", balance, "usePoints", requestedPoints));
            }
            usedPoints = requestedPoints == null ? maxUsablePoints : requestedPoints;
            if (usedPoints > amountLimitedPoints) {
                BigDecimal deduction = pointsToAmount(usedPoints);
                throw new BusinessException(40952, HttpStatus.CONFLICT,
                        "积分抵扣金额超过订单可抵扣上限",
                        Map.of("maxDeductionAmount", maxDeduction, "deductionAmount", deduction));
            }
        }
        BigDecimal deduction = pointsToAmount(usedPoints);
        return new PointsInfoVO(balance, canUse, maxUsablePoints, usedPoints,
                deduction, "100积分抵扣1元", maxDeduction);
    }

    private BigDecimal pointsToAmount(int points) {
        return BigDecimal.valueOf(points).divide(POINTS_PER_YUAN, 2, RoundingMode.DOWN);
    }
}
