package com.socialretail.backend.service.promotion;

import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.socialretail.backend.common.exception.BusinessException;
import com.socialretail.backend.dto.promotion.PromotionApiModels.AvailableCoupon;
import com.socialretail.backend.dto.promotion.PromotionApiModels.AvailableCouponResponse;
import com.socialretail.backend.dto.promotion.PromotionApiModels.CouponUseRule;
import com.socialretail.backend.dto.promotion.PromotionApiModels.MyCoupon;
import com.socialretail.backend.dto.promotion.PromotionApiModels.MyCouponPage;
import com.socialretail.backend.entity.member.Coupon;
import com.socialretail.backend.entity.member.CouponUser;
import com.socialretail.backend.entity.member.Merchant;
import com.socialretail.backend.entity.member.MerchantCoupon;
import com.socialretail.backend.entity.member.MerchantCouponUser;
import com.socialretail.backend.mapper.member.CouponMapper;
import com.socialretail.backend.mapper.member.CouponUserMapper;
import com.socialretail.backend.mapper.member.MerchantCouponMapper;
import com.socialretail.backend.mapper.member.MerchantCouponUserMapper;
import com.socialretail.backend.mapper.member.MerchantMapper;
import com.socialretail.backend.mapper.order.CartMapper;
import com.socialretail.backend.vo.CartItemVO;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Locale;
import java.util.Set;

@Service
public class CouponQueryService {
    private static final String PLATFORM = "PLATFORM";
    private static final String MERCHANT = "MERCHANT";

    private final CouponMapper couponMapper;
    private final CouponUserMapper couponUserMapper;
    private final MerchantCouponMapper merchantCouponMapper;
    private final MerchantCouponUserMapper merchantCouponUserMapper;
    private final MerchantMapper merchantMapper;
    private final CartMapper cartMapper;

    public CouponQueryService(CouponMapper couponMapper, CouponUserMapper couponUserMapper,
                              MerchantCouponMapper merchantCouponMapper,
                              MerchantCouponUserMapper merchantCouponUserMapper,
                              MerchantMapper merchantMapper, CartMapper cartMapper) {
        this.couponMapper = couponMapper;
        this.couponUserMapper = couponUserMapper;
        this.merchantCouponMapper = merchantCouponMapper;
        this.merchantCouponUserMapper = merchantCouponUserMapper;
        this.merchantMapper = merchantMapper;
        this.cartMapper = cartMapper;
    }

    public MyCouponPage myCoupons(Long userId, String requestedSource, Integer status,
                                  Long merchantId, int page, int pageSize) {
        String source = normalizeSource(requestedSource);
        LocalDateTime now = LocalDateTime.now();
        List<MyCoupon> all = new ArrayList<>();
        if (!MERCHANT.equals(source)) {
            List<CouponUser> owned = couponUserMapper.selectList(Wrappers.<CouponUser>lambdaQuery()
                    .eq(CouponUser::getUserId, userId));
            for (CouponUser userCoupon : owned) {
                Coupon coupon = couponMapper.selectById(userCoupon.getCouponId());
                if (coupon == null) continue;
                int dynamicStatus = dynamicStatus(userCoupon.getStatus(), coupon.getValidEnd(), now);
                if (status != null && status != dynamicStatus) continue;
                all.add(new MyCoupon(userCoupon.getId(), coupon.getId(), PLATFORM, "平台券",
                        null, null, coupon.getTitle(), coupon.getType(), "满减券",
                        money(coupon.getMinConsume()), money(coupon.getDiscountAmount()), dynamicStatus,
                        statusText(dynamicStatus), userCoupon.getReceiveTime(), userCoupon.getUseTime(),
                        coupon.getValidStart(), coupon.getValidEnd()));
            }
        }
        if (!PLATFORM.equals(source)) {
            List<MerchantCouponUser> owned = merchantCouponUserMapper.selectList(
                    Wrappers.<MerchantCouponUser>lambdaQuery().eq(MerchantCouponUser::getUserId, userId));
            for (MerchantCouponUser userCoupon : owned) {
                MerchantCoupon coupon = merchantCouponMapper.selectById(userCoupon.getCouponId());
                if (coupon == null || merchantId != null && !merchantId.equals(coupon.getMerchantId())) continue;
                int dynamicStatus = dynamicStatus(userCoupon.getStatus(), coupon.getValidEnd(), now);
                if (status != null && status != dynamicStatus) continue;
                Merchant merchant = merchantMapper.selectById(coupon.getMerchantId());
                all.add(new MyCoupon(userCoupon.getId(), coupon.getId(), MERCHANT, "商家券",
                        coupon.getMerchantId(), merchant == null ? null : merchant.getMerchantName(),
                        coupon.getTitle(), coupon.getType(), "满减券", money(coupon.getMinConsume()),
                        money(coupon.getDiscountAmount()), dynamicStatus, statusText(dynamicStatus),
                        userCoupon.getReceiveTime(), userCoupon.getUseTime(),
                        coupon.getValidStart(), coupon.getValidEnd()));
            }
        }
        all.sort(Comparator.comparing(MyCoupon::receiveTime,
                        Comparator.nullsLast(Comparator.reverseOrder()))
                .thenComparing(MyCoupon::couponUserId, Comparator.reverseOrder()));
        long total = all.size();
        int from = Math.min((page - 1) * pageSize, all.size());
        int to = Math.min(from + pageSize, all.size());
        long pages = total == 0 ? 0 : (total + pageSize - 1) / pageSize;
        return new MyCouponPage(new ArrayList<>(all.subList(from, to)), total, pages, page, pageSize);
    }

