package com.socialretail.backend.vo;

import lombok.Data;

@Data
public class QualificationVO {

    private Long qualificationId;
    private String businessCategory;
    private String licenseNumber;
    private String licenseImage;
    private String foodPermitNumber;
    private String foodPermitImage;
}
