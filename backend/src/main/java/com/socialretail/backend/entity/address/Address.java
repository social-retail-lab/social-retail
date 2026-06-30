package com.socialretail.backend.entity.address;

import lombok.Data;

@Data
public class Address {

    private Long id;
    private Long userId;
    private String consignee;
    private String phone;
    private String province;
    private String city;
    private String district;
    private String detailedAddress;
    private Integer isDefault;
}
