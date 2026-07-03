-- ==========================================
-- update_social_retail_0703_v3_db.sql
-- 优惠卷/促销/平台流水/账户汇总
-- ==========================================
USE `social_retail_db`;

-- 1. 平台促销活动表（大促满减活动）
CREATE TABLE IF NOT EXISTS `platform_promotion` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '活动ID',
  `title` VARCHAR(100) NOT NULL COMMENT '活动名称',
  `start_time` DATETIME NOT NULL COMMENT '开始时间',
  `end_time` DATETIME NOT NULL COMMENT '结束时间',
  `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态：0已关闭 1进行中',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='平台促销活动表';

-- 2. 平台促销梯度表（满减档位）
CREATE TABLE IF NOT EXISTS `platform_promotion_tier` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '梯度ID',
  `promotion_id` BIGINT NOT NULL COMMENT '关联 platform_promotion.id',
  `min_amount` DECIMAL(10,2) NOT NULL COMMENT '满金额',
  `discount_amount` DECIMAL(10,2) NOT NULL COMMENT '减金额',
  `sort_order` INT NOT NULL DEFAULT 0 COMMENT '排序（越小越优先匹配）',
  PRIMARY KEY (`id`),
  KEY `idx_promotion_id` (`promotion_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='平台促销梯度表';

-- 3. 商家参与平台促销记录表
CREATE TABLE IF NOT EXISTS `merchant_promotion_participation` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `merchant_id` BIGINT NOT NULL COMMENT '商家ID',
  `promotion_id` BIGINT NOT NULL COMMENT '促销活动ID',
  `status` TINYINT NOT NULL DEFAULT 0 COMMENT '0未参与 1已参与',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_merchant_promotion` (`merchant_id`, `promotion_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商家参与平台促销记录表';

-- 4. 商家优惠券模板表
CREATE TABLE IF NOT EXISTS `merchant_coupon` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '商家券ID',
  `merchant_id` BIGINT NOT NULL COMMENT '商家ID',
  `title` VARCHAR(100) NOT NULL COMMENT '券名称',
  `type` TINYINT NOT NULL COMMENT '类型：1固定金额 2满减',
  `min_consume` DECIMAL(10,2) DEFAULT 0.00 COMMENT '最低消费金额（固定金额卷使用门槛）',
  `discount_amount` DECIMAL(10,2) DEFAULT NULL COMMENT '固定优惠金额（type=1时生效）',
  `total_count` INT DEFAULT NULL COMMENT '发行总量',
  `received_count` INT NOT NULL DEFAULT 0 COMMENT '已领取数量',
  `per_user_limit` INT NOT NULL DEFAULT 1 COMMENT '每人限领',
  `valid_start` DATETIME DEFAULT NULL COMMENT '有效期开始',
  `valid_end` DATETIME DEFAULT NULL COMMENT '有效期结束',
  `status` TINYINT NOT NULL DEFAULT 1 COMMENT '0禁用 1启用',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_merchant_id` (`merchant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商家优惠券模板表';

-- 5. 商家满减卷梯度表
CREATE TABLE IF NOT EXISTS `merchant_coupon_tier` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '梯度ID',
  `coupon_id` BIGINT NOT NULL COMMENT '关联 merchant_coupon.id',
  `min_amount` DECIMAL(10,2) NOT NULL COMMENT '满金额',
  `discount_amount` DECIMAL(10,2) NOT NULL COMMENT '减金额',
  `sort_order` INT NOT NULL DEFAULT 0 COMMENT '排序',
  PRIMARY KEY (`id`),
  KEY `idx_coupon_id` (`coupon_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商家满减卷梯度表';

-- 6. 商家优惠券领取记录表
CREATE TABLE IF NOT EXISTS `merchant_coupon_user` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '领用记录ID',
  `coupon_id` BIGINT NOT NULL COMMENT '商家券ID',
  `user_id` BIGINT NOT NULL COMMENT '用户ID',
  `order_id` BIGINT DEFAULT NULL COMMENT '核销订单ID',
  `status` TINYINT DEFAULT 0 COMMENT '0未使用 1已使用 2已过期',
  `receive_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `use_time` DATETIME DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_coupon_id` (`coupon_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_order_id` (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商家优惠券领取记录表';

-- 7. 平台流水明细表（只增不改）
CREATE TABLE IF NOT EXISTS `platform_revenue_detail` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '流水ID',
  `order_id` BIGINT DEFAULT NULL COMMENT '关联订单ID',
  `merchant_id` BIGINT DEFAULT NULL COMMENT '关联商家ID',
  `type` VARCHAR(50) NOT NULL COMMENT '类型：commission佣金收入/coupon_subsidy平台贴补/service_fee服务费/other',
  `amount` DECIMAL(10,2) NOT NULL COMMENT '金额（正=收入 负=支出）',
  `description` VARCHAR(500) DEFAULT NULL COMMENT '描述',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_order_id` (`order_id`),
  KEY `idx_merchant_id` (`merchant_id`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='平台流水明细表';

-- 8. 平台账户汇总表
CREATE TABLE IF NOT EXISTS `platform_account_summary` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `total_revenue` DECIMAL(14,2) NOT NULL DEFAULT 0.00 COMMENT '总收入',
  `total_expenditure` DECIMAL(14,2) NOT NULL DEFAULT 0.00 COMMENT '总支出',
  `net_profit` DECIMAL(14,2) NOT NULL DEFAULT 0.00 COMMENT '净收益',
  `frozen_amount` DECIMAL(14,2) NOT NULL DEFAULT 0.00 COMMENT '冻结金额（待结算订单）',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='平台账户汇总表';

-- 插入默认账户记录
INSERT IGNORE INTO `platform_account_summary` (`id`, `total_revenue`, `total_expenditure`, `net_profit`, `frozen_amount`) 
VALUES (1, 0.00, 0.00, 0.00, 0.00);

-- 9. order表新增商家优惠券字段
ALTER TABLE `order`
  ADD COLUMN `merchant_coupon_user_id` BIGINT DEFAULT NULL COMMENT '使用的商家优惠券记录ID' AFTER `coupon_user_id`,
  ADD COLUMN `merchant_coupon_discount` DECIMAL(10,2) DEFAULT 0.00 COMMENT '商家优惠券抵扣金额' AFTER `coupon_discount`;