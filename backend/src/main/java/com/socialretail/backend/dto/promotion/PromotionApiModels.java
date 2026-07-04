package com.socialretail.backend.dto.promotion;

import com.fasterxml.jackson.annotation.JsonFormat;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

public final class PromotionApiModels {
    private PromotionApiModels() { }

    public record DiscountRuleAvailable(Long merchantId, String scene, BigDecimal orderAmount,
                                        List<DiscountRuleItem> list) { }
    public record DiscountRuleItem(Long ruleId, String title, Integer type, String typeText,
                                   BigDecimal minAmount, BigDecimal discountAmount,
                                   BigDecimal discountRate, Boolean available, BigDecimal needAmount,
                                   String showLabel, String promotionTag,
                                   @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss") LocalDateTime startTime,
                                   @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss") LocalDateTime endTime) { }
    public record MerchantCouponPage(Long merchantId, String merchantName,
                                     List<MerchantCouponItem> list, long total, long pages,
                                     int page, int pageSize) { }
    public record MerchantCouponItem(Long couponId, String title, Integer type, String typeText,
                                     BigDecimal minConsume, BigDecimal discountAmount,
                                     Integer totalCount, Integer receivedCount, Integer remainingCount,
                                     Integer perUserLimit, boolean alreadyReceived,
                                     @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss") LocalDateTime validStart,
                                     @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss") LocalDateTime validEnd) { }
    public record MerchantCouponReceive(Long couponUserId, Long couponId, Long merchantId,
                                        String merchantName, String title, Integer status,
                                        String statusText,
                                        @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss") LocalDateTime receiveTime,
                                        @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss") LocalDateTime validStart,
                                        @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss") LocalDateTime validEnd) { }
    public record MyCouponPage(List<MyCoupon> list, long total, long pages,
                               int page, int pageSize) { }
    public record MyCoupon(Long couponUserId, Long couponId, String source, String sourceText,
                           Long merchantId, String merchantName, String title, Integer type,
                           String typeText, BigDecimal minConsume, BigDecimal discountAmount,
                           Integer status, String statusText,
                           @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss") LocalDateTime receiveTime,
                           @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss") LocalDateTime useTime,
                           @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss") LocalDateTime validStart,
                           @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss") LocalDateTime validEnd) { }
    public record AvailableCouponResponse(BigDecimal settlementAmount, Long merchantId,
                                          String merchantName,
                                          List<AvailableCoupon> platformCoupons,
                                          List<AvailableCoupon> merchantCoupons,
                                          CouponUseRule useRule) { }
    public record AvailableCoupon(Long couponUserId, Long couponId, String source,
                                  String sourceText, Long merchantId, String merchantName,
                                  String title, Integer type, String typeText,
                                  BigDecimal minConsume, BigDecimal discountAmount,
                                  boolean available, String unavailableReason,
                                  boolean recommended, boolean selected,
                                  @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss") LocalDateTime receiveTime,
                                  @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss") LocalDateTime validStart,
                                  @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss") LocalDateTime validEnd) { }
    public record CouponUseRule(int maxPlatformCouponCount, int maxMerchantCouponCount,
                                boolean canStack, String description) { }
}
