package com.socialretail.backend.service.order.pricing;

public interface OrderPricingService {
    OrderPricingResult calculate(OrderPricingCommand command);
}
