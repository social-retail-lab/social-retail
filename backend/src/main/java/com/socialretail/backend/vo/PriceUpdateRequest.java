package com.socialretail.backend.vo;


import java.math.BigDecimal;

public class PriceUpdateRequest {

    private BigDecimal price;

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    @Override
    public String toString() {
        return "PriceUpdateRequest{" +
            ", price=" + price +
            '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        PriceUpdateRequest that = (PriceUpdateRequest) o;
        return java.util.Objects.equals(price, that.price);
    }

    @Override
    public int hashCode() {
        return java.util.Objects.hash(price);
    }
}
