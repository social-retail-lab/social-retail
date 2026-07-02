package com.socialretail.backend.utils;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.socialretail.backend.common.JwtUtils;
import org.junit.jupiter.api.Test;
import org.springframework.test.util.ReflectionTestUtils;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

class JwtUtilTest {

    private static final String SECRET = "unit-test-secret-must-have-at-least-32-bytes";

    @Test
    void generatedTokenCanBeParsed() {
        JwtUtil jwtUtil = new JwtUtil(SECRET, 60_000, new ObjectMapper());

        String token = jwtUtil.generateToken(10001L);

        assertEquals(10001L, jwtUtil.getUserId(token));
        assertEquals(60L, jwtUtil.getExpirationSeconds());
    }

    @Test
    void tamperedTokenIsRejected() {
        JwtUtil jwtUtil = new JwtUtil(SECRET, 60_000, new ObjectMapper());
        String token = jwtUtil.generateToken(10001L);
        int signatureStart = token.lastIndexOf('.') + 1;
        char original = token.charAt(signatureStart);
        char replacement = original == 'a' ? 'b' : 'a';
        String tampered = token.substring(0, signatureStart)
                + replacement
                + token.substring(signatureStart + 1);

        assertThrows(IllegalArgumentException.class, () -> jwtUtil.getUserId(tampered));
    }

    @Test
    void legacyInterceptorCanReadUserToken() {
        JwtUtil jwtUtil = new JwtUtil(SECRET, 60_000, new ObjectMapper());
        JwtUtils legacyJwtUtils = new JwtUtils();
        ReflectionTestUtils.setField(legacyJwtUtils, "secret", SECRET);
        ReflectionTestUtils.setField(legacyJwtUtils, "expiration", 60_000L);

        String token = jwtUtil.generateToken(10001L);

        assertTrue(legacyJwtUtils.validateToken(token));
        assertEquals(10001L, legacyJwtUtils.getUserId(token));
    }
}
