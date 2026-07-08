-- ============================================================
-- V1.1 Commission Schedule & Order Distribution Adjustment
-- Date: 2026-07-07
-- ============================================================

-- ============================================================
-- Part A: Commission Rate Schedule (V1.1)
-- ============================================================
-- 平台阶梯式佣金收费细则（V1.1）:
-- | 层级     | 销售额区间(元)   | 佣金费率 | 名称       |
-- |----------|-----------------|---------|------------|
-- | 小微商家 | 0 ~ 1,000       | 0%      | 试运营期   |
-- | 尾部商家 | 1,001 ~ 10,000  | 5%      | 尾部       |
-- | 腰部商家 | 10,001 ~ 100,000| 8%      | 腰部       |
-- | 头部商家 | 100,001 以上    | 12%     | 头部       |

-- ============================================================
-- Part B-1: Add commission columns to `order` table
-- ============================================================

-- Check if commission column exists (ignore error if it does)
-- ALTER TABLE will fail if column already exists, so we use a conditional approach
SET @col_exists = (SELECT COUNT(*) FROM information_schema.COLUMNS 
  WHERE TABLE_SCHEMA = 'social_retail_db' AND TABLE_NAME = 'order' AND COLUMN_NAME = 'commission');
SET @sql = IF(@col_exists = 0, 
  'ALTER TABLE `order` ADD COLUMN commission DECIMAL(10,2) DEFAULT 0 COMMENT ''平台佣金''', 
  'SELECT ''commission column already exists'' AS msg');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @col_exists = (SELECT COUNT(*) FROM information_schema.COLUMNS 
  WHERE TABLE_SCHEMA = 'social_retail_db' AND TABLE_NAME = 'order' AND COLUMN_NAME = 'commission_rate');
SET @sql = IF(@col_exists = 0, 
  'ALTER TABLE `order` ADD COLUMN commission_rate DECIMAL(5,4) DEFAULT 0 COMMENT ''佣金费率''', 
  'SELECT ''commission_rate column already exists'' AS msg');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @col_exists = (SELECT COUNT(*) FROM information_schema.COLUMNS 
  WHERE TABLE_SCHEMA = 'social_retail_db' AND TABLE_NAME = 'order' AND COLUMN_NAME = 'merchant_tier');
SET @sql = IF(@col_exists = 0, 
  'ALTER TABLE `order` ADD COLUMN merchant_tier VARCHAR(20) DEFAULT '''' COMMENT ''商家层级''', 
  'SELECT ''merchant_tier column already exists'' AS msg');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- Add columns to merchant_earnings if not exist
SET @col_exists = (SELECT COUNT(*) FROM information_schema.COLUMNS 
  WHERE TABLE_SCHEMA = 'social_retail_db' AND TABLE_NAME = 'merchant_earnings' AND COLUMN_NAME = 'total_commission');
SET @sql = IF(@col_exists = 0, 
  'ALTER TABLE merchant_earnings ADD COLUMN total_commission DECIMAL(12,2) DEFAULT 0 COMMENT ''累计佣金''', 
  'SELECT ''total_commission column already exists'' AS msg');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @col_exists = (SELECT COUNT(*) FROM information_schema.COLUMNS 
  WHERE TABLE_SCHEMA = 'social_retail_db' AND TABLE_NAME = 'merchant_earnings' AND COLUMN_NAME = 'available_commission');
SET @sql = IF(@col_exists = 0, 
  'ALTER TABLE merchant_earnings ADD COLUMN available_commission DECIMAL(12,2) DEFAULT 0 COMMENT ''可提现佣金''', 
  'SELECT ''available_commission column already exists'' AS msg');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- ============================================================
-- Part B-2 / Task 3: Adjust order distribution for V1.1 target
-- ============================================================
-- Target: 头部10% (3), 腰部25% (6), 尾部40% (10), 小微25% (6)
-- Current: 头部0, 腰部4, 尾部11, 小微10

-- Promote 3 merchants to 头部 (>100K):
-- 万宝珠宝行(2025): 86674 -> 100001 (+13327)
UPDATE `order` SET total_amount = total_amount + 13327, pay_amount = pay_amount + 13327
WHERE id = 419 AND merchant_id = 2025;

-- 潮流数码馆(2018): 41637 -> 100001 (+58364)
UPDATE `order` SET total_amount = total_amount + 58364, pay_amount = pay_amount + 58364
WHERE id = 397 AND merchant_id = 2018;

