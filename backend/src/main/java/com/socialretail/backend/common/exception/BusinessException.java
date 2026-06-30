package com.socialretail.backend.common.exception;

import org.springframework.http.HttpStatus;

/**
 * 携带业务错误码和 HTTP 状态码的可预期异常。
 */
public class BusinessException extends RuntimeException {

    private final int code;
    private final HttpStatus httpStatus;

    public BusinessException(int code, HttpStatus httpStatus, String message) {
        super(message);
        if (code == 0) {
            throw new IllegalArgumentException("业务异常 code 不能为 0");
        }
        this.code = code;
        this.httpStatus = httpStatus;
    }

    public int getCode() {
        return code;
    }

    public HttpStatus getHttpStatus() {
        return httpStatus;
    }
}
