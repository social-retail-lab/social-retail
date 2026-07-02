package com.socialretail.backend.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CatalogProductVO {
    private Long productId;
    private String productName;
    private String productImage;
    private BigDecimal price;
    private BigDecimal originalPrice;
    private Integer soldCount;
    private Integer stock;
    private List<String> tags;
}
