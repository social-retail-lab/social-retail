package com.socialretail.backend.enums.aftersale;
public enum AfterSaleType {
    REFUND_ONLY(1), RETURN_REFUND(2);
    private final int code;
    AfterSaleType(int code) { this.code = code; }
    public int getCode() { return code; }
    public static AfterSaleType fromCode(Integer code) {
        for (AfterSaleType value : values()) if (code != null && value.code == code) return value;
        throw new IllegalArgumentException("未知售后类型: " + code);
    }
}
