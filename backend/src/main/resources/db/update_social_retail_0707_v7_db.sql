-- =====================================================
-- update_social_retail_0707_v7_db.sql
-- 修复内容：
-- 1. 分离平台券和店铺券（coupon → merchant_coupon）
-- 2. 填充大促满减活动（platform_promotion + platform_promotion_tier）
-- 3. 修复平台收入数据（platform_revenue_detail + platform_account_summary）
-- 4. 商家参与促销记录（merchant_promotion_participation）
-- =====================================================
USE social_retail_db;

-- =====================================================
-- Part A: 将店铺券从 coupon 表迁移到 merchant_coupon 表
-- =====================================================
-- A1. 先查看将要迁移的店铺券
SELECT '=== 将要迁移的店铺券 ===' AS info;
SELECT c.id, c.title, c.type, c.min_consume, c.discount_amount, c.total_count
FROM `coupon` c WHERE c.id >= 200100 ORDER BY c.id;

-- A2. 将店铺券插入 merchant_coupon（根据券ID推断商家ID）
-- 券ID规则: 200XYY, X=商家尾号, YY=券序号
-- 200101~200102 → merchant_id=2001; 200201~200202 → merchant_id=2002; etc.
INSERT INTO `merchant_coupon` (`id`, `merchant_id`, `title`, `type`, `min_consume`, `discount_amount`, `total_count`, `received_count`, `per_user_limit`, `validity_type`, `valid_start`, `valid_end`, `status`)
SELECT 
    c.id,
    MID(c.id, 1, 4) AS merchant_id,
    c.title,
    2,
    c.min_consume,
    c.discount_amount,
    c.total_count,
    COALESCE(c.received_count, 0),
    COALESCE(c.per_user_limit, 1),
    COALESCE(c.validity_type, 1),
    c.valid_start,
    c.valid_end,
    COALESCE(c.status, 1)
FROM `coupon` c 
WHERE c.id BETWEEN 200101 AND 200602
   OR c.id BETWEEN 200603 AND 200612
   OR c.id BETWEEN 200618 AND 200627;

-- A3. 修正 merchant_coupon 中按券名匹配的商家ID（200603+的券名中包含商家名）
-- merchant_coupon 的 title 已从 coupon 复制过来，直接用 title 匹配 merchant.merchant_name
UPDATE `merchant_coupon` mc
JOIN `merchant` m ON mc.title LIKE CONCAT(m.merchant_name, '%')
SET mc.merchant_id = m.id
WHERE mc.id >= 200603 AND m.id <> mc.merchant_id;

-- A4. 删除 coupon 表中的店铺券
DELETE FROM `coupon` WHERE id >= 200100;

-- A5. 删除 coupon_user 中关联店铺券的记录（如果有）
DELETE FROM `coupon_user` WHERE coupon_id >= 200100;

-- A6. 确认迁移结果
SELECT '=== 迁移后 coupon 表（仅平台券） ===' AS info;
SELECT id, title, type, min_consume, discount_amount FROM `coupon` ORDER BY id;

SELECT '=== 迁移后 merchant_coupon 表（店铺券） ===' AS info;
SELECT id, merchant_id, title, type, min_consume, discount_amount FROM `merchant_coupon` ORDER BY id;

-- =====================================================
-- Part B: 大促满减活动（platform_promotion + platform_promotion_tier）
-- =====================================================
-- B1. 检查是否已存在
SELECT '=== 当前平台促销活动 ===' AS info;
SELECT * FROM `platform_promotion`;

-- B2. 插入平台大促满减活动
INSERT INTO `platform_promotion` (`id`, `title`, `start_time`, `end_time`, `status`, `create_time`) VALUES
(1, '7月夏日大促满减', '2026-07-01 00:00:00', '2026-07-31 23:59:59', 1, NOW()),
(2, '8月开学季大促', '2026-08-01 00:00:00', '2026-08-31 23:59:59', 1, NOW()),
(3, '618年中大促回场', '2026-06-18 00:00:00', '2026-06-25 23:59:59', 0, NOW());

