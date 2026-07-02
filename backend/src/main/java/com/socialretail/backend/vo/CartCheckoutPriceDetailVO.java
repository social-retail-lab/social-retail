package com.socialretail.backend.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CartCheckoutPriceDetailVO {
    private BigDecimal originalAmount;
    private BigDecimal seckillDiscount;
    private BigDecimal bargainDiscount;
    private BigDecimal promotionDiscount;
    private BigDecimal couponDiscount;
    private BigDecimal pointsDeduction;
    private BigDecimal deliveryFee;
    private BigDecimal payableAmount;
}
