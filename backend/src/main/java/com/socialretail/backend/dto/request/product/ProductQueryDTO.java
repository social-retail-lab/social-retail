package com.socialretail.backend.dto.request.product;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class ProductQueryDTO {

    @Positive(message = "分类ID必须大于0")
    private Long categoryId;

    @Size(max = 100, message = "搜索关键词不能超过100位")
    private String keyword;

    @Min(value = 1, message = "页码必须从1开始")
    private Integer page = 1;

    @Min(value = 1, message = "每页条数不能小于1")
    @Max(value = 100, message = "每页条数不能超过100")
    private Integer size = 10;

    @Size(max = 30, message = "排序参数不能超过30位")
    private String sort;
}
