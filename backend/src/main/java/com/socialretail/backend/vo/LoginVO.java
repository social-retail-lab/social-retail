package com.socialretail.backend.vo;

import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.Data;

@Data
@JsonInclude(JsonInclude.Include.NON_NULL)
public class LoginVO {

    private String token;
    private Long expireTime;
    private Integer merchantStatus;
    private MerchantInfoVO merchantInfo;
    private AdminInfoVO adminInfo;
}