-- B3. 插入促销梯度
INSERT INTO `platform_promotion_tier` (`promotion_id`, `min_amount`, `discount_amount`, `sort_order`) VALUES
-- 7月夏日大促
(1, 100.00, 10.00, 1),
(1, 200.00, 25.00, 2),
(1, 300.00, 45.00, 3),
(1, 500.00, 80.00, 4),
(1, 1000.00, 180.00, 5),
-- 8月开学季大促
(2, 80.00, 8.00, 1),
(2, 150.00, 18.00, 2),
(2, 300.00, 40.00, 3),
(2, 600.00, 90.00, 4),
-- 618回场
(3, 150.00, 30.00, 1),
(3, 300.00, 60.00, 2);

SELECT '=== 平台大促满减活动 ===' AS info;
SELECT pp.id, pp.title, pp.start_time, pp.end_time, pp.status,
       ppt.min_amount, ppt.discount_amount
FROM `platform_promotion` pp
LEFT JOIN `platform_promotion_tier` ppt ON ppt.promotion_id = pp.id
ORDER BY pp.id, ppt.sort_order;

-- =====================================================
-- Part C: 商家参与平台促销记录
-- =====================================================
INSERT INTO `merchant_promotion_participation` (`merchant_id`, `promotion_id`, `status`)
SELECT m.id, 1, 1
FROM `merchant` m
WHERE m.id BETWEEN 2001 AND 2025
  AND NOT EXISTS (
    SELECT 1 FROM `merchant_promotion_participation` mpp 
    WHERE mpp.merchant_id = m.id AND mpp.promotion_id = 1
  );

-- 部分商家也参与8月活动
INSERT INTO `merchant_promotion_participation` (`merchant_id`, `promotion_id`, `status`)
SELECT m.id, 2, 1
FROM `merchant` m
WHERE m.id IN (2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2013, 2015, 2019, 2021, 2023)
  AND NOT EXISTS (
    SELECT 1 FROM `merchant_promotion_participation` mpp 
    WHERE mpp.merchant_id = m.id AND mpp.promotion_id = 2
  );

SELECT '=== 商家参与促销记录 ===' AS info;
SELECT mpp.merchant_id, m.merchant_name, mpp.promotion_id, pp.title
FROM `merchant_promotion_participation` mpp
JOIN `merchant` m ON m.id = mpp.merchant_id
JOIN `platform_promotion` pp ON pp.id = mpp.promotion_id
ORDER BY mpp.promotion_id, mpp.merchant_id;

-- =====================================================
-- Part D: 修复平台收入数据（重建 platform_revenue_detail）
-- 原因：旧数据中金额与 order 表不一致，且缺少大部分订单记录
-- =====================================================

-- D1. 清空旧的 platform_revenue_detail（数据与 order 表不一致）
TRUNCATE TABLE `platform_revenue_detail`;

-- D2. 为所有已完成订单(status=4)重新生成佣金记录（从 order.commission 取）
INSERT INTO `platform_revenue_detail` (`order_id`, `merchant_id`, `type`, `amount`, `description`, `create_time`)
SELECT 
    o.id,
    o.merchant_id,
    'COMMISSION',
    o.commission,
    CONCAT('订单#', o.id, ' 平台佣金(', ROUND(o.commission_rate * 100, 1), '%)'),
    COALESCE(o.complete_time, o.pay_time, o.create_time)
FROM `order` o
WHERE o.status = 4 AND o.commission > 0;

-- D3. 为有 platform_subsidy 的已完成订单生成补贴支出记录
INSERT INTO `platform_revenue_detail` (`order_id`, `merchant_id`, `type`, `amount`, `description`, `create_time`)
SELECT 
    o.id,
    o.merchant_id,
    'SUBSIDY',
    -o.platform_subsidy,
    CONCAT('订单#', o.id, ' 平台补贴'),
    COALESCE(o.complete_time, o.pay_time, o.create_time)