    public AvailableCouponResponse availableCoupons(Long userId, List<Long> requestedCartItemIds) {
        Set<Long> distinctIds = new LinkedHashSet<>(requestedCartItemIds);
        List<CartItemVO> items = cartMapper.selectCartItemsByIds(userId, new ArrayList<>(distinctIds));
        if (items.size() != distinctIds.size()) {
            throw new BusinessException(40421, HttpStatus.NOT_FOUND, "购物车商品不存在或不属于当前用户");
        }
        Long merchantId = items.get(0).getMerchantId();
        if (merchantId == null || items.stream().anyMatch(item -> !merchantId.equals(item.getMerchantId()))) {
            throw new BusinessException(40921, HttpStatus.CONFLICT, "请选择同一商家的商品结算");
        }
        BigDecimal amount = items.stream()
                .map(item -> money(item.getPrice()).multiply(BigDecimal.valueOf(item.getQuantity())))
                .reduce(new BigDecimal("0.00"), BigDecimal::add);
        Merchant merchant = merchantMapper.selectById(merchantId);
        String merchantName = merchant == null ? null : merchant.getMerchantName();
        LocalDateTime now = LocalDateTime.now();
        List<AvailableCoupon> platform = platformCoupons(userId, amount, now);
        List<AvailableCoupon> merchantCoupons = merchantCoupons(userId, merchantId, merchantName, amount, now);
        return new AvailableCouponResponse(money(amount), merchantId, merchantName,
                recommend(platform), recommend(merchantCoupons),
                new CouponUseRule(1, 1, true,
                        "同一笔订单最多使用1张平台优惠券和1张商家优惠券，二者可叠加使用。"));
    }

    private List<AvailableCoupon> platformCoupons(Long userId, BigDecimal amount, LocalDateTime now) {
        List<AvailableCoupon> result = new ArrayList<>();
        List<CouponUser> owned = couponUserMapper.selectList(Wrappers.<CouponUser>lambdaQuery()
                .eq(CouponUser::getUserId, userId).eq(CouponUser::getStatus, 0));
        for (CouponUser userCoupon : owned) {
            Coupon coupon = couponMapper.selectById(userCoupon.getCouponId());
            if (coupon == null) continue;
            String reason = unavailableReason(coupon.getType(), coupon.getStatus(), coupon.getValidStart(),
                    coupon.getValidEnd(), coupon.getMinConsume(), amount, now);
            result.add(new AvailableCoupon(userCoupon.getId(), coupon.getId(), PLATFORM, "平台券",
                    null, null, coupon.getTitle(), coupon.getType(), "满减券", money(coupon.getMinConsume()),
                    money(coupon.getDiscountAmount()), reason == null, reason, false, false,
                    userCoupon.getReceiveTime(), coupon.getValidStart(), coupon.getValidEnd()));
        }
        return result;
    }

