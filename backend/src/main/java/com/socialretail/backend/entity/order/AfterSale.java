package com.socialretail.backend.entity.order;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
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

    private Integer type;

    private BigDecimal refundAmount;

    private BigDecimal actualRefundAmount;

    private String reason;

    private String evidenceImages;

    private String productName;

    private String skuSpecs;

    private Integer status;

    private String auditRemark;

    private LocalDateTime auditTime;

    @TableField(value = "return_received_status")
    private Integer returnReceivedStatus;

    @TableField(value = "return_received_time")
    private LocalDateTime returnReceivedTime;

    private String feedbackContent;

    private String feedbackImages;

    private LocalDateTime completeTime;

    private LocalDateTime applyTime;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Long getOrderId() { return orderId; }
    public void setOrderId(Long orderId) { this.orderId = orderId; }
    public Long getOrderItemId() { return orderItemId; }
    public void setOrderItemId(Long orderItemId) { this.orderItemId = orderItemId; }
    public String getOrderSn() { return orderSn; }
    public void setOrderSn(String orderSn) { this.orderSn = orderSn; }
    public Integer getType() { return type; }
    public void setType(Integer type) { this.type = type; }
    public BigDecimal getRefundAmount() { return refundAmount; }
    public void setRefundAmount(BigDecimal refundAmount) { this.refundAmount = refundAmount; }
    public BigDecimal getActualRefundAmount() { return actualRefundAmount; }
    public void setActualRefundAmount(BigDecimal actualRefundAmount) { this.actualRefundAmount = actualRefundAmount; }
    public String getReason() { return reason; }
    public void setReason(String reason) { this.reason = reason; }
    public String getEvidenceImages() { return evidenceImages; }
    public void setEvidenceImages(String evidenceImages) { this.evidenceImages = evidenceImages; }
    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }
    public String getSkuSpecs() { return skuSpecs; }
    public void setSkuSpecs(String skuSpecs) { this.skuSpecs = skuSpecs; }
    public Integer getStatus() { return status; }
    public void setStatus(Integer status) { this.status = status; }
    public String getAuditRemark() { return auditRemark; }
    public void setAuditRemark(String auditRemark) { this.auditRemark = auditRemark; }
    public LocalDateTime getAuditTime() { return auditTime; }
    public void setAuditTime(LocalDateTime auditTime) { this.auditTime = auditTime; }
    public Integer getReturnReceivedStatus() { return returnReceivedStatus; }
    public void setReturnReceivedStatus(Integer returnReceivedStatus) { this.returnReceivedStatus = returnReceivedStatus; }
    public LocalDateTime getReturnReceivedTime() { return returnReceivedTime; }
    public void setReturnReceivedTime(LocalDateTime returnReceivedTime) { this.returnReceivedTime = returnReceivedTime; }
    public String getFeedbackContent() { return feedbackContent; }
    public void setFeedbackContent(String feedbackContent) { this.feedbackContent = feedbackContent; }
    public String getFeedbackImages() { return feedbackImages; }
    public void setFeedbackImages(String feedbackImages) { this.feedbackImages = feedbackImages; }
    public LocalDateTime getCompleteTime() { return completeTime; }
    public void setCompleteTime(LocalDateTime completeTime) { this.completeTime = completeTime; }
    public LocalDateTime getApplyTime() { return applyTime; }
    public void setApplyTime(LocalDateTime applyTime) { this.applyTime = applyTime; }
}
