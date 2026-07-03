package com.socialretail.backend.dto.response.order;

import com.fasterxml.jackson.annotation.JsonFormat;
import java.time.LocalDateTime;

public record OrderPaymentInfoResponse(Long paymentId, String paySn, String payPlatform,
                                       String status,
                                       @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
                                       LocalDateTime payTime) { }
