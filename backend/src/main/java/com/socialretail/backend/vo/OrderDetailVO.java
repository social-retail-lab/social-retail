package com.socialretail.backend.vo;

import lombok.Data;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

@Data
public class OrderDetailVO {
    private Long orderId;
    private String orderSn;
    private BigDecimal totalAmount;
    private BigDecimal payAmount;
    private BigDecimal discountAmount;
    private Integer deliveryType;
    private String deliveryTypeText;
    private Integer status;
    private String statusText;
    private Object pickupPoint;
    private Object address;
    private Object items;
    private Object payment;
    private List<Map<String, Object>> statusTimeline;
    private String createTime;
}
