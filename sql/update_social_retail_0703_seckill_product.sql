ALTER TABLE `seckill_product`
  ADD COLUMN `sold_count` INT NOT NULL DEFAULT 0 COMMENT '已售数量' AFTER `seckill_stock`,
  ADD COLUMN `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态：0禁用 1启用' AFTER `limit_quantity`,
  ADD COLUMN `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间' AFTER `status`,
  ADD COLUMN `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间' AFTER `create_time`;
  
ALTER TABLE `coupon`
  ADD COLUMN `received_count` INT NOT NULL DEFAULT 0 COMMENT '已领取数量' AFTER `total_count`,
  ADD COLUMN `per_user_limit` INT NOT NULL DEFAULT 1 COMMENT '每人限领数量' AFTER `received_count`,
  ADD COLUMN `exchange_points` INT DEFAULT 0 COMMENT '兑换所需积分，0表示免费领取' AFTER `per_user_limit`,
  ADD COLUMN `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态：0禁用 1启用' AFTER `valid_end`,
  ADD COLUMN `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间' AFTER `status`,
  ADD COLUMN `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间' AFTER `create_time`;
  
CREATE TABLE IF NOT EXISTS `discount_rule` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '满减满折规则ID',
  `title` VARCHAR(100) DEFAULT NULL COMMENT '规则名称',
  `type` TINYINT NOT NULL COMMENT '规则类型：1满减 2满折',
  `min_amount` DECIMAL(10,2) NOT NULL DEFAULT 0.00 COMMENT '满足金额门槛',
  `discount_amount` DECIMAL(10,2) DEFAULT NULL COMMENT '满减金额',
  `discount_rate` DECIMAL(5,2) DEFAULT NULL COMMENT '折扣比例，如8.50表示8.5折',
  `start_time` DATETIME DEFAULT NULL COMMENT '开始时间',
  `end_time` DATETIME DEFAULT NULL COMMENT '结束时间',
  `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态：0禁用 1启用',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='满减满折规则表';

CREATE TABLE IF NOT EXISTS `bargain_help_log` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '帮砍记录ID',
  `bargain_record_id` BIGINT NOT NULL COMMENT '砍价记录ID，对应 bargain_activity.id',
  `helper_user_id` BIGINT NOT NULL COMMENT '帮砍用户ID',
  `cut_amount` DECIMAL(10,2) NOT NULL DEFAULT 0.00 COMMENT '本次帮砍金额',
  `before_price` DECIMAL(10,2) DEFAULT NULL COMMENT '帮砍前价格',
  `after_price` DECIMAL(10,2) DEFAULT NULL COMMENT '帮砍后价格',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '帮砍时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_bargain_helper` (`bargain_record_id`, `helper_user_id`),
  CONSTRAINT `fk_bargain_help_record` FOREIGN KEY (`bargain_record_id`) REFERENCES `bargain_activity` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_bargain_help_user` FOREIGN KEY (`helper_user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='砍价帮砍记录表';