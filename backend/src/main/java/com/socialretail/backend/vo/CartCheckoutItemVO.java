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
    private String skuSpecs;
    private BigDecimal originPrice;
    private BigDecimal finalPrice;
    private Integer quantity;
    private Integer stock;
    private BigDecimal itemOriginAmount;
    private BigDecimal itemFinalAmount;
    private String promotionType;
    private BigDecimal activityDiscount;
    @JsonProperty("isValid")
    private Boolean isValid;
    private String invalidReason;
}
