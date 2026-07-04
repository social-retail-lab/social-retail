package com.socialretail.backend.vo;

import lombok.Data;

import java.math.BigDecimal;

@Data
public class WithdrawalRecordVO {
    private Long withdrawalId;
    private BigDecimal amount;
    private String bankCardNumber;
    private String accountName;
    private String bankName;
    private Integer status;
    private String statusText;
    private String applyTime;
    private String processTime;
}
