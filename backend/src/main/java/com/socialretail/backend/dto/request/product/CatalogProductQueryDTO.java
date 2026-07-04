package com.socialretail.backend.dto.request.product;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.Size;
import lombok.Data;

import java.math.BigDecimal;

@Data
public class CatalogProductQueryDTO {

    @Min(value = 1, message = "页码必须从1开始")
    private Integer page = 1;

    @Min(value = 1, message = "每页条数不能小于1")
    @Max(value = 100, message = "每页条数不能超过100")
    private Integer pageSize = 10;

    @Positive(message = "分类ID必须大于0")
    private Long categoryId;

    @Positive(message = "品牌ID必须大于0")
    private Long brandId;

    @DecimalMin(value = "0.00", message = "最低价格不能小于0")
    private BigDecimal minPrice;

    @DecimalMin(value = "0.00", message = "最高价格不能小于0")
    private BigDecimal maxPrice;

    @Size(max = 20, message = "排序字段不能超过20个字符")
    private String sortField;

    @Size(max = 4, message = "排序方式不能超过4个字符")
    private String sortOrder;
}
