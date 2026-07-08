package com.socialretail.backend.vo;


import java.math.BigDecimal;

public class SkuRequest {

    private String specs;
    private BigDecimal price;
    private Integer stock;
    private String skuCode;

    public String getSpecs() {
        return specs;
    }

    public void setSpecs(String specs) {
        this.specs = specs;
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
        return "SkuRequest{" +
            ", specs=" + specs +
            ", price=" + price +
            ", stock=" + stock +
            ", skuCode=" + skuCode +
            '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        SkuRequest that = (SkuRequest) o;
        return java.util.Objects.equals(specs, that.specs)
                && java.util.Objects.equals(price, that.price)
                && java.util.Objects.equals(stock, that.stock)
                && java.util.Objects.equals(skuCode, that.skuCode);
    }

    @Override
    public int hashCode() {
        return java.util.Objects.hash(specs, price, stock, skuCode);
    }
}
