ALTER TABLE `order`
    ADD COLUMN `merchant_coupon_discount` DECIMAL(10,2) NOT NULL DEFAULT 0.00
        COMMENT '商家优惠券优惠金额' AFTER `coupon_discount`,
    ADD COLUMN `merchant_coupon_user_id` BIGINT DEFAULT NULL
        COMMENT '商家优惠券领取记录ID' AFTER `coupon_user_id`;

