package com.socialretail.backend.vo;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import com.fasterxml.jackson.annotation.JsonFormat;

@Data
public class CartItemVO {
    private Long cartId;
    private Long skuId;
    private Long productId;
    private String productName;
    private String skuSpec;
    private String productImage;
    private BigDecimal price;
    private BigDecimal originalPrice;
    private Integer quantity;
    private Integer stock;
    private Boolean selected;
    @JsonProperty("isValid")
    private Boolean isValid;
    private String invalidReason;
    private Long merchantId;
    private String merchantName;
    private BigDecimal itemAmount;
    private Long distributorProductId;
    private String promotionCode;
    private BigDecimal commissionRate;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime promotionExpiresAt;

    @JsonIgnore
    private Integer productStatus;
    @JsonIgnore
    private Integer productAuditStatus;
}
