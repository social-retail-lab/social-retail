package com.socialretail.backend.entity.order;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@TableName("after_sale")
public class AfterSale {

    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    private Long orderId;

    private Long orderItemId;

    private String orderSn;

    private String productName;

    private String skuSpecs;

    private Integer type;

    private BigDecimal refundAmount;

    private BigDecimal actualRefundAmount;

    private String reason;

    private String rejectReason;

    private Integer status;

    private LocalDateTime applyTime;

    private LocalDateTime auditTime;

    private String auditRemark;

    private LocalDateTime completeTime;

    private String evidenceImages;

    private String feedbackContent;

    private String feedbackImages;

    private LocalDateTime returnReceivedTime;

    private Integer returnReceivedStatus;

    private Integer appealStatus;

    private LocalDateTime appealTime;

    private String appealReason;

    private Integer interveneResult;

    private Integer interveneAction;

    private String interveneRemark;

    private LocalDateTime interveneTime;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getOrderId() {
        return orderId;
    }

    public void setOrderId(Long orderId) {
        this.orderId = orderId;
    }

    public Long getOrderItemId() {
        return orderItemId;
    }

    public void setOrderItemId(Long orderItemId) {
        this.orderItemId = orderItemId;
    }

    public String getOrderSn() {
        return orderSn;
    }

