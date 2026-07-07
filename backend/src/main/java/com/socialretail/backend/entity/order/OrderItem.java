package com.socialretail.backend.entity.order;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@TableName("order_item")
public class OrderItem {
    @TableId(value = "id", type = IdType.AUTO)
    private Long id;
    private Long orderId;
    private Long productId;
    private Long skuId;
    private String productName;
    private String productImage;
    private String skuSpecs;
    private BigDecimal originPrice;
    private BigDecimal finalPrice;
    private BigDecimal price;
    private Integer quantity;
    private BigDecimal itemOriginAmount;
    private BigDecimal itemFinalAmount;
    private String promotionType;
    private Long distributorProductId;
    private BigDecimal commissionRate;
    private LocalDateTime attributionExpiresAt;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Long getOrderId() { return orderId; }
    public void setOrderId(Long orderId) { this.orderId = orderId; }
    public Long getProductId() { return productId; }
    public void setProductId(Long productId) { this.productId = productId; }
    public Long getSkuId() { return skuId; }
    public void setSkuId(Long skuId) { this.skuId = skuId; }
    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }
    public String getProductImage() { return productImage; }
    public void setProductImage(String productImage) { this.productImage = productImage; }
    public String getSkuSpecs() { return skuSpecs; }
    public void setSkuSpecs(String skuSpecs) { this.skuSpecs = skuSpecs; }
    public BigDecimal getOriginPrice() { return originPrice; }
    public void setOriginPrice(BigDecimal originPrice) { this.originPrice = originPrice; }
    public BigDecimal getFinalPrice() { return finalPrice; }
    public void setFinalPrice(BigDecimal finalPrice) { this.finalPrice = finalPrice; }
    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }
    public Integer getQuantity() { return quantity; }
    public void setQuantity(Integer quantity) { this.quantity = quantity; }
    public BigDecimal getItemOriginAmount() { return itemOriginAmount; }
    public void setItemOriginAmount(BigDecimal itemOriginAmount) { this.itemOriginAmount = itemOriginAmount; }
    public BigDecimal getItemFinalAmount() { return itemFinalAmount; }
    public void setItemFinalAmount(BigDecimal itemFinalAmount) { this.itemFinalAmount = itemFinalAmount; }
    public String getPromotionType() { return promotionType; }
    public void setPromotionType(String promotionType) { this.promotionType = promotionType; }
    public Long getDistributorProductId() { return distributorProductId; }
    public void setDistributorProductId(Long distributorProductId) { this.distributorProductId = distributorProductId; }
    public BigDecimal getCommissionRate() { return commissionRate; }
    public void setCommissionRate(BigDecimal commissionRate) { this.commissionRate = commissionRate; }
    public LocalDateTime getAttributionExpiresAt() { return attributionExpiresAt; }
    public void setAttributionExpiresAt(LocalDateTime attributionExpiresAt) { this.attributionExpiresAt = attributionExpiresAt; }
}
