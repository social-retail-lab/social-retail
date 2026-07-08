package com.socialretail.backend.vo;


public class MerchantInfoVO {

    private Long merchantId;
    private String merchantName;
    private String logo;
    private String contactName;
    private String contactPhone;
    private String shopAddress;
    private String businessHours;
    private String introduction;
    private Integer status;
    private String statusText;
    private String createTime;

    public Long getMerchantId() {
        return merchantId;
    }

    public void setMerchantId(Long merchantId) {
        this.merchantId = merchantId;
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

    public String getStatusText() {
        return statusText;
    }

    public void setStatusText(String statusText) {
        this.statusText = statusText;
    }

    public String getCreateTime() {
        return createTime;
    }

    public void setCreateTime(String createTime) {
        this.createTime = createTime;
    }

    @Override
    public String toString() {
        return "MerchantInfoVO{" +
            ", merchantId=" + merchantId +
            ", merchantName=" + merchantName +
            ", logo=" + logo +
            ", contactName=" + contactName +
            ", contactPhone=" + contactPhone +
            ", shopAddress=" + shopAddress +
            ", businessHours=" + businessHours +
            ", introduction=" + introduction +
            ", status=" + status +
            ", statusText=" + statusText +
            ", createTime=" + createTime +
            '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        MerchantInfoVO that = (MerchantInfoVO) o;
        return java.util.Objects.equals(merchantId, that.merchantId)
                && java.util.Objects.equals(merchantName, that.merchantName)
                && java.util.Objects.equals(logo, that.logo)
                && java.util.Objects.equals(contactName, that.contactName)
                && java.util.Objects.equals(contactPhone, that.contactPhone)
                && java.util.Objects.equals(shopAddress, that.shopAddress)
                && java.util.Objects.equals(businessHours, that.businessHours)
                && java.util.Objects.equals(introduction, that.introduction)
                && java.util.Objects.equals(status, that.status)
                && java.util.Objects.equals(statusText, that.statusText)
                && java.util.Objects.equals(createTime, that.createTime);
    }

    @Override
    public int hashCode() {
        return java.util.Objects.hash(merchantId, merchantName, logo, contactName, contactPhone, shopAddress, businessHours, introduction, status, statusText, createTime);
    }
}
