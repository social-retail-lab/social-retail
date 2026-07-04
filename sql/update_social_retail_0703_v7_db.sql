-- ==========================================
-- update_social_retail_0703_v7_db.sql
-- seckill_product.sku_id 改为字符串类型，支持字母、数字、-
-- 去除外键约束，改为 VARCHAR 存储 SKU 码
-- ==========================================
USE `social_retail_db`;

-- 1. 删除唯一索引和外键约束
ALTER TABLE `seckill_product`
  DROP INDEX `uk_seckill_activity_sku`,
  DROP FOREIGN KEY `fk_seckill_sku`;

-- 2. 修改 sku_id 为 VARCHAR
ALTER TABLE `seckill_product`
  MODIFY COLUMN `sku_id` VARCHAR(100) DEFAULT NULL COMMENT '商品SKU码(支持字母数字-)';

-- 3. 重新添加唯一索引
ALTER TABLE `seckill_product`
  ADD UNIQUE KEY `uk_seckill_activity_sku` (`seckill_activity_id`, `sku_id`);
