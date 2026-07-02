package com.socialretail.backend.entity;

import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
public class Payment {
    private Long id;
    private Long orderId;
    private String paySn;
    private String thirdTradeNo;
    private Integer payPlatform;
    private BigDecimal amount;
    private Integer status;
    private LocalDateTime payTime;
    private LocalDateTime callbackTime;
    private String failReason;
    private Integer refundStatus;
    private BigDecimal refundAmount;
    private LocalDateTime refundTime;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
}
