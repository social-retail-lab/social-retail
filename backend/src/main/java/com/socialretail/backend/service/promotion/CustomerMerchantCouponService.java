package com.socialretail.backend.service.promotion;

import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.socialretail.backend.common.exception.BusinessException;
import com.socialretail.backend.dto.promotion.PromotionApiModels.MerchantCouponItem;
import com.socialretail.backend.dto.promotion.PromotionApiModels.MerchantCouponPage;
import com.socialretail.backend.dto.promotion.PromotionApiModels.MerchantCouponReceive;
import com.socialretail.backend.entity.member.Merchant;
import com.socialretail.backend.entity.member.MerchantCoupon;
import com.socialretail.backend.entity.member.MerchantCouponUser;
import com.socialretail.backend.mapper.member.MerchantCouponMapper;
import com.socialretail.backend.mapper.member.MerchantCouponUserMapper;
import com.socialretail.backend.mapper.member.MerchantMapper;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.support.TransactionTemplate;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Service
public class CustomerMerchantCouponService {
    private final MerchantCouponMapper couponMapper;
    private final MerchantCouponUserMapper merchantCouponUserMapper;
    private final MerchantMapper merchantMapper;
    private final TransactionTemplate transactionTemplate;

    // No idempotency table exists in the required schema. This cache provides process-lifetime idempotency.
    private final Map<String, MerchantCouponReceive> idempotentResults = new ConcurrentHashMap<>();
    private final Map<String, Object> idempotentLocks = new ConcurrentHashMap<>();

    public CustomerMerchantCouponService(MerchantCouponMapper couponMapper,
                                         MerchantCouponUserMapper merchantCouponUserMapper,
                                         MerchantMapper merchantMapper,
                                         TransactionTemplate transactionTemplate) {
        this.couponMapper = couponMapper;
        this.merchantCouponUserMapper = merchantCouponUserMapper;
        this.merchantMapper = merchantMapper;
        this.transactionTemplate = transactionTemplate;
    }

    public MerchantCouponPage list(Long userId, Long merchantId, int page, int pageSize) {
        LocalDateTime now = LocalDateTime.now();
        List<MerchantCoupon> all = couponMapper.selectList(Wrappers.<MerchantCoupon>lambdaQuery()
                .eq(MerchantCoupon::getMerchantId, merchantId)
                .eq(MerchantCoupon::getStatus, 1)
                .eq(MerchantCoupon::getType, 1)
                .le(MerchantCoupon::getValidStart, now)
                .ge(MerchantCoupon::getValidEnd, now)
                .apply("received_count < total_count")
                .orderByDesc(MerchantCoupon::getCreateTime));
        long total = all.size();
        int from = Math.min((page - 1) * pageSize, all.size());
        int to = Math.min(from + pageSize, all.size());
        List<MerchantCouponItem> items = all.subList(from, to).stream().map(coupon -> {
            long receivedByUser = merchantCouponUserMapper.selectCount(Wrappers.<MerchantCouponUser>lambdaQuery()
                    .eq(MerchantCouponUser::getCouponId, coupon.getId())
                    .eq(MerchantCouponUser::getUserId, userId));
            int totalCount = zero(coupon.getTotalCount());
            int receivedCount = zero(coupon.getReceivedCount());
            int limit = zero(coupon.getPerUserLimit());
            return new MerchantCouponItem(coupon.getId(), coupon.getTitle(), coupon.getType(), "满减券",
                    money(coupon.getMinConsume()), money(coupon.getDiscountAmount()), totalCount,
                    receivedCount, Math.max(totalCount - receivedCount, 0), limit,
                    receivedByUser >= limit, coupon.getValidStart(), coupon.getValidEnd());
        }).toList();
        Merchant merchant = merchantMapper.selectById(merchantId);
        long pages = total == 0 ? 0 : (total + pageSize - 1) / pageSize;
        return new MerchantCouponPage(merchantId, merchant == null ? null : merchant.getMerchantName(),
                items, total, pages, page, pageSize);
    }

    public MerchantCouponReceive receive(Long userId, Long couponId, String idempotentKey) {
        String key = userId + ":" + idempotentKey;
        MerchantCouponReceive cached = idempotentResults.get(key);
        if (cached != null) return cached;
        Object lock = idempotentLocks.computeIfAbsent(key, ignored -> new Object());
        synchronized (lock) {
            try {
                cached = idempotentResults.get(key);
                if (cached != null) return cached;
                MerchantCouponReceive result = transactionTemplate.execute(
                        status -> receiveInTransaction(userId, couponId));
                idempotentResults.put(key, result);
                return result;
            } finally {
                idempotentLocks.remove(key, lock);
            }
        }
    }

    private MerchantCouponReceive receiveInTransaction(Long userId, Long couponId) {
        MerchantCoupon coupon = couponMapper.selectByIdForUpdate(couponId);
        if (coupon == null) throw error(40481, HttpStatus.NOT_FOUND, "商家优惠券不存在", null);
        LocalDateTime now = LocalDateTime.now();
        if (!Integer.valueOf(1).equals(coupon.getType())
                || !Integer.valueOf(1).equals(coupon.getStatus()) || coupon.getValidStart() == null
                || now.isBefore(coupon.getValidStart())) {
            throw error(40983, HttpStatus.CONFLICT, "商家优惠券当前不可领取",
                    Map.of("couponId", couponId, "status", zero(coupon.getStatus())));
        }
        if (coupon.getValidEnd() == null || now.isAfter(coupon.getValidEnd())) {
            Map<String, Object> data = new java.util.LinkedHashMap<>();
            data.put("couponId", couponId);
            data.put("validEnd", coupon.getValidEnd());
            throw error(40984, HttpStatus.CONFLICT, "商家优惠券已过期", data);
        }
        if (zero(coupon.getReceivedCount()) >= zero(coupon.getTotalCount())) {
            throw error(40981, HttpStatus.CONFLICT, "商家优惠券已领完", Map.of("couponId", couponId));
        }
        long owned = merchantCouponUserMapper.selectCount(Wrappers.<MerchantCouponUser>lambdaQuery()
                .eq(MerchantCouponUser::getCouponId, couponId)
                .eq(MerchantCouponUser::getUserId, userId));
        int limit = zero(coupon.getPerUserLimit());
        if (owned >= limit) {
            throw error(40982, HttpStatus.CONFLICT, "已达到每人限领数量",
                    Map.of("couponId", couponId, "perUserLimit", limit));
        }
        MerchantCouponUser userCoupon = new MerchantCouponUser();
        userCoupon.setCouponId(couponId);
        userCoupon.setUserId(userId);
        userCoupon.setStatus(0);
        userCoupon.setReceiveTime(now);
        merchantCouponUserMapper.insert(userCoupon);
        if (couponMapper.incrementReceivedCount(couponId) != 1) {
            throw error(40981, HttpStatus.CONFLICT, "商家优惠券已领完", Map.of("couponId", couponId));
        }
        Merchant merchant = merchantMapper.selectById(coupon.getMerchantId());
        return new MerchantCouponReceive(userCoupon.getId(), couponId, coupon.getMerchantId(),
                merchant == null ? null : merchant.getMerchantName(), coupon.getTitle(), 0, "未使用",
                now, coupon.getValidStart(), coupon.getValidEnd());
    }

    private BusinessException error(int code, HttpStatus status, String message, Object data) {
        return new BusinessException(code, status, message, data);
    }
    private int zero(Integer value) { return value == null ? 0 : value; }
    private BigDecimal money(BigDecimal value) { return value == null ? new BigDecimal("0.00") : value; }
}
