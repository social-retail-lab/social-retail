package com.socialretail.backend.vo.payment;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
public class PayOrderStatusVO {
    private Long orderId;
    private String orderSn;
    private Long paymentId;
    private String paySn;
    private String payPlatform;
    private String payStatus;
    private String orderStatus;
    private BigDecimal payAmount;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    private LocalDateTime payTime;
}
