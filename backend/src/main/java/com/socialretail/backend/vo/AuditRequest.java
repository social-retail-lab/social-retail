package com.socialretail.backend.vo;

import lombok.Data;

@Data
public class AuditRequest {

    private Integer auditStatus;
    private String auditRemark;
}
