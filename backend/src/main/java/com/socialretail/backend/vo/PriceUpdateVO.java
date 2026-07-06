package com.socialretail.backend.vo;


import java.math.BigDecimal;

public class PriceUpdateVO {

    private Long skuId;
    private BigDecimal oldPrice;
    private BigDecimal newPrice;

    public Long getSkuId() {
        return skuId;
    }

    public void setSkuId(Long skuId) {
        this.skuId = skuId;
    }

    public BigDecimal getOldPrice() {
        return oldPrice;
    }

    public void setOldPrice(BigDecimal oldPrice) {
        this.oldPrice = oldPrice;
    }

    public BigDecimal getNewPrice() {
        return newPrice;
    }

    public void setNewPrice(BigDecimal newPrice) {
        this.newPrice = newPrice;
    }

    @Override
    public String toString() {
        return "PriceUpdateVO{" +
            ", skuId=" + skuId +
            ", oldPrice=" + oldPrice +
            ", newPrice=" + newPrice +
            '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        PriceUpdateVO that = (PriceUpdateVO) o;
        return java.util.Objects.equals(skuId, that.skuId)
                && java.util.Objects.equals(oldPrice, that.oldPrice)
                && java.util.Objects.equals(newPrice, that.newPrice);
    }

    @Override
    public int hashCode() {
        return java.util.Objects.hash(skuId, oldPrice, newPrice);
    }
}
