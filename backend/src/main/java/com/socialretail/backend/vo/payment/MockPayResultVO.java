package com.socialretail.backend.vo.payment;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;

import java.time.LocalDateTime;

@Data
public class MockPayResultVO {
    private Long orderId;
    private String orderSn;
    private Long paymentId;
    private String paySn;
    private String payStatus;
    private String orderStatus;
    private Integer deliveryType;
    private Long pickupPointId;
    private String pickupCode;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    private LocalDateTime payTime;
    private String failReason;
}
