package com.socialretail.backend.entity.order;

import lombok.Data;

@Data
public class Cart {
    private Long id;
    private Long userId;
    private Long skuId;
    private Integer quantity;
}
