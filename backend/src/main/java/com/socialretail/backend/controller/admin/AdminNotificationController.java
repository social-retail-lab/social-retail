package com.socialretail.backend.controller.admin;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.socialretail.backend.common.result.Result;
import com.socialretail.backend.entity.product.Product;
import com.socialretail.backend.entity.system.Notification;
import com.socialretail.backend.mapper.product.ProductMapper;
import com.socialretail.backend.mapper.system.NotificationMapper;
import jakarta.annotation.Resource;
import org.springframework.web.bind.annotation.*;

import java.util.*;

@RestController
@RequestMapping("/api/admin/notifications")
public class AdminNotificationController {

    @Resource private NotificationMapper notificationMapper;
    @Resource private ProductMapper productMapper;

    @GetMapping("/badges")
    public Result badges() {
        Map<String, Object> result = new HashMap<>();

        // 待审核商品
        Long pendingProductAudit = productMapper.selectCount(
            new LambdaQueryWrapper<Product>()
                .eq(Product::getAuditStatus, 0)
        );
        result.put("pendingProductAudit", pendingProductAudit);

        // 未读消息通知
        Long unread = notificationMapper.selectCount(
            new LambdaQueryWrapper<Notification>()
                .isNotNull(Notification::getUserId)
                .eq(Notification::getIsRead, 0)
        );
        result.put("unreadNotifications", unread);

        return Result.success(result);
    }

    @GetMapping
    public Result list() {
        List<Notification> list = notificationMapper.selectList(
            new LambdaQueryWrapper<Notification>()
                .isNotNull(Notification::getUserId)
                .orderByDesc(Notification::getCreateTime)
        );
        return Result.success(list);
    }

    @PostMapping("/mark-read")
    public Result markRead(@RequestBody Map<String, Object> body) {
        Notification n = new Notification();
        n.setIsRead(1);
        var wrapper = new LambdaQueryWrapper<Notification>()
            .isNotNull(Notification::getUserId)
            .eq(Notification::getIsRead, 0);

        Object type = body.get("type");
        if (type != null) {
            wrapper.eq(Notification::getType, type.toString());
        }
        notificationMapper.update(n, wrapper);
        return Result.success(null);
    }
}
