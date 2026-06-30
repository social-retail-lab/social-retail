package com.socialretail.backend.vo;

import lombok.Data;

@Data
public class MerchantLoginRequest {

    private String phone;
    private String password;
    private String smsCode;
}
