package com.socialretail.backend.dto.promotion;

import lombok.Data;
import java.math.BigDecimal;

@Data
public class PromotionCandidate {
    private Long promotionId;
    private String title;
    private BigDecimal minAmount;
    private BigDecimal discountAmount;
}
