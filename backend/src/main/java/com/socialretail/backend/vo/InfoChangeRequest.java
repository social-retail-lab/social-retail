package com.socialretail.backend.vo;


public class InfoChangeRequest {

    private String merchantName;

    private String contactName;

    private String contactPhone;

    private String shopAddress;

    private String businessHours;

    private String introduction;

    public String getMerchantName() {
        return merchantName;
    }

    public void setMerchantName(String merchantName) {
        this.merchantName = merchantName;
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

    @Override
    public String toString() {
        return "InfoChangeRequest{" +
            ", merchantName=" + merchantName +
            ", contactName=" + contactName +
            ", contactPhone=" + contactPhone +
            ", shopAddress=" + shopAddress +
            ", businessHours=" + businessHours +
            ", introduction=" + introduction +
            '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        InfoChangeRequest that = (InfoChangeRequest) o;
        return java.util.Objects.equals(merchantName, that.merchantName)
                && java.util.Objects.equals(contactName, that.contactName)
                && java.util.Objects.equals(contactPhone, that.contactPhone)
                && java.util.Objects.equals(shopAddress, that.shopAddress)
                && java.util.Objects.equals(businessHours, that.businessHours)
                && java.util.Objects.equals(introduction, that.introduction);
    }

    @Override
    public int hashCode() {
        return java.util.Objects.hash(merchantName, contactName, contactPhone, shopAddress, businessHours, introduction);
    }
}
