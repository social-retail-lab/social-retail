package com.socialretail.backend.service.order;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.socialretail.backend.common.exception.BusinessException;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import java.time.Duration;
import java.util.Map;
import java.util.UUID;

@Service
public class OrderPreviewCacheService {
    public static final long EXPIRE_SECONDS = 15 * 60;
    private static final String KEY_PREFIX = "order:preview:";

    private final StringRedisTemplate redisTemplate;
    private final ObjectMapper objectMapper;

    public OrderPreviewCacheService(StringRedisTemplate redisTemplate, ObjectMapper objectMapper) {
        this.redisTemplate = redisTemplate;
        this.objectMapper = objectMapper;
    }

    public String save(Long userId, OrderPreviewSelection selection) {
        String token = UUID.randomUUID().toString().replace("-", "");
        try {
            redisTemplate.opsForValue().set(key(userId, token),
                    objectMapper.writeValueAsString(selection), Duration.ofSeconds(EXPIRE_SECONDS));
            return token;
        } catch (JsonProcessingException | RuntimeException exception) {
            throw new BusinessException(50301, HttpStatus.SERVICE_UNAVAILABLE,
                    "订单预览状态保存失败，请稍后重试");
        }
    }

    public OrderPreviewSelection require(Long userId, String token) {
        String normalized = token == null ? "" : token.trim();
        String json;
        try {
            json = redisTemplate.opsForValue().get(key(userId, normalized));
        } catch (RuntimeException exception) {
            throw new BusinessException(50301, HttpStatus.SERVICE_UNAVAILABLE,
                    "订单预览状态读取失败，请稍后重试");
        }
        if (json == null || json.isBlank()) {
            throw expired(normalized);
        }
        try {
            return objectMapper.readValue(json, OrderPreviewSelection.class);
        } catch (JsonProcessingException exception) {
            throw expired(normalized);
        }
    }

    private String key(Long userId, String token) {
        return KEY_PREFIX + userId + ":" + token;
    }

    private BusinessException expired(String token) {
        return new BusinessException(40961, HttpStatus.CONFLICT,
                "订单预览已过期，请重新预览", Map.of("previewToken", token));
    }
}
