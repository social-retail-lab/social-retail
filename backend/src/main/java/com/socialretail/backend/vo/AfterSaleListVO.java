package com.socialretail.backend.vo;

import lombok.Data;

import java.math.BigDecimal;

@Data
public class AfterSaleListVO {
    private Long afterSaleId;
    private String orderSn;
    private Long orderItemId;
    private String productName;
    private Integer type;
    private String typeText;
    private BigDecimal refundAmount;
    private String reason;
    private Integer status;
    private String statusText;
    private String applyTime;
    private String buyerNickname;
}
