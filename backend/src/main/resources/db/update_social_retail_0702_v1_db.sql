ALTER TABLE `payment`
    ADD COLUMN `third_trade_no` VARCHAR(100) DEFAULT NULL COMMENT '第三方支付交易号，如支付宝trade_no' AFTER `pay_sn`,
    ADD COLUMN `callback_time` DATETIME DEFAULT NULL COMMENT '支付回调时间' AFTER `pay_time`,
    ADD COLUMN `fail_reason` VARCHAR(255) DEFAULT NULL COMMENT '支付失败原因' AFTER `callback_time`,
    ADD COLUMN `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间' AFTER `refund_time`,
    ADD COLUMN `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间' AFTER `create_time`;
ALTER TABLE `payment`
    ADD UNIQUE KEY `uk_payment_pay_sn` (`pay_sn`),
    ADD KEY `idx_payment_order_id` (`order_id`),
    ADD KEY `idx_payment_status` (`status`);