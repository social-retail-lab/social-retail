package com.socialretail.backend.vo;

import lombok.Data;

import java.util.List;
import java.util.Map;

@Data
public class AdminProductDetailVO {
    private Long productId;
    private String title;
    private String subTitle;
    private String mainImage;
    private String detailDesc;
    private Integer saleType;
    private Integer status;
    private String statusText;
    private Integer auditStatus;
    private String auditStatusText;
    private String auditRemark;
    private String auditTime;
    private String createTime;

    // 商家信息
    private Long merchantId;
    private String merchantName;
    private String merchantPhone;

    // SKU列表
    private List<Map<String, Object>> skuList;

    // 分类名称
    private List<String> categoryNames;
}
