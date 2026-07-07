package com.socialretail.backend.service.social.impl;

import com.socialretail.backend.common.PageResult;
import com.socialretail.backend.common.exception.BusinessException;
import com.socialretail.backend.dto.request.social.CommissionCalcRequest;
import com.socialretail.backend.dto.request.social.DistributorWithdrawRequest;
import com.socialretail.backend.dto.response.social.DistributorResponses;
import com.socialretail.backend.service.social.CommissionService;
import com.socialretail.backend.entity.order.Order;
import com.socialretail.backend.entity.order.OrderItem;
import org.springframework.http.HttpStatus;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.PreparedStatement;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.LinkedHashMap;

@Service
public class CommissionServiceImpl implements CommissionService {
    private final JdbcTemplate jdbc;

    public CommissionServiceImpl(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    @Override
    public PageResult<DistributorResponses.PromotionOrder> orders(
            Long userId, Integer status, String keyword, int page, int pageSize) {
        Long distributorId = requireDistributor(userId);
        Query from = commissionFrom(distributorId, status, keyword);
        Long total = jdbc.queryForObject("SELECT COUNT(*) " + from.sql(), Long.class, from.args().toArray());
        List<Object> args = pageArgs(from.args(), page, pageSize);
        List<DistributorResponses.PromotionOrder> list = jdbc.query("""
                SELECT cr.id commission_id, cr.order_id, o.order_sn, mdp.merchant_id,
                  m.merchant_name, p.id product_id, p.title product_name, p.main_image,
                  o.pay_amount order_amount, mdp.commission_rate, cr.commission_amount,
                  cr.status, o.complete_time order_finish_time,
                  COALESCE(cr.settlement_time, DATE_ADD(o.complete_time, INTERVAL 7 DAY)) settle_time
                """ + from.sql() + " ORDER BY o.complete_time DESC, cr.id DESC LIMIT ?, ?",
                (rs, n) -> new DistributorResponses.PromotionOrder(
                        rs.getLong("commission_id"), rs.getLong("order_id"), rs.getString("order_sn"),
                        rs.getLong("merchant_id"), rs.getString("merchant_name"), rs.getLong("product_id"),
                        rs.getString("product_name"), rs.getString("main_image"), rs.getBigDecimal("order_amount"),
                        rs.getBigDecimal("commission_rate"), rs.getBigDecimal("commission_amount"),
                        rs.getInt("status"), rs.getInt("status") == 1 ? "已结算" : "冻结中",
                        time(rs.getTimestamp("order_finish_time")), time(rs.getTimestamp("settle_time"))),
                args.toArray());
        return DistributorResponses.page(list, total == null ? 0 : total, page, pageSize);
    }

    @Override
    public DistributorResponses.SimplePage<DistributorResponses.CommissionDetail> details(
            Long userId, Integer status, int page, int size) {
        Long distributorId = requireDistributor(userId);
        String filter = status == null ? "" : " AND cr.status = ?";
        List<Object> args = new ArrayList<>(List.of(distributorId));
        if (status != null) args.add(status);
        Long total = jdbc.queryForObject("SELECT COUNT(*) FROM commission_record cr "
                + "WHERE cr.distributor_id = ?" + filter, Long.class, args.toArray());
        List<Object> paged = pageArgs(args, page, size);
        List<DistributorResponses.CommissionDetail> list = jdbc.query("""
                SELECT cr.id, cr.order_id, mdp.product_id, cr.commission_amount,
                  cr.status, cr.settlement_time, cr.create_time
                FROM commission_record cr
                JOIN distributor_product dp ON dp.id = cr.distributor_product_id
                JOIN merchant_distribution_product mdp ON mdp.id = dp.distribution_product_id
                WHERE cr.distributor_id = ?
                """ + filter + " ORDER BY cr.create_time DESC, cr.id DESC LIMIT ?, ?",
                (rs, n) -> new DistributorResponses.CommissionDetail(
                        rs.getLong("id"), rs.getLong("order_id"), rs.getLong("product_id"),
                        rs.getBigDecimal("commission_amount"), rs.getInt("status"),
                        time(rs.getTimestamp("settlement_time")), time(rs.getTimestamp("create_time"))),
                paged.toArray());
        return new DistributorResponses.SimplePage<>(total == null ? 0 : total, list);
    }

    @Override
    @Transactional
    public DistributorResponses.Withdraw withdraw(Long userId, DistributorWithdrawRequest request) {
        Long distributorId = requireDistributor(userId);
        BigDecimal amount = request.amount().setScale(2, RoundingMode.HALF_UP);
        int changed = jdbc.update("""
                UPDATE distributor SET available_commission = available_commission - ?,
                  frozen_commission = frozen_commission + ?, update_time = CURRENT_TIMESTAMP
                WHERE id = ? AND status = 1 AND available_commission >= ?
                """, amount, amount, distributorId, amount);
        if (changed == 0) throw error(40063, HttpStatus.BAD_REQUEST, "可提现佣金不足");
        LocalDateTime now = LocalDateTime.now();
        KeyHolder keys = new GeneratedKeyHolder();
        jdbc.update(connection -> {
            PreparedStatement ps = connection.prepareStatement("""
                    INSERT INTO withdraw_record
                    (distributor_id, amount, bank_name, bank_card_no, account_name, status, apply_time)
                    VALUES (?, ?, ?, ?, ?, 0, ?)
                    """, Statement.RETURN_GENERATED_KEYS);
            ps.setLong(1, distributorId); ps.setBigDecimal(2, amount);
            ps.setString(3, request.bankName().trim()); ps.setString(4, request.bankCardNo().trim());
            ps.setString(5, request.accountName().trim()); ps.setTimestamp(6, Timestamp.valueOf(now));
            return ps;
        }, keys);
        return new DistributorResponses.Withdraw(key(keys), amount, 0, now);
    }

    @Override
    public DistributorResponses.SimplePage<DistributorResponses.WithdrawRecord> withdrawRecords(
            Long userId, Integer status, int page, int size) {
        Long distributorId = requireDistributor(userId);
        String filter = status == null ? "" : " AND status = ?";
        List<Object> args = new ArrayList<>(List.of(distributorId));
        if (status != null) args.add(status);
        Long total = jdbc.queryForObject("SELECT COUNT(*) FROM withdraw_record WHERE distributor_id = ?" + filter,
                Long.class, args.toArray());
        List<DistributorResponses.WithdrawRecord> list = jdbc.query("""
                SELECT id, amount, bank_name, bank_card_no, account_name, status, apply_time
                FROM withdraw_record WHERE distributor_id = ?
                """ + filter + " ORDER BY apply_time DESC, id DESC LIMIT ?, ?",
                (rs, n) -> new DistributorResponses.WithdrawRecord(
                        rs.getLong("id"), rs.getBigDecimal("amount"), rs.getString("bank_name"),
                        maskBankCard(rs.getString("bank_card_no")), rs.getString("account_name"),
                        rs.getInt("status"), time(rs.getTimestamp("apply_time"))),
                pageArgs(args, page, size).toArray());
        return new DistributorResponses.SimplePage<>(total == null ? 0 : total, list);
    }

    @Override
    @Transactional
    public DistributorResponses.CommissionCalc calculate(CommissionCalcRequest request) {
        Integer count = jdbc.queryForObject("SELECT COUNT(*) FROM `order` WHERE id = ? AND user_id = ?",
                Integer.class, request.orderId(), request.userId());
        if (count == null || count == 0) throw error(40463, HttpStatus.NOT_FOUND, "订单不存在");
        List<DistributorResponses.CommissionCalcRecord> records = new ArrayList<>();
        BigDecimal total = BigDecimal.ZERO;
        for (CommissionCalcRequest.ProductItem item : request.productItems()) {
            List<Map<String, Object>> rows = jdbc.queryForList("""
                    SELECT dp.id, dp.distributor_id, mdp.product_id, mdp.commission_rate
                    FROM distributor_product dp
                    JOIN merchant_distribution_product mdp ON mdp.id = dp.distribution_product_id
                    JOIN distributor d ON d.id = dp.distributor_id
                    WHERE dp.id = ? AND dp.status = 1 AND mdp.status = 1 AND d.status = 1
                    """, item.distributionProductId());
            if (rows.isEmpty()) continue;
            Map<String, Object> row = rows.get(0);
            Long productId = number(row.get("product_id")).longValue();
            if (!productId.equals(item.productId()))
                throw error(40064, HttpStatus.BAD_REQUEST, "推广商品与订单商品不匹配");
            Long distributorId = number(row.get("distributor_id")).longValue();
            BigDecimal amount = item.price().multiply(BigDecimal.valueOf(item.quantity()))
                    .multiply(decimal(row.get("commission_rate")))
                    .divide(BigDecimal.valueOf(100), 2, RoundingMode.HALF_UP);
            BigDecimal saved = saveCommission(request.orderId(), distributorId,
                    item.distributionProductId(), amount);
            records.add(new DistributorResponses.CommissionCalcRecord(distributorId, saved, productId));
            total = total.add(saved);
        }
        return new DistributorResponses.CommissionCalc(request.orderId(), total, records);
    }

    @Override
    @Transactional
    public void createForPaidOrder(Order order, List<OrderItem> items, LocalDateTime payTime) {
        if (order == null || order.getId() == null || items == null || items.isEmpty()) return;
        LocalDateTime effectivePayTime = payTime == null ? LocalDateTime.now() : payTime;
        Map<Long, PaidCommission> commissions = new LinkedHashMap<>();
        for (OrderItem item : items) {
            BigDecimal amount = paidCommissionAmount(item, effectivePayTime);
            if (amount == null) continue;
            List<Map<String, Object>> relations = jdbc.queryForList("""
                    SELECT dp.distributor_id, mdp.product_id
                    FROM distributor_product dp
                    JOIN merchant_distribution_product mdp ON mdp.id=dp.distribution_product_id
                    JOIN distributor d ON d.id=dp.distributor_id
                    WHERE dp.id=? AND mdp.product_id=?
                      AND dp.status=1 AND mdp.status=1 AND d.status=1
                    """, item.getDistributorProductId(), item.getProductId());
            if (relations.isEmpty()) continue;
            Map<String, Object> relation = relations.get(0);
            Long distributorId = number(relation.get("distributor_id")).longValue();
            commissions.merge(item.getDistributorProductId(),
                    new PaidCommission(distributorId, amount),
                    (left, right) -> new PaidCommission(left.distributorId(),
                            left.amount().add(right.amount())));
        }
        commissions.forEach((distributorProductId, commission) ->
                saveCommission(order.getId(), commission.distributorId(),
                        distributorProductId, commission.amount()));
    }

    static BigDecimal paidCommissionAmount(OrderItem item, LocalDateTime payTime) {
        if (item == null || item.getDistributorProductId() == null || item.getCommissionRate() == null
                || item.getCommissionRate().signum() <= 0 || item.getAttributionExpiresAt() == null
                || !item.getAttributionExpiresAt().isAfter(payTime)) return null;
        BigDecimal baseAmount = item.getItemFinalAmount();
        if (baseAmount == null && item.getFinalPrice() != null && item.getQuantity() != null) {
            baseAmount = item.getFinalPrice().multiply(BigDecimal.valueOf(item.getQuantity()));
        }
        if (baseAmount == null || baseAmount.signum() <= 0) return null;
        BigDecimal amount = baseAmount.multiply(item.getCommissionRate())
                .divide(BigDecimal.valueOf(100), 2, RoundingMode.HALF_UP);
        return amount.signum() <= 0 ? null : amount;
    }

    @Override
    @Transactional
    public int settleDueCommissions() {
        List<Map<String, Object>> due = jdbc.queryForList("""
                SELECT cr.id, cr.distributor_id, cr.commission_amount
                FROM commission_record cr JOIN `order` o ON o.id = cr.order_id
                WHERE cr.status = 0 AND o.complete_time IS NOT NULL
                  AND o.complete_time <= DATE_SUB(NOW(), INTERVAL 7 DAY)
                ORDER BY cr.id LIMIT 200 FOR UPDATE SKIP LOCKED
                """);
        int settled = 0;
        for (Map<String, Object> row : due) {
            Long id = number(row.get("id")).longValue();
            BigDecimal amount = decimal(row.get("commission_amount"));
            if (jdbc.update("UPDATE commission_record SET status=1, settlement_time=NOW() "
                    + "WHERE id=? AND status=0", id) == 1) {
                jdbc.update("""
                        UPDATE distributor SET frozen_commission=GREATEST(frozen_commission-?, 0),
                          available_commission=available_commission+?, total_commission=total_commission+?,
                          update_time=NOW() WHERE id=?
                        """, amount, amount, amount, number(row.get("distributor_id")).longValue());
                settled++;
            }
        }
        return settled;
    }

    private BigDecimal saveCommission(Long orderId, Long distributorId, Long dpId, BigDecimal amount) {
        List<BigDecimal> existing = jdbc.query("SELECT commission_amount FROM commission_record "
                + "WHERE order_id=? AND distributor_product_id=?", (rs, n) -> rs.getBigDecimal(1), orderId, dpId);
        if (!existing.isEmpty()) return existing.get(0);
        int inserted = jdbc.update("""
                INSERT IGNORE INTO commission_record
                (distributor_id, distributor_product_id, order_id, commission_amount, status, create_time)
                VALUES (?, ?, ?, ?, 0, NOW())
                """, distributorId, dpId, orderId, amount);
        if (inserted == 1) {
            jdbc.update("UPDATE distributor SET frozen_commission=frozen_commission+?, update_time=NOW() WHERE id=?",
                    amount, distributorId);
            return amount;
        }
        return jdbc.queryForObject("SELECT commission_amount FROM commission_record "
                + "WHERE order_id=? AND distributor_product_id=?", BigDecimal.class, orderId, dpId);
    }

    private Query commissionFrom(Long distributorId, Integer status, String keyword) {
        StringBuilder sql = new StringBuilder("""
                FROM commission_record cr
                JOIN distributor_product dp ON dp.id=cr.distributor_product_id
                JOIN merchant_distribution_product mdp ON mdp.id=dp.distribution_product_id
                JOIN product p ON p.id=mdp.product_id JOIN merchant m ON m.id=mdp.merchant_id
                JOIN `order` o ON o.id=cr.order_id WHERE cr.distributor_id=?
                """);
        List<Object> args = new ArrayList<>(List.of(distributorId));
        if (status != null) { sql.append(" AND cr.status=?"); args.add(status); }
        if (keyword != null && !keyword.isBlank()) { sql.append(" AND p.title LIKE ?"); args.add("%" + keyword.trim() + "%"); }
        return new Query(sql.toString(), args);
    }

    private Long requireDistributor(Long userId) {
        List<Long> ids = jdbc.query("SELECT id FROM distributor WHERE user_id=? AND status=1",
                (rs, n) -> rs.getLong(1), userId);
        if (ids.isEmpty()) throw error(40361, HttpStatus.FORBIDDEN, "当前用户不是分销员");
        return ids.get(0);
    }

    static String maskBankCard(String card) {
        if (card == null || card.length() <= 4) return card;
        int prefix = Math.min(6, card.length() - 4);
        return card.substring(0, prefix) + "****" + card.substring(card.length() - 4);
    }

    private static List<Object> pageArgs(List<Object> source, int page, int size) {
        List<Object> args = new ArrayList<>(source); args.add((page - 1) * size); args.add(size); return args;
    }
    private static LocalDateTime time(Timestamp value) { return value == null ? null : value.toLocalDateTime(); }
    private static Number number(Object value) { return (Number) value; }
    private static BigDecimal decimal(Object value) { return value == null ? BigDecimal.ZERO : (BigDecimal) value; }
    private static Long key(KeyHolder keys) { if (keys.getKey() == null) throw new IllegalStateException("Generated key missing"); return keys.getKey().longValue(); }
    private static BusinessException error(int code, HttpStatus status, String message) { return new BusinessException(code, status, message); }
    private record Query(String sql, List<Object> args) { }
    private record PaidCommission(Long distributorId, BigDecimal amount) { }
}
