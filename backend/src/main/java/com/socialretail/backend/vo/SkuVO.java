package com.socialretail.backend.vo;

import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.util.Map;

@Data
@NoArgsConstructor
@JsonInclude(JsonInclude.Include.NON_NULL)
public class SkuVO {

    private Long skuId;
    private Map<String, Object> spec;
    private BigDecimal price;
    private Integer stock;

    // 以下字段保留给现有商家端使用。
    private String specs;
    private String specsText;
    private String skuCode;

    public SkuVO(Long skuId, Map<String, Object> spec, BigDecimal price, Integer stock) {
        this.skuId = skuId;
        this.spec = spec;
        this.price = price;
        this.stock = stock;
    }
}
