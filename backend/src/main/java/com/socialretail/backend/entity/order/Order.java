package com.socialretail.backend.entity.order;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@TableName("`order`")
public class Order {

    @TableId(type = IdType.AUTO)
    private Long id;

    /** 订单编号 */
    private String orderSn;

    /** 用户ID */
    private Long userId;

    /** 商家ID */
    private Long merchantId;

    /** 自提点ID */
    private Long pickupPointId;

    /** 订单原价总额 */
    private BigDecimal totalAmount;

    /** 实付金额 */
    private BigDecimal payAmount;

    /** 平台优惠券抵扣 */
    private BigDecimal couponDiscount;

    /** 配送方式 1-自提 2-物流 */
    private Integer deliveryType;

    /** 物流费用 */
    private BigDecimal deliveryFee;

    /** 订单状态 */
    private Integer status;

    /** 支付方式 */
    private Integer payMethod;

    /** 支付时间 */
    private LocalDateTime payTime;

    /** 下单时间 */
    private LocalDateTime createTime;

    /** 更新时间 */
    private LocalDateTime updateTime;

    /** 平台佣金 */
    private BigDecimal commission;

    /** 佣金费率 */
    private BigDecimal commissionRate;

    /** 商家层级 */
    private String merchantTier;

    /** 平台补贴 */
    private BigDecimal platformSubsidy;

    /** 净收入 */
    private BigDecimal netIncome;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
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

    public Long getPickupPointId() {
        return pickupPointId;
    }

    public void setPickupPointId(Long pickupPointId) {
        this.pickupPointId = pickupPointId;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }

    public BigDecimal getPayAmount() {
        return payAmount;
    }

    public void setPayAmount(BigDecimal payAmount) {
        this.payAmount = payAmount;
    }

    public BigDecimal getCouponDiscount() {
        return couponDiscount;
    }

    public void setCouponDiscount(BigDecimal couponDiscount) {
        this.couponDiscount = couponDiscount;
    }

    public Integer getDeliveryType() {
        return deliveryType;
    }

    public void setDeliveryType(Integer deliveryType) {
        this.deliveryType = deliveryType;
    }

    public BigDecimal getDeliveryFee() {
        return deliveryFee;
    }

    public void setDeliveryFee(BigDecimal deliveryFee) {
        this.deliveryFee = deliveryFee;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    public Integer getPayMethod() {
        return payMethod;
    }

    public void setPayMethod(Integer payMethod) {
        this.payMethod = payMethod;
    }

    public LocalDateTime getPayTime() {
        return payTime;
    }

    public void setPayTime(LocalDateTime payTime) {
        this.payTime = payTime;
    }

    public LocalDateTime getCreateTime() {
        return createTime;
    }

    public void setCreateTime(LocalDateTime createTime) {
        this.createTime = createTime;
    }

    public LocalDateTime getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(LocalDateTime updateTime) {
        this.updateTime = updateTime;
    }

    public BigDecimal getCommission() {
        return commission;
    }

    public void setCommission(BigDecimal commission) {
        this.commission = commission;
    }

    public BigDecimal getCommissionRate() {
        return commissionRate;
    }

    public void setCommissionRate(BigDecimal commissionRate) {
        this.commissionRate = commissionRate;
    }

    public String getMerchantTier() {
        return merchantTier;
    }

    public void setMerchantTier(String merchantTier) {
        this.merchantTier = merchantTier;
    }

    public BigDecimal getPlatformSubsidy() {
        return platformSubsidy;
    }

    public void setPlatformSubsidy(BigDecimal platformSubsidy) {
        this.platformSubsidy = platformSubsidy;
    }

    public BigDecimal getNetIncome() {
        return netIncome;
    }

    public void setNetIncome(BigDecimal netIncome) {
        this.netIncome = netIncome;
    }

    @Override
    public String toString() {
        return "Order{" +
            ", id=" + id +
            ", orderSn=" + orderSn +
            ", userId=" + userId +
            ", merchantId=" + merchantId +
            ", pickupPointId=" + pickupPointId +
            ", totalAmount=" + totalAmount +
            ", payAmount=" + payAmount +
            ", couponDiscount=" + couponDiscount +
            ", deliveryType=" + deliveryType +
            ", deliveryFee=" + deliveryFee +
            ", status=" + status +
            ", payMethod=" + payMethod +
            ", payTime=" + payTime +
            ", createTime=" + createTime +
            ", updateTime=" + updateTime +
            '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Order that = (Order) o;
        return java.util.Objects.equals(id, that.id)
                && java.util.Objects.equals(orderSn, that.orderSn)
                && java.util.Objects.equals(userId, that.userId)
                && java.util.Objects.equals(merchantId, that.merchantId)
                && java.util.Objects.equals(pickupPointId, that.pickupPointId)
                && java.util.Objects.equals(totalAmount, that.totalAmount)
                && java.util.Objects.equals(payAmount, that.payAmount)
                && java.util.Objects.equals(couponDiscount, that.couponDiscount)
                && java.util.Objects.equals(deliveryType, that.deliveryType)
                && java.util.Objects.equals(deliveryFee, that.deliveryFee)
                && java.util.Objects.equals(status, that.status)
                && java.util.Objects.equals(payMethod, that.payMethod)
                && java.util.Objects.equals(payTime, that.payTime)
                && java.util.Objects.equals(createTime, that.createTime)
                && java.util.Objects.equals(updateTime, that.updateTime);
    }

    @Override
    public int hashCode() {
        return java.util.Objects.hash(id, orderSn, userId, merchantId, pickupPointId, totalAmount, payAmount, couponDiscount, deliveryType, deliveryFee, status, payMethod, payTime, createTime, updateTime);
    }
}
