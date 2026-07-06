package com.socialretail.backend.entity.member;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

import java.time.LocalDateTime;

@TableName("system_admin")
public class SystemAdmin {

    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    private String username;

    private String password;

    private String realName;

    private String phone;

    private String email;

    private String role;

    private Integer status;

    private LocalDateTime lastLoginTime;

    private LocalDateTime createTime;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getRealName() {
        return realName;
    }

    public void setRealName(String realName) {
        this.realName = realName;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    public LocalDateTime getLastLoginTime() {
        return lastLoginTime;
    }

    public void setLastLoginTime(LocalDateTime lastLoginTime) {
        this.lastLoginTime = lastLoginTime;
    }

    public LocalDateTime getCreateTime() {
        return createTime;
    }

    public void setCreateTime(LocalDateTime createTime) {
        this.createTime = createTime;
    }

    @Override
    public String toString() {
        return "SystemAdmin{" +
            ", id=" + id +
            ", username=" + username +
            ", password=" + password +
            ", realName=" + realName +
            ", phone=" + phone +
            ", email=" + email +
            ", role=" + role +
            ", status=" + status +
            ", lastLoginTime=" + lastLoginTime +
            ", createTime=" + createTime +
            '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        SystemAdmin that = (SystemAdmin) o;
        return java.util.Objects.equals(id, that.id)
                && java.util.Objects.equals(username, that.username)
                && java.util.Objects.equals(password, that.password)
                && java.util.Objects.equals(realName, that.realName)
                && java.util.Objects.equals(phone, that.phone)
                && java.util.Objects.equals(email, that.email)
                && java.util.Objects.equals(role, that.role)
                && java.util.Objects.equals(status, that.status)
                && java.util.Objects.equals(lastLoginTime, that.lastLoginTime)
                && java.util.Objects.equals(createTime, that.createTime);
    }

    @Override
    public int hashCode() {
        return java.util.Objects.hash(id, username, password, realName, phone, email, role, status, lastLoginTime, createTime);
    }
}
