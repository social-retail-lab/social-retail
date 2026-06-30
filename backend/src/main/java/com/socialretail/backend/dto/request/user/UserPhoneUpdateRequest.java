package com.socialretail.backend.dto.request.user;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import lombok.Data;

@Data
public class UserPhoneUpdateRequest {

    @NotBlank(message = "新手机号不能为空")
    @Pattern(regexp = "^1\\d{10}$", message = "新手机号格式错误")
    private String newPhone;

    @NotBlank(message = "验证码不能为空")
    @Pattern(regexp = "^\\d{6}$", message = "验证码必须为6位数字")
    private String code;
}
