package com.socialretail.backend.entity.product;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

import java.math.BigDecimal;

@TableName("sku")
public class Sku {

    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    private Long productId;

    private String specs;

    private BigDecimal price;

    private Integer stock;

    private String skuCode;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getProductId() {
        return productId;
    }

    public void setProductId(Long productId) {
        this.productId = productId;
    }

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
        return "Sku{" +
            ", id=" + id +
            ", productId=" + productId +
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
        Sku that = (Sku) o;
        return java.util.Objects.equals(id, that.id)
                && java.util.Objects.equals(productId, that.productId)
                && java.util.Objects.equals(specs, that.specs)
                && java.util.Objects.equals(price, that.price)
                && java.util.Objects.equals(stock, that.stock)
                && java.util.Objects.equals(skuCode, that.skuCode);
    }

    @Override
    public int hashCode() {
        return java.util.Objects.hash(id, productId, specs, price, stock, skuCode);
    }
}
