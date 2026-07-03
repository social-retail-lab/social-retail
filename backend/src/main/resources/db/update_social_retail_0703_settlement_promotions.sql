CREATE TABLE IF NOT EXISTS `merchant_coupon` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `merchant_id` BIGINT NOT NULL,
  `title` VARCHAR(100) NOT NULL,
  `type` TINYINT NOT NULL,
  `min_consume` DECIMAL(10,2) DEFAULT 0.00,
  `discount_amount` DECIMAL(10,2) DEFAULT NULL,
  `total_count` INT DEFAULT NULL,
  `received_count` INT NOT NULL DEFAULT 0,
  `per_user_limit` INT NOT NULL DEFAULT 1,
  `valid_start` DATETIME DEFAULT NULL,
  `valid_end` DATETIME DEFAULT NULL,
  `status` TINYINT NOT NULL DEFAULT 1,
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_merchant_coupon_merchant` (`merchant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商家优惠券';

CREATE TABLE IF NOT EXISTS `merchant_coupon_tier` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `coupon_id` BIGINT NOT NULL,
  `min_amount` DECIMAL(10,2) NOT NULL,
  `discount_amount` DECIMAL(10,2) NOT NULL,
  `sort_order` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `idx_merchant_coupon_tier_coupon` (`coupon_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商家优惠券阶梯';

CREATE TABLE IF NOT EXISTS `merchant_coupon_user` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `coupon_id` BIGINT NOT NULL,
  `user_id` BIGINT NOT NULL,
  `order_id` BIGINT DEFAULT NULL,
  `status` TINYINT DEFAULT 0,
  `receive_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `use_time` DATETIME DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_merchant_coupon_user_coupon` (`coupon_id`),
  KEY `idx_merchant_coupon_user_user_status` (`user_id`,`status`),
  KEY `idx_merchant_coupon_user_order` (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户商家优惠券';

CREATE TABLE IF NOT EXISTS `platform_promotion` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(100) NOT NULL,
  `start_time` DATETIME NOT NULL,
  `end_time` DATETIME NOT NULL,
  `status` TINYINT NOT NULL DEFAULT 1,
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='平台促销活动';

CREATE TABLE IF NOT EXISTS `platform_promotion_tier` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `promotion_id` BIGINT NOT NULL,
  `min_amount` DECIMAL(10,2) NOT NULL,
  `discount_amount` DECIMAL(10,2) NOT NULL,
  `sort_order` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `idx_platform_promotion_tier_promotion` (`promotion_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='平台促销阶梯';

CREATE TABLE IF NOT EXISTS `merchant_promotion_participation` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `merchant_id` BIGINT NOT NULL,
  `promotion_id` BIGINT NOT NULL,
  `status` TINYINT NOT NULL DEFAULT 0,
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_merchant_promotion` (`merchant_id`,`promotion_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商家参与平台促销记录';

