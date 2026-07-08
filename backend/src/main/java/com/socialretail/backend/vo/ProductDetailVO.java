package com.socialretail.backend.vo;

import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import com.fasterxml.jackson.annotation.JsonFormat;

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
    private BigDecimal ratingScore;
    private Integer commentCount;
    private List<ProductLatestCommentVO> latestComments;
    private String status;
    private ProductMerchantInfoVO merchantInfo;
    private Long distributorProductId;
    private String promotionCode;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime promotionExpiresAt;

    @JsonInclude(JsonInclude.Include.NON_EMPTY)
    private List<SkuVO> skuList;
}
