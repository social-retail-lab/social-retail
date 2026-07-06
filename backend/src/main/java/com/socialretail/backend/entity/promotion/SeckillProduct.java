package com.socialretail.backend.entity.promotion;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@TableName("seckill_product")
public class SeckillProduct {

    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    private Long seckillActivityId;

    private Long productId;

    private String skuId;

    private BigDecimal seckillPrice;

    private Integer seckillStock;

    private Integer soldCount;

    private Integer limitQuantity;

    private Integer status;

    private LocalDateTime createTime;

    private LocalDateTime updateTime;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getSeckillActivityId() {
        return seckillActivityId;
    }

    public void setSeckillActivityId(Long seckillActivityId) {
        this.seckillActivityId = seckillActivityId;
    }

    public Long getProductId() {
        return productId;
    }

    public void setProductId(Long productId) {
        this.productId = productId;
    }

    public String getSkuId() {
        return skuId;
    }

    public void setSkuId(String skuId) {
        this.skuId = skuId;
    }

    public BigDecimal getSeckillPrice() {
        return seckillPrice;
    }

    public void setSeckillPrice(BigDecimal seckillPrice) {
        this.seckillPrice = seckillPrice;
    }

    public Integer getSeckillStock() {
        return seckillStock;
    }

    public void setSeckillStock(Integer seckillStock) {
        this.seckillStock = seckillStock;
    }

    public Integer getSoldCount() {
        return soldCount;
    }

    public void setSoldCount(Integer soldCount) {
        this.soldCount = soldCount;
    }

    public Integer getLimitQuantity() {
        return limitQuantity;
    }

    public void setLimitQuantity(Integer limitQuantity) {
        this.limitQuantity = limitQuantity;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    public LocalDateTime getCreateTime() {
        return createTime;
    }

    public void setCreateTime(LocalDateTime createTime) {
        this.createTime = createTime;
    }

    public LocalDateTime getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(LocalDateTime updateTime) {
        this.updateTime = updateTime;
    }

    @Override
    public String toString() {
        return "SeckillProduct{" +
            ", id=" + id +
            ", seckillActivityId=" + seckillActivityId +
            ", productId=" + productId +
            ", skuId=" + skuId +
            ", seckillPrice=" + seckillPrice +
            ", seckillStock=" + seckillStock +
            ", soldCount=" + soldCount +
            ", limitQuantity=" + limitQuantity +
            ", status=" + status +
            ", createTime=" + createTime +
            ", updateTime=" + updateTime +
            '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        SeckillProduct that = (SeckillProduct) o;
        return java.util.Objects.equals(id, that.id)
                && java.util.Objects.equals(seckillActivityId, that.seckillActivityId)
                && java.util.Objects.equals(productId, that.productId)
                && java.util.Objects.equals(skuId, that.skuId)
                && java.util.Objects.equals(seckillPrice, that.seckillPrice)
                && java.util.Objects.equals(seckillStock, that.seckillStock)
                && java.util.Objects.equals(soldCount, that.soldCount)
                && java.util.Objects.equals(limitQuantity, that.limitQuantity)
                && java.util.Objects.equals(status, that.status)
                && java.util.Objects.equals(createTime, that.createTime)
                && java.util.Objects.equals(updateTime, that.updateTime);
    }

    @Override
    public int hashCode() {
        return java.util.Objects.hash(id, seckillActivityId, productId, skuId, seckillPrice, seckillStock, soldCount, limitQuantity, status, createTime, updateTime);
    }
}
