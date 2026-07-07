package com.socialretail.backend.service.social.impl;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.MultiFormatWriter;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.socialretail.backend.common.PageResult;
import com.socialretail.backend.common.ImageUrlResolver;
import com.socialretail.backend.common.exception.BusinessException;
import com.socialretail.backend.dto.request.social.DistributorApplyRequest;
import com.socialretail.backend.dto.response.social.DistributorResponses;
import com.socialretail.backend.service.social.DistributorService;
import com.socialretail.backend.service.file.LocalImageStorageService;
import com.socialretail.backend.enums.file.ImageUploadType;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.http.HttpStatus;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.nio.file.Files;
import java.nio.file.Path;
import java.sql.PreparedStatement;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.UUID;

@Service
public class DistributorServiceImpl implements DistributorService {
    private final JdbcTemplate jdbc;
    private final LocalImageStorageService imageStorageService;
    private final ImageUrlResolver imageUrlResolver;
    private final Path uploadPath;
    private final String uploadBaseUrl;
    private final String shareBaseUrl;

    public DistributorServiceImpl(JdbcTemplate jdbc,
                                  LocalImageStorageService imageStorageService,
                                  ImageUrlResolver imageUrlResolver,
                                  @Value("${upload.path}") String uploadPath,
                                  @Value("${upload.base-url:}") String uploadBaseUrl,
                                  @Value("${distributor.share-base-url:http://localhost:8081}") String shareBaseUrl) {
        this.jdbc = jdbc;
        this.imageStorageService = imageStorageService;
        this.imageUrlResolver = imageUrlResolver;
        this.uploadPath = Path.of(uploadPath);
        this.uploadBaseUrl = trimSlash(uploadBaseUrl);
        this.shareBaseUrl = trimSlash(shareBaseUrl);
    }

    @Override
    @Transactional
    public DistributorResponses.Apply apply(Long userId, DistributorApplyRequest request) {
        if (exists("SELECT id FROM distributor WHERE user_id=? LIMIT 1", userId))
            throw error(40962, HttpStatus.CONFLICT, "当前用户已是分销员");
        if (exists("SELECT id FROM distributor_apply WHERE user_id=? AND audit_status=0 LIMIT 1", userId))
            throw error(40961, HttpStatus.CONFLICT, "您已提交分销员申请，请勿重复申请");
        String idCardFront = imageStorageService.validateDistributorIdCard(
                userId, request.idCardFront(), ImageUploadType.DISTRIBUTOR_IDCARD_FRONT);
        String idCardBack = imageStorageService.validateDistributorIdCard(
                userId, request.idCardBack(), ImageUploadType.DISTRIBUTOR_IDCARD_BACK);
        LocalDateTime now = LocalDateTime.now();
        KeyHolder keys = new GeneratedKeyHolder();
        try {
            jdbc.update(connection -> {
                PreparedStatement ps = connection.prepareStatement("""
                        INSERT INTO distributor_apply
                        (user_id, real_name, id_card_no, id_card_front, id_card_back, bank_name,
                         bank_card_no, bank_account_name, audit_status, apply_time)
                        VALUES (?, ?, ?, ?, ?, ?, ?, ?, 0, ?)
                        """, Statement.RETURN_GENERATED_KEYS);
                ps.setLong(1, userId); ps.setString(2, request.realName().trim());
                ps.setString(3, request.idCardNo().trim()); ps.setString(4, idCardFront);
                ps.setString(5, idCardBack); ps.setString(6, request.bankName().trim());
                ps.setString(7, request.bankCardNo().trim()); ps.setString(8, request.bankAccountName().trim());
                ps.setTimestamp(9, Timestamp.valueOf(now)); return ps;
            }, keys);
        } catch (DuplicateKeyException exception) {
            throw error(40961, HttpStatus.CONFLICT, "您已提交分销员申请，请勿重复申请");
        }
        return new DistributorResponses.Apply(key(keys), 0, "待审核", now);
    }

