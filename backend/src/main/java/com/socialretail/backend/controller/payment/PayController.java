package com.socialretail.backend.controller.payment;

import com.socialretail.backend.common.result.Result;
import com.socialretail.backend.config.JwtInterceptor;
import com.socialretail.backend.dto.request.payment.AlipayCreatePayDTO;
import com.socialretail.backend.dto.request.payment.MockPayFailDTO;
import com.socialretail.backend.dto.request.payment.MockPaySuccessDTO;
import com.socialretail.backend.service.pay.PayService;
import com.socialretail.backend.vo.payment.AlipayCreatePayVO;
import com.socialretail.backend.vo.payment.MockPayResultVO;
import com.socialretail.backend.vo.payment.PayOrderStatusVO;
import com.socialretail.backend.vo.payment.PaymentDetailVO;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import jakarta.validation.constraints.Positive;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.MediaType;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.LinkedHashMap;
import java.util.Map;

@Validated
@RestController
@RequestMapping("/api/pay")
public class PayController {

    private static final Logger log = LoggerFactory.getLogger(PayController.class);
    private final PayService payService;

    public PayController(PayService payService) {
        this.payService = payService;
    }

    @PostMapping("/alipay/create")
    public Result<AlipayCreatePayVO> createAlipayPayment(
            @RequestAttribute(JwtInterceptor.USER_ID_ATTRIBUTE) Long userId,
            @Valid @RequestBody AlipayCreatePayDTO dto) {
        return Result.success("支付请求创建成功", payService.createAlipayPayment(userId, dto));
    }

    @PostMapping(value = "/alipay/notify",
            consumes = MediaType.APPLICATION_FORM_URLENCODED_VALUE,
            produces = MediaType.TEXT_PLAIN_VALUE)
    public String alipayNotify(HttpServletRequest request) {
        Map<String, String> parameters = new LinkedHashMap<>();
        request.getParameterMap().forEach((name, values) ->
                parameters.put(name, String.join(",", values))
        );
        try {
            return payService.handleAlipayNotify(parameters) ? "success" : "failure";
        } catch (Exception exception) {
            log.error("支付宝异步通知处理失败，outTradeNo={}", parameters.get("out_trade_no"), exception);
            return "failure";
        }
    }

    @GetMapping("/orders/{orderId}/status")
    public Result<PayOrderStatusVO> getOrderPayStatus(
            @RequestAttribute(JwtInterceptor.USER_ID_ATTRIBUTE) Long userId,
            @Positive(message = "订单ID必须大于0") @PathVariable Long orderId) {
        return Result.success(payService.getOrderPayStatus(userId, orderId));
    }

    @PostMapping("/mock/success")
    public Result<MockPayResultVO> mockPaySuccess(
            @RequestAttribute(JwtInterceptor.USER_ID_ATTRIBUTE) Long userId,
            @Valid @RequestBody MockPaySuccessDTO dto) {
        return Result.success("模拟支付成功", payService.mockPaySuccess(userId, dto));
    }

    @PostMapping("/mock/fail")
    public Result<MockPayResultVO> mockPayFail(
            @RequestAttribute(JwtInterceptor.USER_ID_ATTRIBUTE) Long userId,
            @Valid @RequestBody MockPayFailDTO dto) {
        return Result.success("模拟支付失败", payService.mockPayFail(userId, dto));
    }

    @GetMapping("/payments/{paymentId}")
    public Result<PaymentDetailVO> getPaymentDetail(
            @RequestAttribute(JwtInterceptor.USER_ID_ATTRIBUTE) Long userId,
            @Positive(message = "支付流水ID必须大于0") @PathVariable Long paymentId) {
        return Result.success(payService.getPaymentDetail(userId, paymentId));
    }
}
