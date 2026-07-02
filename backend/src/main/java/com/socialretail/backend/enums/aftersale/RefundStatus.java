package com.socialretail.backend.enums.aftersale;
public enum RefundStatus {
    NOT_REFUNDED(0), REFUNDING(1), SUCCESS(2), FAILED(3);
    private final int code;
    RefundStatus(int code) { this.code = code; }
    public int getCode() { return code; }
    public static RefundStatus fromCode(Integer code) {
        for (RefundStatus value : values()) if (code != null && value.code == code) return value;
        throw new IllegalArgumentException("未知退款状态: " + code);
    }
}
