package com.socialretail.backend.vo;

import com.fasterxml.jackson.annotation.JsonInclude;

@JsonInclude(JsonInclude.Include.NON_NULL)
public class LoginVO {

    private String token;
    private Long expireTime;
    private Integer merchantStatus;
    private MerchantInfoVO merchantInfo;
    private AdminInfoVO adminInfo;

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public Long getExpireTime() {
        return expireTime;
    }

    public void setExpireTime(Long expireTime) {
        this.expireTime = expireTime;
    }

    public Integer getMerchantStatus() {
        return merchantStatus;
    }

    public void setMerchantStatus(Integer merchantStatus) {
        this.merchantStatus = merchantStatus;
    }

    public MerchantInfoVO getMerchantInfo() {
        return merchantInfo;
    }

    public void setMerchantInfo(MerchantInfoVO merchantInfo) {
        this.merchantInfo = merchantInfo;
    }

    public AdminInfoVO getAdminInfo() {
        return adminInfo;
    }

    public void setAdminInfo(AdminInfoVO adminInfo) {
        this.adminInfo = adminInfo;
    }
}
