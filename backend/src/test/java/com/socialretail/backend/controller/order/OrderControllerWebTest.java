package com.socialretail.backend.controller.order;

import com.socialretail.backend.common.GlobalExceptionHandler;
import com.socialretail.backend.config.JwtInterceptor;
import com.socialretail.backend.config.WebMvcConfig;
import com.socialretail.backend.dto.response.order.OrderDetailResponse;
import com.socialretail.backend.dto.response.order.OrderListResponse;
import com.socialretail.backend.dto.response.order.OrderPreviewResponse;
import com.socialretail.backend.dto.response.order.OrderStatusResponse;
import com.socialretail.backend.dto.response.order.OrderSubmitResponse;
import com.socialretail.backend.service.order.OrderService;
import com.socialretail.backend.utils.JwtUtil;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.web.servlet.MockMvc;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@WebMvcTest(OrderController.class)
@ContextConfiguration(classes = {
        OrderController.class, WebMvcConfig.class, JwtInterceptor.class, GlobalExceptionHandler.class
})
class OrderControllerWebTest {

    private static final String AUTHORIZATION = "Bearer valid-token";

    @Autowired private MockMvc mockMvc;
    @MockBean private OrderService orderService;
    @MockBean private JwtUtil jwtUtil;

    @BeforeEach
    void setUp() {
        when(jwtUtil.getUserId("valid-token")).thenReturn(10001L);
    }

    @Test
    void orderApisRequireJwt() throws Exception {
        mockMvc.perform(get("/api/orders"))
                .andExpect(status().isUnauthorized())
                .andExpect(jsonPath("$.code").value(40101));
    }

    @Test
    void previewOrder() throws Exception {
        OrderPreviewResponse preview = new OrderPreviewResponse();
        preview.setItemList(List.of());
        preview.setTotalAmount(new BigDecimal("79.80"));
        preview.setDiscountAmount(new BigDecimal("0.00"));
        preview.setPayAmount(new BigDecimal("79.80"));
        preview.setDeliveryFee(new BigDecimal("0.00"));
        preview.setAvailablePromotions(List.of());
        preview.setAvailableCoupons(List.of());
        when(orderService.preview(eq(10001L), any())).thenReturn(preview);

        mockMvc.perform(post("/api/orders/preview")
                        .header("Authorization", AUTHORIZATION)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(orderBody()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.totalAmount").value(79.80));
    }

    @Test
    void submitOrderReturns201() throws Exception {
        when(orderService.submit(eq(10001L), any())).thenReturn(new OrderSubmitResponse(
                9001L, "ORD202607010001", 0, "WAIT_PAY", new BigDecimal("79.80"),
                LocalDateTime.of(2026, 7, 1, 15, 0)
        ));

        mockMvc.perform(post("/api/orders")
                        .header("Authorization", AUTHORIZATION)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(orderBody()))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.message").value("订单创建成功"))
                .andExpect(jsonPath("$.data.orderId").value(9001))
                .andExpect(jsonPath("$.data.statusText").value("WAIT_PAY"))
                .andExpect(jsonPath("$.data.expireTime").value("2026-07-01 15:00:00"));
    }

    @Test
    void listOrdersSupportsStatusAndPagination() throws Exception {
        when(orderService.list(eq(10001L), any())).thenReturn(
                new OrderListResponse(List.of(), 0L, 0, 1, 10)
        );

        mockMvc.perform(get("/api/orders")
                        .header("Authorization", AUTHORIZATION)
                        .param("status", "0")
                        .param("page", "1")
                        .param("pageSize", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.list").isArray())
                .andExpect(jsonPath("$.data.pageSize").value(10));
    }

    @Test
    void detailOrderUsesJwtUser() throws Exception {
        OrderDetailResponse detail = new OrderDetailResponse();
        detail.setOrderId(9001L);
        detail.setOrderSn("ORD202607010001");
        detail.setStatus(0);
        detail.setStatusText("WAIT_PAY");
        detail.setItemList(List.of());
        when(orderService.detail(10001L, 9001L)).thenReturn(detail);

        mockMvc.perform(get("/api/orders/9001").header("Authorization", AUTHORIZATION))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.orderId").value(9001));

        verify(orderService).detail(10001L, 9001L);
    }

    @Test
    void cancelOrder() throws Exception {
        when(orderService.cancel(eq(10001L), eq(9001L), any())).thenReturn(
                new OrderStatusResponse(5, "CANCELLED", LocalDateTime.now())
        );

        mockMvc.perform(post("/api/orders/9001/cancel")
                        .header("Authorization", AUTHORIZATION)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"reason\":\"不需要了\"}"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.message").value("订单取消成功"))
                .andExpect(jsonPath("$.data.status").value(5));
    }

    @Test
    void confirmOrder() throws Exception {
        when(orderService.confirm(10001L, 9001L)).thenReturn(
                new OrderStatusResponse(4, "COMPLETED", LocalDateTime.now())
        );

        mockMvc.perform(post("/api/orders/9001/confirm")
                        .header("Authorization", AUTHORIZATION))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.message").value("确认收货成功"))
                .andExpect(jsonPath("$.data.statusText").value("COMPLETED"));
    }

    @Test
    void queryOrderStatus() throws Exception {
        when(orderService.status(10001L, 9001L)).thenReturn(
                new OrderStatusResponse(3, "DELIVERING", LocalDateTime.now())
        );

        mockMvc.perform(get("/api/orders/9001/status")
                        .header("Authorization", AUTHORIZATION))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.status").value(3))
                .andExpect(jsonPath("$.data.statusText").value("DELIVERING"));
    }

    @Test
    void pageSizeOver100Returns40001() throws Exception {
        mockMvc.perform(get("/api/orders")
                        .header("Authorization", AUTHORIZATION)
                        .param("pageSize", "101"))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.code").value(40001));
    }

    private String orderBody() {
        return """
                {
                  "cartItemIds": [7],
                  "addressId": 501,
                  "deliveryType": 1,
                  "remark": "请尽快配送"
                }
                """;
    }
}
