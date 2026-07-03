package com.socialretail.backend.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CouponBundleVO {
    private CouponOptionVO platformCoupon;
    private CouponOptionVO merchantCoupon;
}
