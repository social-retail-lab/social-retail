package com.socialretail.backend.vo;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class UserUpdateVO {

    private Long userId;
    private String nickname;
    private String avatar;
}
