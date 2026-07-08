package com.socialretail.backend.service.merchant.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.socialretail.backend.entity.promotion.MerchantCoupon;
import com.socialretail.backend.entity.promotion.MerchantCouponTier;
import com.socialretail.backend.mapper.promotion.MerchantCouponMapper;
import com.socialretail.backend.mapper.promotion.MerchantCouponTierMapper;
import com.socialretail.backend.service.merchant.MerchantCouponService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@Service
public class MerchantCouponServiceImpl implements MerchantCouponService {

    private final MerchantCouponMapper merchantCouponMapper;
    private final MerchantCouponTierMapper merchantCouponTierMapper;

    public MerchantCouponServiceImpl(MerchantCouponMapper merchantCouponMapper,
                                     MerchantCouponTierMapper merchantCouponTierMapper) {
        this.merchantCouponMapper = merchantCouponMapper;
        this.merchantCouponTierMapper = merchantCouponTierMapper;
    }

    @Override
    @Transactional
    public MerchantCoupon createCoupon(Long merchantId, MerchantCoupon coupon, List<Map<String, BigDecimal>> tiers) {
        coupon.setMerchantId(merchantId);
        coupon.setStatus(1);
        coupon.setCreateTime(LocalDateTime.now());
        coupon.setUpdateTime(LocalDateTime.now());
        if (coupon.getValidityType() == null) {
            coupon.setValidityType(1);
        }
        merchantCouponMapper.insert(coupon);

        if (coupon.getType() != null && coupon.getType() == 2 && tiers != null && !tiers.isEmpty()) {
            for (Map<String, BigDecimal> tier : tiers) {
                MerchantCouponTier t = new MerchantCouponTier();
                t.setCouponId(coupon.getId());
                t.setMinAmount(tier.get("minAmount"));
                t.setDiscountAmount(tier.get("discountAmount"));
                merchantCouponTierMapper.insert(t);
            }
        }
        return coupon;
    }

    @Override
    public List<MerchantCoupon> listCoupons(Long merchantId) {
        LambdaQueryWrapper<MerchantCoupon> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(MerchantCoupon::getMerchantId, merchantId);
        wrapper.orderByDesc(MerchantCoupon::getCreateTime);
        List<MerchantCoupon> coupons = merchantCouponMapper.selectList(wrapper);

        for (MerchantCoupon coupon : coupons) {
            if (coupon.getType() != null && coupon.getType() == 2) {
                LambdaQueryWrapper<MerchantCouponTier> tierWrapper = new LambdaQueryWrapper<>();
                tierWrapper.eq(MerchantCouponTier::getCouponId, coupon.getId());
                tierWrapper.orderByAsc(MerchantCouponTier::getMinAmount);
                List<MerchantCouponTier> tierList = merchantCouponTierMapper.selectList(tierWrapper);
                coupon.setTiers(tierList);
            }
        }
        return coupons;
    }

    @Override
    @Transactional
    public MerchantCoupon updateCoupon(Long merchantId, Long couponId, MerchantCoupon coupon, List<Map<String, BigDecimal>> tiers) {
        coupon.setId(couponId);
        coupon.setMerchantId(merchantId);
        coupon.setUpdateTime(LocalDateTime.now());
        merchantCouponMapper.updateById(coupon);

        // 更新梯度：先删旧，再插新（仅满减券 type=2）
        LambdaQueryWrapper<MerchantCouponTier> delWrapper = new LambdaQueryWrapper<>();
        delWrapper.eq(MerchantCouponTier::getCouponId, couponId);
        merchantCouponTierMapper.delete(delWrapper);

        if (coupon.getType() != null && coupon.getType() == 2 && tiers != null && !tiers.isEmpty()) {
            int sort = 1;
            for (Map<String, BigDecimal> tier : tiers) {
                MerchantCouponTier t = new MerchantCouponTier();
                t.setCouponId(couponId);
                t.setMinAmount(tier.get("minAmount"));
                t.setDiscountAmount(tier.get("discountAmount"));
                t.setSortOrder(sort++);
                merchantCouponTierMapper.insert(t);
            }
        }
        return merchantCouponMapper.selectById(couponId);
    }

    @Override
    @Transactional
    public void disableCoupon(Long merchantId, Long couponId) {
        // 先校验归属，再更新
        MerchantCoupon coupon = merchantCouponMapper.selectById(couponId);
        if (coupon == null || !coupon.getMerchantId().equals(merchantId)) {
            throw new RuntimeException("优惠卷不存在或无权操作");
        }
        // 用最小 entity 更新，避免全量字段覆盖问题
        MerchantCoupon update = new MerchantCoupon();
        update.setId(couponId);
        update.setStatus(0);
        update.setUpdateTime(LocalDateTime.now());
        merchantCouponMapper.updateById(update);
    }

    @Override
    @Transactional
    public void enableCoupon(Long merchantId, Long couponId) {
        MerchantCoupon coupon = merchantCouponMapper.selectById(couponId);
        if (coupon == null || !coupon.getMerchantId().equals(merchantId)) {
            throw new RuntimeException("优惠卷不存在或无权操作");
        }
        MerchantCoupon update = new MerchantCoupon();
        update.setId(couponId);
        update.setStatus(1);
        update.setReceivedCount(0);
        update.setUpdateTime(LocalDateTime.now());
        merchantCouponMapper.updateById(update);
    }
}
