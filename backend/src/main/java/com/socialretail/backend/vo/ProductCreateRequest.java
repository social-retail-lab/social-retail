package com.socialretail.backend.vo;

import lombok.Data;

import java.math.BigDecimal;
import java.util.List;

@Data
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
}
