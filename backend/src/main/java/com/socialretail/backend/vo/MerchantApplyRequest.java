package com.socialretail.backend.vo;


public class MerchantApplyRequest {

    private Integer applyType;
    private String companyName;
    private String idCardFront;
    private String idCardBack;
    private String licenseNumber;
    private String licenseImage;
    private String foodPermitNumber;
    private String foodPermitImage;
    private String contactName;
    private String contactPhone;
    private String shopAddress;
    private String shopName;

    public Integer getApplyType() {
        return applyType;
    }

    public void setApplyType(Integer applyType) {
        this.applyType = applyType;
    }

    public String getCompanyName() {
        return companyName;
    }

    public void setCompanyName(String companyName) {
        this.companyName = companyName;
    }

    public String getIdCardFront() {
        return idCardFront;
    }

    public void setIdCardFront(String idCardFront) {
        this.idCardFront = idCardFront;
    }

    public String getIdCardBack() {
        return idCardBack;
    }

    public void setIdCardBack(String idCardBack) {
        this.idCardBack = idCardBack;
    }

    public String getLicenseNumber() {
        return licenseNumber;
    }

    public void setLicenseNumber(String licenseNumber) {
        this.licenseNumber = licenseNumber;
    }

    public String getLicenseImage() {
        return licenseImage;
    }

    public void setLicenseImage(String licenseImage) {
        this.licenseImage = licenseImage;
    }

    public String getFoodPermitNumber() {
        return foodPermitNumber;
    }

    public void setFoodPermitNumber(String foodPermitNumber) {
        this.foodPermitNumber = foodPermitNumber;
    }

    public String getFoodPermitImage() {
        return foodPermitImage;
    }

    public void setFoodPermitImage(String foodPermitImage) {
        this.foodPermitImage = foodPermitImage;
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

    public String getShopName() {
        return shopName;
    }

    public void setShopName(String shopName) {
        this.shopName = shopName;
    }

    @Override
    public String toString() {
        return "MerchantApplyRequest{" +
            ", applyType=" + applyType +
            ", companyName=" + companyName +
            ", idCardFront=" + idCardFront +
            ", idCardBack=" + idCardBack +
            ", licenseNumber=" + licenseNumber +
            ", licenseImage=" + licenseImage +
            ", foodPermitNumber=" + foodPermitNumber +
            ", foodPermitImage=" + foodPermitImage +
            ", contactName=" + contactName +
            ", contactPhone=" + contactPhone +
            ", shopAddress=" + shopAddress +
            ", shopName=" + shopName +
            '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        MerchantApplyRequest that = (MerchantApplyRequest) o;
        return java.util.Objects.equals(applyType, that.applyType)
                && java.util.Objects.equals(companyName, that.companyName)
                && java.util.Objects.equals(idCardFront, that.idCardFront)
                && java.util.Objects.equals(idCardBack, that.idCardBack)
                && java.util.Objects.equals(licenseNumber, that.licenseNumber)
                && java.util.Objects.equals(licenseImage, that.licenseImage)
                && java.util.Objects.equals(foodPermitNumber, that.foodPermitNumber)
                && java.util.Objects.equals(foodPermitImage, that.foodPermitImage)
                && java.util.Objects.equals(contactName, that.contactName)
                && java.util.Objects.equals(contactPhone, that.contactPhone)
                && java.util.Objects.equals(shopAddress, that.shopAddress)
                && java.util.Objects.equals(shopName, that.shopName);
    }

    @Override
    public int hashCode() {
        return java.util.Objects.hash(applyType, companyName, idCardFront, idCardBack, licenseNumber, licenseImage, foodPermitNumber, foodPermitImage, contactName, contactPhone, shopAddress, shopName);
    }
}
