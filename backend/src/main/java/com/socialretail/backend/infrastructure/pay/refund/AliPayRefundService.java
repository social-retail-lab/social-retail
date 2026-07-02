package com.socialretail.backend.infrastructure.pay.refund;

import java.math.BigDecimal;
import java.util.concurrent.CompletableFuture;

public interface AliPayRefundService {
    AliPayRefundResult refund(Long orderId, BigDecimal refundAmount);
    CompletableFuture<AliPayRefundResult> refundAsync(Long orderId, BigDecimal refundAmount);
}
