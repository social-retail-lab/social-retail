package com.socialretail.backend.service.order.pricing;

import com.socialretail.backend.common.exception.BusinessException;
import com.socialretail.backend.dto.promotion.PromotionCandidate;
import com.socialretail.backend.mapper.promotion.PromotionPricingMapper;
import com.socialretail.backend.vo.PromotionOptionVO;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@Service
public class PromotionPricingService {
    private static final BigDecimal ZERO = new BigDecimal("0.00");
    private final PromotionPricingMapper mapper;

    public PromotionPricingService(PromotionPricingMapper mapper) {
        this.mapper = mapper;
    }

    public Pricing resolve(Long merchantId, BigDecimal amount, List<Long> requestedIds, boolean autoSelect) {
        List<PromotionCandidate> candidates = mapper.selectAvailable(merchantId, amount, LocalDateTime.now());
        PromotionCandidate selected = null;
        if (requestedIds != null && !requestedIds.isEmpty()) {
            selected = candidates.stream().filter(c -> requestedIds.contains(c.getPromotionId()))
                    .findFirst().orElseThrow(() -> new BusinessException(40916, HttpStatus.CONFLICT,
                            "促销活动不可用或不满足使用条件", Map.of("promotionIds", requestedIds)));
        } else if (autoSelect && !candidates.isEmpty()) {
            selected = candidates.get(0);
        }
        PromotionCandidate finalSelected = selected;
        List<Object> available = candidates.stream()
                .filter(c -> finalSelected == null || !c.getPromotionId().equals(finalSelected.getPromotionId()))
                .map(c -> (Object) new PromotionOptionVO(c.getPromotionId(), c.getTitle(), c.getMinAmount(),
                        c.getDiscountAmount(), false)).toList();
        BigDecimal discount = selected == null ? ZERO : selected.getDiscountAmount().min(amount);
        return new Pricing(selected == null ? null : selected.getPromotionId(),
                discount, available,
                selected == null ? List.of() : List.of(selected.getPromotionId()));
    }

    public record Pricing(Long promotionId, BigDecimal discount,
                          List<Object> available, List<Long> appliedIds) { }
}
