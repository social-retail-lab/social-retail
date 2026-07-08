package com.socialretail.backend.service.file;

import com.socialretail.backend.common.ImageUrlResolver;
import com.socialretail.backend.dto.response.file.BatchImageUploadResponse;
import com.socialretail.backend.entity.file.FileRecord;
import com.socialretail.backend.enums.file.ImageUploadType;
import com.socialretail.backend.mapper.file.FileRecordMapper;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.io.TempDir;
import org.springframework.mock.web.MockMultipartFile;

import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

class LocalImageStorageServiceTest {
    @TempDir
    Path tempDirectory;

    @Test
    void storesDistributorIdCardInConfiguredSideDirectory() throws Exception {
        FileRecordMapper mapper = mock(FileRecordMapper.class);
        when(mapper.insert(any(FileRecord.class))).thenAnswer(invocation -> {
            FileRecord record = invocation.getArgument(0);
            record.setId(42L);
            return 1;
        });
        LocalImageStorageService service = new LocalImageStorageService(
                mapper, mock(ImageUrlResolver.class), tempDirectory.resolve("uploads").toString(),
                tempDirectory.resolve("distributor/id").toString(), 9, 10_485_760L);
        byte[] png = new byte[]{(byte) 0x89, 'P', 'N', 'G', 0x0D, 0x0A, 0x1A, 0x0A};

        BatchImageUploadResponse response = service.uploadImages(7L,
                List.of(new MockMultipartFile("file", "front.png", "image/png", png)),
                ImageUploadType.DISTRIBUTOR_IDCARD_FRONT, 7L);

        assertEquals("/api/files/images/42/content", response.list().get(0).fileUrl());
        try (var files = Files.list(tempDirectory.resolve("distributor/id/front"))) {
            assertTrue(files.anyMatch(path -> path.getFileName().toString().endsWith(".png")));
        }
    }
}
