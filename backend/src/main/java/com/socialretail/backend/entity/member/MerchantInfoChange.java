package com.socialretail.backend.entity.member;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

import java.time.LocalDateTime;

@TableName("merchant_info_change")
public class MerchantInfoChange {

    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    private Long merchantId;

    private String requestType;

    private String oldData;

    private String newData;

    private Integer auditStatus;

    private String auditRemark;

    private LocalDateTime createTime;

    private LocalDateTime auditTime;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getMerchantId() {
        return merchantId;
    }

    public void setMerchantId(Long merchantId) {
        this.merchantId = merchantId;
    }

    public String getRequestType() {
        return requestType;
    }

    public void setRequestType(String requestType) {
        this.requestType = requestType;
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

    public String getAuditRemark() {
        return auditRemark;
    }

    public void setAuditRemark(String auditRemark) {
        this.auditRemark = auditRemark;
    }

    public LocalDateTime getCreateTime() {
        return createTime;
    }

    public void setCreateTime(LocalDateTime createTime) {
        this.createTime = createTime;
    }

    public LocalDateTime getAuditTime() {
        return auditTime;
    }

    public void setAuditTime(LocalDateTime auditTime) {
        this.auditTime = auditTime;
    }

    @Override
    public String toString() {
        return "MerchantInfoChange{" +
            ", id=" + id +
            ", merchantId=" + merchantId +
            ", requestType=" + requestType +
            ", oldData=" + oldData +
            ", newData=" + newData +
            ", auditStatus=" + auditStatus +
            ", auditRemark=" + auditRemark +
            ", createTime=" + createTime +
            ", auditTime=" + auditTime +
            '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        MerchantInfoChange that = (MerchantInfoChange) o;
        return java.util.Objects.equals(id, that.id)
                && java.util.Objects.equals(merchantId, that.merchantId)
                && java.util.Objects.equals(requestType, that.requestType)
                && java.util.Objects.equals(oldData, that.oldData)
                && java.util.Objects.equals(newData, that.newData)
                && java.util.Objects.equals(auditStatus, that.auditStatus)
                && java.util.Objects.equals(auditRemark, that.auditRemark)
                && java.util.Objects.equals(createTime, that.createTime)
                && java.util.Objects.equals(auditTime, that.auditTime);
    }

    @Override
    public int hashCode() {
        return java.util.Objects.hash(id, merchantId, requestType, oldData, newData, auditStatus, auditRemark, createTime, auditTime);
    }
}
