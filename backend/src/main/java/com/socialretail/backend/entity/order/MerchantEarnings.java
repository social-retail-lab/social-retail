package com.socialretail.backend.entity.order;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@TableName("merchant_earnings")
public class MerchantEarnings {

    @TableId(type = IdType.AUTO)
    private Long id;

    /** 商家ID */
    private Long merchantId;

    /** 订单ID */
    private Long orderId;

    /** 订单编号 */
    private String orderSn;

    /** 收益金额 */
    private BigDecimal amount;

    /** 状态 0-冻结中 1-可提现 2-已提现 */
    private Integer status;

    /** 冻结时间(订单完成时间) */
    private LocalDateTime freezeTime;

    /** 解冻时间(冻结后4小时) */
    private LocalDateTime unfreezeTime;

    /** 提现时间 */
    private LocalDateTime withdrawTime;

    /** 创建时间 */
    private LocalDateTime createTime;

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

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    public LocalDateTime getFreezeTime() {
        return freezeTime;
    }

    public void setFreezeTime(LocalDateTime freezeTime) {
        this.freezeTime = freezeTime;
    }

    public LocalDateTime getUnfreezeTime() {
        return unfreezeTime;
    }

    public void setUnfreezeTime(LocalDateTime unfreezeTime) {
        this.unfreezeTime = unfreezeTime;
    }

    public LocalDateTime getWithdrawTime() {
        return withdrawTime;
    }

    public void setWithdrawTime(LocalDateTime withdrawTime) {
        this.withdrawTime = withdrawTime;
    }

    public LocalDateTime getCreateTime() {
        return createTime;
    }

    public void setCreateTime(LocalDateTime createTime) {
        this.createTime = createTime;
    }

    @Override
    public String toString() {
        return "MerchantEarnings{" +
            ", id=" + id +
            ", merchantId=" + merchantId +
            ", orderId=" + orderId +
            ", orderSn=" + orderSn +
            ", amount=" + amount +
            ", status=" + status +
            ", freezeTime=" + freezeTime +
            ", unfreezeTime=" + unfreezeTime +
            ", withdrawTime=" + withdrawTime +
            ", createTime=" + createTime +
            '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        MerchantEarnings that = (MerchantEarnings) o;
        return java.util.Objects.equals(id, that.id)
                && java.util.Objects.equals(merchantId, that.merchantId)
                && java.util.Objects.equals(orderId, that.orderId)
                && java.util.Objects.equals(orderSn, that.orderSn)
                && java.util.Objects.equals(amount, that.amount)
                && java.util.Objects.equals(status, that.status)
                && java.util.Objects.equals(freezeTime, that.freezeTime)
                && java.util.Objects.equals(unfreezeTime, that.unfreezeTime)
                && java.util.Objects.equals(withdrawTime, that.withdrawTime)
                && java.util.Objects.equals(createTime, that.createTime);
    }

    @Override
    public int hashCode() {
        return java.util.Objects.hash(id, merchantId, orderId, orderSn, amount, status, freezeTime, unfreezeTime, withdrawTime, createTime);
    }
}
