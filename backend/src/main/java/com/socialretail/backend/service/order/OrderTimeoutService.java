package com.socialretail.backend.service.order;

public interface OrderTimeoutService {
    int cancelExpiredOrders();
}
