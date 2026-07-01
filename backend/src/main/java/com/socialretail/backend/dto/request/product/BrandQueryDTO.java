package com.socialretail.backend.dto.request.product;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.Positive;
import lombok.Data;

@Data
public class BrandQueryDTO {

    @Positive(message = "分类ID必须大于0")
    private Long categoryId;

    @Min(value = 1, message = "页码必须从1开始")
    private Integer page = 1;

    @Min(value = 1, message = "每页条数不能小于1")
    @Max(value = 100, message = "每页条数不能超过100")
    private Integer pageSize = 20;
}
