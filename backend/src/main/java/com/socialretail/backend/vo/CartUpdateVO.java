package com.socialretail.backend.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CartUpdateVO {
    private Long cartItemId;
    private Long skuId;
    private Integer quantity;
    private BigDecimal price;
    private BigDecimal itemAmount;
}
