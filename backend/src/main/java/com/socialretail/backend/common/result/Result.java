package com.socialretail.backend.common.result;

import org.springframework.web.context.request.RequestAttributes;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import java.util.UUID;

/**
 * API 统一响应对象。
 *
 * @param <T> data 字段的数据类型
 */
public class Result<T> {

    public static final int SUCCESS_CODE = 0;
    public static final int DEFAULT_ERROR_CODE = 50001;

    private static final String SUCCESS_MESSAGE = "success";
    private static final String REQUEST_ID_HEADER = "X-Request-Id";

    private Integer code;
    private String message;
    private T data;
    private Long timestamp;
    private String requestId;

    public Result() {
        this.timestamp = System.currentTimeMillis();
        this.requestId = resolveRequestId();
    }

    public Result(Integer code, String message, T data) {
        this(code, message, data, System.currentTimeMillis(), resolveRequestId());
    }

    public Result(Integer code, String message, T data, Long timestamp, String requestId) {
        this.code = code;
        this.message = message;
        this.data = data;
        this.timestamp = timestamp;
        this.requestId = requestId;
    }

    /**
     * 创建无返回数据的成功响应。
     */
    public static Result<Void> success() {
        return new Result<>(SUCCESS_CODE, SUCCESS_MESSAGE, null);
    }

    public static <T> Result<T> success(T data) {
        return new Result<>(SUCCESS_CODE, SUCCESS_MESSAGE, data);
    }

    public static <T> Result<T> success(String message, T data) {
        return new Result<>(SUCCESS_CODE, message, data);
    }

    public static <T> Result<T> fail(String message) {
        return fail(DEFAULT_ERROR_CODE, message);
    }

    public static <T> Result<T> fail(Integer code, String message) {
        if (code == null || code == SUCCESS_CODE) {
            throw new IllegalArgumentException("失败响应的 code 必须为非 0 整数");
        }
        return new Result<>(code, message, null);
    }

    public static <T> Result<T> error(String message) {
        return fail(message);
    }

    public static <T> Result<T> error(Integer code, String message) {
        return fail(code, message);
    }

    public Integer getCode() {
        return code;
    }

    public void setCode(Integer code) {
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

    public Long getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(Long timestamp) {
        this.timestamp = timestamp;
    }

    public String getRequestId() {
        return requestId;
    }

    public void setRequestId(String requestId) {
        this.requestId = requestId;
    }

    private static String resolveRequestId() {
        RequestAttributes attributes = RequestContextHolder.getRequestAttributes();
        if (attributes instanceof ServletRequestAttributes servletRequestAttributes) {
            String requestId = servletRequestAttributes.getRequest().getHeader(REQUEST_ID_HEADER);
            if (requestId != null && !requestId.isBlank()) {
                return requestId;
            }
        }
        return "req-" + UUID.randomUUID();
    }
}
