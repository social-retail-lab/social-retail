package com.socialretail.backend.vo;

import lombok.Data;

import java.math.BigDecimal;
import java.util.List;

@Data
public class ProductVO {

    private Long productId;
    private String title;
    private String subTitle;
    private Long brandId;
    private String brandName;
    private List<Long> categoryIds;
    private List<String> categoryNames;
    private String mainImage;
    private List<String> detailImages;
    private String detailDesc;
    private Integer saleType;
    private String saleTypeText;
    private Integer auditStatus;
    private String auditRemark;
    private Integer status;
    private List<SkuVO> skuList;
    private String createTime;
    private String updateTime;
}
