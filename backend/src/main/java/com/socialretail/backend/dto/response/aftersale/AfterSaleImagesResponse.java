package com.socialretail.backend.dto.response.aftersale;
import java.util.List;
public record AfterSaleImagesResponse(Long afterSaleId, List<String> imageUrls) { }
