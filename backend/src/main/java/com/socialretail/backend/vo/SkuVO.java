package com.socialretail.backend.vo;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.math.BigDecimal;
import java.util.Map;

public class SkuVO {

    private static final ObjectMapper MAPPER = new ObjectMapper();

    private Long skuId;
    private String specs;
    private String specsText;
    private BigDecimal price;
    private Integer stock;
    private String skuCode;

    public SkuVO() {
    }

    public SkuVO(Long skuId, Map<String, Object> specMap, BigDecimal price, Integer stock) {
        this.skuId = skuId;
        try {
            this.specs = specMap != null ? MAPPER.writeValueAsString(specMap) : null;
        } catch (JsonProcessingException e) {
            this.specs = specMap != null ? specMap.toString() : null;
        }
        this.price = price;
        this.stock = stock;
    }

    public Long getSkuId() {
        return skuId;
    }

    public void setSkuId(Long skuId) {
        this.skuId = skuId;
    }

    public String getSpecs() {
        return specs;
    }

    public void setSpecs(String specs) {
        this.specs = specs;
    }

    public String getSpecsText() {
        return specsText;
    }

    public void setSpecsText(String specsText) {
        this.specsText = specsText;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public Integer getStock() {
        return stock;
    }

    public void setStock(Integer stock) {
        this.stock = stock;
    }

    public String getSkuCode() {
        return skuCode;
    }

    public void setSkuCode(String skuCode) {
        this.skuCode = skuCode;
    }

    @Override
    public String toString() {
        return "SkuVO{" +
            "skuId=" + skuId +
            ", specs=" + specs +
            ", specsText=" + specsText +
            ", price=" + price +
            ", stock=" + stock +
            ", skuCode=" + skuCode +
            '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        SkuVO that = (SkuVO) o;
        return java.util.Objects.equals(skuId, that.skuId)
                && java.util.Objects.equals(specs, that.specs)
                && java.util.Objects.equals(specsText, that.specsText)
                && java.util.Objects.equals(price, that.price)
                && java.util.Objects.equals(stock, that.stock)
                && java.util.Objects.equals(skuCode, that.skuCode);
    }

    @Override
    public int hashCode() {
        return java.util.Objects.hash(skuId, specs, specsText, price, stock, skuCode);
    }
}
