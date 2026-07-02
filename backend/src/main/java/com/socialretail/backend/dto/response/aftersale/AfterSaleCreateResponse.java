package com.socialretail.backend.dto.response.aftersale;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.socialretail.backend.enums.aftersale.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;
public record AfterSaleCreateResponse(Long afterSaleId, Long orderId, Long orderItemId,
        AfterSaleType type, BigDecimal refundAmount, AfterSaleStatus status,
        @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8") LocalDateTime applyTime) { }
