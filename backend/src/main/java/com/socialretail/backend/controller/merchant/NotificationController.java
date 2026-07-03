package com.socialretail.backend.controller.merchant;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.socialretail.backend.common.result.Result;
import com.socialretail.backend.entity.order.AfterSale;
import com.socialretail.backend.entity.order.Order;
import com.socialretail.backend.mapper.order.AfterSaleMapper;
import com.socialretail.backend.mapper.order.OrderMapper;
import com.socialretail.backend.service.merchant.NotificationService;
import jakarta.annotation.Resource;
import jakarta.servlet.http.HttpServletRequest;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@RestController
@RequestMapping("/api/merchant")
public class NotificationController {

    @Resource
    private NotificationService notificationService;
    @Resource
    private OrderMapper orderMapper;
    @Resource
    private AfterSaleMapper afterSaleMapper;

    /** 侧栏小红点/数字统计 */
    @GetMapping("/notifications/badges")
    public Result<Map<String, Object>> badges(HttpServletRequest request) {
        Long merchantId = (Long) request.getAttribute("merchantId");
        Map<String, Object> result = new HashMap<>();

        // 待接单
        long pendingAccept = orderMapper.selectCount(
            new LambdaQueryWrapper<Order>()
                .eq(Order::getMerchantId, merchantId)
                .eq(Order::getStatus, 0)
        );
        result.put("pendingAccept", pendingAccept);

        // 待发货
        long pendingShip = orderMapper.selectCount(
            new LambdaQueryWrapper<Order>()
                .eq(Order::getMerchantId, merchantId)
                .eq(Order::getStatus, 1)
        );
        result.put("pendingShip", pendingShip);

        // 待处理售后
        long pendingAfterSale = afterSaleMapper.selectCount(
            new LambdaQueryWrapper<AfterSale>()
                .eq(AfterSale::getMerchantId, merchantId)
                .eq(AfterSale::getStatus, 0)
        );
        result.put("pendingAfterSale", pendingAfterSale);

        // 未读通知
        int unread = notificationService.getUnreadCount(merchantId);
        result.put("unreadNotifications", unread);

        return Result.success(result);
    }

    /** 获取未读数量（小红点） */
    @GetMapping("/notifications/unread-count")
    public Result<Map<String, Object>> getUnreadCount(HttpServletRequest request) {
        Long merchantId = (Long) request.getAttribute("merchantId");
        int count = notificationService.getUnreadCount(merchantId);
        Map<String, Object> result = new HashMap<>();
        result.put("unreadCount", count);
        result.put("hasUnread", count > 0);
        return Result.success(result);
    }

    /** 获取通知列表 */
    @GetMapping("/notifications")
    public Result<List<Map<String, Object>>> getNotificationList(
            HttpServletRequest request,
            @RequestParam(defaultValue = "1") int pageNum,
            @RequestParam(defaultValue = "20") int pageSize) {
        Long merchantId = (Long) request.getAttribute("merchantId");
        log.info("[通知列表] merchantId={}", merchantId);
        List<Map<String, Object>> list = notificationService.getNotificationList(merchantId, pageNum, pageSize);
        return Result.success(list);
    }

    /** 标记单条已读 */
    @PutMapping("/notifications/{id}/read")
    public Result<String> markAsRead(HttpServletRequest request, @PathVariable Long id) {
        Long merchantId = (Long) request.getAttribute("merchantId");
        notificationService.markAsRead(id, merchantId);
        return Result.success("ok");
    }

    /** 全部已读 */
    @PutMapping("/notifications/read-all")
    public Result<String> markAllAsRead(HttpServletRequest request) {
        Long merchantId = (Long) request.getAttribute("merchantId");
        notificationService.markAllAsRead(merchantId);
        return Result.success("ok");
    }
}
