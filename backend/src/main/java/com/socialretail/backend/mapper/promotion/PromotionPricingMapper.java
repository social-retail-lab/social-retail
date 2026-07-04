package com.socialretail.backend.mapper.promotion;

import com.socialretail.backend.dto.promotion.PromotionCandidate;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Mapper
public interface PromotionPricingMapper {
    @Select("SELECT p.id promotion_id,p.title,t.min_amount,t.discount_amount " +
            "FROM platform_promotion p JOIN platform_promotion_tier t ON t.promotion_id=p.id " +
            "JOIN merchant_promotion_participation mp ON mp.promotion_id=p.id " +
            "WHERE mp.merchant_id=#{merchantId} AND mp.status=1 AND p.status=1 " +
            "AND p.start_time<=#{now} AND p.end_time>#{now} AND t.min_amount<=#{amount} " +
            "ORDER BY t.discount_amount DESC,t.min_amount DESC,p.end_time,p.id")
    List<PromotionCandidate> selectAvailable(@Param("merchantId") Long merchantId,
                                             @Param("amount") BigDecimal amount,
                                             @Param("now") LocalDateTime now);
}
