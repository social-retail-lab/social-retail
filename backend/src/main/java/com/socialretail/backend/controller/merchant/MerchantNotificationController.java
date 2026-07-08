package com.socialretail.backend.controller.merchant;

import com.socialretail.backend.common.Result;
import org.springframework.web.bind.annotation.*;

import java.util.LinkedHashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/merchant/notifications")
public class MerchantNotificationController {

    private static final org.slf4j.Logger log = org.slf4j.LoggerFactory.getLogger(MerchantNotificationController.class);

    @GetMapping("/badges")
    public Result<Map<String, Object>> badges() {
        Map<String, Object> data = new LinkedHashMap<>();
        data.put("pendingAccept", 0);
        data.put("pendingAfterSale", 0);
        data.put("unreadNotifications", 0);
        return Result.ok(data);
    }

    @PostMapping("/mark-read")
    public Result<?> markRead(@RequestBody Map<String, Object> body) {
        log.info("[通知已读] type={}", body.get("type"));
        return Result.ok("ok", null);
    }
}

