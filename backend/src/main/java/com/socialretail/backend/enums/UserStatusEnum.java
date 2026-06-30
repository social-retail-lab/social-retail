package com.socialretail.backend.enums;

public enum UserStatusEnum {

    DISABLED(0),
    NORMAL(1);

    private final int code;

    UserStatusEnum(int code) {
        this.code = code;
    }

    public int getCode() {
        return code;
    }

    public static String nameOf(Integer code) {
        // 兼容旧表 status 默认值为 NULL 的数据。
        if (code == null) {
            return NORMAL.name();
        }
        if (code != null) {
            for (UserStatusEnum status : values()) {
                if (status.code == code) {
                    return status.name();
                }
            }
        }
        return DISABLED.name();
    }
}
