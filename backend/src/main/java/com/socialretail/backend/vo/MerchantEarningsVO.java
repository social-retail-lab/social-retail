package com.socialretail.backend.vo;

import lombok.Data;

import java.math.BigDecimal;

@Data
public class MerchantEarningsVO {
    private Long earningsId;
    private String orderSn;
    private BigDecimal amount;
    private Integer status;
    private String statusText;
    private String freezeTime;
    private String unfreezeTime;
    private String createTime;
}
