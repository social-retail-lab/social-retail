package com.socialretail.backend.common;

import java.util.List;

public class PageResult<T> {
    private List<T> list;
    private long total;
    private int pageNum;
    private int pageSize;

    public static <T> PageResult<T> of(List<T> list, long total, int pageNum, int pageSize) {
        PageResult<T> r = new PageResult<>();
        r.list = list;
        r.total = total;
        r.pageNum = pageNum;
        r.pageSize = pageSize;
        return r;
    }

    public List<T> getList() {
        return list;
    }

    public void setList(List<T> list) {
        this.list = list;
    }

    public long getTotal() {
        return total;
    }

    public void setTotal(long total) {
        this.total = total;
    }

    public int getPageNum() {
        return pageNum;
    }

    public void setPageNum(int pageNum) {
        this.pageNum = pageNum;
    }

    public int getPageSize() {
        return pageSize;
    }

    public void setPageSize(int pageSize) {
        this.pageSize = pageSize;
    }

    @Override
    public String toString() {
        return "PageResult{" +
            ", list=" + list +
            ", total=" + total +
            ", pageNum=" + pageNum +
            ", pageSize=" + pageSize +
            '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        PageResult that = (PageResult) o;
        return java.util.Objects.equals(list, that.list)
                && java.util.Objects.equals(total, that.total)
                && java.util.Objects.equals(pageNum, that.pageNum)
                && java.util.Objects.equals(pageSize, that.pageSize);
    }

    @Override
    public int hashCode() {
        return java.util.Objects.hash(list, total, pageNum, pageSize);
    }
}
