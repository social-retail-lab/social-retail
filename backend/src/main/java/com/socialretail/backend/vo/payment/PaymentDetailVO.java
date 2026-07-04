package com.socialretail.backend.vo.payment;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
public class PaymentDetailVO {
    private Long paymentId;
    private Long orderId;
    private String orderSn;
    private String paySn;
    private String thirdTradeNo;
    private String payPlatform;
    private BigDecimal amount;
    private String status;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    private LocalDateTime payTime;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    private LocalDateTime callbackTime;
    private String failReason;
    private String refundStatus;
    private BigDecimal refundAmount;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    private LocalDateTime refundTime;
}
