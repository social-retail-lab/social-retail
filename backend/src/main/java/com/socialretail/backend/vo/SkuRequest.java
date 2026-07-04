package com.socialretail.backend.vo;

import lombok.Data;

import java.math.BigDecimal;

@Data
public class SkuRequest {

    private String specs;
    private BigDecimal price;
    private Integer stock;
    private String skuCode;
}
