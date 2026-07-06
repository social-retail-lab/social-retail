package com.socialretail.backend.vo;


import java.util.List;
import java.util.Map;

public class AdminProductDetailVO {
    private Long productId;
    private String title;
    private String subTitle;
    private String mainImage;
    private String detailDesc;
    private Integer saleType;
    private Integer status;
    private String statusText;
    private Integer auditStatus;
    private String auditStatusText;
    private String auditRemark;
    private String auditTime;
    private String createTime;

    // 商家信息
    private Long merchantId;
    private String merchantName;
    private String merchantPhone;

    // SKU列表
    private List<Map<String, Object>> skuList;

    // 分类名称
    private List<String> categoryNames;

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

    public String getStatusText() {
        return statusText;
    }

    public void setStatusText(String statusText) {
        this.statusText = statusText;
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

    public String getAuditTime() {
        return auditTime;
    }

    public void setAuditTime(String auditTime) {
        this.auditTime = auditTime;
    }

    public String getCreateTime() {
        return createTime;
    }

    public void setCreateTime(String createTime) {
        this.createTime = createTime;
    }

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

    public String getMerchantPhone() {
        return merchantPhone;
    }

    public void setMerchantPhone(String merchantPhone) {
        this.merchantPhone = merchantPhone;
    }

    public List<String> getCategoryNames() {
        return categoryNames;
    }

    public void setCategoryNames(List<String> categoryNames) {
        this.categoryNames = categoryNames;
    }

    public List<Map<String, Object>> getSkuList() {
        return skuList;
    }

    public void setSkuList(List<Map<String, Object>> skuList) {
        this.skuList = skuList;
    }

    @Override
    public String toString() {
        return "AdminProductDetailVO{" +
            ", productId=" + productId +
            ", title=" + title +
            ", subTitle=" + subTitle +
            ", mainImage=" + mainImage +
            ", detailDesc=" + detailDesc +
            ", saleType=" + saleType +
            ", status=" + status +
            ", statusText=" + statusText +
            ", auditStatus=" + auditStatus +
            ", auditStatusText=" + auditStatusText +
            ", auditRemark=" + auditRemark +
            ", auditTime=" + auditTime +
            ", createTime=" + createTime +
            ", merchantId=" + merchantId +
            ", merchantName=" + merchantName +
            ", merchantPhone=" + merchantPhone +
            ", categoryNames=" + categoryNames +
            '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        AdminProductDetailVO that = (AdminProductDetailVO) o;
        return java.util.Objects.equals(productId, that.productId)
                && java.util.Objects.equals(title, that.title)
                && java.util.Objects.equals(subTitle, that.subTitle)
                && java.util.Objects.equals(mainImage, that.mainImage)
                && java.util.Objects.equals(detailDesc, that.detailDesc)
                && java.util.Objects.equals(saleType, that.saleType)
                && java.util.Objects.equals(status, that.status)
                && java.util.Objects.equals(statusText, that.statusText)
                && java.util.Objects.equals(auditStatus, that.auditStatus)
                && java.util.Objects.equals(auditStatusText, that.auditStatusText)
                && java.util.Objects.equals(auditRemark, that.auditRemark)
                && java.util.Objects.equals(auditTime, that.auditTime)
                && java.util.Objects.equals(createTime, that.createTime)
                && java.util.Objects.equals(merchantId, that.merchantId)
                && java.util.Objects.equals(merchantName, that.merchantName)
                && java.util.Objects.equals(merchantPhone, that.merchantPhone)
                && java.util.Objects.equals(categoryNames, that.categoryNames);
    }

    @Override
    public int hashCode() {
        return java.util.Objects.hash(productId, title, subTitle, mainImage, detailDesc, saleType, status, statusText, auditStatus, auditStatusText, auditRemark, auditTime, createTime, merchantId, merchantName, merchantPhone, categoryNames);
    }
}
