package com.socialretail.backend.vo;

public class UserInfoVO {

    private Long userId;
    private String nickName;
    private String phone;
    private String memberLevel;

    public UserInfoVO() {
    }

    public UserInfoVO(Long userId, String nickName, String phone, String memberLevel) {
        this.userId = userId;
        this.nickName = nickName;
        this.phone = phone;
        this.memberLevel = memberLevel;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public String getNickName() {
        return nickName;
    }

    public void setNickName(String nickName) {
        this.nickName = nickName;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getMemberLevel() {
        return memberLevel;
    }

    public void setMemberLevel(String memberLevel) {
        this.memberLevel = memberLevel;
    }
}
