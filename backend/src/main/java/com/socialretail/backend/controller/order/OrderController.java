package com.socialretail.backend.controller.order;

import com.socialretail.backend.common.result.Result;
import com.socialretail.backend.config.JwtInterceptor;
import com.socialretail.backend.dto.request.order.OrderCancelRequest;
import com.socialretail.backend.dto.request.order.OrderPreviewRequest;
import com.socialretail.backend.dto.request.order.OrderQueryRequest;
import com.socialretail.backend.dto.request.order.OrderSubmitRequest;
import com.socialretail.backend.dto.response.order.OrderDetailResponse;
import com.socialretail.backend.dto.response.order.OrderListResponse;
import com.socialretail.backend.dto.response.order.OrderPreviewResponse;
import com.socialretail.backend.dto.response.order.OrderStatusResponse;
import com.socialretail.backend.dto.response.order.OrderSubmitResponse;
import com.socialretail.backend.service.order.OrderService;
import jakarta.validation.Valid;
import jakarta.validation.constraints.Positive;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Validated
@RestController
@RequestMapping("/api/orders")
public class OrderController {

    private final OrderService orderService;

    public OrderController(OrderService orderService) {
        this.orderService = orderService;
    }

    @PostMapping("/preview")
    public Result<OrderPreviewResponse> preview(
            @RequestAttribute(JwtInterceptor.USER_ID_ATTRIBUTE) Long userId,
            @Valid @RequestBody OrderPreviewRequest request) {
        return Result.success(orderService.preview(userId, request));
    }

    @PostMapping
    public ResponseEntity<Result<OrderSubmitResponse>> submit(
            @RequestAttribute(JwtInterceptor.USER_ID_ATTRIBUTE) Long userId,
            @Valid @RequestBody OrderSubmitRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(Result.success("订单创建成功", orderService.submit(userId, request)));
    }

    @GetMapping
    public Result<OrderListResponse> list(
            @RequestAttribute(JwtInterceptor.USER_ID_ATTRIBUTE) Long userId,
            @Valid @ModelAttribute OrderQueryRequest request) {
        return Result.success(orderService.list(userId, request));
    }

    @GetMapping("/{orderId}")
    public Result<OrderDetailResponse> detail(
            @RequestAttribute(JwtInterceptor.USER_ID_ATTRIBUTE) Long userId,
            @Positive(message = "订单ID必须大于0") @PathVariable Long orderId) {
        return Result.success(orderService.detail(userId, orderId));
    }

    @PostMapping("/{orderId}/cancel")
    public Result<OrderStatusResponse> cancel(
            @RequestAttribute(JwtInterceptor.USER_ID_ATTRIBUTE) Long userId,
            @Positive(message = "订单ID必须大于0") @PathVariable Long orderId,
            @Valid @RequestBody(required = false) OrderCancelRequest request) {
        return Result.success("订单取消成功", orderService.cancel(userId, orderId, request));
    }

    @PostMapping("/{orderId}/confirm")
    public Result<OrderStatusResponse> confirm(
            @RequestAttribute(JwtInterceptor.USER_ID_ATTRIBUTE) Long userId,
            @Positive(message = "订单ID必须大于0") @PathVariable Long orderId) {
        return Result.success("确认收货成功", orderService.confirm(userId, orderId));
    }

    @GetMapping("/{orderId}/status")
    public Result<OrderStatusResponse> status(
            @RequestAttribute(JwtInterceptor.USER_ID_ATTRIBUTE) Long userId,
            @Positive(message = "订单ID必须大于0") @PathVariable Long orderId) {
        return Result.success(orderService.status(userId, orderId));
    }
}
