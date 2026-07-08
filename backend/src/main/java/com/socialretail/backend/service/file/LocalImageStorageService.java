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
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Service
public class LocalImageStorageService {
    private static final DateTimeFormatter DATE_DIRECTORY = DateTimeFormatter.BASIC_ISO_DATE;
    private static final Pattern PRIVATE_IMAGE_URL = Pattern.compile(
            ".*/api/files/images/(\\d+)/content(?:[?#].*)?$");

    private final FileRecordMapper fileRecordMapper;
    private final ImageUrlResolver imageUrlResolver;
    private final Path uploadRoot;
    private final Path distributorIdCardRoot;
    private final int maxCount;
    private final long maxFileSize;

    public LocalImageStorageService(FileRecordMapper fileRecordMapper,
                                    ImageUrlResolver imageUrlResolver,
                                    @Value("${upload.path:./uploads}") String uploadPath,
                                    @Value("${distributor.id-card-storage-path:./distributor/id}")
                                    String distributorIdCardStoragePath,
                                    @Value("${file.upload.max-count:9}") int maxCount,
                                    @Value("${file.upload.max-size-bytes:10485760}") long maxFileSize) {
        this.fileRecordMapper = fileRecordMapper;
        this.imageUrlResolver = imageUrlResolver;
        this.uploadRoot = Paths.get(uploadPath).toAbsolutePath().normalize();
        this.distributorIdCardRoot = Paths.get(distributorIdCardStoragePath)
                .toAbsolutePath().normalize();
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
        if (uploadType.isSingleImageOnly() && files.size() > 1) {
            throw new BusinessException(40040, HttpStatus.BAD_REQUEST,
                    uploadType.name() + "仅允许上传一张图片");
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
        Path storageRoot = uploadType.isDistributorIdCard() ? distributorIdCardRoot : uploadRoot;
        String relativeDirectory = uploadType.isDistributorIdCard()
                ? uploadType.getDirectory()
                : uploadType.getDirectory() + "/" + LocalDate.now().format(DATE_DIRECTORY);
        String relativePath = relativeDirectory + "/" + storedName;
        Path target = storageRoot.resolve(relativePath).normalize();
        if (!target.startsWith(storageRoot)) {
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
        String fileUrl = uploadType.isDistributorIdCard()
                ? "/api/files/images/" + record.getId() + "/content"
                : imageUrlResolver.resolve(relativePath);
        return new UploadedImageResponse(record.getId(), originalName, fileUrl, file.getSize());
    }

    public PrivateImage loadPrivateImage(Long userId, Long adminId, Long fileId) {
        FileRecord record = fileRecordMapper.selectById(fileId);
        if (record == null || record.getIsDeleted() == null || record.getIsDeleted() != 0
                || !isDistributorIdCard(record.getUploadType())) {
            throw new BusinessException(40441, HttpStatus.NOT_FOUND, "身份证图片不存在");
        }
        if (adminId == null && (userId == null || !userId.equals(record.getOwnerUserId()))) {
            throw new BusinessException(40341, HttpStatus.FORBIDDEN, "无权访问该身份证图片");
        }
        Path target = distributorIdCardRoot.resolve(record.getStoredPath()).normalize();
        if (!target.startsWith(distributorIdCardRoot) || !Files.isRegularFile(target)) {
            throw new BusinessException(40441, HttpStatus.NOT_FOUND, "身份证图片不存在");
        }
        return new PrivateImage(target, record.getContentType());
    }

    public String validateDistributorIdCard(Long userId, String fileUrl, ImageUploadType expectedType) {
        Matcher matcher = PRIVATE_IMAGE_URL.matcher(fileUrl == null ? "" : fileUrl.trim());
        if (!matcher.matches()) {
            throw new BusinessException(40065, HttpStatus.BAD_REQUEST,
                    "身份证图片地址无效，请先通过图片上传接口上传");
        }
        FileRecord record = fileRecordMapper.selectById(Long.parseLong(matcher.group(1)));
        if (record == null || record.getIsDeleted() == null || record.getIsDeleted() != 0
                || !userId.equals(record.getOwnerUserId())
                || !expectedType.name().equals(record.getUploadType())) {
            throw new BusinessException(40065, HttpStatus.BAD_REQUEST,
                    "身份证图片不存在、类型不匹配或不属于当前用户");
        }
        return "/api/files/images/" + record.getId() + "/content";
    }

    private boolean isDistributorIdCard(String uploadType) {
        return ImageUploadType.DISTRIBUTOR_IDCARD_FRONT.name().equals(uploadType)
                || ImageUploadType.DISTRIBUTOR_IDCARD_BACK.name().equals(uploadType);
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

    public record PrivateImage(Path path, String contentType) {
    }
}
