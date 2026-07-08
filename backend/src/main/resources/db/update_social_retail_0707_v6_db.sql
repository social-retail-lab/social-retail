-- =====================================================
-- 平台促销活动 + 优惠券 + 订单平台补贴
-- update_social_retail_0707_v6_db.sql
-- =====================================================

-- Part A: 重命名虚假企业商家为个人入驻风格名称
-- 将 user_id IS NULL 的企业商家名称改为电商个人店风格
-- (先查询确认哪些是虚假商家，再执行重命名)
-- =====================================================

-- 查看当前虚假商家列表
SELECT '=== 当前虚假商家 (user_id IS NULL) ===' AS info;
SELECT id, merchant_name, contact_name, contact_phone, create_time
FROM merchant WHERE user_id IS NULL ORDER BY id;

-- 逐一重命名为个人入驻风格
UPDATE merchant SET merchant_name = '顶峰Everest', contact_name = '张峰', contact_phone = '18800002007', shop_address = '重庆市渝北区新牌坊龙湖水晶国际2007', introduction = '专注高端户外装备与服饰，品质之选。' WHERE user_id IS NULL AND id = 2007;
UPDATE merchant SET merchant_name = '星辰潮品Studio', contact_name = '刘辰', contact_phone = '18800002008', shop_address = '重庆市九龙坡区杨家坪步行街B区208', introduction = '潮流服饰、鞋包配饰，年轻人的时尚集合店。' WHERE user_id IS NULL AND id = 2008;
UPDATE merchant SET merchant_name = '小鹿杂货铺', contact_name = '陆阳', contact_phone = '18800002009', shop_address = '重庆市南岸区弹子石国际社区底商12号', introduction = '日用好物、创意家居、生活百货一站购。' WHERE user_id IS NULL AND id = 2009;
UPDATE merchant SET merchant_name = '果壳数码Geekwork', contact_name = '何科', contact_phone = '18800002010', shop_address = '重庆市江北区北城天街红鼎国际A座1510', introduction = '手机配件、智能穿戴、数码潮玩，极客之选。' WHERE user_id IS NULL AND id = 2010;
UPDATE merchant SET merchant_name = '喵吉母婴MiuKids', contact_name = '苗思琪', contact_phone = '18800002011', shop_address = '重庆市沙坪坝区大学城熙街3期B馆1F-11', introduction = '婴幼儿服饰、喂养用品、安全玩具，妈妈的放心选择。' WHERE user_id IS NULL AND id = 2011;
UPDATE merchant SET merchant_name = '焙爱烘焙坊BakeDream', contact_name = '贝甜', contact_phone = '18800002012', shop_address = '重庆市渝中区大坪时代天街C馆LG-22', introduction = '烘焙原料、模具工具、包装材料，家庭烘焙爱好者的秘密基地。' WHERE user_id IS NULL AND id = 2012;
UPDATE merchant SET merchant_name = '绿萝花艺GreenLoft', contact_name = '罗曼', contact_phone = '18800002013', shop_address = '重庆市九龙坡区华润万象里底商L1-09', introduction = '鲜花绿植、花瓶花器、园艺工具，点亮你的生活空间。' WHERE user_id IS NULL AND id = 2013;
UPDATE merchant SET merchant_name = '第七天文具PaperDay', contact_name = '莫文', contact_phone = '18800002014', shop_address = '重庆市北碚区城南新区嘉陵风情步行街A5', introduction = '手账文具、笔记本、钢笔彩墨，书写爱好者的乐土。' WHERE user_id IS NULL AND id = 2014;
UPDATE merchant SET merchant_name = '宠遇PetMeet', contact_name = '常遇', contact_phone = '18800002015', shop_address = '重庆市巴南区龙洲湾万达广场外街2F-06', introduction = '猫狗主粮、零食玩具、宠物用品，让毛孩子更幸福。' WHERE user_id IS NULL AND id = 2015;
UPDATE merchant SET merchant_name = '三两茶事TeaStory', contact_name = '蔡青', contact_phone = '18800002016', shop_address = '重庆市南岸区南滨路长嘉汇购物公园L2-15', introduction = '原叶茶、花草茶、精美茶具，一杯茶的时间慢下来。' WHERE user_id IS NULL AND id = 2016;
UPDATE merchant SET merchant_name = '元气补给站VitalSpot', contact_name = '袁启', contact_phone = '18800002017', shop_address = '重庆市江北区九街高屋A栋底商03', introduction = '健康代餐、蛋白棒、能量饮料，运动达人的能量补给站。' WHERE user_id IS NULL AND id = 2017;
UPDATE merchant SET merchant_name = '简舍家生活SimplyHome', contact_name = '简宁', contact_phone = '18800002018', shop_address = '重庆市渝北区金开大道爱琴海购物公园B1-18', introduction = '北欧风格家居、简约收纳、生活美学，让家更有温度。' WHERE user_id IS NULL AND id = 2018;
UPDATE merchant SET merchant_name = '桃小仙美妆TaoBeauty', contact_name = '陶盈', contact_phone = '18800002019', shop_address = '重庆市大渡口区九宫庙步行街时尚莱迪1F-30', introduction = '国货彩妆、日韩护肤、化妆工具，平价好物聚集地。' WHERE user_id IS NULL AND id = 2019;
UPDATE merchant SET merchant_name = '骑行侠装备BikeHero', contact_name = '齐侠', contact_phone = '18800002020', shop_address = '重庆市沙坪坝区大学城北路U城天街B馆B1-07', introduction = '骑行头盔、手套、车灯配件，安全骑行从这里开始。' WHERE user_id IS NULL AND id = 2020;
UPDATE merchant SET merchant_name = '耳语零食WhisperSnack', contact_name = '卫斯', contact_phone = '18800002021', shop_address = '重庆市巴南区龙洲湾旭辉乐活城1F-11', introduction = '进口零食、网红爆款、办公室健康小食，嘴巴不寂寞。' WHERE user_id IS NULL AND id = 2021;
UPDATE merchant SET merchant_name = '布丁童装PuddingKids', contact_name = '卜婷', contact_phone = '18800002022', shop_address = '重庆市九龙坡区石桥铺仁悦天地2F-18', introduction = '0-12岁童装、童鞋、儿童配饰，舒适安全的成长陪伴。' WHERE user_id IS NULL AND id = 2022;
UPDATE merchant SET merchant_name = '山海渔鲜SeafoodMaster', contact_name = '单海', contact_phone = '18800002023', shop_address = '重庆市渝中区较场口石灰市菜市场水产区P01', introduction = '舟山海鲜、大连刺参、进口冻品，码头直送到家。' WHERE user_id IS NULL AND id = 2023;
UPDATE merchant SET merchant_name = '光影书坊LightLib', contact_name = '舒影', contact_phone = '18800002024', shop_address = '重庆市南岸区弹子石老街文创街区3号', introduction = '畅销图书、儿童绘本、文创书签，让阅读温暖时光。' WHERE user_id IS NULL AND id = 2024;
UPDATE merchant SET merchant_name = '创物手作CraftGen', contact_name = '吴创', contact_phone = '18800002025', shop_address = '重庆市江北区喵儿石创艺特区2号楼B1', introduction = '手工皮具、布艺DIY材料包、复古饰品，匠人精神的小店。' WHERE user_id IS NULL AND id = 2025;

