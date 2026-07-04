package com.socialretail.backend.config;

import com.alipay.api.AlipayClient;
import com.alipay.api.DefaultAlipayClient;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class AliPayConfig {

    @Bean
    public AlipayClient alipayClient(AlipayProperties properties) {
        return new DefaultAlipayClient(
                properties.getServerUrl(), properties.getAppId(),
                properties.getPrivateKey(), properties.getFormat(),
                properties.getCharset(), properties.getAlipayPublicKey(),
                properties.getSignType()
        );
    }
}
