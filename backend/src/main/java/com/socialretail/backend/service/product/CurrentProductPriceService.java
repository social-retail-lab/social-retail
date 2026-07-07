package com.socialretail.backend.service.product;

import com.socialretail.backend.dto.promotion.SeckillProductView;
import com.socialretail.backend.entity.product.Sku;
import com.socialretail.backend.mapper.promotion.SeckillProductMapper;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.Collection;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

@Service
public class CurrentProductPriceService {

    private final SeckillProductMapper seckillProductMapper;

    public CurrentProductPriceService(SeckillProductMapper seckillProductMapper) {
        this.seckillProductMapper = seckillProductMapper;
    }

    public Map<Long, Price> resolve(Collection<Sku> skus) {
        Map<Long, BigDecimal> originalPrices = new LinkedHashMap<>();
        for (Sku sku : skus) {
            if (sku != null && sku.getId() != null) {
                originalPrices.put(sku.getId(), sku.getPrice());
            }
        }
        return resolve(originalPrices);
    }

    public Map<Long, Price> resolve(Map<Long, BigDecimal> originalPrices) {
        Map<Long, Price> result = new LinkedHashMap<>();
        originalPrices.forEach((skuId, price) -> result.put(skuId, new Price(price, price, null)));
        if (originalPrices.isEmpty()) {
            return result;
        }

        List<SeckillProductView> views = seckillProductMapper.selectCurrentViewsBySkuIds(
                originalPrices.keySet().stream().toList(), LocalDateTime.now());
        for (SeckillProductView view : views) {
            BigDecimal originalPrice = originalPrices.get(view.getSkuId());
            BigDecimal seckillPrice = view.getSeckillPrice();
            if (originalPrice == null || seckillPrice == null || seckillPrice.compareTo(originalPrice) >= 0) {
                continue;
            }
            Price existing = result.get(view.getSkuId());
            if (existing != null && (Objects.equals(existing.finalPrice(), originalPrice)
                    || seckillPrice.compareTo(existing.finalPrice()) < 0)) {
                result.put(view.getSkuId(), new Price(originalPrice, seckillPrice,
                        view.getSeckillProductId()));
            }
        }
        return result;
    }

    public Price resolve(Sku sku) {
        if (sku == null || sku.getId() == null) {
            return new Price(null, null, null);
        }
        return resolve(List.of(sku)).get(sku.getId());
    }

    public record Price(BigDecimal originalPrice, BigDecimal finalPrice, Long seckillProductId) {
    }
}
