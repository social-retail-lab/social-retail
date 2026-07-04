package com.socialretail.backend.service.order;

import com.socialretail.backend.dto.request.order.OrderCancelRequest;
import com.socialretail.backend.dto.request.order.OrderPreviewRequest;
import com.socialretail.backend.dto.request.order.OrderQueryRequest;
import com.socialretail.backend.dto.request.order.OrderSubmitRequest;
import com.socialretail.backend.dto.response.order.OrderDetailResponse;
import com.socialretail.backend.dto.response.order.OrderListResponse;
import com.socialretail.backend.dto.response.order.OrderPreviewResponse;
import com.socialretail.backend.dto.response.order.OrderStatusResponse;
import com.socialretail.backend.dto.response.order.OrderSubmitResponse;

public interface OrderService {
    OrderPreviewResponse preview(Long userId, OrderPreviewRequest request);

    OrderSubmitResponse submit(Long userId, String idempotentKey, OrderSubmitRequest request);

    OrderListResponse list(Long userId, OrderQueryRequest request);

    OrderDetailResponse detail(Long userId, Long orderId);

    OrderStatusResponse cancel(Long userId, Long orderId, OrderCancelRequest request);

    OrderStatusResponse confirm(Long userId, Long orderId);

    OrderStatusResponse status(Long userId, Long orderId);
}
