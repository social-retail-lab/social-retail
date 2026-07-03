package com.socialretail.backend.dto.promotion;

import java.math.BigDecimal;
import java.util.List;

public final class SeckillApiModels {
    private SeckillApiModels() { }

    public record ActivityInfo(Long activityId, String title, String preheatStartTime,
                               String startTime, String endTime, Integer status,
                               String statusText, Boolean canBuy, Long countdownSeconds) { }

    public record ProductItem(Long seckillProductId, Long activityId, Long productId,
                              Long skuId, String productName, String productImage,
                              String skuSpecs, BigDecimal originPrice, BigDecimal seckillPrice,
                              Integer seckillStock, Integer soldCount, Integer remainingStock,
                              Integer limitQuantity, Integer status, String statusText,
                              Boolean canBuy, String buttonText) { }

    public record ProductPage(ActivityInfo activityInfo, List<ProductItem> list, Long total,
                              Long pages, Integer page, Integer pageSize) { }

    public record Qualification(Long seckillProductId, Boolean canBuy, String reason,
                                Integer remainingStock, Integer limitQuantity,
                                Integer alreadyBoughtQuantity) { }
}
