package com.socialretail.backend.entity.member;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

@TableName("user")
public class User {

    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    private String phone;

    private String nickname;

    private String password;

    private String avatar;

    private Integer sex;

    private Integer status;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getNickname() {
        return nickname;
    }

    public void setNickname(String nickname) {
        this.nickname = nickname;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    public Integer getSex() {
        return sex;
    }

    public void setSex(Integer sex) {
        this.sex = sex;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "User{" +
            ", id=" + id +
            ", phone=" + phone +
            ", nickname=" + nickname +
            ", password=" + password +
            ", avatar=" + avatar +
            ", sex=" + sex +
            ", status=" + status +
            '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        User that = (User) o;
        return java.util.Objects.equals(id, that.id)
                && java.util.Objects.equals(phone, that.phone)
                && java.util.Objects.equals(nickname, that.nickname)
                && java.util.Objects.equals(password, that.password)
                && java.util.Objects.equals(avatar, that.avatar)
                && java.util.Objects.equals(sex, that.sex)
                && java.util.Objects.equals(status, that.status);
    }

    @Override
    public int hashCode() {
        return java.util.Objects.hash(id, phone, nickname, password, avatar, sex, status);
    }
}
