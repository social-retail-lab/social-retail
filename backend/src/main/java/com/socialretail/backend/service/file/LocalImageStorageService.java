package com.socialretail.backend.service.file;

import com.socialretail.backend.common.ImageUrlResolver;
import com.socialretail.backend.common.exception.BusinessException;
import com.socialretail.backend.dto.response.file.BatchImageUploadResponse;
import com.socialretail.backend.dto.response.file.FailedImageResponse;
import com.socialretail.backend.dto.response.file.UploadedImageResponse;
import com.socialretail.backend.entity.file.FileRecord;
import com.socialretail.backend.enums.file.ImageUploadType;
import com.socialretail.backend.mapper.file.FileRecordMapper;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Service
public class LocalImageStorageService {
    private static final DateTimeFormatter DATE_DIRECTORY = DateTimeFormatter.BASIC_ISO_DATE;

    private final FileRecordMapper fileRecordMapper;
    private final ImageUrlResolver imageUrlResolver;
    private final Path uploadRoot;
    private final int maxCount;
    private final long maxFileSize;

    public LocalImageStorageService(FileRecordMapper fileRecordMapper,
                                    ImageUrlResolver imageUrlResolver,
                                    @Value("${upload.path:./uploads}") String uploadPath,
                                    @Value("${file.upload.max-count:9}") int maxCount,
                                    @Value("${file.upload.max-size-bytes:10485760}") long maxFileSize) {
        this.fileRecordMapper = fileRecordMapper;
        this.imageUrlResolver = imageUrlResolver;
        this.uploadRoot = Paths.get(uploadPath).toAbsolutePath().normalize();
        this.maxCount = maxCount;
        this.maxFileSize = maxFileSize;
    }

    public BatchImageUploadResponse uploadImages(Long userId, List<MultipartFile> files,
                                                 ImageUploadType uploadType, Long businessId) {
        if (files == null || files.isEmpty()) {
            throw new BusinessException(40040, HttpStatus.BAD_REQUEST, "至少上传一个图片文件");
        }
        if (files.size() > maxCount) {
            throw new BusinessException(40040, HttpStatus.BAD_REQUEST, "单次最多上传" + maxCount + "张图片");
        }

        List<UploadedImageResponse> success = new ArrayList<>();
        List<FailedImageResponse> failed = new ArrayList<>();
        for (MultipartFile file : files) {
            String originalName = safeOriginalName(file == null ? null : file.getOriginalFilename());
            try {
                success.add(storeOne(userId, file, uploadType, businessId, originalName));
            } catch (IllegalArgumentException | IOException exception) {
                failed.add(new FailedImageResponse(originalName, exception.getMessage()));
            }
        }
        if (failed.isEmpty()) {
            return BatchImageUploadResponse.allSucceeded(success);
        }
        return BatchImageUploadResponse.partiallySucceeded(success, failed);
    }

    private UploadedImageResponse storeOne(Long userId, MultipartFile file, ImageUploadType uploadType,
                                           Long businessId, String originalName) throws IOException {
        if (file == null || file.isEmpty()) {
            throw new IllegalArgumentException("文件为空");
        }
        if (file.getSize() > maxFileSize) {
            throw new IllegalArgumentException("文件大小超过" + (maxFileSize / 1024 / 1024) + "MB");
        }
        ImageType imageType = detectImageType(file);
        String storedName = UUID.randomUUID().toString().replace("-", "") + "." + imageType.extension();
        String relativeDirectory = uploadType.getDirectory() + "/" + LocalDate.now().format(DATE_DIRECTORY);
        String relativePath = relativeDirectory + "/" + storedName;
        Path target = uploadRoot.resolve(relativePath).normalize();
        if (!target.startsWith(uploadRoot)) {
            throw new IllegalArgumentException("非法文件路径");
        }

        Files.createDirectories(target.getParent());
        try (InputStream inputStream = file.getInputStream()) {
            Files.copy(inputStream, target, StandardCopyOption.REPLACE_EXISTING);
        }

        FileRecord record = new FileRecord();
        record.setOwnerUserId(userId);
        record.setUploadType(uploadType.name());
        record.setBusinessId(businessId);
        record.setOriginalName(originalName);
        record.setStoredPath(relativePath);
        record.setFileSize(file.getSize());
        record.setContentType(imageType.contentType());
        record.setCreateTime(LocalDateTime.now());
        record.setIsDeleted(0);
        try {
            if (fileRecordMapper.insert(record) != 1) {
                throw new IllegalStateException("文件记录保存失败");
            }
        } catch (RuntimeException exception) {
            Files.deleteIfExists(target);
            throw exception;
        }
        return new UploadedImageResponse(record.getId(), originalName,
                imageUrlResolver.resolve(relativePath), file.getSize());
    }

    private ImageType detectImageType(MultipartFile file) throws IOException {
        byte[] header = new byte[12];
        int length;
        try (InputStream inputStream = file.getInputStream()) {
            length = inputStream.read(header);
        }
        if (length >= 3 && unsigned(header[0]) == 0xFF && unsigned(header[1]) == 0xD8
                && unsigned(header[2]) == 0xFF) {
            return new ImageType("jpg", "image/jpeg");
        }
        if (length >= 8 && unsigned(header[0]) == 0x89 && header[1] == 'P' && header[2] == 'N'
                && header[3] == 'G' && unsigned(header[4]) == 0x0D && unsigned(header[5]) == 0x0A
                && unsigned(header[6]) == 0x1A && unsigned(header[7]) == 0x0A) {
            return new ImageType("png", "image/png");
        }
        if (length >= 6) {
            String signature = new String(header, 0, 6, java.nio.charset.StandardCharsets.US_ASCII);
            if ("GIF87a".equals(signature) || "GIF89a".equals(signature)) {
                return new ImageType("gif", "image/gif");
            }
        }
        if (length >= 12 && header[0] == 'R' && header[1] == 'I' && header[2] == 'F' && header[3] == 'F'
                && header[8] == 'W' && header[9] == 'E' && header[10] == 'B' && header[11] == 'P') {
            return new ImageType("webp", "image/webp");
        }
        throw new IllegalArgumentException("文件格式不支持，仅允许 JPG、PNG、GIF、WEBP");
    }

    private int unsigned(byte value) {
        return value & 0xFF;
    }

    private String safeOriginalName(String originalName) {
        if (originalName == null || originalName.isBlank()) {
            return "unnamed-image";
        }
        String normalized = originalName.replace('\\', '/');
        String value = normalized.substring(normalized.lastIndexOf('/') + 1).trim();
        if (value.length() > 200) {
            value = value.substring(value.length() - 200);
        }
        return value;
    }

    private record ImageType(String extension, String contentType) {
    }
}
