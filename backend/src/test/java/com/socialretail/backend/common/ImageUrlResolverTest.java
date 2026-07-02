package com.socialretail.backend.common;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

class ImageUrlResolverTest {
    private final ImageUrlResolver resolver = new ImageUrlResolver(
            "G:/social_retail_lab/social-retail/backend/uploads",
            "http://192.168.1.20:8081"
    );

    @Test
    void convertsWindowsUploadPathToPublicUrl() {
        assertEquals(
                "http://192.168.1.20:8081/uploads/temp/upload/E8C8E3A43B7AA5723A3DFF4BA8FE9D70.jpg",
                resolver.resolve("G:\\social_retail_lab\\social-retail\\backend\\uploads\\temp\\upload\\E8C8E3A43B7AA5723A3DFF4BA8FE9D70.jpg")
        );
    }

    @Test
    void mapsLegacyFileNameToTemporaryUploadDirectory() {
        assertEquals(
                "http://192.168.1.20:8081/uploads/temp/upload/image.jpg",
                resolver.resolve("image.jpg")
        );
    }

    @Test
    void keepsHttpUrlAndUnwrapsMarkdownLink() {
        assertEquals("https://cdn.example.com/product.jpg",
                resolver.resolve("[image](https://cdn.example.com/product.jpg)"));
    }

    @Test
    void rewritesStoredLocalhostUploadUrlToConfiguredBackendHost() {
        assertEquals(
                "http://192.168.1.20:8081/uploads/temp/upload/image.jpg",
                resolver.resolve("http://localhost:8081/uploads/temp/upload/image.jpg")
        );
    }
}
