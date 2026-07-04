package com.socialretail.backend.config;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

class AlipayPropertiesTest {

    @Test
    void normalizesMarkdownAndMalformedCallbackUrls() {
        AlipayProperties properties = new AlipayProperties();

        properties.setNotifyUrl("[https://api.example.com/api/pay/alipay/notify}](https://api.example.com/api/pay/alipay/notify)");
        properties.setReturnUrl("[http://web.example.com/#/orders](http://web.example.com/#/orders)");
        properties.setMobileReturnUrl("https://web.example.com/#/orders}");

        assertEquals("https://api.example.com/api/pay/alipay/notify", properties.getNotifyUrl());
        assertEquals("http://web.example.com/#/orders", properties.getReturnUrl());
        assertEquals("https://web.example.com/#/orders", properties.getMobileReturnUrl());
    }
}
