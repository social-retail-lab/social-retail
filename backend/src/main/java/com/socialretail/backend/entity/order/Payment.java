package com.socialretail.backend.entity.order;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@TableName("payment")
public class Payment {

    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    private Long orderId;

    private Integer refundStatus;

    private BigDecimal refundAmount;

    private LocalDateTime refundTime;

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

    public Integer getRefundStatus() {
        return refundStatus;
    }

    public void setRefundStatus(Integer refundStatus) {
        this.refundStatus = refundStatus;
    }

    public BigDecimal getRefundAmount() {
        return refundAmount;
    }

    public void setRefundAmount(BigDecimal refundAmount) {
        this.refundAmount = refundAmount;
    }

    public LocalDateTime getRefundTime() {
        return refundTime;
    }

    public void setRefundTime(LocalDateTime refundTime) {
        this.refundTime = refundTime;
    }

    @Override
    public String toString() {
        return "Payment{" +
            ", id=" + id +
            ", orderId=" + orderId +
            ", refundStatus=" + refundStatus +
            ", refundAmount=" + refundAmount +
            ", refundTime=" + refundTime +
            '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Payment that = (Payment) o;
        return java.util.Objects.equals(id, that.id)
                && java.util.Objects.equals(orderId, that.orderId)
                && java.util.Objects.equals(refundStatus, that.refundStatus)
                && java.util.Objects.equals(refundAmount, that.refundAmount)
                && java.util.Objects.equals(refundTime, that.refundTime);
    }

    @Override
    public int hashCode() {
        return java.util.Objects.hash(id, orderId, refundStatus, refundAmount, refundTime);
    }
}
