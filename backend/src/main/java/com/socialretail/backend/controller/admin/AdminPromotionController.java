package com.socialretail.backend.controller.admin;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.socialretail.backend.common.result.Result;
import com.socialretail.backend.entity.promotion.PlatformPromotion;
import com.socialretail.backend.entity.promotion.PlatformPromotionTier;
import com.socialretail.backend.mapper.promotion.PlatformPromotionMapper;
import com.socialretail.backend.mapper.promotion.PlatformPromotionTierMapper;
import org.springframework.web.bind.annotation.*;

import jakarta.annotation.Resource;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/admin/promotions")
public class AdminPromotionController {

    @Resource
    private PlatformPromotionMapper promotionMapper;

    @Resource
    private PlatformPromotionTierMapper tierMapper;

    @GetMapping
    public Result list(@RequestParam(required = false) Integer status) {
        LambdaQueryWrapper<PlatformPromotion> wrapper = new LambdaQueryWrapper<>();
        if (status != null) {
            wrapper.eq(PlatformPromotion::getStatus, status);
        }
        wrapper.orderByDesc(PlatformPromotion::getCreateTime);
        List<PlatformPromotion> list = promotionMapper.selectList(wrapper);
        for (PlatformPromotion p : list) {
            List<PlatformPromotionTier> tiers = tierMapper.selectList(
                    new LambdaQueryWrapper<PlatformPromotionTier>()
                            .eq(PlatformPromotionTier::getPromotionId, p.getId())
                            .orderByAsc(PlatformPromotionTier::getSortOrder));
            p.setTiers(tiers);
        }
        Map<String, Object> result = new HashMap<>();
        result.put("total", list.size());
        result.put("list", list);
        return Result.success(result);
    }

    @PostMapping
    public Result create(@RequestBody Map<String, Object> body) {
        Map<String, Object> promotionMap = (Map<String, Object>) body.get("promotion");
        String timeErr = validatePromotionTime(promotionMap);
        if (timeErr != null) return Result.fail(timeErr);

        PlatformPromotion p = buildPromotion(body);
        p.setStatus(0);
        p.setCreateTime(LocalDateTime.now());
        p.setUpdateTime(LocalDateTime.now());
        promotionMapper.insert(p);

        List<PlatformPromotionTier> tiers = buildTiers(body, p.getId());
        if (!tiers.isEmpty()) {
            for (PlatformPromotionTier tier : tiers) {
                tierMapper.insert(tier);
            }
        }
        p.setTiers(tiers);
        return Result.success(p);
    }

    @PutMapping("/{id}")
    public Result update(@PathVariable Long id, @RequestBody Map<String, Object> body) {
        PlatformPromotion existing = promotionMapper.selectById(id);
        if (existing == null) {
            return Result.fail("活动不存在");
        }
        if (existing.getStatus() != 0) {
            return Result.fail("仅草稿状态的活动可编辑");
        }

        Map<String, Object> promotionMap = (Map<String, Object>) body.get("promotion");
        String timeErr = validatePromotionTime(promotionMap);
        if (timeErr != null) return Result.fail(timeErr);

        PlatformPromotion p = buildPromotion(body);
        p.setId(id);
        p.setUpdateTime(LocalDateTime.now());
        promotionMapper.updateById(p);

        tierMapper.delete(new LambdaQueryWrapper<PlatformPromotionTier>()
                .eq(PlatformPromotionTier::getPromotionId, id));
        List<PlatformPromotionTier> tiers = buildTiers(body, id);
        if (!tiers.isEmpty()) {
            for (PlatformPromotionTier tier : tiers) {
                tierMapper.insert(tier);
            }
        }
        p.setTiers(tiers);
        return Result.success(p);
    }

    @PostMapping("/{id}/publish")
    public Result publish(@PathVariable Long id) {
        PlatformPromotion existing = promotionMapper.selectById(id);
        if (existing == null) {
            return Result.fail("活动不存在");
        }
        if (existing.getStatus() != 0) {
            return Result.fail("仅草稿状态的活动可发布");
        }
        if (existing.getStartTime() == null || existing.getStartTime().isBefore(LocalDateTime.now())) {
            return Result.fail("活动开始时间必须晚于当前时间");
        }

        PlatformPromotion p = new PlatformPromotion();
        p.setId(id);
        p.setStatus(1);
        p.setUpdateTime(LocalDateTime.now());
        promotionMapper.updateById(p);
        return Result.success(null);
    }

    @PostMapping("/{id}/close")
    public Result close(@PathVariable Long id) {
        PlatformPromotion existing = promotionMapper.selectById(id);
        if (existing == null) {
            return Result.fail("活动不存在");
        }
        if (existing.getStatus() != 1) {
            return Result.fail("仅已发布状态的活动可关闭");
        }

        PlatformPromotion p = new PlatformPromotion();
        p.setId(id);
        p.setStatus(2);
        p.setUpdateTime(LocalDateTime.now());
        promotionMapper.updateById(p);
        return Result.success(null);
    }

    @DeleteMapping("/{id}")
    public Result delete(@PathVariable Long id) {
        PlatformPromotion existing = promotionMapper.selectById(id);
        if (existing == null) {
            return Result.fail("活动不存在");
        }
        if (existing.getStatus() != 2) {
            return Result.fail("仅已关闭状态的活动可删除");
        }

        tierMapper.delete(new LambdaQueryWrapper<PlatformPromotionTier>()
                .eq(PlatformPromotionTier::getPromotionId, id));
        promotionMapper.deleteById(id);
        return Result.success(null);
    }

    private PlatformPromotion buildPromotion(Map<String, Object> body) {
        Map<String, Object> promotionMap = (Map<String, Object>) body.get("promotion");
        PlatformPromotion p = new PlatformPromotion();
        if (promotionMap != null) {
            p.setTitle((String) promotionMap.get("title"));
            p.setStartTime(parseDateTime((String) promotionMap.get("startTime")));
            p.setEndTime(parseDateTime((String) promotionMap.get("endTime")));
        }
        return p;
    }

    private List<PlatformPromotionTier> buildTiers(Map<String, Object> body, Long promotionId) {
        List<PlatformPromotionTier> result = new ArrayList<>();
        Object tiersObj = body.get("tiers");
        if (tiersObj instanceof List) {
            List<?> list = (List<?>) tiersObj;
            int order = 0;
            for (Object item : list) {
                if (item instanceof Map) {
                    Map<?, ?> m = (Map<?, ?>) item;
                    PlatformPromotionTier tier = new PlatformPromotionTier();
                    tier.setPromotionId(promotionId);
                    tier.setSortOrder(order++);
                    if (m.get("minAmount") != null) {
                        tier.setMinAmount(new BigDecimal(String.valueOf(m.get("minAmount"))));
                    }
                    if (m.get("discountAmount") != null) {
                        tier.setDiscountAmount(new BigDecimal(String.valueOf(m.get("discountAmount"))));
                    }
                    result.add(tier);
                }
            }
        }
        return result;
    }

    private LocalDateTime parseDateTime(String str) {
        if (str == null || str.isEmpty()) {
            return null;
        }
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

    private String validatePromotionTime(Map<String, Object> map) {
        if (map == null) return null;
        Object startObj = map.get("startTime");
        Object endObj = map.get("endTime");
        if (startObj == null || endObj == null) return null;
        if (!(startObj instanceof String) || !(endObj instanceof String)) return null;
        String s1 = (String) startObj, s2 = (String) endObj;
        if (s1.isEmpty() || s2.isEmpty()) return null;
        if (s1.compareTo(s2) >= 0) return "结束时间必须晚于开始时间";
        return null;
    }
}
