package com.socialretail.backend.vo;


import java.util.List;

public class AuditRequestVO {

    private Long requestId;

    private String requestType;       // PRODUCT_PUBLISH, PRODUCT_EDIT, INFO_CHANGE, QUALIFICATION_UPGRADE

    private String requestTypeText;

    private Long productId;           // 商品相关时填充

    private String productTitle;      // 商品标题

    private String imageUrl;          // 主图

    private Integer auditStatus;      // 0-待审核, 1-通过, 2-驳回

    private String auditStatusText;

    private String auditRemark;

    private String createTime;

    private String auditTime;

    private Boolean withdrawable;     // 是否可撤回

    // 详情用：新旧对照
    private Object oldData;

    private Object newData;

    public Long getRequestId() {
        return requestId;
    }

    public void setRequestId(Long requestId) {
        this.requestId = requestId;
    }

    public String getRequestType() {
        return requestType;
    }

    public void setRequestType(String requestType) {
        this.requestType = requestType;
    }

    public String getRequestTypeText() {
        return requestTypeText;
    }

    public void setRequestTypeText(String requestTypeText) {
        this.requestTypeText = requestTypeText;
    }

    public Long getProductId() {
        return productId;
    }

    public void setProductId(Long productId) {
        this.productId = productId;
    }

    public String getProductTitle() {
        return productTitle;
    }

    public void setProductTitle(String productTitle) {
        this.productTitle = productTitle;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
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

    public String getCreateTime() {
        return createTime;
    }

    public void setCreateTime(String createTime) {
        this.createTime = createTime;
    }

    public String getAuditTime() {
        return auditTime;
    }

    public void setAuditTime(String auditTime) {
        this.auditTime = auditTime;
    }

    public Boolean getWithdrawable() {
        return withdrawable;
    }

    public void setWithdrawable(Boolean withdrawable) {
        this.withdrawable = withdrawable;
    }

    public Object getOldData() {
        return oldData;
    }

    public void setOldData(Object oldData) {
        this.oldData = oldData;
    }

    public Object getNewData() {
        return newData;
    }

    public void setNewData(Object newData) {
        this.newData = newData;
    }

    @Override
    public String toString() {
        return "AuditRequestVO{" +
            ", requestId=" + requestId +
            ", requestType=" + requestType +
            ", requestTypeText=" + requestTypeText +
            ", productId=" + productId +
            ", productTitle=" + productTitle +
            ", imageUrl=" + imageUrl +
            ", auditStatus=" + auditStatus +
            ", auditStatusText=" + auditStatusText +
            ", auditRemark=" + auditRemark +
            ", createTime=" + createTime +
            ", auditTime=" + auditTime +
            ", withdrawable=" + withdrawable +
            ", oldData=" + oldData +
            ", newData=" + newData +
            '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        AuditRequestVO that = (AuditRequestVO) o;
        return java.util.Objects.equals(requestId, that.requestId)
                && java.util.Objects.equals(requestType, that.requestType)
                && java.util.Objects.equals(requestTypeText, that.requestTypeText)
                && java.util.Objects.equals(productId, that.productId)
                && java.util.Objects.equals(productTitle, that.productTitle)
                && java.util.Objects.equals(imageUrl, that.imageUrl)
                && java.util.Objects.equals(auditStatus, that.auditStatus)
                && java.util.Objects.equals(auditStatusText, that.auditStatusText)
                && java.util.Objects.equals(auditRemark, that.auditRemark)
                && java.util.Objects.equals(createTime, that.createTime)
                && java.util.Objects.equals(auditTime, that.auditTime)
                && java.util.Objects.equals(withdrawable, that.withdrawable)
                && java.util.Objects.equals(oldData, that.oldData)
                && java.util.Objects.equals(newData, that.newData);
    }

    @Override
    public int hashCode() {
        return java.util.Objects.hash(requestId, requestType, requestTypeText, productId, productTitle, imageUrl, auditStatus, auditStatusText, auditRemark, createTime, auditTime, withdrawable, oldData, newData);
    }
}
