package com.socialretail.backend.vo;

import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@NoArgsConstructor
@JsonInclude(JsonInclude.Include.NON_NULL)
public class ProductListVO {

    private Long productId;
    private String title;
    private String mainImage;
    private BigDecimal price;
    private Integer sales;

    // 以下字段保留给现有商家端与审核端使用。
    private BigDecimal minPrice;
    private BigDecimal maxPrice;
    private Integer totalStock;
    private Integer auditStatus;
    private String auditStatusText;
    private Integer status;
    private String statusText;
    private String createTime;

    public ProductListVO(Long productId,
                         String title,
                         String mainImage,
                         BigDecimal price,
                         Integer sales) {
        this.productId = productId;
        this.title = title;
        this.mainImage = mainImage;
        this.price = price;
        this.sales = sales;
    }
}
