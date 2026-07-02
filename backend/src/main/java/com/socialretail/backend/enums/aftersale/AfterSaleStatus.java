package com.socialretail.backend.enums.aftersale;

import java.util.Arrays;

public enum AfterSaleStatus {
    APPLYING(1, "申请中"), APPROVED(2, "审核通过"), REJECTED(3, "审核拒绝"),
    REFUNDING(4, "退款中"), COMPLETED(5, "已完成"), FAILED(6, "退款失败"), CANCELLED(7, "已取消");

    private final int code;
    private final String text;
    AfterSaleStatus(int code, String text) { this.code = code; this.text = text; }
    public int getCode() { return code; }
    public String getText() { return text; }
    public static AfterSaleStatus fromCode(Integer code) {
        return Arrays.stream(values()).filter(value -> code != null && value.code == code).findFirst()
                .orElseThrow(() -> new IllegalArgumentException("未知售后状态: " + code));
    }
}
