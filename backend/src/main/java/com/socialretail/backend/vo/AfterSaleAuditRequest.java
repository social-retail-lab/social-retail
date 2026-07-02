package com.socialretail.backend.vo;

import lombok.Data;

import java.math.BigDecimal;

@Data
public class AfterSaleAuditRequest {
    private Integer action;
    private String remark;
    private BigDecimal actualRefundAmount;
}
