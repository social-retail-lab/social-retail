package com.socialretail.backend.vo;


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

    public Long getAdminId() {
        return adminId;
    }

    public void setAdminId(Long adminId) {
        this.adminId = adminId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
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

    public String getLastLoginTime() {
        return lastLoginTime;
    }

    public void setLastLoginTime(String lastLoginTime) {
        this.lastLoginTime = lastLoginTime;
    }

    public String getAdminType() {
        return adminType;
    }

    public void setAdminType(String adminType) {
        this.adminType = adminType;
    }

    @Override
    public String toString() {
        return "AdminInfoVO{" +
            ", adminId=" + adminId +
            ", username=" + username +
            ", realName=" + realName +
            ", phone=" + phone +
            ", email=" + email +
            ", role=" + role +
            ", status=" + status +
            ", lastLoginTime=" + lastLoginTime +
            ", adminType=" + adminType +
            '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        AdminInfoVO that = (AdminInfoVO) o;
        return java.util.Objects.equals(adminId, that.adminId)
                && java.util.Objects.equals(username, that.username)
                && java.util.Objects.equals(realName, that.realName)
                && java.util.Objects.equals(phone, that.phone)
                && java.util.Objects.equals(email, that.email)
                && java.util.Objects.equals(role, that.role)
                && java.util.Objects.equals(status, that.status)
                && java.util.Objects.equals(lastLoginTime, that.lastLoginTime)
                && java.util.Objects.equals(adminType, that.adminType);
    }

    @Override
    public int hashCode() {
        return java.util.Objects.hash(adminId, username, realName, phone, email, role, status, lastLoginTime, adminType);
    }
}
