package com.socialretail.backend.vo;

import lombok.Data;

import java.math.BigDecimal;

@Data
public class SkuVO {

    private Long skuId;
    private String specs;
    private String specsText;
    private BigDecimal price;
    private Integer stock;
    private String skuCode;
}
