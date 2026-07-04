package com.socialretail.backend.vo;

import lombok.Data;

import java.math.BigDecimal;

@Data
public class PickupRecordVO {
    private Long orderId;
    private String orderSn;
    private String pickupCode;
    private String pickupPointName;
    private String buyerNickname;
    private BigDecimal totalAmount;
    private String verifyTime;
}
