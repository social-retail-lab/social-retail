package com.socialretail.backend.vo;

import lombok.AllArgsConstructor;
import lombok.Data;

import java.math.BigDecimal;

@Data
@AllArgsConstructor
public class PromotionOptionVO {
    private Long promotionId;
    private String title;
    private BigDecimal minAmount;
    private BigDecimal discountAmount;
    private Boolean selected;
}
