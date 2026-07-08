USE `social_retail_db`;

ALTER TABLE `cart`
  ADD COLUMN IF NOT EXISTS `promotion_code` VARCHAR(50) DEFAULT NULL COMMENT '分销推广码' AFTER `attribution_expires_at`;