package com.socialretail.backend.dto.request.social;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record DistributorApplyRequest(
        @NotBlank @Size(max = 50) String realName,
        @NotBlank @Size(max = 30) String idCardNo,
        @NotBlank @Size(max = 255) String idCardFront,
        @NotBlank @Size(max = 255) String idCardBack,
        @NotBlank @Size(max = 100) String bankName,
        @NotBlank @Size(max = 50) String bankCardNo,
        @NotBlank @Size(max = 50) String bankAccountName) {
}
