package com.socialretail.backend.interceptor;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.socialretail.backend.common.JwtUtils;
import com.socialretail.backend.common.Result;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import java.io.IOException;
import java.util.Set;

@Component
public class AuthInterceptor implements HandlerInterceptor {

    private final JwtUtils jwtUtils;

    private static final Set<String> WHITELIST = Set.of(
            "/api/merchant/auth/login",
            "/api/admin/operation/auth/login",
            "/api/admin/system/auth/login"
    );

    public AuthInterceptor(JwtUtils jwtUtils) {
        this.jwtUtils = jwtUtils;
    }

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        String path = request.getRequestURI();

        // Allow OPTIONS requests (CORS preflight)
        if ("OPTIONS".equalsIgnoreCase(request.getMethod())) {
            return true;
        }

        // Allow whitelist paths (no token needed)
        if (WHITELIST.contains(path)) {
            return true;
        }

        // Get Authorization header
        String header = request.getHeader("Authorization");
        if (header == null || header.isEmpty() || !header.startsWith("Bearer ")) {
            sendErrorResponse(response, 40101, "未登录或登录已过期");
            return false;
        }

        // Extract token
        String token = header.substring(7);

        // Validate token
        if (!jwtUtils.validateToken(token)) {
            sendErrorResponse(response, 40101, "未登录或登录已过期");
            return false;
        }

        // Set request attributes
        request.setAttribute("token", token);
        request.setAttribute("userId", jwtUtils.getUserId(token));
        request.setAttribute("merchantId", jwtUtils.getMerchantId(token));
        request.setAttribute("adminId", jwtUtils.getAdminId(token));
        request.setAttribute("userType", jwtUtils.getUserType(token));

        return true;
    }

    private void sendErrorResponse(HttpServletResponse response, int code, String message) throws IOException {
        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        response.setContentType("application/json;charset=UTF-8");
        Result<?> result = Result.error(code, message);
        response.getWriter().write(new ObjectMapper().writeValueAsString(result));
    }
}
