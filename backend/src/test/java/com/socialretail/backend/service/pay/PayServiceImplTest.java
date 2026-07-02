package com.socialretail.backend.service.pay;

import com.alipay.api.AlipayClient;
import com.alipay.api.internal.util.AlipaySignature;
import com.alipay.api.request.AlipayTradeAppPayRequest;
import com.alipay.api.request.AlipayTradeWapPayRequest;
import com.alipay.api.response.AlipayTradeAppPayResponse;
import com.alipay.api.response.AlipayTradeWapPayResponse;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.socialretail.backend.common.exception.BusinessException;
import com.socialretail.backend.config.AlipayProperties;
import com.socialretail.backend.dto.request.payment.AlipayCreatePayDTO;
import com.socialretail.backend.dto.request.payment.MockPaySuccessDTO;
import com.socialretail.backend.entity.Payment;
import com.socialretail.backend.entity.order.Order;
import com.socialretail.backend.entity.order.OrderItem;
import com.socialretail.backend.mapper.PaymentMapper;
import com.socialretail.backend.mapper.order.OrderMapper;
import com.socialretail.backend.mapper.product.ProductMapper;
import com.socialretail.backend.service.pay.impl.PayServiceImpl;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.security.KeyPair;
import java.security.KeyPairGenerator;
import java.time.LocalDateTime;
import java.util.Base64;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyInt;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class PayServiceImplTest {

    @Mock private PaymentMapper paymentMapper;
    @Mock private OrderMapper orderMapper;
    @Mock private ProductMapper productMapper;
    @Mock private AlipayClient alipayClient;

    private final ObjectMapper objectMapper = new ObjectMapper();
    private AlipayProperties properties;
    private PayServiceImpl service;
    private String privateKey;

    @BeforeEach
    void setUp() throws Exception {
        KeyPairGenerator generator = KeyPairGenerator.getInstance("RSA");
        generator.initialize(2048);
        KeyPair pair = generator.generateKeyPair();
        privateKey = Base64.getEncoder().encodeToString(pair.getPrivate().getEncoded());

        properties = new AlipayProperties();
        properties.setAppId("sandbox-app");
        properties.setPrivateKey(privateKey);
        properties.setAlipayPublicKey(Base64.getEncoder().encodeToString(pair.getPublic().getEncoded()));
        properties.setServerUrl("https://openapi-sandbox.dl.alipaydev.com/gateway.do");
        properties.setNotifyUrl("http://example.test/api/pay/alipay/notify");
        properties.setReturnUrl("http://example.test/payment/result");
        properties.setCharset("UTF-8");
        properties.setSignType("RSA2");
        properties.setFormat("json");
        service = new PayServiceImpl(paymentMapper, orderMapper, productMapper,
                alipayClient, properties, objectMapper);
    }

    @Test
    void alipayCreateUsesMobileWapPaymentByDefault() throws Exception {
        Order order = waitingOrder();
        Payment payment = unpaidPayment();
        when(orderMapper.selectByIdAndUserIdForUpdate(20L, 10L)).thenReturn(order);
        when(paymentMapper.selectLatestByOrderIdForUpdate(20L)).thenReturn(payment);
        AlipayTradeWapPayResponse response = new AlipayTradeWapPayResponse();
        response.setBody("<form id=\"alipaysubmit\"></form>");
        when(alipayClient.pageExecute(any(AlipayTradeWapPayRequest.class))).thenReturn(response);
        AlipayCreatePayDTO dto = new AlipayCreatePayDTO();
        dto.setOrderId(20L);

        var result = service.createAlipayPayment(10L, dto);

        ArgumentCaptor<AlipayTradeWapPayRequest> captor =
                ArgumentCaptor.forClass(AlipayTradeWapPayRequest.class);
        verify(alipayClient).pageExecute(captor.capture());
        JsonNode bizContent = objectMapper.readTree(captor.getValue().getBizContent());
        assertEquals("PAY-20", bizContent.get("out_trade_no").asText());
        assertEquals("39.90", bizContent.get("total_amount").asText());
        assertEquals("QUICK_WAP_WAY", bizContent.get("product_code").asText());
        assertEquals("PAY-20", result.getPaySn());
        assertEquals("WAP", result.getPayType());
        assertEquals("<form id=\"alipaysubmit\"></form>", result.getPayPayload());
    }

    @Test
    void alipayCreateSupportsNativeAppPayment() throws Exception {
        Order order = waitingOrder();
        Payment payment = unpaidPayment();
        when(orderMapper.selectByIdAndUserIdForUpdate(20L, 10L)).thenReturn(order);
        when(paymentMapper.selectLatestByOrderIdForUpdate(20L)).thenReturn(payment);
        AlipayTradeAppPayResponse response = new AlipayTradeAppPayResponse();
        response.setBody("signed-order-string");
        when(alipayClient.sdkExecute(any(AlipayTradeAppPayRequest.class))).thenReturn(response);
        AlipayCreatePayDTO dto = new AlipayCreatePayDTO();
        dto.setOrderId(20L);
        dto.setPayType("app");

        var result = service.createAlipayPayment(10L, dto);

        ArgumentCaptor<AlipayTradeAppPayRequest> captor =
                ArgumentCaptor.forClass(AlipayTradeAppPayRequest.class);
        verify(alipayClient).sdkExecute(captor.capture());
        JsonNode bizContent = objectMapper.readTree(captor.getValue().getBizContent());
        assertEquals("QUICK_MSECURITY_PAY", bizContent.get("product_code").asText());
        assertEquals("APP", result.getPayType());
        assertEquals("signed-order-string", result.getPayPayload());
    }

    @Test
    void mockSuccessMovesOrderWithoutDeductingStockAgain() {
        Order order = waitingOrder();
        when(orderMapper.selectByIdAndUserIdForUpdate(20L, 10L)).thenReturn(order);
        when(paymentMapper.selectLatestByOrderIdForUpdate(20L)).thenReturn(null);
        when(paymentMapper.insert(any())).thenAnswer(invocation -> {
            Payment payment = invocation.getArgument(0);
            payment.setId(6001L);
            return 1;
        });
        when(paymentMapper.updatePlatformAndPaid(eq(6001L), eq(2), any(), any(), any())).thenReturn(1);
        when(orderMapper.updateStatusAfterPay(eq(20L), eq(1), any(), any())).thenReturn(1);
        OrderItem item = new OrderItem();
        item.setProductId(6001L);
        item.setQuantity(2);
        when(orderMapper.selectItemsByOrderId(20L)).thenReturn(List.of(item));
        when(productMapper.incrementSoldCount(6001L, 2)).thenReturn(1);
        when(orderMapper.insertStatusLog(any())).thenReturn(1);
        MockPaySuccessDTO dto = new MockPaySuccessDTO();
        dto.setOrderId(20L);
        dto.setPayAmount(new BigDecimal("39.90"));

        var result = service.mockPaySuccess(10L, dto);

        assertEquals("PAID", result.getPayStatus());
        assertEquals("WAIT_SHIP", result.getOrderStatus());
        verify(productMapper).incrementSoldCount(6001L, 2);
        verify(orderMapper, never()).decrementStock(any(), anyInt());
    }

    @Test
    void callbackIsIdempotentWhenPaymentAlreadyPaid() throws Exception {
        Order order = waitingOrder();
        order.setStatus(1);
        Payment payment = unpaidPayment();
        payment.setStatus(1);
        payment.setThirdTradeNo("TRADE-1");
        when(paymentMapper.selectByPaySn("PAY-20")).thenReturn(payment);
        when(orderMapper.selectByIdForUpdate(20L)).thenReturn(order);
        when(paymentMapper.selectByPaySnForUpdate("PAY-20")).thenReturn(payment);

        Map<String, String> parameters = signedCallback();
        assertTrue(service.handleAlipayNotify(parameters));

        verify(paymentMapper, never()).updatePlatformAndPaid(any(), anyInt(), any(), any(), any());
        verify(orderMapper, never()).updateStatusAfterPay(any(), anyInt(), any(), any());
    }

    @Test
    void mockSuccessRejectsWrongAmount() {
        when(orderMapper.selectByIdAndUserIdForUpdate(20L, 10L)).thenReturn(waitingOrder());
        MockPaySuccessDTO dto = new MockPaySuccessDTO();
        dto.setOrderId(20L);
        dto.setPayAmount(new BigDecimal("19.90"));

        BusinessException exception = assertThrows(
                BusinessException.class, () -> service.mockPaySuccess(10L, dto)
        );
        assertEquals(40925, exception.getCode());
    }

    private Map<String, String> signedCallback() throws Exception {
        Map<String, String> parameters = new LinkedHashMap<>();
        parameters.put("app_id", "sandbox-app");
        parameters.put("out_trade_no", "PAY-20");
        parameters.put("trade_no", "TRADE-1");
        parameters.put("trade_status", "TRADE_SUCCESS");
        parameters.put("total_amount", "39.90");
        parameters.put("gmt_payment", "2026-07-01 17:00:00");
        parameters.put("sign_type", "RSA2");
        String content = AlipaySignature.getSignCheckContentV1(parameters);
        parameters.put("sign", AlipaySignature.rsaSign(content, privateKey, "UTF-8", "RSA2"));
        return parameters;
    }

    private Order waitingOrder() {
        Order order = new Order();
        order.setId(20L);
        order.setOrderSn("ORDER-20");
        order.setUserId(10L);
        order.setPayAmount(new BigDecimal("39.90"));
        order.setStatus(0);
        order.setDeliveryType(1);
        order.setPayExpireTime(LocalDateTime.now().plusMinutes(20));
        return order;
    }

    private Payment unpaidPayment() {
        Payment payment = new Payment();
        payment.setId(6001L);
        payment.setOrderId(20L);
        payment.setPaySn("PAY-20");
        payment.setPayPlatform(1);
        payment.setAmount(new BigDecimal("39.90"));
        payment.setStatus(0);
        return payment;
    }
}
