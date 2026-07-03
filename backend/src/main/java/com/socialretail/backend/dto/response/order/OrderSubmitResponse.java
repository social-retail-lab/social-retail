package com.socialretail.backend.dto.response.order;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonInclude;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class OrderSubmitResponse {
    private Long orderId;
    private String orderSn;
    private Integer status;
    private String statusText;
    private BigDecimal payAmount;
    private BigDecimal totalAmount;
    private BigDecimal seckillDiscount;
    private BigDecimal bargainDiscount;
    private BigDecimal promotionDiscount;
    private BigDecimal merchantCouponDiscount;
    private BigDecimal platformCouponDiscount;
    private BigDecimal pointsDeduction;
    private BigDecimal deliveryFee;
    @JsonInclude(JsonInclude.Include.NON_NULL)
    private Boolean idempotent;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    private LocalDateTime expireTime;
}
