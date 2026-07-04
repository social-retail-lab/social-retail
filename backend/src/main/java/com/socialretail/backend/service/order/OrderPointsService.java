package com.socialretail.backend.service.order;

import com.socialretail.backend.common.exception.BusinessException;
import com.socialretail.backend.entity.member.Member;
import com.socialretail.backend.entity.member.PointsLog;
import com.socialretail.backend.entity.order.Order;
import com.socialretail.backend.mapper.member.MemberMapper;
import com.socialretail.backend.mapper.member.PointsLogMapper;
import com.socialretail.backend.mapper.order.OrderMapper;
import com.socialretail.backend.service.member.impl.MemberLevelServiceImpl;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.Map;

@Service
public class OrderPointsService {
    public static final int NONE = 0;
    public static final int RESERVED = 1;
    public static final int CONSUMED = 2;
    public static final int RELEASED = 3;

    private final MemberMapper memberMapper;
    private final PointsLogMapper pointsLogMapper;
    private final OrderMapper orderMapper;
    private final MemberLevelServiceImpl memberLevelService;

    public OrderPointsService(MemberMapper memberMapper, PointsLogMapper pointsLogMapper,
                              OrderMapper orderMapper, MemberLevelServiceImpl memberLevelService) {
        this.memberMapper = memberMapper;
        this.pointsLogMapper = pointsLogMapper;
        this.orderMapper = orderMapper;
        this.memberLevelService = memberLevelService;
    }

    @Transactional
    public void reserve(Long userId, int points, String orderSn) {
        if (points <= 0) return;
        memberLevelService.getOrCreate(userId);
        Member member = memberMapper.selectByUserIdForUpdate(userId);
        int balance = balance(member);
        if (balance < points) {
            throw new BusinessException(40951, HttpStatus.CONFLICT, "积分余额不足",
                    Map.of("pointsBalance", balance, "usePoints", points));
        }
        member.setPointsBalance(balance - points);
        if (memberMapper.updateById(member) != 1) throw new IllegalStateException("订单积分预占失败");
        insertLog(userId, 2, -points, balance - points,
                "订单创建，积分抵扣，订单号：" + orderSn);
    }

    @Transactional
    public void consume(Order order) {
        int points = usedPoints(order);
        if (points > 0) {
            orderMapper.updatePointsStatus(order.getId(), RESERVED, CONSUMED);
        }
    }

    @Transactional
    public void release(Order order) {
        int points = usedPoints(order);
        if (points <= 0 || orderMapper.updatePointsStatus(order.getId(), RESERVED, RELEASED) != 1) return;
        Member member = memberMapper.selectByUserIdForUpdate(order.getUserId());
        if (member == null) throw new IllegalStateException("订单用户会员账户不存在");
        member.setPointsBalance(balance(member) + points);
        if (memberMapper.updateById(member) != 1) throw new IllegalStateException("订单预占积分释放失败");
        insertLog(order.getUserId(), 5, points, member.getPointsBalance(),
                "订单取消，退回抵扣积分，订单号：" + order.getOrderSn());
    }

    private void insertLog(Long userId, int type, int changePoints, int currentPoints, String remark) {
        PointsLog log = new PointsLog();
        log.setUserId(userId);
        log.setType(type);
        log.setChangePoints(changePoints);
        log.setCurrentPoints(currentPoints);
        log.setRemark(remark);
        log.setCreateTime(LocalDateTime.now());
        if (pointsLogMapper.insert(log) != 1) throw new IllegalStateException("订单积分流水写入失败");
    }

    private int usedPoints(Order order) {
        return order == null || order.getUsedPoints() == null ? 0 : order.getUsedPoints();
    }

    private int balance(Member member) {
        return member == null || member.getPointsBalance() == null ? 0 : member.getPointsBalance();
    }
}
