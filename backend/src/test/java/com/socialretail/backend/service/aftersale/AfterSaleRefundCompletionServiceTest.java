package com.socialretail.backend.service.aftersale;

import com.socialretail.backend.entity.order.AfterSale;
import com.socialretail.backend.entity.order.OrderItem;
import com.socialretail.backend.enums.aftersale.AfterSaleStatus;
import com.socialretail.backend.enums.aftersale.RefundStatus;
import com.socialretail.backend.mapper.order.AfterSaleMapper;
import com.socialretail.backend.mapper.order.OrderItemMapper;
import com.socialretail.backend.mapper.product.ProductMapper;
import com.socialretail.backend.service.aftersale.impl.AfterSaleRefundCompletionService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class AfterSaleRefundCompletionServiceTest {
    @Mock private AfterSaleMapper afterSaleMapper;
    @Mock private OrderItemMapper orderItemMapper;
    @Mock private ProductMapper productMapper;
    private AfterSaleRefundCompletionService service;

    @BeforeEach
    void setUp() {
        service = new AfterSaleRefundCompletionService(afterSaleMapper, orderItemMapper, productMapper);
    }

    @Test
    void successfulRefundDecrementsSoldCountOnce() {
        when(afterSaleMapper.finishRefund(eq(1L), eq(AfterSaleStatus.COMPLETED.getCode()),
                eq(RefundStatus.SUCCESS.getCode()), anyString(), any())).thenReturn(1);
        AfterSale afterSale = new AfterSale();
        afterSale.setOrderItemId(9L);
        afterSale.setRefundAmount(new java.math.BigDecimal("139.80"));
        when(afterSaleMapper.selectById(1L)).thenReturn(afterSale);
        OrderItem item = new OrderItem();
        item.setProductId(6001L);
        item.setQuantity(2);
        item.setItemFinalAmount(new java.math.BigDecimal("139.80"));
        when(orderItemMapper.selectById(9L)).thenReturn(item);
        when(productMapper.decrementSoldCount(6001L, 2)).thenReturn(1);

        assertEquals(1, service.complete(1L, true, "success"));
        verify(productMapper).decrementSoldCount(6001L, 2);
    }

    @Test
    void duplicateRefundCallbackDoesNotDecrementAgain() {
        when(afterSaleMapper.finishRefund(eq(1L), anyInt(), anyInt(), anyString(), any())).thenReturn(0);

        assertEquals(0, service.complete(1L, true, "duplicate"));
        verifyNoInteractions(orderItemMapper, productMapper);
    }
}