-- 滋补堂(2010): 24394.30 -> 100001.30 (+75607)
UPDATE `order` SET total_amount = total_amount + 75607, pay_amount = pay_amount + 75607
WHERE id = 329 AND merchant_id = 2010;

-- Promote 5 merchants to 腰部 (>=10K):
-- 尚品烟酒行(2012): 9001 -> 10000 (+999)
UPDATE `order` SET total_amount = total_amount + 999, pay_amount = pay_amount + 999
WHERE id = 373 AND merchant_id = 2012;

-- 精品服饰店(2022): 7898 -> 10000 (+2102)
UPDATE `order` SET total_amount = total_amount + 2102, pay_amount = pay_amount + 2102
WHERE id = 411 AND merchant_id = 2022;

-- 臻品生活馆(2007): 7464.60 -> 10000.60 (+2536)
UPDATE `order` SET total_amount = total_amount + 2536, pay_amount = pay_amount + 2536
WHERE id = 307 AND merchant_id = 2007;

-- 鲜禧果仓(2003): 4293.10 -> 10000.10 (+5707)
UPDATE `order` SET total_amount = total_amount + 5707, pay_amount = pay_amount + 5707
WHERE id = 235 AND merchant_id = 2003;

-- 家禾粮油副食(2004): 4008.90 -> 10000.90 (+5992)
UPDATE `order` SET total_amount = total_amount + 5992, pay_amount = pay_amount + 5992
WHERE id = 258 AND merchant_id = 2004;

-- ============================================================
-- Part B-3: Calculate platform commission for each order
-- ============================================================

-- Step 1: Create temp table with merchant total sales (after adjustments)
DROP TEMPORARY TABLE IF EXISTS merchant_totals;
CREATE TEMPORARY TABLE merchant_totals AS
SELECT merchant_id, SUM(pay_amount) AS total_sales
FROM `order` WHERE status IN (2,3,4)
GROUP BY merchant_id;

-- Step 2: Update all valid orders with tier, rate, and commission
UPDATE `order` o
INNER JOIN merchant_totals mt ON o.merchant_id = mt.merchant_id
SET 
  o.merchant_tier = CASE
    WHEN mt.total_sales > 100000 THEN '头部商家'
    WHEN mt.total_sales >= 10000 THEN '腰部商家'
    WHEN mt.total_sales >= 1000 THEN '尾部商家'
    ELSE '小微商家'
  END,
  o.commission_rate = CASE
    WHEN mt.total_sales > 100000 THEN 0.1200
    WHEN mt.total_sales >= 10000 THEN 0.0800
    WHEN mt.total_sales >= 1000 THEN 0.0500
    ELSE 0.0000
  END,
  o.commission = ROUND(o.pay_amount * CASE
    WHEN mt.total_sales > 100000 THEN 0.12
    WHEN mt.total_sales >= 10000 THEN 0.08
    WHEN mt.total_sales >= 1000 THEN 0.05
    ELSE 0
  END, 2)
WHERE o.status IN (2,3,4);

-- Clean up
DROP TEMPORARY TABLE IF EXISTS merchant_totals;

-- ============================================================
-- Part C: Update merchant_earnings
-- ============================================================
-- For each merchant: total_commission = SUM of all their orders' commission

UPDATE merchant_earnings me
INNER JOIN (
  SELECT merchant_id, SUM(commission) AS total_comm
  FROM `order` WHERE status IN (2,3,4)
  GROUP BY merchant_id
) oc ON me.merchant_id = oc.merchant_id
SET 
  me.total_commission = oc.total_comm,
  me.available_commission = oc.total_comm;

-- For merchants with no orders but existing earnings rows, set commission to 0
UPDATE merchant_earnings 
SET total_commission = 0, available_commission = 0
WHERE total_commission IS NULL;

-- ============================================================
-- Verification queries
-- ============================================================
SELECT '=== Commission Summary ===' AS info;
SELECT merchant_tier, COUNT(*) AS order_count, 
  SUM(commission) AS total_commission,
  ROUND(AVG(commission_rate), 4) AS avg_rate
FROM `order` WHERE status IN (2,3,4)
GROUP BY merchant_tier;

SELECT '=== Merchant Tier Distribution ===' AS info;
SELECT tier, COUNT(*) AS merchant_count FROM (
  SELECT 
    CASE 
      WHEN COALESCE(SUM(o.pay_amount), 0) > 100000 THEN '头部商家'
      WHEN COALESCE(SUM(o.pay_amount), 0) >= 10000 THEN '腰部商家'
      WHEN COALESCE(SUM(o.pay_amount), 0) >= 1000 THEN '尾部商家'
      ELSE '小微商家'
    END AS tier
  FROM merchant m 
  LEFT JOIN `order` o ON m.id = o.merchant_id AND o.status IN (2,3,4)
  GROUP BY m.id
) t GROUP BY tier;

