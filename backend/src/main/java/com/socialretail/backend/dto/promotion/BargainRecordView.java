package com.socialretail.backend.dto.promotion;

import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
public class BargainRecordView {
    private Long bargainRecordId;
    private Long userId;
    private Long productId;
    private Long skuId;
    private BigDecimal currentPrice;
    private LocalDateTime endTime;
    private Integer status;
}
