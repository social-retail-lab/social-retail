package com.socialretail.backend.vo;


public class AuditRequest {

    private Integer auditStatus;
    private String auditRemark;

    public Integer getAuditStatus() {
        return auditStatus;
    }

    public void setAuditStatus(Integer auditStatus) {
        this.auditStatus = auditStatus;
    }

    public String getAuditRemark() {
        return auditRemark;
    }

    public void setAuditRemark(String auditRemark) {
        this.auditRemark = auditRemark;
    }

    @Override
    public String toString() {
        return "AuditRequest{" +
            ", auditStatus=" + auditStatus +
            ", auditRemark=" + auditRemark +
            '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        AuditRequest that = (AuditRequest) o;
        return java.util.Objects.equals(auditStatus, that.auditStatus)
                && java.util.Objects.equals(auditRemark, that.auditRemark);
    }

    @Override
    public int hashCode() {
        return java.util.Objects.hash(auditStatus, auditRemark);
    }
}
