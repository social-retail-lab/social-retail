package com.socialretail.backend.config;

import com.socialretail.backend.interceptor.AuthInterceptor;
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

    private final AuthInterceptor authInterceptor;

    @Value("${upload.path:}")
    private String uploadPath;

    public WebConfig(AuthInterceptor authInterceptor) {
        this.authInterceptor = authInterceptor;
    }

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(authInterceptor)
                .addPathPatterns("/api/**")
                .excludePathPatterns(
                        "/api/merchant/auth/login",
                        "/api/merchant/notifications/**",
                        "/api/admin/operation/auth/login",
                        "/api/admin/system/auth/login",
                        "/api/admin/notifications/**",
                        "/api/user/sms/**"
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
        // 映射static目录为静态资源，使用绝对路径
        Path basePath;
        if (uploadPath != null && !uploadPath.isEmpty()) {
            basePath = Paths.get(uploadPath).toAbsolutePath();
        } else {
            basePath = Paths.get(System.getProperty("user.dir"), "src", "main", "resources", "static").toAbsolutePath();
        }
        String basePathStr = "file:" + basePath.toString().replace("\\", "/") + "/";
        registry.addResourceHandler("/static/**")
                .addResourceLocations(basePathStr);
        registry.addResourceHandler("/uploads/**")
                .addResourceLocations(basePathStr);
    }
}
