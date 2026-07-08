package com.socialretail.backend.entity.product;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

import java.time.LocalDateTime;

@TableName("product")
public class Product {

    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    private Long brandId;

    private Long merchantId;

    private String title;

    private String subTitle;

    private String mainImage;

    private String detailDesc;

    private String detailImages;

    private Integer saleType;

    private Integer status;

    private Integer auditStatus;

    private String auditRemark;

    private LocalDateTime auditTime;

    private LocalDateTime createTime;

    private LocalDateTime updateTime;

    private Long soldCount;

    private Integer forceOffShelf;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getBrandId() {
        return brandId;
    }

    public void setBrandId(Long brandId) {
        this.brandId = brandId;
    }

    public Long getMerchantId() {
        return merchantId;
    }

    public void setMerchantId(Long merchantId) {
        this.merchantId = merchantId;
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

    public String getMainImage() {
        return mainImage;
    }

    public void setMainImage(String mainImage) {
        this.mainImage = mainImage;
    }

    public String getDetailDesc() {
        return detailDesc;
    }

    public void setDetailDesc(String detailDesc) {
        this.detailDesc = detailDesc;
    }

    public String getDetailImages() {
        return detailImages;
    }

    public void setDetailImages(String detailImages) {
        this.detailImages = detailImages;
    }

    public Integer getSaleType() {
        return saleType;
    }

    public void setSaleType(Integer saleType) {
        this.saleType = saleType;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
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

    public LocalDateTime getAuditTime() {
        return auditTime;
    }

    public void setAuditTime(LocalDateTime auditTime) {
        this.auditTime = auditTime;
    }

    public LocalDateTime getCreateTime() {
        return createTime;
    }

    public void setCreateTime(LocalDateTime createTime) {
        this.createTime = createTime;
    }

    public LocalDateTime getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(LocalDateTime updateTime) {
        this.updateTime = updateTime;
    }

    public Long getSoldCount() {
        return soldCount;
    }

    public void setSoldCount(Long soldCount) {
        this.soldCount = soldCount;
    }

    public Integer getForceOffShelf() {
        return forceOffShelf;
    }

    public void setForceOffShelf(Integer forceOffShelf) {
        this.forceOffShelf = forceOffShelf;
    }

    @Override
    public String toString() {
        return "Product{" +
            "id=" + id +
            ", brandId=" + brandId +
            ", merchantId=" + merchantId +
            ", title=" + title +
            ", subTitle=" + subTitle +
            ", mainImage=" + mainImage +
            ", detailDesc=" + detailDesc +
            ", detailImages=" + detailImages +
            ", saleType=" + saleType +
            ", status=" + status +
            ", auditStatus=" + auditStatus +
            ", auditRemark=" + auditRemark +
            ", auditTime=" + auditTime +
            ", createTime=" + createTime +
            ", updateTime=" + updateTime +
            ", soldCount=" + soldCount +
            ", forceOffShelf=" + forceOffShelf +
            '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Product that = (Product) o;
        return java.util.Objects.equals(id, that.id)
                && java.util.Objects.equals(brandId, that.brandId)
                && java.util.Objects.equals(merchantId, that.merchantId)
                && java.util.Objects.equals(title, that.title)
                && java.util.Objects.equals(subTitle, that.subTitle)
                && java.util.Objects.equals(mainImage, that.mainImage)
                && java.util.Objects.equals(detailDesc, that.detailDesc)
                && java.util.Objects.equals(detailImages, that.detailImages)
                && java.util.Objects.equals(saleType, that.saleType)
                && java.util.Objects.equals(status, that.status)
                && java.util.Objects.equals(auditStatus, that.auditStatus)
                && java.util.Objects.equals(auditRemark, that.auditRemark)
                && java.util.Objects.equals(auditTime, that.auditTime)
                && java.util.Objects.equals(createTime, that.createTime)
                && java.util.Objects.equals(updateTime, that.updateTime)
                && java.util.Objects.equals(soldCount, that.soldCount)
                && java.util.Objects.equals(forceOffShelf, that.forceOffShelf);
    }

    @Override
    public int hashCode() {
        return java.util.Objects.hash(id, brandId, merchantId, title, subTitle, mainImage, detailDesc, detailImages, saleType, status, auditStatus, auditRemark, auditTime, createTime, updateTime, soldCount, forceOffShelf);
    }
}
