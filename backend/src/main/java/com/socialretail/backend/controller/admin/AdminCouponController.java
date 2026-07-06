package com.socialretail.backend.controller.admin;

import com.socialretail.backend.common.Result;
import com.socialretail.backend.entity.promotion.Coupon;
import com.socialretail.backend.service.promotion.CouponService;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.Map;

@RestController
@RequestMapping("/api/admin/coupons")
public class AdminCouponController {

    private final CouponService couponService;

    public AdminCouponController(CouponService couponService) {
        this.couponService = couponService;
    }

    @GetMapping
    public Result list(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) Integer type,
            @RequestParam(required = false) Integer status) {
        return Result.success(couponService.listCoupons(keyword, type, status));
    }

    @GetMapping("/{id}")
    public Result get(@PathVariable Long id) {
        return Result.success(couponService.getById(id));
    }

    @PostMapping
    public Result create(@RequestBody Map<String, Object> body) {
        Coupon coupon = buildCoupon(body);
        return Result.success(couponService.createCoupon(coupon));
    }

    @PutMapping("/{id}")
    public Result update(@PathVariable Long id, @RequestBody Map<String, Object> body) {
        Coupon coupon = buildCoupon(body);
        return Result.success(couponService.updateCoupon(id, coupon));
    }

    @DeleteMapping("/{id}")
    public Result delete(@PathVariable Long id) {
        couponService.deleteCoupon(id);
        return Result.success(null);
    }

    @PostMapping("/{id}/disable")
    public Result disable(@PathVariable Long id) {
        couponService.disableCoupon(id);
        return Result.success(null);
    }

    @PostMapping("/{id}/enable")
    public Result enable(@PathVariable Long id) {
        Coupon coupon = new Coupon();
        coupon.setId(id);
        coupon.setStatus(1);
        couponService.updateCoupon(id, coupon);
        return Result.success(null);
    }

    private Coupon buildCoupon(Map<String, Object> body) {
        Coupon coupon = new Coupon();
        if (body.get("title") != null) {
            coupon.setTitle((String) body.get("title"));
        }
        if (body.get("type") != null) {
            Object typeVal = body.get("type");
            if (typeVal instanceof String) {
                String typeStr = (String) typeVal;
                if ("FIXED".equalsIgnoreCase(typeStr)) {
                    coupon.setType(1);
                } else if ("FULL_REDUCTION".equalsIgnoreCase(typeStr)) {
                    coupon.setType(2);
                }
            } else if (typeVal instanceof Number) {
                coupon.setType(((Number) typeVal).intValue());
            }
        }
        if (body.get("discountAmount") != null) {
            coupon.setDiscountAmount(new BigDecimal(String.valueOf(body.get("discountAmount"))));
        }
        if (body.get("minConsume") != null) {
            coupon.setMinConsume(new BigDecimal(String.valueOf(body.get("minConsume"))));
        } else {
            coupon.setMinConsume(new BigDecimal("0.01"));
        }
        if (body.get("totalCount") != null) {
            coupon.setTotalCount(((Number) body.get("totalCount")).intValue());
        }
        if (body.get("perUserLimit") != null) {
            coupon.setPerUserLimit(((Number) body.get("perUserLimit")).intValue());
        }
        if (body.get("exchangePoints") != null) {
            coupon.setExchangePoints(((Number) body.get("exchangePoints")).intValue());
        }
        if (body.get("validityType") != null) {
            coupon.setValidityType(((Number) body.get("validityType")).intValue());
        }
        if (body.get("validityDays") != null) {
            coupon.setValidityDays(((Number) body.get("validityDays")).intValue());
        }
        if (body.get("validStart") != null) {
            coupon.setValidStart(parseDateTime((String) body.get("validStart")));
        }
        if (body.get("validEnd") != null) {
            coupon.setValidEnd(parseDateTime((String) body.get("validEnd")));
        }
        return coupon;
    }

    private LocalDateTime parseDateTime(String str) {
        if (str == null || str.isEmpty()) return null;
        try {
            if (str.length() == 10) {
                // "2026-07-01" → add time
                return LocalDateTime.parse(str + "T00:00:00");
            }
            if (str.length() == 16) {
                // "2026-07-01T12:00" from datetime-local
                return LocalDateTime.parse(str + ":00");
            }
            return LocalDateTime.parse(str);
        } catch (Exception e) {
            // try replacing space with T
            return LocalDateTime.parse(str.replace(" ", "T"));
        }
    }
}
