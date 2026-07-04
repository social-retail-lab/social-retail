-- ==========================================
-- 平台积分兑换优惠券测试数据
-- 表：coupon
-- 说明：
-- type 固定为 1，表示满减券
-- status：0=禁用，1=启用
-- exchange_points：兑换所需积分
-- ==========================================

-- 可选：先清理旧测试数据，避免主键冲突
DELETE FROM `coupon`
WHERE `id` IN (3001, 3002, 3003, 3004, 3005, 3006);


-- 1. 正常可兑换平台优惠券
INSERT INTO `coupon`
(`id`, `title`, `type`, `min_consume`, `discount_amount`, `total_count`, `received_count`, `per_user_limit`, `exchange_points`, `valid_start`, `valid_end`, `status`, `create_time`, `update_time`)
VALUES
(3001, '平台满100减10优惠券', 1, 100.00, 10.00, 1000, 120, 1, 1000, '2026-07-01 00:00:00', '2026-07-31 23:59:59', 1, NOW(), NOW()),

(3002, '平台满200减25优惠券', 1, 200.00, 25.00, 800, 230, 1, 2000, '2026-07-01 00:00:00', '2026-07-31 23:59:59', 1, NOW(), NOW()),

(3003, '平台满50减5优惠券', 1, 50.00, 5.00, 500, 80, 2, 500, '2026-07-01 00:00:00', '2026-07-31 23:59:59', 1, NOW(), NOW()),

(3004, '平台满300减40优惠券', 1, 300.00, 40.00, 300, 50, 1, 3500, '2026-07-01 00:00:00', '2026-07-31 23:59:59', 1, NOW(), NOW());


-- 2. 库存已兑完测试数据
INSERT INTO `coupon`
(`id`, `title`, `type`, `min_consume`, `discount_amount`, `total_count`, `received_count`, `per_user_limit`, `exchange_points`, `valid_start`, `valid_end`, `status`, `create_time`, `update_time`)
VALUES
(3005, '平台满80减8优惠券-已兑完', 1, 80.00, 8.00, 100, 100, 1, 800, '2026-07-01 00:00:00', '2026-07-31 23:59:59', 1, NOW(), NOW());


-- 3. 禁用状态测试数据
INSERT INTO `coupon`
(`id`, `title`, `type`, `min_consume`, `discount_amount`, `total_count`, `received_count`, `per_user_limit`, `exchange_points`, `valid_start`, `valid_end`, `status`, `create_time`, `update_time`)
VALUES
(3006, '平台满150减20优惠券-已禁用', 1, 150.00, 20.00, 500, 10, 1, 1500, '2026-07-01 00:00:00', '2026-07-31 23:59:59', 0, NOW(), NOW());


-- ==========================================
-- 查询校验：会员中心可兑换平台优惠券列表
-- 只查启用、有效期内、库存未兑完的优惠券
-- ==========================================

SELECT
  `id` AS `couponId`,
  `title`,
  `type`,
  `min_consume` AS `minConsume`,
  `discount_amount` AS `discountAmount`,
  `total_count` AS `totalCount`,
  `received_count` AS `receivedCount`,
  (`total_count` - `received_count`) AS `remainingCount`,
  `per_user_limit` AS `perUserLimit`,
  `exchange_points` AS `exchangePoints`,
  `valid_start` AS `validStart`,
  `valid_end` AS `validEnd`,
  `status`
FROM `coupon`
WHERE `status` = 1
  AND NOW() BETWEEN `valid_start` AND `valid_end`
  AND (`total_count` - `received_count`) > 0
ORDER BY `exchange_points` ASC;