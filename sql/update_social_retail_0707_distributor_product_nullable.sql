USE `social_retail_db`;

ALTER TABLE `distributor_product`
  MODIFY COLUMN `promotion_url` VARCHAR(500) DEFAULT NULL COMMENT '推广链接';