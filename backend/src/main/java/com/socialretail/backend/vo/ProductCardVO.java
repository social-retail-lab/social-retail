package com.socialretail.backend.vo;

import lombok.AllArgsConstructor;
import lombok.Data;

import java.math.BigDecimal;
import java.util.List;

@Data
@AllArgsConstructor
public class ProductCardVO {
    private Long productId;
    private String productName;
    private String productImage;
    private BigDecimal price;
    private BigDecimal originalPrice;
    private Long soldCount;
    private Integer stock;
    private List<String> tags;
    private Long merchantId;
    private String merchantName;
    private String promotionTitle;
}
