USE `social_retail_db`;

ALTER TABLE `product`
  ADD COLUMN `force_off_shelf` TINYINT DEFAULT 0 COMMENT '是否强制下架: 0-否 1-是（管理员强制下架，商家无法再次上架）' AFTER `sold_count`;