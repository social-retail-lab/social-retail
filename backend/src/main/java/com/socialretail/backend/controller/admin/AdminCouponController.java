package com.socialretail.backend.controller.admin;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.socialretail.backend.common.result.Result;
import com.socialretail.backend.entity.promotion.Coupon;
import com.socialretail.backend.mapper.promotion.CouponMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import jakarta.annotation.Resource;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

@Slf4j
@RestController
@RequestMapping("/api/admin/coupons")
public class AdminCouponController {

    @Resource
    private CouponMapper couponMapper;

    @GetMapping
    public Result list(@RequestParam(defaultValue = "1") Integer pageNum,
                       @RequestParam(defaultValue = "10") Integer pageSize,
                       @RequestParam(required = false) String keyword,
                       @RequestParam(required = false) String type,
                       @RequestParam(required = false) String status) {
        LambdaQueryWrapper<Coupon> wrapper = new LambdaQueryWrapper<>();
        if (keyword != null && !keyword.isEmpty())
            wrapper.like(Coupon::getTitle, keyword);
        if (type != null && !type.isEmpty()) {
            wrapper.eq(Coupon::getType, "FIXED".equals(type) ? 1 : 2);
        }
        if (status != null && !status.isEmpty()) {
            wrapper.eq(Coupon::getStatus, "ACTIVE".equals(status) ? 1 : 0);
        }
        wrapper.orderByDesc(Coupon::getCreateTime);
        Page<Coupon> page = couponMapper.selectPage(new Page<>(pageNum, pageSize), wrapper);
        Map<String, Object> result = new HashMap<>();
        result.put("total", page.getTotal());
        result.put("list", page.getRecords());
        return Result.success(result);
    }

    @PostMapping
    public Result create(@RequestBody Map<String, Object> params) {
        if (!validateTime(params)) {
            return Result.fail("结束时间必须晚于开始时间");
        }
        Coupon c = buildCoupon(params);
        c.setCreateTime(LocalDateTime.now());
        c.setUpdateTime(LocalDateTime.now());
        couponMapper.insert(c);
        return Result.success(c);
    }

    @PutMapping("/{id}")
    public Result update(@PathVariable Long id, @RequestBody Map<String, Object> params) {
        Coupon existing = couponMapper.selectById(id);
        if (existing == null) return Result.fail("优惠券不存在");
        if (!validateTime(params)) {
            return Result.fail("结束时间必须晚于开始时间");
        }
        Coupon c = buildCoupon(params);
        c.setId(id);
        c.setUpdateTime(LocalDateTime.now());
        couponMapper.updateById(c);
        return Result.success(null);
    }

    @PostMapping("/{id}/enable")
    public Result enable(@PathVariable Long id) {
        Coupon existing = couponMapper.selectById(id);
        if (existing == null) return Result.fail("优惠券不存在");
        // 固定时间段优惠券：如果已过期不允许启用
        if (existing.getValidityType() != null && existing.getValidityType() == 1
            && existing.getValidEnd() != null
            && existing.getValidEnd().isBefore(LocalDateTime.now())) {
            return Result.fail("该优惠券已过期，请先编辑修改有效期后重新启用");
        }
        Coupon c = new Coupon();
        c.setId(id);
        c.setStatus(1);
        c.setUpdateTime(LocalDateTime.now());
        couponMapper.updateById(c);
        return Result.success(null);
    }

    @PostMapping("/{id}/disable")
    public Result disable(@PathVariable Long id) {
        Coupon existing = couponMapper.selectById(id);
        if (existing == null) return Result.fail("优惠券不存在");
        Coupon c = new Coupon();
        c.setId(id);
        c.setStatus(0);
        c.setUpdateTime(LocalDateTime.now());
        couponMapper.updateById(c);
        return Result.success(null);
    }

    @DeleteMapping("/{id}")
    public Result delete(@PathVariable Long id) {
        couponMapper.deleteById(id);
        return Result.success(null);
    }

    private Coupon buildCoupon(Map<String, Object> params) {
        Coupon c = new Coupon();
        c.setTitle((String) params.get("title"));
        String type = (String) params.get("type");
        if (type != null) c.setType("FIXED".equals(type) ? 1 : 2);

        Object minConsume = params.get("minConsume");
        if (minConsume instanceof String && !((String) minConsume).isEmpty())
            c.setMinConsume(new BigDecimal((String) minConsume));
        else if (minConsume instanceof Number)
            c.setMinConsume(BigDecimal.valueOf(((Number) minConsume).doubleValue()));

        Object discountAmount = params.get("discountAmount");
        if (discountAmount instanceof String && !((String) discountAmount).isEmpty())
            c.setDiscountAmount(new BigDecimal((String) discountAmount));
        else if (discountAmount instanceof Number)
            c.setDiscountAmount(BigDecimal.valueOf(((Number) discountAmount).doubleValue()));

        Object totalCount = params.get("totalCount");
        if (totalCount instanceof Number) c.setTotalCount(((Number) totalCount).intValue());
        Object perUserLimit = params.get("perUserLimit");
        if (perUserLimit instanceof Number) c.setPerUserLimit(((Number) perUserLimit).intValue());
        Object exchangePoints = params.get("exchangePoints");
        if (exchangePoints instanceof Number) c.setExchangePoints(((Number) exchangePoints).intValue());
        Object memberLevelRequired = params.get("memberLevelRequired");
        if (memberLevelRequired instanceof Number) c.setMemberLevelRequired(((Number) memberLevelRequired).intValue());
        Object validityType = params.get("validityType");
        if (validityType instanceof Number) c.setValidityType(((Number) validityType).intValue());
        else if (validityType instanceof String) c.setValidityType("2".equals(validityType) ? 2 : 1);
        Object validityDays = params.get("validityDays");
        if (validityDays instanceof Number) c.setValidityDays(((Number) validityDays).intValue());

        DateTimeFormatter fmt = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        Object validStart = params.get("validStart");
        if (validStart instanceof String && !((String) validStart).isEmpty())
            c.setValidStart(LocalDateTime.parse((String) validStart, fmt));
        Object validEnd = params.get("validEnd");
        if (validEnd instanceof String && !((String) validEnd).isEmpty())
            c.setValidEnd(LocalDateTime.parse((String) validEnd, fmt));
        return c;
    }

    private boolean validateTime(Map<String, Object> params) {
        Object validStart = params.get("validStart");
        Object validEnd = params.get("validEnd");
        if (validStart == null || validEnd == null) return true;
        if (!(validStart instanceof String) || !(validEnd instanceof String)) return true;
        String s1 = (String) validStart, s2 = (String) validEnd;
        if (s1.isEmpty() || s2.isEmpty()) return true;
        return s1.compareTo(s2) < 0;
    }
}
