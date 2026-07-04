package com.socialretail.backend.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebMvcConfig implements WebMvcConfigurer {

    private final JwtInterceptor jwtInterceptor;

    public WebMvcConfig(JwtInterceptor jwtInterceptor) {
        this.jwtInterceptor = jwtInterceptor;
    }

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(jwtInterceptor)
                .addPathPatterns(
                        "/api/user/**",
                        "/api/addresses/**",
                        "/api/cart/**",
                        "/api/orders/**",
                        "/api/discount-rules/**",
                        "/api/merchants/*/coupons",
                        "/api/merchant-coupons/**",
                        "/api/coupons/**",
                        "/api/after-sales/**",
                        "/api/pay/**",
                        "/api/member/**",
                        "/api/points/**",
                        "/api/growth/**",
                        "/api/internal/member/**",
                        "/api/seckill/products/**"
                )
                .excludePathPatterns(
                        "/api/auth/login",
                        "/api/auth/register",
                        "/api/pay/alipay/notify"
                );
    }
}
