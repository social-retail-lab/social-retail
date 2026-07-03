package com.socialretail.backend.service.promotion.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.socialretail.backend.common.exception.BusinessException;
import com.socialretail.backend.entity.promotion.Coupon;
import com.socialretail.backend.mapper.promotion.CouponMapper;
import com.socialretail.backend.service.promotion.CouponService;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Service
public class CouponServiceImpl implements CouponService {
    private static final BigDecimal DEFAULT_MIN_CONSUME = new BigDecimal("0.01");

    private final CouponMapper couponMapper;

    public CouponServiceImpl(CouponMapper couponMapper) {
        this.couponMapper = couponMapper;
    }

    @Override
    public List<Coupon> listCoupons(String keyword, Integer type, Integer status) {
        LambdaQueryWrapper<Coupon> query = new LambdaQueryWrapper<>();
        query.like(StringUtils.hasText(keyword), Coupon::getTitle,
                        StringUtils.hasText(keyword) ? keyword.trim() : null)
                .eq(type != null, Coupon::getType, type)
                .eq(status != null, Coupon::getStatus, status)
                .orderByDesc(Coupon::getCreateTime)
                .orderByDesc(Coupon::getId);
        return couponMapper.selectList(query);
    }

    @Override
    public Coupon getById(Long id) {
        return requireCoupon(id);
    }

    @Override
    @Transactional
    public Coupon createCoupon(Coupon coupon) {
        LocalDateTime now = LocalDateTime.now();
        coupon.setId(null);
        coupon.setReceivedCount(0);
        coupon.setStatus(coupon.getStatus() == null ? 1 : coupon.getStatus());
        coupon.setMinConsume(coupon.getMinConsume() == null
                ? DEFAULT_MIN_CONSUME : coupon.getMinConsume());
        coupon.setPerUserLimit(coupon.getPerUserLimit() == null ? 1 : coupon.getPerUserLimit());
        coupon.setExchangePoints(coupon.getExchangePoints() == null ? 0 : coupon.getExchangePoints());
        coupon.setValidityType(coupon.getValidityType() == null ? 1 : coupon.getValidityType());
        coupon.setCreateTime(now);
        coupon.setUpdateTime(now);
        if (couponMapper.insert(coupon) != 1) {
            throw new IllegalStateException("优惠券创建失败");
        }
        return coupon;
    }

    @Override
    @Transactional
    public Coupon updateCoupon(Long id, Coupon coupon) {
        requireCoupon(id);
        coupon.setId(id);
        coupon.setReceivedCount(null);
        coupon.setCreateTime(null);
        coupon.setUpdateTime(LocalDateTime.now());
        if (couponMapper.updateById(coupon) != 1) {
            throw new IllegalStateException("优惠券更新失败");
        }
        return requireCoupon(id);
    }

    @Override
    @Transactional
    public void deleteCoupon(Long id) {
        requireCoupon(id);
        if (couponMapper.deleteById(id) != 1) {
            throw new IllegalStateException("优惠券删除失败");
        }
    }

    @Override
    @Transactional
    public void disableCoupon(Long id) {
        requireCoupon(id);
        Coupon update = new Coupon();
        update.setId(id);
        update.setStatus(0);
        update.setUpdateTime(LocalDateTime.now());
        if (couponMapper.updateById(update) != 1) {
            throw new IllegalStateException("优惠券停用失败");
        }
    }

    private Coupon requireCoupon(Long id) {
        Coupon coupon = id == null ? null : couponMapper.selectById(id);
        if (coupon == null) {
            throw new BusinessException(40451, HttpStatus.NOT_FOUND, "优惠券不存在");
        }
        return coupon;
    }
}
