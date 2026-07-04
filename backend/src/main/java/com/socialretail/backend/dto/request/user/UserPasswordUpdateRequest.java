package com.socialretail.backend.dto.request.user;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class UserPasswordUpdateRequest {

    @NotBlank(message = "原密码不能为空")
    @Size(min = 6, max = 72, message = "原密码长度必须为6到72位")
    private String oldPassword;

    @NotBlank(message = "新密码不能为空")
    @Size(min = 6, max = 72, message = "新密码长度必须为6到72位")
    private String newPassword;
}