-- 如果还有更多虚假商家（ID > 2025），用通用规则重命名
UPDATE merchant SET merchant_name = CONCAT('店主', SUBSTRING(contact_name, 1, 1), '的小店') WHERE user_id IS NULL AND id > 2025;

SELECT '=== 重命名后的虚假商家 ===' AS info;
SELECT id, merchant_name, contact_name FROM merchant WHERE user_id IS NULL ORDER BY id;


-- =====================================================
-- Part B: 订单表新增平台补贴字段
-- =====================================================
SET @sql_check = (SELECT COUNT(*) FROM information_schema.COLUMNS 
  WHERE TABLE_SCHEMA = 'social_retail_db' AND TABLE_NAME = 'order' AND COLUMN_NAME = 'platform_subsidy');
SET @sql = IF(@sql_check = 0,
  'ALTER TABLE `order` ADD COLUMN platform_subsidy DECIMAL(10,2) DEFAULT 0 COMMENT ''平台补贴金额''',
  'SELECT ''platform_subsidy already exists'' AS msg');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;


-- =====================================================
-- Part C: 平台大促满减活动
-- =====================================================

-- C1. 平台满减优惠券模板（type=2 表示平台满减活动）
-- 满100减10 / 满200减25 / 满300减45 / 满500减80 / 满1000减180

