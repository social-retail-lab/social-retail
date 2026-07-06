package com.socialretail.backend.vo;


import java.math.BigDecimal;

public class ProductListVO {

    private Long productId;
    private String title;
    private String mainImage;
    private BigDecimal minPrice;
    private BigDecimal maxPrice;
    private Integer totalStock;
    private Integer auditStatus;
    private String auditStatusText;
    private Integer status;
    private String statusText;
    private String createTime;

    public Long getProductId() {
        return productId;
    }

    public void setProductId(Long productId) {
        this.productId = productId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getMainImage() {
        return mainImage;
    }

    public void setMainImage(String mainImage) {
        this.mainImage = mainImage;
    }

    public BigDecimal getMinPrice() {
        return minPrice;
    }

    public void setMinPrice(BigDecimal minPrice) {
        this.minPrice = minPrice;
    }

    public BigDecimal getMaxPrice() {
        return maxPrice;
    }

    public void setMaxPrice(BigDecimal maxPrice) {
        this.maxPrice = maxPrice;
    }

    public Integer getTotalStock() {
        return totalStock;
    }

    public void setTotalStock(Integer totalStock) {
        this.totalStock = totalStock;
    }

    public Integer getAuditStatus() {
        return auditStatus;
    }

    public void setAuditStatus(Integer auditStatus) {
        this.auditStatus = auditStatus;
    }

    public String getAuditStatusText() {
        return auditStatusText;
    }

    public void setAuditStatusText(String auditStatusText) {
        this.auditStatusText = auditStatusText;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    public String getStatusText() {
        return statusText;
    }

    public void setStatusText(String statusText) {
        this.statusText = statusText;
    }

    public String getCreateTime() {
        return createTime;
    }

    public void setCreateTime(String createTime) {
        this.createTime = createTime;
    }

    @Override
    public String toString() {
        return "ProductListVO{" +
            ", productId=" + productId +
            ", title=" + title +
            ", mainImage=" + mainImage +
            ", minPrice=" + minPrice +
            ", maxPrice=" + maxPrice +
            ", totalStock=" + totalStock +
            ", auditStatus=" + auditStatus +
            ", auditStatusText=" + auditStatusText +
            ", status=" + status +
            ", statusText=" + statusText +
            ", createTime=" + createTime +
            '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        ProductListVO that = (ProductListVO) o;
        return java.util.Objects.equals(productId, that.productId)
                && java.util.Objects.equals(title, that.title)
                && java.util.Objects.equals(mainImage, that.mainImage)
                && java.util.Objects.equals(minPrice, that.minPrice)
                && java.util.Objects.equals(maxPrice, that.maxPrice)
                && java.util.Objects.equals(totalStock, that.totalStock)
                && java.util.Objects.equals(auditStatus, that.auditStatus)
                && java.util.Objects.equals(auditStatusText, that.auditStatusText)
                && java.util.Objects.equals(status, that.status)
                && java.util.Objects.equals(statusText, that.statusText)
                && java.util.Objects.equals(createTime, that.createTime);
    }

    @Override
    public int hashCode() {
        return java.util.Objects.hash(productId, title, mainImage, minPrice, maxPrice, totalStock, auditStatus, auditStatusText, status, statusText, createTime);
    }
}
