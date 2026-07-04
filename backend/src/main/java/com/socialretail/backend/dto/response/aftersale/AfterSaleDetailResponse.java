package com.socialretail.backend.dto.response.aftersale;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.socialretail.backend.enums.aftersale.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
public record AfterSaleDetailResponse(Long afterSaleId, Long orderId, String orderSn, Long orderItemId,
        String productName, String productImage, String skuSpecs, AfterSaleType type,
        BigDecimal refundAmount, BigDecimal actualRefundAmount, String reason, List<String> evidenceImages,
        AfterSaleStatus status, String statusText, AuditStatus auditStatus, RefundStatus refundStatus,
        String auditRemark, String rejectReason,
        @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8") LocalDateTime applyTime,
        @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8") LocalDateTime handleTime,
        @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8") LocalDateTime completeTime) { }
