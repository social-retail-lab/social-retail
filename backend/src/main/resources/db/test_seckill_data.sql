-- ==========================================
-- 秒杀功能测试数据
-- 依赖: data.sql 中的商品(6001-6014)和SKU(8001-8020)
-- 用法: source test_seckill_data.sql
-- ==========================================

-- 先清理旧测试数据
DELETE FROM seckill_product WHERE seckill_activity_id IN (SELECT id FROM seckill_activity WHERE title LIKE '%测试%' OR title LIKE '%秒杀%');
DELETE FROM seckill_activity WHERE title LIKE '%测试%' OR title LIKE '%秒杀%';

-- ==========================================
-- 秒杀活动1: 草稿状态（status=0，不可见，可编辑）
-- ==========================================
INSERT INTO seckill_activity (title, start_time, end_time, status) VALUES
('测试-周末秒杀专场', '2026-07-05 10:00:00', '2026-07-05 22:00:00', 0);

-- ==========================================
-- 秒杀活动2: 已发布（status=1，商家端可见可选品）
-- ==========================================
INSERT INTO seckill_activity (title, start_time, end_time, status) VALUES
('测试-618返场秒杀', '2026-07-10 00:00:00', '2026-07-12 23:59:59', 1);

-- 关联秒杀商品（引用data.sql中已存在的商品和SKU）
INSERT INTO seckill_product (seckill_activity_id, product_id, sku_id, seckill_price, seckill_stock, sold_count, limit_quantity, status) VALUES
-- 使用活动2（上一条INSERT生成的ID，假设为最后一个插入的ID）
((SELECT MAX(id) FROM seckill_activity), 6001, 'SKU-A001', 29.90, 50, 0, 2, 1),   -- 苹果5斤装 原价39.90
((SELECT MAX(id) FROM seckill_activity), 6002, 'SKU-B002', 69.90, 30, 0, 1, 1),   -- 褚橙10斤装 原价85.00
((SELECT MAX(id) FROM seckill_activity), 6013, 'SKU-C003', 8.90, 100, 0, 3, 1),   -- 香蕉2斤装 原价12.90
((SELECT MAX(id) FROM seckill_activity), 6009, 'SKU-D004', 45.00, 80, 0, 2, 1),   -- 纯牛奶 原价59.90
((SELECT MAX(id) FROM seckill_activity), 6010, 'SKU-E005', 59.00, 40, 0, 1, 1);   -- 每日坚果 原价79.00

-- ==========================================
-- 秒杀活动3: 已关闭（status=2，可删除）
-- ==========================================
INSERT INTO seckill_activity (title, start_time, end_time, status) VALUES
('测试-已结束的秒杀', '2026-06-01 10:00:00', '2026-06-01 22:00:00', 2);

-- 历史数据：已售出的秒杀商品（用于查看已关闭活动的商品记录）
INSERT INTO seckill_product (seckill_activity_id, product_id, sku_id, seckill_price, seckill_stock, sold_count, limit_quantity, status) VALUES
((SELECT MAX(id) FROM seckill_activity), 6001, 'old-sku-001', 59.90, 30, 30, 1, 1),   -- 全部售罄
((SELECT MAX(id) FROM seckill_activity), 6008, 'old-sku-002', 49.90, 20, 15, 2, 1);   -- 牛腩 部分售出

-- ==========================================
-- 验证数据
-- ==========================================
SELECT '=== 秒杀活动 ===' AS '';
SELECT id, title, start_time, end_time, 
       CASE status WHEN 0 THEN '草稿' WHEN 1 THEN '已发布' WHEN 2 THEN '已关闭' END AS status_text
FROM seckill_activity ORDER BY id;

SELECT '=== 秒杀商品 ===' AS '';
SELECT sp.id, sa.title AS 活动名称, p.title AS 商品名称, sp.sku_id,
       sp.seckill_price AS 秒杀价, sp.seckill_stock AS 库存,
       sp.sold_count AS 已售, sp.limit_quantity AS 限购,
       CASE sp.status WHEN 0 THEN '禁用' WHEN 1 THEN '启用' END AS 状态
FROM seckill_product sp
JOIN seckill_activity sa ON sa.id = sp.seckill_activity_id
LEFT JOIN product p ON p.id = sp.product_id
ORDER BY sp.seckill_activity_id, sp.id;
