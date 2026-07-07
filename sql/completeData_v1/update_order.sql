ALTER TABLE `order`
ADD COLUMN promotion_code VARCHAR(50) DEFAULT NULL COMMENT '推广码' AFTER distributor_product_id;