    @Override
    public DistributorResponses.Status status(Long userId) {
        boolean isDistributor = exists("SELECT id FROM distributor WHERE user_id=? AND status=1 LIMIT 1", userId);
        List<Map<String, Object>> rows = jdbc.queryForList("""
                SELECT audit_status, real_name, bank_name, bank_card_no, apply_time, audit_time, audit_remark
                FROM distributor_apply WHERE user_id=? ORDER BY apply_time DESC, id DESC LIMIT 1
                """, userId);
        if (rows.isEmpty()) return new DistributorResponses.Status(isDistributor, null, "未申请", null, null,
                null, null, null, null);
        Map<String, Object> row = rows.get(0);
        int audit = number(row.get("audit_status")).intValue();
        return new DistributorResponses.Status(isDistributor, audit, auditText(audit), string(row.get("real_name")),
                string(row.get("bank_name")), bankTail(string(row.get("bank_card_no"))),
                time(row.get("apply_time")), time(row.get("audit_time")), string(row.get("audit_remark")));
    }

    @Override
    public DistributorResponses.Dashboard dashboard(Long userId) {
        Map<String, Object> distributor = requireDistributor(userId);
        Long id = number(distributor.get("id")).longValue();
        Integer products = jdbc.queryForObject("SELECT COUNT(*) FROM distributor_product WHERE distributor_id=? AND status=1", Integer.class, id);
        Integer orders = jdbc.queryForObject("SELECT COUNT(*) FROM commission_record WHERE distributor_id=?", Integer.class, id);
        java.math.BigDecimal today = jdbc.queryForObject("SELECT COALESCE(SUM(commission_amount),0) FROM commission_record WHERE distributor_id=? AND create_time>=CURRENT_DATE", java.math.BigDecimal.class, id);
        List<DistributorResponses.QuickMenu> menus = List.of(
                new DistributorResponses.QuickMenu("推广商品", "/pages/distributor/products"),
                new DistributorResponses.QuickMenu("推广订单", "/pages/distributor/orders"),
                new DistributorResponses.QuickMenu("佣金明细", "/pages/distributor/commissions"),
                new DistributorResponses.QuickMenu("佣金提现", "/pages/distributor/withdraw"));
        return new DistributorResponses.Dashboard(id, decimal(distributor.get("total_commission")),
                decimal(distributor.get("frozen_commission")), products, orders, today, menus);
    }

    @Override
    public PageResult<DistributorResponses.AvailableProduct> products(
            Long userId, String keyword, Long merchantId, int page, int pageSize) {
        Long distributorId = number(requireDistributor(userId).get("id")).longValue();
        StringBuilder where = new StringBuilder(" WHERE mdp.status=1 AND p.status=1 AND m.status=1");
        List<Object> filters = new ArrayList<>();
        if (keyword != null && !keyword.isBlank()) { where.append(" AND p.title LIKE ?"); filters.add("%" + keyword.trim() + "%"); }
        if (merchantId != null) { where.append(" AND mdp.merchant_id=?"); filters.add(merchantId); }
        String from = """
                FROM merchant_distribution_product mdp JOIN product p ON p.id=mdp.product_id
                JOIN merchant m ON m.id=mdp.merchant_id
                LEFT JOIN (SELECT product_id, MIN(price) price FROM sku GROUP BY product_id) s ON s.product_id=p.id
                """ + where;
        Long total = jdbc.queryForObject("SELECT COUNT(*) " + from, Long.class, filters.toArray());
        List<Object> args = new ArrayList<>(List.of(distributorId)); args.addAll(filters);
        args.add((page - 1) * pageSize); args.add(pageSize);
        List<DistributorResponses.AvailableProduct> list = jdbc.query("""
                SELECT mdp.id distribution_product_id, mdp.merchant_id, m.merchant_name,
                  p.id product_id, p.title product_name, p.main_image, s.price, mdp.commission_rate,
                  EXISTS(SELECT 1 FROM distributor_product dp WHERE dp.distributor_id=?
                    AND dp.distribution_product_id=mdp.id) already_promoted
                """ + from + " ORDER BY mdp.create_time DESC, mdp.id DESC LIMIT ?, ?",
                (rs, n) -> new DistributorResponses.AvailableProduct(
                        rs.getLong("distribution_product_id"), rs.getLong("merchant_id"),
                        rs.getString("merchant_name"), rs.getLong("product_id"), rs.getString("product_name"),
                        imageUrlResolver.resolve(rs.getString("main_image")),
                        rs.getBigDecimal("price"), rs.getBigDecimal("commission_rate"),
                        rs.getBoolean("already_promoted")), args.toArray());
        return DistributorResponses.page(list, total == null ? 0 : total, page, pageSize);
    }

