-- ==========================================
-- 测试数据：平台优惠卷 + 商家优惠卷 + 大促满减活动
-- ==========================================
USE `social_retail_db`;

-- ========================
-- 平台优惠卷 (coupon表)
-- ========================
-- 固定金额卷1：新人专享5元券
INSERT INTO `coupon` (`title`, `type`, `min_consume`, `discount_amount`, `total_count`, `received_count`, `per_user_limit`, `exchange_points`, `valid_start`, `valid_end`, `status`, `create_time`, `update_time`)
VALUES ('新人专享5元券', 1, 0.01, 5.00, 1000, 0, 1, 100, '2026-06-01 00:00:00', '2026-12-31 23:59:59', 1, NOW(), NOW());

-- 固定金额卷2：满50减10
INSERT INTO `coupon` (`title`, `type`, `min_consume`, `discount_amount`, `total_count`, `received_count`, `per_user_limit`, `exchange_points`, `valid_start`, `valid_end`, `status`, `create_time`, `update_time`)
VALUES ('满50减10通用券', 1, 50.00, 10.00, 500, 23, 2, 200, '2026-06-15 00:00:00', '2026-09-15 23:59:59', 1, NOW(), NOW());

-- 固定金额卷3：满100减20
INSERT INTO `coupon` (`title`, `type`, `min_consume`, `discount_amount`, `total_count`, `received_count`, `per_user_limit`, `exchange_points`, `valid_start`, `valid_end`, `status`, `create_time`, `update_time`)
VALUES ('满100减20大额券', 1, 100.00, 20.00, 300, 5, 1, 500, '2026-07-01 00:00:00', '2026-08-31 23:59:59', 1, NOW(), NOW());

-- 固定金额卷4：已禁用测试卷
INSERT INTO `coupon` (`title`, `type`, `min_consume`, `discount_amount`, `total_count`, `received_count`, `per_user_limit`, `exchange_points`, `valid_start`, `valid_end`, `status`, `create_time`, `update_time`)
VALUES ('已过期测试券', 1, 20.00, 3.00, 100, 0, 1, 0, '2025-01-01 00:00:00', '2025-06-30 23:59:59', 0, NOW(), NOW());

-- ========================
-- 大促满减活动 (platform_promotion + platform_promotion_tier)
-- ========================
-- 活动1：618大促
INSERT INTO `platform_promotion` (`title`, `start_time`, `end_time`, `status`, `create_time`, `update_time`)
VALUES ('618年中大促', '2026-06-01 00:00:00', '2026-06-18 23:59:59', 1, NOW(), NOW());

SET @promo618_id = LAST_INSERT_ID();
INSERT INTO `platform_promotion_tier` (`promotion_id`, `min_amount`, `discount_amount`, `sort_order`) VALUES
(@promo618_id, 300.00, 20.00, 1),
(@promo618_id, 500.00, 60.00, 2),
(@promo618_id, 1000.00, 150.00, 3);

-- 活动2：双11大促
INSERT INTO `platform_promotion` (`title`, `start_time`, `end_time`, `status`, `create_time`, `update_time`)
VALUES ('双11狂欢节', '2026-11-01 00:00:00', '2026-11-11 23:59:59', 1, NOW(), NOW());

SET @promo11_id = LAST_INSERT_ID();
INSERT INTO `platform_promotion_tier` (`promotion_id`, `min_amount`, `discount_amount`, `sort_order`) VALUES
(@promo11_id, 200.00, 15.00, 1),
(@promo11_id, 400.00, 50.00, 2),
(@promo11_id, 800.00, 120.00, 3);

-- 活动3：年货节（已关闭）
INSERT INTO `platform_promotion` (`title`, `start_time`, `end_time`, `status`, `create_time`, `update_time`)
VALUES ('2026年货节', '2026-01-15 00:00:00', '2026-02-05 23:59:59', 0, NOW(), NOW());

SET @promo_ny_id = LAST_INSERT_ID();
INSERT INTO `platform_promotion_tier` (`promotion_id`, `min_amount`, `discount_amount`, `sort_order`) VALUES
(@promo_ny_id, 150.00, 10.00, 1),
(@promo_ny_id, 300.00, 30.00, 2);

-- ========================
-- 商家优惠卷 (merchant_coupon表) 
-- 假设存在 merchant_id=1 的商家
-- 如果不存在，先创建一个测试商家
-- ========================
INSERT IGNORE INTO `merchant` (`id`, `merchant_name`, `contact_name`, `contact_phone`, `status`, `create_time`)
VALUES (1, '测试旗舰店', '张三', '13800001111', 1, NOW());

-- 商家卷1：店铺新人5元无门槛
INSERT INTO `merchant_coupon` (`merchant_id`, `title`, `type`, `min_consume`, `discount_amount`, `total_count`, `received_count`, `per_user_limit`, `valid_start`, `valid_end`, `status`, `create_time`, `update_time`)
VALUES (1, '新人无门槛5元券', 1, 0.01, 5.00, 200, 0, 1, '2026-06-01 00:00:00', '2026-12-31 23:59:59', 1, NOW(), NOW());

-- 商家卷2：满100减15
INSERT INTO `merchant_coupon` (`merchant_id`, `title`, `type`, `min_consume`, `discount_amount`, `total_count`, `received_count`, `per_user_limit`, `valid_start`, `valid_end`, `status`, `create_time`, `update_time`)
VALUES (1, '满100减15', 1, 100.00, 15.00, 100, 8, 2, '2026-07-01 00:00:00', '2026-09-30 23:59:59', 1, NOW(), NOW());

-- 商家卷3：满减卷（满200减30, 满500减80）
INSERT INTO `merchant_coupon` (`merchant_id`, `title`, `type`, `min_consume`, `discount_amount`, `total_count`, `received_count`, `per_user_limit`, `valid_start`, `valid_end`, `status`, `create_time`, `update_time`)
VALUES (1, '店铺满减大促', 2, NULL, NULL, 50, 3, 1, '2026-07-01 00:00:00', '2026-08-31 23:59:59', 1, NOW(), NOW());

SET @mc_id = LAST_INSERT_ID();
INSERT INTO `merchant_coupon_tier` (`coupon_id`, `min_amount`, `discount_amount`, `sort_order`) VALUES
(@mc_id, 200.00, 30.00, 1),
(@mc_id, 500.00, 80.00, 2);