FROM `order` o
WHERE o.status = 4 AND o.platform_subsidy > 0;

-- D4. 更新 platform_account_summary
UPDATE `platform_account_summary` pas
SET 
    pas.total_revenue = (
        SELECT COALESCE(SUM(amount), 0) FROM `platform_revenue_detail` 
        WHERE type = 'COMMISSION' AND amount > 0
    ),
    pas.total_expenditure = (
        SELECT COALESCE(SUM(ABS(amount)), 0) FROM `platform_revenue_detail` 
        WHERE type = 'SUBSIDY'
    ),
    pas.frozen_amount = (
        SELECT COALESCE(SUM(o.commission), 0) FROM `order` o 
        WHERE o.status IN (1, 2, 3) AND o.commission > 0
    ),
    pas.update_time = NOW()
WHERE pas.id = 1;

-- D5. 设置净收益
UPDATE `platform_account_summary` SET net_profit = total_revenue - total_expenditure WHERE id = 1;

-- D6. 如果没有汇总记录则插入
INSERT INTO `platform_account_summary` (`id`, `total_revenue`, `total_expenditure`, `net_profit`, `frozen_amount`, `update_time`)
SELECT 1,
    COALESCE((SELECT SUM(amount) FROM `platform_revenue_detail` WHERE type = 'COMMISSION' AND amount > 0), 0),
    COALESCE((SELECT SUM(ABS(amount)) FROM `platform_revenue_detail` WHERE type = 'SUBSIDY'), 0),
    0, 0, NOW()
WHERE NOT EXISTS (SELECT 1 FROM `platform_account_summary` WHERE id = 1);

-- =====================================================
-- Part E: 验证结果
-- =====================================================

SELECT '=== 平台券统计 ===' AS info;
SELECT COUNT(*) AS cnt, SUM(total_count) AS total_qty FROM `coupon`;

SELECT '=== 店铺券统计 ===' AS info;
SELECT merchant_id, COUNT(*) AS cnt, SUM(total_count) AS total_qty 
FROM `merchant_coupon` GROUP BY merchant_id ORDER BY merchant_id;

SELECT '=== 大促满减活动 ===' AS info;
SELECT pp.id, pp.title, pp.start_time, pp.end_time, 
  CASE pp.status WHEN 1 THEN '进行中' WHEN 0 THEN '已关闭' END AS status_name,
  COUNT(ppt.id) AS tier_cnt
FROM `platform_promotion` pp
LEFT JOIN `platform_promotion_tier` ppt ON ppt.promotion_id = pp.id
GROUP BY pp.id, pp.title, pp.start_time, pp.end_time, pp.status;

SELECT '=== 平台收入汇总 ===' AS info;
SELECT 
    COALESCE(SUM(CASE WHEN type = 'COMMISSION' AND amount > 0 THEN amount ELSE 0 END), 0) AS total_commission,
    COALESCE(SUM(CASE WHEN type = 'SUBSIDY' OR amount < 0 THEN ABS(amount) ELSE 0 END), 0) AS total_subsidy
FROM `platform_revenue_detail`;

SELECT '=== platform_account_summary ===' AS info;
SELECT * FROM `platform_account_summary`;

SELECT '=== 各商家收入明细 Top15 ===' AS info;
SELECT m.merchant_name, 
    COUNT(DISTINCT prd.order_id) AS order_cnt,
    COALESCE(SUM(CASE WHEN prd.type = 'COMMISSION' THEN prd.amount ELSE 0 END), 0) AS total_commission,
    COALESCE(SUM(CASE WHEN prd.type = 'SUBSIDY' THEN ABS(prd.amount) ELSE 0 END), 0) AS total_subsidy
FROM `platform_revenue_detail` prd
JOIN `merchant` m ON m.id = prd.merchant_id
GROUP BY prd.merchant_id, m.merchant_name
ORDER BY total_commission DESC LIMIT 15;

SELECT '=== Script completed: update_social_retail_0707_v7_db.sql ===' AS info;
