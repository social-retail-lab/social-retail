package com.socialretail.backend.dto.response.social;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.socialretail.backend.common.PageResult;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

public final class DistributorResponses {
    private DistributorResponses() { }

    public record Apply(Long applyId, Integer auditStatus, String auditStatusText,
                        @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss") LocalDateTime applyTime) { }
    public record Status(Boolean isDistributor, Integer auditStatus, String auditStatusText,
                         String realName, String bankName, String bankCardTailNo,
                         @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss") LocalDateTime applyTime,
                         @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss") LocalDateTime auditTime,
                         String auditRemark) { }
    public record Dashboard(Long distributorId, BigDecimal totalCommission, BigDecimal frozenCommission,
                            Integer promotionProductCount, Integer promotionOrderCount,
                            BigDecimal todayCommission, List<QuickMenu> quickMenus) { }
    public record QuickMenu(String name, String path) { }
    public record AvailableProduct(Long distributionProductId, Long merchantId, String merchantName,
                                   Long productId, String productName, String mainImage, BigDecimal price,
                                   BigDecimal commissionRate, Boolean alreadyPromoted) { }
    public record Promote(Long distributorProductId, String promotionCode) { }
    public record ShareLink(String promotionCode, String promotionUrl, String qrCode) { }
    public record MyProduct(Long distributorProductId, Long distributionProductId, Long merchantId,
                            String merchantName, Long productId, String productName, String mainImage,
                            BigDecimal price, BigDecimal commissionRate, String promotionCode,
                            String promotionUrl, String qrCode, Integer status, String statusText,
                            @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss") LocalDateTime createTime) { }
    public record MyProductDetail(Long distributorProductId, Long distributionProductId, Long merchantId,
                                  String merchantName, Long productId, String productName, String subTitle,
                                  String mainImage, BigDecimal price, BigDecimal commissionRate,
                                  String promotionCode, String promotionUrl, String qrCode,
                                  Integer status, String statusText,
                                  @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss") LocalDateTime createTime,
                                  List<DistributionRecord> distributionRecords) { }
    public record DistributionRecord(Long commissionId, Long orderId, String orderSn, Long buyerId,
                                     BigDecimal orderAmount, BigDecimal commissionAmount,
                                     Integer commissionStatus, String commissionStatusText,
                                     @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss") LocalDateTime orderTime,
                                     @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss") LocalDateTime settlementTime) { }
    public record PromotionStatus(Long distributorProductId, Integer status, String statusText) { }
    public record PromotionOrder(Long commissionId, Long orderId, String orderSn, Long merchantId,
                                 String merchantName, Long productId, String productName, String mainImage,
                                 BigDecimal orderAmount, BigDecimal commissionRate, BigDecimal commissionAmount,
                                 Integer status, String statusText,
                                 @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss") LocalDateTime orderFinishTime,
                                 @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss") LocalDateTime settleTime) { }
    public record CommissionDetail(Long recordId, Long orderId, Long productId, BigDecimal commissionAmount,
                                   Integer status,
                                   @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss") LocalDateTime settlementTime,
                                   @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss") LocalDateTime createTime) { }
    public record SimplePage<T>(Long total, List<T> list) { }
    public record Withdraw(Long withdrawId, BigDecimal amount, Integer status,
                           @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss") LocalDateTime applyTime) { }
    public record WithdrawRecord(Long withdrawId, BigDecimal amount, String bankName, String bankCardNo,
                                 String accountName, Integer status,
                                 @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss") LocalDateTime applyTime) { }
    public record CommissionCalc(Long orderId, BigDecimal totalCommission,
                                 List<CommissionCalcRecord> records) { }
    public record CommissionCalcRecord(Long distributorId, BigDecimal commissionAmount, Long productId) { }

    public static <T> PageResult<T> page(List<T> list, long total, int page, int pageSize) {
        return PageResult.of(list, total, page, pageSize);
    }
}
