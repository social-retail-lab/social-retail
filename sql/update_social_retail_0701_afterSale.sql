use `social_retail_db`;
ALTER TABLE `after_sale`
ADD COLUMN `refund_status` TINYINT DEFAULT 0 COMMENT '退款状态：0未退款 1退款中 2退款成功 3退款失败' AFTER `status`;

ALTER TABLE `after_sale`
ADD COLUMN `reject_reason` VARCHAR(500) DEFAULT NULL COMMENT '拒绝原因' AFTER `audit_remark`;

ALTER TABLE `after_sale`
ADD COLUMN `service_type` TINYINT DEFAULT 1 COMMENT '售后服务类型：1退款 2退货退款' AFTER `type`;

ALTER TABLE `after_sale`
ADD COLUMN `is_deleted` TINYINT DEFAULT 0 COMMENT '逻辑删除标记' AFTER `feedback_images`;

ALTER TABLE `after_sale`
ADD COLUMN `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间' AFTER `complete_time`;

ALTER TABLE `after_sale`
ADD COLUMN `merchant_id` BIGINT DEFAULT NULL COMMENT '商家ID（用于后台处理归属）' AFTER `order_item_id`;