package com.socialretail.backend.vo;


public class ProductQueryRequest {

    private String keyword;
    private Long categoryId;
    private Integer status;
    private Integer auditStatus;

    public String getKeyword() {
        return keyword;
    }

    public void setKeyword(String keyword) {
        this.keyword = keyword;
    }

    public Long getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(Long categoryId) {
        this.categoryId = categoryId;
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

    @Override
    public String toString() {
        return "ProductQueryRequest{" +
            ", keyword=" + keyword +
            ", categoryId=" + categoryId +
            ", status=" + status +
            ", auditStatus=" + auditStatus +
            '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        ProductQueryRequest that = (ProductQueryRequest) o;
        return java.util.Objects.equals(keyword, that.keyword)
                && java.util.Objects.equals(categoryId, that.categoryId)
                && java.util.Objects.equals(status, that.status)
                && java.util.Objects.equals(auditStatus, that.auditStatus);
    }

    @Override
    public int hashCode() {
        return java.util.Objects.hash(keyword, categoryId, status, auditStatus);
    }
}
