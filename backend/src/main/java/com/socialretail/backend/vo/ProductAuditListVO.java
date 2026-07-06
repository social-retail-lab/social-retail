package com.socialretail.backend.vo;


import java.math.BigDecimal;

public class ProductAuditListVO {

    private Long productId;
    private String title;
    private String mainImage;
    private String merchantName;
    private BigDecimal minPrice;
    private Integer auditStatus;
    private String auditStatusText;
    private String submitTime;

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

    public String getMerchantName() {
        return merchantName;
    }

    public void setMerchantName(String merchantName) {
        this.merchantName = merchantName;
    }

    public BigDecimal getMinPrice() {
        return minPrice;
    }

    public void setMinPrice(BigDecimal minPrice) {
        this.minPrice = minPrice;
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

    public String getSubmitTime() {
        return submitTime;
    }

    public void setSubmitTime(String submitTime) {
        this.submitTime = submitTime;
    }

    @Override
    public String toString() {
        return "ProductAuditListVO{" +
            ", productId=" + productId +
            ", title=" + title +
            ", mainImage=" + mainImage +
            ", merchantName=" + merchantName +
            ", minPrice=" + minPrice +
            ", auditStatus=" + auditStatus +
            ", auditStatusText=" + auditStatusText +
            ", submitTime=" + submitTime +
            '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        ProductAuditListVO that = (ProductAuditListVO) o;
        return java.util.Objects.equals(productId, that.productId)
                && java.util.Objects.equals(title, that.title)
                && java.util.Objects.equals(mainImage, that.mainImage)
                && java.util.Objects.equals(merchantName, that.merchantName)
                && java.util.Objects.equals(minPrice, that.minPrice)
                && java.util.Objects.equals(auditStatus, that.auditStatus)
                && java.util.Objects.equals(auditStatusText, that.auditStatusText)
                && java.util.Objects.equals(submitTime, that.submitTime);
    }

    @Override
    public int hashCode() {
        return java.util.Objects.hash(productId, title, mainImage, merchantName, minPrice, auditStatus, auditStatusText, submitTime);
    }
}
