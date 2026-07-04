package com.socialretail.backend.vo;

import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@NoArgsConstructor
@JsonInclude(JsonInclude.Include.NON_NULL)
public class CartPromotionDetailVO {
    private String type;
    private String title;
    private BigDecimal discount;
    private Integer usedPoints;

    public CartPromotionDetailVO(String type, String title, BigDecimal discount) {
        this(type, title, discount, null);
    }

    public CartPromotionDetailVO(String type, String title, BigDecimal discount, Integer usedPoints) {
        this.type = type;
        this.title = title;
        this.discount = discount;
        this.usedPoints = usedPoints;
    }
}
