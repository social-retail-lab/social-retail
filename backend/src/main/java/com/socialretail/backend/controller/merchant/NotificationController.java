package com.socialretail.backend.controller.merchant;

import com.socialretail.backend.common.result.Result;
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
