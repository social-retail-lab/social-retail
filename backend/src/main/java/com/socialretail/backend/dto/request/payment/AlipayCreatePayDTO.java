package com.socialretail.backend.dto.request.payment;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Positive;
import lombok.Data;

@Data
public class AlipayCreatePayDTO {
    @NotNull(message = "订单ID不能为空")
    @Positive(message = "订单ID必须大于0")
    private Long orderId;

    /**
     * WAP：手机浏览器/H5；APP：Android/iOS 原生应用。
     */
    @Pattern(regexp = "(?i)WAP|APP", message = "payType 只支持 WAP 或 APP")
    private String payType = "WAP";
}
