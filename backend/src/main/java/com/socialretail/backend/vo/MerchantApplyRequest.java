package com.socialretail.backend.vo;

import lombok.Data;

@Data
public class MerchantApplyRequest {

    private Integer applyType;
    private String companyName;
    private String idCardFront;
    private String idCardBack;
    private String licenseNumber;
    private String licenseImage;
    private String foodPermitNumber;
    private String foodPermitImage;
    private String contactName;
    private String contactPhone;
    private String shopAddress;
    private String shopName;
}
