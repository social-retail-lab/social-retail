package com.socialretail.backend.vo;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CartCheckoutItemVO {
    private Long cartItemId;
    private Long skuId;
    private Long productId;
    private String productName;
    private String productImage;
    private String skuSpec;
    private BigDecimal originalPrice;
    private BigDecimal salePrice;
    private Integer quantity;
    private Integer stock;
    private BigDecimal itemOriginalAmount;
    private BigDecimal itemPayableAmount;
    private String activityType;
    private BigDecimal activityDiscount;
    @JsonProperty("isValid")
    private Boolean isValid;
    private String invalidReason;
}
