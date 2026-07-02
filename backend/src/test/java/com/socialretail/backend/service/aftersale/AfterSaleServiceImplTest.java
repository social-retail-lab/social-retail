package com.socialretail.backend.service.aftersale;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.socialretail.backend.common.exception.BusinessException;
import com.socialretail.backend.dto.request.aftersale.AfterSaleCancelRequest;
import com.socialretail.backend.entity.order.AfterSale;
import com.socialretail.backend.entity.order.Order;
import com.socialretail.backend.enums.aftersale.*;
import com.socialretail.backend.infrastructure.pay.refund.AliPayRefundResult;
import com.socialretail.backend.infrastructure.pay.refund.AliPayRefundService;
import com.socialretail.backend.mapper.order.AfterSaleMapper;
import com.socialretail.backend.mapper.order.OrderItemMapper;
import com.socialretail.backend.mapper.order.OrderMapper;
import com.socialretail.backend.service.aftersale.impl.AfterSaleServiceImpl;
import com.socialretail.backend.service.aftersale.impl.AfterSaleRefundCompletionService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.CompletableFuture;

import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class AfterSaleServiceImplTest {
    @Mock private AfterSaleMapper afterSaleMapper;
    @Mock private OrderMapper orderMapper;
    @Mock private OrderItemMapper orderItemMapper;
    @Mock private AliPayRefundService aliPayRefundService;
    @Mock private AfterSaleRefundCompletionService refundCompletionService;
    private AfterSaleServiceImpl service;

    @BeforeEach
    void setUp() {
        service = new AfterSaleServiceImpl(afterSaleMapper, orderMapper, orderItemMapper,
                aliPayRefundService, refundCompletionService, new ObjectMapper());
    }

    @Test
    void approvedWaitShipOrderRefundsSynchronouslyAndCompletes() {
        AfterSale pending = afterSale(1L, AuditStatus.PENDING, RefundStatus.NOT_REFUNDED);
        AfterSale approved = afterSale(1L, AuditStatus.APPROVED, RefundStatus.NOT_REFUNDED);
        when(afterSaleMapper.selectById(1L)).thenReturn(pending, approved);
        when(afterSaleMapper.recordAudit(eq(1L), eq(1), eq(2), any(), isNull(), any())).thenReturn(1);
        when(afterSaleMapper.claimRefund(eq(1L), any())).thenReturn(1);
        Order order = new Order();
        order.setId(10L);
        order.setStatus(1);
        when(orderMapper.selectById(10L)).thenReturn(order);
        when(aliPayRefundService.refund(10L, new BigDecimal("59.90")))
                .thenReturn(AliPayRefundResult.success("mock-trade"));

        service.handleAuditResult(1L, AuditStatus.APPROVED, "同意退款");

        verify(aliPayRefundService).refund(10L, new BigDecimal("59.90"));
        verify(refundCompletionService).complete(eq(1L), eq(true), anyString());
    }

    @Test
    void repeatedApprovedAuditDoesNotRefundAgainAfterSuccess() {
        AfterSale completed = afterSale(1L, AuditStatus.APPROVED, RefundStatus.SUCCESS);
        completed.setStatus(AfterSaleStatus.COMPLETED.getCode());
        when(afterSaleMapper.selectById(1L)).thenReturn(completed, completed);
        when(afterSaleMapper.recordAudit(eq(1L), eq(1), eq(2), any(), isNull(), any())).thenReturn(0);

        service.handleAuditResult(1L, AuditStatus.APPROVED, "重复消息");

        verify(afterSaleMapper, never()).claimRefund(anyLong(), any());
        verifyNoInteractions(aliPayRefundService);
    }

    @Test
    void shippedOrderRefundsAsynchronouslyAndRecordsFailure() {
        AfterSale pending = afterSale(1L, AuditStatus.PENDING, RefundStatus.NOT_REFUNDED);
        AfterSale approved = afterSale(1L, AuditStatus.APPROVED, RefundStatus.NOT_REFUNDED);
        when(afterSaleMapper.selectById(1L)).thenReturn(pending, approved);
        when(afterSaleMapper.recordAudit(eq(1L), eq(1), eq(2), any(), isNull(), any())).thenReturn(1);
        when(afterSaleMapper.claimRefund(eq(1L), any())).thenReturn(1);
        Order order = new Order();
        order.setId(10L);
        order.setStatus(3);
        when(orderMapper.selectById(10L)).thenReturn(order);
        when(aliPayRefundService.refundAsync(10L, new BigDecimal("59.90")))
                .thenReturn(CompletableFuture.completedFuture(AliPayRefundResult.fail("sandbox fail")));

        service.handleAuditResult(1L, AuditStatus.APPROVED, "同意退款");

        verify(refundCompletionService).complete(1L, false, "sandbox fail");
    }

    @Test
    void cancelRejectsAnAlreadyApprovedAfterSale() {
        Map<String, Object> row = afterSaleDetailRow();
        row.put("audit_status", AuditStatus.APPROVED.getCode());
        when(afterSaleMapper.selectUserDetail(1L, 100L)).thenReturn(row);

        assertThrows(BusinessException.class,
                () -> service.cancel(100L, 1L, new AfterSaleCancelRequest("不需要了")));

        verify(afterSaleMapper, never()).cancelApplying(anyLong(), anyLong(), any(), any());
    }

    @Test
    void cancelUpdatesOnlyPendingAndNotRefundedAfterSale() {
        when(afterSaleMapper.selectUserDetail(1L, 100L)).thenReturn(afterSaleDetailRow());
        when(afterSaleMapper.cancelApplying(eq(1L), eq(100L), eq("不需要了"), any())).thenReturn(1);

        service.cancel(100L, 1L, new AfterSaleCancelRequest("不需要了"));

        verify(afterSaleMapper).cancelApplying(eq(1L), eq(100L), eq("不需要了"), any());
    }

    private Map<String, Object> afterSaleDetailRow() {
        Map<String, Object> row = new HashMap<>();
        row.put("id", 1L);
        row.put("order_id", 10L);
        row.put("order_item_id", 20L);
        row.put("type", AfterSaleType.REFUND_ONLY.getCode());
        row.put("refund_amount", new BigDecimal("59.90"));
        row.put("evidence_images", "[]");
        row.put("status", AfterSaleStatus.APPLYING.getCode());
        row.put("audit_status", AuditStatus.PENDING.getCode());
        row.put("refund_status", RefundStatus.NOT_REFUNDED.getCode());
        return row;
    }

    private AfterSale afterSale(Long id, AuditStatus auditStatus, RefundStatus refundStatus) {
        AfterSale afterSale = new AfterSale();
        afterSale.setId(id);
        afterSale.setOrderId(10L);
        afterSale.setStatus(AfterSaleStatus.APPLYING.getCode());
        afterSale.setAuditStatus(auditStatus.getCode());
        afterSale.setRefundStatus(refundStatus.getCode());
        afterSale.setRefundAmount(new BigDecimal("59.90"));
        afterSale.setIsDeleted(0);
        return afterSale;
    }
}
