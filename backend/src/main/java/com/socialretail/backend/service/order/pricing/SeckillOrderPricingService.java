package com.socialretail.backend.service.order.pricing;

import com.socialretail.backend.common.exception.BusinessException;
import com.socialretail.backend.dto.promotion.SeckillProductView;
import com.socialretail.backend.mapper.promotion.SeckillProductMapper;
import com.socialretail.backend.vo.CartItemVO;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.Objects;

@Service
public class SeckillOrderPricingService {
    private static final BigDecimal ZERO = new BigDecimal("0.00");
    private final SeckillProductMapper productMapper;
    private final StringRedisTemplate redisTemplate;

    public SeckillOrderPricingService(SeckillProductMapper productMapper,
                                      StringRedisTemplate redisTemplate) {
        this.productMapper = productMapper;
        this.redisTemplate = redisTemplate;
    }

    public Quote quote(Long userId, Long seckillProductId, List<CartItemVO> items) {
        if (seckillProductId == null) return Quote.none();
        SeckillProductView view = productMapper.selectViewById(seckillProductId);
        if (view == null) throw unavailable(seckillProductId, "秒杀商品不存在");

        CartItemVO item = items.stream()
                .filter(i -> Objects.equals(i.getSkuId(), view.getSkuId())
                        && Objects.equals(i.getProductId(), view.getProductId()))
                .findFirst().orElseThrow(() -> unavailable(seckillProductId, "秒杀商品与结算商品不匹配"));
        LocalDateTime now = LocalDateTime.now();
        if (view.getStartTime() == null || view.getEndTime() == null
                || now.isBefore(view.getStartTime()) || !now.isBefore(view.getEndTime())
                || !Integer.valueOf(1).equals(view.getSeckillProductStatus())
                || !Integer.valueOf(1).equals(view.getProductStatus())
                || !Integer.valueOf(1).equals(view.getProductAuditStatus())) {
            throw unavailable(seckillProductId, "秒杀活动已结束或不可用");
        }
        int quantity = item.getQuantity() == null ? 0 : item.getQuantity();
        int remaining = Math.max(0, value(view.getSeckillStock()) - value(view.getSoldCount()));
        if (quantity <= 0 || quantity > remaining) {
            throw new BusinessException(40912, HttpStatus.CONFLICT, "库存不足",
                    Map.of("skuId", view.getSkuId(), "availableStock", remaining));
        }
        int bought = productMapper.sumBoughtQuantity(userId, seckillProductId, view.getSkuId());
        int limit = view.getLimitQuantity() == null || view.getLimitQuantity() <= 0
                ? 1 : view.getLimitQuantity();
        if (bought + quantity > limit) {
            throw unavailable(seckillProductId, "已超过秒杀限购数量");
        }
        BigDecimal originPrice = money(item.getPrice());
        BigDecimal finalPrice = money(view.getSeckillPrice());
        if (finalPrice.compareTo(originPrice) > 0) {
            throw unavailable(seckillProductId, "秒杀价格配置无效");
        }
        BigDecimal originAmount = originPrice.multiply(BigDecimal.valueOf(quantity));
        BigDecimal finalAmount = finalPrice.multiply(BigDecimal.valueOf(quantity));
        BigDecimal discount = originAmount.subtract(finalAmount).max(ZERO);
        return new Quote(seckillProductId, view.getActivityId(), view.getSkuId(), quantity,
                originPrice, finalPrice, originAmount, finalAmount, discount);
    }

    public Quote quoteBest(Long userId, List<CartItemVO> items) {
        Quote best = Quote.none();
        for (CartItemVO item : items) {
            SeckillProductView view = productMapper.selectCurrentViewBySku(item.getSkuId(), LocalDateTime.now());
            if (view == null) continue;
            try {
                Quote candidate = quote(userId, view.getSeckillProductId(), List.of(item));
                if (!best.applied() || candidate.discount().compareTo(best.discount()) > 0) best = candidate;
            } catch (BusinessException ignored) {
                // 自动匹配场景下，无资格或已售罄时按普通商品结算。
            }
        }
        return best;
    }

    public void consume(Quote quote) {
        if (!quote.applied()) return;
        if (productMapper.consumeStock(quote.seckillProductId(), quote.quantity()) != 1) {
            throw new BusinessException(40912, HttpStatus.CONFLICT, "库存不足",
                    Map.of("skuId", quote.skuId(), "availableStock", 0));
        }
        evictStock(quote.activityId(), quote.skuId());
    }

    public void release(Long seckillProductId, Integer quantity) {
        if (seckillProductId == null || quantity == null || quantity <= 0) return;
        SeckillProductView view = productMapper.selectViewById(seckillProductId);
        if (view != null && productMapper.releaseStock(seckillProductId, quantity) == 1) {
            evictStock(view.getActivityId(), view.getSkuId());
        }
    }

    private void evictStock(Long activityId, Long skuId) {
        try {
            redisTemplate.delete("seckill:stock:" + activityId + ":" + skuId);
        } catch (RuntimeException ignored) {
            // Redis 不可用时以数据库库存为准，不影响订单事务。
        }
    }

    private BusinessException unavailable(Long id, String message) {
        return new BusinessException(40911, HttpStatus.CONFLICT, message,
                Map.of("seckillProductId", id));
    }

    private int value(Integer number) { return number == null ? 0 : number; }
    private BigDecimal money(BigDecimal amount) { return amount == null ? ZERO : amount; }

    public record Quote(Long seckillProductId, Long activityId, Long skuId, Integer quantity,
                        BigDecimal originPrice, BigDecimal finalPrice,
                        BigDecimal originAmount, BigDecimal finalAmount, BigDecimal discount) {
        static Quote none() {
            return new Quote(null, null, null, 0, ZERO, ZERO, ZERO, ZERO, ZERO);
        }
        public boolean applied() { return seckillProductId != null; }
    }
}
