package com.socialretail.backend.vo;

import lombok.Data;

@Data
public class ProductAuditStatusVO {

    private Long productId;
    private String title;
    private Integer auditStatus;
    private String auditStatusText;
    private String auditRemark;
    private String auditTime;
    private String submitTime;
}