    private List<AvailableCoupon> merchantCoupons(Long userId, Long currentMerchantId,
                                                   String currentMerchantName, BigDecimal amount,
                                                   LocalDateTime now) {
        List<AvailableCoupon> result = new ArrayList<>();
        List<MerchantCouponUser> owned = merchantCouponUserMapper.selectList(
                Wrappers.<MerchantCouponUser>lambdaQuery()
                        .eq(MerchantCouponUser::getUserId, userId)
                        .eq(MerchantCouponUser::getStatus, 0));
        for (MerchantCouponUser userCoupon : owned) {
            MerchantCoupon coupon = merchantCouponMapper.selectById(userCoupon.getCouponId());
            if (coupon == null) continue;
            String reason = currentMerchantId.equals(coupon.getMerchantId()) ? null : "不适用于当前商家";
            if (reason == null) reason = unavailableReason(coupon.getType(), coupon.getStatus(),
                    coupon.getValidStart(), coupon.getValidEnd(), coupon.getMinConsume(), amount, now);
            boolean currentMerchant = currentMerchantId.equals(coupon.getMerchantId());
            Merchant merchant = currentMerchant ? null : merchantMapper.selectById(coupon.getMerchantId());
            String name = currentMerchant ? currentMerchantName
                    : merchant == null ? null : merchant.getMerchantName();
            result.add(new AvailableCoupon(userCoupon.getId(), coupon.getId(), MERCHANT, "商家券",
                    coupon.getMerchantId(), name, coupon.getTitle(), coupon.getType(), "满减券",
                    money(coupon.getMinConsume()), money(coupon.getDiscountAmount()), reason == null,
                    reason, false, false, userCoupon.getReceiveTime(),
                    coupon.getValidStart(), coupon.getValidEnd()));
        }
        return result;
    }

    private List<AvailableCoupon> recommend(List<AvailableCoupon> coupons) {
        Long bestId = coupons.stream().filter(AvailableCoupon::available)
                .sorted(Comparator.comparing(AvailableCoupon::discountAmount).reversed()
                        .thenComparing(AvailableCoupon::validEnd,
                                Comparator.nullsLast(Comparator.naturalOrder()))
                        .thenComparing(AvailableCoupon::couponUserId))
                .map(AvailableCoupon::couponUserId).findFirst().orElse(null);
        return coupons.stream().map(coupon -> copyWithSelection(coupon,
                bestId != null && bestId.equals(coupon.couponUserId()))).toList();
    }

    private AvailableCoupon copyWithSelection(AvailableCoupon c, boolean selected) {
        return new AvailableCoupon(c.couponUserId(), c.couponId(), c.source(), c.sourceText(),
                c.merchantId(), c.merchantName(), c.title(), c.type(), c.typeText(), c.minConsume(),
                c.discountAmount(), c.available(), c.unavailableReason(), selected, selected,
                c.receiveTime(), c.validStart(), c.validEnd());
    }

    private String unavailableReason(Integer type, Integer status, LocalDateTime start,
                                     LocalDateTime end, BigDecimal minimum,
                                     BigDecimal amount, LocalDateTime now) {
        if (!Integer.valueOf(1).equals(type)) return "仅支持满减券";
        if (!Integer.valueOf(1).equals(status)) return "优惠券当前不可用";
        if (start == null || now.isBefore(start)) return "优惠券尚未生效";
        if (end == null || now.isAfter(end)) return "优惠券已过期";
        if (amount.compareTo(money(minimum)) < 0) return "未满足最低消费金额";
        return null;
    }

    private String normalizeSource(String source) {
        if (source == null || source.isBlank()) return null;
        String normalized = source.trim().toUpperCase(Locale.ROOT);
        if (!PLATFORM.equals(normalized) && !MERCHANT.equals(normalized)) {
            throw new BusinessException(40001, HttpStatus.BAD_REQUEST, "source仅支持PLATFORM或MERCHANT");
        }
        return normalized;
    }

    private int dynamicStatus(Integer stored, LocalDateTime end, LocalDateTime now) {
        int value = stored == null ? 0 : stored;
        return value == 0 && end != null && now.isAfter(end) ? 2 : value;
    }
    private String statusText(int status) {
        return status == 1 ? "已使用" : status == 2 ? "已过期" : "未使用";
    }
    private BigDecimal money(BigDecimal value) {
        return value == null ? new BigDecimal("0.00") : value.setScale(2, RoundingMode.HALF_UP);
    }
}
