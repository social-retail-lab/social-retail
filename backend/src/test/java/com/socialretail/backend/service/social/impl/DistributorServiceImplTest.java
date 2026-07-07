package com.socialretail.backend.service.social.impl;

import org.junit.jupiter.api.Test;

import java.sql.Timestamp;
import java.time.LocalDateTime;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNull;

class DistributorServiceImplTest {
    @Test
    void convertsJdbcDateTimeRepresentations() {
        LocalDateTime expected = LocalDateTime.of(2026, 7, 6, 15, 9, 2);

        assertEquals(expected, DistributorServiceImpl.time(expected));
        assertEquals(expected, DistributorServiceImpl.time(Timestamp.valueOf(expected)));
        assertNull(DistributorServiceImpl.time(null));
    }
}
