package com.socialretail.backend.vo;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

import java.math.BigDecimal;

@Data
public class CartItemVO {
    private Long cartId;
    private Long skuId;
    private Long productId;
    private String productName;
    private String skuSpec;
    private String productImage;
    private BigDecimal price;
    private Integer quantity;
    private Integer stock;
    private Boolean selected;
    @JsonProperty("isValid")
    private Boolean isValid;
    private String invalidReason;
    private Long merchantId;
    private String merchantName;
    private BigDecimal itemAmount;

    @JsonIgnore
    private Integer productStatus;
    @JsonIgnore
    private Integer productAuditStatus;
}
