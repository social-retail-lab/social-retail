package com.socialretail.backend.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ProductDetailVO {

    private Long productId;
    private String title;
    private String description;
    private List<String> images;
    private BigDecimal price;
    private List<SkuVO> skuList;
}
