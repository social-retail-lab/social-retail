package com.socialretail.backend.utils;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;
import java.security.GeneralSecurityException;
import java.security.MessageDigest;
import java.util.Base64;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * 基于 HMAC-SHA256 的 JWT 生成与校验工具。
 */
@Component
public class JwtUtil {

    private static final String HMAC_SHA_256 = "HmacSHA256";
    private static final String JWT_HEADER = "{\"alg\":\"HS256\",\"typ\":\"JWT\"}";
    private static final TypeReference<Map<String, Object>> MAP_TYPE = new TypeReference<>() {
    };

    private final byte[] secret;
    private final long expirationMillis;
    private final ObjectMapper objectMapper;

    public JwtUtil(@Value("${jwt.secret}") String secret,
                   @Value("${jwt.expiration-millis:604800000}") long expirationMillis,
                   ObjectMapper objectMapper) {
        byte[] secretBytes = secret.getBytes(StandardCharsets.UTF_8);
        if (secretBytes.length < 32) {
            throw new IllegalArgumentException("jwt.secret 至少需要 32 字节");
        }
        if (expirationMillis <= 0) {
            throw new IllegalArgumentException("jwt.expiration-millis 必须大于 0");
        }
        this.secret = secretBytes;
        this.expirationMillis = expirationMillis;
        this.objectMapper = objectMapper;
    }

    public String generateToken(Long userId) {
        if (userId == null) {
            throw new IllegalArgumentException("userId 不能为空");
        }

        long issuedAt = System.currentTimeMillis() / 1000;
        long expiresAt = (System.currentTimeMillis() + expirationMillis) / 1000;
        Map<String, Object> payload = new LinkedHashMap<>();
        payload.put("sub", userId.toString());
        payload.put("iat", issuedAt);
        payload.put("exp", expiresAt);

        try {
            String header = encode(JWT_HEADER.getBytes(StandardCharsets.UTF_8));
            String body = encode(objectMapper.writeValueAsBytes(payload));
            String unsignedToken = header + "." + body;
            return unsignedToken + "." + encode(sign(unsignedToken));
        } catch (Exception exception) {
            throw new IllegalStateException("Token 生成失败", exception);
        }
    }

    public Map<String, Object> parseToken(String token) {
        try {
            if (token == null || token.isBlank()) {
                throw new IllegalArgumentException("Token 不能为空");
            }
            String[] parts = token.split("\\.", -1);
            if (parts.length != 3) {
                throw new IllegalArgumentException("Token 格式错误");
            }

            Map<String, Object> header = readPart(parts[0]);
            if (!"HS256".equals(header.get("alg"))) {
                throw new IllegalArgumentException("不支持的 Token 签名算法");
            }

            byte[] expectedSignature = sign(parts[0] + "." + parts[1]);
            byte[] actualSignature = Base64.getUrlDecoder().decode(parts[2]);
            if (!MessageDigest.isEqual(expectedSignature, actualSignature)) {
                throw new IllegalArgumentException("Token 签名无效");
            }

            Map<String, Object> payload = readPart(parts[1]);
            Object expiresAt = payload.get("exp");
            if (!(expiresAt instanceof Number)
                    || System.currentTimeMillis() / 1000 >= ((Number) expiresAt).longValue()) {
                throw new IllegalArgumentException("Token 已过期");
            }
            return Collections.unmodifiableMap(payload);
        } catch (IllegalArgumentException exception) {
            throw exception;
        } catch (Exception exception) {
            throw new IllegalArgumentException("Token 无效", exception);
        }
    }

    public Long getUserId(String token) {
        Object subject = parseToken(token).get("sub");
        if (subject == null) {
            throw new IllegalArgumentException("Token 缺少用户标识");
        }
        try {
            return Long.valueOf(subject.toString());
        } catch (NumberFormatException exception) {
            throw new IllegalArgumentException("Token 用户标识无效", exception);
        }
    }

    public long getExpirationSeconds() {
        return expirationMillis / 1000;
    }

    private Map<String, Object> readPart(String part) throws Exception {
        return objectMapper.readValue(Base64.getUrlDecoder().decode(part), MAP_TYPE);
    }

    private byte[] sign(String value) throws GeneralSecurityException {
        Mac mac = Mac.getInstance(HMAC_SHA_256);
        mac.init(new SecretKeySpec(secret, HMAC_SHA_256));
        return mac.doFinal(value.getBytes(StandardCharsets.US_ASCII));
    }

    private String encode(byte[] value) {
        return Base64.getUrlEncoder().withoutPadding().encodeToString(value);
    }
}
