package com.socialretail.backend.dto.response.file;

import com.fasterxml.jackson.annotation.JsonInclude;

import java.util.List;

@JsonInclude(JsonInclude.Include.NON_NULL)
public record BatchImageUploadResponse(List<UploadedImageResponse> list,
                                       List<UploadedImageResponse> successList,
                                       List<FailedImageResponse> failList) {
    public static BatchImageUploadResponse allSucceeded(List<UploadedImageResponse> images) {
        return new BatchImageUploadResponse(images, null, null);
    }

    public static BatchImageUploadResponse partiallySucceeded(List<UploadedImageResponse> success,
                                                               List<FailedImageResponse> failed) {
        return new BatchImageUploadResponse(null, success, failed);
    }
}
