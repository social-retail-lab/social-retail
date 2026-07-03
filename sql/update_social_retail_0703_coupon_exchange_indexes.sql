UPDATE `coupon` c
SET c.`received_count` = (
    SELECT COUNT(*) FROM `coupon_user` cu WHERE cu.`coupon_id` = c.`id`
);

ALTER TABLE `coupon`
    ADD INDEX `idx_coupon_exchange_list` (`type`, `status`, `valid_start`, `valid_end`, `exchange_points`);

ALTER TABLE `coupon_user`
    ADD INDEX `idx_coupon_user_limit` (`user_id`, `coupon_id`);
