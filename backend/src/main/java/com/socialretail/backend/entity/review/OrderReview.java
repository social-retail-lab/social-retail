package com.socialretail.backend.entity.review;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

import java.time.LocalDateTime;

@TableName("order_review")
public class OrderReview {

    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    private Long orderId;

    private String orderSn;

    private Long userId;

    private Long merchantId;

    private Long productId;

    private Integer rating;

    private String content;

    private String images;

    private Integer isAnonymous;

    private Integer appealStatus;

    private String appealReason;

    private String appealEvidence;

    private LocalDateTime appealTime;

    private String auditResult;

    private LocalDateTime auditTime;

    private LocalDateTime createTime;

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

    public String getOrderSn() {
        return orderSn;
    }

    public void setOrderSn(String orderSn) {
        this.orderSn = orderSn;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public Long getMerchantId() {
        return merchantId;
    }

    public void setMerchantId(Long merchantId) {
        this.merchantId = merchantId;
    }

    public Long getProductId() {
        return productId;
    }

    public void setProductId(Long productId) {
        this.productId = productId;
    }

    public Integer getRating() {
        return rating;
    }

    public void setRating(Integer rating) {
        this.rating = rating;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getImages() {
        return images;
    }

    public void setImages(String images) {
        this.images = images;
    }

    public Integer getIsAnonymous() {
        return isAnonymous;
    }

    public void setIsAnonymous(Integer isAnonymous) {
        this.isAnonymous = isAnonymous;
    }

    public Integer getAppealStatus() {
        return appealStatus;
    }

    public void setAppealStatus(Integer appealStatus) {
        this.appealStatus = appealStatus;
    }

    public String getAppealReason() {
        return appealReason;
    }

    public void setAppealReason(String appealReason) {
        this.appealReason = appealReason;
    }

    public String getAppealEvidence() {
        return appealEvidence;
    }

    public void setAppealEvidence(String appealEvidence) {
        this.appealEvidence = appealEvidence;
    }

    public LocalDateTime getAppealTime() {
        return appealTime;
    }

    public void setAppealTime(LocalDateTime appealTime) {
        this.appealTime = appealTime;
    }

    public String getAuditResult() {
        return auditResult;
    }

    public void setAuditResult(String auditResult) {
        this.auditResult = auditResult;
    }

    public LocalDateTime getAuditTime() {
        return auditTime;
    }

    public void setAuditTime(LocalDateTime auditTime) {
        this.auditTime = auditTime;
    }

    public LocalDateTime getCreateTime() {
        return createTime;
    }

    public void setCreateTime(LocalDateTime createTime) {
        this.createTime = createTime;
    }

    @Override
    public String toString() {
        return "OrderReview{" +
            ", id=" + id +
            ", orderId=" + orderId +
            ", orderSn=" + orderSn +
            ", userId=" + userId +
            ", merchantId=" + merchantId +
            ", productId=" + productId +
            ", rating=" + rating +
            ", content=" + content +
            ", images=" + images +
            ", isAnonymous=" + isAnonymous +
            ", appealStatus=" + appealStatus +
            ", appealReason=" + appealReason +
            ", appealEvidence=" + appealEvidence +
            ", appealTime=" + appealTime +
            ", auditResult=" + auditResult +
            ", auditTime=" + auditTime +
            ", createTime=" + createTime +
            '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        OrderReview that = (OrderReview) o;
        return java.util.Objects.equals(id, that.id)
                && java.util.Objects.equals(orderId, that.orderId)
                && java.util.Objects.equals(orderSn, that.orderSn)
                && java.util.Objects.equals(userId, that.userId)
                && java.util.Objects.equals(merchantId, that.merchantId)
                && java.util.Objects.equals(productId, that.productId)
                && java.util.Objects.equals(rating, that.rating)
                && java.util.Objects.equals(content, that.content)
                && java.util.Objects.equals(images, that.images)
                && java.util.Objects.equals(isAnonymous, that.isAnonymous)
                && java.util.Objects.equals(appealStatus, that.appealStatus)
                && java.util.Objects.equals(appealReason, that.appealReason)
                && java.util.Objects.equals(appealEvidence, that.appealEvidence)
                && java.util.Objects.equals(appealTime, that.appealTime)
                && java.util.Objects.equals(auditResult, that.auditResult)
                && java.util.Objects.equals(auditTime, that.auditTime)
                && java.util.Objects.equals(createTime, that.createTime);
    }

    @Override
    public int hashCode() {
        return java.util.Objects.hash(id, orderId, orderSn, userId, merchantId, productId, rating, content, images, isAnonymous, appealStatus, appealReason, appealEvidence, appealTime, auditResult, auditTime, createTime);
    }
}
