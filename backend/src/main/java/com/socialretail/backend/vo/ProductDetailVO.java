package com.socialretail.backend.vo;

import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.util.List;

@Data
@NoArgsConstructor
@JsonInclude(JsonInclude.Include.NON_NULL)
public class ProductDetailVO {
    private Long productId;
    private String productName;
    private String productImage;

    @JsonInclude(JsonInclude.Include.NON_EMPTY)
    private List<String> bannerImages;

    @JsonInclude(JsonInclude.Include.NON_EMPTY)
    private List<String> detailImages;

    private String description;
    private Long categoryId;
    private String categoryName;
    private Long brandId;
    private String brandName;
    private BigDecimal price;
    private BigDecimal originalPrice;
    private Long soldCount;
    private Integer stock;
    private String status;
    private ProductMerchantInfoVO merchantInfo;

    @JsonInclude(JsonInclude.Include.NON_EMPTY)
    private List<SkuVO> skuList;
}
