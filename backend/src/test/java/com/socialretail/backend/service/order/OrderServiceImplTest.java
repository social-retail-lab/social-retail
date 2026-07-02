package com.socialretail.backend.service.order;

import com.socialretail.backend.common.exception.BusinessException;
import com.socialretail.backend.config.OrderTimeoutProperties;
import com.socialretail.backend.dto.request.order.OrderCancelRequest;
import com.socialretail.backend.dto.request.order.OrderPreviewRequest;
import com.socialretail.backend.dto.request.order.OrderQueryRequest;
import com.socialretail.backend.dto.request.order.OrderSubmitRequest;
import com.socialretail.backend.entity.address.Address;
import com.socialretail.backend.entity.order.Order;
import com.socialretail.backend.entity.order.OrderItem;
import com.socialretail.backend.mapper.address.AddressMapper;
import com.socialretail.backend.mapper.order.CartMapper;
import com.socialretail.backend.mapper.order.OrderMapper;
import com.socialretail.backend.service.order.impl.OrderServiceImpl;
import com.socialretail.backend.service.order.pricing.DefaultOrderPricingService;
import com.socialretail.backend.vo.CartItemVO;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyInt;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class OrderServiceImplTest {

    @Mock private OrderMapper orderMapper;
    @Mock private CartMapper cartMapper;
    @Mock private AddressMapper addressMapper;

    private OrderServiceImpl orderService;

    @BeforeEach
    void setUp() {
        OrderTimeoutProperties timeoutProperties = new OrderTimeoutProperties();
        timeoutProperties.setTimeoutMinutes(30);
        orderService = new OrderServiceImpl(
                orderMapper, cartMapper, addressMapper,
                new DefaultOrderPricingService(), timeoutProperties
        );
    }

    @Test
    void previewCalculatesAmountAndUsesOwnedAddress() {
        when(cartMapper.selectCartItemsByIds(10001L, List.of(7L, 8L))).thenReturn(List.of(
                cartItem(7L, 8001L, 2001L, 2, "39.90"),
                cartItem(8L, 8002L, 2001L, 1, "10.00")
        ));
        when(addressMapper.selectByIdAndUserId(501L, 10001L)).thenReturn(address(501L));
        OrderPreviewRequest request = previewRequest(List.of(7L, 8L), 501L);

        var result = orderService.preview(10001L, request);

        assertEquals(new BigDecimal("89.80"), result.getTotalAmount());
        assertEquals(result.getTotalAmount(), result.getPayAmount());
        assertEquals(2, result.getItemList().size());
        assertEquals("138****8000", result.getAddressInfo().getPhone());
        assertEquals(new BigDecimal("0.00"), result.getPromotionDiscount());
        assertEquals(List.of(), result.getAvailablePromotions());
    }

    @Test
    void previewRejectsCrossMerchantCart() {
        when(cartMapper.selectCartItemsByIds(10001L, List.of(7L, 8L))).thenReturn(List.of(
                cartItem(7L, 8001L, 2001L, 1, "39.90"),
                cartItem(8L, 8002L, 2002L, 1, "10.00")
        ));

        BusinessException exception = assertThrows(
                BusinessException.class,
                () -> orderService.preview(10001L, previewRequest(List.of(7L, 8L), 501L))
        );

        assertEquals(40912, exception.getCode());
        verify(addressMapper, never()).selectByIdAndUserId(any(), any());
    }

    @Test
    void submitCreatesSnapshotsDeductsStockDeletesCartAndWritesLog() {
        CartItemVO cartItem = cartItem(7L, 8001L, 2001L, 2, "39.90");
        when(cartMapper.selectCartItemsByIds(10001L, List.of(7L))).thenReturn(List.of(cartItem));
        when(addressMapper.selectByIdAndUserId(501L, 10001L)).thenReturn(address(501L));
        when(orderMapper.insertOrder(any())).thenAnswer(invocation -> {
            Order order = invocation.getArgument(0);
            order.setId(9001L);
            return 1;
        });
        when(orderMapper.insertOrderItem(any())).thenReturn(1);
        when(orderMapper.decrementStock(8001L, 2)).thenReturn(1);
        when(cartMapper.deleteByIdsAndUserId(10001L, List.of(7L))).thenReturn(1);
        when(orderMapper.insertStatusLog(any())).thenReturn(1);

        var result = orderService.submit(10001L, submitRequest(List.of(7L), 501L));

        assertEquals(9001L, result.getOrderId());
        assertEquals(OrderServiceImpl.WAIT_PAY, result.getStatus());
        assertEquals(new BigDecimal("79.80"), result.getPayAmount());
        assertNotNull(result.getOrderSn());
        assertNotNull(result.getExpireTime());
        ArgumentCaptor<OrderItem> itemCaptor = ArgumentCaptor.forClass(OrderItem.class);
        verify(orderMapper).insertOrderItem(itemCaptor.capture());
        assertEquals("测试商品", itemCaptor.getValue().getProductName());
        assertEquals(new BigDecimal("79.80"), itemCaptor.getValue().getItemFinalAmount());
        verify(orderMapper).decrementStock(8001L, 2);
        verify(cartMapper).deleteByIdsAndUserId(10001L, List.of(7L));
    }

    @Test
    void conditionalStockDeductionFailureReturns40911() {
        when(cartMapper.selectCartItemsByIds(10001L, List.of(7L)))
                .thenReturn(List.of(cartItem(7L, 8001L, 2001L, 2, "39.90")));
        when(addressMapper.selectByIdAndUserId(501L, 10001L)).thenReturn(address(501L));
        when(orderMapper.insertOrder(any())).thenAnswer(invocation -> {
            ((Order) invocation.getArgument(0)).setId(9001L);
            return 1;
        });
        when(orderMapper.insertOrderItem(any())).thenReturn(1);
        when(orderMapper.decrementStock(8001L, 2)).thenReturn(0);

        BusinessException exception = assertThrows(
                BusinessException.class,
                () -> orderService.submit(10001L, submitRequest(List.of(7L), 501L))
        );

        assertEquals(40911, exception.getCode());
        verify(cartMapper, never()).deleteByIdsAndUserId(any(), any());
    }

    @Test
    void cancelWaitPayOrderRestoresStockAndWritesLog() {
        Order order = order(9001L, OrderServiceImpl.WAIT_PAY);
        OrderItem item = orderItem(8001L, 2);
        when(orderMapper.selectByIdAndUserId(9001L, 10001L)).thenReturn(order);
        when(orderMapper.cancelWaitPayOrder(9001L, 10001L)).thenReturn(1);
        when(orderMapper.selectItemsByOrderId(9001L)).thenReturn(List.of(item));
        when(orderMapper.incrementStock(8001L, 2)).thenReturn(1);
        when(orderMapper.insertStatusLog(any())).thenReturn(1);
        OrderCancelRequest request = new OrderCancelRequest();
        request.setReason("不想买了");

        var result = orderService.cancel(10001L, 9001L, request);

        assertEquals(OrderServiceImpl.CANCELLED, result.getStatus());
        verify(orderMapper).incrementStock(8001L, 2);
        verify(orderMapper).insertStatusLog(any());
    }

    @Test
    void completedOrderCannotBeCancelled() {
        when(orderMapper.selectByIdAndUserId(9001L, 10001L))
                .thenReturn(order(9001L, OrderServiceImpl.COMPLETED));

        BusinessException exception = assertThrows(
                BusinessException.class,
                () -> orderService.cancel(10001L, 9001L, null)
        );

        assertEquals(40921, exception.getCode());
        verify(orderMapper, never()).cancelWaitPayOrder(any(), any());
    }

    @Test
    void confirmDeliveringOrderCompletesAndWritesLog() {
        when(orderMapper.selectByIdAndUserId(9001L, 10001L))
                .thenReturn(order(9001L, OrderServiceImpl.DELIVERING));
        when(orderMapper.completeOrder(9001L, 10001L)).thenReturn(1);
        when(orderMapper.insertStatusLog(any())).thenReturn(1);

        var result = orderService.confirm(10001L, 9001L);

        assertEquals(OrderServiceImpl.COMPLETED, result.getStatus());
        verify(orderMapper).completeOrder(9001L, 10001L);
    }

    @Test
    void listSupportsStatusPaginationAndReturnsAtMostTwoItems() {
        Order order = order(9001L, OrderServiceImpl.WAIT_PAY);
        when(orderMapper.countOrdersByUserId(10001L, OrderServiceImpl.WAIT_PAY)).thenReturn(11L);
        when(orderMapper.selectOrdersByUserId(10001L, OrderServiceImpl.WAIT_PAY, 0, 10))
                .thenReturn(List.of(order));
        when(orderMapper.selectItemsByOrderId(9001L)).thenReturn(List.of(
                orderItem(8001L, 1), orderItem(8002L, 1), orderItem(8003L, 1)
        ));
        OrderQueryRequest request = new OrderQueryRequest();
        request.setStatus(OrderServiceImpl.WAIT_PAY);

        var result = orderService.list(10001L, request);

        assertEquals(11L, result.getTotal());
        assertEquals(2, result.getPages());
        assertEquals(2, result.getList().get(0).getItemList().size());
    }

    private OrderPreviewRequest previewRequest(List<Long> ids, Long addressId) {
        OrderPreviewRequest request = new OrderPreviewRequest();
        request.setCartItemIds(ids);
        request.setAddressId(addressId);
        request.setDeliveryType(1);
        return request;
    }

    private OrderSubmitRequest submitRequest(List<Long> ids, Long addressId) {
        OrderSubmitRequest request = new OrderSubmitRequest();
        request.setCartItemIds(ids);
        request.setAddressId(addressId);
        request.setDeliveryType(1);
        return request;
    }

    private CartItemVO cartItem(Long cartId, Long skuId, Long merchantId, int quantity, String price) {
        CartItemVO item = new CartItemVO();
        item.setCartId(cartId);
        item.setSkuId(skuId);
        item.setProductId(6001L);
        item.setProductName("测试商品");
        item.setProductImage("image.jpg");
        item.setSkuSpec("{\"规格\":\"标准\"}");
        item.setPrice(new BigDecimal(price));
        item.setQuantity(quantity);
        item.setStock(100);
        item.setMerchantId(merchantId);
        item.setProductStatus(1);
        item.setProductAuditStatus(1);
        return item;
    }

    private Address address(Long id) {
        Address address = new Address();
        address.setId(id);
        address.setUserId(10001L);
        address.setConsignee("张三");
        address.setPhone("13800138000");
        address.setProvince("北京市");
        address.setCity("北京市");
        address.setDistrict("朝阳区");
        address.setDetailedAddress("测试路1号");
        return address;
    }

    private Order order(Long id, int status) {
        Order order = new Order();
        order.setId(id);
        order.setOrderSn("ORD202607010001");
        order.setUserId(10001L);
        order.setMerchantId(2001L);
        order.setStatus(status);
        order.setDeliveryType(1);
        order.setTotalAmount(new BigDecimal("39.90"));
        order.setPayAmount(new BigDecimal("39.90"));
        order.setCreateTime(LocalDateTime.now());
        return order;
    }

    private OrderItem orderItem(Long skuId, int quantity) {
        OrderItem item = new OrderItem();
        item.setId(skuId + 1000);
        item.setSkuId(skuId);
        item.setProductId(6001L);
        item.setProductName("测试商品");
        item.setOriginPrice(new BigDecimal("39.90"));
        item.setFinalPrice(new BigDecimal("39.90"));
        item.setQuantity(quantity);
        item.setItemFinalAmount(new BigDecimal("39.90").multiply(BigDecimal.valueOf(quantity)));
        return item;
    }
}
