package com.socialretail.backend.service.order;

import com.socialretail.backend.config.OrderTimeoutProperties;
import com.socialretail.backend.entity.order.OrderItem;
import com.socialretail.backend.entity.order.OrderStatusLog;
import com.socialretail.backend.mapper.order.OrderMapper;
import com.socialretail.backend.service.order.impl.OrderTimeoutServiceImpl;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class OrderTimeoutServiceImplTest {

    @Mock private OrderMapper orderMapper;

    private OrderTimeoutServiceImpl timeoutService;

    @BeforeEach
    void setUp() {
        OrderTimeoutProperties properties = new OrderTimeoutProperties();
        properties.setBatchSize(100);
        timeoutService = new OrderTimeoutServiceImpl(orderMapper, properties);
    }

    @Test
    void expiredWaitPayOrderIsCancelledAndStockIsRestored() {
        when(orderMapper.selectExpiredWaitPayOrderIds(100)).thenReturn(List.of(9001L));
        when(orderMapper.expireWaitPayOrder(9001L)).thenReturn(1);
        when(orderMapper.selectItemsByOrderId(9001L)).thenReturn(List.of(item(8001L, 2)));
        when(orderMapper.incrementStock(8001L, 2)).thenReturn(1);
        when(orderMapper.insertStatusLog(any())).thenReturn(1);

        int count = timeoutService.cancelExpiredOrders();

        assertEquals(1, count);
        verify(orderMapper).incrementStock(8001L, 2);
        ArgumentCaptor<OrderStatusLog> logCaptor = ArgumentCaptor.forClass(OrderStatusLog.class);
        verify(orderMapper).insertStatusLog(logCaptor.capture());
        assertEquals("SYSTEM", logCaptor.getValue().getOperatorType());
        assertEquals("支付超时自动取消", logCaptor.getValue().getRemark());
    }

    @Test
    void orderClaimedByAnotherExecutorDoesNotRestoreStockTwice() {
        when(orderMapper.selectExpiredWaitPayOrderIds(100)).thenReturn(List.of(9001L));
        when(orderMapper.expireWaitPayOrder(9001L)).thenReturn(0);

        int count = timeoutService.cancelExpiredOrders();

        assertEquals(0, count);
        verify(orderMapper, never()).selectItemsByOrderId(9001L);
        verify(orderMapper, never()).incrementStock(any(), any());
        verify(orderMapper, never()).insertStatusLog(any());
    }

    @Test
    void noExpiredOrdersPerformsNoWrites() {
        when(orderMapper.selectExpiredWaitPayOrderIds(100)).thenReturn(List.of());

        assertEquals(0, timeoutService.cancelExpiredOrders());

        verify(orderMapper, never()).expireWaitPayOrder(any());
    }

    private OrderItem item(Long skuId, int quantity) {
        OrderItem item = new OrderItem();
        item.setSkuId(skuId);
        item.setQuantity(quantity);
        return item;
    }
}