    public void setOrderSn(String orderSn) {
        this.orderSn = orderSn;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getSkuSpecs() {
        return skuSpecs;
    }

    public void setSkuSpecs(String skuSpecs) {
        this.skuSpecs = skuSpecs;
    }

    public Integer getType() {
        return type;
    }

    public void setType(Integer type) {
        this.type = type;
    }

    public BigDecimal getRefundAmount() {
        return refundAmount;
    }

    public void setRefundAmount(BigDecimal refundAmount) {
        this.refundAmount = refundAmount;
    }

    public BigDecimal getActualRefundAmount() {
        return actualRefundAmount;
    }

    public void setActualRefundAmount(BigDecimal actualRefundAmount) {
        this.actualRefundAmount = actualRefundAmount;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public String getRejectReason() {
        return rejectReason;
    }

    public void setRejectReason(String rejectReason) {
        this.rejectReason = rejectReason;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    public LocalDateTime getApplyTime() {
        return applyTime;
    }

    public void setApplyTime(LocalDateTime applyTime) {
        this.applyTime = applyTime;
    }

    public LocalDateTime getAuditTime() {
        return auditTime;
    }

    public void setAuditTime(LocalDateTime auditTime) {
        this.auditTime = auditTime;
    }

    public String getAuditRemark() {
        return auditRemark;
    }

    public void setAuditRemark(String auditRemark) {
        this.auditRemark = auditRemark;
    }

    public LocalDateTime getCompleteTime() {
        return completeTime;
    }

    public void setCompleteTime(LocalDateTime completeTime) {
        this.completeTime = completeTime;
    }

    public String getEvidenceImages() {
        return evidenceImages;
    }

    public void setEvidenceImages(String evidenceImages) {
        this.evidenceImages = evidenceImages;
    }

    public String getFeedbackContent() {
        return feedbackContent;
    }

    public void setFeedbackContent(String feedbackContent) {
        this.feedbackContent = feedbackContent;
    }

    public String getFeedbackImages() {
        return feedbackImages;
    }

    public void setFeedbackImages(String feedbackImages) {
        this.feedbackImages = feedbackImages;
    }

    public LocalDateTime getReturnReceivedTime() {
        return returnReceivedTime;
    }

    public void setReturnReceivedTime(LocalDateTime returnReceivedTime) {
        this.returnReceivedTime = returnReceivedTime;
    }

    public Integer getReturnReceivedStatus() {
        return returnReceivedStatus;
    }

    public void setReturnReceivedStatus(Integer returnReceivedStatus) {
        this.returnReceivedStatus = returnReceivedStatus;
    }

    public Integer getAppealStatus() {
        return appealStatus;
    }

    public void setAppealStatus(Integer appealStatus) {
        this.appealStatus = appealStatus;
    }

    public LocalDateTime getAppealTime() {
        return appealTime;
    }

    public void setAppealTime(LocalDateTime appealTime) {
        this.appealTime = appealTime;
    }

    public String getAppealReason() {
        return appealReason;
    }

    public void setAppealReason(String appealReason) {
        this.appealReason = appealReason;
    }

    public Integer getInterveneResult() {
        return interveneResult;
    }

    public void setInterveneResult(Integer interveneResult) {
        this.interveneResult = interveneResult;
    }

    public Integer getInterveneAction() {
        return interveneAction;
    }

    public void setInterveneAction(Integer interveneAction) {
        this.interveneAction = interveneAction;
    }

    public String getInterveneRemark() {
        return interveneRemark;
    }

    public void setInterveneRemark(String interveneRemark) {
        this.interveneRemark = interveneRemark;
    }

    public LocalDateTime getInterveneTime() {
        return interveneTime;
    }

    public void setInterveneTime(LocalDateTime interveneTime) {
        this.interveneTime = interveneTime;
    }

    @Override
    public String toString() {
        return "AfterSale{" +
            ", id=" + id +
            ", orderId=" + orderId +
            ", orderItemId=" + orderItemId +
            ", orderSn=" + orderSn +
            ", productName=" + productName +
            ", skuSpecs=" + skuSpecs +
            ", type=" + type +
            ", refundAmount=" + refundAmount +
            ", actualRefundAmount=" + actualRefundAmount +
            ", reason=" + reason +
            ", rejectReason=" + rejectReason +
            ", status=" + status +
            ", applyTime=" + applyTime +
            ", auditTime=" + auditTime +
            ", auditRemark=" + auditRemark +
            ", completeTime=" + completeTime +
            ", evidenceImages=" + evidenceImages +
            ", feedbackContent=" + feedbackContent +
            ", feedbackImages=" + feedbackImages +
            ", returnReceivedTime=" + returnReceivedTime +
            ", returnReceivedStatus=" + returnReceivedStatus +
            ", appealStatus=" + appealStatus +
            ", appealTime=" + appealTime +
            ", appealReason=" + appealReason +
            ", interveneResult=" + interveneResult +
            ", interveneAction=" + interveneAction +
            ", interveneRemark=" + interveneRemark +
            ", interveneTime=" + interveneTime +
            '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        AfterSale that = (AfterSale) o;
        return java.util.Objects.equals(id, that.id)
                && java.util.Objects.equals(orderId, that.orderId)
                && java.util.Objects.equals(orderItemId, that.orderItemId)
                && java.util.Objects.equals(orderSn, that.orderSn)
                && java.util.Objects.equals(productName, that.productName)
                && java.util.Objects.equals(skuSpecs, that.skuSpecs)
                && java.util.Objects.equals(type, that.type)
                && java.util.Objects.equals(refundAmount, that.refundAmount)
                && java.util.Objects.equals(actualRefundAmount, that.actualRefundAmount)
                && java.util.Objects.equals(reason, that.reason)
                && java.util.Objects.equals(rejectReason, that.rejectReason)
                && java.util.Objects.equals(status, that.status)
                && java.util.Objects.equals(applyTime, that.applyTime)
                && java.util.Objects.equals(auditTime, that.auditTime)
                && java.util.Objects.equals(auditRemark, that.auditRemark)
                && java.util.Objects.equals(completeTime, that.completeTime)
                && java.util.Objects.equals(evidenceImages, that.evidenceImages)
                && java.util.Objects.equals(feedbackContent, that.feedbackContent)
                && java.util.Objects.equals(feedbackImages, that.feedbackImages)
                && java.util.Objects.equals(returnReceivedTime, that.returnReceivedTime)
                && java.util.Objects.equals(returnReceivedStatus, that.returnReceivedStatus)
                && java.util.Objects.equals(appealStatus, that.appealStatus)
                && java.util.Objects.equals(appealTime, that.appealTime)
                && java.util.Objects.equals(appealReason, that.appealReason)
                && java.util.Objects.equals(interveneResult, that.interveneResult)
                && java.util.Objects.equals(interveneAction, that.interveneAction)
                && java.util.Objects.equals(interveneRemark, that.interveneRemark)
                && java.util.Objects.equals(interveneTime, that.interveneTime);
    }

    @Override
    public int hashCode() {
        return java.util.Objects.hash(id, orderId, orderItemId, orderSn, productName, skuSpecs, type, refundAmount, actualRefundAmount, reason, rejectReason, status, applyTime, auditTime, auditRemark, completeTime, evidenceImages, feedbackContent, feedbackImages, returnReceivedTime, returnReceivedStatus, appealStatus, appealTime, appealReason, interveneResult, interveneAction, interveneRemark, interveneTime);
    }
}