    @Override
    @Transactional
    public DistributorResponses.Promote promote(Long userId, Long distributionProductId) {
        Long distributorId = number(requireDistributor(userId).get("id")).longValue();
        List<Map<String, Object>> product = jdbc.queryForList("SELECT product_id FROM merchant_distribution_product WHERE id=? AND status=1", distributionProductId);
        if (product.isEmpty()) throw error(40461, HttpStatus.NOT_FOUND, "分销商品不存在或已关闭分销");
        List<Map<String, Object>> existing = promotion(distributorId, distributionProductId);
        if (!existing.isEmpty()) return promote(existing.get(0));
        String code = "PR" + LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss", Locale.ROOT))
                + UUID.randomUUID().toString().replace("-", "").substring(0, 8).toUpperCase(Locale.ROOT);
        String url = shareBaseUrl + "/product/" + number(product.get(0).get("product_id")).longValue() + "?promotionCode=" + code;
        KeyHolder keys = new GeneratedKeyHolder();
        try {
            jdbc.update(connection -> {
                PreparedStatement ps = connection.prepareStatement("INSERT INTO distributor_product "
                        + "(distributor_id,distribution_product_id,promotion_code,promotion_url,status,create_time) "
                        + "VALUES(?,?,?,?,1,NOW())", Statement.RETURN_GENERATED_KEYS);
                ps.setLong(1, distributorId); ps.setLong(2, distributionProductId); ps.setString(3, code); ps.setString(4, url); return ps;
            }, keys);
            return new DistributorResponses.Promote(key(keys), code);
        } catch (DuplicateKeyException exception) {
            return promote(promotion(distributorId, distributionProductId).get(0));
        }
    }

    @Override
    @Transactional
    public DistributorResponses.ShareLink shareLink(Long userId, Long distributorProductId) {
        Long distributorId = number(requireDistributor(userId).get("id")).longValue();
        List<Map<String, Object>> rows = jdbc.queryForList("SELECT promotion_code,promotion_url,qr_code FROM distributor_product WHERE id=? AND distributor_id=? AND status=1", distributorProductId, distributorId);
        if (rows.isEmpty()) throw error(40462, HttpStatus.NOT_FOUND, "推广商品不存在");
        Map<String, Object> row = rows.get(0); String code = string(row.get("promotion_code"));
        String url = string(row.get("promotion_url")); String qr = string(row.get("qr_code"));
        if (qr == null || qr.isBlank()) { qr = generateQr(code, url); jdbc.update("UPDATE distributor_product SET qr_code=? WHERE id=?", qr, distributorProductId); }
        return new DistributorResponses.ShareLink(code, url, imageUrlResolver.resolve(qr));
    }

    @Override
    public PageResult<DistributorResponses.MyProduct> myProducts(Long userId, String keyword, Integer status, int page, int pageSize) {
        Long distributorId = number(requireDistributor(userId).get("id")).longValue();
        StringBuilder filter = new StringBuilder(" WHERE dp.distributor_id=?"); List<Object> args = new ArrayList<>(List.of(distributorId));
        if (keyword != null && !keyword.isBlank()) { filter.append(" AND p.title LIKE ?"); args.add("%" + keyword.trim() + "%"); }
        if (status != null) { filter.append(" AND dp.status=?"); args.add(status); }
        String from = """
                FROM distributor_product dp JOIN merchant_distribution_product mdp ON mdp.id=dp.distribution_product_id
                JOIN product p ON p.id=mdp.product_id JOIN merchant m ON m.id=mdp.merchant_id
                LEFT JOIN (SELECT product_id,MIN(price) price FROM sku GROUP BY product_id) s ON s.product_id=p.id
                """ + filter;
        Long total = jdbc.queryForObject("SELECT COUNT(*) " + from, Long.class, args.toArray());
        args.add((page - 1) * pageSize); args.add(pageSize);
        List<DistributorResponses.MyProduct> list = jdbc.query("""
                SELECT dp.id,dp.distribution_product_id,mdp.merchant_id,m.merchant_name,p.id product_id,
                  p.title product_name,p.main_image,s.price,mdp.commission_rate,dp.promotion_code,
                  dp.promotion_url,dp.qr_code,dp.status,dp.create_time
                """ + from + " ORDER BY dp.create_time DESC,dp.id DESC LIMIT ?,?",
                (rs, n) -> new DistributorResponses.MyProduct(rs.getLong("id"), rs.getLong("distribution_product_id"),
                        rs.getLong("merchant_id"), rs.getString("merchant_name"), rs.getLong("product_id"),
                        rs.getString("product_name"), imageUrlResolver.resolve(rs.getString("main_image")),
                        rs.getBigDecimal("price"),
                        rs.getBigDecimal("commission_rate"), rs.getString("promotion_code"), rs.getString("promotion_url"),
                        imageUrlResolver.resolve(rs.getString("qr_code")), rs.getInt("status"),
                        rs.getInt("status") == 1 ? "推广中" : "已停用",
                        rs.getTimestamp("create_time").toLocalDateTime()), args.toArray());
        return DistributorResponses.page(list, total == null ? 0 : total, page, pageSize);
    }

