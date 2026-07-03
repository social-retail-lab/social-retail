package com.socialretail.backend.dto.request.order;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.Data;

import java.util.List;

@Data
public class OrderPreviewRequest {
    @NotEmpty(message = "请选择要下单的商品")
    private List<@NotNull @Positive Long> cartItemIds;

    @Positive(message = "地址ID必须大于0")
    private Long addressId;

    @Positive(message = "自提点ID必须大于0")
    private Long pickupPointId;

    @Min(value = 1, message = "配送方式仅支持1或2")
    @Max(value = 2, message = "配送方式仅支持1或2")
    private Integer deliveryType = 1;

    @Positive(message = "优惠券领取记录ID必须大于0")
    private Long couponUserId;

    private Boolean usePoints = false;

    @Positive(message = "使用积分必须大于0")
    private Integer usePointsAmount;

    @jakarta.validation.Valid
    private OrderActivityContextRequest activityContext;

    @jakarta.validation.constraints.Size(max = 500, message = "订单备注不能超过500个字符")
    private String remark;
}
