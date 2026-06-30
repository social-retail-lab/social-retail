package com.socialretail.backend.vo;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class UserInfoVO {

    private Long userId;
    private String phone;
    private String nickname;
    private String avatar;
    private String status;
    private Object memberInfo;
    private Object distributorInfo;

    public UserInfoVO(Long userId,
                      String phone,
                      String nickname,
                      String avatar,
                      String status,
                      Object memberInfo,
                      Object distributorInfo) {
        this.userId = userId;
        this.phone = phone;
        this.nickname = nickname;
        this.avatar = avatar;
        this.status = status;
        this.memberInfo = memberInfo;
        this.distributorInfo = distributorInfo;
    }

    /**
     * 保留测试控制器的旧构造方式。
     */
    public UserInfoVO(Long userId, String nickname, String phone, String ignoredMemberLevel) {
        this(userId, phone, nickname, null, "NORMAL", null, null);
    }
}
