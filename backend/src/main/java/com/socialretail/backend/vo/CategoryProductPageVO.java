package com.socialretail.backend.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CategoryProductPageVO {
    private Long categoryId;
    private String categoryName;
    private List<CatalogProductVO> list;
    private Long total;
    private Integer pages;
    private Integer page;
    private Integer pageSize;
}
