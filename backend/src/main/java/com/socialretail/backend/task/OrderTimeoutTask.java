package com.socialretail.backend.task;

import com.socialretail.backend.service.order.OrderTimeoutService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Component
public class OrderTimeoutTask {

    private static final Logger log = LoggerFactory.getLogger(OrderTimeoutTask.class);
    private final OrderTimeoutService orderTimeoutService;

    public OrderTimeoutTask(OrderTimeoutService orderTimeoutService) {
        this.orderTimeoutService = orderTimeoutService;
    }

    @Scheduled(
            initialDelayString = "${order.auto-cancel.scan-delay-ms:60000}",
            fixedDelayString = "${order.auto-cancel.scan-delay-ms:60000}"
    )
    public void cancelExpiredOrders() {
        int cancelledCount = orderTimeoutService.cancelExpiredOrders();
        if (cancelledCount > 0) {
            log.info("自动取消超时待支付订单 {} 个", cancelledCount);
        }
    }
}
