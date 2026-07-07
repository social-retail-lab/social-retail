package com.socialretail.backend.dto.request.social;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;

public record ShareLinkRequest(
        @NotNull @Positive Long distributorProductId) {
}
