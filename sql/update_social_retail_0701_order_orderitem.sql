ALTER TABLE `order`
    ADD COLUMN `address_id` BIGINT DEFAULT NULL COMMENT '收货地址ID' AFTER `pickup_point_id`,

    ADD COLUMN `consignee` VARCHAR(50) DEFAULT NULL COMMENT '收货人姓名快照' AFTER `address_id`,
    ADD COLUMN `phone` VARCHAR(20) DEFAULT NULL COMMENT '收货人电话快照' AFTER `consignee`,
    ADD COLUMN `province` VARCHAR(50) DEFAULT NULL COMMENT '省份快照' AFTER `phone`,
    ADD COLUMN `city` VARCHAR(50) DEFAULT NULL COMMENT '城市快照' AFTER `province`,
    ADD COLUMN `district` VARCHAR(50) DEFAULT NULL COMMENT '区县快照' AFTER `city`,
    ADD COLUMN `detailed_address` VARCHAR(200) DEFAULT NULL COMMENT '详细地址快照' AFTER `district`,

    ADD COLUMN `delivery_fee` DECIMAL(10,2) DEFAULT 0.00 COMMENT '配送费' AFTER `discount_amount`,
    ADD COLUMN `seckill_discount` DECIMAL(10,2) DEFAULT 0.00 COMMENT '秒杀优惠金额' AFTER `delivery_fee`,
    ADD COLUMN `bargain_discount` DECIMAL(10,2) DEFAULT 0.00 COMMENT '砍价优惠金额' AFTER `seckill_discount`,
    ADD COLUMN `coupon_discount` DECIMAL(10,2) DEFAULT 0.00 COMMENT '优惠券优惠金额' AFTER `bargain_discount`,
    ADD COLUMN `points_deduction` DECIMAL(10,2) DEFAULT 0.00 COMMENT '积分抵扣金额' AFTER `coupon_discount`,

    ADD COLUMN `coupon_user_id` BIGINT DEFAULT NULL COMMENT '用户优惠券领取记录ID' AFTER `points_deduction`,
    ADD COLUMN `seckill_id` BIGINT DEFAULT NULL COMMENT '秒杀活动ID' AFTER `coupon_user_id`,
    ADD COLUMN `bargain_id` BIGINT DEFAULT NULL COMMENT '砍价活动ID' AFTER `seckill_id`,
    ADD COLUMN `promotion_snapshot` TEXT DEFAULT NULL COMMENT '营销优惠快照JSON' AFTER `bargain_id`,

    ADD COLUMN `pay_expire_time` DATETIME DEFAULT NULL COMMENT '支付超时时间' AFTER `create_time`,
    ADD COLUMN `pay_time` DATETIME DEFAULT NULL COMMENT '支付时间' AFTER `pay_expire_time`,
    ADD COLUMN `cancel_time` DATETIME DEFAULT NULL COMMENT '取消时间' AFTER `pay_time`,

    ADD COLUMN `user_deleted` TINYINT DEFAULT 0 COMMENT '用户侧是否删除：0否 1是' AFTER `prepare_time`;
    
ALTER TABLE `order_item`
    ADD COLUMN `product_id` BIGINT DEFAULT NULL COMMENT '商品ID' AFTER `order_id`,
    ADD COLUMN `product_image` VARCHAR(255) DEFAULT NULL COMMENT '商品图片快照' AFTER `product_name`,

    ADD COLUMN `origin_price` DECIMAL(10,2) DEFAULT NULL COMMENT '商品原价' AFTER `sku_specs`,
    ADD COLUMN `final_price` DECIMAL(10,2) DEFAULT NULL COMMENT '最终成交单价' AFTER `origin_price`,

    ADD COLUMN `item_origin_amount` DECIMAL(10,2) DEFAULT 0.00 COMMENT '商品原始小计' AFTER `quantity`,
    ADD COLUMN `item_final_amount` DECIMAL(10,2) DEFAULT 0.00 COMMENT '商品最终小计' AFTER `item_origin_amount`,

    ADD COLUMN `promotion_type` VARCHAR(30) DEFAULT NULL COMMENT '商品参与的促销类型：NORMAL/SECKILL/BARGAIN/COUPON' AFTER `item_final_amount`;