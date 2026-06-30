package com.socialretail.backend.dto.request.user;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class UserLoginRequest {

    @NotBlank(message = "手机号不能为空")
    @Pattern(regexp = "^1\\d{10}$", message = "手机号格式错误")
    private String phone;

    @Pattern(regexp = "^\\d{6}$", message = "验证码必须为6位数字")
    private String code;

    @Size(min = 6, max = 72, message = "密码长度必须为6到72位")
    private String password;

    @NotBlank(message = "登录类型不能为空")
    private String loginType;
}
