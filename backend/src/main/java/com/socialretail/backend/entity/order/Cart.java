package com.socialretail.backend.entity.order;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class Cart {
    private Long id;
    private Long userId;
    private Long skuId;
    private Integer quantity;
    private Long distributorProductId;
    private LocalDateTime attributionExpiresAt;
    private String promotionCode;
}
