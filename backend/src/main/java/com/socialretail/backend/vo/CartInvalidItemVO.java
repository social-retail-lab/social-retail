package com.socialretail.backend.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CartInvalidItemVO {
    private Long cartItemId;
    private Long skuId;
    private Long productId;
    private String productName;
    private String productImage;
    private Integer quantity;
    private String invalidReason;
}
