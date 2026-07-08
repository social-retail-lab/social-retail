package com.socialretail.backend.dto.request.social;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Digits;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

import java.math.BigDecimal;

public record DistributorWithdrawRequest(
        @NotNull @DecimalMin(value = "0.01") @Digits(integer = 8, fraction = 2) BigDecimal amount,
        @NotBlank @Size(max = 100) String bankName,
        @NotBlank @Size(max = 50) String bankCardNo,
        @NotBlank @Size(max = 50) String accountName) {
}
