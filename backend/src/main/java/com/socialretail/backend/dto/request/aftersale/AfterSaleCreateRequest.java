package com.socialretail.backend.dto.request.aftersale;

import com.socialretail.backend.enums.aftersale.AfterSaleType;
import jakarta.validation.constraints.*;
import java.math.BigDecimal;
import java.util.List;

public record AfterSaleCreateRequest(
        @NotNull @Positive Long orderId,
        @NotNull @Positive Long orderItemId,
        @NotNull AfterSaleType type,
        @NotNull @DecimalMin("0.01") BigDecimal refundAmount,
        @NotBlank @Size(max = 200) String reason,
        @Size(max = 9, message = "凭证图片最多9张") List<@NotBlank String> evidenceImages) { }
