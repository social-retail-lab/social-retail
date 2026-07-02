package com.socialretail.backend.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

@Data
@Component
@ConfigurationProperties(prefix = "alipay")
public class AlipayProperties {
    private String appId;
    private String privateKey;
    private String alipayPublicKey;
    private String notifyUrl;
    private String returnUrl;
    private String mobileReturnUrl;
    private String serverUrl;
    private String signType = "RSA2";
    private String charset = "UTF-8";
    private String format = "json";
}
