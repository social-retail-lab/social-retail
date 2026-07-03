ALTER TABLE `order`
    ADD COLUMN `promotion_discount` DECIMAL(10,2) NOT NULL DEFAULT 0.00
        COMMENT '平台满减满折活动优惠金额' AFTER `bargain_discount`;

