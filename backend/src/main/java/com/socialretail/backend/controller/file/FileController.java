package com.socialretail.backend.controller.file;

import com.socialretail.backend.common.exception.BusinessException;
import com.socialretail.backend.common.result.Result;
import com.socialretail.backend.config.JwtInterceptor;
import com.socialretail.backend.dto.response.file.BatchImageUploadResponse;
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

    @PostMapping(value = "/images/batch", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public Result<BatchImageUploadResponse> uploadImages(
            @RequestAttribute(JwtInterceptor.USER_ID_ATTRIBUTE) Long userId,
            @RequestParam("files") List<MultipartFile> files,
            @RequestParam ImageUploadType uploadType,
            @RequestParam(required = false) @Positive Long businessId) {
        BatchImageUploadResponse response = imageStorageService
                .uploadImages(userId, files, uploadType, businessId);
        if (response.successList() != null && response.successList().isEmpty()) {
            throw new BusinessException(40041, HttpStatus.BAD_REQUEST, "所有文件上传失败", response);
        }
        String message = response.list() != null ? "批量上传成功" : "部分文件上传成功";
        return Result.success(message, response);
    }
}