    @Override
    @Transactional
    public DistributorResponses.MyProductDetail myProductDetail(Long userId, Long distributorProductId) {
        Long distributorId = number(requireDistributor(userId).get("id")).longValue();
        List<Map<String, Object>> rows = jdbc.queryForList("""
                SELECT dp.id distributor_product_id, dp.distribution_product_id,
                  mdp.merchant_id, m.merchant_name, p.id product_id, p.title product_name,
                  p.sub_title, p.main_image, s.price, mdp.commission_rate,
                  dp.promotion_code, dp.promotion_url, dp.qr_code, dp.status, dp.create_time
                FROM distributor_product dp
                JOIN merchant_distribution_product mdp ON mdp.id=dp.distribution_product_id
                JOIN product p ON p.id=mdp.product_id
                JOIN merchant m ON m.id=mdp.merchant_id
                LEFT JOIN (SELECT product_id,MIN(price) price FROM sku GROUP BY product_id) s
                  ON s.product_id=p.id
                WHERE dp.id=? AND dp.distributor_id=?
                """, distributorProductId, distributorId);
        if (rows.isEmpty()) {
            throw error(40461, HttpStatus.NOT_FOUND, "推广商品不存在");
        }
        Map<String, Object> row = rows.get(0);
        String promotionCode = string(row.get("promotion_code"));
        String promotionUrl = string(row.get("promotion_url"));
        String qrCode = string(row.get("qr_code"));
        if (qrCode == null || qrCode.isBlank()) {
            qrCode = generateQr(promotionCode, promotionUrl);
            jdbc.update("UPDATE distributor_product SET qr_code=? WHERE id=? AND distributor_id=?",
                    qrCode, distributorProductId, distributorId);
        }

        List<DistributorResponses.DistributionRecord> records = jdbc.query("""
                SELECT cr.id commission_id, cr.order_id, o.order_sn, o.user_id buyer_id,
                  o.pay_amount order_amount, cr.commission_amount, cr.status commission_status,
                  o.create_time order_time, cr.settlement_time
                FROM commission_record cr
                JOIN `order` o ON o.id=cr.order_id
                WHERE cr.distributor_id=? AND cr.distributor_product_id=?
                ORDER BY o.create_time DESC, cr.id DESC
                """, (rs, n) -> {
                    int commissionStatus = rs.getInt("commission_status");
                    return new DistributorResponses.DistributionRecord(
                            rs.getLong("commission_id"), rs.getLong("order_id"),
                            rs.getString("order_sn"), rs.getLong("buyer_id"),
                            rs.getBigDecimal("order_amount"), rs.getBigDecimal("commission_amount"),
                            commissionStatus, commissionStatus == 1 ? "已结算" : "冻结中",
                            time(rs.getObject("order_time")), time(rs.getObject("settlement_time")));
                }, distributorId, distributorProductId);
        int status = number(row.get("status")).intValue();
        return new DistributorResponses.MyProductDetail(
                number(row.get("distributor_product_id")).longValue(),
                number(row.get("distribution_product_id")).longValue(),
                number(row.get("merchant_id")).longValue(), string(row.get("merchant_name")),
                number(row.get("product_id")).longValue(), string(row.get("product_name")),
                string(row.get("sub_title")), imageUrlResolver.resolve(string(row.get("main_image"))),
                decimalOrNull(row.get("price")), decimal(row.get("commission_rate")),
                promotionCode, promotionUrl, imageUrlResolver.resolve(qrCode),
                status, promotionStatusText(status),
                time(row.get("create_time")), records);
    }

    @Override
    @Transactional
    public DistributorResponses.PromotionStatus disablePromotion(
            Long userId, Long distributorProductId) {
        return changePromotionStatus(userId, distributorProductId, 0);
    }

