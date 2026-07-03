package com.socialretail.backend.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class PromotionActivityInfoVO {
    private Long seckillProductId;
    private Long bargainRecordId;
    private Long groupId;
    private List<Long> promotionIds;
}
