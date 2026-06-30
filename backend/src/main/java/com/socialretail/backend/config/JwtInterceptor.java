package com.socialretail.backend.config;

import com.socialretail.backend.common.exception.BusinessException;
import com.socialretail.backend.utils.JwtUtil;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.HandlerInterceptor;

@Component
public class JwtInterceptor implements HandlerInterceptor {

    public static final String USER_ID_ATTRIBUTE = "userId";
    private static final String BEARER_PREFIX = "Bearer ";

    private final JwtUtil jwtUtil;

    public JwtInterceptor(JwtUtil jwtUtil) {
        this.jwtUtil = jwtUtil;
    }

    @Override
    public boolean preHandle(HttpServletRequest request,
                             HttpServletResponse response,
                             Object handler) {
        if (HttpMethod.OPTIONS.matches(request.getMethod()) || !(handler instanceof HandlerMethod)) {
            return true;
        }

        String authorization = request.getHeader("Authorization");
        if (authorization == null || !authorization.startsWith(BEARER_PREFIX)) {
            throw unauthorized("未登录或Authorization请求头格式错误");
        }

        String token = authorization.substring(BEARER_PREFIX.length()).trim();
        try {
            request.setAttribute(USER_ID_ATTRIBUTE, jwtUtil.getUserId(token));
            return true;
        } catch (IllegalArgumentException exception) {
            throw unauthorized("Token无效或已过期");
        }
    }

    private BusinessException unauthorized(String message) {
        return new BusinessException(40101, HttpStatus.UNAUTHORIZED, message);
    }
}
