package com.socialretail.backend.vo;

import lombok.Data;

import java.math.BigDecimal;

@Data
public class MerchantListVO {

    private Long merchantId;
    private String merchantName;
    private String logo;
    private String contactName;
    private String contactPhone;
    private String shopAddress;
    private Integer status;
    private String statusText;
    private Integer productCount;
    private Integer totalOrders;
    private BigDecimal totalAmount;
    private String createTime;
}
