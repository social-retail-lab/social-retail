package com.socialretail.backend.common;

import lombok.Data;
import java.util.UUID;

@Data
public class Result<T> {
    private int code;
    private String message;
    private T data;
    private long timestamp;
    private String requestId;

    private Result() {}

    public static <T> Result<T> ok() {
        Result<T> r = new Result<>();
        r.code = 0;
        r.message = "success";
        r.data = null;
        r.timestamp = System.currentTimeMillis();
        r.requestId = "req-" + UUID.randomUUID().toString().substring(0, 8);
        return r;
    }

    public static <T> Result<T> ok(T data) {
        Result<T> r = ok();
        r.data = data;
        return r;
    }

    public static <T> Result<T> ok(String message, T data) {
        Result<T> r = ok(data);
        r.message = message;
        return r;
    }

    public static <T> Result<T> error(int code, String message) {
        Result<T> r = new Result<>();
        r.code = code;
        r.message = message;
        r.data = null;
        r.timestamp = System.currentTimeMillis();
        r.requestId = "req-" + UUID.randomUUID().toString().substring(0, 8);
        return r;
    }

    public static <T> Result<T> error(String message) {
        return error(50001, message);
    }
}
