package com.socialretail.backend.service.order.pricing;

import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.socialretail.backend.common.exception.BusinessException;
import com.socialretail.backend.entity.member.Merchant;
import com.socialretail.backend.entity.member.MerchantCoupon;
import com.socialretail.backend.entity.member.MerchantCouponUser;
import com.socialretail.backend.mapper.member.MerchantCouponMapper;
import com.socialretail.backend.mapper.member.MerchantCouponUserMapper;
import com.socialretail.backend.mapper.member.MerchantMapper;
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
public class MerchantCouponPricingService {
    private static final BigDecimal ZERO = new BigDecimal("0.00");
    private final MerchantCouponMapper couponMapper;
    private final MerchantCouponUserMapper couponUserMapper;
    private final MerchantMapper merchantMapper;

    public MerchantCouponPricingService(MerchantCouponMapper couponMapper,
                                        MerchantCouponUserMapper couponUserMapper,
                                        MerchantMapper merchantMapper) {
        this.couponMapper = couponMapper;
        this.couponUserMapper = couponUserMapper;
        this.merchantMapper = merchantMapper;
    }

    public Pricing resolve(Long userId, Long merchantId, Long requestedCouponUserId,
                           BigDecimal amount, boolean enabled, boolean autoSelect) {
        List<Entry> available = availableEntries(userId, merchantId, amount);
        Entry selected = null;
        if (enabled && requestedCouponUserId != null) {
            selected = available.stream()
                    .filter(entry -> entry.userCoupon().getId().equals(requestedCouponUserId))
                    .findFirst().orElseThrow(() -> unavailable(requestedCouponUserId, merchantId, amount));
        } else if (enabled && autoSelect && !available.isEmpty()) {
            selected = available.get(0);
        }
        Entry finalSelected = selected;
        List<CouponOptionVO> options = available.stream()
                .filter(entry -> finalSelected == null
                        || !entry.userCoupon().getId().equals(finalSelected.userCoupon().getId()))
                .map(entry -> toOption(entry, false, false))
                .toList();
        CouponOptionVO selectedInfo = selected == null ? null
                : toOption(selected, true, autoSelect && requestedCouponUserId == null);
        return new Pricing(selectedInfo, selected == null ? ZERO : money(selected.coupon().getDiscountAmount()),
                options, selected == null ? null : selected.userCoupon().getId());
    }

    public CouponOptionVO orderCoupon(Long userId, Long couponUserId, BigDecimal discount) {
        if (couponUserId == null) return null;
        MerchantCouponUser userCoupon = couponUserMapper.selectOne(Wrappers.<MerchantCouponUser>lambdaQuery()
                .eq(MerchantCouponUser::getId, couponUserId)
                .eq(MerchantCouponUser::getUserId, userId).last("LIMIT 1"));
        if (userCoupon == null) return null;
        MerchantCoupon coupon = couponMapper.selectById(userCoupon.getCouponId());
        if (coupon == null) return null;
        Merchant merchant = merchantMapper.selectById(coupon.getMerchantId());
        return new CouponOptionVO(userCoupon.getId(), coupon.getId(), coupon.getMerchantId(),
                merchant == null ? null : merchant.getMerchantName(), coupon.getTitle(),
                "MERCHANT", "商家券", null, money(discount), null, null, null);
    }

    public void markUsed(Long couponUserId, Long userId, Long orderId, LocalDateTime useTime) {
        if (couponUserId != null && couponUserMapper.markUsed(couponUserId, userId, orderId, useTime) != 1) {
            throw unavailable(couponUserId, null, null);
        }
    }

    public void restoreByOrderId(Long orderId) {
        couponUserMapper.restoreByOrderId(orderId);
    }

    private List<Entry> availableEntries(Long userId, Long merchantId, BigDecimal amount) {
        LocalDateTime now = LocalDateTime.now();
        List<Entry> result = new ArrayList<>();
        List<MerchantCouponUser> owned = couponUserMapper.selectList(
                Wrappers.<MerchantCouponUser>lambdaQuery()
                        .eq(MerchantCouponUser::getUserId, userId)
                        .eq(MerchantCouponUser::getStatus, 0));
        for (MerchantCouponUser userCoupon : owned) {
            MerchantCoupon coupon = couponMapper.selectById(userCoupon.getCouponId());
            if (coupon == null || !merchantId.equals(coupon.getMerchantId())
                    || !Integer.valueOf(1).equals(coupon.getType())
                    || !Integer.valueOf(1).equals(coupon.getStatus())
                    || coupon.getValidStart() == null || coupon.getValidEnd() == null
                    || now.isBefore(coupon.getValidStart()) || now.isAfter(coupon.getValidEnd())
                    || amount.compareTo(money(coupon.getMinConsume())) < 0) continue;
            result.add(new Entry(userCoupon, coupon, merchantMapper.selectById(merchantId)));
        }
        result.sort(Comparator
                .comparing((Entry entry) -> money(entry.coupon().getDiscountAmount())).reversed()
                .thenComparing(entry -> entry.coupon().getValidEnd())
                .thenComparing(entry -> entry.userCoupon().getId()));
        return result;
    }

    private CouponOptionVO toOption(Entry entry, boolean selected, boolean autoSelected) {
        return option(entry.userCoupon(), entry.coupon(), entry.merchant(),
                money(entry.coupon().getDiscountAmount()), selected, autoSelected);
    }

    private CouponOptionVO option(MerchantCouponUser userCoupon, MerchantCoupon coupon,
                                  Merchant merchant, BigDecimal discount,
                                  Boolean selected, Boolean autoSelected) {
        return new CouponOptionVO(userCoupon.getId(), coupon.getId(), coupon.getMerchantId(),
                merchant == null ? null : merchant.getMerchantName(), coupon.getTitle(),
                "MERCHANT", "商家券", money(coupon.getMinConsume()), discount,
                selected, autoSelected, null);
    }

    private BusinessException unavailable(Long couponUserId, Long merchantId, BigDecimal amount) {
        Map<String, Object> data = new java.util.LinkedHashMap<>();
        data.put("merchantCouponUserId", couponUserId);
        MerchantCouponUser owned = couponUserMapper.selectOne(Wrappers.<MerchantCouponUser>lambdaQuery()
                .eq(MerchantCouponUser::getId, couponUserId).last("LIMIT 1"));
        MerchantCoupon coupon = owned == null ? null : couponMapper.selectById(owned.getCouponId());
        data.put("merchantId", merchantId != null ? merchantId : coupon == null ? null : coupon.getMerchantId());
        if (coupon != null) data.put("minConsume", money(coupon.getMinConsume()));
        if (amount != null) data.put("currentAmount", amount);
        return new BusinessException(40914, HttpStatus.CONFLICT,
                "商家优惠券不可用或不满足使用条件",
                data);
    }

    private BigDecimal money(BigDecimal value) { return value == null ? ZERO : value; }
    private record Entry(MerchantCouponUser userCoupon, MerchantCoupon coupon, Merchant merchant) { }
    public record Pricing(CouponOptionVO selected, BigDecimal discount,
                          List<CouponOptionVO> available, Long couponUserId) { }
}
