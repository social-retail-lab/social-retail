package com.socialretail.backend.service.member.impl;

import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.socialretail.backend.common.exception.BusinessException;
import com.socialretail.backend.dto.member.MemberApiModels.*;
import com.socialretail.backend.entity.member.*;
import com.socialretail.backend.mapper.member.*;
import com.socialretail.backend.service.member.PointsService;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;

@Service
public class PointsServiceImpl implements PointsService {
    private static final int SIGN_IN_POINTS = 10;
    private static final int SIGN_IN_TYPE = 3;
    private static final DateTimeFormatter DATE_TIME = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
    private final MemberMapper memberMapper;
    private final PointsLogMapper pointsLogMapper;
    private final CouponMapper couponMapper;
    private final CouponUserMapper couponUserMapper;
    private final MemberLevelServiceImpl memberLevelService;

    public PointsServiceImpl(MemberMapper memberMapper, PointsLogMapper pointsLogMapper,
                             CouponMapper couponMapper, CouponUserMapper couponUserMapper,
                             MemberLevelServiceImpl memberLevelService) {
        this.memberMapper = memberMapper;
        this.pointsLogMapper = pointsLogMapper;
        this.couponMapper = couponMapper;
        this.couponUserMapper = couponUserMapper;
        this.memberLevelService = memberLevelService;
    }

    @Override
    @Transactional
    public Balance getBalance(Long userId) {
        Member member = memberLevelService.getOrCreate(userId);
        return new Balance(userId, points(member));
    }

    @Override
    public PageData<PointsLogItem> listLogs(Long userId, Integer type, int page, int pageSize) {
        Page<PointsLog> result = pointsLogMapper.selectPage(new Page<>(page, pageSize),
                Wrappers.<PointsLog>lambdaQuery().eq(PointsLog::getUserId, userId)
                        .eq(type != null, PointsLog::getType, type)
                        .orderByDesc(PointsLog::getCreateTime, PointsLog::getId));
        List<PointsLogItem> items = result.getRecords().stream().map(log -> new PointsLogItem(
                log.getId(), log.getType(), typeText(log.getType()), log.getChangePoints(),
                log.getCurrentPoints(), log.getRemark(), format(log.getCreateTime()))).toList();
        return new PageData<>(items, result.getTotal(), result.getPages(), page, pageSize);
    }

    @Override
    @Transactional
    public Deduction calculateDeduction(Long userId, DeductionRequest request) {
        int balance = points(memberLevelService.getOrCreate(userId));
        if (balance < request.usePoints()) {
            throw new BusinessException(40951, HttpStatus.CONFLICT, "积分余额不足",
                    Map.of("pointsBalance", balance, "usePoints", request.usePoints()));
        }
        BigDecimal deduction = BigDecimal.valueOf(request.usePoints())
                .divide(BigDecimal.valueOf(100), 2, RoundingMode.DOWN);
        BigDecimal max = request.orderAmount().multiply(new BigDecimal("0.10"))
                .setScale(2, RoundingMode.DOWN);
        if (deduction.compareTo(max) > 0) {
            throw new BusinessException(40952, HttpStatus.CONFLICT, "积分抵扣金额超过订单可抵扣上限",
                    Map.of("orderAmount", request.orderAmount(), "maxDeductionAmount", max,
                            "deductionAmount", deduction));
        }
        return new Deduction(balance, request.usePoints(), deduction,
                request.orderAmount().subtract(deduction).setScale(2, RoundingMode.HALF_UP),
                "100积分抵扣1元");
    }

    @Override
    @Transactional
    public ExchangeCouponPage listExchangeCoupons(Long userId, int page, int pageSize) {
        LocalDateTime now = LocalDateTime.now();
        int balance = points(memberLevelService.getOrCreate(userId));
        Page<Coupon> result = couponMapper.selectPage(new Page<>(page, pageSize),
                Wrappers.<Coupon>lambdaQuery()
                        .eq(Coupon::getType, 1)
                        .eq(Coupon::getStatus, 1)
                        .gt(Coupon::getExchangePoints, 0)
                        .le(Coupon::getValidStart, now)
                        .ge(Coupon::getValidEnd, now)
                        .orderByAsc(Coupon::getExchangePoints, Coupon::getId));
        List<ExchangeCouponItem> items = result.getRecords().stream()
                .map(coupon -> toExchangeCouponItem(userId, balance, coupon)).toList();
        return new ExchangeCouponPage(balance, items, result.getTotal(), result.getPages(), page, pageSize);
    }

