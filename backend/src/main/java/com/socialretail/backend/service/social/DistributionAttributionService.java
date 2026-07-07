package com.socialretail.backend.service.social;

import com.socialretail.backend.common.exception.BusinessException;
import org.springframework.http.HttpStatus;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.math.BigDecimal;
import java.util.List;

@Service
public class DistributionAttributionService {
    public static final int ATTRIBUTION_DAYS = 7;

    private final JdbcTemplate jdbcTemplate;

    public DistributionAttributionService(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public Attribution resolve(String promotionCode, Long productId) {
        if (!StringUtils.hasText(promotionCode)) return null;
        List<Attribution> rows = jdbcTemplate.query("""
                SELECT dp.id distributor_product_id, dp.promotion_code, mdp.product_id,
                       mdp.commission_rate
                FROM distributor_product dp
                JOIN merchant_distribution_product mdp ON mdp.id = dp.distribution_product_id
                JOIN distributor d ON d.id = dp.distributor_id
                WHERE dp.promotion_code = ? AND mdp.product_id = ?
                  AND dp.status = 1 AND mdp.status = 1 AND d.status = 1
                LIMIT 1
                """, (rs, rowNum) -> new Attribution(
                rs.getLong("distributor_product_id"), rs.getString("promotion_code"),
                rs.getLong("product_id"), rs.getBigDecimal("commission_rate")),
                promotionCode.trim(), productId);
        if (rows.isEmpty()) {
            throw new BusinessException(40464, HttpStatus.NOT_FOUND,
                    "推广码不存在、已失效或与当前商品不匹配");
        }
        return rows.get(0);
    }

    public record Attribution(Long distributorProductId, String promotionCode,
                              Long productId, BigDecimal commissionRate) {
    }
}
