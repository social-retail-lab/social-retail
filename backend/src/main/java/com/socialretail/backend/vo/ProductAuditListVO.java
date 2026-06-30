package com.socialretail.backend.vo;

import lombok.Data;

import java.math.BigDecimal;

@Data
public class ProductAuditListVO {

    private Long productId;
    private String title;
    private String mainImage;
    private String merchantName;
    private BigDecimal minPrice;
    private Integer auditStatus;
    private String auditStatusText;
    private String submitTime;
}
