package com.socialretail.backend.vo;

import lombok.Data;

import java.math.BigDecimal;

@Data
public class OrderListVO {
    private Long orderId;
    private String orderSn;
    private BigDecimal totalAmount;
    private BigDecimal payAmount;
    private Integer deliveryType;
    private String deliveryTypeText;
    private Integer status;
    private String statusText;
    private String pickupPointName;
    private String buyerNickname;
    private String buyerPhone;
    private Integer itemCount;
    private String createTime;
}