INSERT INTO `coupon` (`id`, `title`, `type`, `min_consume`, `discount_amount`, `total_count`, `valid_start`, `valid_end`) VALUES
(901, '7月夏日狂欢 满100减10', 2, 100.00, 10.00, 500, '2026-07-01 00:00:00', '2026-07-31 23:59:59'),
(902, '7月夏日狂欢 满200减25', 2, 200.00, 25.00, 400, '2026-07-01 00:00:00', '2026-07-31 23:59:59'),
(903, '7月夏日狂欢 满300减45', 2, 300.00, 45.00, 300, '2026-07-01 00:00:00', '2026-07-31 23:59:59'),
(904, '7月夏日狂欢 满500减80', 2, 500.00, 80.00, 200, '2026-07-01 00:00:00', '2026-07-31 23:59:59'),
(905, '7月夏日狂欢 满1000减180', 2, 1000.00, 180.00, 100, '2026-07-01 00:00:00', '2026-07-31 23:59:59'),
(906, '新用户首单礼 满50减15', 2, 50.00, 15.00, 200, '2026-07-01 00:00:00', '2026-08-31 23:59:59');


-- C2. 平台会员等级专属优惠券（type=3 平台会员券）
-- 普通会员(level=1) / 银牌会员(level=2) / 金牌会员(level=3)

INSERT INTO `coupon` (`id`, `title`, `type`, `min_consume`, `discount_amount`, `total_count`, `valid_start`, `valid_end`) VALUES
(911, '普通会员专享 满80减8', 3, 80.00, 8.00, 300, '2026-07-01 00:00:00', '2026-07-31 23:59:59'),
(912, '普通会员专享 满150减18', 3, 150.00, 18.00, 250, '2026-07-01 00:00:00', '2026-07-31 23:59:59'),
(913, '银牌会员专享 满100减15', 3, 100.00, 15.00, 300, '2026-07-01 00:00:00', '2026-07-31 23:59:59'),
(914, '银牌会员专享 满200减30', 3, 200.00, 30.00, 200, '2026-07-01 00:00:00', '2026-07-31 23:59:59'),
(915, '金牌会员专享 满150减25', 3, 150.00, 25.00, 200, '2026-07-01 00:00:00', '2026-07-31 23:59:59'),
(916, '金牌会员专享 满300减50', 3, 300.00, 50.00, 150, '2026-07-01 00:00:00', '2026-07-31 23:59:59');


-- =====================================================
-- Part D: 秒杀活动
-- =====================================================

-- D1. 秒杀活动场次
INSERT INTO `seckill_activity` (`id`, `title`, `start_time`, `end_time`, `status`) VALUES
(1, '7月7日限时秒杀', '2026-07-07 10:00:00', '2026-07-07 22:00:00', 1),
(2, '7月14日超级秒杀日', '2026-07-14 10:00:00', '2026-07-14 22:00:00', 1),
(3, '周末狂欢秒杀', '2026-07-13 08:00:00', '2026-07-14 23:59:59', 1);

-- D2. 秒杀商品（选择真实商家的热门商品做秒杀，秒杀价约原价6-8折）
INSERT INTO `seckill_product` (`seckill_activity_id`, `product_id`, `sku_id`, `seckill_price`, `seckill_stock`, `limit_quantity`) VALUES
(1, 6001, 8001, 59.90, 50, 2),   -- 三只松鼠每日坚果30包 原价77
(1, 6005, 8005, 12.90, 80, 3),   -- 卫龙大面筋10包 原价19.9
(1, 6009, 8009, 25.90, 60, 2),   -- 阿克苏冰糖心苹果5斤 原价36.9
(1, 6017, 8017, 12.90, 100, 5),  -- 有友泡椒凤爪 原价18.9
(2, 6002, 8002, 19.90, 60, 3),   -- 三只松鼠虎皮风爪 原价26
(2, 6012, 8012, 65.00, 40, 2),   -- 沃隆每日坚果750g 原价85
(2, 6018, 8018, 18.90, 50, 3),   -- 绝味香辣鸭脖200g 原价24.9
(2, 6021, 8021, 49.90, 40, 2),   -- 元气森林白桃气泡水15瓶 原价65
(3, 6006, 8006, 25.00, 50, 2),   -- 良品铺子蛋黄酥6枚 原价35
(3, 6013, 8013, 55.00, 30, 2),   -- 金龙鱼稻花香大米5kg 原价68
(3, 6020, 8020, 59.90, 30, 3),   -- 有友现卤五香鹌鹑蛋300g 原价78
(3, 6024, 8024, 34.90, 40, 2);   -- 农夫山泉芒果复合果汁1L 原价45


