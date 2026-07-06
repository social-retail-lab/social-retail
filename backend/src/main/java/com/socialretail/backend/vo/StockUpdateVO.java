package com.socialretail.backend.vo;


public class StockUpdateVO {

    private Long skuId;
    private String productName;
    private Integer oldStock;
    private Integer newStock;

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

    public Integer getOldStock() {
        return oldStock;
    }

    public void setOldStock(Integer oldStock) {
        this.oldStock = oldStock;
    }

    public Integer getNewStock() {
        return newStock;
    }

    public void setNewStock(Integer newStock) {
        this.newStock = newStock;
    }

    @Override
    public String toString() {
        return "StockUpdateVO{" +
            ", skuId=" + skuId +
            ", productName=" + productName +
            ", oldStock=" + oldStock +
            ", newStock=" + newStock +
            '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        StockUpdateVO that = (StockUpdateVO) o;
        return java.util.Objects.equals(skuId, that.skuId)
                && java.util.Objects.equals(productName, that.productName)
                && java.util.Objects.equals(oldStock, that.oldStock)
                && java.util.Objects.equals(newStock, that.newStock);
    }

    @Override
    public int hashCode() {
        return java.util.Objects.hash(skuId, productName, oldStock, newStock);
    }
}
