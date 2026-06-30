package com.socialretail.backend.vo;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class AddressDefaultVO {

    private Long addressId;
    private Boolean isDefault;
}
