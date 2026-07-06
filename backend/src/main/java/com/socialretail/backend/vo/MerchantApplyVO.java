package com.socialretail.backend.vo;


public class MerchantApplyVO {

    private Long applyId;
    private Integer applyType;
    private String applyTypeText;
    private String companyName;
    private String shopName;
    private String contactName;
    private String contactPhone;
    private String licenseNumber;
    private String licenseImage;
    private String foodPermitNumber;
    private String foodPermitImage;
    private String idCardFront;
    private String idCardBack;
    private String shopAddress;
    private Integer auditStatus;
    private String auditStatusText;
    private String auditRemark;
    private String applyTime;
    private String auditTime;
    private Long merchantId;

    public Long getApplyId() {
        return applyId;
    }

    public void setApplyId(Long applyId) {
        this.applyId = applyId;
    }

    public Integer getApplyType() {
        return applyType;
    }

    public void setApplyType(Integer applyType) {
        this.applyType = applyType;
    }

    public String getApplyTypeText() {
        return applyTypeText;
    }

    public void setApplyTypeText(String applyTypeText) {
        this.applyTypeText = applyTypeText;
    }

    public String getCompanyName() {
        return companyName;
    }

    public void setCompanyName(String companyName) {
        this.companyName = companyName;
    }

    public String getShopName() {
        return shopName;
    }

    public void setShopName(String shopName) {
        this.shopName = shopName;
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

    public String getShopAddress() {
        return shopAddress;
    }

    public void setShopAddress(String shopAddress) {
        this.shopAddress = shopAddress;
    }

    public Integer getAuditStatus() {
        return auditStatus;
    }

    public void setAuditStatus(Integer auditStatus) {
        this.auditStatus = auditStatus;
    }

    public String getAuditStatusText() {
        return auditStatusText;
    }

    public void setAuditStatusText(String auditStatusText) {
        this.auditStatusText = auditStatusText;
    }

    public String getAuditRemark() {
        return auditRemark;
    }

    public void setAuditRemark(String auditRemark) {
        this.auditRemark = auditRemark;
    }

    public String getApplyTime() {
        return applyTime;
    }

    public void setApplyTime(String applyTime) {
        this.applyTime = applyTime;
    }

    public String getAuditTime() {
        return auditTime;
    }

    public void setAuditTime(String auditTime) {
        this.auditTime = auditTime;
    }

    public Long getMerchantId() {
        return merchantId;
    }

    public void setMerchantId(Long merchantId) {
        this.merchantId = merchantId;
    }

    @Override
    public String toString() {
        return "MerchantApplyVO{" +
            ", applyId=" + applyId +
            ", applyType=" + applyType +
            ", applyTypeText=" + applyTypeText +
            ", companyName=" + companyName +
            ", shopName=" + shopName +
            ", contactName=" + contactName +
            ", contactPhone=" + contactPhone +
            ", licenseNumber=" + licenseNumber +
            ", licenseImage=" + licenseImage +
            ", foodPermitNumber=" + foodPermitNumber +
            ", foodPermitImage=" + foodPermitImage +
            ", idCardFront=" + idCardFront +
            ", idCardBack=" + idCardBack +
            ", shopAddress=" + shopAddress +
            ", auditStatus=" + auditStatus +
            ", auditStatusText=" + auditStatusText +
            ", auditRemark=" + auditRemark +
            ", applyTime=" + applyTime +
            ", auditTime=" + auditTime +
            ", merchantId=" + merchantId +
            '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        MerchantApplyVO that = (MerchantApplyVO) o;
        return java.util.Objects.equals(applyId, that.applyId)
                && java.util.Objects.equals(applyType, that.applyType)
                && java.util.Objects.equals(applyTypeText, that.applyTypeText)
                && java.util.Objects.equals(companyName, that.companyName)
                && java.util.Objects.equals(shopName, that.shopName)
                && java.util.Objects.equals(contactName, that.contactName)
                && java.util.Objects.equals(contactPhone, that.contactPhone)
                && java.util.Objects.equals(licenseNumber, that.licenseNumber)
                && java.util.Objects.equals(licenseImage, that.licenseImage)
                && java.util.Objects.equals(foodPermitNumber, that.foodPermitNumber)
                && java.util.Objects.equals(foodPermitImage, that.foodPermitImage)
                && java.util.Objects.equals(idCardFront, that.idCardFront)
                && java.util.Objects.equals(idCardBack, that.idCardBack)
                && java.util.Objects.equals(shopAddress, that.shopAddress)
                && java.util.Objects.equals(auditStatus, that.auditStatus)
                && java.util.Objects.equals(auditStatusText, that.auditStatusText)
                && java.util.Objects.equals(auditRemark, that.auditRemark)
                && java.util.Objects.equals(applyTime, that.applyTime)
                && java.util.Objects.equals(auditTime, that.auditTime)
                && java.util.Objects.equals(merchantId, that.merchantId);
    }

    @Override
    public int hashCode() {
        return java.util.Objects.hash(applyId, applyType, applyTypeText, companyName, shopName, contactName, contactPhone, licenseNumber, licenseImage, foodPermitNumber, foodPermitImage, idCardFront, idCardBack, shopAddress, auditStatus, auditStatusText, auditRemark, applyTime, auditTime, merchantId);
    }
}
