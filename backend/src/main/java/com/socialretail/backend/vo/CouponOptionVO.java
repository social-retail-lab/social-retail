package com.socialretail.backend.vo;

import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.math.BigDecimal;

@Data
@NoArgsConstructor
@AllArgsConstructor
@JsonInclude(JsonInclude.Include.NON_NULL)
public class CouponOptionVO {
    private Long couponUserId;
    private Long couponId;
    private Long merchantId;
    private String merchantName;
    private String title;
    private String source;
    private String sourceText;
    private BigDecimal minConsume;
    private BigDecimal discountAmount;
    private Boolean selected;
    private Boolean autoSelected;
    private String invalidReason;
}
