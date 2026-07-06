package com.socialretail.backend.entity.member;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

import java.time.LocalDateTime;

@TableName("merchant")
public class Merchant {

    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    private Long userId;

    private String merchantName;

    private String logo;

    private String contactName;

    private String contactPhone;

    private String shopAddress;

    private String businessHours;

    private String introduction;

    private Integer status;

    private LocalDateTime createTime;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public String getMerchantName() {
        return merchantName;
    }

    public void setMerchantName(String merchantName) {
        this.merchantName = merchantName;
    }

    public String getLogo() {
        return logo;
    }

    public void setLogo(String logo) {
        this.logo = logo;
    }

    public String getContactName() {
        return contactName;
    }

    public void setContactName(String contactName) {
        this.contactName = contactName;
    }

    public String getContactPhone() {
        return contactPhone;
    }

    public void setContactPhone(String contactPhone) {
        this.contactPhone = contactPhone;
    }

    public String getShopAddress() {
        return shopAddress;
    }

    public void setShopAddress(String shopAddress) {
        this.shopAddress = shopAddress;
    }

    public String getBusinessHours() {
        return businessHours;
    }

    public void setBusinessHours(String businessHours) {
        this.businessHours = businessHours;
    }

    public String getIntroduction() {
        return introduction;
    }

    public void setIntroduction(String introduction) {
        this.introduction = introduction;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    public LocalDateTime getCreateTime() {
        return createTime;
    }

    public void setCreateTime(LocalDateTime createTime) {
        this.createTime = createTime;
    }

    @Override
    public String toString() {
        return "Merchant{" +
            ", id=" + id +
            ", userId=" + userId +
            ", merchantName=" + merchantName +
            ", logo=" + logo +
            ", contactName=" + contactName +
            ", contactPhone=" + contactPhone +
            ", shopAddress=" + shopAddress +
            ", businessHours=" + businessHours +
            ", introduction=" + introduction +
            ", status=" + status +
            ", createTime=" + createTime +
            '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Merchant that = (Merchant) o;
        return java.util.Objects.equals(id, that.id)
                && java.util.Objects.equals(userId, that.userId)
                && java.util.Objects.equals(merchantName, that.merchantName)
                && java.util.Objects.equals(logo, that.logo)
                && java.util.Objects.equals(contactName, that.contactName)
                && java.util.Objects.equals(contactPhone, that.contactPhone)
                && java.util.Objects.equals(shopAddress, that.shopAddress)
                && java.util.Objects.equals(businessHours, that.businessHours)
                && java.util.Objects.equals(introduction, that.introduction)
                && java.util.Objects.equals(status, that.status)
                && java.util.Objects.equals(createTime, that.createTime);
    }

    @Override
    public int hashCode() {
        return java.util.Objects.hash(id, userId, merchantName, logo, contactName, contactPhone, shopAddress, businessHours, introduction, status, createTime);
    }
}
