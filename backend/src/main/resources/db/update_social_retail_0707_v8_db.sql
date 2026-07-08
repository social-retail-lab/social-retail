-- =====================================================
-- update_social_retail_0707_v8_db.sql
-- 店铺满减券合并为梯度券 + 清理旧数据
-- =====================================================

USE social_retail_db;

-- =====================================================
-- Part A: 合并店铺满减券为梯度券
-- 当前问题：每个商家有2条满减券记录（满30减5 + 满60减12）
-- 正确做法：每个商家1条满减券，梯度存在 merchant_coupon_tier 中
-- 每个商家保留较小的 coupon_id，删除较大的，生成梯度
-- =====================================================

-- A1. 为每个商家生成梯度数据（从要删除的 coupon 中读取 discountAmount）
-- 商家2001-2006：coupon_id 200101→保留, 200102→删除
-- 商家2011-2025：coupon_id 200603-200612→保留, 200618-200627→删除

-- 为保留的 coupon 添加第一档梯度（满30减5，从保留 coupon 自身数据）
INSERT INTO `merchant_coupon_tier` (`coupon_id`, `min_amount`, `discount_amount`, `sort_order`)
SELECT mc.id, mc.min_consume, mc.discount_amount, 1
FROM `merchant_coupon` mc
WHERE mc.id IN (200101,200201,200301,200401,200501,200601,
                200603,200604,200605,200606,200607,200608,200609,200610,200611,200612)
  AND mc.type = 2
  AND NOT EXISTS (SELECT 1 FROM `merchant_coupon_tier` t WHERE t.coupon_id = mc.id);

-- 为保留的 coupon 添加第二档梯度（满60减12，从要删除的配对 coupon 获取）
-- 配对关系：200101↔200102, 200603↔200618, 200604↔200619, ...
INSERT INTO `merchant_coupon_tier` (`coupon_id`, `min_amount`, `discount_amount`, `sort_order`)
SELECT keep_id, keep_del.min_consume, keep_del.discount_amount, 2
FROM (
    SELECT 200101 AS keep_id, 200102 AS del_id UNION ALL
    SELECT 200201, 200202 UNION ALL
    SELECT 200301, 200302 UNION ALL
    SELECT 200401, 200402 UNION ALL
    SELECT 200501, 200502 UNION ALL
    SELECT 200601, 200602 UNION ALL
    SELECT 200603, 200618 UNION ALL
    SELECT 200604, 200619 UNION ALL
    SELECT 200605, 200620 UNION ALL
    SELECT 200606, 200621 UNION ALL
    SELECT 200607, 200622 UNION ALL
    SELECT 200608, 200623 UNION ALL
    SELECT 200609, 200624 UNION ALL
    SELECT 200610, 200625 UNION ALL
    SELECT 200611, 200626 UNION ALL
    SELECT 200612, 200627
) AS pairs
JOIN `merchant_coupon` keep_del ON keep_del.id = pairs.del_id
WHERE NOT EXISTS (SELECT 1 FROM `merchant_coupon_tier` t WHERE t.coupon_id = pairs.keep_id AND t.sort_order = 2);

-- A2. 更新保留的 coupon 名称（去掉金额信息，改为通用名称）
UPDATE `merchant_coupon` mc
JOIN `merchant` m ON mc.merchant_id = m.id
SET mc.title = CONCAT(m.merchant_name, '满减券'),
    mc.min_consume = NULL,
    mc.discount_amount = NULL
WHERE mc.id IN (200101,200201,200301,200401,200501,200601,
                200603,200604,200605,200606,200607,200608,200609,200610,200611,200612)
  AND mc.type = 2;

-- A3. 删除冗余的配对 coupon（满60减12 这些）
DELETE FROM `merchant_coupon`
WHERE id IN (200102,200202,200302,200402,200502,200602,
             200618,200619,200620,200621,200622,200623,200624,200625,200626,200627);

SELECT '✅ v8 店铺满减券合并完成' AS result;

-- =====================================================
-- Part B: 验证查询
-- =====================================================

-- B1. 查看最终 merchant_coupon 列表（每个商家最多1条满减券 + 可能1条固定券）
SELECT mc.id, mc.merchant_id, m.merchant_name, mc.title, mc.type, mc.status,
       mc.per_user_limit, mc.total_count, mc.received_count
FROM `merchant_coupon` mc
JOIN `merchant` m ON mc.merchant_id = m.id
ORDER BY mc.merchant_id, mc.id;

-- B2. 查看所有梯度数据
SELECT t.coupon_id, mc.title, t.min_amount, t.discount_amount, t.sort_order
FROM `merchant_coupon_tier` t
JOIN `merchant_coupon` mc ON t.coupon_id = mc.id
ORDER BY t.coupon_id, t.sort_order;

-- B3. platform_account_summary 当前值
SELECT * FROM `platform_account_summary`;

-- B4. platform_revenue_detail 汇总
SELECT type, COUNT(*) cnt, SUM(amount) total FROM `platform_revenue_detail` GROUP BY type;
