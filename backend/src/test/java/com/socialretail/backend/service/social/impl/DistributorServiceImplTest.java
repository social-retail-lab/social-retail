package com.socialretail.backend.service.social.impl;

import com.google.zxing.BinaryBitmap;
import com.google.zxing.MultiFormatReader;
import com.google.zxing.client.j2se.BufferedImageLuminanceSource;
import com.google.zxing.common.HybridBinarizer;
import com.socialretail.backend.common.ImageUrlResolver;
import com.socialretail.backend.service.file.LocalImageStorageService;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.io.TempDir;
import org.springframework.jdbc.core.JdbcTemplate;

import javax.imageio.ImageIO;
import java.nio.file.Path;
import java.sql.Timestamp;
import java.time.LocalDateTime;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNull;

class DistributorServiceImplTest {
    @Test
    void convertsJdbcDateTimeRepresentations() {
        LocalDateTime expected = LocalDateTime.of(2026, 7, 6, 15, 9, 2);

        assertEquals(expected, DistributorServiceImpl.time(expected));
        assertEquals(expected, DistributorServiceImpl.time(Timestamp.valueOf(expected)));
        assertNull(DistributorServiceImpl.time(null));
    }

    @Test
    void buildsFrontendProductPromotionUrlFromConfiguredBaseUrl() {
        assertEquals(
                "http://172.20.10.2:5173/pages/product/detail?id=6014&promotionCode=PRxxx",
                DistributorServiceImpl.buildPromotionUrl(
                        "http://172.20.10.2:5173/", 6014L, "PRxxx"));
    }

    @Test
    void switchesPromotionDomainWithoutChangingUrlLogic() {
        assertEquals(
                "https://mall.xxx.com/pages/product/detail?id=6014&promotionCode=PRxxx",
                DistributorServiceImpl.buildPromotionUrl(
                        "https://mall.xxx.com", 6014L, "PRxxx"));
    }

    @Test
    void qrCodeEncodesTheFinalPromotionUrl(@TempDir Path tempDir) throws Exception {
        DistributorServiceImpl service = new DistributorServiceImpl(
                org.mockito.Mockito.mock(JdbcTemplate.class),
                org.mockito.Mockito.mock(LocalImageStorageService.class),
                org.mockito.Mockito.mock(ImageUrlResolver.class),
                tempDir.toString(), "", "http://172.20.10.2:5173");
        String promotionUrl = DistributorServiceImpl.buildPromotionUrl(
                "http://172.20.10.2:5173", 6014L, "PRxxx");

        service.generateQr("PRxxx", promotionUrl);

        var image = ImageIO.read(tempDir.resolve("qrcode/PRxxx.png").toFile());
        var bitmap = new BinaryBitmap(new HybridBinarizer(
                new BufferedImageLuminanceSource(image)));
        assertEquals(promotionUrl, new MultiFormatReader().decode(bitmap).getText());
    }
}
