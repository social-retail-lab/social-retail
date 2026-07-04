package com.socialretail.backend.service.promotion;

import com.socialretail.backend.dto.promotion.PromotionApiModels.DiscountRuleAvailable;
import com.socialretail.backend.entity.member.DiscountRule;
import com.socialretail.backend.mapper.member.DiscountRuleMapper;
import org.junit.jupiter.api.Test;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

class DiscountRuleServiceTest {

    @Test
    void productSceneDoesNotCalculateAmount() {
        DiscountRuleService service = serviceWithRule();

        DiscountRuleAvailable response = service.available(null, 2001L, "PRODUCT");

        assertEquals("PRODUCT", response.scene());
        assertNull(response.orderAmount());
        assertNull(response.list().get(0).available());
        assertNull(response.list().get(0).needAmount());
        assertEquals("满200减20", response.list().get(0).showLabel());
        assertEquals("FULL_REDUCTION", response.list().get(0).promotionTag());
    }

    @Test
    void cartSceneCalculatesAvailableAndNeedAmount() {
        DiscountRuleService service = serviceWithRule();

        DiscountRuleAvailable insufficient = service.available(new BigDecimal("180.00"), 2001L, "cart");
        DiscountRuleAvailable sufficient = service.available(new BigDecimal("220.00"), 2001L, "CART");

        assertEquals("CART", insufficient.scene());
        assertFalse(insufficient.list().get(0).available());
        assertEquals(new BigDecimal("20.00"), insufficient.list().get(0).needAmount());
        assertTrue(sufficient.list().get(0).available());
        assertEquals(new BigDecimal("0.00"), sufficient.list().get(0).needAmount());
    }

    private DiscountRuleService serviceWithRule() {
        DiscountRuleMapper mapper = mock(DiscountRuleMapper.class);
        DiscountRule rule = new DiscountRule();
        rule.setId(9001L);
        rule.setTitle("满200减20");
        rule.setType(1);
        rule.setMinAmount(new BigDecimal("200.00"));
        rule.setDiscountAmount(new BigDecimal("20.00"));
        rule.setStartTime(LocalDateTime.now().minusDays(1));
        rule.setEndTime(LocalDateTime.now().plusDays(1));
        when(mapper.selectList(any())).thenReturn(List.of(rule));
        return new DiscountRuleService(mapper);
    }
}
