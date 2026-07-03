package com.socialretail.backend.service.order.pricing;

import com.socialretail.backend.vo.CartItemVO;
import com.socialretail.backend.vo.PointsInfoVO;
import com.socialretail.backend.service.member.PointsCalculationService;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Service
public class DefaultOrderPricingService implements OrderPricingService {

    private static final BigDecimal ZERO = new BigDecimal("0.00");
    private final PointsCalculationService pointsCalculationService;

    public DefaultOrderPricingService(PointsCalculationService pointsCalculationService) {
        this.pointsCalculationService = pointsCalculationService;
    }

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

        // 积分只抵扣商品优惠后的金额，配送费不参与 10% 上限计算。
        PointsInfoVO pointsInfo = pointsCalculationService.calculate(
                command.userId(), originalAmount, command.usePoints(), command.usePointsAmount());
        BigDecimal pointsDeduction = pointsInfo.getDeductionAmount();
        BigDecimal payableAmount = originalAmount.subtract(pointsDeduction).max(BigDecimal.ZERO);

        return new OrderPricingResult(
                originalAmount,
                pointsDeduction,
                ZERO,
                payableAmount,
                ZERO,
                ZERO,
                ZERO,
                ZERO,
                pointsDeduction,
                null,
                null,
                null,
                null,
                itemPrices,
                List.of(),
                List.of(),
                pointsInfo
        );
    }
}
