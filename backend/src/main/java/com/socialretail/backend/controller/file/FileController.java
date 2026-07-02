package com.socialretail.backend.controller.file;

import com.socialretail.backend.common.exception.BusinessException;
import com.socialretail.backend.common.result.Result;
import com.socialretail.backend.config.JwtInterceptor;
import com.socialretail.backend.dto.response.file.BatchImageUploadResponse;
import com.socialretail.backend.dto.response.file.UploadedImageResponse;
import com.socialretail.backend.enums.file.ImageUploadType;
import com.socialretail.backend.service.file.LocalImageStorageService;
import jakarta.validation.constraints.Positive;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@Validated
@RestController
@RequestMapping("/api/files")
public class FileController {
    private final LocalImageStorageService imageStorageService;

    public FileController(LocalImageStorageService imageStorageService) {
        this.imageStorageService = imageStorageService;
    }

    @PostMapping(value = "/images", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public Result<UploadedImageResponse> uploadImage(
            @RequestAttribute(JwtInterceptor.USER_ID_ATTRIBUTE) Long userId,
            @RequestAttribute(value = "merchantId", required = false) Long merchantId,
            @RequestAttribute(value = "adminId", required = false) Long adminId,
            @RequestParam("file") MultipartFile file,
            @RequestParam ImageUploadType uploadType,
            @RequestParam(required = false) @Positive Long businessId) {
        Long effectiveBusinessId = effectiveBusinessId(
                userId, merchantId, adminId, uploadType, businessId);
        BatchImageUploadResponse response = imageStorageService
                .uploadImages(userId, List.of(file), uploadType, effectiveBusinessId);
        if (response.list() == null || response.list().isEmpty()) {
            String reason = response.failList() == null || response.failList().isEmpty()
                    ? "图片上传失败" : response.failList().get(0).reason();
            throw new BusinessException(40041, HttpStatus.BAD_REQUEST, reason);
        }
        return Result.success("上传成功", response.list().get(0));
    }

    @PostMapping(value = "/images/batch", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public Result<BatchImageUploadResponse> uploadImages(
            @RequestAttribute(JwtInterceptor.USER_ID_ATTRIBUTE) Long userId,
            @RequestAttribute(value = "merchantId", required = false) Long merchantId,
            @RequestAttribute(value = "adminId", required = false) Long adminId,
            @RequestParam("files") List<MultipartFile> files,
            @RequestParam ImageUploadType uploadType,
            @RequestParam(required = false) @Positive Long businessId) {
        Long effectiveBusinessId = effectiveBusinessId(
                userId, merchantId, adminId, uploadType, businessId);
        BatchImageUploadResponse response = imageStorageService
                .uploadImages(userId, files, uploadType, effectiveBusinessId);
        if (response.successList() != null && response.successList().isEmpty()) {
            throw new BusinessException(40041, HttpStatus.BAD_REQUEST, "所有文件上传失败", response);
        }
        String message = response.list() != null ? "批量上传成功" : "部分文件上传成功";
        return Result.success(message, response);
    }

    private Long effectiveBusinessId(Long userId, Long merchantId, Long adminId,
                                     ImageUploadType uploadType, Long requestedBusinessId) {
        if (uploadType.getOwnership() == ImageUploadType.Ownership.MERCHANT) {
            if (merchantId == null) {
                throw new BusinessException(40302, HttpStatus.FORBIDDEN, "该上传类型仅限商户使用");
            }
            if (uploadType == ImageUploadType.MERCHANT_AVATAR
                    || uploadType == ImageUploadType.MERCHANT_LOGO) {
                return merchantId;
            }
        }
        if (uploadType.getOwnership() == ImageUploadType.Ownership.MERCHANT_OR_ADMIN
                && merchantId == null && adminId == null) {
            throw new BusinessException(40302, HttpStatus.FORBIDDEN,
                    "该上传类型仅限商户或管理员使用");
        }
        if (uploadType.getOwnership() == ImageUploadType.Ownership.ADMIN && adminId == null) {
            throw new BusinessException(40302, HttpStatus.FORBIDDEN, "该上传类型仅限管理员使用");
        }
        if (uploadType.getOwnership() == ImageUploadType.Ownership.USER
                && (uploadType == ImageUploadType.USER_AVATAR
                || uploadType == ImageUploadType.MERCHANT_IDCARD_FRONT
                || uploadType == ImageUploadType.MERCHANT_IDCARD_BACK
                || uploadType == ImageUploadType.MERCHANT_LICENSE)) {
            return userId;
        }
        return requestedBusinessId;
    }
}
