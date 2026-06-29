package com.socialretail.backend.vo;

import lombok.Data;

@Data
public class MerchantInfoVO {

    private Long merchantId;
    private String merchantName;
    private String logo;
    private String contactName;
    private String contactPhone;
    private String shopAddress;
    private String businessHours;
    private String introduction;
    private Integer status;
    private String statusText;
    private String createTime;
}
