package com.socialretail.backend.vo;

public class MerchantInfoChangeVO {

    private Long changeId;

    private String requestType;

    private String requestTypeText;

    private String oldData;

    private String newData;

    private Integer auditStatus;

    private Integer auditStatusText;

    private String auditRemark;

    private String createTime;

    private String auditTime;

    public Long getChangeId() {
        return changeId;
    }

    public void setChangeId(Long changeId) {
        this.changeId = changeId;
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

    public String getOldData() {
        return oldData;
    }

    public void setOldData(String oldData) {
        this.oldData = oldData;
    }

    public String getNewData() {
        return newData;
    }

    public void setNewData(String newData) {
        this.newData = newData;
    }

    public Integer getAuditStatus() {
        return auditStatus;
    }

    public void setAuditStatus(Integer auditStatus) {
        this.auditStatus = auditStatus;
    }

    public Integer getAuditStatusText() {
        return auditStatusText;
    }

    public void setAuditStatusText(Integer auditStatusText) {
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

    @Override
    public String toString() {
        return "MerchantInfoChangeVO{" +
            ", changeId=" + changeId +
            ", requestType=" + requestType +
            ", requestTypeText=" + requestTypeText +
            ", oldData=" + oldData +
            ", newData=" + newData +
            ", auditStatus=" + auditStatus +
            ", auditStatusText=" + auditStatusText +
            ", auditRemark=" + auditRemark +
            ", createTime=" + createTime +
            ", auditTime=" + auditTime +
            '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        MerchantInfoChangeVO that = (MerchantInfoChangeVO) o;
        return java.util.Objects.equals(changeId, that.changeId)
                && java.util.Objects.equals(requestType, that.requestType)
                && java.util.Objects.equals(requestTypeText, that.requestTypeText)
                && java.util.Objects.equals(oldData, that.oldData)
                && java.util.Objects.equals(newData, that.newData)
                && java.util.Objects.equals(auditStatus, that.auditStatus)
                && java.util.Objects.equals(auditStatusText, that.auditStatusText)
                && java.util.Objects.equals(auditRemark, that.auditRemark)
                && java.util.Objects.equals(createTime, that.createTime)
                && java.util.Objects.equals(auditTime, that.auditTime);
    }

    @Override
    public int hashCode() {
        return java.util.Objects.hash(changeId, requestType, requestTypeText, oldData, newData, auditStatus, auditStatusText, auditRemark, createTime, auditTime);
    }
}
