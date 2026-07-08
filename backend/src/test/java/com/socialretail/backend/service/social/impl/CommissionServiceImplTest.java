package com.socialretail.backend.service.social.impl;

import org.junit.jupiter.api.Test;
import com.socialretail.backend.entity.order.OrderItem;
import java.math.BigDecimal;
import java.time.LocalDateTime;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNull;

class CommissionServiceImplTest {
    @Test
    void masksBankCardWithoutLeakingMiddleDigits() {
        assertEquals("622202****2020", CommissionServiceImpl.maskBankCard("6222020202020202020"));
        assertEquals("1234", CommissionServiceImpl.maskBankCard("1234"));
    }

    @Test
    void calculatesPaidCommissionOnlyBeforeAttributionExpires() {
        LocalDateTime payTime = LocalDateTime.of(2026, 7, 6, 16, 0);
        OrderItem item = new OrderItem();
        item.setDistributorProductId(7L);
        item.setCommissionRate(new BigDecimal("5.00"));
        item.setItemFinalAmount(new BigDecimal("59.80"));
        item.setAttributionExpiresAt(payTime.plusSeconds(1));

        assertEquals(new BigDecimal("2.99"),
                CommissionServiceImpl.paidCommissionAmount(item, payTime));

        item.setAttributionExpiresAt(payTime);
        assertNull(CommissionServiceImpl.paidCommissionAmount(item, payTime));
    }
}
