package com.socialretail.backend.vo;

import lombok.Data;

@Data
public class InfoChangeRequest {

    private String merchantName;

    private String contactName;

    private String contactPhone;

    private String shopAddress;

    private String businessHours;

    private String introduction;
}
