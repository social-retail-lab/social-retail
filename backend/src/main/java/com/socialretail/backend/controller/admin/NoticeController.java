package com.socialretail.backend.controller.admin;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.socialretail.backend.common.Result;
import com.socialretail.backend.entity.product.Product;
import com.socialretail.backend.mapper.product.ProductMapper;
import org.springframework.web.bind.annotation.*;

import java.util.LinkedHashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/admin/notifications")
public class NoticeController {

    private static final org.slf4j.Logger log = org.slf4j.LoggerFactory.getLogger(NoticeController.class);

    private final ProductMapper productMapper;

    public NoticeController(ProductMapper productMapper) {
        this.productMapper = productMapper;
    }

    @GetMapping("/badges")
    public Result badges() {
        // 待审核商品数
        LambdaQueryWrapper<Product> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Product::getAuditStatus, 0);
        long pendingProductAudit = productMapper.selectCount(wrapper);

        Map<String, Object> data = new LinkedHashMap<>();
        data.put("pendingProductAudit", (int) pendingProductAudit);
        data.put("pendingMerchantAudit", 0);
        data.put("pendingAfterSaleAppeal", 0);
        data.put("unreadNotifications", pendingProductAudit > 0);
        return Result.ok(data);
    }

    @PostMapping("/mark-read")
    public Result markRead(@RequestBody Map<String, Object> body) {
        return Result.ok("已标记已读", null);
    }
}
