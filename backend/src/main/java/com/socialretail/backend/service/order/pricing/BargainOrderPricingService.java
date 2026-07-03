package com.socialretail.backend.service.order.pricing;

import com.socialretail.backend.common.exception.BusinessException;
import com.socialretail.backend.dto.promotion.BargainRecordView;
import com.socialretail.backend.mapper.promotion.BargainPricingMapper;
import com.socialretail.backend.vo.CartItemVO;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.Objects;

@Service
public class BargainOrderPricingService {
    private static final BigDecimal ZERO = new BigDecimal("0.00");
    private final BargainPricingMapper mapper;

    public BargainOrderPricingService(BargainPricingMapper mapper) { this.mapper = mapper; }

    public Quote quote(Long userId, Long requestedId, List<CartItemVO> items, boolean autoSelect) {
        if (requestedId != null) return quoteRecord(userId, mapper.selectViewById(requestedId), items, true);
        if (!autoSelect) return Quote.none();
        Quote best = Quote.none();
        for (BargainRecordView record : mapper.selectActiveByUser(userId, LocalDateTime.now())) {
            Quote candidate = quoteRecord(userId, record, items, false);
            if (candidate.applied() && (!best.applied() || candidate.discount().compareTo(best.discount()) > 0)) {
                best = candidate;
            }
        }
        return best;
    }

    private Quote quoteRecord(Long userId, BargainRecordView record, List<CartItemVO> items, boolean strict) {
        if (record == null || !Objects.equals(record.getUserId(), userId)
                || !Integer.valueOf(1).equals(record.getStatus()) || record.getEndTime() == null
                || !record.getEndTime().isAfter(LocalDateTime.now())) {
            if (strict) throw unavailable(record == null ? null : record.getBargainRecordId());
            return Quote.none();
        }
        CartItemVO item = items.stream().filter(i -> Objects.equals(i.getSkuId(), record.getSkuId())
                && Objects.equals(i.getProductId(), record.getProductId())).findFirst().orElse(null);
        if (item == null) {
            if (strict) throw unavailable(record.getBargainRecordId());
            return Quote.none();
        }
        BigDecimal origin = money(item.getPrice());
        BigDecimal current = money(record.getCurrentPrice());
        if (current.compareTo(origin) > 0) {
            if (strict) throw unavailable(record.getBargainRecordId());
            return Quote.none();
        }
        int quantity = item.getQuantity() == null ? 0 : item.getQuantity();
        BigDecimal originAmount = origin.multiply(BigDecimal.valueOf(quantity));
        BigDecimal finalAmount = current.multiply(BigDecimal.valueOf(quantity));
        return new Quote(record.getBargainRecordId(), item.getSkuId(), origin, current,
                originAmount, finalAmount, originAmount.subtract(finalAmount).max(ZERO));
    }

    private BusinessException unavailable(Long id) {
        return new BusinessException(40917, HttpStatus.CONFLICT, "砍价记录不可用或未达到下单条件",
                Map.of("bargainRecordId", id == null ? 0 : id));
    }
    private BigDecimal money(BigDecimal value) { return value == null ? ZERO : value; }
    public record Quote(Long recordId, Long skuId, BigDecimal originPrice, BigDecimal finalPrice,
                        BigDecimal originAmount, BigDecimal finalAmount, BigDecimal discount) {
        static Quote none() { return new Quote(null, null, ZERO, ZERO, ZERO, ZERO, ZERO); }
        public boolean applied() { return recordId != null; }
    }
}
