package com.socialretail.backend.service.promotion;

import com.socialretail.backend.entity.promotion.Coupon;

import java.util.List;

public interface CouponService {

    List<Coupon> listCoupons(String keyword, Integer type, Integer status);

    Coupon getById(Long id);

    Coupon createCoupon(Coupon coupon);

    Coupon updateCoupon(Long id, Coupon coupon);

    void deleteCoupon(Long id);

    void disableCoupon(Long id);
}
