package com.socialretail.backend.dto.request.payment;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.Data;

import java.math.BigDecimal;

@Data
public class MockPaySuccessDTO {
    @NotNull(message = "订单ID不能为空")
    @Positive(message = "订单ID必须大于0")
    private Long orderId;

    @NotNull(message = "支付金额不能为空")
    @DecimalMin(value = "0.01", message = "支付金额必须大于0")
    private BigDecimal payAmount;
}
