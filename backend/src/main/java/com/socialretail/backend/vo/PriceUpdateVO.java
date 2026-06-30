package com.socialretail.backend.vo;

import lombok.Data;

import java.math.BigDecimal;

@Data
public class PriceUpdateVO {

    private Long skuId;
    private BigDecimal oldPrice;
    private BigDecimal newPrice;
}
