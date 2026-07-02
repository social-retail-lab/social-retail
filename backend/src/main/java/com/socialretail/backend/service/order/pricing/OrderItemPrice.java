package com.socialretail.backend.service.order.pricing;

import java.math.BigDecimal;

public record OrderItemPrice(
        BigDecimal originPrice,
        BigDecimal finalPrice,
        BigDecimal originAmount,
        BigDecimal finalAmount,
        String promotionType
) {
}
