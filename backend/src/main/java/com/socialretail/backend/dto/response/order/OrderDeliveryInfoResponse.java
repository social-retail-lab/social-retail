package com.socialretail.backend.dto.response.order;

import com.fasterxml.jackson.annotation.JsonFormat;
import java.time.LocalDateTime;

public record OrderDeliveryInfoResponse(Long deliveryId, String deliverySn, String status,
                                        String dispatcherName, String dispatcherPhone,
                                        @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
                                        LocalDateTime startTime,
                                        @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
                                        LocalDateTime endTime) { }
