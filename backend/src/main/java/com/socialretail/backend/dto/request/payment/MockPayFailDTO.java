package com.socialretail.backend.dto.request.payment;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class MockPayFailDTO {
    @NotNull(message = "订单ID不能为空")
    @Positive(message = "订单ID必须大于0")
    private Long orderId;

    @Size(max = 255, message = "失败原因不能超过255个字符")
    private String failReason;
}
