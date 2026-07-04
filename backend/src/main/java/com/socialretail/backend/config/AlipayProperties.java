package com.socialretail.backend.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Data
@Component
@ConfigurationProperties(prefix = "alipay")
public class AlipayProperties {
    private static final Pattern MARKDOWN_URL = Pattern.compile(
            "^\\[https?://[^]]+]\\((https?://[^)]+)\\)$", Pattern.CASE_INSENSITIVE);

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

    public void setNotifyUrl(String notifyUrl) {
        this.notifyUrl = normalizeExternalUrl(notifyUrl);
    }

    public void setReturnUrl(String returnUrl) {
        this.returnUrl = normalizeExternalUrl(returnUrl);
    }

    public void setMobileReturnUrl(String mobileReturnUrl) {
        this.mobileReturnUrl = normalizeExternalUrl(mobileReturnUrl);
    }

    static String normalizeExternalUrl(String value) {
        if (value == null) {
            return null;
        }
        String normalized = value.trim();
        Matcher markdown = MARKDOWN_URL.matcher(normalized);
        if (markdown.matches()) {
            normalized = markdown.group(1);
        }
        return normalized.replaceFirst("[}\\]]+$", "");
    }
}
