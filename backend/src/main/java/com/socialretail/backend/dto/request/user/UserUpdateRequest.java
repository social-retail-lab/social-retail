package com.socialretail.backend.dto.request.user;

import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class UserUpdateRequest {

    @Size(max = 50, message = "昵称长度不能超过50位")
    private String nickname;

    @Size(max = 200, message = "头像地址长度不能超过200位")
    private String avatar;
}
