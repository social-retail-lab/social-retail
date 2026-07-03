package com.socialretail.backend.dto.response.order;

import lombok.Data;
import com.fasterxml.jackson.annotation.JsonInclude;

import java.math.BigDecimal;

@Data
@JsonInclude(JsonInclude.Include.NON_NULL)
public class OrderItemResponse {
    private Long cartItemId;
    private Long orderItemId;
    private Long skuId;
    private Long productId;
    private String productName;
    private String productImage;
    private String skuSpecs;
    private BigDecimal originPrice;
    private BigDecimal finalPrice;
    private Integer quantity;
    private BigDecimal itemAmount;
    private BigDecimal itemOriginAmount;
    private BigDecimal itemFinalAmount;
    private String promotionType;
}
