package com.socialretail.backend.service.pay.impl;

import com.alipay.api.AlipayClient;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.socialretail.backend.common.OrderStatus;
import com.socialretail.backend.common.exception.BusinessException;
import com.socialretail.backend.config.AlipayProperties;
import com.socialretail.backend.dto.request.payment.MockPaySuccessDTO;
import com.socialretail.backend.entity.order.Order;
import com.socialretail.backend.entity.order.Payment;
import com.socialretail.backend.entity.order.PickupPoint;
import com.socialretail.backend.mapper.order.OrderMapper;
import com.socialretail.backend.mapper.order.PaymentMapper;
import com.socialretail.backend.mapper.product.ProductMapper;
import com.socialretail.backend.service.order.OrderPointsService;
import com.socialretail.backend.service.order.OrderRewardService;
import com.socialretail.backend.service.social.CommissionService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class PayServiceImplPickupTest {
    @Mock private PaymentMapper paymentMapper;
    @Mock private OrderMapper orderMapper;
    @Mock private ProductMapper productMapper;
    @Mock private AlipayClient alipayClient;
    @Mock private OrderPointsService orderPointsService;
    @Mock private OrderRewardService orderRewardService;
    @Mock private CommissionService commissionService;

    private PayServiceImpl service;

    @BeforeEach
    void setUp() {
        service = new PayServiceImpl(paymentMapper, orderMapper, productMapper, alipayClient,
                new AlipayProperties(), new ObjectMapper(), orderPointsService,
                orderRewardService, commissionService);
    }

    @Test
    void pickupOrderGeneratesSixDigitCodeAfterSuccessfulPayment() {
        Order order = payableOrder(OrderStatus.PICKUP, 3001L);
        Payment payment = unpaidPayment(order);
        PickupPoint point = availablePoint(3001L, order.getMerchantId());
        stubSuccessfulPayment(order, payment);
        when(orderMapper.selectPickupPointById(3001L)).thenReturn(point);
        when(orderMapper.updatePickupCodeIfAbsent(eq(order.getId()), anyString(), any()))
                .thenReturn(1);

        var result = service.mockPaySuccess(order.getUserId(), request(order));

        assertEquals(OrderStatus.PICKUP, result.getDeliveryType());
        assertEquals(3001L, result.getPickupPointId());
        assertTrue(result.getPickupCode().matches("\\d{6}"));
        assertEquals(result.getPickupCode(), order.getPickupCode());
        assertEquals("PAID", result.getPayStatus());
        assertEquals("WAIT_ACCEPT", result.getOrderStatus());
    }

    @Test
    void deliveryOrderDoesNotGeneratePickupCode() {
        Order order = payableOrder(OrderStatus.DELIVERY, null);
        Payment payment = unpaidPayment(order);
        stubSuccessfulPayment(order, payment);

        var result = service.mockPaySuccess(order.getUserId(), request(order));

        assertEquals(OrderStatus.DELIVERY, result.getDeliveryType());
        assertNull(result.getPickupPointId());
        assertNull(result.getPickupCode());
        verify(orderMapper, never()).updatePickupCodeIfAbsent(anyLong(), anyString(), any());
    }

    @Test
    void unavailablePickupPointReturnsDocumentedConflict() {
        Order order = payableOrder(OrderStatus.PICKUP, 3001L);
        Payment payment = unpaidPayment(order);
        when(orderMapper.selectByIdAndUserIdForUpdate(order.getId(), order.getUserId()))
                .thenReturn(order);
        when(paymentMapper.selectLatestByOrderIdForUpdate(order.getId())).thenReturn(payment);
        when(orderMapper.selectPickupPointById(3001L)).thenReturn(null);

        BusinessException exception = assertThrows(BusinessException.class,
                () -> service.mockPaySuccess(order.getUserId(), request(order)));

        assertEquals(40931, exception.getCode());
        assertEquals(409, exception.getHttpStatus().value());
        verify(paymentMapper, never()).updatePlatformAndPaid(anyLong(), any(), anyString(), any(), any());
    }

    @Test
    void repeatedSuccessfulPaymentReturnsExistingPickupCodeWithoutRegeneration() {
        Order order = payableOrder(OrderStatus.PICKUP, 3001L);
        order.setStatus(OrderStatus.WAIT_ACCEPT);
        order.setPickupCode("839204");
        order.setPayTime(LocalDateTime.now().minusMinutes(1));
        Payment payment = unpaidPayment(order);
        payment.setStatus(1);
        payment.setPayTime(order.getPayTime());
        when(orderMapper.selectByIdAndUserIdForUpdate(order.getId(), order.getUserId()))
                .thenReturn(order);
        when(paymentMapper.selectLatestByOrderIdForUpdate(order.getId())).thenReturn(payment);

        var result = service.mockPaySuccess(order.getUserId(), request(order));

        assertEquals("839204", result.getPickupCode());
        assertEquals("WAIT_ACCEPT", result.getOrderStatus());
        verify(orderMapper, never()).updatePickupCodeIfAbsent(anyLong(), anyString(), any());
        verify(paymentMapper, never()).updatePlatformAndPaid(anyLong(), any(), anyString(), any(), any());
    }

    private void stubSuccessfulPayment(Order order, Payment payment) {
        when(orderMapper.selectByIdAndUserIdForUpdate(order.getId(), order.getUserId()))
                .thenReturn(order);
        when(paymentMapper.selectLatestByOrderIdForUpdate(order.getId())).thenReturn(payment);
        when(paymentMapper.updatePlatformAndPaid(eq(payment.getId()), eq(2), anyString(), any(), any()))
                .thenReturn(1);
        when(orderMapper.updateStatusAfterPay(eq(order.getId()), eq(OrderStatus.WAIT_ACCEPT), any(), any()))
                .thenReturn(1);
        when(orderMapper.selectItemsByOrderId(order.getId())).thenReturn(List.of());
        when(orderMapper.insertStatusLog(any())).thenReturn(1);
    }

    private Order payableOrder(int deliveryType, Long pickupPointId) {
        Order order = new Order();
        order.setId(5001L);
        order.setOrderSn("202606260001");
        order.setUserId(1001L);
        order.setMerchantId(2001L);
        order.setDeliveryType(deliveryType);
        order.setPickupPointId(pickupPointId);
        order.setPayAmount(new BigDecimal("184.80"));
        order.setStatus(OrderStatus.WAIT_PAY);
        order.setPayExpireTime(LocalDateTime.now().plusMinutes(10));
        return order;
    }

    private Payment unpaidPayment(Order order) {
        Payment payment = new Payment();
        payment.setId(6001L);
        payment.setOrderId(order.getId());
        payment.setPaySn("MOCKPAY202606260001");
        payment.setAmount(order.getPayAmount());
        payment.setStatus(0);
        return payment;
    }

    private PickupPoint availablePoint(Long id, Long merchantId) {
        PickupPoint point = new PickupPoint();
        point.setId(id);
        point.setMerchantId(merchantId);
        point.setStatus(1);
        point.setAuditStatus(1);
        return point;
    }

    private MockPaySuccessDTO request(Order order) {
        MockPaySuccessDTO request = new MockPaySuccessDTO();
        request.setOrderId(order.getId());
        request.setPayAmount(order.getPayAmount());
        return request;
    }
}
