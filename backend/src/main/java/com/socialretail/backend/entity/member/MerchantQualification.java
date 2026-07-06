package com.socialretail.backend.entity.member;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

@TableName("merchant_qualification")
public class MerchantQualification {

    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    private Long merchantId;

    private String licenseNumber;

    private String licenseImage;

    private String foodPermitNumber;

    private String foodPermitImage;

    private String businessCategory;

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

    public String getBusinessCategory() {
        return businessCategory;
    }

    public void setBusinessCategory(String businessCategory) {
        this.businessCategory = businessCategory;
    }

    @Override
    public String toString() {
        return "MerchantQualification{" +
            ", id=" + id +
            ", merchantId=" + merchantId +
            ", licenseNumber=" + licenseNumber +
            ", licenseImage=" + licenseImage +
            ", foodPermitNumber=" + foodPermitNumber +
            ", foodPermitImage=" + foodPermitImage +
            ", businessCategory=" + businessCategory +
            '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        MerchantQualification that = (MerchantQualification) o;
        return java.util.Objects.equals(id, that.id)
                && java.util.Objects.equals(merchantId, that.merchantId)
                && java.util.Objects.equals(licenseNumber, that.licenseNumber)
                && java.util.Objects.equals(licenseImage, that.licenseImage)
                && java.util.Objects.equals(foodPermitNumber, that.foodPermitNumber)
                && java.util.Objects.equals(foodPermitImage, that.foodPermitImage)
                && java.util.Objects.equals(businessCategory, that.businessCategory);
    }

    @Override
    public int hashCode() {
        return java.util.Objects.hash(id, merchantId, licenseNumber, licenseImage, foodPermitNumber, foodPermitImage, businessCategory);
    }
}
