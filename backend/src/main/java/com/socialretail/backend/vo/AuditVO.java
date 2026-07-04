package com.socialretail.backend.vo;

import lombok.Data;

@Data
public class AuditVO {

    private Long applyId;
    private Long productId;
    private Integer auditStatus;
    private String auditStatusText;
    private Long merchantId;
}
