package com.socialretail.backend.service.order.impl;

import com.socialretail.backend.config.OrderTimeoutProperties;
import com.socialretail.backend.entity.order.OrderItem;
import com.socialretail.backend.entity.order.Order;
import com.socialretail.backend.entity.order.OrderStatusLog;
import com.socialretail.backend.mapper.order.OrderMapper;
import com.socialretail.backend.service.order.OrderTimeoutService;
import com.socialretail.backend.service.order.OrderPointsService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class OrderTimeoutServiceImpl implements OrderTimeoutService {

    private final OrderMapper orderMapper;
    private final OrderTimeoutProperties properties;
    private final OrderPointsService orderPointsService;

    public OrderTimeoutServiceImpl(OrderMapper orderMapper, OrderTimeoutProperties properties,
                                   OrderPointsService orderPointsService) {
        this.orderMapper = orderMapper;
        this.properties = properties;
        this.orderPointsService = orderPointsService;
    }

    @Override
    @Transactional
    public int cancelExpiredOrders() {
        int batchSize = Math.max(1, properties.getBatchSize());
        List<Long> orderIds = orderMapper.selectExpiredWaitPayOrderIds(batchSize);
        int cancelledCount = 0;
        for (Long orderId : orderIds) {
            Order order = orderMapper.selectById(orderId);
            // 条件更新相当于抢占：多实例或手动取消并发时，只有一个执行者能成功。
            if (orderMapper.expireWaitPayOrder(orderId) != 1) {
                continue;
            }
            orderPointsService.release(order);
            for (OrderItem item : orderMapper.selectItemsByOrderId(orderId)) {
                if (item.getSkuId() != null
                        && orderMapper.incrementStock(item.getSkuId(), item.getQuantity()) != 1) {
                    throw new IllegalStateException("超时订单库存恢复失败: orderId=" + orderId);
                }
            }
            insertTimeoutLog(orderId);
            cancelledCount++;
        }
        return cancelledCount;
    }

    private void insertTimeoutLog(Long orderId) {
        OrderStatusLog log = new OrderStatusLog();
        log.setOrderId(orderId);
        log.setFromStatus(OrderServiceImpl.WAIT_PAY);
        log.setToStatus(OrderServiceImpl.CANCELLED);
        log.setStatusText(OrderServiceImpl.statusText(OrderServiceImpl.CANCELLED));
        log.setOperatorType("SYSTEM");
        log.setOperatorId(null);
        log.setRemark("支付超时自动取消");
        log.setCreateTime(LocalDateTime.now());
        if (orderMapper.insertStatusLog(log) != 1) {
            throw new IllegalStateException("超时订单状态日志保存失败: orderId=" + orderId);
        }
    }
}
