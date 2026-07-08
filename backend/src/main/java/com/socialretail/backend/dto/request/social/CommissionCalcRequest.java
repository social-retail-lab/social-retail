package com.socialretail.backend.dto.request.social;

import jakarta.validation.Valid;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;

import java.math.BigDecimal;
import java.util.List;

public record CommissionCalcRequest(
        @NotNull @Positive Long orderId,
        @NotNull @Positive Long userId,
        @NotEmpty List<@Valid ProductItem> productItems) {

    public record ProductItem(
            @NotNull @Positive Long productId,
            @NotNull @DecimalMin(value = "0.01") BigDecimal price,
            @NotNull @Positive Integer quantity,
            @NotNull @Positive Long distributionProductId) {
    }
}
