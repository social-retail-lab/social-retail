package com.socialretail.backend.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class AvailableCouponGroupsVO {
    private List<CouponOptionVO> platformCoupons;
    private List<CouponOptionVO> merchantCoupons;
}
