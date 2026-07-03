-- ==========================================
-- update_social_retail_0703_v6_db.sql
-- coupon 表新增领取会员等级门槛字段
-- 会员分级: 0=不限制 1=普通会员 2=银卡会员 3=金卡会员 4=钻石会员
-- ==========================================
USE `social_retail_db`;

-- ========================
-- coupon 新增领取会员等级门槛
-- ========================
ALTER TABLE `coupon`
  ADD COLUMN `member_level_required` TINYINT DEFAULT 0 COMMENT '领取会员等级门槛: 0不限制 1普通会员 2银卡会员 3金卡会员 4钻石会员' AFTER `exchange_points`;

-- ========================
-- 已有数据默认不限制（member_level_required=0），无需更新
-- ========================
