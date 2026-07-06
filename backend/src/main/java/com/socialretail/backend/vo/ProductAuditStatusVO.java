package com.socialretail.backend.vo;


public class ProductAuditStatusVO {

    private Long productId;
    private String title;
    private Integer auditStatus;
    private String auditStatusText;
    private String auditRemark;
    private String auditTime;
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

    public String getAuditRemark() {
        return auditRemark;
    }

    public void setAuditRemark(String auditRemark) {
        this.auditRemark = auditRemark;
    }

    public String getAuditTime() {
        return auditTime;
    }

    public void setAuditTime(String auditTime) {
        this.auditTime = auditTime;
    }

    public String getSubmitTime() {
        return submitTime;
    }

    public void setSubmitTime(String submitTime) {
        this.submitTime = submitTime;
    }

    @Override
    public String toString() {
        return "ProductAuditStatusVO{" +
            ", productId=" + productId +
            ", title=" + title +
            ", auditStatus=" + auditStatus +
            ", auditStatusText=" + auditStatusText +
            ", auditRemark=" + auditRemark +
            ", auditTime=" + auditTime +
            ", submitTime=" + submitTime +
            '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        ProductAuditStatusVO that = (ProductAuditStatusVO) o;
        return java.util.Objects.equals(productId, that.productId)
                && java.util.Objects.equals(title, that.title)
                && java.util.Objects.equals(auditStatus, that.auditStatus)
                && java.util.Objects.equals(auditStatusText, that.auditStatusText)
                && java.util.Objects.equals(auditRemark, that.auditRemark)
                && java.util.Objects.equals(auditTime, that.auditTime)
                && java.util.Objects.equals(submitTime, that.submitTime);
    }

    @Override
    public int hashCode() {
        return java.util.Objects.hash(productId, title, auditStatus, auditStatusText, auditRemark, auditTime, submitTime);
    }
}
