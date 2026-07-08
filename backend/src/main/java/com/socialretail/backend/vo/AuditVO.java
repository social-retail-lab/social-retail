package com.socialretail.backend.vo;


public class AuditVO {

    private Long applyId;
    private Long productId;
    private Integer auditStatus;
    private String auditStatusText;
    private Long merchantId;

    public Long getApplyId() {
        return applyId;
    }

    public void setApplyId(Long applyId) {
        this.applyId = applyId;
    }

    public Long getProductId() {
        return productId;
    }

    public void setProductId(Long productId) {
        this.productId = productId;
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

    public Long getMerchantId() {
        return merchantId;
    }

    public void setMerchantId(Long merchantId) {
        this.merchantId = merchantId;
    }

    @Override
    public String toString() {
        return "AuditVO{" +
            ", applyId=" + applyId +
            ", productId=" + productId +
            ", auditStatus=" + auditStatus +
            ", auditStatusText=" + auditStatusText +
            ", merchantId=" + merchantId +
            '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        AuditVO that = (AuditVO) o;
        return java.util.Objects.equals(applyId, that.applyId)
                && java.util.Objects.equals(productId, that.productId)
                && java.util.Objects.equals(auditStatus, that.auditStatus)
                && java.util.Objects.equals(auditStatusText, that.auditStatusText)
                && java.util.Objects.equals(merchantId, that.merchantId);
    }

    @Override
    public int hashCode() {
        return java.util.Objects.hash(applyId, productId, auditStatus, auditStatusText, merchantId);
    }
}