-- =====================================================
-- Part E: 为每个商家创建店铺专属优惠券
-- =====================================================

INSERT INTO `coupon` (`id`, `title`, `type`, `min_consume`, `discount_amount`, `total_count`, `valid_start`, `valid_end`) VALUES
-- 2001 润禾生活食铺
(200101, '润禾小店 满30减5', 0, 30.00, 5.00, 200, '2026-07-01 00:00:00', '2026-08-31 23:59:59'),
(200102, '润禾小店 满60减12', 0, 60.00, 12.00, 150, '2026-07-01 00:00:00', '2026-08-31 23:59:59'),
-- 2002 食愈小站
(200201, '食愈小站 满25减4', 0, 25.00, 4.00, 200, '2026-07-01 00:00:00', '2026-08-31 23:59:59'),
(200202, '食愈小站 满50减10', 0, 50.00, 10.00, 150, '2026-07-01 00:00:00', '2026-08-31 23:59:59'),
-- 2003 鲜禧果仓
(200301, '鲜禧果仓 满40减6', 0, 40.00, 6.00, 200, '2026-07-01 00:00:00', '2026-08-31 23:59:59'),
(200302, '鲜禧果仓 满80减15', 0, 80.00, 15.00, 150, '2026-07-01 00:00:00', '2026-08-31 23:59:59'),
-- 2004 家禾粮油副食
(200401, '家禾粮油 满50减8', 0, 50.00, 8.00, 200, '2026-07-01 00:00:00', '2026-08-31 23:59:59'),
(200402, '家禾粮油 满100减20', 0, 100.00, 20.00, 100, '2026-07-01 00:00:00', '2026-08-31 23:59:59'),
-- 2005 巷味卤货
(200501, '巷味卤货 满20减3', 0, 20.00, 3.00, 300, '2026-07-01 00:00:00', '2026-08-31 23:59:59'),
(200502, '巷味卤货 满40减8', 0, 40.00, 8.00, 200, '2026-07-01 00:00:00', '2026-08-31 23:59:59'),
-- 2006 果汽鲜饮
(200601, '果汽鲜饮 满30减5', 0, 30.00, 5.00, 200, '2026-07-01 00:00:00', '2026-08-31 23:59:59'),
(200602, '果汽鲜饮 满60减10', 0, 60.00, 10.00, 150, '2026-07-01 00:00:00', '2026-08-31 23:59:59');

-- 为每个虚假商家(2007-2025)批量生成店铺优惠券
INSERT INTO `coupon` (`title`, `type`, `min_consume`, `discount_amount`, `total_count`, `valid_start`, `valid_end`)
SELECT 
  CONCAT(m.merchant_name, ' 满30减5'),
  0, 30.00, 5.00, 200, '2026-07-01 00:00:00', '2026-08-31 23:59:59'
FROM merchant m WHERE m.user_id IS NULL AND m.id BETWEEN 2007 AND 2025;

INSERT INTO `coupon` (`title`, `type`, `min_consume`, `discount_amount`, `total_count`, `valid_start`, `valid_end`)
SELECT 
  CONCAT(m.merchant_name, ' 满60减12'),
  0, 60.00, 12.00, 100, '2026-07-01 00:00:00', '2026-08-31 23:59:59'
FROM merchant m WHERE m.user_id IS NULL AND m.id BETWEEN 2007 AND 2025;


-- =====================================================
-- Part F: 用户领取优惠券
-- =====================================================

