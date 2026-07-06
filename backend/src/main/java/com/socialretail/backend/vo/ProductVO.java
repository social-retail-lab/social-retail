package com.socialretail.backend.vo;


import java.math.BigDecimal;
import java.util.List;

public class ProductVO {

    private Long productId;
    private String title;
    private String subTitle;
    private Long brandId;
    private String brandName;
    private List<Long> categoryIds;
    private List<String> categoryNames;
    private String mainImage;
    private List<String> detailImages;
    private String detailDesc;
    private Integer saleType;
    private String saleTypeText;
    private Integer auditStatus;
    private String auditRemark;
    private Integer status;
    private List<SkuVO> skuList;
    private String createTime;
    private String updateTime;

    public Long getProductId() {
        return productId;
    }

    public void setProductId(Long productId) {
        this.productId = productId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getSubTitle() {
        return subTitle;
    }

    public void setSubTitle(String subTitle) {
        this.subTitle = subTitle;
    }

    public Long getBrandId() {
        return brandId;
    }

    public void setBrandId(Long brandId) {
        this.brandId = brandId;
    }

    public String getBrandName() {
        return brandName;
    }

    public void setBrandName(String brandName) {
        this.brandName = brandName;
    }

    public List<Long> getCategoryIds() {
        return categoryIds;
    }

    public void setCategoryIds(List<Long> categoryIds) {
        this.categoryIds = categoryIds;
    }

    public List<String> getCategoryNames() {
        return categoryNames;
    }

    public void setCategoryNames(List<String> categoryNames) {
        this.categoryNames = categoryNames;
    }

    public String getMainImage() {
        return mainImage;
    }

    public void setMainImage(String mainImage) {
        this.mainImage = mainImage;
    }

    public List<String> getDetailImages() {
        return detailImages;
    }

    public void setDetailImages(List<String> detailImages) {
        this.detailImages = detailImages;
    }

    public String getDetailDesc() {
        return detailDesc;
    }

    public void setDetailDesc(String detailDesc) {
        this.detailDesc = detailDesc;
    }

    public Integer getSaleType() {
        return saleType;
    }

    public void setSaleType(Integer saleType) {
        this.saleType = saleType;
    }

    public String getSaleTypeText() {
        return saleTypeText;
    }

    public void setSaleTypeText(String saleTypeText) {
        this.saleTypeText = saleTypeText;
    }

    public Integer getAuditStatus() {
        return auditStatus;
    }

    public void setAuditStatus(Integer auditStatus) {
        this.auditStatus = auditStatus;
    }

    public String getAuditRemark() {
        return auditRemark;
    }

    public void setAuditRemark(String auditRemark) {
        this.auditRemark = auditRemark;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    public List<SkuVO> getSkuList() {
        return skuList;
    }

    public void setSkuList(List<SkuVO> skuList) {
        this.skuList = skuList;
    }

    public String getCreateTime() {
        return createTime;
    }

    public void setCreateTime(String createTime) {
        this.createTime = createTime;
    }

    public String getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(String updateTime) {
        this.updateTime = updateTime;
    }

    @Override
    public String toString() {
        return "ProductVO{" +
            ", productId=" + productId +
            ", title=" + title +
            ", subTitle=" + subTitle +
            ", brandId=" + brandId +
            ", brandName=" + brandName +
            ", categoryIds=" + categoryIds +
            ", categoryNames=" + categoryNames +
            ", mainImage=" + mainImage +
            ", detailImages=" + detailImages +
            ", detailDesc=" + detailDesc +
            ", saleType=" + saleType +
            ", saleTypeText=" + saleTypeText +
            ", auditStatus=" + auditStatus +
            ", auditRemark=" + auditRemark +
            ", status=" + status +
            ", skuList=" + skuList +
            ", createTime=" + createTime +
            ", updateTime=" + updateTime +
            '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        ProductVO that = (ProductVO) o;
        return java.util.Objects.equals(productId, that.productId)
                && java.util.Objects.equals(title, that.title)
                && java.util.Objects.equals(subTitle, that.subTitle)
                && java.util.Objects.equals(brandId, that.brandId)
                && java.util.Objects.equals(brandName, that.brandName)
                && java.util.Objects.equals(categoryIds, that.categoryIds)
                && java.util.Objects.equals(categoryNames, that.categoryNames)
                && java.util.Objects.equals(mainImage, that.mainImage)
                && java.util.Objects.equals(detailImages, that.detailImages)
                && java.util.Objects.equals(detailDesc, that.detailDesc)
                && java.util.Objects.equals(saleType, that.saleType)
                && java.util.Objects.equals(saleTypeText, that.saleTypeText)
                && java.util.Objects.equals(auditStatus, that.auditStatus)
                && java.util.Objects.equals(auditRemark, that.auditRemark)
                && java.util.Objects.equals(status, that.status)
                && java.util.Objects.equals(skuList, that.skuList)
                && java.util.Objects.equals(createTime, that.createTime)
                && java.util.Objects.equals(updateTime, that.updateTime);
    }

    @Override
    public int hashCode() {
        return java.util.Objects.hash(productId, title, subTitle, brandId, brandName, categoryIds, categoryNames, mainImage, detailImages, detailDesc, saleType, saleTypeText, auditStatus, auditRemark, status, skuList, createTime, updateTime);
    }
}
