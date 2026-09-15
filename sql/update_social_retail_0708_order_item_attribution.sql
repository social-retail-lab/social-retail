-- ============================================================
-- 0708 订单项分销归因字段补全
-- 背景：OrderItem 实体新增了 distributorProductId / commissionRate / attributionExpiresAt
--      但 order_item 表缺少对应列，导致商家端订单列表查询报错
--      Unknown column 'attribution_expires_at' in 'field list'
-- 注意：MySQL 8.0.21 以下版本不支持 ADD COLUMN IF NOT EXISTS，按项目约定不使用该子句
-- ============================================================

ALTER TABLE `order_item`
    ADD COLUMN `distributor_product_id` BIGINT DEFAULT NULL COMMENT '分销员商品ID（distributor_product.id）' AFTER `promotion_type`,
    ADD COLUMN `commission_rate` DECIMAL(10,2) DEFAULT NULL COMMENT '分销佣金比例快照（如 0.10 表示 10%）' AFTER `distributor_product_id`,
    ADD COLUMN `attribution_expires_at` DATETIME DEFAULT NULL COMMENT '分销归因过期时间（7天窗口结束时间）' AFTER `commission_rate`;
