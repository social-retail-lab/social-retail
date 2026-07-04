package com.socialretail.backend.dto.response.aftersale;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.socialretail.backend.enums.aftersale.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;
public record AfterSaleListItemResponse(Long afterSaleId, Long orderId, String orderSn,
        Long orderItemId, String productName, String productImage, AfterSaleType type,
        BigDecimal refundAmount, AfterSaleStatus status, String statusText,
        @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8") LocalDateTime applyTime) { }
