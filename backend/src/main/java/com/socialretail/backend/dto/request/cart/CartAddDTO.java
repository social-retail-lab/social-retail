package com.socialretail.backend.dto.request.cart;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.Data;

@Data
public class CartAddDTO {
    @NotNull(message = "skuId不能为空")
    @Positive(message = "skuId必须大于0")
    private Long skuId;

    @NotNull(message = "购买数量不能为空")
    @Min(value = 1, message = "购买数量必须大于0")
    @Max(value = 999, message = "购买数量不能超过999")
    private Integer quantity;
}
