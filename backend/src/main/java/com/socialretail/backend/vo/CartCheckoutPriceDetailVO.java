package com.socialretail.backend.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CartCheckoutPriceDetailVO {
    private BigDecimal totalAmount;
    private BigDecimal seckillDiscount;
    private BigDecimal bargainDiscount;
    private BigDecimal promotionDiscount;
    private BigDecimal merchantCouponDiscount;
    private BigDecimal platformCouponDiscount;
    private BigDecimal pointsDeduction;
    private BigDecimal deliveryFee;
    private BigDecimal payAmount;
}
