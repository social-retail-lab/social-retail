package com.socialretail.backend.service.file;

import com.socialretail.backend.common.ImageUrlResolver;
import com.socialretail.backend.common.exception.BusinessException;
import com.socialretail.backend.dto.response.file.BatchImageUploadResponse;
import com.socialretail.backend.entity.file.FileRecord;
import com.socialretail.backend.enums.file.ImageUploadType;
import com.socialretail.backend.mapper.file.FileRecordMapper;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.io.TempDir;
import org.mockito.ArgumentCaptor;
import org.springframework.mock.web.MockMultipartFile;

import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

class LocalImageStorageServiceTest {
    @TempDir
    Path uploadRoot;

    @Test
    void uploadsValidImageAndPersistsRelativePath() {
        FileRecordMapper mapper = mapperAssigningId(6001L);
        LocalImageStorageService service = service(mapper);
        MockMultipartFile image = new MockMultipartFile(
                "files", "detail.png", "image/png", pngBytes());

        BatchImageUploadResponse response = service.uploadImages(
                1001L, List.of(image), ImageUploadType.PRODUCT_DETAIL, 2001L);

        assertNotNull(response.list());
        assertEquals(6001L, response.list().get(0).fileId());
        assertTrue(response.list().get(0).fileUrl().startsWith(
                "http://backend.test:8081/uploads/product/detail/"));
        ArgumentCaptor<FileRecord> captor = ArgumentCaptor.forClass(FileRecord.class);
        org.mockito.Mockito.verify(mapper).insert(captor.capture());
        assertFalse(Path.of(captor.getValue().getStoredPath()).isAbsolute());
        assertTrue(Files.exists(uploadRoot.resolve(captor.getValue().getStoredPath())));
    }

    @Test
    void returnsPartialResultWhenOneFileIsNotAnImage() {
        FileRecordMapper mapper = mapperAssigningId(6001L);
        LocalImageStorageService service = service(mapper);
        MockMultipartFile valid = new MockMultipartFile(
                "files", "detail.png", "image/png", pngBytes());
        MockMultipartFile invalid = new MockMultipartFile(
                "files", "detail.exe", "application/octet-stream", new byte[]{1, 2, 3, 4});

        BatchImageUploadResponse response = service.uploadImages(
                1001L, List.of(valid, invalid), ImageUploadType.AFTER_SALE, null);

        assertNull(response.list());
        assertEquals(1, response.successList().size());
        assertEquals("detail.exe", response.failList().get(0).fileName());
        assertTrue(response.failList().get(0).reason().contains("文件格式不支持"));
    }

    @Test
    void rejectsMultipleImagesForSingleImageType() {
        LocalImageStorageService service = service(mapperAssigningId(6001L));
        MockMultipartFile first = new MockMultipartFile(
                "files", "avatar1.png", "image/png", pngBytes());
        MockMultipartFile second = new MockMultipartFile(
                "files", "avatar2.png", "image/png", pngBytes());

        BusinessException exception = assertThrows(BusinessException.class,
                () -> service.uploadImages(1001L, List.of(first, second),
                        ImageUploadType.USER_AVATAR, null));

        assertEquals(40040, exception.getCode());
        assertTrue(exception.getMessage().contains("仅允许上传一张图片"));
    }

    @Test
    void storesBrandLogoInBrandLogoDirectory() {
        LocalImageStorageService service = service(mapperAssigningId(6002L));
        MockMultipartFile logo = new MockMultipartFile(
                "files", "brand-logo.png", "image/png", pngBytes());

        BatchImageUploadResponse response = service.uploadImages(
                1001L, List.of(logo), ImageUploadType.BRAND_LOGO, 3001L);

        assertTrue(response.list().get(0).fileUrl().contains("/uploads/brand/logo/"));
    }

    private LocalImageStorageService service(FileRecordMapper mapper) {
        return new LocalImageStorageService(
                mapper,
                new ImageUrlResolver(uploadRoot.toString(), "http://backend.test:8081"),
                uploadRoot.toString(),
                9,
                10 * 1024 * 1024
        );
    }

    private FileRecordMapper mapperAssigningId(long id) {
        FileRecordMapper mapper = mock(FileRecordMapper.class);
        when(mapper.insert(any(FileRecord.class))).thenAnswer(invocation -> {
            invocation.<FileRecord>getArgument(0).setId(id);
            return 1;
        });
        return mapper;
    }

    private byte[] pngBytes() {
        return new byte[]{(byte) 0x89, 'P', 'N', 'G', 0x0D, 0x0A, 0x1A, 0x0A, 1, 2, 3, 4};
    }
}
