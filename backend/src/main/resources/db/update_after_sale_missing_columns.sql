-- ==========================================
-- update_after_sale_missing_columns.sql
-- 补全 after_sale 表缺失字段，与 AfterSale 实体对齐
-- ==========================================

ALTER TABLE `after_sale`
  ADD COLUMN IF NOT EXISTS `merchant_id` BIGINT DEFAULT NULL COMMENT '商家ID' AFTER `order_item_id`,
  ADD COLUMN IF NOT EXISTS `service_type` TINYINT DEFAULT NULL COMMENT '服务类型' AFTER `type`,
  ADD COLUMN IF NOT EXISTS `audit_status` TINYINT DEFAULT NULL COMMENT '审核状态' AFTER `status`,
  ADD COLUMN IF NOT EXISTS `refund_status` TINYINT DEFAULT NULL COMMENT '退款状态' AFTER `audit_status`,
  ADD COLUMN IF NOT EXISTS `reject_reason` VARCHAR(500) DEFAULT NULL COMMENT '拒绝/强制退款理由' AFTER `audit_remark`,
  ADD COLUMN IF NOT EXISTS `update_time` DATETIME DEFAULT NULL COMMENT '最后更新时间' AFTER `apply_time`,
  ADD COLUMN IF NOT EXISTS `is_deleted` TINYINT DEFAULT 0 COMMENT '软删除标记 0-未删除 1-已删除';
