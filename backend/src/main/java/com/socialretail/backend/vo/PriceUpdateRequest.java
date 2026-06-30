package com.socialretail.backend.vo;

import lombok.Data;

import java.math.BigDecimal;

@Data
public class PriceUpdateRequest {

    private BigDecimal price;
}
