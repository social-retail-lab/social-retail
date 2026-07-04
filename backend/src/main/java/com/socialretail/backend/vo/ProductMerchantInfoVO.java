package com.socialretail.backend.vo;

import com.fasterxml.jackson.annotation.JsonInclude;

@JsonInclude(JsonInclude.Include.NON_NULL)
public record ProductMerchantInfoVO(Long merchantId, String merchantName, String merchantLogo) {
}
