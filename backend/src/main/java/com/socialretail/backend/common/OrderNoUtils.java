package com.socialretail.backend.common;

import java.security.SecureRandom;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public final class OrderNoUtils {
    private static final DateTimeFormatter FORMATTER = DateTimeFormatter.ofPattern("yyyyMMddHHmmssSSS");
    private static final SecureRandom RANDOM = new SecureRandom();

    private OrderNoUtils() {
    }

    public static String generate() {
        return "ORD" + LocalDateTime.now().format(FORMATTER)
                + String.format("%06d", RANDOM.nextInt(1_000_000));
    }
}
