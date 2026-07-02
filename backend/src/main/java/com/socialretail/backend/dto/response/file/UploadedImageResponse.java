package com.socialretail.backend.dto.response.file;

public record UploadedImageResponse(Long fileId, String fileName, String fileUrl, Long fileSize) {
}
