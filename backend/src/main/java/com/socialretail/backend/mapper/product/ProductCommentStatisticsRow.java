package com.socialretail.backend.mapper.product;

import lombok.Data;

import java.math.BigDecimal;

@Data
public class ProductCommentStatisticsRow {
    private BigDecimal ratingScore;
    private Long commentCount;
}
