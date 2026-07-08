package com.socialretail.backend.common;

import java.util.UUID;

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

    // 别名方法
    public static <T> Result<T> success() {
        return ok();
    }

    public static <T> Result<T> success(T data) {
        return ok(data);
    }

    public static <T> Result<T> success(String message, T data) {
        return ok(message, data);
    }

    public static <T> Result<T> fail(String message) {
        return error(50001, message);
    }

    public int getCode() {
        return code;
    }

    public void setCode(int code) {
        this.code = code;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public T getData() {
        return data;
    }

    public void setData(T data) {
        this.data = data;
    }

    public long getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(long timestamp) {
        this.timestamp = timestamp;
    }

    public String getRequestId() {
        return requestId;
    }

    public void setRequestId(String requestId) {
        this.requestId = requestId;
    }

    @Override
    public String toString() {
        return "Result{" +
            ", code=" + code +
            ", message=" + message +
            ", data=" + data +
            ", timestamp=" + timestamp +
            ", requestId=" + requestId +
            '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Result that = (Result) o;
        return java.util.Objects.equals(code, that.code)
                && java.util.Objects.equals(message, that.message)
                && java.util.Objects.equals(data, that.data)
                && java.util.Objects.equals(timestamp, that.timestamp)
                && java.util.Objects.equals(requestId, that.requestId);
    }

    @Override
    public int hashCode() {
        return java.util.Objects.hash(code, message, data, timestamp, requestId);
    }
}
