package com.socialretail.backend.dto.promotion;

import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
public class SeckillProductView {
    private Long seckillProductId;
    private Long activityId;
    private String activityTitle;
    private LocalDateTime startTime;
    private LocalDateTime endTime;
    private Long productId;
    private Long skuId;
    private String productName;
    private String productImage;
    private String skuSpecs;
    private BigDecimal originPrice;
    private BigDecimal seckillPrice;
    private Integer seckillStock;
    private Integer soldCount;
    private Integer limitQuantity;
    private Integer productStatus;
    private Integer productAuditStatus;
    private Integer seckillProductStatus;
}
