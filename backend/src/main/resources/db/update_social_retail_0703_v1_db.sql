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

ALTER TABLE after_sale
ADD COLUMN audit_status TINYINT NOT NULL DEFAULT 0
COMMENT '审核状态：0待审核 1通过 2拒绝'
AFTER status;
use `social_retail_db`;
-- 会员中心上线迁移：保证每个用户只有一份会员账户，并补齐历史用户。
ALTER TABLE `member`
  MODIFY `user_id` BIGINT NOT NULL,
  MODIFY `member_level` TINYINT NOT NULL DEFAULT 1,
  MODIFY `points_balance` INT NOT NULL DEFAULT 0,
  MODIFY `growth_value` INT NOT NULL DEFAULT 0,
  ADD UNIQUE KEY `uk_member_user` (`user_id`);