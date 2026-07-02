package com.socialretail.backend.service.order.pricing;

import com.socialretail.backend.vo.CartItemVO;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Service
public class DefaultOrderPricingService implements OrderPricingService {

    private static final BigDecimal ZERO = new BigDecimal("0.00");

    @Override
    public OrderPricingResult calculate(OrderPricingCommand command) {
        Map<Long, OrderItemPrice> itemPrices = new LinkedHashMap<>();
        BigDecimal originalAmount = ZERO;
        for (CartItemVO item : command.items()) {
            BigDecimal price = item.getPrice() == null ? ZERO : item.getPrice();
            int quantity = item.getQuantity() == null ? 0 : item.getQuantity();
            BigDecimal amount = price.multiply(BigDecimal.valueOf(quantity));
            originalAmount = originalAmount.add(amount);
            itemPrices.put(item.getCartId(), new OrderItemPrice(
                    price, price, amount, amount, "NORMAL"
            ));
        }

        return new OrderPricingResult(
                originalAmount,
                ZERO,
                ZERO,
                originalAmount,
                ZERO,
                ZERO,
                ZERO,
                ZERO,
                ZERO,
                null,
                null,
                null,
                null,
                itemPrices,
                List.of(),
                List.of()
        );
    }
}
