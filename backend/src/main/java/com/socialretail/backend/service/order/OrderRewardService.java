package com.socialretail.backend.service.order;

import com.socialretail.backend.dto.member.MemberApiModels.LevelRule;
import com.socialretail.backend.entity.member.GrowthLog;
import com.socialretail.backend.entity.member.Member;
import com.socialretail.backend.entity.member.PointsLog;
import com.socialretail.backend.entity.order.Order;
import com.socialretail.backend.mapper.member.GrowthLogMapper;
import com.socialretail.backend.mapper.member.MemberMapper;
import com.socialretail.backend.mapper.member.PointsLogMapper;
import com.socialretail.backend.service.member.BenefitService;
import com.socialretail.backend.service.member.impl.MemberLevelServiceImpl;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDateTime;
import java.util.Map;

/**
 * Issues the consumption rewards that belong to a successfully paid order.
 * The caller must invoke this in the same transaction as the one-time payment
 * status transition so a repeated payment callback cannot issue rewards twice.
 */
@Service
public class OrderRewardService {
    private static final int CONSUMPTION_REWARD = 1;
    private static final Map<Integer, BigDecimal> POINTS_MULTIPLIERS = Map.of(
            1, new BigDecimal("1.0"),
            2, new BigDecimal("1.2"),
            3, new BigDecimal("1.5"),
            4, new BigDecimal("2.0")
    );

    private final MemberMapper memberMapper;
    private final PointsLogMapper pointsLogMapper;
    private final GrowthLogMapper growthLogMapper;
    private final MemberLevelServiceImpl memberLevelService;
    private final BenefitService benefitService;

    public OrderRewardService(MemberMapper memberMapper,
                              PointsLogMapper pointsLogMapper,
                              GrowthLogMapper growthLogMapper,
                              MemberLevelServiceImpl memberLevelService,
                              BenefitService benefitService) {
        this.memberMapper = memberMapper;
        this.pointsLogMapper = pointsLogMapper;
        this.growthLogMapper = growthLogMapper;
        this.memberLevelService = memberLevelService;
        this.benefitService = benefitService;
    }

    @Transactional
    public void rewardPaidOrder(Order order, LocalDateTime rewardTime) {
        if (order == null || order.getUserId() == null) {
            throw new IllegalArgumentException("支付奖励缺少订单或用户信息");
        }

        BigDecimal paidAmount = order.getPayAmount() == null ? BigDecimal.ZERO : order.getPayAmount();
        if (paidAmount.signum() <= 0) return;

        memberLevelService.getOrCreate(order.getUserId());
        Member member = memberMapper.selectByUserIdForUpdate(order.getUserId());
        if (member == null) throw new IllegalStateException("订单用户会员账户不存在");

        int currentLevel = value(member.getMemberLevel(), 1);
        int growthReward = paidAmount.setScale(0, RoundingMode.DOWN).intValueExact();
        int pointsReward = paidAmount.multiply(pointsMultiplier(currentLevel))
                .setScale(0, RoundingMode.DOWN).intValueExact();
        if (growthReward <= 0 && pointsReward <= 0) return;

        int currentPoints = value(member.getPointsBalance(), 0) + pointsReward;
        int currentGrowth = value(member.getGrowthValue(), 0) + growthReward;
        LevelRule targetRule = benefitService.calculateRule(currentGrowth);

        member.setPointsBalance(currentPoints);
        member.setGrowthValue(currentGrowth);
        member.setMemberLevel(Math.max(currentLevel, targetRule.memberLevel()));
        if (memberMapper.updateById(member) != 1) {
            throw new IllegalStateException("订单支付奖励更新会员账户失败");
        }

        LocalDateTime now = rewardTime == null ? LocalDateTime.now() : rewardTime;
        String orderRemark = "订单支付成功，订单号：" + order.getOrderSn();
        if (pointsReward > 0) {
            PointsLog pointsLog = new PointsLog();
            pointsLog.setUserId(order.getUserId());
            pointsLog.setType(CONSUMPTION_REWARD);
            pointsLog.setChangePoints(pointsReward);
            pointsLog.setCurrentPoints(currentPoints);
            pointsLog.setRemark(orderRemark + "，获得积分");
            pointsLog.setCreateTime(now);
            if (pointsLogMapper.insert(pointsLog) != 1) {
                throw new IllegalStateException("订单消费奖励积分流水写入失败");
            }
        }
        if (growthReward > 0) {
            GrowthLog growthLog = new GrowthLog();
            growthLog.setUserId(order.getUserId());
            growthLog.setType(CONSUMPTION_REWARD);
            growthLog.setChangeGrowth(growthReward);
            growthLog.setCurrentGrowth(currentGrowth);
            growthLog.setRemark(orderRemark + "，获得成长值");
            growthLog.setCreateTime(now);
            if (growthLogMapper.insert(growthLog) != 1) {
                throw new IllegalStateException("订单消费成长值流水写入失败");
            }
        }
    }

    private BigDecimal pointsMultiplier(int memberLevel) {
        return POINTS_MULTIPLIERS.getOrDefault(memberLevel, BigDecimal.ONE);
    }

    private int value(Integer number, int fallback) {
        return number == null ? fallback : number;
    }
}
