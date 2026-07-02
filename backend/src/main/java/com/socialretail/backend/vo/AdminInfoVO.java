package com.socialretail.backend.vo;

import lombok.Data;

@Data
public class AdminInfoVO {

    private Long adminId;
    private String username;
    private String realName;
    private String phone;
    private String email;
    private String role;
    private Integer status;
    private String lastLoginTime;
    private String adminType;
}
