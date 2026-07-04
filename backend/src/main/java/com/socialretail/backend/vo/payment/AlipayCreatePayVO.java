package com.socialretail.backend.vo.payment;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class AlipayCreatePayVO {
    private Long paymentId;
    private String paySn;
    private Long orderId;
    private String orderSn;
    private BigDecimal payAmount;
    private String payPlatform;
    private String payType;

    /**
     * WAP 时为需要在手机浏览器中提交的 HTML form；
     * APP 时为交给支付宝客户端 SDK 的 orderString。
     */
    private String payPayload;
}
