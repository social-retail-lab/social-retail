package com.socialretail.backend.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class BrandProductPageVO {
    private Long brandId;
    private String brandName;
    private List<CatalogProductVO> list;
    private Long total;
    private Integer pages;
    private Integer page;
    private Integer pageSize;
}
