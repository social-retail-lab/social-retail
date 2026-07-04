package com.socialretail.backend.dto.response.order;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Data
public class OrderSummaryResponse {
    private Long orderId;
    private String orderSn;
    private Long merchantId;
    private Integer status;
    private String statusText;
    private BigDecimal totalAmount;
    private BigDecimal payAmount;
    private Integer deliveryType;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    private LocalDateTime createTime;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    private LocalDateTime payExpireTime;
    private List<OrderItemResponse> itemList;
}