-- F1. 为已有会员的用户发放对应的等级优惠券
-- 会员等级1(普通): coupon 911, 912; 等级2(银牌): 913, 914; 等级3(金牌): 915, 916
INSERT INTO `coupon_user` (`coupon_id`, `user_id`, `status`, `receive_time`)
SELECT 
  CASE WHEN mb.member_level = 1 AND RAND() < 0.5 THEN 911 ELSE 912 END,
  mb.user_id, 0,
  '2026-07-04 10:00:00'
FROM `member` mb WHERE mb.member_level = 1 AND mb.user_id IS NOT NULL;

INSERT INTO `coupon_user` (`coupon_id`, `user_id`, `status`, `receive_time`)
SELECT 
  CASE WHEN mb.member_level = 2 AND RAND() < 0.5 THEN 913 ELSE 914 END,
  mb.user_id, 0,
  '2026-07-04 10:00:00'
FROM `member` mb WHERE mb.member_level = 2 AND mb.user_id IS NOT NULL;

INSERT INTO `coupon_user` (`coupon_id`, `user_id`, `status`, `receive_time`)
SELECT 
  CASE WHEN mb.member_level = 3 AND RAND() < 0.5 THEN 915 ELSE 916 END,
  mb.user_id, 0,
  '2026-07-04 10:00:00'
FROM `member` mb WHERE mb.member_level = 3 AND mb.user_id IS NOT NULL;

-- F2. 为每个用户随机发放1-3张平台满减券(901-906)和店铺券
-- 发放给 users 1001-1025
INSERT INTO `coupon_user` (`coupon_id`, `user_id`, `status`, `receive_time`)
SELECT 
  c.id, u.id, 0,
  DATE_ADD('2026-07-01 08:00:00', INTERVAL FLOOR(RAND() * 144) HOUR)
FROM `user` u
CROSS JOIN `coupon` c
WHERE u.id BETWEEN 1001 AND 1025
  AND c.id IN (901, 902, 903, 904, 905, 906)
  AND RAND() < 0.55;

-- F3. 为商户自己的用户发放店铺券(200101-202502)
INSERT INTO `coupon_user` (`coupon_id`, `user_id`, `status`, `receive_time`)
SELECT 
  c.id, o.user_id, 0,
  DATE_ADD('2026-07-02 09:00:00', INTERVAL FLOOR(RAND() * 120) HOUR)
FROM `order` o
JOIN `coupon` c ON c.id BETWEEN 200101 AND 200102 WHERE o.merchant_id = 2001
UNION ALL
SELECT 
  c.id, o.user_id, 0,
  DATE_ADD('2026-07-02 09:00:00', INTERVAL FLOOR(RAND() * 120) HOUR)
FROM `order` o
JOIN `coupon` c ON c.id BETWEEN 200201 AND 200202 WHERE o.merchant_id = 2002
UNION ALL
SELECT 
  c.id, o.user_id, 0,
  DATE_ADD('2026-07-02 09:00:00', INTERVAL FLOOR(RAND() * 120) HOUR)
FROM `order` o
JOIN `coupon` c ON c.id BETWEEN 200301 AND 200302 WHERE o.merchant_id = 2003
UNION ALL
SELECT 
  c.id, o.user_id, 0,
  DATE_ADD('2026-07-02 09:00:00', INTERVAL FLOOR(RAND() * 120) HOUR)
FROM `order` o
JOIN `coupon` c ON c.id BETWEEN 200401 AND 200402 WHERE o.merchant_id = 2004
UNION ALL
SELECT 
  c.id, o.user_id, 0,
  DATE_ADD('2026-07-02 09:00:00', INTERVAL FLOOR(RAND() * 120) HOUR)
FROM `order` o
JOIN `coupon` c ON c.id BETWEEN 200501 AND 200502 WHERE o.merchant_id = 2005
UNION ALL
SELECT 
  c.id, o.user_id, 0,
  DATE_ADD('2026-07-02 09:00:00', INTERVAL FLOOR(RAND() * 120) HOUR)
FROM `order` o
JOIN `coupon` c ON c.id BETWEEN 200601 AND 200602 WHERE o.merchant_id = 2006
LIMIT 500;


-- =====================================================
-- Part G: 计算订单平台补贴 - 满减优惠券核销
-- =====================================================

