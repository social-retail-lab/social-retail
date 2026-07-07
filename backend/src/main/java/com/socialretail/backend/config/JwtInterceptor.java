package com.socialretail.backend.config;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.socialretail.backend.common.JwtUtils;
import com.socialretail.backend.common.result.Result;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.http.HttpMethod;
import org.springframework.stereotype.Component;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.HandlerInterceptor;

import java.io.IOException;
import java.util.Set;

@Component
public class JwtInterceptor implements HandlerInterceptor {

    public static final String USER_ID_ATTRIBUTE = "userId";
    public static final String MERCHANT_ID_ATTRIBUTE = "merchantId";
    public static final String ADMIN_ID_ATTRIBUTE = "adminId";
    public static final String USER_TYPE_ATTRIBUTE = "userType";

    private static final String BEARER_PREFIX = "Bearer ";

    private static final Set<String> WHITELIST = Set.of(
            "/api/merchant/auth/login",
            "/api/admin/operation/auth/login",
            "/api/admin/system/auth/login",
            "/api/auth/login",
            "/api/auth/register",
            "/api/user/sms/send",
            "/api/pay/alipay/notify"
    );

    private final JwtUtils jwtUtils;

    public JwtInterceptor(JwtUtils jwtUtils) {
        this.jwtUtils = jwtUtils;
    }

    @Override
    public boolean preHandle(HttpServletRequest request,
                             HttpServletResponse response,
                             Object handler) throws Exception {
        // Allow OPTIONS (CORS preflight)
        if (HttpMethod.OPTIONS.matches(request.getMethod())) {
            return true;
        }

        String path = request.getRequestURI();

        // Allow whitelist
        if (WHITELIST.contains(path)) {
            return true;
        }

        // 商品评价列表无需登录，评价详情支持可选登录。若携带 token，仍继续解析，
        // 以便详情接口判断当前用户是否为评价发布者。
        boolean optionalAuthPath = isOptionalCommentRead(request.getMethod(), path);

        // Get Authorization header
        String header = request.getHeader("Authorization");
        if (optionalAuthPath && (header == null || header.isBlank())) {
            return true;
        }
        if (header == null || header.isEmpty() || !header.startsWith(BEARER_PREFIX)) {
            sendErrorResponse(response, 40100, "用户未登录或登录已过期");
            return false;
        }

        String token = header.substring(BEARER_PREFIX.length()).trim();

        // Validate token
        if (!jwtUtils.validateToken(token)) {
            sendErrorResponse(response, 40100, "用户未登录或登录已过期");
            return false;
        }

        // Set request attributes by userType
        String userType = jwtUtils.getUserType(token);
        request.setAttribute(USER_ID_ATTRIBUTE, jwtUtils.getUserId(token));
        request.setAttribute(USER_TYPE_ATTRIBUTE, userType);

        if ("merchant".equals(userType)) {
            request.setAttribute(MERCHANT_ID_ATTRIBUTE, jwtUtils.getMerchantId(token));
        } else if ("admin".equals(userType)) {
            request.setAttribute(ADMIN_ID_ATTRIBUTE, jwtUtils.getAdminId(token));
        }

        return true;
    }

    private boolean isOptionalCommentRead(String method, String path) {
        if (!HttpMethod.GET.matches(method)) {
            return false;
        }
        return path.matches("/api/products/\\d+/comments")
                || path.matches("/api/comments/\\d+");
    }

    private void sendErrorResponse(HttpServletResponse response, int code, String message) throws IOException {
        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        response.setContentType("application/json;charset=UTF-8");
        Result<?> result = Result.error(code, message);
        response.getWriter().write(new ObjectMapper().writeValueAsString(result));
    }
}
