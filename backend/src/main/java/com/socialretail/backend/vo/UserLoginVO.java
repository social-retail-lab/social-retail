package com.socialretail.backend.vo;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class UserLoginVO {

    private String token;
    private Long expireSeconds;
    private UserInfoVO userInfo;
}
