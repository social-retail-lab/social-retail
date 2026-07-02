package com.socialretail.backend.infrastructure.pay.refund;

public record AliPayRefundResult(boolean success, String tradeNo, String message) {
    public static AliPayRefundResult success(String tradeNo) {
        return new AliPayRefundResult(true, tradeNo, "支付宝沙箱退款成功");
    }
    public static AliPayRefundResult fail(String message) {
        return new AliPayRefundResult(false, null, message);
    }
}
