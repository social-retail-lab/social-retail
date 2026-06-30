package com.socialretail.backend.handler;

import com.socialretail.backend.common.Result;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.method.annotation.MethodArgumentTypeMismatchException;

@Slf4j
@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(RuntimeException.class)
    public Result<?> handleRuntimeException(RuntimeException e) {
        log.warn("[全局异常] 业务异常: {}", e.getMessage());
        return Result.error(50001, e.getMessage());
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public Result<?> handleMethodArgumentNotValid(MethodArgumentNotValidException e) {
        String message = e.getBindingResult().getFieldErrors().stream()
                .findFirst()
                .map(fieldError -> fieldError.getField() + ": " + fieldError.getDefaultMessage())
                .orElse("参数校验失败");
        log.warn("[全局异常] 参数校验失败: {}", message);
        return Result.error(40001, message);
    }

    @ExceptionHandler(MethodArgumentTypeMismatchException.class)
    public Result<?> handleBindException(MethodArgumentTypeMismatchException e) {
        log.warn("[全局异常] 参数类型错误: {} - {}", e.getName(), e.getValue());
        return Result.error(40001, "参数类型错误");
    }

    @ExceptionHandler(Exception.class)
    public Result<?> handleException(Exception e) {
        log.error("[全局异常] 系统内部错误", e);
        return Result.error(50001, "系统内部错误");
    }
}
