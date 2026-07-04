ALTER TABLE `order`
    ADD COLUMN `idempotent_key` VARCHAR(100) DEFAULT NULL COMMENT '用户提交订单幂等键' AFTER `order_sn`,
    ADD COLUMN `used_points` INT NOT NULL DEFAULT 0 COMMENT '订单使用积分' AFTER `points_deduction`,
    ADD COLUMN `points_status` TINYINT NOT NULL DEFAULT 0 COMMENT '积分状态：0无 1预占 2已扣减 3已释放' AFTER `used_points`,
    ADD UNIQUE KEY `uk_order_user_idempotent` (`user_id`, `idempotent_key`);
