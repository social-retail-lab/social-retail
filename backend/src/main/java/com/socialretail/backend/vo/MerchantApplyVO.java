package com.socialretail.backend.vo;

import lombok.Data;

@Data
public class MerchantApplyVO {

    private Long applyId;
    private Integer applyType;
    private String applyTypeText;
    private String companyName;
    private String shopName;
    private String contactName;
    private String contactPhone;
    private String licenseNumber;
    private String licenseImage;
    private String foodPermitNumber;
    private String foodPermitImage;
    private String idCardFront;
    private String idCardBack;
    private String shopAddress;
    private Integer auditStatus;
    private String auditStatusText;
    private String auditRemark;
    private String applyTime;
    private String auditTime;
    private Long merchantId;
}
