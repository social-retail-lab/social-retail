-- =====================================================
-- update_social_retail_0707_v9_db.sql
-- 1. 同步cart表结构变更
-- 2. 生成需要平台介入的退款诉求
-- 3. 生成分销员申请请求
-- 4. 将部分商品设置为可被分销状态
-- =====================================================

USE social_retail_db;

SET FOREIGN_KEY_CHECKS = 0;

-- =====================================================
-- Part A: 同步 cart 表结构变更
-- =====================================================

ALTER TABLE `cart`
    ADD COLUMN `attribution_expires_at` datetime DEFAULT NULL COMMENT '归属有效期' AFTER `distributor_product_id`,
    ADD COLUMN `promotion_code` varchar(50) DEFAULT NULL COMMENT '分销推广码' AFTER `attribution_expires_at`,
    ADD INDEX `idx_cart_distribution` (`distributor_product_id`, `attribution_expires_at`);

SELECT '✅ cart 表结构同步完成' AS result;

-- =====================================================
-- Part B: 生成需要平台介入的退款诉求（after_sale）
-- 用户申诉商家处理结果，需要平台介入裁决
-- =====================================================

INSERT INTO `after_sale` (`id`, `order_id`, `order_item_id`, `merchant_id`, `order_sn`, `type`, `service_type`, `refund_amount`, `actual_refund_amount`, `reason`, `evidence_images`, `product_name`, `sku_specs`, `status`, `audit_status`, `refund_status`, `audit_remark`, `reject_reason`, `audit_time`, `return_received_status`, `appeal_status`, `appeal_time`, `appeal_reason`, `intervene_result`, `intervene_action`, `intervene_remark`, `intervene_time`, `return_received_time`, `complete_time`, `update_time`, `feedback_content`, `feedback_images`, `is_deleted`, `apply_time`)
VALUES
(8, 55, 101, 2003, '202605081530030001', 1, 1, 26.40, NULL,
 '商品标注"新鲜采摘"，但收到的水果有明显腐烂斑点，部分已变质'
 ,'["/static/product/6011.jpg"]',
 '海南妃子笑荔枝新鲜当季时令水果5斤装','{\"净重\":\"5斤\",\"包装\":\"泡沫箱保温\"}',5,2,0,NULL,'商品已过24小时新鲜投诉时效，不符合退款条件','2026-07-01 10:00:00',0,1,'2026-07-02 14:00:00',
 '商家以"超过24小时投诉时效"为由拒绝退款，但水果腐烂属于商品品质问题，不属于时限问题，要求平台介入裁决',
 NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-06 00:00:00','已投诉商家','["/static/product/6011_bad.jpg"]',0,'2026-06-25 16:00:00'),

(9, 58, 105, 2004, '202605091500040002', 2, 2, 58.00, NULL,
 '购买的大米与实物描述严重不符，煮后口感很差，疑似陈米掺杂'
 ,'["/static/product/6020.jpg"]',
 '五常大米稻花香2号5kg真空包装','{\"净重\":\"5kg\",\"品质\":\"一等品\"}',5,2,0,NULL,'商品已开封使用，影响二次销售，不予退货','2026-07-01 15:30:00',0,1,'2026-07-03 09:00:00',
 '不拆封怎么知道质量有问题？商家以"已开封影响二次销售"为由拒绝是霸王条款，请平台介入',
 NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-06 00:00:00','已投诉商家','',0,'2026-06-26 09:00:00'),

(10, 65, 112, 2005, '202605102000050003', 1, 1, 35.00, NULL,
 '卤味真空包装漏气，打开后异味明显，无法食用'
 ,'["/static/product/6026.jpg"]',
 '卤味侠麻辣鸭脖真空装200g','{\"规格\":\"200g\",\"口味\":\"麻辣\"}',5,2,0,NULL,'真空包装漏气可能是运输造成，非商家责任','2026-07-02 11:00:00',0,1,'2026-07-03 16:00:00',
 '商家和快递互相推诿，消费者权益无人保障，要求平台介入处理并退款',
 NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-06 00:00:00','已投诉商家','',0,'2026-06-28 14:00:00'),

(11, 72, 119, 2006, '202605112500060004', 2, 2, 68.00, NULL,
 '购买的本地面包酸橙和青柠口味中酸橙包已变质发霉，附有照片证据'
 ,'["/static/product/6030.jpg"]',
 '本地面包酸橙芒果椰子和青柠口味','{\"口味\":\"综合\",\"数量\":\"3个装\"}',5,2,0,NULL,'食品一经售出不退不换','2026-07-01 10:00:00',0,1,'2026-07-02 08:00:00',
 '食品安全法规定售出变质食品应退一赔十，商家态度恶劣，请平台严肃处理',
 NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-06 00:00:00','已投诉商家','["/static/product/6030_mold.jpg"]',0,'2026-06-30 10:00:00'),

(12, 75, 125, 2011, '202605121800110005', 1, 1, 89.00, NULL,
 '购买的婴儿奶粉批次与网店页面展示不符，担心产品质量，要求退货'
 ,'["/static/product/6040.jpg"]',
 'a2 Platinum 婴儿配方奶粉1段900g','{\"规格\":\"900g\",\"段数\":\"1段\"}',5,2,0,NULL,'跨境商品一经发货不支持退款','2026-07-02 09:00:00',0,1,'2026-07-03 18:00:00',
 '收到货品批次不同属于商家发货问题，不是我的责任，平台应保障消费者知情权',
 NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-06 00:00:00','已投诉商家','',0,'2026-06-29 11:00:00'),

(13, 81, 131, 2012, '202605131900120006', 2, 2, 45.00, NULL,
 '购买的曲奇饼干收到后发现包装盒已开封，部分饼干碎裂，密封条破损'
 ,'["/static/product/6048.jpg"]',
 '丹麦蓝罐曲奇礼盒装908g','{\"规格\":\"908g\",\"包装\":\"礼盒\"}',5,2,0,NULL,'商品发出时完好，属物流责任','2026-07-01 16:00:00',0,1,'2026-07-04 10:00:00',
 '商家和物流互不认责，我作为收货方凭什么承担损失，要求平台裁定责任人并退款',
 NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-06 00:00:00','已投诉商家','["/static/product/6048_open.jpg"]',0,'2026-06-27 15:00:00'),

(14, 85, 135, 2014, '202605142100140007', 1, 1, 28.50, NULL,
 '写字钢笔到手后无法正常出墨，反复清洗磨尖都无效，怀疑是假货'
 ,'["/static/product/6054.jpg"]',
 '派克IM系列丽雅黑金夹墨水笔','{\"颜色\":\"丽雅黑金夹\",\"类型\":\"墨水笔\"}',5,2,0,NULL,'正品笔经检测出墨正常，拒绝退款','2026-07-02 14:00:00',0,1,'2026-07-04 16:00:00',
 '强烈怀疑是假货，要求平台检测真伪，如果是假货要求退一赔三',
 NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-06 00:00:00','已投诉商家','',0,'2026-06-28 09:00:00');

SELECT '✅ 平台介入型的 after_sale 记录生成完成' AS result;

-- =====================================================
-- Part C: 生成分销员申请请求
-- =====================================================

INSERT INTO `distributor_apply` (`id`, `user_id`, `real_name`, `id_card_no`, `id_card_front`, `id_card_back`, `bank_name`, `bank_card_no`, `bank_account_name`, `audit_status`, `apply_time`)
VALUES
(1, 1007, '张伟', '330102199003154012', '/static/idcard/front_1007.jpg', '/static/idcard/back_1007.jpg',
 '中国工商银行', '6222021234567890123', '张伟', 0, '2026-07-01 10:00:00'),
(2, 1008, '李娜', '440103199212081825', '/static/idcard/front_1008.jpg', '/static/idcard/back_1008.jpg',
 '中国建设银行', '6227003344556677889', '李娜', 0, '2026-07-02 14:00:00'),
(3, 1009, '王芳', '310105198806153029', '/static/idcard/front_1009.jpg', '/static/idcard/back_1009.jpg',
 '招商银行', '6214850212345678', '王芳', 0, '2026-07-03 09:00:00'),
(4, 1010, '赵强', '330106199507152016', '/static/idcard/front_1010.jpg', '/static/idcard/back_1010.jpg',
 '中国银行', '6216601234567890145', '赵强', 0, '2026-07-03 16:00:00'),
(5, 1011, '陈静', '320102199411223627', '/static/idcard/front_1011.jpg', '/static/idcard/back_1011.jpg',
 '中国农业银行', '6228481234567891123', '陈静', 0, '2026-07-04 11:00:00'),
(6, 1012, '刘洋', '130103199801015134', '/static/idcard/front_1012.jpg', '/static/idcard/back_1012.jpg',
 '交通银行', '6222600123456789', '刘洋', 0, '2026-07-05 08:00:00'),
(7, 1013, '孙丽', '370102199307224528', '/static/idcard/front_1013.jpg', '/static/idcard/back_1013.jpg',
 '中国邮政储蓄银行', '6217991234567890234', '孙丽', 0, '2026-07-05 15:00:00'),
(8, 1014, '陈伟', '420103199610123319', '/static/idcard/front_1014.jpg', '/static/idcard/back_1014.jpg',
 '浦发银行', '6217921234567890123', '陈伟', 0, '2026-07-06 10:00:00');

SELECT '✅ 分销员申请请求生成完成' AS result;

-- =====================================================
-- Part D: 将部分商品设置为可被分销状态
-- 为不同商家添加分销商品（已有 merchant 2001 的 2 个）
-- =====================================================

INSERT INTO `merchant_distribution_product` (`merchant_id`, `product_id`, `commission_rate`, `status`)
VALUES
-- 2002 食愈小站
(2002, 6005, 8.00, 1),
(2002, 6006, 10.00, 1),
-- 2003 鲜禧果仓
(2003, 6009, 12.00, 1),
(2003, 6010, 10.00, 1),
-- 2004 家禾粮油副食
(2004, 6018, 6.00, 1),
(2004, 6020, 8.00, 1),
-- 2005 巷味卤货
(2005, 6025, 10.00, 1),
(2005, 6026, 12.00, 1),
-- 2006 果汽鲜饮
(2006, 6029, 15.00, 1),
(2006, 6032, 10.00, 1),
-- 2011 喵吉母婴MiuKids
(2011, 6038, 8.00, 1),
(2011, 6040, 6.00, 1),
-- 2012 焙爱烘焙坊
(2012, 6047, 10.00, 1),
(2012, 6048, 12.00, 1),
-- 2014 第七天文具
(2014, 6053, 15.00, 1),
(2014, 6056, 10.00, 1),
-- 2016 三两茶事
(2016, 6063, 12.00, 1),
(2016, 6065, 10.00, 1);

SELECT '✅ 可被分销商品设置完成' AS result;

SET FOREIGN_KEY_CHECKS = 1;

-- =====================================================
-- Part E: 验证查询
-- =====================================================

-- E1. 申诉中的 after_sale 记录（需要平台介入）
SELECT id, order_sn, merchant_id, product_name, appeal_status, status,
       appeal_reason, apply_time
FROM `after_sale`
WHERE appeal_status = 1
ORDER BY id;

-- E2. 待审核的分销员申请
SELECT id, user_id, real_name, audit_status, apply_time
FROM `distributor_apply`
WHERE audit_status = 0
ORDER BY id;

-- E3. 可分销商品统计
SELECT m.merchant_name, COUNT(mdp.product_id) AS dist_product_count
FROM `merchant_distribution_product` mdp
JOIN `merchant` m ON mdp.merchant_id = m.id
WHERE mdp.status = 1
GROUP BY mdp.merchant_id, m.merchant_name
ORDER BY mdp.merchant_id;

-- E4. cart 表结构确认
SHOW COLUMNS FROM `cart`;
