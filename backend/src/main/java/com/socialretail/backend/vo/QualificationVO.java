package com.socialretail.backend.vo;


public class QualificationVO {

    private Long qualificationId;
    private String businessCategory;
    private String licenseNumber;
    private String licenseImage;
    private String foodPermitNumber;
    private String foodPermitImage;

    public Long getQualificationId() {
        return qualificationId;
    }

    public void setQualificationId(Long qualificationId) {
        this.qualificationId = qualificationId;
    }

    public String getBusinessCategory() {
        return businessCategory;
    }

    public void setBusinessCategory(String businessCategory) {
        this.businessCategory = businessCategory;
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

    @Override
    public String toString() {
        return "QualificationVO{" +
            ", qualificationId=" + qualificationId +
            ", businessCategory=" + businessCategory +
            ", licenseNumber=" + licenseNumber +
            ", licenseImage=" + licenseImage +
            ", foodPermitNumber=" + foodPermitNumber +
            ", foodPermitImage=" + foodPermitImage +
            '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        QualificationVO that = (QualificationVO) o;
        return java.util.Objects.equals(qualificationId, that.qualificationId)
                && java.util.Objects.equals(businessCategory, that.businessCategory)
                && java.util.Objects.equals(licenseNumber, that.licenseNumber)
                && java.util.Objects.equals(licenseImage, that.licenseImage)
                && java.util.Objects.equals(foodPermitNumber, that.foodPermitNumber)
                && java.util.Objects.equals(foodPermitImage, that.foodPermitImage);
    }

    @Override
    public int hashCode() {
        return java.util.Objects.hash(qualificationId, businessCategory, licenseNumber, licenseImage, foodPermitNumber, foodPermitImage);
    }
}
