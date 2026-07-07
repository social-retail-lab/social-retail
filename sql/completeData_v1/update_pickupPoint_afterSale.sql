-- =====================================================
-- 数据库补丁：修复实体类与数据库字段不匹配问题
-- 执行方式: mysql -u root -p social_retail < 本文件
-- =====================================================
use `social_retail_db`;
-- ========== pickup_point 表补充字段 ==========
ALTER TABLE `pickup_point`

  ADD COLUMN `update_time` DATETIME DEFAULT NULL COMMENT '更新时间' AFTER `create_time`;

-- ========== after_sale 表补充字段 ==========
ALTER TABLE `after_sale`
  ADD COLUMN `appeal_status` TINYINT DEFAULT NULL COMMENT '申诉状态（0未申诉 1已申诉）' AFTER `return_received_status`,
  ADD COLUMN `appeal_time` DATETIME DEFAULT NULL COMMENT '申诉时间' AFTER `appeal_status`,
  ADD COLUMN `appeal_reason` VARCHAR(500) DEFAULT NULL COMMENT '申诉原因' AFTER `appeal_time`,
  ADD COLUMN `intervene_result` TINYINT DEFAULT NULL COMMENT '平台介入结果' AFTER `appeal_reason`,
  ADD COLUMN `intervene_action` TINYINT DEFAULT NULL COMMENT '平台操作' AFTER `intervene_result`,
  ADD COLUMN `intervene_remark` VARCHAR(500) DEFAULT NULL COMMENT '介入备注' AFTER `intervene_action`,
  ADD COLUMN `intervene_time` DATETIME DEFAULT NULL COMMENT '介入时间' AFTER `intervene_remark`;