    @Override
    @Transactional
    public Exchange exchangeCoupon(Long userId, ExchangeRequest request) {
        Coupon coupon = couponMapper.selectByIdForUpdate(request.couponId());
        LocalDateTime now = LocalDateTime.now();
        if (coupon == null || !Integer.valueOf(1).equals(coupon.getType())
                || !Integer.valueOf(1).equals(coupon.getStatus())
                || coupon.getExchangePoints() == null || coupon.getExchangePoints() <= 0
                || coupon.getValidStart() == null || coupon.getValidEnd() == null
                || now.isBefore(coupon.getValidStart()) || now.isAfter(coupon.getValidEnd())) {
            throw new BusinessException(40451, HttpStatus.NOT_FOUND, "优惠券不存在");
        }
        int received = value(coupon.getReceivedCount());
        if (coupon.getTotalCount() == null || received >= coupon.getTotalCount()) {
            throw new BusinessException(40953, HttpStatus.CONFLICT, "优惠券库存不足",
                    Map.of("couponId", coupon.getId()));
        }
        int alreadyExchanged = userExchangeCount(userId, coupon.getId());
        int perUserLimit = positive(coupon.getPerUserLimit(), 1);
        if (alreadyExchanged >= perUserLimit) {
            throw new BusinessException(40955, HttpStatus.CONFLICT, "已达到每人限兑数量",
                    Map.of("couponId", coupon.getId(), "perUserLimit", perUserLimit));
        }
        memberLevelService.getOrCreate(userId);
        Member member = memberMapper.selectByUserIdForUpdate(userId);
        int balance = points(member);
        int usePoints = coupon.getExchangePoints();
        if (balance < usePoints) {
            throw new BusinessException(40951, HttpStatus.CONFLICT, "积分余额不足",
                    Map.of("pointsBalance", balance, "usePoints", usePoints));
        }
        if (couponMapper.incrementReceivedCount(coupon.getId()) != 1) {
            throw new BusinessException(40953, HttpStatus.CONFLICT, "优惠券库存不足",
                    Map.of("couponId", coupon.getId()));
        }
        int current = balance - usePoints;
        member.setPointsBalance(current);
        if (memberMapper.updateById(member) != 1) throw new IllegalStateException("积分扣减失败");
        addPointsLog(userId, 4, -usePoints, current, "积分兑换优惠券：" + coupon.getTitle(), now);

        CouponUser couponUser = new CouponUser();
        couponUser.setCouponId(coupon.getId());
        couponUser.setUserId(userId);
        couponUser.setStatus(0);
        couponUser.setReceiveTime(now);
        if (couponUserMapper.insert(couponUser) != 1) throw new IllegalStateException("优惠券领取记录写入失败");
        return new Exchange(couponUser.getId(), coupon.getId(), coupon.getTitle(), usePoints,
                current, format(now), format(coupon.getValidStart()), format(coupon.getValidEnd()));
    }

    @Override
    @Transactional
    public SignIn signIn(Long userId) {
        memberLevelService.getOrCreate(userId);
        Member member = memberMapper.selectByUserIdForUpdate(userId);
        LocalDate today = LocalDate.now();
        if (hasSignedIn(userId, today)) {
            throw new BusinessException(40954, HttpStatus.CONFLICT, "今日已签到",
                    Map.of("signInDate", today.toString()));
        }
        int current = points(member) + SIGN_IN_POINTS;
        member.setPointsBalance(current);
        memberMapper.updateById(member);
        addPointsLog(userId, SIGN_IN_TYPE, SIGN_IN_POINTS, current, "每日签到获得积分", LocalDateTime.now());
        return new SignIn(userId, SIGN_IN_POINTS, current, today.toString());
    }

    @Override
    public SignInStatus getSignInStatus(Long userId) {
        LocalDate today = LocalDate.now();
        boolean signed = hasSignedIn(userId, today);
        return new SignInStatus(userId, signed, today.toString(), SIGN_IN_POINTS,
                signed ? "今日已签到" : "立即签到");
    }

    private boolean hasSignedIn(Long userId, LocalDate date) {
        return pointsLogMapper.selectCount(Wrappers.<PointsLog>lambdaQuery()
                .eq(PointsLog::getUserId, userId).eq(PointsLog::getType, SIGN_IN_TYPE)
                .ge(PointsLog::getCreateTime, date.atStartOfDay())
                .le(PointsLog::getCreateTime, date.atTime(LocalTime.MAX))) > 0;
    }

    private void addPointsLog(Long userId, int type, int change, int current,
                              String remark, LocalDateTime time) {
        PointsLog log = new PointsLog();
        log.setUserId(userId); log.setType(type); log.setChangePoints(change);
        log.setCurrentPoints(current); log.setRemark(remark); log.setCreateTime(time);
        pointsLogMapper.insert(log);
    }

    private ExchangeCouponItem toExchangeCouponItem(Long userId, int balance, Coupon coupon) {
        int received = value(coupon.getReceivedCount());
        int total = value(coupon.getTotalCount());
        int remaining = Math.max(0, total - received);
        int limit = positive(coupon.getPerUserLimit(), 1);
        int already = userExchangeCount(userId, coupon.getId());
        int requiredPoints = value(coupon.getExchangePoints());
        String statusText;
        if (already >= limit) statusText = "已兑换";
        else if (remaining <= 0) statusText = "已兑完";
        else if (balance < requiredPoints) statusText = "积分不足";
        else statusText = "立即兑换";
        return new ExchangeCouponItem(coupon.getId(), coupon.getTitle(), coupon.getType(), "满减券",
                coupon.getMinConsume(), coupon.getDiscountAmount(), requiredPoints,
                "立即兑换".equals(statusText), statusText, total, received, remaining, limit, already,
                format(coupon.getValidStart()), format(coupon.getValidEnd()));
    }

    private int userExchangeCount(Long userId, Long couponId) {
        return Math.toIntExact(couponUserMapper.selectCount(Wrappers.<CouponUser>lambdaQuery()
                .eq(CouponUser::getUserId, userId).eq(CouponUser::getCouponId, couponId)));
    }

    private int value(Integer number) { return number == null ? 0 : number; }
    private int positive(Integer number, int fallback) { return number == null || number <= 0 ? fallback : number; }

    private int points(Member member) { return member.getPointsBalance() == null ? 0 : member.getPointsBalance(); }
    private String format(LocalDateTime time) { return time == null ? null : time.format(DATE_TIME); }
    private String typeText(Integer type) {
        if (type == null) return "未知";
        return switch (type) { case 1 -> "消费获得"; case 2 -> "积分抵扣"; case 3 -> "签到获得";
            case 4 -> "兑换优惠券"; case 5 -> "售后退回"; case 6 -> "系统调整"; default -> "未知"; };
    }
}
