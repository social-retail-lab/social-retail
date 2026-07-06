package com.socialretail.backend.common.exception;

import org.springframework.http.HttpStatus;

public class BusinessException extends RuntimeException {

    private final int code;
    private final HttpStatus httpStatus;

    public int getCode() { return code; }
    public HttpStatus getHttpStatus() { return httpStatus; }

    public BusinessException(int code, HttpStatus httpStatus, String message) {
        super(message);
        this.code = code;
        this.httpStatus = httpStatus;
    }

    public BusinessException(String message) {
        super(message);
        this.code = 500;
        this.httpStatus = HttpStatus.INTERNAL_SERVER_ERROR;
    }
}
