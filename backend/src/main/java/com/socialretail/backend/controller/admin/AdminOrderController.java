package com.socialretail.backend.controller.admin;

import com.socialretail.backend.common.PageResult;
import com.socialretail.backend.common.result.Result;
import com.socialretail.backend.service.admin.impl.AdminOrderServiceImpl;
import jakarta.annotation.Resource;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.math.BigDecimal;
import java.util.Map;

@Slf4j
@RestController
@RequestMapping("/api/admin")
public class AdminOrderController {

    @Resource
    private AdminOrderServiceImpl adminOrderService;

    // ==================== 订单管理 ====================

    @GetMapping("/orders")
    public Result<PageResult<Map<String, Object>>> getOrderList(
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String keyword,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int pageSize) {
        log.info("[管理端订单列表] status={}, keyword={}, page={}, pageSize={}", status, keyword, page, pageSize);
        try {
            Integer statusInt = convertStatus(status);
            PageResult<Map<String, Object>> pageResult = adminOrderService.getOrderList(keyword, statusInt, page, pageSize);
            log.info("[管理端订单列表] 成功, total={}", pageResult.getTotal());
            return Result.success(pageResult);
        } catch (RuntimeException e) {
            log.warn("[管理端订单列表] 失败, 原因: {}", e.getMessage());
            throw e;
        }
    }

    @GetMapping("/orders/{orderId}")
    public Result<Map<String, Object>> getOrderDetail(@PathVariable Long orderId) {
        log.info("[管理端订单详情] orderId={}", orderId);
        try {
            Map<String, Object> detail = adminOrderService.getOrderDetail(orderId);
            log.info("[管理端订单详情] 成功, orderId={}, orderSn={}", orderId, detail.get("orderSn"));
            return Result.success(detail);
        } catch (RuntimeException e) {
            log.warn("[管理端订单详情] 失败, orderId={}, 原因: {}", orderId, e.getMessage());
            throw e;
        }
    }

    @PostMapping("/orders/{orderId}/refund")
    public Result<Map<String, Object>> handleRefund(
            @PathVariable Long orderId,
            @RequestBody Map<String, Object> body) {
        BigDecimal refundAmount = body.get("refundAmount") != null
                ? new BigDecimal(body.get("refundAmount").toString()) : BigDecimal.ZERO;
        String reason = (String) body.get("reason");
        log.info("[管理端退款处理] orderId={}, refundAmount={}, reason={}", orderId, refundAmount, reason);
        try {
            Map<String, Object> result = adminOrderService.handleRefund(orderId, refundAmount, reason);
            log.info("[管理端退款处理] 成功, orderId={}", orderId);
            return Result.success(result);
        } catch (RuntimeException e) {
            log.warn("[管理端退款处理] 失败, orderId={}, 原因: {}", orderId, e.getMessage());
            throw e;
        }
    }

    @PostMapping("/orders/{orderId}/close")
    public Result<Map<String, Object>> closeOrder(
            @PathVariable Long orderId,
            @RequestBody Map<String, Object> body) {
        String reason = (String) body.get("reason");
        log.info("[管理端关闭订单] orderId={}, reason={}", orderId, reason);
        try {
            Map<String, Object> result = adminOrderService.closeOrder(orderId, reason);
            log.info("[管理端关闭订单] 成功, orderId={}", orderId);
            return Result.success(result);
        } catch (RuntimeException e) {
            log.warn("[管理端关闭订单] 失败, orderId={}, 原因: {}", orderId, e.getMessage());
            throw e;
        }
    }

    /**
     * 将前端状态字符串转换为数据库 Integer 状态码
     */
    private Integer convertStatus(String status) {
        if (status == null || status.isEmpty() || "ALL".equals(status)) {
            return null;
        }
        return switch (status.toUpperCase()) {
            case "WAIT_PAY" -> 1;
            case "WAIT_SHIP" -> 2;
            case "SHIPPING", "WAIT_PICKUP" -> 3;
            case "COMPLETED" -> 4;
            case "CANCELLED" -> 5;
            case "REFUNDING" -> 6;
            default -> null;
        };
    }
}
