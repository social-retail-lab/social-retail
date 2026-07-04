package com.socialretail.backend.dto.request.aftersale;
import jakarta.validation.constraints.*;
import java.util.List;
public record AfterSaleImagesRequest(
        @NotEmpty @Size(max = 9, message = "单次最多上传9张凭证") List<@NotBlank String> imageUrls) { }
