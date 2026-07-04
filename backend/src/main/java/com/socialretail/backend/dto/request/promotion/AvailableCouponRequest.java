package com.socialretail.backend.dto.request.promotion;

import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.Data;

import java.util.List;

@Data
public class AvailableCouponRequest {
    @NotEmpty(message = "请选择要结算的购物车商品")
    private List<@NotNull(message = "购物车商品ID不能为空")
            @Positive(message = "购物车商品ID必须大于0") Long> cartItemIds;
}
