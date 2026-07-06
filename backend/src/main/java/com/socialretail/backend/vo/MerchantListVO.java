package com.socialretail.backend.vo;


import java.math.BigDecimal;

public class MerchantListVO {

    private Long merchantId;
    private String merchantName;
    private String logo;
    private String contactName;
    private String contactPhone;
    private String shopAddress;
    private Integer status;
    private String statusText;
    private Integer productCount;
    private Integer totalOrders;
    private BigDecimal totalAmount;
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

    public Integer getProductCount() {
        return productCount;
    }

    public void setProductCount(Integer productCount) {
        this.productCount = productCount;
    }

    public Integer getTotalOrders() {
        return totalOrders;
    }

    public void setTotalOrders(Integer totalOrders) {
        this.totalOrders = totalOrders;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getCreateTime() {
        return createTime;
    }

    public void setCreateTime(String createTime) {
        this.createTime = createTime;
    }

    @Override
    public String toString() {
        return "MerchantListVO{" +
            ", merchantId=" + merchantId +
            ", merchantName=" + merchantName +
            ", logo=" + logo +
            ", contactName=" + contactName +
            ", contactPhone=" + contactPhone +
            ", shopAddress=" + shopAddress +
            ", status=" + status +
            ", statusText=" + statusText +
            ", productCount=" + productCount +
            ", totalOrders=" + totalOrders +
            ", totalAmount=" + totalAmount +
            ", createTime=" + createTime +
            '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        MerchantListVO that = (MerchantListVO) o;
        return java.util.Objects.equals(merchantId, that.merchantId)
                && java.util.Objects.equals(merchantName, that.merchantName)
                && java.util.Objects.equals(logo, that.logo)
                && java.util.Objects.equals(contactName, that.contactName)
                && java.util.Objects.equals(contactPhone, that.contactPhone)
                && java.util.Objects.equals(shopAddress, that.shopAddress)
                && java.util.Objects.equals(status, that.status)
                && java.util.Objects.equals(statusText, that.statusText)
                && java.util.Objects.equals(productCount, that.productCount)
                && java.util.Objects.equals(totalOrders, that.totalOrders)
                && java.util.Objects.equals(totalAmount, that.totalAmount)
                && java.util.Objects.equals(createTime, that.createTime);
    }

    @Override
    public int hashCode() {
        return java.util.Objects.hash(merchantId, merchantName, logo, contactName, contactPhone, shopAddress, status, statusText, productCount, totalOrders, totalAmount, createTime);
    }
}
