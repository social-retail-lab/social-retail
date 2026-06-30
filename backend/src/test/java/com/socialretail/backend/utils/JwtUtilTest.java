package com.socialretail.backend.utils;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;

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
}
