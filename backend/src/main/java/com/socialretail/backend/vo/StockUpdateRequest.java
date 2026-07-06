package com.socialretail.backend.vo;


public class StockUpdateRequest {

    private Integer stock;
    private String remark;

    public Integer getStock() {
        return stock;
    }

    public void setStock(Integer stock) {
        this.stock = stock;
    }

    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark;
    }

    @Override
    public String toString() {
        return "StockUpdateRequest{" +
            ", stock=" + stock +
            ", remark=" + remark +
            '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        StockUpdateRequest that = (StockUpdateRequest) o;
        return java.util.Objects.equals(stock, that.stock)
                && java.util.Objects.equals(remark, that.remark);
    }

    @Override
    public int hashCode() {
        return java.util.Objects.hash(stock, remark);
    }
}
