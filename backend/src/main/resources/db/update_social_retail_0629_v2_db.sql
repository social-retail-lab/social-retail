-- ==========================================
-- 数据库变更脚本 v2
-- 日期: 2026-06-29
-- 说明: 商家入驻个人/企业区分、资质表增加经营门类、食品许可证改为非必填
-- ==========================================

USE `social_retail_db`;

-- 1. merchant_apply 表增加入驻类型字段
ALTER TABLE `merchant_apply`
    ADD COLUMN `apply_type` TINYINT DEFAULT 1 COMMENT '入驻类型: 1-个人, 2-企业' AFTER `user_id`;

-- 2. merchant_qualification 表增加经营门类字段
ALTER TABLE `merchant_qualification`
    ADD COLUMN `business_category` VARCHAR(100) DEFAULT NULL COMMENT '经营门类' AFTER `merchant_id`;

-- 3. merchant_qualification 表食品经营许可证改为非必填（已经是DEFAULT NULL，无需修改）
-- 但为兼容历史数据，执行以下语句确保字段可为NULL
ALTER TABLE `merchant_qualification`
    MODIFY COLUMN `food_permit_number` VARCHAR(50) DEFAULT NULL COMMENT '食品经营许可证号',
    MODIFY COLUMN `food_permit_image` VARCHAR(200) DEFAULT NULL COMMENT '食品许可证图片URL';

-- 4. merchant_apply 表食品经营许可证改为非必填
ALTER TABLE `merchant_apply`
    MODIFY COLUMN `food_permit_number` VARCHAR(50) DEFAULT NULL COMMENT '食品经营许可证号',
    MODIFY COLUMN `food_permit_image` VARCHAR(200) DEFAULT NULL COMMENT '食品许可证图片URL';
