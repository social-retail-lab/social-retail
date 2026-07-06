package com.socialretail.backend.vo;


public class MerchantLoginRequest {

    private String phone;
    private String password;
    private String smsCode;

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getSmsCode() {
        return smsCode;
    }

    public void setSmsCode(String smsCode) {
        this.smsCode = smsCode;
    }

    @Override
    public String toString() {
        return "MerchantLoginRequest{" +
            ", phone=" + phone +
            ", password=" + password +
            ", smsCode=" + smsCode +
            '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        MerchantLoginRequest that = (MerchantLoginRequest) o;
        return java.util.Objects.equals(phone, that.phone)
                && java.util.Objects.equals(password, that.password)
                && java.util.Objects.equals(smsCode, that.smsCode);
    }

    @Override
    public int hashCode() {
        return java.util.Objects.hash(phone, password, smsCode);
    }
}
