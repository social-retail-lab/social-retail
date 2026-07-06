package com.socialretail.backend.controller.admin;

import com.socialretail.backend.common.Result;
import com.socialretail.backend.entity.promotion.PlatformPromotion;
import com.socialretail.backend.service.promotion.PromotionService;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/admin/promotions")
public class AdminPromotionController {

    private final PromotionService promotionService;

    public AdminPromotionController(PromotionService promotionService) {
        this.promotionService = promotionService;
    }

    // 活动列表（status: 0=草稿, 1=已发布, 2=已关闭）
    @GetMapping
    public Result list(@RequestParam(required = false) Integer status) {
        return Result.success(promotionService.listPromotions(status));
    }

    // 创建活动（保存为草稿）
    @PostMapping
    public Result create(@RequestBody Map<String, Object> body) {
        Map<String, Object> promotionMap = (Map<String, Object>) body.get("promotion");
        PlatformPromotion p = new PlatformPromotion();
        p.setTitle((String) promotionMap.get("title"));
        p.setStartTime(parseDateTime((String) promotionMap.get("startTime")));
        p.setEndTime(parseDateTime((String) promotionMap.get("endTime")));
        List<Map<String, BigDecimal>> tiers = parseTiers(body.get("tiers"));
        return Result.success(promotionService.createPromotion(p, tiers));
    }

    // 编辑活动（仅草稿可编辑）
    @PutMapping("/{id}")
    public Result update(@PathVariable Long id, @RequestBody Map<String, Object> body) {
        Map<String, Object> promotionMap = (Map<String, Object>) body.get("promotion");
        PlatformPromotion p = new PlatformPromotion();
        p.setTitle((String) promotionMap.get("title"));
        p.setStartTime(parseDateTime((String) promotionMap.get("startTime")));
        p.setEndTime(parseDateTime((String) promotionMap.get("endTime")));
        List<Map<String, BigDecimal>> tiers = parseTiers(body.get("tiers"));
        return Result.success(promotionService.updatePromotion(id, p, tiers));
    }

    // 发布活动（草稿→已发布，发布后不可编辑）
    @PostMapping("/{id}/publish")
    public Result publish(@PathVariable Long id) {
        promotionService.publishPromotion(id);
        return Result.success(null);
    }

    // 关闭活动（已发布→已关闭）
    @PostMapping("/{id}/close")
    public Result close(@PathVariable Long id) {
        promotionService.closePromotion(id);
        return Result.success(null);
    }

    // 删除活动（仅已关闭可删除）
    @DeleteMapping("/{id}")
    public Result delete(@PathVariable Long id) {
        promotionService.deletePromotion(id);
        return Result.success(null);
    }

    // ===== 辅助方法 =====
    private List<Map<String, BigDecimal>> parseTiers(Object tiersObj) {
        List<Map<String, BigDecimal>> result = new ArrayList<>();
        if (tiersObj == null) return result;
        if (tiersObj instanceof List) {
            List<?> list = (List<?>) tiersObj;
            for (Object item : list) {
                if (item instanceof Map) {
                    Map<?, ?> m = (Map<?, ?>) item;
                    Map<String, BigDecimal> tier = new java.util.HashMap<>();
                    if (m.get("minAmount") != null) {
                        tier.put("minAmount", new BigDecimal(String.valueOf(m.get("minAmount"))));
                    }
                    if (m.get("discountAmount") != null) {
                        tier.put("discountAmount", new BigDecimal(String.valueOf(m.get("discountAmount"))));
                    }
                    result.add(tier);
                }
            }
        }
        return result;
    }

    private LocalDateTime parseDateTime(String str) {
        if (str == null || str.isEmpty()) return null;
        try {
            if (str.length() == 10) {
                return LocalDateTime.parse(str + "T00:00:00");
            }
            if (str.length() == 16) {
                return LocalDateTime.parse(str + ":00");
            }
            return LocalDateTime.parse(str);
        } catch (DateTimeParseException e) {
            return LocalDateTime.parse(str.replace(" ", "T"));
        }
    }
}
