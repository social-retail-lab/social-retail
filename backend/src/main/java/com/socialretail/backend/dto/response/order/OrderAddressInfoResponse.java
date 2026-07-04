package com.socialretail.backend.dto.response.order;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class OrderAddressInfoResponse {
    private Long addressId;
    private String consignee;
    private String phone;
    private String province;
    private String city;
    private String district;
    private String detailedAddress;
}
