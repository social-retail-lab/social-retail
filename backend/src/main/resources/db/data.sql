-- ==========================================
-- 测试数据脚本
-- 说明：密码加密使用 MD5(明文 + social-retail-salt)
--       123456    → e18ca020a37ff8c10fc1166f1de931ef
--       admin123  → 56ed087f4411c193dbbb1421745bae12
-- ==========================================
USE `social_retail_db`;

-- ==========================================
-- 1. 用户数据
-- ==========================================
-- 普通用户（密码MD5: 123456）
INSERT INTO `user` (`id`, `phone`, `nickname`, `password`, `avatar`, `sex`, `status`) VALUES
(1001, '13800001001', '张三商家', 'e18ca020a37ff8c10fc1166f1de931ef', 'https://cdn.example.com/avatar/01.png', 1, 1),
(1002, '13800001002', '李四商家', 'e18ca020a37ff8c10fc1166f1de931ef', 'https://cdn.example.com/avatar/02.png', 1, 1),
(1003, '13800001003', '王五商家', 'e18ca020a37ff8c10fc1166f1de931ef', 'https://cdn.example.com/avatar/03.png', 0, 1),
(1004, '13800001004', '赵六买家', 'e18ca020a37ff8c10fc1166f1de931ef', 'https://cdn.example.com/avatar/04.png', 1, 1);

-- ==========================================
-- 2. 商家数据
-- ==========================================
INSERT INTO `merchant` (`id`, `user_id`, `merchant_name`, `logo`, `contact_name`, `contact_phone`, `shop_address`, `business_hours`, `introduction`, `status`, `create_time`) VALUES
(2001, 1001, '鲜果时光（朝阳店）', 'https://cdn.example.com/logo/01.png', '张三', '13800001001', '北京市朝阳区XX路XX号', '08:00-22:00', '主营新鲜水果蔬菜', 1, '2026-06-01 10:00:00'),
(2002, 1002, '优选生鲜旗舰店', 'https://cdn.example.com/logo/02.png', '李四', '13800001002', '北京市海淀区YY路YY号', '09:00-21:00', '优选品质生鲜', 1, '2026-06-10 15:00:00'),
(2003, 1003, '绿色田园有机店', 'https://cdn.example.com/logo/03.png', '王五', '13800001003', '北京市丰台区ZZ路ZZ号', '07:30-20:30', '有机认证蔬菜基地直供', 2, '2026-06-15 09:00:00');

-- ==========================================
-- 3. 商家资质
-- ==========================================
INSERT INTO `merchant_qualification` (`id`, `merchant_id`, `business_category`, `license_number`, `license_image`, `food_permit_number`, `food_permit_image`) VALUES
(3001, 2001, '水果蔬菜', '91110108MA01XXX01', 'https://cdn.example.com/license/01.jpg', 'JY1110108XXX01', 'https://cdn.example.com/food_permit/01.jpg'),
(3002, 2002, '水果蔬菜', '91110108MA01XXX02', 'https://cdn.example.com/license/02.jpg', 'JY1110108XXX02', 'https://cdn.example.com/food_permit/02.jpg'),
(3003, 2003, '有机食品', '91110108MA01XXX03', 'https://cdn.example.com/license/03.jpg', NULL, NULL);

-- ==========================================
-- 4. 商家入驻申请（待审核数据）
-- ==========================================
INSERT INTO `merchant_apply` (`id`, `user_id`, `apply_type`, `company_name`, `id_card_front`, `id_card_back`, `license_number`, `license_image`, `food_permit_number`, `food_permit_image`, `contact_name`, `contact_phone`, `shop_address`, `shop_name`, `audit_status`, `audit_remark`, `apply_time`) VALUES
(4001, 1004, 2, '赵六农产品公司', 'https://cdn.example.com/id_front/04.jpg', 'https://cdn.example.com/id_back/04.jpg', '91110108MA01XXX04', 'https://cdn.example.com/license/04.jpg', 'JY1110108XXX04', 'https://cdn.example.com/food_permit/04.jpg', '赵六', '13800001004', '北京市通州区WW路WW号', '赵六农产品直营店', 0, NULL, '2026-06-27 09:00:00'),
(4002, 1003, 2, '绿色田园食品有限公司', 'https://cdn.example.com/id_front/03.jpg', 'https://cdn.example.com/id_back/03.jpg', '91110108MA01XXX03', 'https://cdn.example.com/license/03.jpg', 'JY1110108XXX03', 'https://cdn.example.com/food_permit/03.jpg', '王五', '13800001003', '北京市大兴区VV路VV号', '绿色田园（大兴店）', 0, NULL, '2026-06-27 10:00:00'),
(4003, 1004, 1, '个体水果摊', 'https://cdn.example.com/id_front/04.jpg', 'https://cdn.example.com/id_back/04.jpg', NULL, NULL, NULL, NULL, '赵六', '13800001004', '北京市通州区XX小区', '小赵水果', 1, '个人资质齐全，审核通过', '2026-06-26 08:00:00');

