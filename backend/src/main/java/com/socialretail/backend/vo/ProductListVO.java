package com.socialretail.backend.vo;

import lombok.Data;

import java.math.BigDecimal;

@Data
public class ProductListVO {

    private Long productId;
    private String title;
    private String mainImage;
    private BigDecimal minPrice;
    private BigDecimal maxPrice;
    private Integer totalStock;
    private Integer auditStatus;
    private String auditStatusText;
    private Integer status;
    private String statusText;
    private String createTime;
}