    @Override
    @Transactional
    public DistributorResponses.PromotionStatus enablePromotion(
            Long userId, Long distributorProductId) {
        return changePromotionStatus(userId, distributorProductId, 1);
    }

    private DistributorResponses.PromotionStatus changePromotionStatus(
            Long userId, Long distributorProductId, int targetStatus) {
        Long distributorId = number(requireDistributor(userId).get("id")).longValue();
        List<Integer> statuses = jdbc.query("""
                SELECT status FROM distributor_product WHERE id=? AND distributor_id=?
                """, (rs, n) -> rs.getInt(1), distributorProductId, distributorId);
        if (statuses.isEmpty()) {
            throw error(40461, HttpStatus.NOT_FOUND, "推广商品不存在");
        }
        if (statuses.get(0) != targetStatus) {
            jdbc.update("UPDATE distributor_product SET status=? WHERE id=? AND distributor_id=?",
                    targetStatus, distributorProductId, distributorId);
        }
        return new DistributorResponses.PromotionStatus(
                distributorProductId, targetStatus, promotionStatusText(targetStatus));
    }

    private Map<String, Object> requireDistributor(Long userId) {
        List<Map<String, Object>> rows = jdbc.queryForList("SELECT id,total_commission,frozen_commission FROM distributor WHERE user_id=? AND status=1", userId);
        if (rows.isEmpty()) throw error(40361, HttpStatus.FORBIDDEN, "当前用户不是分销员"); return rows.get(0);
    }
    private List<Map<String, Object>> promotion(Long distributorId, Long productId) { return jdbc.queryForList("SELECT id,promotion_code FROM distributor_product WHERE distributor_id=? AND distribution_product_id=? LIMIT 1", distributorId, productId); }
    private boolean exists(String sql, Object... args) { return !jdbc.queryForList(sql, args).isEmpty(); }
    private String generateQr(String code, String url) {
        try { Path directory = uploadPath.resolve("qrcode").normalize(); Files.createDirectories(directory); Path target = directory.resolve(code + ".png").normalize();
            if (!target.startsWith(directory)) throw new IllegalStateException("Invalid path");
            MatrixToImageWriter.writeToPath(new MultiFormatWriter().encode(url, BarcodeFormat.QR_CODE, 320, 320), "PNG", target);
            String relative = "/uploads/qrcode/" + code + ".png"; return uploadBaseUrl.isBlank() ? relative : uploadBaseUrl + relative;
        } catch (Exception exception) { throw error(50061, HttpStatus.INTERNAL_SERVER_ERROR, "二维码生成失败"); }
    }
    private static DistributorResponses.Promote promote(Map<String, Object> row) { return new DistributorResponses.Promote(number(row.get("id")).longValue(), string(row.get("promotion_code"))); }
    private static String auditText(int status) { return switch (status) { case 0 -> "待审核"; case 1 -> "审核通过"; case 2 -> "审核拒绝"; default -> "未知状态"; }; }
    private static String bankTail(String card) { return card == null ? null : card.substring(Math.max(0, card.length() - 4)); }
    private static String trimSlash(String value) { return value == null ? "" : value.replaceAll("/+$", ""); }
    private static Number number(Object value) { return (Number) value; }
    private static java.math.BigDecimal decimal(Object value) { return value == null ? java.math.BigDecimal.ZERO : (java.math.BigDecimal) value; }
    private static java.math.BigDecimal decimalOrNull(Object value) { return value == null ? null : (java.math.BigDecimal) value; }
    private static String string(Object value) { return value == null ? null : value.toString(); }
    private static String promotionStatusText(int status) { return status == 1 ? "推广中" : "已停用"; }
    static LocalDateTime time(Object value) {
        if (value == null) return null;
        if (value instanceof LocalDateTime localDateTime) return localDateTime;
        if (value instanceof Timestamp timestamp) return timestamp.toLocalDateTime();
        if (value instanceof java.util.Date date) {
            return LocalDateTime.ofInstant(date.toInstant(), java.time.ZoneId.systemDefault());
        }
        throw new IllegalArgumentException("Unsupported date-time value: " + value.getClass().getName());
    }
    private static Long key(KeyHolder keys) { if (keys.getKey() == null) throw new IllegalStateException("Generated key missing"); return keys.getKey().longValue(); }
    private static BusinessException error(int code, HttpStatus status, String message) { return new BusinessException(code, status, message); }
}
