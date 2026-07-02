package com.socialretail.backend.dto.response.aftersale;
import com.socialretail.backend.enums.aftersale.AfterSaleStatus;
public record AfterSaleStatusResponse(Long afterSaleId, AfterSaleStatus status) { }