-- 对已完成(status=4)且pay_amount达到满减门槛的订单，按规则设置补贴
-- 满100补10 / 满200补25 / 满300补45 / 满500补80 / 满1000补180

UPDATE `order` SET platform_subsidy = 10.00, discount_amount = discount_amount + 10.00
WHERE status = 4 AND pay_amount >= 100 AND pay_amount < 200 AND RAND() < 0.40 AND platform_subsidy = 0;

UPDATE `order` SET platform_subsidy = 25.00, discount_amount = discount_amount + 25.00
WHERE status = 4 AND pay_amount >= 200 AND pay_amount < 300 AND RAND() < 0.35 AND platform_subsidy = 0;

UPDATE `order` SET platform_subsidy = 45.00, discount_amount = discount_amount + 45.00
WHERE status = 4 AND pay_amount >= 300 AND pay_amount < 500 AND RAND() < 0.30 AND platform_subsidy = 0;

UPDATE `order` SET platform_subsidy = 80.00, discount_amount = discount_amount + 80.00
WHERE status = 4 AND pay_amount >= 500 AND pay_amount < 1000 AND RAND() < 0.30 AND platform_subsidy = 0;

UPDATE `order` SET platform_subsidy = 180.00, discount_amount = discount_amount + 180.00
WHERE status = 4 AND pay_amount >= 1000 AND RAND() < 0.25 AND platform_subsidy = 0;

-- 新用户首单补贴（满50补15）
UPDATE `order` SET platform_subsidy = 15.00, discount_amount = discount_amount + 15.00
WHERE status = 4 AND pay_amount >= 50 AND pay_amount < 100 AND user_id IN (1011, 1013, 1015, 1017, 1019) AND RAND() < 0.50 AND platform_subsidy = 0;


-- =====================================================
-- Part H: 秒杀订单补贴计算
-- =====================================================

-- 为部分已完成订单标记秒杀身份并计算补贴
-- 选取已核销(status=4)的头部/尾部商家订单，应用对应秒杀价计算补贴

-- 农0夫山泉鲜榨芒果复合果汁 1L瓶装 (product 6024, sku 8024, original 45): seckill=34.9 补贴=10.1/瓶
UPDATE `order` o
JOIN `order_item` oi ON oi.order_id = o.id
SET o.platform_subsidy = o.platform_subsidy + ROUND(10.1 * oi.quantity, 2),
    o.discount_amount = o.discount_amount + ROUND(10.1 * oi.quantity, 2)
WHERE o.status = 4 AND oi.sku_id = 8024 AND o.platform_subsidy = 0 AND RAND() < 0.40;

-- 良品铺子蛋黄酥6枚 (product 6006, sku 8006, original 35): seckill=25 补贴=10/盒
UPDATE `order` o
JOIN `order_item` oi ON oi.order_id = o.id
SET o.platform_subsidy = o.platform_subsidy + ROUND(10.0 * oi.quantity, 2),
    o.discount_amount = o.discount_amount + ROUND(10.0 * oi.quantity, 2)
WHERE o.status = 4 AND oi.sku_id = 8006 AND o.platform_subsidy = 0 AND RAND() < 0.45;

-- 三只松鼠每日坚果30包 (product 6001, sku 8001, original 77): seckill=59.9 补贴=17.1/箱
UPDATE `order` o
JOIN `order_item` oi ON oi.order_id = o.id
SET o.platform_subsidy = o.platform_subsidy + ROUND(17.1 * oi.quantity, 2),
    o.discount_amount = o.discount_amount + ROUND(17.1 * oi.quantity, 2)
WHERE o.status = 4 AND oi.sku_id = 8001 AND o.platform_subsidy = 0 AND RAND() < 0.35;

-- 卫龙大面筋68g*10包 (product 6005, sku 8005, original 19.9): seckill=12.9 补贴=7/组
UPDATE `order` o
JOIN `order_item` oi ON oi.order_id = o.id
SET o.platform_subsidy = o.platform_subsidy + ROUND(7.0 * oi.quantity, 2),
    o.discount_amount = o.discount_amount + ROUND(7.0 * oi.quantity, 2)
WHERE o.status = 4 AND oi.sku_id = 8005 AND o.platform_subsidy = 0 AND RAND() < 0.50;

