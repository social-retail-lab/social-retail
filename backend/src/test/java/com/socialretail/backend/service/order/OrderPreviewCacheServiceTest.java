package com.socialretail.backend.service.order;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.socialretail.backend.common.exception.BusinessException;
import com.socialretail.backend.dto.request.order.OrderActivityContextRequest;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.data.redis.core.ValueOperations;

import java.time.Duration;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

class OrderPreviewCacheServiceTest {
    private StringRedisTemplate redisTemplate;
    private ValueOperations<String, String> valueOperations;
    private OrderPreviewCacheService service;

    @SuppressWarnings("unchecked")
    @BeforeEach
    void setUp() {
        redisTemplate = mock(StringRedisTemplate.class);
        valueOperations = mock(ValueOperations.class);
        when(redisTemplate.opsForValue()).thenReturn(valueOperations);
        service = new OrderPreviewCacheService(redisTemplate, new ObjectMapper());
    }

    @Test
    void savesUserScopedTokenForFifteenMinutes() {
        OrderPreviewSelection selection = selection();

        String token = service.save(10007L, selection);

        assertEquals(32, token.length());
        verify(valueOperations).set(anyString(), anyString(),
                any(Duration.class));
    }

    @Test
    void missingOrExpiredTokenReturns40961() {
        when(valueOperations.get(anyString())).thenReturn(null);

        BusinessException exception = assertThrows(BusinessException.class,
                () -> service.require(10007L, "expired-token"));

        assertEquals(40961, exception.getCode());
        assertTrue(exception.getMessage().contains("已过期"));
    }

    private OrderPreviewSelection selection() {
        OrderActivityContextRequest activity = new OrderActivityContextRequest();
        activity.setSeckillProductId(9001L);
        return new OrderPreviewSelection(List.of(1001L, 1002L), 1, 4001L, null,
                1L, 7001L, 998, activity, "请尽快配送");
    }
}
