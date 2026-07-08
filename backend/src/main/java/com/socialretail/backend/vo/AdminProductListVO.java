package com.socialretail.backend.vo;


public class AdminProductListVO {
    private Long productId;
    private String title;
    private String mainImage;
    private Integer status;
    private String statusText;
    private Integer auditStatus;
    private String auditStatusText;
    private Boolean groupPurchase;  // 是否可拼团（预留）
    private String merchantName;

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

    public Boolean getGroupPurchase() {
        return groupPurchase;
    }

    public void setGroupPurchase(Boolean groupPurchase) {
        this.groupPurchase = groupPurchase;
    }

    public String getMerchantName() {
        return merchantName;
    }

    public void setMerchantName(String merchantName) {
        this.merchantName = merchantName;
    }

    @Override
    public String toString() {
        return "AdminProductListVO{" +
            ", productId=" + productId +
            ", title=" + title +
            ", mainImage=" + mainImage +
            ", status=" + status +
            ", statusText=" + statusText +
            ", auditStatus=" + auditStatus +
            ", auditStatusText=" + auditStatusText +
            ", groupPurchase=" + groupPurchase +
            ", merchantName=" + merchantName +
            '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        AdminProductListVO that = (AdminProductListVO) o;
        return java.util.Objects.equals(productId, that.productId)
                && java.util.Objects.equals(title, that.title)
                && java.util.Objects.equals(mainImage, that.mainImage)
                && java.util.Objects.equals(status, that.status)
                && java.util.Objects.equals(statusText, that.statusText)
                && java.util.Objects.equals(auditStatus, that.auditStatus)
                && java.util.Objects.equals(auditStatusText, that.auditStatusText)
                && java.util.Objects.equals(groupPurchase, that.groupPurchase)
                && java.util.Objects.equals(merchantName, that.merchantName);
    }

    @Override
    public int hashCode() {
        return java.util.Objects.hash(productId, title, mainImage, status, statusText, auditStatus, auditStatusText, groupPurchase, merchantName);
    }
}
