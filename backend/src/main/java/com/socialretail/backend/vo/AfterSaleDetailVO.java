package com.socialretail.backend.vo;

import lombok.Data;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

@Data
public class AfterSaleDetailVO {
    private Long afterSaleId;
    private String orderSn;
    private Long orderItemId;
    private String productName;
    private String skuSpecs;
    private Integer type;
    private String typeText;
    private BigDecimal refundAmount;
    private String reason;
    private Object evidenceImages;
    private Integer status;
    private String statusText;
    private String applyTime;
    private String buyerNickname;
    private String buyerPhone;
    private List<Map<String, Object>> statusTimeline;
}
