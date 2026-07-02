package com.socialretail.backend.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.nio.file.Path;
import java.nio.file.Paths;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    private final JwtInterceptor jwtInterceptor;

    @Value("${upload.path:}")
    private String uploadPath;

    public WebConfig(JwtInterceptor jwtInterceptor) {
        this.jwtInterceptor = jwtInterceptor;
    }

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(jwtInterceptor)
                .addPathPatterns("/api/**")
                .excludePathPatterns(
                        "/api/merchant/auth/login",
                        "/api/admin/operation/auth/login",
                        "/api/admin/system/auth/login",
                        "/api/auth/login",
                        "/api/auth/register",
                        "/api/user/sms/send",
                        "/api/pay/alipay/notify"
                );
    }

    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/**")
                .allowedOriginPatterns("*")
                .allowedMethods("GET", "POST", "PUT", "DELETE", "PATCH", "OPTIONS")
                .allowedHeaders("*")
                .allowCredentials(true)
                .maxAge(3600);
    }

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // 映射上传目录为静态资源，使用绝对路径避免 Tomcat temp 目录问题
        Path basePath;
        if (uploadPath != null && !uploadPath.isEmpty()) {
            basePath = Paths.get(uploadPath).toAbsolutePath();
        } else {
            basePath = Paths.get(System.getProperty("user.dir"), "static").toAbsolutePath();
        }
        registry.addResourceHandler("/static/**")
                .addResourceLocations("file:" + basePath.toString().replace("\\", "/") + "/");
    }
}
