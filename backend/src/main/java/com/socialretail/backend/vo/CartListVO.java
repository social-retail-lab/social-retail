package com.socialretail.backend.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CartListVO {
    private List<CartItemVO> list;
    private Integer totalQuantity;
    private BigDecimal totalAmount;
    private BigDecimal checkedAmount;
}
