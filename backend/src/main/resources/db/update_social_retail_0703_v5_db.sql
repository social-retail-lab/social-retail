ALTER TABLE `seckill_activity`
    ADD INDEX `idx_seckill_activity_time` (`start_time`, `end_time`, `status`);

ALTER TABLE `seckill_product`
    ADD UNIQUE KEY `uk_seckill_activity_sku` (`seckill_activity_id`, `sku_id`),
    ADD INDEX `idx_seckill_product_activity_status` (`seckill_activity_id`, `status`);