package com.socialretail.backend.entity.order;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@TableName("`order`")
public class Order {
    @TableId(value = "id", type = IdType.AUTO)
    private Long id;
    private String orderSn;
    private String idempotentKey;
    private Long userId;
    private Long merchantId;
    private Long pickupPointId;
    private Long addressId;
    private String consignee;
    private String phone;
    private String province;
    private String city;
    private String district;
    private String detailedAddress;
    private BigDecimal totalAmount;
    private BigDecimal payAmount;
    @TableField(value = "discount_amount")
    private BigDecimal discountAmount;
    private BigDecimal deliveryFee;
    private BigDecimal seckillDiscount;
    private BigDecimal bargainDiscount;
    private BigDecimal couponDiscount;
    private BigDecimal pointsDeduction;
    private Integer usedPoints;
    private Integer pointsStatus;
    private Long couponUserId;
    private Long seckillId;
    private Long bargainId;
    private String promotionSnapshot;
    private Integer deliveryType;
    private Integer status;
    private String pickupCode;
    private String remark;
    private LocalDateTime createTime;
    private LocalDateTime payExpireTime;
    private LocalDateTime payTime;
    private LocalDateTime cancelTime;
    private LocalDateTime updateTime;
    private LocalDateTime acceptTime;
    private LocalDateTime prepareTime;
    private LocalDateTime completeTime;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getOrderSn() { return orderSn; }
    public void setOrderSn(String orderSn) { this.orderSn = orderSn; }
    public String getIdempotentKey() { return idempotentKey; }
    public void setIdempotentKey(String idempotentKey) { this.idempotentKey = idempotentKey; }
    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }
    public Long getMerchantId() { return merchantId; }
    public void setMerchantId(Long merchantId) { this.merchantId = merchantId; }
    public Long getPickupPointId() { return pickupPointId; }
    public void setPickupPointId(Long pickupPointId) { this.pickupPointId = pickupPointId; }
    public Long getAddressId() { return addressId; }
    public void setAddressId(Long addressId) { this.addressId = addressId; }
    public String getConsignee() { return consignee; }
    public void setConsignee(String consignee) { this.consignee = consignee; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    public String getProvince() { return province; }
    public void setProvince(String province) { this.province = province; }
    public String getCity() { return city; }
    public void setCity(String city) { this.city = city; }
    public String getDistrict() { return district; }
    public void setDistrict(String district) { this.district = district; }
    public String getDetailedAddress() { return detailedAddress; }
    public void setDetailedAddress(String detailedAddress) { this.detailedAddress = detailedAddress; }
    public BigDecimal getTotalAmount() { return totalAmount; }
    public void setTotalAmount(BigDecimal totalAmount) { this.totalAmount = totalAmount; }
    public BigDecimal getPayAmount() { return payAmount; }
    public void setPayAmount(BigDecimal payAmount) { this.payAmount = payAmount; }
    public BigDecimal getDiscountAmount() { return discountAmount; }
    public void setDiscountAmount(BigDecimal discountAmount) { this.discountAmount = discountAmount; }
    public BigDecimal getDeliveryFee() { return deliveryFee; }
    public void setDeliveryFee(BigDecimal deliveryFee) { this.deliveryFee = deliveryFee; }
    public BigDecimal getSeckillDiscount() { return seckillDiscount; }
    public void setSeckillDiscount(BigDecimal seckillDiscount) { this.seckillDiscount = seckillDiscount; }
    public BigDecimal getBargainDiscount() { return bargainDiscount; }
    public void setBargainDiscount(BigDecimal bargainDiscount) { this.bargainDiscount = bargainDiscount; }
    public BigDecimal getCouponDiscount() { return couponDiscount; }
    public void setCouponDiscount(BigDecimal couponDiscount) { this.couponDiscount = couponDiscount; }
    public BigDecimal getPointsDeduction() { return pointsDeduction; }
    public void setPointsDeduction(BigDecimal pointsDeduction) { this.pointsDeduction = pointsDeduction; }
    public Integer getUsedPoints() { return usedPoints; }
    public void setUsedPoints(Integer usedPoints) { this.usedPoints = usedPoints; }
    public Integer getPointsStatus() { return pointsStatus; }
    public void setPointsStatus(Integer pointsStatus) { this.pointsStatus = pointsStatus; }
    public Long getCouponUserId() { return couponUserId; }
    public void setCouponUserId(Long couponUserId) { this.couponUserId = couponUserId; }
    public Long getSeckillId() { return seckillId; }
    public void setSeckillId(Long seckillId) { this.seckillId = seckillId; }
    public Long getBargainId() { return bargainId; }
    public void setBargainId(Long bargainId) { this.bargainId = bargainId; }
    public String getPromotionSnapshot() { return promotionSnapshot; }
    public void setPromotionSnapshot(String promotionSnapshot) { this.promotionSnapshot = promotionSnapshot; }
    public Integer getDeliveryType() { return deliveryType; }
    public void setDeliveryType(Integer deliveryType) { this.deliveryType = deliveryType; }
    public Integer getStatus() { return status; }
    public void setStatus(Integer status) { this.status = status; }
    public String getPickupCode() { return pickupCode; }
    public void setPickupCode(String pickupCode) { this.pickupCode = pickupCode; }
    public String getRemark() { return remark; }
    public void setRemark(String remark) { this.remark = remark; }
    public LocalDateTime getCreateTime() { return createTime; }
    public void setCreateTime(LocalDateTime createTime) { this.createTime = createTime; }
    public LocalDateTime getPayExpireTime() { return payExpireTime; }
    public void setPayExpireTime(LocalDateTime payExpireTime) { this.payExpireTime = payExpireTime; }
    public LocalDateTime getPayTime() { return payTime; }
    public void setPayTime(LocalDateTime payTime) { this.payTime = payTime; }
    public LocalDateTime getCancelTime() { return cancelTime; }
    public void setCancelTime(LocalDateTime cancelTime) { this.cancelTime = cancelTime; }
    public LocalDateTime getUpdateTime() { return updateTime; }
    public void setUpdateTime(LocalDateTime updateTime) { this.updateTime = updateTime; }
    public LocalDateTime getAcceptTime() { return acceptTime; }
    public void setAcceptTime(LocalDateTime acceptTime) { this.acceptTime = acceptTime; }
    public LocalDateTime getPrepareTime() { return prepareTime; }
    public void setPrepareTime(LocalDateTime prepareTime) { this.prepareTime = prepareTime; }
    public LocalDateTime getCompleteTime() { return completeTime; }
    public void setCompleteTime(LocalDateTime completeTime) { this.completeTime = completeTime; }
}
