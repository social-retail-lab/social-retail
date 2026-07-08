package com.socialretail.backend.dto.merchant;

import com.fasterxml.jackson.annotation.JsonFormat;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

public final class MerchantHomeApiModels {
    private MerchantHomeApiModels() {
    }

    public record MerchantHome(Long merchantId, String merchantName, String logo,
                               String shopAddress, String businessHours, String introduction,
                               String contactPhone, Integer status, String statusText,
                               MerchantStatistics statistics, List<MerchantCouponSummary> couponList,
                               List<MerchantProductSummary> recommendProducts) {
    }

    public record MerchantBasic(Long merchantId, String merchantName, String logo,
                                String shopAddress, String businessHours, String introduction,
                                String contactName, String contactPhone, Integer status,
                                String statusText,
                                @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss") LocalDateTime createTime) {
    }

    public record MerchantStatistics(int productCount, long totalSoldCount) {
    }

    public record MerchantCouponSummary(Long couponId, String title, Integer type, String typeText,
                                        BigDecimal minConsume, BigDecimal discountAmount,
                                        int remainingCount, Integer perUserLimit,
                                        boolean alreadyReceived,
                                        @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss") LocalDateTime validStart,
                                        @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss") LocalDateTime validEnd) {
    }

    public record MerchantProductSummary(Long productId, String title, String subTitle,
                                         String mainImage, long soldCount) {
    }

    public record MerchantProductItem(Long productId, String productName, String productImage,
                                      BigDecimal price, BigDecimal originalPrice,
                                      long soldCount, int stock, List<String> tags,
                                      Long merchantId, String merchantName, String promotionTitle) {
    }

    public record MerchantProductPage(Long merchantId, String merchantName,
                                      List<MerchantProductItem> list, long total, long pages,
                                      int page, int pageSize) {
    }

    public record MerchantProductSearchPage(Long merchantId, String merchantName, String keyword,
                                            List<MerchantProductItem> list, long total,
                                            long pages, int page, int pageSize) {
    }

    public record PickupPointItem(Long pickupPointId, Long merchantId, String name,
                                  String address, String contactPhone,
                                  String businessHours, String image) {
    }
}
