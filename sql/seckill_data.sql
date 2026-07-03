-- ==========================================
-- 秒杀活动测试数据
-- 说明：
-- 1. 假设 product 表中已存在商品：6001、6002、6003
-- 2. 假设 sku 表中已存在 SKU：2001、2002、2003
-- 3. status：0=预热中/未开始，1=进行中，2=已结束，3=禁用
-- 4. seckill_product.status：0=禁用，1=启用
-- ==========================================


-- 1. 秒杀活动表测试数据
INSERT INTO `seckill_activity`
(`id`, `title`, `start_time`, `end_time`, `status`)
VALUES
(5001, '今日限时秒杀专场', '2026-07-03 10:00:00', '2026-07-03 12:00:00', 1),
(5002, '明日水果秒杀预热场', '2026-07-04 10:00:00', '2026-07-04 12:00:00', 0),
(5003, '昨日秒杀历史场', '2026-07-02 10:00:00', '2026-07-02 12:00:00', 2);


-- 2. 秒杀商品表测试数据：今日进行中的秒杀活动 5001
INSERT INTO `seckill_product`
(`id`, `seckill_activity_id`, `product_id`, `sku_id`, `seckill_price`, `seckill_stock`, `sold_count`, `limit_quantity`, `status`, `create_time`, `update_time`)
VALUES
(7001, 5001, 6001, 2001, 39.90, 100, 20, 1, 1, '2026-07-03 08:00:00', '2026-07-03 08:00:00'),
(7002, 5001, 6002, 2002, 49.90, 80, 10, 2, 1, '2026-07-03 08:00:00', '2026-07-03 08:00:00'),
(7003, 5001, 6003, 2003, 19.90, 50, 50, 1, 1, '2026-07-03 08:00:00', '2026-07-03 08:00:00');


-- 3. 秒杀商品表测试数据：明日预热活动 5002
INSERT INTO `seckill_product`
(`id`, `seckill_activity_id`, `product_id`, `sku_id`, `seckill_price`, `seckill_stock`, `sold_count`, `limit_quantity`, `status`, `create_time`, `update_time`)
VALUES
(7004, 5002, 6001, 2001, 36.90, 120, 0, 1, 1, '2026-07-03 09:00:00', '2026-07-03 09:00:00'),
(7005, 5002, 6002, 2002, 46.90, 100, 0, 2, 1, '2026-07-03 09:00:00', '2026-07-03 09:00:00');


-- 4. 秒杀商品表测试数据：已结束活动 5003
INSERT INTO `seckill_product`
(`id`, `seckill_activity_id`, `product_id`, `sku_id`, `seckill_price`, `seckill_stock`, `sold_count`, `limit_quantity`, `status`, `create_time`, `update_time`)
VALUES
(7006, 5003, 6003, 2003, 18.90, 60, 35, 1, 1, '2026-07-02 08:00:00', '2026-07-02 12:00:00');


-- ==========================================
-- 查询校验示例
-- ==========================================

-- 查询今日进行中的秒杀活动
SELECT *
FROM `seckill_activity`
WHERE `status` = 1
  AND NOW() BETWEEN `start_time` AND `end_time`;


-- 查询秒杀活动 5001 下的秒杀商品
SELECT
  sp.id AS seckillProductId,
  sp.seckill_activity_id AS activityId,
  sp.product_id AS productId,
  sp.sku_id AS skuId,
  p.title AS productName,
  p.main_image AS productImage,
  sp.seckill_price AS seckillPrice,
  sp.seckill_stock AS seckillStock,
  sp.sold_count AS soldCount,
  (sp.seckill_stock - sp.sold_count) AS remainingStock,
  sp.limit_quantity AS limitQuantity,
  sp.status AS seckillProductStatus
FROM `seckill_product` sp
LEFT JOIN `product` p ON sp.product_id = p.id
WHERE sp.seckill_activity_id = 5001
  AND sp.status = 1;