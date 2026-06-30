package com.socialretail.backend.common;

import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class PageResult<T> {

    private List<T> list;
    private Long total;
    private Integer pages;
    private Integer page;
    private Integer pageSize;

    public static <T> PageResult<T> of(List<T> list, long total, int pageNum, int pageSize) {
        int pages = pageSize <= 0 ? 0 : (int) ((total + pageSize - 1) / pageSize);
        return new PageResult<>(list, total, pages, pageNum, pageSize);
    }

    public static <T> PageResult<T> empty(Integer page, Integer pageSize) {
        return new PageResult<>(List.of(), 0L, 0, page, pageSize);
    }

    /**
     * 兼容已有商家端代码中的 pageNum 命名，JSON 统一输出 page。
     */
    @JsonIgnore
    public Integer getPageNum() {
        return page;
    }

    @JsonIgnore
    public void setPageNum(Integer pageNum) {
        this.page = pageNum;
    }
}
