package com.socialretail.backend.vo;


import java.math.BigDecimal;
import java.util.List;

public class ProductCreateRequest {

    private Long brandId;
    private List<Long> categoryIds;
    private String title;
    private String subTitle;
    private String mainImage;
    private List<String> detailImages;
    private String detailDesc;
    private Integer saleType;
    private List<SkuRequest> skuList;

    public Long getBrandId() {
        return brandId;
    }

    public void setBrandId(Long brandId) {
        this.brandId = brandId;
    }

    public List<Long> getCategoryIds() {
        return categoryIds;
    }

    public void setCategoryIds(List<Long> categoryIds) {
        this.categoryIds = categoryIds;
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

    public List<SkuRequest> getSkuList() {
        return skuList;
    }

    public void setSkuList(List<SkuRequest> skuList) {
        this.skuList = skuList;
    }

    @Override
    public String toString() {
        return "ProductCreateRequest{" +
            ", brandId=" + brandId +
            ", categoryIds=" + categoryIds +
            ", title=" + title +
            ", subTitle=" + subTitle +
            ", mainImage=" + mainImage +
            ", detailImages=" + detailImages +
            ", detailDesc=" + detailDesc +
            ", saleType=" + saleType +
            ", skuList=" + skuList +
            '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        ProductCreateRequest that = (ProductCreateRequest) o;
        return java.util.Objects.equals(brandId, that.brandId)
                && java.util.Objects.equals(categoryIds, that.categoryIds)
                && java.util.Objects.equals(title, that.title)
                && java.util.Objects.equals(subTitle, that.subTitle)
                && java.util.Objects.equals(mainImage, that.mainImage)
                && java.util.Objects.equals(detailImages, that.detailImages)
                && java.util.Objects.equals(detailDesc, that.detailDesc)
                && java.util.Objects.equals(saleType, that.saleType)
                && java.util.Objects.equals(skuList, that.skuList);
    }

    @Override
    public int hashCode() {
        return java.util.Objects.hash(brandId, categoryIds, title, subTitle, mainImage, detailImages, detailDesc, saleType, skuList);
    }
}
