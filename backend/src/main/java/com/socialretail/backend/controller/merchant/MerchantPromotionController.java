package com.socialretail.backend.controller.merchant;

import com.socialretail.backend.common.result.Result;
import com.socialretail.backend.entity.promotion.MerchantCoupon;
import com.socialretail.backend.service.merchant.MerchantCouponService;
import com.socialretail.backend.service.promotion.PromotionService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.annotation.Resource;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/merchant/promotions")
public class MerchantPromotionController {

    private final PromotionService promotionService;
    private final MerchantCouponService merchantCouponService;

    public MerchantPromotionController(PromotionService promotionService, MerchantCouponService merchantCouponService) {
        this.promotionService = promotionService;
        this.merchantCouponService = merchantCouponService;
    }

    private Long getMerchantId(HttpServletRequest request) {
        return (Long) request.getAttribute("merchantId");
    }

    // ===== 平台活动 =====
    @GetMapping("/platform")
    public Result platformPromotions(HttpServletRequest request) {
        Long merchantId = getMerchantId(request);
        return Result.success(promotionService.getMerchantPromotions(merchantId));
    }

    @PostMapping("/platform/{promotionId}/join")
    public Result join(@PathVariable Long promotionId, HttpServletRequest request) {
        promotionService.participatePromotion(getMerchantId(request), promotionId);
        return Result.success(null);
    }

    @PostMapping("/platform/{promotionId}/quit")
    public Result quit(@PathVariable Long promotionId, HttpServletRequest request) {
        promotionService.quitPromotion(getMerchantId(request), promotionId);
        return Result.success(null);
    }

    // ===== 商家优惠卷 =====
    @GetMapping("/coupons")
    public Result couponList(HttpServletRequest request) {
        return Result.success(merchantCouponService.listCoupons(getMerchantId(request)));
    }

    @PostMapping("/coupons")
    public Result createCoupon(@RequestBody Map<String, Object> body, HttpServletRequest request) {
        Long merchantId = getMerchantId(request);
        MerchantCoupon coupon = buildCoupon(body);
        List<Map<String, BigDecimal>> tiers = parseTiers(body.get("tiers"));
        return Result.success(merchantCouponService.createCoupon(merchantId, coupon, tiers));
    }

    @PutMapping("/coupons/{id}")
    public Result updateCoupon(@PathVariable Long id, @RequestBody Map<String, Object> body, HttpServletRequest request) {
        Long merchantId = getMerchantId(request);
        MerchantCoupon coupon = buildCoupon(body);
        List<Map<String, BigDecimal>> tiers = parseTiers(body.get("tiers"));
        return Result.success(merchantCouponService.updateCoupon(merchantId, id, coupon));
    }

    @PostMapping("/coupons/{id}/disable")
    public Result disableCoupon(@PathVariable Long id, HttpServletRequest request) {
        merchantCouponService.disableCoupon(getMerchantId(request), id);
        return Result.success(null);
    }

    @PostMapping("/coupons/{id}/enable")
    public Result enableCoupon(@PathVariable Long id, HttpServletRequest request) {
        merchantCouponService.enableCoupon(getMerchantId(request), id);
        return Result.success(null);
    }

    // ===== 辅助方法 =====
    private MerchantCoupon buildCoupon(Map<String, Object> body) {
        MerchantCoupon coupon = new MerchantCoupon();
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
