-- =====================================================
-- 数据库补丁：修复实体类与数据库字段不匹配问题
-- 执行方式: mysql -u root -p social_retail < 本文件
-- =====================================================

-- ========== pickup_point 表补充字段 ==========
ALTER TABLE `pickup_point`
  ADD COLUMN IF NOT EXISTS `image` VARCHAR(500) DEFAULT NULL COMMENT '自提点照片' AFTER `contact_phone`,
  ADD COLUMN IF NOT EXISTS `create_time` DATETIME DEFAULT NULL COMMENT '创建时间' AFTER `status`,
  ADD COLUMN IF NOT EXISTS `update_time` DATETIME DEFAULT NULL COMMENT '更新时间' AFTER `create_time`;

-- ========== after_sale 表补充字段 ==========
ALTER TABLE `after_sale`
  ADD COLUMN IF NOT EXISTS `order_sn` VARCHAR(50) DEFAULT NULL COMMENT '订单快照编号' AFTER `order_item_id`,
  ADD COLUMN IF NOT EXISTS `product_name` VARCHAR(200) DEFAULT NULL COMMENT '商品快照名称' AFTER `order_sn`,
  ADD COLUMN IF NOT EXISTS `sku_specs` VARCHAR(200) DEFAULT NULL COMMENT '规格快照' AFTER `product_name`,
  ADD COLUMN IF NOT EXISTS `actual_refund_amount` DECIMAL(10,2) DEFAULT NULL COMMENT '实际退款金额' AFTER `refund_amount`,
  ADD COLUMN IF NOT EXISTS `reject_reason` VARCHAR(200) DEFAULT NULL COMMENT '拒绝原因' AFTER `reason`,
  ADD COLUMN IF NOT EXISTS `audit_time` DATETIME DEFAULT NULL COMMENT '审核时间' AFTER `status`,
  ADD COLUMN IF NOT EXISTS `audit_remark` VARCHAR(500) DEFAULT NULL COMMENT '审核备注' AFTER `audit_time`,
  ADD COLUMN IF NOT EXISTS `complete_time` DATETIME DEFAULT NULL COMMENT '完成时间' AFTER `audit_remark`,
  ADD COLUMN IF NOT EXISTS `evidence_images` TEXT DEFAULT NULL COMMENT '凭证图片（JSON数组）' AFTER `complete_time`,
  ADD COLUMN IF NOT EXISTS `feedback_content` VARCHAR(500) DEFAULT NULL COMMENT '处理反馈' AFTER `evidence_images`,
  ADD COLUMN IF NOT EXISTS `feedback_images` TEXT DEFAULT NULL COMMENT '反馈图片' AFTER `feedback_content`,
  ADD COLUMN IF NOT EXISTS `return_received_time` DATETIME DEFAULT NULL COMMENT '退货收货时间' AFTER `feedback_images`,
  ADD COLUMN IF NOT EXISTS `return_received_status` TINYINT DEFAULT NULL COMMENT '退货收货状态' AFTER `return_received_time`,
  ADD COLUMN IF NOT EXISTS `appeal_status` TINYINT DEFAULT NULL COMMENT '申诉状态（0未申诉 1已申诉）' AFTER `return_received_status`,
  ADD COLUMN IF NOT EXISTS `appeal_time` DATETIME DEFAULT NULL COMMENT '申诉时间' AFTER `appeal_status`,
  ADD COLUMN IF NOT EXISTS `appeal_reason` VARCHAR(500) DEFAULT NULL COMMENT '申诉原因' AFTER `appeal_time`,
  ADD COLUMN IF NOT EXISTS `intervene_result` TINYINT DEFAULT NULL COMMENT '平台介入结果' AFTER `appeal_reason`,
  ADD COLUMN IF NOT EXISTS `intervene_action` TINYINT DEFAULT NULL COMMENT '平台操作' AFTER `intervene_result`,
  ADD COLUMN IF NOT EXISTS `intervene_remark` VARCHAR(500) DEFAULT NULL COMMENT '介入备注' AFTER `intervene_action`,
  ADD COLUMN IF NOT EXISTS `intervene_time` DATETIME DEFAULT NULL COMMENT '介入时间' AFTER `intervene_remark`;