-- ==========================================
-- 5. 品牌数据
-- ==========================================
INSERT INTO `brand` (`id`, `name`, `logo`, `description`, `create_time`) VALUES
(5001, '阿克苏', 'https://cdn.example.com/brand/01.png', '新疆阿克苏苹果品牌', '2026-01-01 10:00:00'),
(5002, '褚橙', 'https://cdn.example.com/brand/02.png', '云南冰糖橙品牌', '2026-01-05 10:00:00'),
(5003, '都乐', 'https://cdn.example.com/brand/03.png', '国际水果品牌', '2026-02-01 10:00:00'),
(5004, '佳沛', 'https://cdn.example.com/brand/04.png', '新西兰奇异果品牌', '2026-02-15 10:00:00');

-- ==========================================
-- 6. 商品分类数据
-- ==========================================
INSERT INTO `category` (`id`, `parent_id`, `name`, `level`, `sort_order`) VALUES
-- 一级分类
(101, NULL, '生鲜水果', 1, 1),
(102, NULL, '蔬菜豆菇', 1, 2),
(103, NULL, '肉禽蛋奶', 1, 3),
-- 二级分类（生鲜水果子类）
(111, 101, '进口水果', 2, 1),
(112, 101, '国产水果', 2, 2),
-- 三级分类（国产水果子类）
(121, 112, '苹果', 3, 1),
(122, 112, '橙子', 3, 2),
(123, 112, '奇异果', 3, 3),
-- 二级分类（蔬菜豆菇子类）
(113, 102, '叶菜类', 2, 1),
(114, 102, '根茎类', 2, 2),
-- 三级分类
(124, 113, '菠菜', 3, 1),
(125, 113, '生菜', 3, 2),
(126, 114, '土豆', 3, 1);

-- ==========================================
-- 7. 商品数据
-- ==========================================
INSERT INTO `product` (`id`, `brand_id`, `merchant_id`, `title`, `sub_title`, `main_image`, `detail_desc`, `detail_images`, `sale_type`, `status`, `audit_status`, `audit_remark`, `audit_time`, `create_time`, `update_time`) VALUES
-- 已审核通过已上架
(6001, 5001, 2001, '新疆阿克苏冰糖心苹果 5斤装', '产地直发 甜脆多汁', 'https://cdn.example.com/product/main_01.jpg', '<p>正宗新疆阿克苏冰糖心苹果，产地直发，甜脆多汁</p>', '["https://cdn.example.com/product/detail_01_1.jpg","https://cdn.example.com/product/detail_01_2.jpg"]', 3, 1, 1, '商品信息合规，审核通过', '2026-06-20 14:00:00', '2026-06-19 10:00:00', '2026-06-20 14:00:00'),
-- 已审核通过已上架
(6002, 5002, 2001, '云南褚橙 10斤装', '冰糖橙 新鲜当季水果', 'https://cdn.example.com/product/main_02.jpg', '<p>云南哀牢山褚橙，皮薄汁多，甜而不腻</p>', '["https://cdn.example.com/product/detail_02_1.jpg","https://cdn.example.com/product/detail_02_2.jpg"]', 3, 1, 1, '审核通过', '2026-06-20 15:00:00', '2026-06-19 11:00:00', '2026-06-20 15:00:00'),
-- 已审核通过已下架
(6003, 5003, 2002, '都乐进口香蕉 2斤装', '菲律宾进口 香甜软糯', 'https://cdn.example.com/product/main_03.jpg', '<p>菲律宾原装进口都乐香蕉</p>', '["https://cdn.example.com/product/detail_03_1.jpg"]', 2, 0, 1, '审核通过', '2026-06-21 10:00:00', '2026-06-20 09:00:00', '2026-06-22 08:00:00'),
-- 待审核
(6004, 5004, 2002, '佳沛新西兰奇异果 12枚装', '阳光金果 维C之王', 'https://cdn.example.com/product/main_04.jpg', '<p>新西兰原箱进口佳沛奇异果</p>', '["https://cdn.example.com/product/detail_04_1.jpg","https://cdn.example.com/product/detail_04_2.jpg"]', 1, 0, 0, NULL, NULL, '2026-06-27 08:00:00', '2026-06-27 08:00:00'),
-- 审核拒绝
(6005, 5001, 2001, '阿克苏特级大苹果礼盒装', '精选大果 送礼佳品', 'https://cdn.example.com/product/main_05.jpg', '<p>精选特级大果礼盒</p>', '["https://cdn.example.com/product/detail_05_1.jpg"]', 3, 0, 2, '主图与实物不符，请重新上传', '2026-06-26 16:00:00', '2026-06-25 14:00:00', '2026-06-26 16:00:00'),
-- 待审核（新发布）
(6006, 5003, 2001, '都乐菲律宾凤梨 1个装', '酸甜可口 无需泡盐水', 'https://cdn.example.com/product/main_06.jpg', '<p>都乐金钻凤梨，无需泡盐水直接食用</p>', '["https://cdn.example.com/product/detail_06_1.jpg"]', 2, 0, 0, NULL, NULL, '2026-06-27 09:00:00', '2026-06-27 09:00:00');

