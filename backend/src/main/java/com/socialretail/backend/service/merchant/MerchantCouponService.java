package com.socialretail.backend.service.merchant;

import com.socialretail.backend.entity.promotion.MerchantCoupon;
import java.util.List;
import java.util.Map;
import java.math.BigDecimal;

public interface MerchantCouponService {
    // 商家管理自己的优惠卷
    MerchantCoupon createCoupon(Long merchantId, MerchantCoupon coupon, List<Map<String, BigDecimal>> tiers);
    List<MerchantCoupon> listCoupons(Long merchantId);
    MerchantCoupon updateCoupon(Long merchantId, Long couponId, MerchantCoupon coupon);
    void disableCoupon(Long merchantId, Long couponId);
    void enableCoupon(Long merchantId, Long couponId);
}
