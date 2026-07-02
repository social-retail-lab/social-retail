package com.socialretail.backend.service.aftersale.impl;

import com.socialretail.backend.entity.order.AfterSale;
import com.socialretail.backend.entity.order.OrderItem;
import com.socialretail.backend.enums.aftersale.AfterSaleStatus;
import com.socialretail.backend.enums.aftersale.RefundStatus;
import com.socialretail.backend.mapper.order.AfterSaleMapper;
import com.socialretail.backend.mapper.order.OrderItemMapper;
import com.socialretail.backend.mapper.product.ProductMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/** 在同一事务中确认退款结果并维护商品净销量。 */
@Service
public class AfterSaleRefundCompletionService {
    private final AfterSaleMapper afterSaleMapper;
    private final OrderItemMapper orderItemMapper;
    private final ProductMapper productMapper;

    public AfterSaleRefundCompletionService(AfterSaleMapper afterSaleMapper,
                                            OrderItemMapper orderItemMapper,
                                            ProductMapper productMapper) {
        this.afterSaleMapper = afterSaleMapper;
        this.orderItemMapper = orderItemMapper;
        this.productMapper = productMapper;
    }

    @Transactional
    public int complete(Long afterSaleId, boolean success, String message) {
        int changed = afterSaleMapper.finishRefund(afterSaleId,
                success ? AfterSaleStatus.COMPLETED.getCode() : AfterSaleStatus.FAILED.getCode(),
                success ? RefundStatus.SUCCESS.getCode() : RefundStatus.FAILED.getCode(),
                message, LocalDateTime.now());
        if (changed == 0 || !success) {
            return changed;
        }

        AfterSale afterSale = afterSaleMapper.selectById(afterSaleId);
        if (afterSale == null || afterSale.getOrderItemId() == null) {
            throw new IllegalStateException("退款成功但售后单或订单明细不存在，afterSaleId=" + afterSaleId);
        }
        OrderItem item = orderItemMapper.selectById(afterSale.getOrderItemId());
        if (item == null || item.getProductId() == null || item.getQuantity() == null || item.getQuantity() <= 0) {
            throw new IllegalStateException("退款成功但订单商品数据不完整，orderItemId=" + afterSale.getOrderItemId());
        }
        BigDecimal itemPaidAmount = item.getItemFinalAmount();
        if (itemPaidAmount == null && item.getFinalPrice() != null) {
            itemPaidAmount = item.getFinalPrice().multiply(BigDecimal.valueOf(item.getQuantity()));
        }
        // 金额不足以覆盖整条订单明细时属于部分退款，不回退已售件数。
        if (afterSale.getRefundAmount() == null || itemPaidAmount == null
                || afterSale.getRefundAmount().compareTo(itemPaidAmount) < 0) {
            return changed;
        }
        if (productMapper.decrementSoldCount(item.getProductId(), item.getQuantity()) != 1) {
            throw new IllegalStateException("退款成功后回退商品销量失败，productId=" + item.getProductId());
        }
        return changed;
    }
}
