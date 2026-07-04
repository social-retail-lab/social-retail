package com.socialretail.backend.infrastructure.pay.refund.impl;

import com.socialretail.backend.infrastructure.pay.refund.AliPayRefundResult;
import com.socialretail.backend.infrastructure.pay.refund.AliPayRefundService;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;

@Service
public class MockAliPayRefundService implements AliPayRefundService {
    private final boolean forceFail;
    private final ConcurrentMap<String, AliPayRefundResult> results = new ConcurrentHashMap<>();

    public MockAliPayRefundService(
            @Value("${after-sale.alipay.mock-force-fail:false}") boolean forceFail) {
        this.forceFail = forceFail;
    }

    @Override
    public AliPayRefundResult refund(Long orderId, BigDecimal refundAmount) {
        String idempotencyKey = orderId + ":" + refundAmount.stripTrailingZeros().toPlainString();
        return results.computeIfAbsent(idempotencyKey, ignored -> executeRefund(orderId, refundAmount));
    }

    @Async
    @Override
    public CompletableFuture<AliPayRefundResult> refundAsync(Long orderId, BigDecimal refundAmount) {
        return CompletableFuture.completedFuture(refund(orderId, refundAmount));
    }

    private AliPayRefundResult executeRefund(Long orderId, BigDecimal refundAmount) {
        if (orderId == null || refundAmount == null || refundAmount.signum() <= 0) {
            return AliPayRefundResult.fail("支付宝沙箱拒绝了无效退款参数");
        }
        if (forceFail) {
            return AliPayRefundResult.fail("支付宝沙箱模拟退款失败");
        }
        return AliPayRefundResult.success("MOCK-ALI-REFUND-" + orderId);
    }
}
