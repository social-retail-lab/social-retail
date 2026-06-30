package com.socialretail.backend.vo;

import lombok.Data;

@Data
public class AdminProductListVO {
    private Long productId;
    private String title;
    private String mainImage;
    private Integer status;
    private String statusText;
    private Integer auditStatus;
    private String auditStatusText;
    private Boolean groupPurchase;  // 是否可拼团（预留）
    private String merchantName;
}
