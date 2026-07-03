-- ==========================================
-- update_social_retail_0703_v4_db.sql
-- 1. coupon 表新增有效期类型字段
-- 2. merchant_coupon 表新增有效期类型字段
-- 3. platform_promotion status 语义变更（0=草稿, 1=已发布, 2=已关闭）
-- ==========================================
USE `social_retail_db`;

-- ========================
-- 平台优惠卷 (coupon) 新增有效期类型
-- ========================
ALTER TABLE `coupon`
  ADD COLUMN `validity_type` TINYINT DEFAULT 1 COMMENT '有效期类型: 1=固定时间段, 2=领取后N天失效' AFTER `exchange_points`,
  ADD COLUMN `validity_days` INT DEFAULT NULL COMMENT '有效期天数(validity_type=2时有效)' AFTER `validity_type`;

-- ========================
-- 商家优惠卷 (merchant_coupon) 新增有效期类型
-- ========================
ALTER TABLE `merchant_coupon`
  ADD COLUMN `validity_type` TINYINT DEFAULT 1 COMMENT '有效期类型: 1=固定时间段, 2=领取后N天失效' AFTER `per_user_limit`,
  ADD COLUMN `validity_days` INT DEFAULT NULL COMMENT '有效期天数(validity_type=2时有效)' AFTER `validity_type`;

-- ========================
-- 已有数据默认使用固定时间段（validity_type=1），无需更新
-- ========================
