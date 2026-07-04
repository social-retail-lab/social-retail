package com.socialretail.backend.common.exception;

import org.springframework.http.HttpStatus;

/**
 * 携带业务错误码和 HTTP 状态码的可预期异常。
 */
public class BusinessException extends RuntimeException {

    private final int code;
    private final HttpStatus httpStatus;
    private final Object data;

    public BusinessException(int code, HttpStatus httpStatus, String message) {
        this(code, httpStatus, message, null);
    }

    public BusinessException(int code, HttpStatus httpStatus, String message, Object data) {
        super(message);
        if (code == 0) {
            throw new IllegalArgumentException("业务异常 code 不能为 0");
        }
        this.code = code;
        this.httpStatus = httpStatus;
        this.data = data;
    }

    public int getCode() {
        return code;
    }

    public HttpStatus getHttpStatus() {
        return httpStatus;
    }

    public Object getData() {
        return data;
    }
}
