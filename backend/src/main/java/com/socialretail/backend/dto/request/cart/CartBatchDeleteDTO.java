package com.socialretail.backend.dto.request.cart;

import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.Data;

import java.util.List;

@Data
public class CartBatchDeleteDTO {
    @NotEmpty(message = "请选择要删除的商品")
    private List<@NotNull(message = "购物车商品ID不能为空") @Positive(message = "购物车商品ID必须大于0") Long> cartItemIds;
}
