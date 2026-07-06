package com.socialretail.backend.vo;


public class ShelfStatusRequest {

    private Integer status;

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "ShelfStatusRequest{" +
            ", status=" + status +
            '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        ShelfStatusRequest that = (ShelfStatusRequest) o;
        return java.util.Objects.equals(status, that.status);
    }

    @Override
    public int hashCode() {
        return java.util.Objects.hash(status);
    }
}
