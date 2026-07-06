package com.socialretail.backend.entity.order;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

import java.math.BigDecimal;

@TableName("order_item")
public class OrderItem {

    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    private Long orderId;

    private Long productId;

    private Long skuId;

    private String productName;

    private String skuSpecs;

    private BigDecimal price;

    private Integer quantity;

    /** 商品图片（非DB字段，VO层填充） */
    @TableField(exist = false)
    private String productImage;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getOrderId() {
        return orderId;
    }

    public void setOrderId(Long orderId) {
        this.orderId = orderId;
    }

    public Long getProductId() {
        return productId;
    }

    public void setProductId(Long productId) {
        this.productId = productId;
    }

    public Long getSkuId() {
        return skuId;
    }

    public void setSkuId(Long skuId) {
        this.skuId = skuId;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getSkuSpecs() {
        return skuSpecs;
    }

    public void setSkuSpecs(String skuSpecs) {
        this.skuSpecs = skuSpecs;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }

    public String getProductImage() {
        return productImage;
    }

    public void setProductImage(String productImage) {
        this.productImage = productImage;
    }

    @Override
    public String toString() {
        return "OrderItem{" +
            ", id=" + id +
            ", orderId=" + orderId +
            ", productId=" + productId +
            ", skuId=" + skuId +
            ", productName=" + productName +
            ", skuSpecs=" + skuSpecs +
            ", price=" + price +
            ", quantity=" + quantity +
            '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        OrderItem that = (OrderItem) o;
        return java.util.Objects.equals(id, that.id)
                && java.util.Objects.equals(orderId, that.orderId)
                && java.util.Objects.equals(productId, that.productId)
                && java.util.Objects.equals(skuId, that.skuId)
                && java.util.Objects.equals(productName, that.productName)
                && java.util.Objects.equals(skuSpecs, that.skuSpecs)
                && java.util.Objects.equals(price, that.price)
                && java.util.Objects.equals(quantity, that.quantity);
    }

    @Override
    public int hashCode() {
        return java.util.Objects.hash(id, orderId, productId, skuId, productName, skuSpecs, price, quantity);
    }
}
