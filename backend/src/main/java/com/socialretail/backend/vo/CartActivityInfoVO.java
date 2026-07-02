package com.socialretail.backend.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CartActivityInfoVO {
    private Long seckillActivityId;
    private Long bargainActivityId;
    private Long groupActivityId;
    private List<Long> promotionIds;
}