SELECT '=== Merchant Earnings Summary ===' AS info;
SELECT COUNT(*) AS earnings_count, SUM(total_commission) AS total_comm, SUM(available_commission) AS avail_comm FROM merchant_earnings;

-- ============================================================
-- Part D: Fine-tune distribution — promote 4 小微 to 尾部 (target: 10尾部/6小微)
-- ============================================================
-- 果汽鲜饮(2006): 896 -> 1001 (+105)
UPDATE `order` SET total_amount = total_amount + 105, pay_amount = pay_amount + 105
WHERE id = 360 AND merchant_id = 2006;

-- 四海海鲜城(2024): 757 -> 1001 (+244)
UPDATE `order` SET total_amount = total_amount + 244, pay_amount = pay_amount + 244
WHERE id = 417 AND merchant_id = 2024;

-- 食愈小站(2002): 747.80 -> 1000.80 (+253)
UPDATE `order` SET total_amount = total_amount + 253, pay_amount = pay_amount + 253
WHERE id = 350 AND merchant_id = 2002;

-- 巷味卤货(2005): 695.70 -> 1000.70 (+305)
UPDATE `order` SET total_amount = total_amount + 305, pay_amount = pay_amount + 305
WHERE id = 354 AND merchant_id = 2005;

-- Recalculate commissions after fine-tuning
DROP TEMPORARY TABLE IF EXISTS merchant_totals;
CREATE TEMPORARY TABLE merchant_totals AS
SELECT merchant_id, SUM(pay_amount) AS total_sales
FROM `order` WHERE status IN (2,3,4)
GROUP BY merchant_id;

UPDATE `order` o
INNER JOIN merchant_totals mt ON o.merchant_id = mt.merchant_id
SET 
  o.merchant_tier = CASE
    WHEN mt.total_sales > 100000 THEN '头部商家'
    WHEN mt.total_sales >= 10000 THEN '腰部商家'
    WHEN mt.total_sales >= 1000 THEN '尾部商家'
    ELSE '小微商家'
  END,
  o.commission_rate = CASE
    WHEN mt.total_sales > 100000 THEN 0.1200
    WHEN mt.total_sales >= 10000 THEN 0.0800
    WHEN mt.total_sales >= 1000 THEN 0.0500
    ELSE 0.0000
  END,
  o.commission = ROUND(o.pay_amount * CASE
    WHEN mt.total_sales > 100000 THEN 0.12
    WHEN mt.total_sales >= 10000 THEN 0.08
    WHEN mt.total_sales >= 1000 THEN 0.05
    ELSE 0
  END, 2)
WHERE o.status IN (2,3,4);

DROP TEMPORARY TABLE IF EXISTS merchant_totals;

-- Redo merchant_earnings
UPDATE merchant_earnings me
INNER JOIN (
  SELECT merchant_id, SUM(commission) AS total_comm
  FROM `order` WHERE status IN (2,3,4)
  GROUP BY merchant_id
) oc ON me.merchant_id = oc.merchant_id
SET 
  me.total_commission = oc.total_comm,
  me.available_commission = oc.total_comm;

UPDATE merchant_earnings 
SET total_commission = 0, available_commission = 0
WHERE total_commission IS NULL;

-- Final verification
SELECT '=== Final Tier Distribution ===' AS info;
SELECT tier, COUNT(*) AS merchant_count FROM (
  SELECT 
    CASE 
      WHEN COALESCE(SUM(o.pay_amount), 0) > 100000 THEN '头部商家'
      WHEN COALESCE(SUM(o.pay_amount), 0) >= 10000 THEN '腰部商家'
      WHEN COALESCE(SUM(o.pay_amount), 0) >= 1000 THEN '尾部商家'
      ELSE '小微商家'
    END AS tier
  FROM merchant m 
  LEFT JOIN `order` o ON m.id = o.merchant_id AND o.status IN (2,3,4)
  GROUP BY m.id
) t GROUP BY tier;

SELECT '=== Final Commission by Tier ===' AS info;
SELECT merchant_tier, COUNT(*) AS order_count, 
  SUM(commission) AS total_commission,
  ROUND(AVG(commission_rate), 4) AS avg_rate
FROM `order` WHERE status IN (2,3,4)
GROUP BY merchant_tier;
