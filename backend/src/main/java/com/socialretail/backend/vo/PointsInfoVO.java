package com.socialretail.backend.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class PointsInfoVO {
    private Integer pointsBalance;
    private Boolean canUsePoints;
    private Integer maxUsablePoints;
    private Integer usedPoints;
    private BigDecimal deductionAmount;
    private String deductionRule;
    private BigDecimal maxDeductionAmount;
}