-- ==========================================
-- 8. 商品分类关联
-- ==========================================
INSERT INTO `product_category_relation` (`id`, `product_id`, `category_id`) VALUES
-- 苹果 -> 苹果(三级) + 国产水果(二级) + 生鲜水果(一级)
(7001, 6001, 121), (7002, 6001, 112), (7003, 6001, 101),
-- 褚橙 -> 橙子(三级) + 国产水果(二级) + 生鲜水果(一级)
(7004, 6002, 122), (7005, 6002, 112), (7006, 6002, 101),
-- 香蕉 -> 进口水果(二级) + 生鲜水果(一级)
(7007, 6003, 111), (7008, 6003, 101),
-- 奇异果 -> 奇异果(三级) + 国产水果(二级) + 生鲜水果(一级)
(7009, 6004, 123), (7010, 6004, 112), (7011, 6004, 101),
-- 苹果礼盒 -> 苹果(三级) + 国产水果(二级) + 生鲜水果(一级)
(7012, 6005, 121), (7013, 6005, 112), (7014, 6005, 101),
-- 凤梨 -> 进口水果(二级) + 生鲜水果(一级)
(7015, 6006, 111), (7016, 6006, 101);

-- ==========================================
-- 9. SKU数据
-- ==========================================
INSERT INTO `sku` (`id`, `product_id`, `specs`, `price`, `stock`, `sku_code`) VALUES
-- 苹果6001的SKU
(8001, 6001, '{"规格":"5斤装","果径":"80-85mm"}', 39.90, 200, 'AKS-APPLE-5J-80'),
(8002, 6001, '{"规格":"10斤装","果径":"85-90mm"}', 69.90, 100, 'AKS-APPLE-10J-85'),
(8003, 6001, '{"规格":"5斤装","果径":"90mm以上"}', 49.90, 50, 'AKS-APPLE-5J-90'),
-- 褚橙6002的SKU
(8004, 6002, '{"规格":"5斤装","等级":"一级果"}', 45.00, 150, 'CC-ORANGE-5J-1'),
(8005, 6002, '{"规格":"10斤装","等级":"特级果"}', 85.00, 80, 'CC-ORANGE-10J-S'),
-- 香蕉6003的SKU
(8006, 6003, '{"规格":"2斤装","成熟度":"7-8分熟"}', 12.90, 300, 'DL-BANANA-2J'),
(8007, 6003, '{"规格":"5斤装","成熟度":"7-8分熟"}', 28.90, 150, 'DL-BANANA-5J'),
-- 奇异果6004的SKU
(8008, 6004, '{"规格":"12枚装","品类":"阳光金果"}', 59.90, 100, 'ZP-KIWI-12-GOLD'),
(8009, 6004, '{"规格":"12枚装","品类":"绿果"}', 39.90, 120, 'ZP-KIWI-12-GREEN'),
-- 苹果礼盒6005的SKU
(8010, 6005, '{"规格":"礼盒装6枚","果径":"95mm+特级"}', 128.00, 30, 'AKS-GIFT-6-95'),
-- 凤梨6006的SKU
(8011, 6006, '{"规格":"单果1.5-2斤","等级":"一级"}', 19.90, 80, 'DL-PINE-1');

-- ==========================================
-- 10. 运营管理员
-- ==========================================
-- 密码明文: admin123 → MD5+salt: 56ed087f4411c193dbbb1421745bae12
INSERT INTO `operation_admin` (`id`, `username`, `password`, `real_name`, `phone`, `email`, `role`, `status`, `last_login_time`, `create_time`) VALUES
(9001, 'operator01', '56ed087f4411c193dbbb1421745bae12', '运营张三', '13900001001', 'zhangsan@example.com', '商品运营', 1, '2026-06-28 09:00:00', '2026-01-01 00:00:00'),
(9002, 'operator02', '56ed087f4411c193dbbb1421745bae12', '运营李四', '13900001002', 'lisi@example.com', '内容运营', 1, '2026-06-28 10:00:00', '2026-02-01 00:00:00');

-- ==========================================
-- 11. 系统管理员
-- ==========================================
INSERT INTO `system_admin` (`id`, `username`, `password`, `real_name`, `phone`, `email`, `role`, `status`, `last_login_time`, `create_time`) VALUES
(10001, 'superadmin', '56ed087f4411c193dbbb1421745bae12', '系统管理员', '13800000000', 'admin@example.com', 'SUPER_ADMIN', 1, '2026-06-28 08:00:00', '2026-01-01 00:00:00');
