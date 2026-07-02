package com.socialretail.backend.enums.aftersale;
public enum AuditStatus {
    PENDING(0), APPROVED(1), REJECTED(2);
    private final int code;
    AuditStatus(int code) { this.code = code; }
    public int getCode() { return code; }
    public static AuditStatus fromCode(Integer code) {
        for (AuditStatus value : values()) if (code != null && value.code == code) return value;
        throw new IllegalArgumentException("未知审核状态: " + code);
    }
}
