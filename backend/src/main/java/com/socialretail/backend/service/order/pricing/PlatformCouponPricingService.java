package com.socialretail.backend.service.order.pricing;

import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.socialretail.backend.common.exception.BusinessException;
import com.socialretail.backend.entity.member.Coupon;
import com.socialretail.backend.entity.member.CouponUser;
import com.socialretail.backend.mapper.member.CouponMapper;
import com.socialretail.backend.mapper.member.CouponUserMapper;
import com.socialretail.backend.vo.CouponOptionVO;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Map;

@Service
public class PlatformCouponPricingService {
    private final CouponMapper couponMapper;
    private final CouponUserMapper couponUserMapper;

    public PlatformCouponPricingService(CouponMapper couponMapper, CouponUserMapper couponUserMapper) {
        this.couponMapper = couponMapper;
        this.couponUserMapper = couponUserMapper;
    }

    public Pricing resolve(Long userId, Long requestedCouponUserId, BigDecimal amount,
                           boolean enabled, boolean autoSelect) {
        List<Entry> available = availableEntries(userId, amount);
        Entry selected = null;
        if (enabled && requestedCouponUserId != null) {
            selected = available.stream().filter(e -> e.user().getId().equals(requestedCouponUserId))
                    .findFirst().orElseThrow(() -> unavailable(requestedCouponUserId, amount));
        } else if (enabled && autoSelect) {
            selected = available.isEmpty() ? null : available.get(0);
        }
        Entry finalSelected = selected;
        List<CouponOptionVO> options = available.stream()
                .filter(e -> finalSelected == null || !e.user().getId().equals(finalSelected.user().getId()))
                .map(e -> toOption(e, false, false))
                .toList();
        CouponOptionVO selectedInfo = selected == null ? null
                : toOption(selected, true, autoSelect && requestedCouponUserId == null);
        return new Pricing(selectedInfo, selected == null ? BigDecimal.ZERO : money(selected.coupon().getDiscountAmount()), options,
                selected == null ? null : selected.user().getId());
    }

    public CouponOptionVO orderCoupon(Long userId, Long couponUserId, BigDecimal discount) {
        if (couponUserId == null) return null;
        CouponUser userCoupon = couponUserMapper.selectOne(Wrappers.<CouponUser>lambdaQuery()
                .eq(CouponUser::getId, couponUserId).eq(CouponUser::getUserId, userId).last("LIMIT 1"));
        if (userCoupon == null) return null;
        Coupon coupon = couponMapper.selectById(userCoupon.getCouponId());
        if (coupon == null) return null;
        return new CouponOptionVO(userCoupon.getId(), coupon.getId(), null, null, coupon.getTitle(),
                "PLATFORM", "平台券", null, money(discount), null, null, null);
    }

    public void markUsed(Long couponUserId, Long userId, Long orderId, LocalDateTime useTime) {
        if (couponUserId != null && couponUserMapper.markUsed(couponUserId, userId, orderId, useTime) != 1) {
            throw new BusinessException(40913, HttpStatus.CONFLICT, "平台优惠券不可用或不满足使用条件",
                    Map.of("platformCouponUserId", couponUserId));
        }
    }

    public void restoreByOrderId(Long orderId) {
        couponUserMapper.restoreByOrderId(orderId);
    }

    private List<Entry> availableEntries(Long userId, BigDecimal amount) {
        LocalDateTime now = LocalDateTime.now();
        List<CouponUser> userCoupons = couponUserMapper.selectList(Wrappers.<CouponUser>lambdaQuery()
                .eq(CouponUser::getUserId, userId).eq(CouponUser::getStatus, 0));
        List<Entry> result = new ArrayList<>();
        for (CouponUser userCoupon : userCoupons) {
            Coupon coupon = couponMapper.selectById(userCoupon.getCouponId());
            if (coupon == null || !Integer.valueOf(1).equals(coupon.getType())
                    || !Integer.valueOf(1).equals(coupon.getStatus())
                    || coupon.getValidStart() == null || coupon.getValidEnd() == null
                    || now.isBefore(coupon.getValidStart()) || now.isAfter(coupon.getValidEnd())
                    || amount.compareTo(money(coupon.getMinConsume())) < 0) continue;
            result.add(new Entry(userCoupon, coupon));
        }
        result.sort(Comparator
                .comparing((Entry e) -> money(e.coupon().getDiscountAmount())).reversed()
                .thenComparing(e -> e.coupon().getValidEnd())
                .thenComparing(e -> e.user().getId()));
        return result;
    }

    private CouponOptionVO toOption(Entry entry, boolean selected, boolean autoSelected) {
        Coupon coupon = entry.coupon();
        return new CouponOptionVO(entry.user().getId(), coupon.getId(), null, null, coupon.getTitle(),
                "PLATFORM", "平台券", money(coupon.getMinConsume()), money(coupon.getDiscountAmount()),
                selected, autoSelected, null);
    }

    private BusinessException unavailable(Long couponUserId, BigDecimal amount) {
        Map<String, Object> data = new java.util.LinkedHashMap<>();
        data.put("platformCouponUserId", couponUserId);
        CouponUser owned = couponUserMapper.selectOne(Wrappers.<CouponUser>lambdaQuery()
                .eq(CouponUser::getId, couponUserId).last("LIMIT 1"));
        Coupon coupon = owned == null ? null : couponMapper.selectById(owned.getCouponId());
        if (coupon != null) data.put("minConsume", money(coupon.getMinConsume()));
        data.put("currentAmount", amount);
        return new BusinessException(40913, HttpStatus.CONFLICT, "平台优惠券不可用或不满足使用条件",
                data);
    }

    private BigDecimal money(BigDecimal value) { return value == null ? new BigDecimal("0.00") : value; }
    private record Entry(CouponUser user, Coupon coupon) { }
    public record Pricing(CouponOptionVO selected, BigDecimal discount,
                          List<CouponOptionVO> available, Long couponUserId) { }
}