-- 有友泡椒凤爪 (product 6017, sku 8017, original 18.9): seckill=12.9 补贴=6/袋
UPDATE `order` o
JOIN `order_item` oi ON oi.order_id = o.id
SET o.platform_subsidy = o.platform_subsidy + ROUND(6.0 * oi.quantity, 2),
    o.discount_amount = o.discount_amount + ROUND(6.0 * oi.quantity, 2)
WHERE o.status = 4 AND oi.sku_id = 8017 AND o.platform_subsidy = 0 AND RAND() < 0.45;

-- 金龙鱼稻花香大米5kg (product 6013, sku 8013, original 68): seckill=55 补贴=13/袋
UPDATE `order` o
JOIN `order_item` oi ON oi.order_id = o.id
SET o.platform_subsidy = o.platform_subsidy + ROUND(13.0 * oi.quantity, 2),
    o.discount_amount = o.discount_amount + ROUND(13.0 * oi.quantity, 2)
WHERE o.status = 4 AND oi.sku_id = 8013 AND o.platform_subsidy = 0 AND RAND() < 0.40;


-- =====================================================
-- Part I: 关联优惠券核销记录
-- =====================================================

-- 为有补贴的已完成订单，关联coupon_user记录（标记已使用status=1）
UPDATE `coupon_user` cu
JOIN (
  SELECT DISTINCT o.user_id, o.id AS order_id, o.platform_subsidy
  FROM `order` o
  WHERE o.status = 4 AND o.platform_subsidy > 0
) od ON cu.user_id = od.user_id
SET cu.order_id = od.order_id, 
    cu.status = 1, 
    cu.use_time = (SELECT create_time FROM `order` WHERE id = od.order_id)
WHERE cu.status = 0 AND cu.coupon_id IN (901, 902, 903, 904, 905, 906, 911, 912, 913, 914, 915, 916)
  AND RAND() < 0.5
LIMIT 200;


-- =====================================================
-- Part J: 数据验证
-- =====================================================

SELECT '=== 优惠券统计 ===' AS info;
SELECT 
  CASE 
    WHEN id BETWEEN 900 AND 910 THEN '满减活动'
    WHEN id BETWEEN 911 AND 920 THEN '会员等级券'
    WHEN id BETWEEN 200101 AND 200602 THEN '店铺优惠券'
    ELSE '其他'
  END AS coupon_type,
  COUNT(*) AS cnt, SUM(total_count) AS total_qty
FROM coupon GROUP BY coupon_type;

SELECT '=== 秒杀活动 ===' AS info;
SELECT sa.title, COUNT(sp.id) AS product_count
FROM seckill_activity sa
LEFT JOIN seckill_product sp ON sp.seckill_activity_id = sa.id
GROUP BY sa.id, sa.title;

SELECT '=== 订单平台补贴统计 ===' AS info;
SELECT 
  COUNT(*) AS total_orders_with_subsidy,
  ROUND(SUM(platform_subsidy), 2) AS total_subsidy,
  ROUND(AVG(platform_subsidy), 2) AS avg_subsidy
FROM `order` WHERE platform_subsidy > 0;

SELECT '=== 各商家补贴分布（Top 10） ===' AS info;
SELECT o.merchant_id, m.merchant_name, COUNT(*) AS order_cnt,
  ROUND(SUM(o.platform_subsidy), 2) AS total_subsidy
FROM `order` o
JOIN merchant m ON m.id = o.merchant_id
WHERE o.platform_subsidy > 0
GROUP BY o.merchant_id, m.merchant_name
ORDER BY total_subsidy DESC LIMIT 10;

SELECT '=== 会员等级优惠券领取情况 ===' AS info;
SELECT c.title, COUNT(cu.id) AS received, SUM(CASE WHEN cu.status = 1 THEN 1 ELSE 0 END) AS used
FROM coupon c
LEFT JOIN coupon_user cu ON cu.coupon_id = c.id
WHERE c.id BETWEEN 911 AND 916
GROUP BY c.id, c.title
ORDER BY c.id;

SELECT '=== 虚假商家重命名确认 ===' AS info;
SELECT id, merchant_name FROM merchant WHERE user_id IS NULL ORDER BY id;

SELECT '=== Script completed: update_social_retail_0707_v6_db.sql ===' AS info;
