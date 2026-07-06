package com.socialretail.backend.entity.product;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

@TableName("product_category_relation")
public class ProductCategoryRelation {

    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    private Long productId;

    private Long categoryId;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getProductId() {
        return productId;
    }

    public void setProductId(Long productId) {
        this.productId = productId;
    }

    public Long getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(Long categoryId) {
        this.categoryId = categoryId;
    }

    @Override
    public String toString() {
        return "ProductCategoryRelation{" +
            ", id=" + id +
            ", productId=" + productId +
            ", categoryId=" + categoryId +
            '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        ProductCategoryRelation that = (ProductCategoryRelation) o;
        return java.util.Objects.equals(id, that.id)
                && java.util.Objects.equals(productId, that.productId)
                && java.util.Objects.equals(categoryId, that.categoryId);
    }

    @Override
    public int hashCode() {
        return java.util.Objects.hash(id, productId, categoryId);
    }
}
