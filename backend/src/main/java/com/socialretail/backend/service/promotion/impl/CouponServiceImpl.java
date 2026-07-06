package com.socialretail.backend.service.promotion.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.socialretail.backend.entity.promotion.Coupon;
import com.socialretail.backend.mapper.promotion.CouponMapper;
import com.socialretail.backend.service.promotion.CouponService;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.List;

@Service
public class CouponServiceImpl implements CouponService {

    private final CouponMapper couponMapper;

    public CouponServiceImpl(CouponMapper couponMapper) {
        this.couponMapper = couponMapper;
    }

    @Override
    public List<Coupon> listCoupons(String keyword, Integer type, Integer status) {
        LambdaQueryWrapper<Coupon> wrapper = new LambdaQueryWrapper<>();
        if (StringUtils.hasText(keyword)) {
            wrapper.like(Coupon::getTitle, keyword);
        }
        if (type != null) {
            wrapper.eq(Coupon::getType, type);
        }
        if (status != null) {
            wrapper.eq(Coupon::getStatus, status);
        }
        wrapper.orderByDesc(Coupon::getCreateTime);
        return couponMapper.selectList(wrapper);
    }

    @Override
    public Coupon getById(Long id) {
        return couponMapper.selectById(id);
    }

    @Override
    public Coupon createCoupon(Coupon coupon) {
        coupon.setReceivedCount(0);
        coupon.setStatus(1);
        couponMapper.insert(coupon);
        return coupon;
    }

    @Override
    public Coupon updateCoupon(Long id, Coupon coupon) {
        coupon.setId(id);
        couponMapper.updateById(coupon);
        return couponMapper.selectById(id);
    }

    @Override
    public void deleteCoupon(Long id) {
        couponMapper.deleteById(id);
    }

    @Override
    public void disableCoupon(Long id) {
        LambdaUpdateWrapper<Coupon> wrapper = new LambdaUpdateWrapper<>();
        wrapper.eq(Coupon::getId, id).set(Coupon::getStatus, 0);
        couponMapper.update(null, wrapper);
    }
}
