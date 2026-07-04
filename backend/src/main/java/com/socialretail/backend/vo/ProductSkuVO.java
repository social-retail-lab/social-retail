package com.socialretail.backend.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.util.Map;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ProductSkuVO {
    private Long skuId;
    private String skuName;
    private Map<String, Object> specs;
    private BigDecimal price;
    private BigDecimal originalPrice;
    private Integer stock;
    private Integer lockedStock;
    private String status;
}
