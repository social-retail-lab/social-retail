package com.socialretail.backend.vo;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class UserRegisterVO {

    private Long userId;
    private String phone;
    private String nickname;
    private String status;
}
