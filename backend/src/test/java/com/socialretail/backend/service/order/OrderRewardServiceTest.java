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
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.ArgumentCaptor;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

class OrderRewardServiceTest {
    private MemberMapper memberMapper;
    private PointsLogMapper pointsLogMapper;
    private GrowthLogMapper growthLogMapper;
    private MemberLevelServiceImpl memberLevelService;
    private BenefitService benefitService;
    private OrderRewardService service;

    @BeforeEach
    void setUp() {
        memberMapper = mock(MemberMapper.class);
        pointsLogMapper = mock(PointsLogMapper.class);
        growthLogMapper = mock(GrowthLogMapper.class);
        memberLevelService = mock(MemberLevelServiceImpl.class);
        benefitService = mock(BenefitService.class);
        service = new OrderRewardService(memberMapper, pointsLogMapper, growthLogMapper,
                memberLevelService, benefitService);
        when(memberMapper.updateById(any())).thenReturn(1);
        when(pointsLogMapper.insert(any())).thenReturn(1);
        when(growthLogMapper.insert(any())).thenReturn(1);
    }

    @Test
    void paidOrderUsesCurrentLevelMultiplierAndWritesBothLogs() {
        Member member = member(2, 500, 300);
        when(memberMapper.selectByUserIdForUpdate(1001L)).thenReturn(member);
        when(benefitService.calculateRule(399)).thenReturn(rule(2));

        LocalDateTime paidAt = LocalDateTime.of(2026, 7, 4, 12, 0);
        service.rewardPaidOrder(order("99.80"), paidAt);

        assertEquals(619, member.getPointsBalance());
        assertEquals(399, member.getGrowthValue());
        assertEquals(2, member.getMemberLevel());

        ArgumentCaptor<PointsLog> points = ArgumentCaptor.forClass(PointsLog.class);
        verify(pointsLogMapper).insert(points.capture());
        assertEquals(119, points.getValue().getChangePoints());
        assertEquals(619, points.getValue().getCurrentPoints());
        assertEquals(paidAt, points.getValue().getCreateTime());

        ArgumentCaptor<GrowthLog> growth = ArgumentCaptor.forClass(GrowthLog.class);
        verify(growthLogMapper).insert(growth.capture());
        assertEquals(99, growth.getValue().getChangeGrowth());
        assertEquals(399, growth.getValue().getCurrentGrowth());
    }

    @Test
    void crossingGrowthThresholdUpgradesMemberButUsesPreviousLevelForThisOrder() {
        Member member = member(1, 10, 990);
        when(memberMapper.selectByUserIdForUpdate(1001L)).thenReturn(member);
        when(benefitService.calculateRule(1010)).thenReturn(rule(2));

        service.rewardPaidOrder(order("20.90"), LocalDateTime.now());

        assertEquals(30, member.getPointsBalance());
        assertEquals(1010, member.getGrowthValue());
        assertEquals(2, member.getMemberLevel());
    }

    @Test
    void zeroPaidAmountDoesNotTouchMemberAccount() {
        service.rewardPaidOrder(order("0.00"), LocalDateTime.now());

        verify(memberLevelService, never()).getOrCreate(any());
        verify(memberMapper, never()).updateById(any());
        verify(pointsLogMapper, never()).insert(any());
        verify(growthLogMapper, never()).insert(any());
    }

    private Member member(int level, int points, int growth) {
        Member member = new Member();
        member.setUserId(1001L);
        member.setMemberLevel(level);
        member.setPointsBalance(points);
        member.setGrowthValue(growth);
        return member;
    }

    private Order order(String payAmount) {
        Order order = new Order();
        order.setId(2001L);
        order.setOrderSn("ORD202607040001");
        order.setUserId(1001L);
        order.setPayAmount(new BigDecimal(payAmount));
        return order;
    }

    private LevelRule rule(int level) {
        return new LevelRule(level, "L" + level, level == 1 ? 0 : 1000, "", List.of());
    }
}
