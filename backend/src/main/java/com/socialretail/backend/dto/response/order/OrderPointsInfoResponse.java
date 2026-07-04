package com.socialretail.backend.dto.response.order;

import java.math.BigDecimal;

public record OrderPointsInfoResponse(Integer usedPoints, BigDecimal deductionAmount,
                                      String deductionRule) { }
