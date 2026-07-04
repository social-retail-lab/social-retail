package com.socialretail.backend.common;

import com.fasterxml.jackson.annotation.JsonIgnore;

import java.util.List;

public class PageResult<T> {

    private List<T> list;
    private Long total;
    private Integer pages;
    private Integer page;
    private Integer pageSize;

    public PageResult() {
    }

    public PageResult(List<T> list, Long total, Integer pages, Integer page, Integer pageSize) {
        this.list = list;
        this.total = total;
        this.pages = pages;
        this.page = page;
        this.pageSize = pageSize;
    }

    public List<T> getList() {
        return list;
    }

    public void setList(List<T> list) {
        this.list = list;
    }

    public Long getTotal() {
        return total;
    }

    public void setTotal(Long total) {
        this.total = total;
    }

    public Integer getPages() {
        return pages;
    }

    public void setPages(Integer pages) {
        this.pages = pages;
    }

    public Integer getPage() {
        return page;
    }

    public void setPage(Integer page) {
        this.page = page;
    }

    public Integer getPageSize() {
        return pageSize;
    }

    public void setPageSize(Integer pageSize) {
        this.pageSize = pageSize;
    }

    public static <T> PageResult<T> of(List<T> list, long total, int pageNum, int pageSize) {
        int pages = pageSize <= 0 ? 0 : (int) ((total + pageSize - 1) / pageSize);
        return new PageResult<>(list, total, pages, pageNum, pageSize);
    }

    public static <T> PageResult<T> empty(Integer page, Integer pageSize) {
        return new PageResult<>(List.of(), 0L, 0, page, pageSize);
    }

    @JsonIgnore
    public Integer getPageNum() {
        return page;
    }

    @JsonIgnore
    public void setPageNum(Integer pageNum) {
        this.page = pageNum;
    }
}
