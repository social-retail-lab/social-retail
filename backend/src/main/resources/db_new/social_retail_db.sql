/*
 Navicat Premium Dump SQL

 Source Server         : localhost_3306_1
 Source Server Type    : MySQL
 Source Server Version : 80046 (8.0.46)
 Source Host           : localhost:3306
 Source Schema         : social_retail_db

 Target Server Type    : MySQL
 Target Server Version : 80046 (8.0.46)
 File Encoding         : 65001

 Date: 06/07/2026 14:21:23
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for address
-- ----------------------------
DROP TABLE IF EXISTS `address`;
CREATE TABLE `address`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '地址ID（主键）',
  `user_id` bigint NULL DEFAULT NULL COMMENT '用户ID',
  `consignee` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '收货人姓名',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '收货人电话',
  `province` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '省份',
  `city` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '城市',
  `district` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '区县',
  `detailed_address` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '详细地址',
  `is_default` tinyint NULL DEFAULT NULL COMMENT '是否默认地址',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_address_user`(`user_id` ASC) USING BTREE,
  CONSTRAINT `fk_address_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '收货地址表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of address
-- ----------------------------

-- ----------------------------
-- Table structure for after_sale
-- ----------------------------
DROP TABLE IF EXISTS `after_sale`;
CREATE TABLE `after_sale`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '售后ID（主键）',
  `order_id` bigint NULL DEFAULT NULL COMMENT '订单ID',
  `order_item_id` bigint NULL DEFAULT NULL COMMENT '订单明细ID',
  `type` tinyint NULL DEFAULT NULL COMMENT '售后类型（仅退款/退货退款）',
  `refund_amount` decimal(10, 2) NULL DEFAULT NULL COMMENT '申请退款金额',
  `reason` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '申请原因',
  `status` tinyint NULL DEFAULT NULL COMMENT '售后状态',
  `apply_time` datetime NULL DEFAULT NULL COMMENT '申请时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_after_sale_order`(`order_id` ASC) USING BTREE,
  INDEX `fk_after_sale_item`(`order_item_id` ASC) USING BTREE,
  CONSTRAINT `fk_after_sale_item` FOREIGN KEY (`order_item_id`) REFERENCES `order_item` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_after_sale_order` FOREIGN KEY (`order_id`) REFERENCES `order` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '售后申请表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of after_sale
-- ----------------------------

-- ----------------------------
-- Table structure for bargain_activity
-- ----------------------------
DROP TABLE IF EXISTS `bargain_activity`;
CREATE TABLE `bargain_activity`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '砍价活动ID（主键）',
  `user_id` bigint NULL DEFAULT NULL COMMENT '发起用户ID',
  `product_id` bigint NULL DEFAULT NULL COMMENT '商品SpuID',
  `sku_id` bigint NULL DEFAULT NULL COMMENT '商品SkuID',
  `target_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '砍价目标底价',
  `current_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '当前砍后金额',
  `end_time` datetime NULL DEFAULT NULL COMMENT '结束时限',
  `status` tinyint NULL DEFAULT NULL COMMENT '砍价状态',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_bargain_user`(`user_id` ASC) USING BTREE,
  INDEX `fk_bargain_product`(`product_id` ASC) USING BTREE,
  INDEX `fk_bargain_sku`(`sku_id` ASC) USING BTREE,
  CONSTRAINT `fk_bargain_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_bargain_sku` FOREIGN KEY (`sku_id`) REFERENCES `sku` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_bargain_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '砍价活动表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of bargain_activity
-- ----------------------------

-- ----------------------------
-- Table structure for bargain_help_log
-- ----------------------------
DROP TABLE IF EXISTS `bargain_help_log`;
CREATE TABLE `bargain_help_log`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '帮砍记录ID',
  `bargain_record_id` bigint NOT NULL COMMENT '砍价记录ID，对应 bargain_activity.id',
  `helper_user_id` bigint NOT NULL COMMENT '帮砍用户ID',
  `cut_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '本次帮砍金额',
  `before_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '帮砍前价格',
  `after_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '帮砍后价格',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '帮砍时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_bargain_helper`(`bargain_record_id` ASC, `helper_user_id` ASC) USING BTREE,
  INDEX `fk_bargain_help_user`(`helper_user_id` ASC) USING BTREE,
  CONSTRAINT `fk_bargain_help_record` FOREIGN KEY (`bargain_record_id`) REFERENCES `bargain_activity` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_bargain_help_user` FOREIGN KEY (`helper_user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '砍价帮砍记录表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of bargain_help_log
-- ----------------------------

-- ----------------------------
-- Table structure for brand
-- ----------------------------
DROP TABLE IF EXISTS `brand`;
CREATE TABLE `brand`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '品牌ID（主键）',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '品牌名称',
  `logo` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '品牌Logo',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '品牌介绍',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5051 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '品牌表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of brand
-- ----------------------------
INSERT INTO `brand` VALUES (5001, '三只松鼠', 'brand/5001.jpg', '互联网坚果零食第一品牌', '2026-05-13 15:08:19');
INSERT INTO `brand` VALUES (5002, '良品铺子', 'brand/5002.jpg', '高端全品类零食连锁标杆品牌', '2026-05-06 15:08:27');
INSERT INTO `brand` VALUES (5003, '卫龙', 'brand/5003.jpg', '国民辣味调味零食第一品牌', '2026-06-18 15:08:34');
INSERT INTO `brand` VALUES (5004, '旺旺', 'brand/5004.jpg', '国民童年米果零食经典龙头', '2026-05-26 15:08:40');
INSERT INTO `brand` VALUES (5005, '奉节脐橙', 'brand/5005.jpg', '重庆地标鲜果品牌', '2026-05-30 15:08:47');
INSERT INTO `brand` VALUES (5006, '沃隆', 'brand/5006.jpg', '每日坚果原创开创品牌', '2026-06-03 15:08:56');
INSERT INTO `brand` VALUES (5007, '金龙鱼', 'brand/5007.jpg', '国民粮油龙头品牌', '2026-06-13 15:09:02');
INSERT INTO `brand` VALUES (5008, '涪陵榨菜', 'brand/5008.jpg', '世界三大名腌菜之一', '2026-06-08 15:09:07');
INSERT INTO `brand` VALUES (5009, '绝味鸭脖', 'brand/5009.jpg', '全国连锁卤味熟食龙头品牌', '2026-06-25 15:09:13');
INSERT INTO `brand` VALUES (5010, '有友', 'brand/5010.jpg', '重庆本土卤味零食品牌', '2026-06-30 15:09:19');
INSERT INTO `brand` VALUES (5011, '元气森林', 'brand/5011.jpg', '零糖气泡水健康饮品新锐头部品牌', '2026-06-21 15:09:24');
INSERT INTO `brand` VALUES (5012, '农夫山泉', 'brand/5012.jpg', '国民天然饮用水果汁龙头', '2026-07-02 15:09:30');
INSERT INTO `brand` VALUES (5013, '田园时光', 'brand/5013.jpg', '精选时令蔬菜，有机种植，新鲜直达餐桌', '2026-06-02 10:00:00');
INSERT INTO `brand` VALUES (5014, '草原牧场', 'brand/5014.jpg', '源头直供优质肉禽蛋品，绿色健康，口感鲜美', '2026-06-02 11:00:00');
INSERT INTO `brand` VALUES (5015, '海之鲜', 'brand/5015.jpg', '精选全球优质海鲜，鲜活到家，营养美味', '2026-06-03 09:00:00');
INSERT INTO `brand` VALUES (5016, '茅台', 'brand/5016.jpg', '国酒茅台，酱香经典，中国白酒第一品牌', '2026-06-03 10:00:00');
INSERT INTO `brand` VALUES (5017, '青岛', 'brand/5017.jpg', '百年啤酒品牌，经典口味，畅饮无限', '2026-06-03 10:30:00');
INSERT INTO `brand` VALUES (5018, '雀巢', 'brand/5018.jpg', '全球食品饮料巨头，品质保证，营养健康', '2026-06-03 11:00:00');
INSERT INTO `brand` VALUES (5019, '立顿', 'brand/5019.jpg', '全球最大茶饮品牌，经典口味，品质如一', '2026-06-04 09:00:00');
INSERT INTO `brand` VALUES (5020, '同仁堂', 'brand/5020.jpg', '百年中药老字号，品质滋补，养生首选', '2026-06-04 09:30:00');
INSERT INTO `brand` VALUES (5021, '汤臣倍健', 'brand/5021.jpg', '膳食补充剂领导品牌，科学营养，健康相伴', '2026-06-04 10:00:00');
INSERT INTO `brand` VALUES (5022, '费列罗', 'brand/5022.jpg', '意大利知名巧克力品牌，榛果威化，口感丰富', '2026-06-04 10:30:00');
INSERT INTO `brand` VALUES (5023, '明治', 'brand/5023.jpg', '日本知名食品品牌，巧克力豆，口感细腻', '2026-06-04 11:00:00');
INSERT INTO `brand` VALUES (5024, '水星家纺', 'brand/5024.jpg', '家纺行业领导品牌，舒适睡眠，温馨家居', '2026-06-05 09:00:00');
INSERT INTO `brand` VALUES (5025, '欧普照明', 'brand/5025.jpg', '照明行业领导品牌，节能护眼，品质之光', '2026-06-05 09:30:00');
INSERT INTO `brand` VALUES (5026, '乐扣乐扣', 'brand/5026.jpg', '保鲜盒领导品牌，密封保鲜，健康生活', '2026-06-05 10:00:00');
INSERT INTO `brand` VALUES (5027, '蓝月亮', 'brand/5027.jpg', '洗衣液领导品牌，温和洁净，呵护衣物', '2026-06-05 10:30:00');
INSERT INTO `brand` VALUES (5028, '维达', 'brand/5028.jpg', '纸巾领导品牌，柔软亲肤，品质生活', '2026-06-05 11:00:00');
INSERT INTO `brand` VALUES (5029, '箭牌', 'brand/5029.jpg', '卫浴领导品牌，品质卫浴，舒适生活', '2026-06-06 09:00:00');
INSERT INTO `brand` VALUES (5030, '天堂', 'brand/5030.jpg', '雨伞领导品牌，品质保障，风雨无阻', '2026-06-06 09:30:00');
INSERT INTO `brand` VALUES (5031, '茶花', 'brand/5031.jpg', '家居用品领导品牌，品质实用，生活好帮手', '2026-06-06 10:00:00');
INSERT INTO `brand` VALUES (5032, '宜家', 'brand/5032.jpg', '全球知名家居品牌，简约设计，温馨生活', '2026-06-06 10:30:00');
INSERT INTO `brand` VALUES (5033, '皇家', 'brand/5033.jpg', '宠物食品领导品牌，营养均衡，关爱宠物', '2026-06-06 11:00:00');
INSERT INTO `brand` VALUES (5034, '苏泊尔', 'brand/5034.jpg', '厨房电器领导品牌，品质厨房，美味生活', '2026-06-07 09:00:00');
INSERT INTO `brand` VALUES (5035, '张小泉', 'brand/5035.jpg', '百年刀剪老字号，锋利耐用，品质传承', '2026-06-07 09:30:00');
INSERT INTO `brand` VALUES (5036, '富光', 'brand/5036.jpg', '水杯领导品牌，品质饮水，健康生活', '2026-06-07 10:00:00');
INSERT INTO `brand` VALUES (5037, '康宁', 'brand/5037.jpg', '玻璃餐具领导品牌，健康环保，品质生活', '2026-06-07 10:30:00');
INSERT INTO `brand` VALUES (5038, '九阳', 'brand/5038.jpg', '厨房小家电领导品牌，智能便捷，美味厨房', '2026-06-07 11:00:00');
INSERT INTO `brand` VALUES (5039, '欧莱雅', 'brand/5039.jpg', '全球化妆品领导品牌，科技护肤，美丽绽放', '2026-06-08 09:00:00');
INSERT INTO `brand` VALUES (5040, '玉兰油', 'brand/5040.jpg', '全球知名护肤品牌，科学护肤，焕发光彩', '2026-06-08 09:30:00');
INSERT INTO `brand` VALUES (5041, '多芬', 'brand/5041.jpg', '全球知名洗护品牌，温和呵护，美丽自信', '2026-06-08 10:00:00');
INSERT INTO `brand` VALUES (5042, '潘婷', 'brand/5042.jpg', '全球知名护发品牌，修护秀发，健康亮泽', '2026-06-08 10:30:00');
INSERT INTO `brand` VALUES (5043, '高露洁', 'brand/5043.jpg', '全球知名口腔护理品牌，健康口腔，笑容自信', '2026-06-08 11:00:00');
INSERT INTO `brand` VALUES (5044, '护舒宝', 'brand/5044.jpg', '全球知名女性护理品牌，贴心呵护，安心每一天', '2026-06-09 09:00:00');
INSERT INTO `brand` VALUES (5045, '迪奥', 'brand/5045.jpg', '法国奢侈品牌，经典香水，优雅气质', '2026-06-09 09:30:00');
INSERT INTO `brand` VALUES (5046, '美宝莲', 'brand/5046.jpg', '全球知名彩妆品牌，时尚彩妆，美丽绽放', '2026-06-09 10:00:00');
INSERT INTO `brand` VALUES (5047, '美赞臣', 'brand/5047.jpg', '全球知名奶粉品牌，科学配方，呵护成长', '2026-06-10 09:00:00');
INSERT INTO `brand` VALUES (5048, '亨氏', 'brand/5048.jpg', '全球知名辅食品牌，营养辅食，健康成长', '2026-06-10 09:30:00');
INSERT INTO `brand` VALUES (5049, '帮宝适', 'brand/5049.jpg', '全球知名纸尿裤品牌，干爽舒适，呵护宝宝', '2026-06-10 10:00:00');
INSERT INTO `brand` VALUES (5050, '贝亲', 'brand/5050.jpg', '日本知名母婴品牌，品质喂养，呵护宝宝', '2026-06-10 10:30:00');

-- ----------------------------
-- Table structure for cart
-- ----------------------------
DROP TABLE IF EXISTS `cart`;
CREATE TABLE `cart`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '购物车ID（主键）',
  `user_id` bigint NULL DEFAULT NULL COMMENT '用户ID',
  `sku_id` bigint NULL DEFAULT NULL COMMENT 'SkuID',
  `quantity` int NULL DEFAULT NULL COMMENT '购买数量',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_cart_user`(`user_id` ASC) USING BTREE,
  INDEX `fk_cart_sku`(`sku_id` ASC) USING BTREE,
  CONSTRAINT `fk_cart_sku` FOREIGN KEY (`sku_id`) REFERENCES `sku` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_cart_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '购物车表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of cart
-- ----------------------------

-- ----------------------------
-- Table structure for category
-- ----------------------------
DROP TABLE IF EXISTS `category`;
CREATE TABLE `category`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '分类ID（主键）',
  `parent_id` bigint NULL DEFAULT NULL COMMENT '上级分类ID',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '分类名称',
  `level` tinyint NULL DEFAULT NULL COMMENT '层级等级',
  `sort_order` int NULL DEFAULT NULL COMMENT '排序值',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 609 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '商品分类表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of category
-- ----------------------------
INSERT INTO `category` VALUES (1, 0, '生鲜果蔬肉禽', 1, 1);
INSERT INTO `category` VALUES (2, 0, '食品饮料滋补', 1, 2);
INSERT INTO `category` VALUES (3, 0, '家居百货日用品', 1, 3);
INSERT INTO `category` VALUES (4, 0, '厨具餐具厨房配件', 1, 4);
INSERT INTO `category` VALUES (5, 0, '个护美妆清洁', 1, 5);
INSERT INTO `category` VALUES (6, 0, '母婴孕童用品', 1, 6);
INSERT INTO `category` VALUES (101, 1, '新鲜水果', 2, 1);
INSERT INTO `category` VALUES (102, 1, '时令蔬菜', 2, 2);
INSERT INTO `category` VALUES (103, 1, '猪牛羊肉', 2, 3);
INSERT INTO `category` VALUES (104, 1, '海鲜水产', 2, 4);
INSERT INTO `category` VALUES (105, 1, '禽肉蛋品', 2, 5);
INSERT INTO `category` VALUES (106, 1, '冷冻速食', 2, 6);
INSERT INTO `category` VALUES (107, 1, '熟食卤味', 2, 7);
INSERT INTO `category` VALUES (108, 1, '甜品饮品', 2, 8);
INSERT INTO `category` VALUES (201, 2, '休闲零食', 2, 1);
INSERT INTO `category` VALUES (202, 2, '粮油米面调味', 2, 2);
INSERT INTO `category` VALUES (203, 2, '酒水饮料冲调', 2, 3);
INSERT INTO `category` VALUES (204, 2, '进口零食酒水', 2, 4);
INSERT INTO `category` VALUES (205, 2, '地方特产礼盒', 2, 5);
INSERT INTO `category` VALUES (206, 2, '茗茶茶饮', 2, 6);
INSERT INTO `category` VALUES (207, 2, '保健食品滋补品', 2, 7);
INSERT INTO `category` VALUES (208, 2, '食品礼券礼盒', 2, 8);
INSERT INTO `category` VALUES (301, 3, '家纺床品毛巾', 2, 1);
INSERT INTO `category` VALUES (302, 3, '灯具照明', 2, 2);
INSERT INTO `category` VALUES (303, 3, '收纳储物用品', 2, 3);
INSERT INTO `category` VALUES (304, 3, '清洁消杀纸品', 2, 4);
INSERT INTO `category` VALUES (305, 3, '浴室洗漱用品', 2, 5);
INSERT INTO `category` VALUES (306, 3, '雨伞雨具防护', 2, 6);
INSERT INTO `category` VALUES (307, 3, '洗晒熨烫工具', 2, 7);
INSERT INTO `category` VALUES (308, 3, '装饰摆件花艺', 2, 8);
INSERT INTO `category` VALUES (309, 3, '宠物全品类', 2, 9);
INSERT INTO `category` VALUES (401, 4, '烹饪锅具', 2, 1);
INSERT INTO `category` VALUES (402, 4, '刀剪菜板工具', 2, 2);
INSERT INTO `category` VALUES (403, 4, '水杯酒具茶具', 2, 3);
INSERT INTO `category` VALUES (404, 4, '碗盘餐具', 2, 4);
INSERT INTO `category` VALUES (405, 4, '厨房小配件', 2, 5);
INSERT INTO `category` VALUES (406, 4, '商用酒店厨具', 2, 6);
INSERT INTO `category` VALUES (501, 5, '面部护肤', 2, 1);
INSERT INTO `category` VALUES (502, 5, '身体洗护沐浴', 2, 2);
INSERT INTO `category` VALUES (503, 5, '洗发护发', 2, 3);
INSERT INTO `category` VALUES (504, 5, '口腔护理', 2, 4);
INSERT INTO `category` VALUES (505, 5, '女性卫生巾护理', 2, 5);
INSERT INTO `category` VALUES (506, 5, '香水彩妆', 2, 6);
INSERT INTO `category` VALUES (601, 6, '婴幼儿奶粉', 2, 1);
INSERT INTO `category` VALUES (602, 6, '辅食营养零食', 2, 2);
INSERT INTO `category` VALUES (603, 6, '尿裤湿巾', 2, 3);
INSERT INTO `category` VALUES (604, 6, '喂养餐具器具', 2, 4);
INSERT INTO `category` VALUES (605, 6, '宝宝洗护用品', 2, 5);
INSERT INTO `category` VALUES (606, 6, '童装童鞋寝具', 2, 6);
INSERT INTO `category` VALUES (607, 6, '孕妈妈妈专区', 2, 7);
INSERT INTO `category` VALUES (608, 6, '童车安全座椅', 2, 8);

-- ----------------------------
-- Table structure for commission_log
-- ----------------------------
DROP TABLE IF EXISTS `commission_log`;
CREATE TABLE `commission_log`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '流水ID（主键）',
  `distributor_id` bigint NULL DEFAULT NULL COMMENT '收益人分销员ID',
  `order_id` bigint NULL DEFAULT NULL COMMENT '关联交易触发订单ID',
  `order_amount` decimal(10, 2) NULL DEFAULT NULL COMMENT '计提基数总金额',
  `commission_amount` decimal(10, 2) NULL DEFAULT NULL COMMENT '本次分润佣金金额',
  `status` tinyint NULL DEFAULT NULL COMMENT '清算状态',
  `settlement_time` datetime NULL DEFAULT NULL COMMENT '入账钱包清算时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_comm_distributor`(`distributor_id` ASC) USING BTREE,
  INDEX `fk_comm_order`(`order_id` ASC) USING BTREE,
  CONSTRAINT `fk_comm_distributor` FOREIGN KEY (`distributor_id`) REFERENCES `distributor` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_comm_order` FOREIGN KEY (`order_id`) REFERENCES `order` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '佣金流水结算表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of commission_log
-- ----------------------------

-- ----------------------------
-- Table structure for coupon
-- ----------------------------
DROP TABLE IF EXISTS `coupon`;
CREATE TABLE `coupon`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '优惠券ID（主键）',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '优惠券名称',
  `type` tinyint NULL DEFAULT NULL COMMENT '适用类型',
  `min_consume` decimal(10, 2) NULL DEFAULT NULL COMMENT '满减门槛金额',
  `discount_amount` decimal(10, 2) NULL DEFAULT NULL COMMENT '面值抵扣金额',
  `total_count` int NULL DEFAULT NULL COMMENT '发行总量',
  `received_count` int NOT NULL DEFAULT 0 COMMENT '已领取数量',
  `per_user_limit` int NOT NULL DEFAULT 1 COMMENT '每人限领数量',
  `exchange_points` int NULL DEFAULT 0 COMMENT '兑换所需积分，0表示免费领取',
  `member_level_required` tinyint NULL DEFAULT 0 COMMENT '领取会员等级门槛: 0不限制 1普通会员 2银卡会员 3金卡会员 4钻石会员',
  `valid_start` datetime NULL DEFAULT NULL COMMENT '有效期开始时间',
  `valid_end` datetime NULL DEFAULT NULL COMMENT '有效期截止时间',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态：0禁用 1启用',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '优惠券主表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of coupon
-- ----------------------------

-- ----------------------------
-- Table structure for coupon_user
-- ----------------------------
DROP TABLE IF EXISTS `coupon_user`;
CREATE TABLE `coupon_user`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '领用记录ID（主键）',
  `coupon_id` bigint NULL DEFAULT NULL COMMENT '优惠券模版ID',
  `user_id` bigint NULL DEFAULT NULL COMMENT '持有用户ID',
  `order_id` bigint NULL DEFAULT NULL COMMENT '核销抵扣订单ID',
  `status` tinyint NULL DEFAULT NULL COMMENT '状态（未使用/已用/过期）',
  `receive_time` datetime NULL DEFAULT NULL COMMENT '领取时间',
  `use_time` datetime NULL DEFAULT NULL COMMENT '使用核销时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_coupon_template`(`coupon_id` ASC) USING BTREE,
  INDEX `fk_coupon_user`(`user_id` ASC) USING BTREE,
  INDEX `fk_coupon_order`(`order_id` ASC) USING BTREE,
  CONSTRAINT `fk_coupon_order` FOREIGN KEY (`order_id`) REFERENCES `order` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_coupon_template` FOREIGN KEY (`coupon_id`) REFERENCES `coupon` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_coupon_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '优惠券领用记录表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of coupon_user
-- ----------------------------

-- ----------------------------
-- Table structure for delivery
-- ----------------------------
DROP TABLE IF EXISTS `delivery`;
CREATE TABLE `delivery`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '配送单ID（主键）',
  `order_id` bigint NULL DEFAULT NULL COMMENT '订单ID',
  `delivery_sn` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '物流运单号',
  `dispatcher_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '配送员/骑手姓名',
  `dispatcher_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '配送员电话',
  `status` tinyint NULL DEFAULT NULL COMMENT '配送状态',
  `start_time` datetime NULL DEFAULT NULL COMMENT '出发时间',
  `end_time` datetime NULL DEFAULT NULL COMMENT '送达时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_delivery_order`(`order_id` ASC) USING BTREE,
  CONSTRAINT `fk_delivery_order` FOREIGN KEY (`order_id`) REFERENCES `order` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '配送单表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of delivery
-- ----------------------------

-- ----------------------------
-- Table structure for discount_rule
-- ----------------------------
DROP TABLE IF EXISTS `discount_rule`;
CREATE TABLE `discount_rule`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '满减满折规则ID',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '规则名称',
  `type` tinyint NOT NULL COMMENT '规则类型：1满减 2满折',
  `min_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '满足金额门槛',
  `discount_amount` decimal(10, 2) NULL DEFAULT NULL COMMENT '满减金额',
  `discount_rate` decimal(5, 2) NULL DEFAULT NULL COMMENT '折扣比例，如8.50表示8.5折',
  `start_time` datetime NULL DEFAULT NULL COMMENT '开始时间',
  `end_time` datetime NULL DEFAULT NULL COMMENT '结束时间',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态：0禁用 1启用',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '满减满折规则表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of discount_rule
-- ----------------------------

-- ----------------------------
-- Table structure for distributor
-- ----------------------------
DROP TABLE IF EXISTS `distributor`;
CREATE TABLE `distributor`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '分销员ID（主键）',
  `user_id` bigint NULL DEFAULT NULL COMMENT '用户ID',
  `total_commission` decimal(10, 2) NULL DEFAULT NULL COMMENT '累计佣金',
  `frozen_commission` decimal(10, 2) NULL DEFAULT NULL COMMENT '冻结佣金',
  `status` tinyint NULL DEFAULT NULL COMMENT '分销状态',
  `apply_time` datetime NULL DEFAULT NULL COMMENT '申请时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_distributor_user`(`user_id` ASC) USING BTREE,
  CONSTRAINT `fk_distributor_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '分销员表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of distributor
-- ----------------------------

-- ----------------------------
-- Table structure for file_record
-- ----------------------------
DROP TABLE IF EXISTS `file_record`;
CREATE TABLE `file_record`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '文件ID',
  `owner_user_id` bigint NOT NULL COMMENT '上传用户ID',
  `upload_type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '上传业务类型',
  `business_id` bigint NULL DEFAULT NULL COMMENT '关联业务ID',
  `original_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '原文件名',
  `stored_path` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'uploads目录下的相对路径',
  `file_size` bigint NOT NULL COMMENT '文件大小（字节）',
  `content_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '实际图片类型',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `is_deleted` tinyint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_file_stored_path`(`stored_path` ASC) USING BTREE,
  INDEX `idx_file_owner`(`owner_user_id` ASC, `is_deleted` ASC) USING BTREE,
  INDEX `idx_file_business`(`upload_type` ASC, `business_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '本地上传文件元数据' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of file_record
-- ----------------------------

-- ----------------------------
-- Table structure for growth_log
-- ----------------------------
DROP TABLE IF EXISTS `growth_log`;
CREATE TABLE `growth_log`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志ID（主键）',
  `user_id` bigint NULL DEFAULT NULL COMMENT '用户ID',
  `type` tinyint NULL DEFAULT NULL COMMENT '来源渠道类型',
  `change_growth` int NULL DEFAULT NULL COMMENT '变更成长值数额',
  `current_growth` int NULL DEFAULT NULL COMMENT '最新累计总成长值',
  `remark` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '行为场景备注',
  `create_time` datetime NULL DEFAULT NULL COMMENT '变动记录时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_growth_log_user`(`user_id` ASC) USING BTREE,
  CONSTRAINT `fk_growth_log_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '成长值变更日志表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of growth_log
-- ----------------------------

-- ----------------------------
-- Table structure for member
-- ----------------------------
DROP TABLE IF EXISTS `member`;
CREATE TABLE `member`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '会员ID（主键）',
  `user_id` bigint NULL DEFAULT NULL COMMENT '用户ID',
  `member_level` tinyint NULL DEFAULT NULL COMMENT '会员等级',
  `points_balance` int NULL DEFAULT NULL COMMENT '积分余额',
  `growth_value` int NULL DEFAULT NULL COMMENT '成长值',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_member_user`(`user_id` ASC) USING BTREE,
  CONSTRAINT `fk_member_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '会员表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of member
-- ----------------------------

-- ----------------------------
-- Table structure for merchant
-- ----------------------------
DROP TABLE IF EXISTS `merchant`;
CREATE TABLE `merchant`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '商家ID（主键）',
  `user_id` bigint NULL DEFAULT NULL COMMENT '关联用户ID',
  `merchant_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '商家名称',
  `logo` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '商家Logo',
  `contact_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '联系人',
  `contact_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '联系电话',
  `shop_address` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '店铺地址',
  `business_hours` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '营业时间',
  `introduction` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '店铺简介',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `status` tinyint NULL DEFAULT NULL COMMENT '营业状态（0-关闭，1-营业，5-暂时歇业）',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_merchant_user`(`user_id` ASC) USING BTREE,
  CONSTRAINT `fk_merchant_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 2026 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '商家表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of merchant
-- ----------------------------
INSERT INTO `merchant` VALUES (2001, 1001, '润禾生活食铺', 'merchant/1001.jpg', '陈心意', '17782224500', '重庆市渝北区金开大道星光天地12铺', '08:00-22:00', '休闲零食、熟食卤味', '2026-05-05 10:41:16', 1);
INSERT INTO `merchant` VALUES (2002, 1002, '食愈小铺', 'merchant/1002.jpg', '王瑞', '17782224501', '重庆市江北区观音桥星光68负一楼', '08:00-22:00', '休闲零食、甜品饮品', '2026-05-07 10:41:24', 1);
INSERT INTO `merchant` VALUES (2003, 1003, '鲜禧果仓', 'merchant/1003.jpg', '李思琪', '17782224502', '重庆市南岸区南坪协信星光一层', '08:00-22:00', '新鲜水果、时令蔬菜', '2026-05-19 10:41:33', 1);
INSERT INTO `merchant` VALUES (2004, 1004, '家禾粮油副食', 'merchant/1004.jpg', '赵红', '17782224503', '重庆市九龙坡区杨家坪直港大道', '08:00-22:00', '粮油米面、海鲜水产', '2026-05-29 10:41:40', 1);
INSERT INTO `merchant` VALUES (2005, 1005, '巷味卤货', 'merchant/1005.jpg', '钱森', '17782224504', '重庆市渝中区两路口桂花园路', '08:00-22:00', '熟食卤味、冷冻速食', '2026-06-03 10:41:49', 1);
INSERT INTO `merchant` VALUES (2006, 1006, '果汽鲜饮', 'merchant/1006.jpg', '张康泰', '17782224505', '重庆市南岸区茶园时代都汇临街铺', '08:00-22:00', '酒水饮料、甜品饮品', '2026-06-12 10:41:57', 1);
INSERT INTO `merchant` VALUES (2007, 1007, '臻品生活馆', 'merchant/1007.jpg', '陈勇', '17782224506', '重庆市大渡口区新山村街道钢花路 56 号', '08:00-22:00', '家居百货、个护美妆', '2026-06-21 10:42:04', 1);
INSERT INTO `merchant` VALUES (2008, 1008, '厨乐坊', 'merchant/1008.jpg', '王果苗', '17782224507', '重庆市渝北区回兴街道宝圣大道学府路 105 号', '08:00-22:00', '厨具餐具、厨房配件', '2026-06-30 10:42:10', 1);
INSERT INTO `merchant` VALUES (2009, 1009, '贝贝乐母婴馆', 'merchant/1009.jpg', '李鑫瑞', '17782224508', '重庆市巴南区龙洲湾旭辉城底商 42 号', '08:00-22:00', '母婴孕童全品类', '2026-07-01 10:42:17', 1);
INSERT INTO `merchant` VALUES (2010, 1010, '滋补堂', 'merchant/1010.jpg', '赵蕊', '17782224509', '重庆市九龙坡区西彭镇铝城南路 21 号便民商铺', '08:00-22:00', '保健食品、进口零食', '2026-07-03 10:42:22', 1);
INSERT INTO `merchant` VALUES (2011, 1011, '鑫旺生鲜超市', 'merchant/1011.jpg', '林芳', '17782224510', '重庆市渝北区龙溪街道花卉园西路', '07:00-23:00', '综合生鲜超市，品种齐全', '2026-05-04 09:00:00', 1);
INSERT INTO `merchant` VALUES (2012, 1012, '尚品烟酒行', 'merchant/1012.jpg', '周伟', '17782224511', '重庆市江北区五里店街道五江路', '09:00-21:00', '高端烟酒，正品保障', '2026-05-15 10:00:00', 1);
INSERT INTO `merchant` VALUES (2013, 1013, '小清新花店', 'merchant/1013.jpg', '吴敏', '17782224512', '重庆市南岸区南坪万达广场步行街', '10:00-22:00', '鲜花绿植，节日礼品', '2026-06-01 09:00:00', 1);
INSERT INTO `merchant` VALUES (2014, 1014, '优品电器城', 'merchant/1014.jpg', '郑强', '17782224513', '重庆市沙坪坝区小龙坎新街', '09:00-21:00', '家电数码，品质保证', '2026-06-20 08:00:00', 1);
INSERT INTO `merchant` VALUES (2015, 1015, '便民便利店', 'merchant/1015.jpg', '孙丽', '17782224514', '重庆市大渡口区九宫庙街道钢花路', '06:00-00:00', '24小时便利店', '2026-07-01 07:00:00', 1);
INSERT INTO `merchant` VALUES (2016, 1016, '茶马古道茶行', 'merchant/1016.jpg', '马超', '17782224515', '重庆市渝中区解放碑步行街', '09:00-21:00', '茶叶茶具，名茶品鉴', '2026-05-06 09:00:00', 1);
INSERT INTO `merchant` VALUES (2017, 1017, '古韵红木家具', 'merchant/1017.jpg', '黄忠', '17782224516', '重庆市南岸区南坪红星美凯龙', '10:00-18:00', '红木家具，古典工艺', '2026-05-18 09:00:00', 1);
INSERT INTO `merchant` VALUES (2018, 1018, '潮流数码馆', 'merchant/1018.jpg', '赵云', '17782224517', '重庆市江北区观音桥赛博数码广场', '09:00-21:00', '手机电脑，数码配件', '2026-05-28 09:00:00', 1);
INSERT INTO `merchant` VALUES (2019, 1019, '茗香茶庄', 'merchant/1019.jpg', '魏延', '17782224518', '重庆市沙坪坝区磁器口古镇', '09:00-22:00', '名优茶叶，茶具礼品', '2026-06-08 09:00:00', 1);
INSERT INTO `merchant` VALUES (2020, 1020, '锦绣丝绸馆', 'merchant/1020.jpg', '关羽', '17782224519', '重庆市渝北区龙溪街道', '10:00-20:00', '丝绸制品，传统工艺', '2026-06-15 09:00:00', 1);
INSERT INTO `merchant` VALUES (2021, 1021, '味美轩餐厅', 'merchant/1021.jpg', '张飞', '17782224520', '重庆市九龙坡区杨家坪步行街', '11:00-22:00', '川菜粤菜，特色美食', '2026-06-22 09:00:00', 1);
INSERT INTO `merchant` VALUES (2022, 1022, '精品服饰店', 'merchant/1022.jpg', '刘备', '17782224521', '重庆市南岸区万达广场', '10:00-21:00', '品牌服饰，潮流搭配', '2026-06-28 09:00:00', 1);
INSERT INTO `merchant` VALUES (2023, 1023, '智慧书店', 'merchant/1023.jpg', '诸葛亮', '17782224522', '重庆市渝中区新华书店旁', '09:00-21:00', '图书文具，文创产品', '2026-07-02 09:00:00', 1);
INSERT INTO `merchant` VALUES (2024, 1024, '四海海鲜城', 'merchant/1024.jpg', '曹操', '17782224523', '重庆市巴南区鱼洞滨江路', '09:00-21:00', '海鲜水产，新鲜直供', '2026-07-03 09:00:00', 1);
INSERT INTO `merchant` VALUES (2025, 1025, '万宝珠宝行', 'merchant/1025.jpg', '孙权', '17782224524', '重庆市江北区北城天街', '10:00-21:00', '金银珠宝，奢侈品', '2026-07-04 09:00:00', 1);

-- ----------------------------
-- Table structure for merchant_apply
-- ----------------------------
DROP TABLE IF EXISTS `merchant_apply`;
CREATE TABLE `merchant_apply`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '申请ID（主键）',
  `user_id` bigint NULL DEFAULT NULL COMMENT '申请人用户ID',
  `apply_type` tinyint NULL DEFAULT 1 COMMENT '入驻类型: 1-个人, 2-企业',
  `company_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '企业/商家名称',
  `id_card_front` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '身份证正面图片',
  `id_card_back` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '身份证反面图片',
  `license_number` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '营业执照注册号',
  `license_image` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '营业执照图片',
  `food_permit_number` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '食品经营许可证号',
  `food_permit_image` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '食品许可证图片',
  `contact_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '联系人',
  `contact_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '联系电话',
  `shop_address` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '店铺地址',
  `shop_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '店铺名称',
  `audit_status` tinyint NULL DEFAULT NULL COMMENT '审核状态',
  `audit_remark` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '审核备注',
  `audit_time` datetime NULL DEFAULT NULL COMMENT '审核时间',
  `apply_time` datetime NULL DEFAULT NULL COMMENT '提交时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_merchant_apply_user`(`user_id` ASC) USING BTREE,
  CONSTRAINT `fk_merchant_apply_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 4026 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '商家入驻申请表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of merchant_apply
-- ----------------------------
INSERT INTO `merchant_apply` VALUES (4001, 1001, 2, '润禾食品商贸有限公司', '/id/0000.jpg', '/id/0000.jpg', '91500101MA03XXX01', '/license/1001.jpg', 'JY500101XXX01', '/foodpermit/1001.jpg', '陈一', '17782224500', '重庆市渝北区金开大道星光天地12铺', '润禾生活食铺', 1, '企业资质齐全，证照审核通过', '2026-06-05 10:30:00', '2026-06-05 09:10:00');
INSERT INTO `merchant_apply` VALUES (4002, 1002, 1, '食愈小铺食品经营店', '/id/0000.jpg', '/id/0000.jpg', '91500101MA03XXX02', '/license/1002.jpg', 'JY500101XXX02', '/foodpermit/1002.jpg', '王二', '17782224501', '重庆市江北区观音桥星光68负一楼', '食愈小铺', 1, '个体证件完整，准予入驻', '2026-06-08 15:45:00', '2026-06-08 14:25:00');
INSERT INTO `merchant_apply` VALUES (4003, 1003, 2, '鲜禧果蔬农产品有限公司', '/id/0000.jpg', '/id/0000.jpg', '91500103MA03XXX03', '/license/1003.jpg', 'JY500103XXX03', '/foodpermit/1003.jpg', '李三', '17782224502', '重庆市南岸区南坪协信星光一层', '鲜禧果仓', 1, '生鲜食品资质核验无误', '2026-06-12 11:20:00', '2026-06-12 10:05:00');
INSERT INTO `merchant_apply` VALUES (4004, 1004, 2, '家禾粮油副食配送公司', '/id/0000.jpg', '/id/0000.jpg', '91500104MA03XXX04', '/license/1004.jpg', 'JY500104XXX04', '/foodpermit/1004.jpg', '赵四', '17782224503', '重庆市九龙坡区杨家坪直港大道', '家禾粮油副食', 1, '粮油经营许可齐全，审核通过', '2026-06-15 17:45:00', '2026-06-15 16:30:00');
INSERT INTO `merchant_apply` VALUES (4005, 1005, 1, '巷味卤货小吃店', '/id/0000.jpg', '/id/0000.jpg', '91500101MA03XXX05', '/license/1005.jpg', 'JY500101XXX05', '/foodpermit/1005.jpg', '钱五', '17782224504', '重庆市渝中区两路口桂花园路', '巷味卤货', 1, '熟食卫生资质达标，审核通过', '2026-06-20 13:00:00', '2026-06-20 11:15:00');
INSERT INTO `merchant_apply` VALUES (4006, 1006, 1, '果汽鲜饮饮品店', '/id/0000.jpg', '/id/0000.jpg', '91500101MA03XXX06', '/license/1006.jpg', 'JY500101XXX06', '/foodpermit/1006.jpg', '张六', '17782224505', '重庆市南岸区茶园时代都汇临街铺', '果汽鲜饮', 0, '资料待补充食品留样记录，暂未通过', '2026-06-25 13:57:52', '2026-06-25 08:40:00');
INSERT INTO `merchant_apply` VALUES (4007, 1007, 2, '臻品生活商贸有限公司', '/id/0000.jpg', '/id/0000.jpg', '91500107MA03XXX07', '/license/1007.jpg', 'JY500107XXX07', '/foodpermit/1007.jpg', '陈勇', '17782224506', '重庆市大渡口区新山村街道钢花路 56 号', '臻品生活馆', 1, '企业资质齐全，证照审核通过', '2026-06-28 10:30:00', '2026-06-28 09:10:00');
INSERT INTO `merchant_apply` VALUES (4008, 1008, 2, '厨乐坊厨具用品有限公司', '/id/0000.jpg', '/id/0000.jpg', '91500108MA03XXX08', '/license/1008.jpg', 'JY500108XXX08', '/foodpermit/1008.jpg', '王果苗', '17782224507', '重庆市渝北区回兴街道宝圣大道学府路 105 号', '厨乐坊', 1, '企业资质齐全，证照审核通过', '2026-07-03 10:30:00', '2026-07-03 09:10:00');
INSERT INTO `merchant_apply` VALUES (4009, 1009, 2, '贝贝乐母婴用品有限公司', '/id/0000.jpg', '/id/0000.jpg', '91500109MA03XXX09', '/license/1009.jpg', 'JY500109XXX09', '/foodpermit/1009.jpg', '李鑫瑞', '17782224508', '重庆市巴南区龙洲湾旭辉城底商 42 号', '贝贝乐母婴馆', 1, '母婴用品资质齐全，证照审核通过', '2026-07-04 10:30:00', '2026-07-04 09:10:00');
INSERT INTO `merchant_apply` VALUES (4010, 1010, 2, '滋补堂健康食品有限公司', '/id/0000.jpg', '/id/0000.jpg', '91500110MA03XXX10', '/license/1010.jpg', 'JY500110XXX10', '/foodpermit/1010.jpg', '赵蕊', '17782224509', '重庆市九龙坡区西彭镇铝城南路 21 号便民商铺', '滋补堂', 1, '保健食品资质齐全，证照审核通过', '2026-07-06 10:30:00', '2026-07-06 09:10:00');
INSERT INTO `merchant_apply` VALUES (4011, 1011, 2, '鑫旺生鲜超市有限公司', '/id/0000.jpg', '/id/0000.jpg', '91500111MA03XXX11', '/license/1011.jpg', 'JY500111XXX11', '/foodpermit/1011.jpg', '林芳', '17782224510', '重庆市渝北区龙溪街道花卉园西路', '鑫旺生鲜超市', 1, '生鲜超市资质齐全，证照审核通过', '2026-05-05 10:30:00', '2026-05-05 09:10:00');
INSERT INTO `merchant_apply` VALUES (4012, 1012, 2, '尚品烟酒贸易有限公司', '/id/0000.jpg', '/id/0000.jpg', '91500112MA03XXX12', '/license/1012.jpg', 'JY500112XXX12', '/foodpermit/1012.jpg', '周伟', '17782224511', '重庆市江北区五里店街道五江路', '尚品烟酒行', 1, '烟酒专卖资质齐全，证照审核通过', '2026-05-16 10:30:00', '2026-05-16 09:10:00');
INSERT INTO `merchant_apply` VALUES (4013, 1013, 1, '小清新鲜花店', '/id/0000.jpg', '/id/0000.jpg', '91500113MA03XXX13', '/license/1013.jpg', 'JY500113XXX13', '/foodpermit/1013.jpg', '吴敏', '17782224512', '重庆市南岸区南坪万达广场步行街', '小清新花店', 1, '个体证件完整，准予入驻', '2026-06-02 10:30:00', '2026-06-02 09:10:00');
INSERT INTO `merchant_apply` VALUES (4014, 1014, 2, '优品电器销售有限公司', '/id/0000.jpg', '/id/0000.jpg', '91500114MA03XXX14', '/license/1014.jpg', 'JY500114XXX14', '/foodpermit/1014.jpg', '郑强', '17782224513', '重庆市沙坪坝区小龙坎新街', '优品电器城', 1, '家电销售资质齐全，证照审核通过', '2026-06-21 10:30:00', '2026-06-21 09:10:00');
INSERT INTO `merchant_apply` VALUES (4015, 1015, 1, '便民便利店', '/id/0000.jpg', '/id/0000.jpg', '91500115MA03XXX15', '/license/1015.jpg', 'JY500115XXX15', '/foodpermit/1015.jpg', '孙丽', '17782224514', '重庆市大渡口区九宫庙街道钢花路', '便民便利店', 1, '个体证件完整，准予入驻', '2026-07-02 10:30:00', '2026-07-02 09:10:00');
INSERT INTO `merchant_apply` VALUES (4016, 1016, 2, '茶马古道茶业有限公司', '/id/0000.jpg', '/id/0000.jpg', '91500116MA03XXX16', '/license/1016.jpg', 'JY500116XXX16', '/foodpermit/1016.jpg', '马超', '17782224515', '重庆市渝中区解放碑步行街', '茶马古道茶行', 1, '茶叶销售资质齐全，证照审核通过', '2026-05-07 10:30:00', '2026-05-07 09:10:00');
INSERT INTO `merchant_apply` VALUES (4017, 1017, 2, '古韵红木家具有限公司', '/id/0000.jpg', '/id/0000.jpg', '91500117MA03XXX17', '/license/1017.jpg', 'JY500117XXX17', '/foodpermit/1017.jpg', '黄忠', '17782224516', '重庆市南岸区南坪红星美凯龙', '古韵红木家具', 1, '家具销售资质齐全，证照审核通过', '2026-05-19 10:30:00', '2026-05-19 09:10:00');
INSERT INTO `merchant_apply` VALUES (4018, 1018, 2, '潮流数码科技有限公司', '/id/0000.jpg', '/id/0000.jpg', '91500118MA03XXX18', '/license/1018.jpg', 'JY500118XXX18', '/foodpermit/1018.jpg', '赵云', '17782224517', '重庆市江北区观音桥赛博数码广场', '潮流数码馆', 1, '数码产品销售资质齐全，证照审核通过', '2026-05-29 10:30:00', '2026-05-29 09:10:00');
INSERT INTO `merchant_apply` VALUES (4019, 1019, 2, '茗香茶业有限公司', '/id/0000.jpg', '/id/0000.jpg', '91500119MA03XXX19', '/license/1019.jpg', 'JY500119XXX19', '/foodpermit/1019.jpg', '魏延', '17782224518', '重庆市沙坪坝区磁器口古镇', '茗香茶庄', 1, '茶叶销售资质齐全，证照审核通过', '2026-06-09 10:30:00', '2026-06-09 09:10:00');
INSERT INTO `merchant_apply` VALUES (4020, 1020, 2, '锦绣丝绸制品有限公司', '/id/0000.jpg', '/id/0000.jpg', '91500120MA03XXX20', '/license/1020.jpg', 'JY500120XXX20', '/foodpermit/1020.jpg', '关羽', '17782224519', '重庆市渝北区龙溪街道', '锦绣丝绸馆', 1, '丝绸制品销售资质齐全，证照审核通过', '2026-06-16 10:30:00', '2026-06-16 09:10:00');
INSERT INTO `merchant_apply` VALUES (4021, 1021, 2, '味美轩餐饮管理有限公司', '/id/0000.jpg', '/id/0000.jpg', '91500121MA03XXX21', '/license/1021.jpg', 'JY500121XXX21', '/foodpermit/1021.jpg', '张飞', '17782224520', '重庆市九龙坡区杨家坪步行街', '味美轩餐厅', 1, '餐饮服务资质齐全，证照审核通过', '2026-06-23 10:30:00', '2026-06-23 09:10:00');
INSERT INTO `merchant_apply` VALUES (4022, 1022, 2, '精品服饰贸易有限公司', '/id/0000.jpg', '/id/0000.jpg', '91500122MA03XXX22', '/license/1022.jpg', 'JY500122XXX22', '/foodpermit/1022.jpg', '刘备', '17782224521', '重庆市南岸区万达广场', '精品服饰店', 1, '服饰销售资质齐全，证照审核通过', '2026-06-29 10:30:00', '2026-06-29 09:10:00');
INSERT INTO `merchant_apply` VALUES (4023, 1023, 2, '智慧图书文化有限公司', '/id/0000.jpg', '/id/0000.jpg', '91500123MA03XXX23', '/license/1023.jpg', 'JY500123XXX23', '/foodpermit/1023.jpg', '诸葛亮', '17782224522', '重庆市渝中区新华书店旁', '智慧书店', 1, '图书销售资质齐全，证照审核通过', '2026-07-03 10:30:00', '2026-07-03 09:10:00');
INSERT INTO `merchant_apply` VALUES (4024, 1024, 2, '四海海鲜餐饮有限公司', '/id/0000.jpg', '/id/0000.jpg', '91500124MA03XXX24', '/license/1024.jpg', 'JY500124XXX24', '/foodpermit/1024.jpg', '曹操', '17782224523', '重庆市巴南区鱼洞滨江路', '四海海鲜城', 1, '海鲜餐饮资质齐全，证照审核通过', '2026-07-04 10:30:00', '2026-07-04 09:10:00');
INSERT INTO `merchant_apply` VALUES (4025, 1025, 2, '万宝珠宝有限公司', '/id/0000.jpg', '/id/0000.jpg', '91500125MA03XXX25', '/license/1025.jpg', 'JY500125XXX25', '/foodpermit/1025.jpg', '孙权', '17782224524', '重庆市江北区北城天街', '万宝珠宝行', 1, '珠宝销售资质齐全，证照审核通过', '2026-07-05 10:30:00', '2026-07-05 09:10:00');

-- ----------------------------
-- Table structure for merchant_coupon
-- ----------------------------
DROP TABLE IF EXISTS `merchant_coupon`;
CREATE TABLE `merchant_coupon`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '商家券ID',
  `merchant_id` bigint NOT NULL COMMENT '商家ID',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '券名称',
  `type` tinyint NOT NULL COMMENT '类型：1固定金额 2满减',
  `min_consume` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '最低消费金额（固定金额卷使用门槛）',
  `discount_amount` decimal(10, 2) NULL DEFAULT NULL COMMENT '固定优惠金额（type=1时生效）',
  `total_count` int NULL DEFAULT NULL COMMENT '发行总量',
  `received_count` int NOT NULL DEFAULT 0 COMMENT '已领取数量',
  `per_user_limit` int NOT NULL DEFAULT 1 COMMENT '每人限领',
  `valid_start` datetime NULL DEFAULT NULL COMMENT '有效期开始',
  `valid_end` datetime NULL DEFAULT NULL COMMENT '有效期结束',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '0禁用 1启用',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_merchant_id`(`merchant_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '商家优惠券模板表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of merchant_coupon
-- ----------------------------

-- ----------------------------
-- Table structure for merchant_coupon_tier
-- ----------------------------
DROP TABLE IF EXISTS `merchant_coupon_tier`;
CREATE TABLE `merchant_coupon_tier`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '梯度ID',
  `coupon_id` bigint NOT NULL COMMENT '关联 merchant_coupon.id',
  `min_amount` decimal(10, 2) NOT NULL COMMENT '满金额',
  `discount_amount` decimal(10, 2) NOT NULL COMMENT '减金额',
  `sort_order` int NOT NULL DEFAULT 0 COMMENT '排序',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_coupon_id`(`coupon_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '商家满减卷梯度表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of merchant_coupon_tier
-- ----------------------------

-- ----------------------------
-- Table structure for merchant_coupon_user
-- ----------------------------
DROP TABLE IF EXISTS `merchant_coupon_user`;
CREATE TABLE `merchant_coupon_user`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '领用记录ID',
  `coupon_id` bigint NOT NULL COMMENT '商家券ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `order_id` bigint NULL DEFAULT NULL COMMENT '核销订单ID',
  `status` tinyint NULL DEFAULT 0 COMMENT '0未使用 1已使用 2已过期',
  `receive_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `use_time` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_coupon_id`(`coupon_id` ASC) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_order_id`(`order_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '商家优惠券领取记录表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of merchant_coupon_user
-- ----------------------------

-- ----------------------------
-- Table structure for merchant_info_change
-- ----------------------------
DROP TABLE IF EXISTS `merchant_info_change`;
CREATE TABLE `merchant_info_change`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '变更ID',
  `merchant_id` bigint NOT NULL COMMENT '商家ID',
  `request_type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '请求类型: INFO_CHANGE-信息修改, QUALIFICATION_UPGRADE-升级企业资质',
  `old_data` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '旧数据(JSON)',
  `new_data` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '新数据(JSON)',
  `audit_status` tinyint NOT NULL DEFAULT 0 COMMENT '审核状态: 0-待审核, 1-通过, 2-驳回',
  `audit_remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '审核备注/理由',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `audit_time` datetime NULL DEFAULT NULL COMMENT '审核时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_merchant_id`(`merchant_id` ASC) USING BTREE,
  INDEX `idx_audit_status`(`audit_status` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '商家信息变更审核表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of merchant_info_change
-- ----------------------------

-- ----------------------------
-- Table structure for merchant_promotion_participation
-- ----------------------------
DROP TABLE IF EXISTS `merchant_promotion_participation`;
CREATE TABLE `merchant_promotion_participation`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `merchant_id` bigint NOT NULL COMMENT '商家ID',
  `promotion_id` bigint NOT NULL COMMENT '促销活动ID',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '0未参与 1已参与',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_merchant_promotion`(`merchant_id` ASC, `promotion_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '商家参与平台促销记录表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of merchant_promotion_participation
-- ----------------------------

-- ----------------------------
-- Table structure for merchant_qualification
-- ----------------------------
DROP TABLE IF EXISTS `merchant_qualification`;
CREATE TABLE `merchant_qualification`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '资质ID（主键）',
  `merchant_id` bigint NULL DEFAULT NULL COMMENT '商家ID',
  `business_category` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '经营门类',
  `license_number` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '营业执照注册号',
  `license_image` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '营业执照图片',
  `food_permit_number` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '食品经营许可证号',
  `food_permit_image` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '食品许可证图片',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_qualification_merchant`(`merchant_id` ASC) USING BTREE,
  CONSTRAINT `fk_qualification_merchant` FOREIGN KEY (`merchant_id`) REFERENCES `merchant` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 3026 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '商家资质表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of merchant_qualification
-- ----------------------------
INSERT INTO `merchant_qualification` VALUES (3001, 2001, '综合休闲食品、鲜果零食', '91500101MA03XXX01', '/license/1001.jpg', 'JY500101XXX01', '/foodpermit/1001.jpg');
INSERT INTO `merchant_qualification` VALUES (3002, 2002, '网红零食、糕点膨化食品', '91500102MA03XXX02', '/license/1002.jpg', 'JY500102XXX02', '/foodpermit/1002.jpg');
INSERT INTO `merchant_qualification` VALUES (3003, 2003, '新鲜水果、果干蜜饯坚果', '91500103MA03XXX03', '/license/1003.jpg', 'JY500103XXX03', '/foodpermit/1003.jpg');
INSERT INTO `merchant_qualification` VALUES (3004, 2004, '粮油米面、调味罐头速食', '91500104MA03XXX04', '/license/1004.jpg', 'JY500104XXX04', '/foodpermit/1004.jpg');
INSERT INTO `merchant_qualification` VALUES (3005, 2005, '卤味熟食、肉干即食食品', '91500105MA03XXX05', '/license/1005.jpg', 'JY500105XXX05', '/foodpermit/1005.jpg');
INSERT INTO `merchant_qualification` VALUES (3006, 2006, '鲜果现榨气泡饮品、鲜萃茶饮、冷藏即饮果汁汽水', '91500106MA03XXX05', '/license/1006.jpg', 'JY500106XXX05', '/foodpermit/1001.jpg');
INSERT INTO `merchant_qualification` VALUES (3007, 2007, '家居百货、个护美妆、清洁用品', '91500107MA03XXX07', '/license/1007.jpg', 'JY500107XXX07', '/foodpermit/1007.jpg');
INSERT INTO `merchant_qualification` VALUES (3008, 2008, '厨具餐具、厨房配件、小家电', '91500108MA03XXX08', '/license/1008.jpg', 'JY500108XXX08', '/foodpermit/1008.jpg');
INSERT INTO `merchant_qualification` VALUES (3009, 2009, '母婴用品、婴幼儿食品、儿童玩具', '91500109MA03XXX09', '/license/1009.jpg', 'JY500109XXX09', '/foodpermit/1009.jpg');
INSERT INTO `merchant_qualification` VALUES (3010, 2010, '保健食品、滋补品、进口食品', '91500110MA03XXX10', '/license/1010.jpg', 'JY500110XXX10', '/foodpermit/1010.jpg');
INSERT INTO `merchant_qualification` VALUES (3011, 2011, '新鲜蔬果、肉蛋禽奶、粮油米面', '91500111MA03XXX11', '/license/1011.jpg', 'JY500111XXX11', '/foodpermit/1011.jpg');
INSERT INTO `merchant_qualification` VALUES (3012, 2012, '高端白酒、进口红酒、名烟名茶', '91500112MA03XXX12', '/license/1012.jpg', 'JY500112XXX12', '/foodpermit/1012.jpg');
INSERT INTO `merchant_qualification` VALUES (3013, 2013, '鲜花绿植、盆栽花卉、节日礼品', '91500113MA03XXX13', '/license/1013.jpg', 'JY500113XXX13', '/foodpermit/1013.jpg');
INSERT INTO `merchant_qualification` VALUES (3014, 2014, '大家电、小家电、数码产品', '91500114MA03XXX14', '/license/1014.jpg', 'JY500114XXX14', '/foodpermit/1014.jpg');
INSERT INTO `merchant_qualification` VALUES (3015, 2015, '日用百货、零食饮料、便民商品', '91500115MA03XXX15', '/license/1015.jpg', 'JY500115XXX15', '/foodpermit/1015.jpg');
INSERT INTO `merchant_qualification` VALUES (3016, 2016, '茶叶茶具、名茶品鉴、茶礼定制', '91500116MA03XXX16', '/license/1016.jpg', 'JY500116XXX16', '/foodpermit/1016.jpg');
INSERT INTO `merchant_qualification` VALUES (3017, 2017, '红木家具、古典工艺、实木定制', '91500117MA03XXX17', '/license/1017.jpg', 'JY500117XXX17', '/foodpermit/1017.jpg');
INSERT INTO `merchant_qualification` VALUES (3018, 2018, '手机电脑、数码配件、智能设备', '91500118MA03XXX18', '/license/1018.jpg', 'JY500118XXX18', '/foodpermit/1018.jpg');
INSERT INTO `merchant_qualification` VALUES (3019, 2019, '名优茶叶、茶具礼品、茶点零食', '91500119MA03XXX19', '/license/1019.jpg', 'JY500119XXX19', '/foodpermit/1019.jpg');
INSERT INTO `merchant_qualification` VALUES (3020, 2020, '丝绸制品、传统工艺、礼品定制', '91500120MA03XXX20', '/license/1020.jpg', 'JY500120XXX20', '/foodpermit/1020.jpg');
INSERT INTO `merchant_qualification` VALUES (3021, 2021, '川菜粤菜、特色美食、餐饮服务', '91500121MA03XXX21', '/license/1021.jpg', 'JY500121XXX21', '/foodpermit/1021.jpg');
INSERT INTO `merchant_qualification` VALUES (3022, 2022, '品牌服饰、潮流搭配、鞋帽箱包', '91500122MA03XXX22', '/license/1022.jpg', 'JY500122XXX22', '/foodpermit/1022.jpg');
INSERT INTO `merchant_qualification` VALUES (3023, 2023, '图书文具、文创产品、教辅材料', '91500123MA03XXX23', '/license/1023.jpg', 'JY500123XXX23', '/foodpermit/1023.jpg');
INSERT INTO `merchant_qualification` VALUES (3024, 2024, '海鲜水产、新鲜直供、海鲜加工', '91500124MA03XXX24', '/license/1024.jpg', 'JY500124XXX24', '/foodpermit/1024.jpg');
INSERT INTO `merchant_qualification` VALUES (3025, 2025, '金银珠宝、奢侈品、首饰定制', '91500125MA03XXX25', '/license/1025.jpg', 'JY500125XXX25', '/foodpermit/1025.jpg');

-- ----------------------------
-- Table structure for message_template
-- ----------------------------
DROP TABLE IF EXISTS `message_template`;
CREATE TABLE `message_template`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '模板ID（主键）',
  `template_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '模板编码',
  `template_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '模板名称',
  `message_type` tinyint NULL DEFAULT NULL COMMENT '消息类型（1站内信、2短信、3邮件）',
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '消息标题',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '消息模板内容',
  `status` tinyint NULL DEFAULT NULL COMMENT '启用状态',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '消息通知模板表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of message_template
-- ----------------------------

-- ----------------------------
-- Table structure for notice
-- ----------------------------
DROP TABLE IF EXISTS `notice`;
CREATE TABLE `notice`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '公告ID（主键）',
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '公告标题',
  `summary` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '公告摘要',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '公告内容',
  `target_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'ALL' COMMENT '接收范围（USER=用户端，MERCHANT=商家端，ALL=全平台）',
  `status` tinyint NULL DEFAULT 1 COMMENT '状态（0草稿，1已发布，2已下线）',
  `publish_time` datetime NULL DEFAULT NULL COMMENT '发布时间',
  `expire_time` datetime NULL DEFAULT NULL COMMENT '过期时间',
  `is_top` tinyint NULL DEFAULT 0 COMMENT '是否置顶（0否 1是）',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_target_type`(`target_type` ASC) USING BTREE,
  INDEX `idx_publish_time`(`publish_time` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '系统公告表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of notice
-- ----------------------------

-- ----------------------------
-- Table structure for notification
-- ----------------------------
DROP TABLE IF EXISTS `notification`;
CREATE TABLE `notification`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '通知ID',
  `user_id` bigint NULL DEFAULT NULL COMMENT '目标用户ID（运营平台管理员）',
  `merchant_id` bigint NULL DEFAULT NULL COMMENT '目标商家ID',
  `type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '通知类型: AUDIT_RESULT/ORDER_STATUS/AFTERSALE_STATUS等',
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '通知标题',
  `content` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '通知内容',
  `is_read` tinyint NOT NULL DEFAULT 0 COMMENT '是否已读: 0未读 1已读',
  `related_id` bigint NULL DEFAULT NULL COMMENT '关联业务ID',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_read`(`user_id` ASC, `is_read` ASC) USING BTREE,
  INDEX `idx_merchant_read`(`merchant_id` ASC, `is_read` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '消息通知表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of notification
-- ----------------------------

-- ----------------------------
-- Table structure for operation_admin
-- ----------------------------
DROP TABLE IF EXISTS `operation_admin`;
CREATE TABLE `operation_admin`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '运营管理员ID（主键）',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '登录账号',
  `password` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '登录密码（加密）',
  `real_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '真实姓名',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '联系电话',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '邮箱',
  `role` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '角色',
  `status` tinyint NULL DEFAULT NULL COMMENT '账号状态',
  `last_login_time` datetime NULL DEFAULT NULL COMMENT '最后登录时间',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '运营管理员信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of operation_admin
-- ----------------------------

-- ----------------------------
-- Table structure for order
-- ----------------------------
DROP TABLE IF EXISTS `order`;
CREATE TABLE `order`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '订单ID（主键）',
  `order_sn` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '订单编号',
  `idempotent_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '用户提交订单幂等键',
  `user_id` bigint NULL DEFAULT NULL COMMENT '用户ID',
  `merchant_id` bigint NULL DEFAULT NULL COMMENT '商家ID',
  `pickup_point_id` bigint NULL DEFAULT NULL COMMENT '自提点ID',
  `total_amount` decimal(10, 2) NULL DEFAULT NULL COMMENT '订单总价',
  `pay_amount` decimal(10, 2) NULL DEFAULT NULL COMMENT '应付金额',
  `delivery_type` tinyint NULL DEFAULT NULL COMMENT '配送方式',
  `status` tinyint NULL DEFAULT NULL COMMENT '订单状态',
  `coupon_user_id` bigint NULL DEFAULT NULL COMMENT '使用的平台优惠券记录ID',
  `coupon_discount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '平台优惠券抵扣金额',
  `merchant_coupon_user_id` bigint NULL DEFAULT NULL COMMENT '使用的商家优惠券记录ID',
  `merchant_coupon_discount` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '商家优惠券抵扣金额',
  `create_time` datetime NULL DEFAULT NULL COMMENT '下单时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_order_user_idempotent`(`user_id` ASC, `idempotent_key` ASC) USING BTREE,
  INDEX `fk_order_user`(`user_id` ASC) USING BTREE,
  INDEX `fk_order_merchant`(`merchant_id` ASC) USING BTREE,
  INDEX `fk_order_pickup`(`pickup_point_id` ASC) USING BTREE,
  CONSTRAINT `fk_order_merchant` FOREIGN KEY (`merchant_id`) REFERENCES `merchant` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_order_pickup` FOREIGN KEY (`pickup_point_id`) REFERENCES `pickup_point` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_order_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 1121 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '订单主表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of order
-- ----------------------------
INSERT INTO `order` VALUES (1001, 'ORD20260504001', 'IDEM20260504001', 1001, 2001, NULL, 156.80, 156.80, 2, 3, NULL, 0.00, NULL, 0.00, '2026-05-04 10:30:00');
INSERT INTO `order` VALUES (1002, 'ORD20260505002', 'IDEM20260505002', 1002, 2002, NULL, 89.70, 89.70, 2, 3, NULL, 0.00, NULL, 0.00, '2026-05-05 14:20:00');
INSERT INTO `order` VALUES (1003, 'ORD20260506003', 'IDEM20260506003', 1003, 2003, NULL, 258.00, 258.00, 2, 3, NULL, 0.00, NULL, 0.00, '2026-05-06 09:15:00');
INSERT INTO `order` VALUES (1004, 'ORD20260508004', 'IDEM20260508004', 1004, 2004, NULL, 168.80, 168.80, 2, 3, NULL, 0.00, NULL, 0.00, '2026-05-08 16:45:00');
INSERT INTO `order` VALUES (1005, 'ORD20260510005', 'IDEM20260510005', 1005, 2005, NULL, 125.60, 125.60, 2, 3, NULL, 0.00, NULL, 0.00, '2026-05-10 11:30:00');
INSERT INTO `order` VALUES (1006, 'ORD20260512006', 'IDEM20260512006', 1006, 2006, NULL, 198.00, 198.00, 2, 3, NULL, 0.00, NULL, 0.00, '2026-05-12 13:00:00');
INSERT INTO `order` VALUES (1007, 'ORD20260515007', 'IDEM20260515007', 1007, 2007, NULL, 458.00, 458.00, 3, 3, NULL, 0.00, NULL, 0.00, '2026-05-15 15:20:00');
INSERT INTO `order` VALUES (1008, 'ORD20260518008', 'IDEM20260518008', 1008, 2008, NULL, 898.00, 898.00, 3, 3, NULL, 0.00, NULL, 0.00, '2026-05-18 10:00:00');
INSERT INTO `order` VALUES (1009, 'ORD20260520009', 'IDEM20260520009', 1009, 2009, NULL, 698.00, 698.00, 3, 3, NULL, 0.00, NULL, 0.00, '2026-05-20 12:15:00');
INSERT INTO `order` VALUES (1010, 'ORD20260522010', 'IDEM20260522010', 1010, 2010, NULL, 1288.00, 1288.00, 3, 3, NULL, 0.00, NULL, 0.00, '2026-05-22 14:30:00');
INSERT INTO `order` VALUES (1011, 'ORD20260525011', 'IDEM20260525011', 1001, 2011, NULL, 386.00, 386.00, 2, 3, NULL, 0.00, NULL, 0.00, '2026-05-25 08:45:00');
INSERT INTO `order` VALUES (1012, 'ORD20260528012', 'IDEM20260528012', 1002, 2012, NULL, 3588.00, 3588.00, 2, 3, NULL, 0.00, NULL, 0.00, '2026-05-28 16:00:00');
INSERT INTO `order` VALUES (1013, 'ORD20260530013', 'IDEM20260530013', 1003, 2013, NULL, 188.00, 188.00, 2, 3, NULL, 0.00, NULL, 0.00, '2026-05-30 11:20:00');
INSERT INTO `order` VALUES (1014, 'ORD20260601014', 'IDEM20260601014', 1004, 2014, NULL, 2598.00, 2598.00, 3, 3, NULL, 0.00, NULL, 0.00, '2026-06-01 09:30:00');
INSERT INTO `order` VALUES (1015, 'ORD20260603015', 'IDEM20260603015', 1005, 2015, NULL, 45.80, 45.80, 2, 3, NULL, 0.00, NULL, 0.00, '2026-06-03 22:15:00');
INSERT INTO `order` VALUES (1016, 'ORD20260605016', 'IDEM20260605016', 1006, 2001, NULL, 78.90, 78.90, 2, 3, NULL, 0.00, NULL, 0.00, '2026-06-05 13:40:00');
INSERT INTO `order` VALUES (1017, 'ORD20260608017', 'IDEM20260608017', 1007, 2002, NULL, 268.00, 268.00, 2, 3, NULL, 0.00, NULL, 0.00, '2026-06-08 10:10:00');
INSERT INTO `order` VALUES (1018, 'ORD20260610018', 'IDEM20260610018', 1008, 2003, NULL, 588.00, 588.00, 2, 3, NULL, 0.00, NULL, 0.00, '2026-06-10 17:30:00');
INSERT INTO `order` VALUES (1019, 'ORD20260612019', 'IDEM20260612019', 1009, 2004, NULL, 189.00, 189.00, 2, 3, NULL, 0.00, NULL, 0.00, '2026-06-12 09:00:00');
INSERT INTO `order` VALUES (1020, 'ORD20260615020', 'IDEM20260615020', 1010, 2005, NULL, 356.00, 356.00, 2, 3, NULL, 0.00, NULL, 0.00, '2026-06-15 14:45:00');
INSERT INTO `order` VALUES (1021, 'ORD20260618021', 'IDEM20260618021', 1011, 2006, NULL, 234.00, 234.00, 2, 3, NULL, 0.00, NULL, 0.00, '2026-06-18 11:00:00');
INSERT INTO `order` VALUES (1022, 'ORD20260620022', 'IDEM20260620022', 1012, 2007, NULL, 756.00, 756.00, 3, 3, NULL, 0.00, NULL, 0.00, '2026-06-20 16:20:00');
INSERT INTO `order` VALUES (1023, 'ORD20260622023', 'IDEM20260622023', 1013, 2008, NULL, 1298.00, 1298.00, 3, 3, NULL, 0.00, NULL, 0.00, '2026-06-22 10:30:00');
INSERT INTO `order` VALUES (1024, 'ORD20260625024', 'IDEM20260625024', 1014, 2009, NULL, 458.00, 458.00, 3, 3, NULL, 0.00, NULL, 0.00, '2026-06-25 13:15:00');
INSERT INTO `order` VALUES (1025, 'ORD20260628025', 'IDEM20260628025', 1015, 2010, NULL, 898.00, 898.00, 3, 3, NULL, 0.00, NULL, 0.00, '2026-06-28 15:00:00');
INSERT INTO `order` VALUES (1026, 'ORD20260630026', 'IDEM20260630026', 1001, 2011, NULL, 568.00, 568.00, 2, 3, NULL, 0.00, NULL, 0.00, '2026-06-30 08:30:00');
INSERT INTO `order` VALUES (1027, 'ORD20260701027', 'IDEM20260701027', 1002, 2012, NULL, 5898.00, 5898.00, 2, 3, NULL, 0.00, NULL, 0.00, '2026-07-01 11:00:00');
INSERT INTO `order` VALUES (1028, 'ORD20260702028', 'IDEM20260702028', 1003, 2013, NULL, 68.00, 68.00, 2, 3, NULL, 0.00, NULL, 0.00, '2026-07-02 14:20:00');
INSERT INTO `order` VALUES (1029, 'ORD20260703029', 'IDEM20260703029', 1004, 2014, NULL, 3598.00, 3598.00, 3, 3, NULL, 0.00, NULL, 0.00, '2026-07-03 09:45:00');
INSERT INTO `order` VALUES (1030, 'ORD20260704030', 'IDEM20260704030', 1005, 2015, NULL, 25.60, 25.60, 2, 3, NULL, 0.00, NULL, 0.00, '2026-07-04 00:30:00');
INSERT INTO `order` VALUES (1031, 'ORD20260507031', 'IDEM20260507031', 1006, 2001, NULL, 234.50, 234.50, 2, 3, NULL, 0.00, NULL, 0.00, '2026-05-07 16:30:00');
INSERT INTO `order` VALUES (1032, 'ORD20260509032', 'IDEM20260509032', 1007, 2002, NULL, 45.90, 45.90, 2, 3, NULL, 0.00, NULL, 0.00, '2026-05-09 10:45:00');
INSERT INTO `order` VALUES (1033, 'ORD20260511033', 'IDEM20260511033', 1008, 2003, NULL, 188.00, 188.00, 2, 3, NULL, 0.00, NULL, 0.00, '2026-05-11 12:00:00');
INSERT INTO `order` VALUES (1034, 'ORD20260513034', 'IDEM20260513034', 1009, 2004, NULL, 78.00, 78.00, 2, 3, NULL, 0.00, NULL, 0.00, '2026-05-13 15:15:00');
INSERT INTO `order` VALUES (1035, 'ORD20260514035', 'IDEM20260514035', 1010, 2005, NULL, 568.00, 568.00, 2, 3, NULL, 0.00, NULL, 0.00, '2026-05-14 09:20:00');
INSERT INTO `order` VALUES (1036, 'ORD20260516036', 'IDEM20260516036', 1011, 2006, NULL, 123.00, 123.00, 2, 3, NULL, 0.00, NULL, 0.00, '2026-05-16 14:00:00');
INSERT INTO `order` VALUES (1037, 'ORD20260517037', 'IDEM20260517037', 1012, 2007, NULL, 345.00, 345.00, 3, 3, NULL, 0.00, NULL, 0.00, '2026-05-17 11:30:00');
INSERT INTO `order` VALUES (1038, 'ORD20260519038', 'IDEM20260519038', 1013, 2008, NULL, 988.00, 988.00, 3, 3, NULL, 0.00, NULL, 0.00, '2026-05-19 16:45:00');
INSERT INTO `order` VALUES (1039, 'ORD20260521039', 'IDEM20260521039', 1014, 2009, NULL, 234.00, 234.00, 3, 3, NULL, 0.00, NULL, 0.00, '2026-05-21 10:15:00');
INSERT INTO `order` VALUES (1040, 'ORD20260523040', 'IDEM20260523040', 1015, 2010, NULL, 1568.00, 1568.00, 3, 3, NULL, 0.00, NULL, 0.00, '2026-05-23 13:00:00');
INSERT INTO `order` VALUES (1041, 'ORD20260524041', 'IDEM20260524041', 1001, 2011, NULL, 234.00, 234.00, 2, 3, NULL, 0.00, NULL, 0.00, '2026-05-24 17:20:00');
INSERT INTO `order` VALUES (1042, 'ORD20260526042', 'IDEM20260526042', 1002, 2012, NULL, 1298.00, 1298.00, 2, 3, NULL, 0.00, NULL, 0.00, '2026-05-26 11:45:00');
INSERT INTO `order` VALUES (1043, 'ORD20260527043', 'IDEM20260527043', 1003, 2013, NULL, 89.00, 89.00, 2, 3, NULL, 0.00, NULL, 0.00, '2026-05-27 14:30:00');
INSERT INTO `order` VALUES (1044, 'ORD20260529044', 'IDEM20260529044', 1004, 2014, NULL, 1598.00, 1598.00, 3, 3, NULL, 0.00, NULL, 0.00, '2026-05-29 09:00:00');
INSERT INTO `order` VALUES (1045, 'ORD20260531045', 'IDEM20260531045', 1005, 2015, NULL, 18.50, 18.50, 2, 3, NULL, 0.00, NULL, 0.00, '2026-05-31 23:50:00');
INSERT INTO `order` VALUES (1046, 'ORD20260602046', 'IDEM20260602046', 1006, 2001, NULL, 89.00, 89.00, 2, 3, NULL, 0.00, NULL, 0.00, '2026-06-02 10:00:00');
INSERT INTO `order` VALUES (1047, 'ORD20260604047', 'IDEM20260604047', 1007, 2002, NULL, 345.00, 345.00, 2, 3, NULL, 0.00, NULL, 0.00, '2026-06-04 15:20:00');
INSERT INTO `order` VALUES (1048, 'ORD20260606048', 'IDEM20260606048', 1008, 2003, NULL, 234.00, 234.00, 2, 3, NULL, 0.00, NULL, 0.00, '2026-06-06 11:30:00');
INSERT INTO `order` VALUES (1049, 'ORD20260607049', 'IDEM20260607049', 1009, 2004, NULL, 156.00, 156.00, 2, 3, NULL, 0.00, NULL, 0.00, '2026-06-07 14:00:00');
INSERT INTO `order` VALUES (1050, 'ORD20260609050', 'IDEM20260609050', 1010, 2005, NULL, 89.00, 89.00, 2, 3, NULL, 0.00, NULL, 0.00, '2026-06-09 09:15:00');
INSERT INTO `order` VALUES (1051, 'ORD20260611051', 'IDEM20260611051', 1011, 2006, NULL, 267.00, 267.00, 2, 3, NULL, 0.00, NULL, 0.00, '2026-06-11 16:45:00');
INSERT INTO `order` VALUES (1052, 'ORD20260613052', 'IDEM20260613052', 1012, 2007, NULL, 568.00, 568.00, 3, 3, NULL, 0.00, NULL, 0.00, '2026-06-13 12:00:00');
INSERT INTO `order` VALUES (1053, 'ORD20260614053', 'IDEM20260614053', 1013, 2008, NULL, 789.00, 789.00, 3, 3, NULL, 0.00, NULL, 0.00, '2026-06-14 10:30:00');
INSERT INTO `order` VALUES (1054, 'ORD20260616054', 'IDEM20260616054', 1014, 2009, NULL, 123.00, 123.00, 3, 3, NULL, 0.00, NULL, 0.00, '2026-06-16 17:15:00');
INSERT INTO `order` VALUES (1055, 'ORD20260617055', 'IDEM20260617055', 1015, 2010, NULL, 2345.00, 2345.00, 3, 3, NULL, 0.00, NULL, 0.00, '2026-06-17 11:00:00');
INSERT INTO `order` VALUES (1056, 'ORD20260619056', 'IDEM20260619056', 1001, 2011, NULL, 456.00, 456.00, 2, 3, NULL, 0.00, NULL, 0.00, '2026-06-19 08:30:00');
INSERT INTO `order` VALUES (1057, 'ORD20260621057', 'IDEM20260621057', 1002, 2012, NULL, 4598.00, 4598.00, 2, 3, NULL, 0.00, NULL, 0.00, '2026-06-21 14:00:00');
INSERT INTO `order` VALUES (1058, 'ORD20260623058', 'IDEM20260623058', 1003, 2013, NULL, 45.00, 45.00, 2, 3, NULL, 0.00, NULL, 0.00, '2026-06-23 15:30:00');
INSERT INTO `order` VALUES (1059, 'ORD20260624059', 'IDEM20260624059', 1004, 2014, NULL, 2345.00, 2345.00, 3, 3, NULL, 0.00, NULL, 0.00, '2026-06-24 09:45:00');
INSERT INTO `order` VALUES (1060, 'ORD20260626060', 'IDEM20260626060', 1005, 2015, NULL, 32.00, 32.00, 2, 3, NULL, 0.00, NULL, 0.00, '2026-06-26 00:45:00');
INSERT INTO `order` VALUES (1061, 'ORD20260627061', 'IDEM20260627061', 1006, 2001, NULL, 178.00, 178.00, 2, 3, NULL, 0.00, NULL, 0.00, '2026-06-27 13:00:00');
INSERT INTO `order` VALUES (1062, 'ORD20260629062', 'IDEM20260629062', 1007, 2002, NULL, 89.00, 89.00, 2, 3, NULL, 0.00, NULL, 0.00, '2026-06-29 10:15:00');
INSERT INTO `order` VALUES (1063, 'ORD20260701063', 'IDEM20260701063', 1008, 2003, NULL, 456.00, 456.00, 2, 3, NULL, 0.00, NULL, 0.00, '2026-07-01 16:30:00');
INSERT INTO `order` VALUES (1064, 'ORD20260702064', 'IDEM20260702064', 1009, 2004, NULL, 345.00, 345.00, 2, 3, NULL, 0.00, NULL, 0.00, '2026-07-02 11:00:00');
INSERT INTO `order` VALUES (1065, 'ORD20260703065', 'IDEM20260703065', 1010, 2005, NULL, 234.00, 234.00, 2, 3, NULL, 0.00, NULL, 0.00, '2026-07-03 14:20:00');
INSERT INTO `order` VALUES (1066, 'ORD20260704066', 'IDEM20260704066', 1011, 2006, NULL, 156.00, 156.00, 2, 3, NULL, 0.00, NULL, 0.00, '2026-07-04 09:30:00');
INSERT INTO `order` VALUES (1067, 'ORD20260516067', 'IDEM20260516067', 1012, 2012, NULL, 8998.00, 8998.00, 2, 3, NULL, 0.00, NULL, 0.00, '2026-05-16 16:00:00');
INSERT INTO `order` VALUES (1068, 'ORD20260520068', 'IDEM20260520068', 1013, 2014, NULL, 5998.00, 5998.00, 3, 3, NULL, 0.00, NULL, 0.00, '2026-05-20 10:30:00');
INSERT INTO `order` VALUES (1069, 'ORD20260610069', 'IDEM20260610069', 1014, 2012, NULL, 6898.00, 6898.00, 2, 3, NULL, 0.00, NULL, 0.00, '2026-06-10 13:00:00');
INSERT INTO `order` VALUES (1070, 'ORD20260625070', 'IDEM20260625070', 1015, 2014, NULL, 4598.00, 4598.00, 3, 3, NULL, 0.00, NULL, 0.00, '2026-06-25 15:45:00');
INSERT INTO `order` VALUES (1071, 'ORD20260508071', 'IDEM20260508071', 1016, 2016, NULL, 398.00, 398.00, 2, 3, NULL, 0.00, NULL, 0.00, '2026-05-08 10:00:00');
INSERT INTO `order` VALUES (1072, 'ORD20260512072', 'IDEM20260512072', 1017, 2017, NULL, 12800.00, 12800.00, 2, 3, NULL, 0.00, NULL, 0.00, '2026-05-12 14:00:00');
INSERT INTO `order` VALUES (1073, 'ORD20260518073', 'IDEM20260518073', 1018, 2018, NULL, 5688.00, 5688.00, 2, 3, NULL, 0.00, NULL, 0.00, '2026-05-18 16:30:00');
INSERT INTO `order` VALUES (1074, 'ORD20260522074', 'IDEM20260522074', 1019, 2019, NULL, 188.00, 188.00, 2, 3, NULL, 0.00, NULL, 0.00, '2026-05-22 09:30:00');
INSERT INTO `order` VALUES (1075, 'ORD20260528075', 'IDEM20260528075', 1020, 2020, NULL, 898.00, 898.00, 2, 3, NULL, 0.00, NULL, 0.00, '2026-05-28 11:00:00');
INSERT INTO `order` VALUES (1076, 'ORD20260603076', 'IDEM20260603076', 1021, 2021, NULL, 568.00, 568.00, 2, 3, NULL, 0.00, NULL, 0.00, '2026-06-03 12:30:00');
INSERT INTO `order` VALUES (1077, 'ORD20260608077', 'IDEM20260608077', 1022, 2022, NULL, 1298.00, 1298.00, 2, 3, NULL, 0.00, NULL, 0.00, '2026-06-08 14:00:00');
INSERT INTO `order` VALUES (1078, 'ORD20260612078', 'IDEM20260612078', 1023, 2023, NULL, 45.00, 45.00, 2, 3, NULL, 0.00, NULL, 0.00, '2026-06-12 10:00:00');
INSERT INTO `order` VALUES (1079, 'ORD20260618079', 'IDEM20260618079', 1024, 2024, NULL, 2598.00, 2598.00, 2, 3, NULL, 0.00, NULL, 0.00, '2026-06-18 17:00:00');
INSERT INTO `order` VALUES (1080, 'ORD20260622080', 'IDEM20260622080', 1025, 2025, NULL, 18888.00, 18888.00, 2, 3, NULL, 0.00, NULL, 0.00, '2026-06-22 13:00:00');
INSERT INTO `order` VALUES (1081, 'ORD20260628081', 'IDEM20260628081', 1016, 2016, NULL, 568.00, 568.00, 2, 3, NULL, 0.00, NULL, 0.00, '2026-06-28 10:30:00');
INSERT INTO `order` VALUES (1082, 'ORD20260630082', 'IDEM20260630082', 1017, 2017, NULL, 8900.00, 8900.00, 2, 3, NULL, 0.00, NULL, 0.00, '2026-06-30 09:00:00');
INSERT INTO `order` VALUES (1083, 'ORD20260701083', 'IDEM20260701083', 1018, 2018, NULL, 3298.00, 3298.00, 2, 3, NULL, 0.00, NULL, 0.00, '2026-07-01 15:00:00');
INSERT INTO `order` VALUES (1084, 'ORD20260702084', 'IDEM20260702084', 1019, 2019, NULL, 345.00, 345.00, 2, 3, NULL, 0.00, NULL, 0.00, '2026-07-02 11:30:00');
INSERT INTO `order` VALUES (1085, 'ORD20260703085', 'IDEM20260703085', 1020, 2020, NULL, 1256.00, 1256.00, 2, 3, NULL, 0.00, NULL, 0.00, '2026-07-03 14:00:00');
INSERT INTO `order` VALUES (1086, 'ORD20260704086', 'IDEM20260704086', 1021, 2021, NULL, 898.00, 898.00, 2, 3, NULL, 0.00, NULL, 0.00, '2026-07-04 12:00:00');
INSERT INTO `order` VALUES (1087, 'ORD20260510087', 'IDEM20260510087', 1022, 2022, NULL, 2345.00, 2345.00, 2, 3, NULL, 0.00, NULL, 0.00, '2026-05-10 16:00:00');
INSERT INTO `order` VALUES (1088, 'ORD20260515088', 'IDEM20260515088', 1023, 2023, NULL, 68.00, 68.00, 2, 3, NULL, 0.00, NULL, 0.00, '2026-05-15 10:30:00');
INSERT INTO `order` VALUES (1089, 'ORD20260520089', 'IDEM20260520089', 1024, 2024, NULL, 3988.00, 3988.00, 2, 3, NULL, 0.00, NULL, 0.00, '2026-05-20 12:00:00');
INSERT INTO `order` VALUES (1090, 'ORD20260525090', 'IDEM20260525090', 1025, 2025, NULL, 25888.00, 25888.00, 2, 3, NULL, 0.00, NULL, 0.00, '2026-05-25 15:00:00');
INSERT INTO `order` VALUES (1091, 'ORD20260605091', 'IDEM20260605091', 1016, 2016, NULL, 128.00, 128.00, 2, 3, NULL, 0.00, NULL, 0.00, '2026-06-05 09:30:00');
INSERT INTO `order` VALUES (1092, 'ORD20260610092', 'IDEM20260610092', 1017, 2017, NULL, 5600.00, 5600.00, 2, 3, NULL, 0.00, NULL, 0.00, '2026-06-10 11:00:00');
INSERT INTO `order` VALUES (1093, 'ORD20260615093', 'IDEM20260615093', 1018, 2018, NULL, 1899.00, 1899.00, 2, 3, NULL, 0.00, NULL, 0.00, '2026-06-15 14:30:00');
INSERT INTO `order` VALUES (1094, 'ORD20260620094', 'IDEM20260620094', 1019, 2019, NULL, 89.00, 89.00, 2, 3, NULL, 0.00, NULL, 0.00, '2026-06-20 10:00:00');
INSERT INTO `order` VALUES (1095, 'ORD20260625095', 'IDEM20260625095', 1020, 2020, NULL, 456.00, 456.00, 2, 3, NULL, 0.00, NULL, 0.00, '2026-06-25 16:00:00');
INSERT INTO `order` VALUES (1096, 'ORD20260701096', 'IDEM20260701096', 1011, 2011, NULL, 103.00, 103.00, 2, 3, NULL, 0.00, NULL, 0.00, '2026-07-01 10:00:00');
INSERT INTO `order` VALUES (1097, 'ORD20260702097', 'IDEM20260702097', 1012, 2012, NULL, 2098.00, 2098.00, 2, 3, NULL, 0.00, NULL, 0.00, '2026-07-02 14:00:00');
INSERT INTO `order` VALUES (1098, 'ORD20260703098', 'IDEM20260703098', 1013, 2013, NULL, 226.00, 226.00, 2, 3, NULL, 0.00, NULL, 0.00, '2026-07-03 11:00:00');
INSERT INTO `order` VALUES (1099, 'ORD20260704099', 'IDEM20260704099', 1014, 2014, NULL, 5598.00, 5598.00, 2, 3, NULL, 0.00, NULL, 0.00, '2026-07-04 15:00:00');
INSERT INTO `order` VALUES (1100, 'ORD20260705100', 'IDEM20260705100', 1015, 2015, NULL, 37.80, 37.80, 2, 3, NULL, 0.00, NULL, 0.00, '2026-07-05 09:00:00');
INSERT INTO `order` VALUES (1101, 'ORD20260706101', 'IDEM20260706101', 1016, 2016, NULL, 466.00, 466.00, 2, 3, NULL, 0.00, NULL, 0.00, '2026-07-06 10:00:00');
INSERT INTO `order` VALUES (1102, 'ORD20260707102', 'IDEM20260707102', 1017, 2017, NULL, 17700.00, 17700.00, 2, 3, NULL, 0.00, NULL, 0.00, '2026-07-07 16:00:00');
INSERT INTO `order` VALUES (1103, 'ORD20260708103', 'IDEM20260708103', 1018, 2018, NULL, 8986.00, 8986.00, 2, 3, NULL, 0.00, NULL, 0.00, '2026-07-08 14:00:00');
INSERT INTO `order` VALUES (1104, 'ORD20260709104', 'IDEM20260709104', 1019, 2019, NULL, 476.00, 476.00, 2, 3, NULL, 0.00, NULL, 0.00, '2026-07-09 11:00:00');
INSERT INTO `order` VALUES (1105, 'ORD20260710105', 'IDEM20260710105', 1020, 2020, NULL, 1854.00, 1854.00, 2, 3, NULL, 0.00, NULL, 0.00, '2026-07-10 13:00:00');
INSERT INTO `order` VALUES (1106, 'ORD20260711106', 'IDEM20260711106', 1021, 2021, NULL, 156.00, 156.00, 2, 3, NULL, 0.00, NULL, 0.00, '2026-07-11 12:00:00');
INSERT INTO `order` VALUES (1107, 'ORD20260712107', 'IDEM20260712107', 1022, 2022, NULL, 2198.00, 2198.00, 2, 3, NULL, 0.00, NULL, 0.00, '2026-07-12 15:00:00');
INSERT INTO `order` VALUES (1108, 'ORD20260713108', 'IDEM20260713108', 1023, 2023, NULL, 256.00, 256.00, 2, 3, NULL, 0.00, NULL, 0.00, '2026-07-13 10:00:00');
INSERT INTO `order` VALUES (1109, 'ORD20260714109', 'IDEM20260714109', 1024, 2024, NULL, 972.00, 972.00, 2, 3, NULL, 0.00, NULL, 0.00, '2026-07-14 17:00:00');
INSERT INTO `order` VALUES (1110, 'ORD20260715110', 'IDEM20260715110', 1025, 2025, NULL, 18888.00, 18888.00, 2, 3, NULL, 0.00, NULL, 0.00, '2026-07-15 14:00:00');
INSERT INTO `order` VALUES (1111, 'ORD20260716111', 'IDEM20260716111', 1001, 2001, NULL, 77.00, 77.00, 2, 3, NULL, 0.00, NULL, 0.00, '2026-07-16 09:00:00');
INSERT INTO `order` VALUES (1112, 'ORD20260717112', 'IDEM20260717112', 1002, 2002, NULL, 55.80, 55.80, 2, 3, NULL, 0.00, NULL, 0.00, '2026-07-17 11:00:00');
INSERT INTO `order` VALUES (1113, 'ORD20260718113', 'IDEM20260718113', 1003, 2003, NULL, 36.90, 36.90, 2, 3, NULL, 0.00, NULL, 0.00, '2026-07-18 10:00:00');
INSERT INTO `order` VALUES (1114, 'ORD20260719114', 'IDEM20260719114', 1004, 2004, NULL, 68.00, 68.00, 2, 3, NULL, 0.00, NULL, 0.00, '2026-07-19 13:00:00');
INSERT INTO `order` VALUES (1115, 'ORD20260720115', 'IDEM20260720115', 1005, 2005, NULL, 45.80, 45.80, 2, 3, NULL, 0.00, NULL, 0.00, '2026-07-20 12:00:00');
INSERT INTO `order` VALUES (1116, 'ORD20260721116', 'IDEM20260721116', 1006, 2006, NULL, 65.00, 65.00, 2, 3, NULL, 0.00, NULL, 0.00, '2026-07-21 14:00:00');
INSERT INTO `order` VALUES (1117, 'ORD20260722117', 'IDEM20260722117', 1007, 2007, NULL, 298.00, 298.00, 2, 3, NULL, 0.00, NULL, 0.00, '2026-07-22 10:00:00');
INSERT INTO `order` VALUES (1118, 'ORD20260723118', 'IDEM20260723118', 1008, 2008, NULL, 398.00, 398.00, 2, 3, NULL, 0.00, NULL, 0.00, '2026-07-23 15:00:00');
INSERT INTO `order` VALUES (1119, 'ORD20260724119', 'IDEM20260724119', 1009, 2009, NULL, 398.00, 398.00, 2, 3, NULL, 0.00, NULL, 0.00, '2026-07-24 11:00:00');
INSERT INTO `order` VALUES (1120, 'ORD20260725120', 'IDEM20260725120', 1010, 2010, NULL, 888.00, 888.00, 2, 3, NULL, 0.00, NULL, 0.00, '2026-07-25 16:00:00');

-- ----------------------------
-- Table structure for order_item
-- ----------------------------
DROP TABLE IF EXISTS `order_item`;
CREATE TABLE `order_item`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '明细ID（主键）',
  `order_id` bigint NULL DEFAULT NULL COMMENT '订单ID',
  `sku_id` bigint NULL DEFAULT NULL COMMENT 'SkuID',
  `product_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '商品快照名称',
  `sku_specs` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '规格快照',
  `price` decimal(10, 2) NULL DEFAULT NULL COMMENT '购买单价',
  `quantity` int NULL DEFAULT NULL COMMENT '购买数量',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_items_order`(`order_id` ASC) USING BTREE,
  INDEX `fk_items_sku`(`sku_id` ASC) USING BTREE,
  CONSTRAINT `fk_items_order` FOREIGN KEY (`order_id`) REFERENCES `order` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_items_sku` FOREIGN KEY (`sku_id`) REFERENCES `sku` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 2213 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '订单明细表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of order_item
-- ----------------------------
INSERT INTO `order_item` VALUES (2001, 1001, 8025, '智利车厘子JJ级2斤装', '{"规格":"2斤装","等级":"JJ级"}', 128.00, 1);
INSERT INTO `order_item` VALUES (2002, 1001, 8026, '智利蓝莓125g*4盒', '{"规格":"125g*4盒"}', 28.80, 1);
INSERT INTO `order_item` VALUES (2003, 1002, 8030, '农夫山泉矿泉水550ml*24瓶', '{"规格":"550ml*24瓶"}', 24.90, 1);
INSERT INTO `order_item` VALUES (2004, 1002, 8032, '蒙牛纯牛奶250ml*12盒', '{"规格":"250ml*12盒"}', 59.80, 1);
INSERT INTO `order_item` VALUES (2005, 1003, 8040, '金龙鱼调和油5L', '{"规格":"5L"}', 68.00, 2);
INSERT INTO `order_item` VALUES (2006, 1003, 8042, '海天酱油500ml', '{"规格":"500ml"}', 15.00, 2);
INSERT INTO `order_item` VALUES (2007, 1004, 8055, '维达纸巾抽纸3层*24包', '{"规格":"3层*24包"}', 68.80, 1);
INSERT INTO `order_item` VALUES (2008, 1004, 8056, '蓝月亮洗衣液2kg', '{"规格":"2kg"}', 59.00, 1);
INSERT INTO `order_item` VALUES (2009, 1005, 8035, '奥利奥饼干97g*6盒', '{"规格":"97g*6盒"}', 35.60, 2);
INSERT INTO `order_item` VALUES (2010, 1005, 8036, '乐事薯片75g*4袋', '{"规格":"75g*4袋"}', 27.20, 2);
INSERT INTO `order_item` VALUES (2011, 1006, 8031, '可口可乐330ml*12罐', '{"规格":"330ml*12罐"}', 39.00, 2);
INSERT INTO `order_item` VALUES (2012, 1006, 8033, '怡宝纯净水1.5L*12瓶', '{"规格":"1.5L*12瓶"}', 18.00, 5);
INSERT INTO `order_item` VALUES (2013, 1007, 8050, '美的电饭煲3L', '{"规格":"3L"}', 299.00, 1);
INSERT INTO `order_item` VALUES (2014, 1007, 8052, '九阳豆浆机', '{"规格":"1.2L"}', 159.00, 1);
INSERT INTO `order_item` VALUES (2015, 1008, 8050, '美的电饭煲4L', '{"规格":"4L"}', 459.00, 1);
INSERT INTO `order_item` VALUES (2016, 1008, 8051, '苏泊尔压力锅5L', '{"规格":"5L"}', 439.00, 1);
INSERT INTO `order_item` VALUES (2017, 1009, 8068, '帮宝适纸尿裤M码60片', '{"规格":"M码60片"}', 199.00, 2);
INSERT INTO `order_item` VALUES (2018, 1009, 8070, '美赞臣奶粉3段900g', '{"规格":"3段900g"}', 299.00, 1);
INSERT INTO `order_item` VALUES (2019, 1010, 8080, '同仁堂阿胶250g', '{"规格":"250g"}', 688.00, 1);
INSERT INTO `order_item` VALUES (2020, 1010, 8082, '安利蛋白粉450g', '{"规格":"450g"}', 300.00, 2);
INSERT INTO `order_item` VALUES (2021, 1011, 8025, '智利车厘子JJ级2斤装', '{"规格":"2斤装","等级":"JJ级"}', 128.00, 2);
INSERT INTO `order_item` VALUES (2022, 1011, 8027, '新西兰奇异果6个装', '{"规格":"6个装"}', 38.00, 3);
INSERT INTO `order_item` VALUES (2023, 1012, 8038, '飞天茅台53度500ml', '{"规格":"53度500ml"}', 1499.00, 2);
INSERT INTO `order_item` VALUES (2024, 1012, 8039, '五粮液52度500ml', '{"规格":"52度500ml"}', 599.00, 1);
INSERT INTO `order_item` VALUES (2025, 1013, 8058, '玫瑰花束11支', '{"规格":"11支"}', 88.00, 1);
INSERT INTO `order_item` VALUES (2026, 1013, 8059, '向日葵花束6支', '{"规格":"6支"}', 50.00, 2);
INSERT INTO `order_item` VALUES (2027, 1014, 8050, '美的冰箱双开门', '{"规格":"500L"}', 2599.00, 1);
INSERT INTO `order_item` VALUES (2028, 1015, 8030, '农夫山泉矿泉水550ml*24瓶', '{"规格":"550ml*24瓶"}', 24.90, 1);
INSERT INTO `order_item` VALUES (2029, 1015, 8034, '康师傅方便面5连包', '{"规格":"5连包"}', 12.90, 1);
INSERT INTO `order_item` VALUES (2030, 1016, 8030, '农夫山泉矿泉水550ml*24瓶', '{"规格":"550ml*24瓶"}', 24.90, 2);
INSERT INTO `order_item` VALUES (2031, 1016, 8032, '蒙牛纯牛奶250ml*12盒', '{"规格":"250ml*12盒"}', 29.10, 1);
INSERT INTO `order_item` VALUES (2032, 1017, 8045, '苏泊尔炒锅32cm', '{"规格":"32cm"}', 168.00, 1);
INSERT INTO `order_item` VALUES (2033, 1017, 8046, '张小泉刀具套装', '{"规格":"5件套"}', 99.00, 1);
INSERT INTO `order_item` VALUES (2034, 1018, 8050, '美的电饭煲4L', '{"规格":"4L"}', 459.00, 1);
INSERT INTO `order_item` VALUES (2035, 1018, 8053, '格兰仕微波炉', '{"规格":"20L"}', 129.00, 1);
INSERT INTO `order_item` VALUES (2036, 1019, 8055, '维达纸巾抽纸3层*24包', '{"规格":"3层*24包"}', 68.80, 1);
INSERT INTO `order_item` VALUES (2037, 1019, 8057, '威猛先生清洁剂500ml', '{"规格":"500ml"}', 25.20, 4);
INSERT INTO `order_item` VALUES (2038, 1020, 8040, '金龙鱼调和油5L', '{"规格":"5L"}', 68.00, 3);
INSERT INTO `order_item` VALUES (2039, 1020, 8042, '海天酱油500ml', '{"规格":"500ml"}', 15.00, 8);
INSERT INTO `order_item` VALUES (2040, 1021, 8031, '可口可乐330ml*12罐', '{"规格":"330ml*12罐"}', 39.00, 3);
INSERT INTO `order_item` VALUES (2041, 1021, 8033, '怡宝纯净水1.5L*12瓶', '{"规格":"1.5L*12瓶"}', 18.00, 5);
INSERT INTO `order_item` VALUES (2042, 1022, 8050, '美的电饭煲4L', '{"规格":"4L"}', 459.00, 1);
INSERT INTO `order_item` VALUES (2043, 1022, 8052, '九阳豆浆机', '{"规格":"1.2L"}', 159.00, 2);
INSERT INTO `order_item` VALUES (2044, 1023, 8050, '美的冰箱三开门', '{"规格":"350L"}', 1299.00, 1);
INSERT INTO `order_item` VALUES (2045, 1024, 8068, '帮宝适纸尿裤L码48片', '{"规格":"L码48片"}', 199.00, 2);
INSERT INTO `order_item` VALUES (2046, 1024, 8069, '好奇拉拉裤XL码36片', '{"规格":"XL码36片"}', 59.00, 1);
INSERT INTO `order_item` VALUES (2047, 1025, 8080, '同仁堂阿胶250g', '{"规格":"250g"}', 688.00, 1);
INSERT INTO `order_item` VALUES (2048, 1025, 8081, '东阿阿胶300g', '{"规格":"300g"}', 209.00, 1);
INSERT INTO `order_item` VALUES (2049, 1026, 8025, '智利车厘子JJ级2斤装', '{"规格":"2斤装","等级":"JJ级"}', 128.00, 3);
INSERT INTO `order_item` VALUES (2050, 1026, 8028, '澳洲芒果2个装', '{"规格":"2个装"}', 46.00, 2);
INSERT INTO `order_item` VALUES (2051, 1027, 8038, '飞天茅台53度500ml', '{"规格":"53度500ml"}', 1499.00, 3);
INSERT INTO `order_item` VALUES (2052, 1027, 8039, '五粮液52度500ml', '{"规格":"52度500ml"}', 599.00, 2);
INSERT INTO `order_item` VALUES (2053, 1028, 8058, '康乃馨花束10支', '{"规格":"10支"}', 38.00, 1);
INSERT INTO `order_item` VALUES (2054, 1028, 8059, '百合花花束6支', '{"规格":"6支"}', 29.00, 1);
INSERT INTO `order_item` VALUES (2055, 1029, 8050, '美的空调1.5匹', '{"规格":"1.5匹"}', 2599.00, 1);
INSERT INTO `order_item` VALUES (2056, 1029, 8051, '苏泊尔压力锅6L', '{"规格":"6L"}', 999.00, 1);
INSERT INTO `order_item` VALUES (2057, 1030, 8034, '康师傅方便面5连包', '{"规格":"5连包"}', 12.90, 1);
INSERT INTO `order_item` VALUES (2058, 1030, 8030, '农夫山泉矿泉水550ml*12瓶', '{"规格":"550ml*12瓶"}', 12.70, 1);
INSERT INTO `order_item` VALUES (2059, 1031, 8026, '智利蓝莓125g*4盒', '{"规格":"125g*4盒"}', 28.80, 4);
INSERT INTO `order_item` VALUES (2060, 1031, 8027, '新西兰奇异果6个装', '{"规格":"6个装"}', 38.00, 3);
INSERT INTO `order_item` VALUES (2061, 1032, 8030, '农夫山泉矿泉水550ml*24瓶', '{"规格":"550ml*24瓶"}', 24.90, 1);
INSERT INTO `order_item` VALUES (2062, 1032, 8032, '蒙牛纯牛奶250ml*6盒', '{"规格":"250ml*6盒"}', 21.00, 1);
INSERT INTO `order_item` VALUES (2063, 1033, 8028, '澳洲芒果2个装', '{"规格":"2个装"}', 46.00, 2);
INSERT INTO `order_item` VALUES (2064, 1033, 8029, '泰国山竹500g', '{"规格":"500g"}', 34.00, 2);
INSERT INTO `order_item` VALUES (2065, 1034, 8056, '蓝月亮洗衣液2kg', '{"规格":"2kg"}', 59.00, 1);
INSERT INTO `order_item` VALUES (2066, 1034, 8055, '维达纸巾抽纸3层*12包', '{"规格":"3层*12包"}', 19.00, 1);
INSERT INTO `order_item` VALUES (2067, 1035, 8040, '金龙鱼调和油5L', '{"规格":"5L"}', 68.00, 6);
INSERT INTO `order_item` VALUES (2068, 1035, 8043, '太太乐鸡精200g', '{"规格":"200g"}', 8.00, 10);
INSERT INTO `order_item` VALUES (2069, 1036, 8031, '可口可乐330ml*12罐', '{"规格":"330ml*12罐"}', 39.00, 2);
INSERT INTO `order_item` VALUES (2070, 1036, 8032, '蒙牛纯牛奶250ml*12盒', '{"规格":"250ml*12盒"}', 42.00, 2);
INSERT INTO `order_item` VALUES (2071, 1037, 8050, '美的电饭煲3L', '{"规格":"3L"}', 299.00, 1);
INSERT INTO `order_item` VALUES (2072, 1037, 8052, '九阳豆浆机', '{"规格":"1.2L"}', 45.00, 1);
INSERT INTO `order_item` VALUES (2073, 1038, 8051, '苏泊尔压力锅5L', '{"规格":"5L"}', 439.00, 2);
INSERT INTO `order_item` VALUES (2074, 1038, 8045, '苏泊尔炒锅32cm', '{"规格":"32cm"}', 109.00, 1);
INSERT INTO `order_item` VALUES (2075, 1039, 8068, '帮宝适纸尿裤M码60片', '{"规格":"M码60片"}', 199.00, 1);
INSERT INTO `order_item` VALUES (2076, 1039, 8069, '好奇拉拉裤L码48片', '{"规格":"L码48片"}', 34.00, 1);
INSERT INTO `order_item` VALUES (2077, 1040, 8080, '同仁堂阿胶250g', '{"规格":"250g"}', 688.00, 2);
INSERT INTO `order_item` VALUES (2078, 1040, 8082, '安利蛋白粉450g', '{"规格":"450g"}', 191.00, 1);
INSERT INTO `order_item` VALUES (2079, 1041, 8025, '智利车厘子JJ级2斤装', '{"规格":"2斤装","等级":"JJ级"}', 128.00, 1);
INSERT INTO `order_item` VALUES (2080, 1041, 8026, '智利蓝莓125g*4盒', '{"规格":"125g*4盒"}', 53.00, 2);
INSERT INTO `order_item` VALUES (2081, 1042, 8038, '飞天茅台53度500ml', '{"规格":"53度500ml"}', 1499.00, 1);
INSERT INTO `order_item` VALUES (2082, 1042, 8039, '五粮液52度500ml', '{"规格":"52度500ml"}', 599.00, 1);
INSERT INTO `order_item` VALUES (2083, 1043, 8058, '向日葵花束6支', '{"规格":"6支"}', 50.00, 1);
INSERT INTO `order_item` VALUES (2084, 1043, 8059, '康乃馨花束10支', '{"规格":"10支"}', 38.00, 1);
INSERT INTO `order_item` VALUES (2085, 1044, 8050, '美的空调1匹', '{"规格":"1匹"}', 1599.00, 1);
INSERT INTO `order_item` VALUES (2086, 1044, 8053, '格兰仕微波炉', '{"规格":"20L"}', 0.00, 0);
INSERT INTO `order_item` VALUES (2087, 1045, 8034, '康师傅方便面5连包', '{"规格":"5连包"}', 12.90, 1);
INSERT INTO `order_item` VALUES (2088, 1045, 8030, '农夫山泉矿泉水550ml*6瓶', '{"规格":"550ml*6瓶"}', 5.60, 1);
INSERT INTO `order_item` VALUES (2089, 1046, 8030, '农夫山泉矿泉水550ml*24瓶', '{"规格":"550ml*24瓶"}', 24.90, 2);
INSERT INTO `order_item` VALUES (2090, 1046, 8032, '蒙牛纯牛奶250ml*6盒', '{"规格":"250ml*6盒"}', 39.20, 1);
INSERT INTO `order_item` VALUES (2091, 1047, 8045, '苏泊尔炒锅32cm', '{"规格":"32cm"}', 168.00, 1);
INSERT INTO `order_item` VALUES (2092, 1047, 8046, '张小泉刀具套装', '{"规格":"5件套"}', 177.00, 1);
INSERT INTO `order_item` VALUES (2093, 1048, 8040, '金龙鱼调和油5L', '{"规格":"5L"}', 68.00, 2);
INSERT INTO `order_item` VALUES (2094, 1048, 8042, '海天酱油500ml', '{"规格":"500ml"}', 49.00, 2);
INSERT INTO `order_item` VALUES (2095, 1049, 8055, '维达纸巾抽纸3层*24包', '{"规格":"3层*24包"}', 68.80, 1);
INSERT INTO `order_item` VALUES (2096, 1049, 8056, '蓝月亮洗衣液2kg', '{"规格":"2kg"}', 43.20, 2);
INSERT INTO `order_item` VALUES (2097, 1050, 8035, '奥利奥饼干97g*6盒', '{"规格":"97g*6盒"}', 35.60, 1);
INSERT INTO `order_item` VALUES (2098, 1050, 8036, '乐事薯片75g*4袋', '{"规格":"75g*4袋"}', 26.80, 2);
INSERT INTO `order_item` VALUES (2099, 1051, 8031, '可口可乐330ml*12罐', '{"规格":"330ml*12罐"}', 39.00, 4);
INSERT INTO `order_item` VALUES (2100, 1051, 8033, '怡宝纯净水1.5L*12瓶', '{"规格":"1.5L*12瓶"}', 51.00, 4);
INSERT INTO `order_item` VALUES (2101, 1052, 8050, '美的电饭煲4L', '{"规格":"4L"}', 459.00, 1);
INSERT INTO `order_item` VALUES (2102, 1052, 8052, '九阳豆浆机', '{"规格":"1.2L"}', 108.00, 1);
INSERT INTO `order_item` VALUES (2103, 1053, 8051, '苏泊尔压力锅5L', '{"规格":"5L"}', 439.00, 1);
INSERT INTO `order_item` VALUES (2104, 1053, 8053, '格兰仕微波炉', '{"规格":"20L"}', 349.00, 1);
INSERT INTO `order_item` VALUES (2105, 1054, 8068, '帮宝适纸尿裤M码60片', '{"规格":"M码60片"}', 199.00, 0);
INSERT INTO `order_item` VALUES (2106, 1054, 8069, '好奇拉拉裤L码48片', '{"规格":"L码48片"}', 123.00, 1);
INSERT INTO `order_item` VALUES (2107, 1055, 8080, '同仁堂阿胶250g', '{"规格":"250g"}', 688.00, 3);
INSERT INTO `order_item` VALUES (2108, 1055, 8082, '安利蛋白粉450g', '{"规格":"450g"}', 281.00, 1);
INSERT INTO `order_item` VALUES (2109, 1056, 8025, '智利车厘子JJ级2斤装', '{"规格":"2斤装","等级":"JJ级"}', 128.00, 2);
INSERT INTO `order_item` VALUES (2110, 1056, 8028, '澳洲芒果2个装', '{"规格":"2个装"}', 100.00, 2);
INSERT INTO `order_item` VALUES (2111, 1057, 8038, '飞天茅台53度500ml', '{"规格":"53度500ml"}', 1499.00, 3);
INSERT INTO `order_item` VALUES (2112, 1057, 8039, '五粮液52度500ml', '{"规格":"52度500ml"}', 0.00, 0);
INSERT INTO `order_item` VALUES (2113, 1058, 8058, '百合花单支', '{"规格":"单支"}', 15.00, 2);
INSERT INTO `order_item` VALUES (2114, 1058, 8059, '玫瑰花单支', '{"规格":"单支"}', 15.00, 1);
INSERT INTO `order_item` VALUES (2115, 1059, 8050, '美的冰箱双开门', '{"规格":"500L"}', 2345.00, 1);
INSERT INTO `order_item` VALUES (2116, 1060, 8034, '康师傅方便面5连包', '{"规格":"5连包"}', 12.90, 2);
INSERT INTO `order_item` VALUES (2117, 1060, 8030, '农夫山泉矿泉水550ml*6瓶', '{"规格":"550ml*6瓶"}', 6.20, 1);
INSERT INTO `order_item` VALUES (2118, 1061, 8026, '智利蓝莓125g*4盒', '{"规格":"125g*4盒"}', 28.80, 4);
INSERT INTO `order_item` VALUES (2119, 1061, 8027, '新西兰奇异果6个装', '{"规格":"6个装"}', 62.80, 2);
INSERT INTO `order_item` VALUES (2120, 1062, 8030, '农夫山泉矿泉水550ml*24瓶', '{"规格":"550ml*24瓶"}', 24.90, 2);
INSERT INTO `order_item` VALUES (2121, 1062, 8032, '蒙牛纯牛奶250ml*12盒', '{"规格":"250ml*12盒"}', 39.20, 1);
INSERT INTO `order_item` VALUES (2122, 1063, 8040, '金龙鱼调和油5L', '{"规格":"5L"}', 68.00, 4);
INSERT INTO `order_item` VALUES (2123, 1063, 8042, '海天酱油500ml', '{"规格":"500ml"}', 104.00, 4);
INSERT INTO `order_item` VALUES (2124, 1064, 8055, '维达纸巾抽纸3层*24包', '{"规格":"3层*24包"}', 68.80, 3);
INSERT INTO `order_item` VALUES (2125, 1064, 8056, '蓝月亮洗衣液2kg', '{"规格":"2kg"}', 138.60, 2);
INSERT INTO `order_item` VALUES (2126, 1065, 8035, '奥利奥饼干97g*6盒', '{"规格":"97g*6盒"}', 35.60, 4);
INSERT INTO `order_item` VALUES (2127, 1065, 8036, '乐事薯片75g*4袋', '{"规格":"75g*4袋"}', 91.60, 3);
INSERT INTO `order_item` VALUES (2128, 1066, 8031, '可口可乐330ml*12罐', '{"规格":"330ml*12罐"}', 39.00, 2);
INSERT INTO `order_item` VALUES (2129, 1066, 8033, '怡宝纯净水1.5L*12瓶', '{"规格":"1.5L*12瓶"}', 78.00, 4);
INSERT INTO `order_item` VALUES (2130, 1067, 8038, '飞天茅台53度500ml', '{"规格":"53度500ml"}', 1499.00, 6);
INSERT INTO `order_item` VALUES (2131, 1068, 8050, '美的冰箱双开门', '{"规格":"500L"}', 2599.00, 2);
INSERT INTO `order_item` VALUES (2132, 1068, 8051, '苏泊尔压力锅6L', '{"规格":"6L"}', 799.00, 1);
INSERT INTO `order_item` VALUES (2133, 1069, 8038, '飞天茅台53度500ml', '{"规格":"53度500ml"}', 1499.00, 4);
INSERT INTO `order_item` VALUES (2134, 1069, 8039, '五粮液52度500ml', '{"规格":"52度500ml"}', 599.00, 2);
INSERT INTO `order_item` VALUES (2135, 1070, 8050, '美的空调1.5匹', '{"规格":"1.5匹"}', 2599.00, 1);
INSERT INTO `order_item` VALUES (2136, 1070, 8053, '格兰仕微波炉', '{"规格":"20L"}', 1999.00, 1);
INSERT INTO `order_item` VALUES (2137, 1071, 8080, '普洱茶饼357g', '{"规格":"357g"}', 198.00, 2);
INSERT INTO `order_item` VALUES (2138, 1072, 8050, '红木餐桌1.5米', '{"规格":"1.5米"}', 8800.00, 1);
INSERT INTO `order_item` VALUES (2139, 1072, 8051, '红木餐椅4把', '{"规格":"4把"}', 4000.00, 1);
INSERT INTO `order_item` VALUES (2140, 1073, 8050, 'iPhone 15 Pro 256G', '{"规格":"256G"}', 5688.00, 1);
INSERT INTO `order_item` VALUES (2141, 1074, 8080, '铁观音礼盒装', '{"规格":"礼盒装250g"}', 188.00, 1);
INSERT INTO `order_item` VALUES (2142, 1075, 8050, '丝绸旗袍', '{"规格":"M码"}', 598.00, 1);
INSERT INTO `order_item` VALUES (2143, 1075, 8051, '丝绸围巾', '{"规格":"100%桑蚕丝"}', 300.00, 1);
INSERT INTO `order_item` VALUES (2144, 1076, 8050, '家庭套餐A', '{"规格":"4人份"}', 288.00, 2);
INSERT INTO `order_item` VALUES (2145, 1077, 8050, '品牌羽绒服', '{"规格":"L码"}', 899.00, 1);
INSERT INTO `order_item` VALUES (2146, 1077, 8051, '羊毛围巾', '{"规格":"100%羊毛"}', 399.00, 1);
INSERT INTO `order_item` VALUES (2147, 1078, 8050, '畅销小说', '{"规格":"平装"}', 45.00, 1);
INSERT INTO `order_item` VALUES (2148, 1079, 8050, '波士顿龙虾', '{"规格":"2斤"}', 398.00, 4);
INSERT INTO `order_item` VALUES (2149, 1079, 8051, '三文鱼刺身', '{"规格":"1斤"}', 806.00, 2);
INSERT INTO `order_item` VALUES (2150, 1080, 8050, '黄金项链', '{"规格":"20克"}', 8888.00, 1);
INSERT INTO `order_item` VALUES (2151, 1080, 8051, '钻石戒指', '{"规格":"1克拉"}', 10000.00, 1);
INSERT INTO `order_item` VALUES (2152, 1081, 8080, '龙井茶叶250g', '{"规格":"250g"}', 288.00, 2);
INSERT INTO `order_item` VALUES (2153, 1082, 8050, '红木沙发三件套', '{"规格":"三人位+单人位+茶几"}', 8900.00, 1);
INSERT INTO `order_item` VALUES (2154, 1083, 8050, 'MacBook Air M3', '{"规格":"8GB+256GB"}', 3298.00, 1);
INSERT INTO `order_item` VALUES (2155, 1084, 8080, '大红袍礼盒', '{"规格":"礼盒装100g"}', 178.00, 2);
INSERT INTO `order_item` VALUES (2156, 1085, 8050, '丝绸床单四件套', '{"规格":"1.8米床"}', 856.00, 1);
INSERT INTO `order_item` VALUES (2157, 1085, 8051, '丝绸被芯', '{"规格":"200*230"}', 400.00, 1);
INSERT INTO `order_item` VALUES (2158, 1086, 8050, '海鲜套餐', '{"规格":"2人份"}', 449.00, 2);
INSERT INTO `order_item` VALUES (2159, 1087, 8050, '品牌运动鞋', '{"规格":"42码"}', 899.00, 2);
INSERT INTO `order_item` VALUES (2160, 1087, 8051, '运动背包', '{"规格":"大号"}', 547.00, 1);
INSERT INTO `order_item` VALUES (2161, 1088, 8050, '儿童绘本套装', '{"规格":"10本"}', 68.00, 1);
INSERT INTO `order_item` VALUES (2162, 1089, 8050, '帝王蟹', '{"规格":"3斤"}', 1288.00, 2);
INSERT INTO `order_item` VALUES (2163, 1089, 8051, '澳洲龙虾', '{"规格":"2斤"}', 1412.00, 1);
INSERT INTO `order_item` VALUES (2164, 1090, 8050, '铂金项链', '{"规格":"30克"}', 12888.00, 1);
INSERT INTO `order_item` VALUES (2165, 1090, 8051, '翡翠手镯', '{"规格":"58mm"}', 13000.00, 1);
INSERT INTO `order_item` VALUES (2166, 1091, 8080, '茉莉花茶', '{"规格":"100g"}', 68.00, 2);
INSERT INTO `order_item` VALUES (2167, 1092, 8050, '红木书桌', '{"规格":"1.2米"}', 5600.00, 1);
INSERT INTO `order_item` VALUES (2168, 1093, 8050, 'iPad Pro 11寸', '{"规格":"256GB"}', 1899.00, 1);
INSERT INTO `order_item` VALUES (2169, 1094, 8080, '红茶礼盒', '{"规格":"200g"}', 89.00, 1);
INSERT INTO `order_item` VALUES (2170, 1095, 8050, '丝绸领带', '{"规格":"真丝"}', 228.00, 2);
INSERT INTO `order_item` VALUES (2171, 1096, 8169, '新鲜五花肉500g', '{"规格":"1份","净重":"500g"}', 35.00, 1);
INSERT INTO `order_item` VALUES (2172, 1096, 8170, '鲜活基围虾500g', '{"规格":"1份","净重":"500g"}', 68.00, 1);
INSERT INTO `order_item` VALUES (2173, 1097, 8171, '飞天茅台53度500ml', '{"规格":"1瓶","容量":"500ml"}', 1499.00, 1);
INSERT INTO `order_item` VALUES (2174, 1097, 8172, '五粮液52度500ml', '{"规格":"1瓶","容量":"500ml"}', 599.00, 1);
INSERT INTO `order_item` VALUES (2175, 1098, 8173, '玫瑰鲜花束11朵', '{"规格":"1束","数量":"11朵"}', 168.00, 1);
INSERT INTO `order_item` VALUES (2176, 1098, 8174, '多肉植物组合6颗', '{"规格":"1盆","数量":"6颗"}', 58.00, 1);
INSERT INTO `order_item` VALUES (2177, 1099, 8175, '美的空调1.5匹', '{"规格":"1台","匹数":"1.5匹"}', 2599.00, 1);
INSERT INTO `order_item` VALUES (2178, 1099, 8176, '小米电视55英寸', '{"规格":"1台","尺寸":"55英寸"}', 2999.00, 1);
INSERT INTO `order_item` VALUES (2179, 1100, 8177, '农夫山泉矿泉水550ml*24', '{"规格":"1箱","数量":"24瓶"}', 24.90, 1);
INSERT INTO `order_item` VALUES (2180, 1100, 8178, '康师傅方便面5连包', '{"规格":"5包","口味":"红烧牛肉"}', 12.90, 1);
INSERT INTO `order_item` VALUES (2181, 1101, 8179, '普洱茶饼357g', '{"规格":"1饼","净重":"357g"}', 198.00, 1);
INSERT INTO `order_item` VALUES (2182, 1101, 8180, '陶瓷茶具套装', '{"规格":"1套","材质":"陶瓷"}', 268.00, 1);
INSERT INTO `order_item` VALUES (2183, 1102, 8181, '红木餐桌1.5米', '{"规格":"1张","尺寸":"1.5米"}', 8800.00, 1);
INSERT INTO `order_item` VALUES (2184, 1102, 8182, '红木沙发三件套', '{"规格":"1套","材质":"黄花梨"}', 8900.00, 1);
INSERT INTO `order_item` VALUES (2185, 1103, 8183, 'iPhone 15 Pro 256G', '{"规格":"1部","容量":"256GB"}', 5688.00, 1);
INSERT INTO `order_item` VALUES (2186, 1103, 8184, 'MacBook Air M3', '{"规格":"1台","配置":"8GB+256GB"}', 3298.00, 1);
INSERT INTO `order_item` VALUES (2187, 1104, 8185, '铁观音礼盒装250g', '{"规格":"1盒","净重":"250g"}', 188.00, 1);
INSERT INTO `order_item` VALUES (2188, 1104, 8186, '龙井茶叶250g', '{"规格":"1盒","净重":"250g"}', 288.00, 1);
INSERT INTO `order_item` VALUES (2189, 1105, 8187, '丝绸旗袍', '{"规格":"1件","尺码":"M码"}', 598.00, 1);
INSERT INTO `order_item` VALUES (2190, 1105, 8188, '丝绸床单四件套', '{"规格":"1套","尺寸":"1.8米"}', 1256.00, 1);
INSERT INTO `order_item` VALUES (2191, 1106, 8189, '招牌红烧肉', '{"规格":"1份","重量":"500g"}', 68.00, 1);
INSERT INTO `order_item` VALUES (2192, 1106, 8190, '海鲜炒饭', '{"规格":"1份","份量":"2人份"}', 88.00, 1);
INSERT INTO `order_item` VALUES (2193, 1107, 8191, '品牌羽绒服', '{"规格":"1件","尺码":"L码"}', 899.00, 1);
INSERT INTO `order_item` VALUES (2194, 1107, 8192, '羊毛大衣', '{"规格":"1件","尺码":"M码"}', 1299.00, 1);
INSERT INTO `order_item` VALUES (2195, 1108, 8193, '畅销小说套装', '{"规格":"1套","数量":"5本"}', 88.00, 1);
INSERT INTO `order_item` VALUES (2196, 1108, 8194, '钢笔礼盒套装', '{"规格":"1套","材质":"钢笔"}', 168.00, 1);
INSERT INTO `order_item` VALUES (2197, 1109, 8195, '波士顿龙虾2斤', '{"规格":"1只","重量":"2斤"}', 398.00, 2);
INSERT INTO `order_item` VALUES (2198, 1109, 8196, '三文鱼刺身1斤', '{"规格":"1份","重量":"1斤"}', 188.00, 1);
INSERT INTO `order_item` VALUES (2199, 1110, 8197, '黄金项链20克', '{"规格":"1条","重量":"20克"}', 8888.00, 1);
INSERT INTO `order_item` VALUES (2200, 1110, 8198, '钻石戒指1克拉', '{"规格":"1枚","克拉":"1克拉"}', 10000.00, 1);
INSERT INTO `order_item` VALUES (2201, 1111, 8001, '三只松鼠每日坚果30包礼盒', '{"规格":"30包装","净重":"600g-750g"}', 77.00, 1);
INSERT INTO `order_item` VALUES (2202, 1112, 8005, '卫龙大面筋68g*10包', '{"规格":"10包装","单包":"68g"}', 19.90, 1);
INSERT INTO `order_item` VALUES (2203, 1112, 8006, '良品铺子蛋黄酥6枚盒装', '{"规格":"6枚盒装","净重":"360g"}', 35.00, 1);
INSERT INTO `order_item` VALUES (2204, 1113, 8009, '阿克苏冰糖心苹果5斤装', '{"规格":"5斤装","果径":"80-85mm"}', 36.90, 1);
INSERT INTO `order_item` VALUES (2205, 1114, 8013, '金龙鱼稻花香大米5kg袋装', '{"规格":"1袋装","净重":"5000g"}', 68.00, 1);
INSERT INTO `order_item` VALUES (2206, 1115, 8017, '有友泡椒凤爪210g袋装', '{"规格":"1袋装","净重":"210g","口味":"山椒"}', 18.90, 1);
INSERT INTO `order_item` VALUES (2207, 1115, 8020, '有友现卤五香鹌鹑蛋300g', '{"规格":"1盒装","净重":"300g"}', 16.90, 1);
INSERT INTO `order_item` VALUES (2208, 1116, 8021, '元气森林白桃气泡水480ml*15瓶', '{"规格":"15瓶装","单瓶":"480ml","口味":"白桃"}', 65.00, 1);
INSERT INTO `order_item` VALUES (2209, 1117, 8128, '苏泊尔不粘锅32cm', '{"规格":"1个","尺寸":"32cm"}', 298.00, 1);
INSERT INTO `order_item` VALUES (2210, 1118, 8129, '苏泊尔压力锅5L', '{"规格":"1个","容量":"5L"}', 398.00, 1);
INSERT INTO `order_item` VALUES (2211, 1119, 8153, '美赞臣奶粉3段', '{"规格":"1罐","净重":"900g"}', 398.00, 1);
INSERT INTO `order_item` VALUES (2212, 1120, 8073, '茅台飞天53度500ml', '{"规格":"1瓶","容量":"500ml"}', 1499.00, 1);

-- ----------------------------
-- Table structure for payment
-- ----------------------------
DROP TABLE IF EXISTS `payment`;
CREATE TABLE `payment`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '支付ID（主键）',
  `order_id` bigint NULL DEFAULT NULL COMMENT '订单ID',
  `pay_sn` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '支付流水号',
  `third_trade_no` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '第三方支付交易号，如支付宝trade_no',
  `pay_platform` tinyint NULL DEFAULT NULL COMMENT '支付通道',
  `amount` decimal(10, 2) NULL DEFAULT NULL COMMENT '实际支付金额',
  `status` tinyint NULL DEFAULT NULL COMMENT '支付状态',
  `pay_time` datetime NULL DEFAULT NULL COMMENT '支付成功时间',
  `callback_time` datetime NULL DEFAULT NULL COMMENT '支付回调时间',
  `fail_reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '支付失败原因',
  `refund_time` datetime NULL DEFAULT NULL COMMENT '退款时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_payment_pay_sn`(`pay_sn` ASC) USING BTREE,
  INDEX `fk_payment_order`(`order_id` ASC) USING BTREE,
  INDEX `idx_payment_status`(`status` ASC) USING BTREE,
  CONSTRAINT `fk_payment_order` FOREIGN KEY (`order_id`) REFERENCES `order` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '支付记录表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of payment
-- ----------------------------

-- ----------------------------
-- Table structure for pickup_point
-- ----------------------------
DROP TABLE IF EXISTS `pickup_point`;
CREATE TABLE `pickup_point`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '自提点ID（主键）',
  `merchant_id` bigint NULL DEFAULT NULL COMMENT '所属商家ID',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '自提点名称',
  `address` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '自提点详细地址',
  `contact_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '联系电话',
  `business_hours` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '营业时间',
  `status` tinyint NULL DEFAULT NULL COMMENT '营业状态',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_pickup_merchant`(`merchant_id` ASC) USING BTREE,
  CONSTRAINT `fk_pickup_merchant` FOREIGN KEY (`merchant_id`) REFERENCES `merchant` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '自提点表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of pickup_point
-- ----------------------------

-- ----------------------------
-- Table structure for platform_account_summary
-- ----------------------------
DROP TABLE IF EXISTS `platform_account_summary`;
CREATE TABLE `platform_account_summary`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `total_revenue` decimal(14, 2) NOT NULL DEFAULT 0.00 COMMENT '总收入',
  `total_expenditure` decimal(14, 2) NOT NULL DEFAULT 0.00 COMMENT '总支出',
  `net_profit` decimal(14, 2) NOT NULL DEFAULT 0.00 COMMENT '净收益',
  `frozen_amount` decimal(14, 2) NOT NULL DEFAULT 0.00 COMMENT '冻结金额（待结算订单）',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '平台账户汇总表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of platform_account_summary
-- ----------------------------
INSERT INTO `platform_account_summary` VALUES (1, 0.00, 0.00, 0.00, 0.00, '2026-07-04 10:26:15');

-- ----------------------------
-- Table structure for platform_promotion
-- ----------------------------
DROP TABLE IF EXISTS `platform_promotion`;
CREATE TABLE `platform_promotion`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '活动ID',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '活动名称',
  `start_time` datetime NOT NULL COMMENT '开始时间',
  `end_time` datetime NOT NULL COMMENT '结束时间',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态：0已关闭 1进行中',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '平台促销活动表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of platform_promotion
-- ----------------------------

-- ----------------------------
-- Table structure for platform_promotion_tier
-- ----------------------------
DROP TABLE IF EXISTS `platform_promotion_tier`;
CREATE TABLE `platform_promotion_tier`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '梯度ID',
  `promotion_id` bigint NOT NULL COMMENT '关联 platform_promotion.id',
  `min_amount` decimal(10, 2) NOT NULL COMMENT '满金额',
  `discount_amount` decimal(10, 2) NOT NULL COMMENT '减金额',
  `sort_order` int NOT NULL DEFAULT 0 COMMENT '排序（越小越优先匹配）',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_promotion_id`(`promotion_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '平台促销梯度表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of platform_promotion_tier
-- ----------------------------

-- ----------------------------
-- Table structure for platform_revenue_detail
-- ----------------------------
DROP TABLE IF EXISTS `platform_revenue_detail`;
CREATE TABLE `platform_revenue_detail`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '流水ID',
  `order_id` bigint NULL DEFAULT NULL COMMENT '关联订单ID',
  `merchant_id` bigint NULL DEFAULT NULL COMMENT '关联商家ID',
  `type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '类型：commission佣金收入/coupon_subsidy平台贴补/service_fee服务费/other',
  `amount` decimal(10, 2) NOT NULL COMMENT '金额（正=收入 负=支出）',
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '描述',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_order_id`(`order_id` ASC) USING BTREE,
  INDEX `idx_merchant_id`(`merchant_id` ASC) USING BTREE,
  INDEX `idx_create_time`(`create_time` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '平台流水明细表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of platform_revenue_detail
-- ----------------------------

-- ----------------------------
-- Table structure for points_log
-- ----------------------------
DROP TABLE IF EXISTS `points_log`;
CREATE TABLE `points_log`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志ID（主键）',
  `user_id` bigint NULL DEFAULT NULL COMMENT '用户ID',
  `type` tinyint NULL DEFAULT NULL COMMENT '变更动作类型',
  `change_points` int NULL DEFAULT NULL COMMENT '变动积分值',
  `current_points` int NULL DEFAULT NULL COMMENT '变动后余额',
  `remark` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '事务场景备注',
  `create_time` datetime NULL DEFAULT NULL COMMENT '记录生成时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_points_log_user`(`user_id` ASC) USING BTREE,
  CONSTRAINT `fk_points_log_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '积分变更日志表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of points_log
-- ----------------------------

-- ----------------------------
-- Table structure for poster
-- ----------------------------
DROP TABLE IF EXISTS `poster`;
CREATE TABLE `poster`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '海报ID（主键）',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '海报主题模板名称',
  `bg_image` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '背景原图素材URL',
  `qr_code_config` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '二维码动态图层配置参数',
  `status` tinyint NULL DEFAULT NULL COMMENT '使用状态',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '裂变海报配置表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of poster
-- ----------------------------

-- ----------------------------
-- Table structure for product
-- ----------------------------
DROP TABLE IF EXISTS `product`;
CREATE TABLE `product`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '商品ID（主键）',
  `brand_id` bigint NULL DEFAULT NULL COMMENT '品牌ID',
  `merchant_id` bigint NULL DEFAULT NULL COMMENT '商家ID',
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '商品名称',
  `sub_title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '副标题',
  `main_image` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '商品主图',
  `detail_desc` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '详情描述',
  `detail_images` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '详情图片(JSON数组)',
  `sale_type` tinyint NULL DEFAULT NULL COMMENT '销售模式（自提/配送）',
  `status` tinyint NULL DEFAULT NULL COMMENT '上架状态',
  `audit_status` tinyint NULL DEFAULT NULL COMMENT '审核状态(0待审/1通过/2拒绝)',
  `audit_remark` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '审核备注',
  `audit_time` datetime NULL DEFAULT NULL COMMENT '审核时间',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `sold_count` bigint NOT NULL DEFAULT 0 COMMENT '已售数量',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_product_brand`(`brand_id` ASC) USING BTREE,
  INDEX `fk_product_merchant`(`merchant_id` ASC) USING BTREE,
  CONSTRAINT `fk_product_brand` FOREIGN KEY (`brand_id`) REFERENCES `brand` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_product_merchant` FOREIGN KEY (`merchant_id`) REFERENCES `merchant` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 6199 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '商品主表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of product
-- ----------------------------
INSERT INTO `product` VALUES (6001, 5001, 2001, '三只松鼠每日坚果30包礼盒', '果仁饱满 营养均衡', 'product/6001.jpg', '<p>混合坚果独立小袋，全家代餐零食</p>', '/product_detail/6001.jpg', 2, 1, 1, '审核通过', '2026-06-01 10:00:00', '2026-06-01 09:00:00', '2026-06-01 09:00:00', 1);
INSERT INTO `product` VALUES (6002, 5001, 2001, '三只松鼠虎皮风爪袋装', '软烂脱骨 卤香入味', 'product/6002.jpg', '<p>老卤慢炖鸡爪，追剧网红即食卤味零食</p>', '/product_detail/6002.jpg', 2, 1, 1, '审核通过', '2026-06-01 11:00:00', '2026-06-01 10:30:00', '2026-06-01 10:30:00', 0);
INSERT INTO `product` VALUES (6003, 5002, 2001, '良品铺子芒果干500g大包装', '果肉厚实 酸甜不腻', 'product/6003.jpg', '<p>鲜芒果低温烘干，无过多添加蜜饯</p>', '/product_detail/6003.jpg', 2, 1, 1, '审核通过', '2026-06-02 10:00:00', '2026-06-02 09:00:00', '2026-06-02 09:00:00', 0);
INSERT INTO `product` VALUES (6004, 5004, 2001, '旺旺雪饼520g家庭装', '酥脆米香 童年味道', 'product/6004.jpg', '<p>经典膨化米饼，办公室家庭常备小零食</p>', '/product_detail/6004.jpg', 2, 1, 1, '审核通过', '2026-06-02 14:00:00', '2026-06-02 13:00:00', '2026-06-02 13:00:00', 0);
INSERT INTO `product` VALUES (6005, 5003, 2002, '卫龙大面筋68g*10包', '香辣劲道 解馋小吃', 'product/6005.jpg', '<p>经典麻辣辣条，便携独立小包办公室零食</p>', '/product_detail/6005.jpg', 2, 1, 1, '审核通过', '2026-06-03 10:00:00', '2026-06-03 09:00:00', '2026-06-03 09:00:00', 0);
INSERT INTO `product` VALUES (6006, 5002, 2002, '良品铺子蛋黄酥6枚盒装', '绵密沙糯 多层馅料', 'product/6006.jpg', '<p>雪媚娘红豆咸蛋黄点心，下午茶糕点</p>', '/product_detail/6006.jpg', 2, 1, 1, '审核通过', '2026-06-03 15:00:00', '2026-06-03 14:00:00', '2026-06-03 14:00:00', 0);
INSERT INTO `product` VALUES (6007, 5002, 2002, '良品铺子手工黑芝麻软糕400g', '软糯香甜 无添加蔗糖', 'product/6007.jpg', '<p>传统手工糕点，老人小孩均可食用</p>', '/product_detail/6007.jpg', 2, 1, 1, '审核通过', '2026-06-04 10:00:00', '2026-06-04 09:00:00', '2026-06-04 09:00:00', 0);
INSERT INTO `product` VALUES (6008, 5002, 2002, '良品铺子雪花酥300g', '奶香浓郁 坚果混合', 'product/6008.jpg', '<p>牛轧雪花酥，蔓越莓坚果组合网红点心</p>', '/product_detail/6008.jpg', 2, 1, 1, '审核通过', '2026-06-04 16:00:00', '2026-06-04 15:00:00', '2026-06-04 15:00:00', 0);
INSERT INTO `product` VALUES (6009, 5005, 2003, '阿克苏冰糖心苹果5斤装', '产地直发 甜脆多汁', 'product/6009.jpg', '<p>正宗阿克苏冰糖心苹果，果园现摘冷链直达</p>', '/product_detail/6009.jpg', 2, 1, 1, '审核通过', '2026-06-05 10:00:00', '2026-06-05 09:00:00', '2026-06-05 09:00:00', 0);
INSERT INTO `product` VALUES (6010, 5005, 2003, '奉节脐橙8斤装', '重庆本地鲜果 爆汁清甜', 'product/6010.jpg', '<p>奉节核心产区脐橙，皮薄无渣现摘现发</p>', '/product_detail/6010.jpg', 2, 1, 1, '审核通过', '2026-06-05 11:00:00', '2026-06-05 10:30:00', '2026-06-05 10:30:00', 0);
INSERT INTO `product` VALUES (6011, 5005, 2003, '阳光金果奇异果12粒礼盒', '高维C 香甜软嫩', 'product/6011.jpg', '<p>新西兰进口奇异果，高端送礼鲜果礼盒</p>', '/product_detail/6011.jpg', 2, 1, 1, '审核通过', '2026-06-06 10:00:00', '2026-06-06 09:00:00', '2026-06-06 09:00:00', 0);
INSERT INTO `product` VALUES (6012, 5006, 2003, '沃隆每日坚果750g30袋', '科学配比 孕妇可食', 'product/6012.jpg', '<p>无添加盐糖，独立小袋适合每日代餐</p>', '/product_detail/6012.jpg', 2, 1, 1, '审核通过', '2026-06-06 14:00:00', '2026-06-06 13:00:00', '2026-06-06 13:00:00', 0);
INSERT INTO `product` VALUES (6013, 5007, 2004, '金龙鱼稻花香大米5kg袋装', '米油丰厚 软糯香甜', 'product/6013.jpg', '<p>东北五常产区大米，家用煮饭首选</p>', '/product_detail/6013.jpg', 2, 1, 1, '审核通过', '2026-06-07 10:00:00', '2026-06-07 09:00:00', '2026-06-07 09:00:00', 0);
INSERT INTO `product` VALUES (6014, 5007, 2004, '海天金标生抽1.9L桶装', '粮食酿造 凉拌红烧通用', 'product/6014.jpg', '<p>180天酿造酱油，鲜香味足家用调味</p>', '/product_detail/6014.jpg', 2, 1, 1, '审核通过', '2026-06-07 11:00:00', '2026-06-07 10:30:00', '2026-06-07 10:30:00', 0);
INSERT INTO `product` VALUES (6015, 5008, 2004, '涪陵清爽榨菜80g*20袋', '重庆特产 配粥下饭小菜', 'product/6015.jpg', '<p>地道涪陵榨菜，低盐清爽独立小包</p>', '/product_detail/6015.jpg', 2, 1, 1, '审核通过', '2026-06-08 10:00:00', '2026-06-08 09:00:00', '2026-06-08 09:00:00', 0);
INSERT INTO `product` VALUES (6016, 5003, 2004, '农家红薯宽粉1000g', '久煮不烂 火锅炖菜专用', 'product/6016.jpg', '<p>纯红薯手工制作宽粉条，无胶无添加</p>', '/product_detail/6016.jpg', 2, 1, 1, '审核通过', '2026-06-08 15:00:00', '2026-06-08 14:00:00', '2026-06-08 14:00:00', 0);
INSERT INTO `product` VALUES (6017, 5010, 2005, '有友泡椒凤爪210g袋装', '重庆经典 酸辣入味', 'product/6017.jpg', '<p>地道山椒泡凤爪，追剧解馋网红卤味</p>', '/product_detail/6017.jpg', 2, 1, 1, '审核通过', '2026-06-09 10:00:00', '2026-06-09 09:00:00', '2026-06-09 09:00:00', 0);
INSERT INTO `product` VALUES (6018, 5009, 2005, '绝味香辣鸭脖200g锁鲜装', '鲜卤现发 麻辣够味', 'product/6018.jpg', '<p>气调锁鲜鸭脖，开袋即食熟食</p>', '/product_detail/6018.jpg', 2, 1, 1, '审核通过', '2026-06-09 11:00:00', '2026-06-09 10:30:00', '2026-06-09 10:30:00', 0);
INSERT INTO `product` VALUES (6019, 5009, 2005, '绝味原切牛肉脯150g', '肉质紧实 肉香浓郁', 'product/6019.jpg', '<p>谷饲牛肉制作肉干，无淀粉添加</p>', '/product_detail/6019.jpg', 2, 1, 1, '审核通过', '2026-06-10 10:00:00', '2026-06-10 09:00:00', '2026-06-10 09:00:00', 0);
INSERT INTO `product` VALUES (6020, 5010, 2005, '有友现卤五香鹌鹑蛋300g', '卤香浓郁 独立小包', 'product/6020.jpg', '<p>手工老卤慢炖鹌鹑蛋，日常解馋小食</p>', '/product_detail/6020.jpg', 2, 1, 1, '审核通过', '2026-06-10 14:00:00', '2026-06-10 13:00:00', '2026-06-10 13:00:00', 0);
INSERT INTO `product` VALUES (6021, 5011, 2006, '元气森林白桃气泡水480ml*15瓶', '0糖0脂0卡 清爽解腻', 'product/6021.jpg', '<p>白桃果味苏打汽水，冰镇夏日饮品</p>', '/product_detail/6021.jpg', 2, 1, 1, '审核通过', '2026-06-11 10:00:00', '2026-06-11 09:00:00', '2026-06-11 09:00:00', 0);
INSERT INTO `product` VALUES (6022, 5012, 2006, '农夫山泉100%鲜榨橙汁900ml', '鲜果原榨 无浓缩还原', 'product/6022.jpg', '<p>新鲜橙子压榨果汁，家庭日常饮品</p>', '/product_detail/6022.jpg', 2, 1, 1, '审核通过', '2026-06-11 11:00:00', '2026-06-11 10:30:00', '2026-06-11 10:30:00', 0);
INSERT INTO `product` VALUES (6023, 5011, 2006, '元气森林酸奶200g*12盒', '浓稠顺滑 早餐代餐', 'product/6023.jpg', '<p>生牛乳发酵常温酸奶，儿童老人均可饮用</p>', '/product_detail/6023.jpg', 2, 1, 1, '审核通过', '2026-06-12 10:00:00', '2026-06-12 09:00:00', '2026-06-12 09:00:00', 0);
INSERT INTO `product` VALUES (6024, 5011, 2006, '农夫山泉鲜榨芒果复合果汁1L瓶装', '果香浓郁 冰镇更好喝', 'product/6024.jpg', '<p>多种热带水果复配果汁，聚会分享饮品</p>', '/product_detail/6024.jpg', 2, 1, 0, '待审核', NULL, '2026-06-15 10:00:00', '2026-06-15 10:00:00', 0);
INSERT INTO `product` VALUES (6025, 5005, 2003, '智利车厘子JJ级2斤装', '进口鲜果 颗颗饱满', 'product/6025.jpg', '<p>智利空运车厘子，新鲜直达，甜蜜多汁</p>', '/product_detail/6025.jpg', 2, 1, 1, '审核通过', '2026-06-16 10:00:00', '2026-06-16 09:00:00', '2026-06-16 09:00:00', 0);
INSERT INTO `product` VALUES (6026, 5005, 2003, '海南金煌芒果5斤装', '核小肉厚 香甜多汁', 'product/6026.jpg', '<p>海南产地直发金煌芒果，果肉金黄细腻</p>', '/product_detail/6026.jpg', 2, 1, 1, '审核通过', '2026-06-16 11:00:00', '2026-06-16 10:30:00', '2026-06-16 10:30:00', 0);
INSERT INTO `product` VALUES (6027, 5005, 2003, '新疆无籽红提3斤装', '脆甜爽口 无籽多汁', 'product/6027.jpg', '<p>新疆吐鲁番无籽红提，阳光充足甜度高</p>', '/product_detail/6027.jpg', 2, 1, 1, '审核通过', '2026-06-17 10:00:00', '2026-06-17 09:00:00', '2026-06-17 09:00:00', 0);
INSERT INTO `product` VALUES (6028, 5005, 2003, '泰国山竹5斤装', '软糯清甜 果肉饱满', 'product/6028.jpg', '<p>泰国进口山竹，新鲜采摘，香甜可口</p>', '/product_detail/6028.jpg', 2, 1, 1, '审核通过', '2026-06-17 11:00:00', '2026-06-17 10:30:00', '2026-06-17 10:30:00', 0);
INSERT INTO `product` VALUES (6029, 5013, 2003, '云南高山娃娃菜3颗装', '清甜脆嫩 无公害', 'product/6029.jpg', '<p>云南高山种植娃娃菜，口感清甜脆嫩</p>', '/product_detail/6029.jpg', 2, 1, 1, '审核通过', '2026-06-18 10:00:00', '2026-06-18 09:00:00', '2026-06-18 09:00:00', 0);
INSERT INTO `product` VALUES (6030, 5013, 2003, '有机西兰花2颗装', '绿色有机 营养丰富', 'product/6030.jpg', '<p>有机种植西兰花，富含维生素，营养健康</p>', '/product_detail/6030.jpg', 2, 1, 1, '审核通过', '2026-06-18 11:00:00', '2026-06-18 10:30:00', '2026-06-18 10:30:00', 0);
INSERT INTO `product` VALUES (6031, 5013, 2003, '上海青500g', '新鲜翠绿 口感清脆', 'product/6031.jpg', '<p>本地新鲜上海青，翠绿鲜嫩，炒菜首选</p>', '/product_detail/6031.jpg', 2, 1, 1, '审核通过', '2026-06-19 10:00:00', '2026-06-19 09:00:00', '2026-06-19 09:00:00', 0);
INSERT INTO `product` VALUES (6032, 5013, 2003, '新鲜西红柿5斤装', '自然成熟 酸甜可口', 'product/6032.jpg', '<p>露天种植西红柿，自然成熟，沙甜可口</p>', '/product_detail/6032.jpg', 2, 1, 1, '审核通过', '2026-06-19 11:00:00', '2026-06-19 10:30:00', '2026-06-19 10:30:00', 0);
INSERT INTO `product` VALUES (6033, 5013, 2003, '紫甘蓝2颗装', '脆爽多汁 营养丰富', 'product/6033.jpg', '<p>新鲜紫甘蓝，脆爽多汁，凉拌佳品</p>', '/product_detail/6033.jpg', 2, 1, 1, '审核通过', '2026-06-20 10:00:00', '2026-06-20 09:00:00', '2026-06-20 09:00:00', 0);
INSERT INTO `product` VALUES (6034, 5013, 2003, '山东大葱3斤装', '葱白脆嫩 葱香浓郁', 'product/6034.jpg', '<p>山东章丘大葱，葱白脆嫩，葱香浓郁</p>', '/product_detail/6034.jpg', 2, 1, 1, '审核通过', '2026-06-20 11:00:00', '2026-06-20 10:30:00', '2026-06-20 10:30:00', 0);
INSERT INTO `product` VALUES (6035, 5014, 2004, '黑猪五花肉500g', '肥瘦相间 肉质鲜嫩', 'product/6035.jpg', '<p>农家散养黑猪五花肉，肥瘦相间，红烧首选</p>', '/product_detail/6035.jpg', 2, 1, 1, '审核通过', '2026-06-21 10:00:00', '2026-06-21 09:00:00', '2026-06-21 09:00:00', 0);
INSERT INTO `product` VALUES (6036, 5014, 2004, '澳洲牛腩块1kg', '进口牛肉 炖煮佳品', 'product/6036.jpg', '<p>澳洲进口牛腩块，肉质紧实，红烧炖煮皆宜</p>', '/product_detail/6036.jpg', 2, 1, 1, '审核通过', '2026-06-21 11:00:00', '2026-06-21 10:30:00', '2026-06-21 10:30:00', 0);
INSERT INTO `product` VALUES (6037, 5014, 2004, '内蒙古羊排1.5kg', '草原羊肉 鲜嫩无膻', 'product/6037.jpg', '<p>内蒙古草原羊排，肉质鲜嫩，无膻味</p>', '/product_detail/6037.jpg', 2, 1, 1, '审核通过', '2026-06-22 10:00:00', '2026-06-22 09:00:00', '2026-06-22 09:00:00', 0);
INSERT INTO `product` VALUES (6038, 5014, 2004, '猪里脊500g', '肉质细嫩 炒菜首选', 'product/6038.jpg', '<p>新鲜猪里脊肉，肉质细嫩，适合炒菜</p>', '/product_detail/6038.jpg', 2, 1, 1, '审核通过', '2026-06-22 11:00:00', '2026-06-22 10:30:00', '2026-06-22 10:30:00', 0);
INSERT INTO `product` VALUES (6039, 5014, 2004, '肥牛卷500g', '火锅必备 鲜嫩可口', 'product/6039.jpg', '<p>优质肥牛卷，火锅涮肉必备，鲜嫩可口</p>', '/product_detail/6039.jpg', 2, 1, 1, '审核通过', '2026-06-23 10:00:00', '2026-06-23 09:00:00', '2026-06-23 09:00:00', 0);
INSERT INTO `product` VALUES (6040, 5014, 2004, '猪蹄500g', '胶原蛋白丰富', 'product/6040.jpg', '<p>新鲜猪蹄，富含胶原蛋白，炖汤佳品</p>', '/product_detail/6040.jpg', 2, 1, 1, '审核通过', '2026-06-23 11:00:00', '2026-06-23 10:30:00', '2026-06-23 10:30:00', 0);
INSERT INTO `product` VALUES (6041, 5015, 2004, '厄瓜多尔白虾400g', '进口海虾 肉质Q弹', 'product/6041.jpg', '<p>厄瓜多尔进口白虾，肉质Q弹，鲜美可口</p>', '/product_detail/6041.jpg', 2, 1, 1, '审核通过', '2026-06-24 10:00:00', '2026-06-24 09:00:00', '2026-06-24 09:00:00', 0);
INSERT INTO `product` VALUES (6042, 5015, 2004, '挪威三文鱼500g', '进口刺身级', 'product/6042.jpg', '<p>挪威进口三文鱼，刺身级品质，肉质鲜嫩</p>', '/product_detail/6042.jpg', 2, 1, 1, '审核通过', '2026-06-24 11:00:00', '2026-06-24 10:30:00', '2026-06-24 10:30:00', 0);
INSERT INTO `product` VALUES (6043, 5015, 2004, '鲜活大闸蟹4只装', '阳澄湖产区', 'product/6043.jpg', '<p>阳澄湖大闸蟹，膏满黄肥，鲜美无比</p>', '/product_detail/6043.jpg', 2, 1, 1, '审核通过', '2026-06-25 10:00:00', '2026-06-25 09:00:00', '2026-06-25 09:00:00', 0);
INSERT INTO `product` VALUES (6044, 5015, 2004, '鲍鱼4只装', '新鲜活鲍', 'product/6044.jpg', '<p>新鲜活鲍鱼，肉质鲜嫩，滋补佳品</p>', '/product_detail/6044.jpg', 2, 1, 1, '审核通过', '2026-06-25 11:00:00', '2026-06-25 10:30:00', '2026-06-25 10:30:00', 0);
INSERT INTO `product` VALUES (6045, 5015, 2004, '扇贝肉500g', '冷冻新鲜', 'product/6045.jpg', '<p>新鲜扇贝肉，冷冻锁鲜，肉质饱满</p>', '/product_detail/6045.jpg', 2, 1, 1, '审核通过', '2026-06-26 10:00:00', '2026-06-26 09:00:00', '2026-06-26 09:00:00', 0);
INSERT INTO `product` VALUES (6046, 5015, 2004, '花甲500g', '鲜活新鲜', 'product/6046.jpg', '<p>鲜活花甲，肉质鲜美，蒜蓉粉丝蒸首选</p>', '/product_detail/6046.jpg', 2, 1, 1, '审核通过', '2026-06-26 11:00:00', '2026-06-26 10:30:00', '2026-06-26 10:30:00', 0);
INSERT INTO `product` VALUES (6047, 5014, 2004, '农家土鸡整只1.5kg', '散养土鸡', 'product/6047.jpg', '<p>农家散养土鸡，肉质紧实，炖汤鲜美</p>', '/product_detail/6047.jpg', 2, 1, 1, '审核通过', '2026-06-27 10:00:00', '2026-06-27 09:00:00', '2026-06-27 09:00:00', 0);
INSERT INTO `product` VALUES (6048, 5014, 2004, '鲜鸡蛋30枚', '农家土鸡蛋', 'product/6048.jpg', '<p>农家散养土鸡蛋，蛋黄金黄浓稠</p>', '/product_detail/6048.jpg', 2, 1, 1, '审核通过', '2026-06-27 11:00:00', '2026-06-27 10:30:00', '2026-06-27 10:30:00', 0);
INSERT INTO `product` VALUES (6049, 5014, 2004, '老鸭整只2kg', '散养老鸭', 'product/6049.jpg', '<p>农家散养老鸭，肉质紧实，煲汤首选</p>', '/product_detail/6049.jpg', 2, 1, 1, '审核通过', '2026-06-28 10:00:00', '2026-06-28 09:00:00', '2026-06-28 09:00:00', 0);
INSERT INTO `product` VALUES (6050, 5014, 2004, '鹌鹑蛋200g', '新鲜鹌鹑蛋', 'product/6050.jpg', '<p>新鲜鹌鹑蛋，营养丰富，小巧可口</p>', '/product_detail/6050.jpg', 2, 1, 1, '审核通过', '2026-06-28 11:00:00', '2026-06-28 10:30:00', '2026-06-28 10:30:00', 0);
INSERT INTO `product` VALUES (6051, 5014, 2004, '鸽子整只500g', '新鲜乳鸽', 'product/6051.jpg', '<p>新鲜乳鸽，肉质细嫩，营养滋补</p>', '/product_detail/6051.jpg', 2, 1, 1, '审核通过', '2026-06-29 10:00:00', '2026-06-29 09:00:00', '2026-06-29 09:00:00', 0);
INSERT INTO `product` VALUES (6052, 5014, 2005, '湾仔码头水饺500g', '手工水饺', 'product/6052.jpg', '<p>湾仔码头手工水饺，皮薄馅大，鲜美可口</p>', '/product_detail/6052.jpg', 2, 1, 1, '审核通过', '2026-06-29 11:00:00', '2026-06-29 10:30:00', '2026-06-29 10:30:00', 0);
INSERT INTO `product` VALUES (6053, 5014, 2005, '思念汤圆400g', '黑芝麻馅', 'product/6053.jpg', '<p>思念黑芝麻汤圆，软糯香甜，传统美味</p>', '/product_detail/6053.jpg', 2, 1, 1, '审核通过', '2026-06-30 10:00:00', '2026-06-30 09:00:00', '2026-06-30 09:00:00', 0);
INSERT INTO `product` VALUES (6054, 5014, 2005, '正大鸡排500g', '速冻半成品', 'product/6054.jpg', '<p>正大鸡排，外酥里嫩，油炸美味</p>', '/product_detail/6054.jpg', 2, 1, 1, '审核通过', '2026-06-30 11:00:00', '2026-06-30 10:30:00', '2026-06-30 10:30:00', 0);
INSERT INTO `product` VALUES (6055, 5014, 2005, '速冻包子10只装', '鲜肉馅', 'product/6055.jpg', '<p>速冻鲜肉包子，皮薄馅足，早餐必备</p>', '/product_detail/6055.jpg', 2, 1, 1, '审核通过', '2026-07-01 10:00:00', '2026-07-01 09:00:00', '2026-07-01 09:00:00', 0);
INSERT INTO `product` VALUES (6056, 5014, 2005, '手抓饼10片装', '家庭装', 'product/6056.jpg', '<p>手抓饼家庭装，早餐方便快捷，美味可口</p>', '/product_detail/6056.jpg', 2, 1, 1, '审核通过', '2026-07-01 11:00:00', '2026-07-01 10:30:00', '2026-07-01 10:30:00', 0);
INSERT INTO `product` VALUES (6057, 5009, 2005, '周黑鸭锁鲜装300g', '麻辣鲜香', 'product/6057.jpg', '<p>周黑鸭锁鲜装，麻辣鲜香，回味无穷</p>', '/product_detail/6057.jpg', 2, 1, 1, '审核通过', '2026-07-02 10:00:00', '2026-07-02 09:00:00', '2026-07-02 09:00:00', 0);
INSERT INTO `product` VALUES (6058, 5010, 2005, '麻辣兔头2只装', '成都特色', 'product/6058.jpg', '<p>成都特色麻辣兔头，麻辣鲜香，回味无穷</p>', '/product_detail/6058.jpg', 2, 1, 1, '审核通过', '2026-07-02 11:00:00', '2026-07-02 10:30:00', '2026-07-02 10:30:00', 0);
INSERT INTO `product` VALUES (6059, 5022, 2006, '哈根达斯冰淇淋81g', '香草口味', 'product/6059.jpg', '<p>哈根达斯香草冰淇淋，丝滑细腻，美味享受</p>', '[\"product/6059_detail_1.jpg\"]/product_detail/6059.jpg', 2, 1, 1, '审核通过', '2026-07-03 10:00:00', '2026-07-03 09:00:00', '2026-07-03 09:00:00', 0);
INSERT INTO `product` VALUES (6060, 5022, 2006, '八喜冰淇淋500ml', '草莓口味', 'product/6060.jpg', '<p>八喜草莓冰淇淋，香甜细腻，夏日清凉</p>', '/product_detail/6060.jpg', 2, 1, 1, '审核通过', '2026-07-03 11:00:00', '2026-07-03 10:30:00', '2026-07-03 10:30:00', 0);
INSERT INTO `product` VALUES (6061, 5022, 2006, '提拉米苏蛋糕切块', '意式甜点', 'product/6061.jpg', '<p>意式提拉米苏蛋糕，香浓顺滑，下午茶首选</p>', '/product_detail/6061.jpg', 2, 1, 1, '审核通过', '2026-07-04 10:00:00', '2026-07-04 09:00:00', '2026-07-04 09:00:00', 0);
INSERT INTO `product` VALUES (6062, 5022, 2006, '芒果班戟4个装', '港式甜品', 'product/6062.jpg', '<p>港式芒果班戟，皮薄馅大，香甜可口</p>', '/product_detail/6062.jpg', 2, 1, 1, '审核通过', '2026-07-04 11:00:00', '2026-07-04 10:30:00', '2026-07-04 10:30:00', 0);
INSERT INTO `product` VALUES (6063, 5022, 2006, '杨枝甘露300ml', '港式饮品', 'product/6063.jpg', '<p>港式杨枝甘露，芒果西柚西米，清爽美味</p>', '/product_detail/6063.jpg', 2, 1, 1, '审核通过', '2026-07-05 10:00:00', '2026-07-05 09:00:00', '2026-07-05 09:00:00', 0);
INSERT INTO `product` VALUES (6064, 5007, 2004, '鲁花花生油5L', '压榨一级', 'product/6064.jpg', '<p>鲁花压榨一级花生油，香浓纯正，炒菜更香</p>', '/product_detail/6064.jpg', 2, 1, 1, '审核通过', '2026-07-06 10:00:00', '2026-07-06 09:00:00', '2026-07-06 09:00:00', 0);
INSERT INTO `product` VALUES (6065, 5008, 2004, '老干妈辣椒酱280g', '经典风味', 'product/6065.jpg', '<p>老干妈辣椒酱，香辣可口，下饭神器</p>', '/product_detail/6065.jpg', 2, 1, 1, '审核通过', '2026-07-06 11:00:00', '2026-07-06 10:30:00', '2026-07-06 10:30:00', 0);
INSERT INTO `product` VALUES (6066, 5007, 2004, '东北小米2.5kg', '农家特产', 'product/6066.jpg', '<p>东北农家小米，金黄饱满，熬粥香浓</p>', '/product_detail/6066.jpg', 2, 1, 1, '审核通过', '2026-07-07 10:00:00', '2026-07-07 09:00:00', '2026-07-07 09:00:00', 0);
INSERT INTO `product` VALUES (6067, 5017, 2006, '青岛啤酒经典500ml*6', '百年经典', 'product/6067.jpg', '<p>青岛啤酒经典款，百年酿造工艺，畅饮无限</p>', '/product_detail/6067.jpg', 2, 1, 1, '审核通过', '2026-07-07 11:00:00', '2026-07-07 10:30:00', '2026-07-07 10:30:00', 0);
INSERT INTO `product` VALUES (6068, 5018, 2006, '雀巢咖啡1+2原味48杯', '速溶咖啡', 'product/6068.jpg', '<p>雀巢咖啡1+2原味，香浓顺滑，提神醒脑</p>', '/product_detail/6068.jpg', 2, 1, 1, '审核通过', '2026-07-08 10:00:00', '2026-07-08 09:00:00', '2026-07-08 09:00:00', 0);
INSERT INTO `product` VALUES (6069, 5012, 2006, '蒙牛纯牛奶250ml*24', '优质奶源', 'product/6069.jpg', '<p>蒙牛纯牛奶，优质奶源，营养健康</p>', '/product_detail/6069.jpg', 2, 1, 1, '审核通过', '2026-07-08 11:00:00', '2026-07-08 10:30:00', '2026-07-08 10:30:00', 0);
INSERT INTO `product` VALUES (6070, 5022, 2010, '费列罗巧克力T30', '榛果威化', 'product/6070.jpg', '<p>费列罗榛果威化巧克力，香浓美味，送礼首选</p>', '/product_detail/6070.jpg', 2, 1, 1, '审核通过', '2026-07-09 10:00:00', '2026-07-09 09:00:00', '2026-07-09 09:00:00', 0);
INSERT INTO `product` VALUES (6071, 5023, 2010, '明治巧克力豆100g', '缤纷口味', 'product/6071.jpg', '<p>明治巧克力豆，缤纷口味，口感细腻</p>', '/product_detail/6071.jpg', 2, 1, 1, '审核通过', '2026-07-09 11:00:00', '2026-07-09 10:30:00', '2026-07-09 10:30:00', 0);
INSERT INTO `product` VALUES (6072, 5023, 2010, '乐天小熊饼干192g', '夹心饼干', 'product/6072.jpg', '<p>乐天小熊饼干，香浓夹心，可爱造型</p>', '/product_detail/6072.jpg', 2, 1, 1, '审核通过', '2026-07-10 10:00:00', '2026-07-10 09:00:00', '2026-07-10 09:00:00', 0);
INSERT INTO `product` VALUES (6073, 5016, 2010, '茅台飞天53度500ml', '酱香经典', 'product/6073.jpg', '<p>茅台飞天53度，国酒经典，酱香浓郁</p>', '/product_detail/6073.jpg', 2, 1, 1, '审核通过', '2026-07-10 11:00:00', '2026-07-10 10:30:00', '2026-07-10 10:30:00', 0);
INSERT INTO `product` VALUES (6074, 5016, 2010, '进口红酒750ml', '法国产区', 'product/6074.jpg', '<p>法国进口红酒，果香浓郁，口感醇厚</p>', '/product_detail/6074.jpg', 2, 1, 1, '审核通过', '2026-07-11 10:00:00', '2026-07-11 09:00:00', '2026-07-11 09:00:00', 0);
INSERT INTO `product` VALUES (6075, 5008, 2004, '重庆火锅底料礼盒', '麻辣鲜香', 'product/6075.jpg', '<p>重庆火锅底料礼盒，麻辣鲜香，正宗川味</p>', '/product_detail/6075.jpg', 2, 1, 1, '审核通过', '2026-07-11 11:00:00', '2026-07-11 10:30:00', '2026-07-11 10:30:00', 0);
INSERT INTO `product` VALUES (6076, 5022, 2010, '云南鲜花饼礼盒', '花香四溢', 'product/6076.jpg', '<p>云南鲜花饼礼盒，花香四溢，酥软可口</p>', '/product_detail/6076.jpg', 2, 1, 1, '审核通过', '2026-07-12 10:00:00', '2026-07-12 09:00:00', '2026-07-12 09:00:00', 0);
INSERT INTO `product` VALUES (6077, 5014, 2005, '四川腊肠礼盒', '麻辣鲜香', 'product/6077.jpg', '<p>四川腊肠礼盒，麻辣鲜香，年味十足</p>', '/product_detail/6077.jpg', 2, 1, 1, '审核通过', '2026-07-12 11:00:00', '2026-07-12 10:30:00', '2026-07-12 10:30:00', 0);
INSERT INTO `product` VALUES (6078, 5014, 2005, '湖南腊肉礼盒', '烟熏风味', 'product/6078.jpg', '<p>湖南腊肉礼盒，烟熏风味，香气扑鼻</p>', '/product_detail/6078.jpg', 2, 1, 1, '审核通过', '2026-07-13 10:00:00', '2026-07-13 09:00:00', '2026-07-13 09:00:00', 0);
INSERT INTO `product` VALUES (6079, 5008, 2004, '山西陈醋礼盒', '百年老醋', 'product/6079.jpg', '<p>山西陈醋礼盒，百年老醋，酸香浓郁</p>', '/product_detail/6079.jpg', 2, 1, 1, '审核通过', '2026-07-13 11:00:00', '2026-07-13 10:30:00', '2026-07-13 10:30:00', 0);
INSERT INTO `product` VALUES (6080, 5019, 2010, '西湖龙井250g', '明前茶', 'product/6080.jpg', '<p>西湖龙井明前茶，清香甘醇，名茶之首</p>', '/product_detail/6080.jpg', 2, 1, 1, '审核通过', '2026-07-14 10:00:00', '2026-07-14 09:00:00', '2026-07-14 09:00:00', 0);
INSERT INTO `product` VALUES (6081, 5019, 2010, '铁观音250g', '清香型', 'product/6081.jpg', '<p>铁观音清香型，香气高扬，回甘持久</p>', '/product_detail/6081.jpg', 2, 1, 1, '审核通过', '2026-07-14 11:00:00', '2026-07-14 10:30:00', '2026-07-14 10:30:00', 0);
INSERT INTO `product` VALUES (6082, 5019, 2010, '大红袍100g', '岩茶之王', 'product/6082.jpg', '<p>大红袍岩茶之王，香气馥郁，岩韵悠长</p>', '/product_detail/6082.jpg', 2, 1, 1, '审核通过', '2026-07-15 10:00:00', '2026-07-15 09:00:00', '2026-07-15 09:00:00', 0);
INSERT INTO `product` VALUES (6083, 5019, 2006, '立顿红茶包100包', '经典红茶', 'product/6083.jpg', '<p>立顿红茶包，经典口味，方便快捷</p>', '/product_detail/6083.jpg', 2, 1, 1, '审核通过', '2026-07-15 11:00:00', '2026-07-15 10:30:00', '2026-07-15 10:30:00', 0);
INSERT INTO `product` VALUES (6084, 5019, 2010, '普洱熟茶357g', '勐海味', 'product/6084.jpg', '<p>普洱熟茶勐海味，陈香醇厚，暖胃养生</p>', '/product_detail/6084.jpg', 2, 1, 1, '审核通过', '2026-07-16 10:00:00', '2026-07-16 09:00:00', '2026-07-16 09:00:00', 0);
INSERT INTO `product` VALUES (6085, 5020, 2010, '同仁堂阿胶250g', '补血养颜', 'product/6085.jpg', '<p>同仁堂阿胶，补血养颜，滋阴润燥</p>', '/product_detail/6085.jpg', 2, 1, 1, '审核通过', '2026-07-16 11:00:00', '2026-07-16 10:30:00', '2026-07-16 10:30:00', 0);
INSERT INTO `product` VALUES (6086, 5021, 2010, '汤臣倍健蛋白粉450g', '增强免疫力', 'product/6086.jpg', '<p>汤臣倍健蛋白粉，增强免疫力，营养补充</p>', '/product_detail/6086.jpg', 2, 1, 1, '审核通过', '2026-07-17 10:00:00', '2026-07-17 09:00:00', '2026-07-17 09:00:00', 0);
INSERT INTO `product` VALUES (6087, 5020, 2010, '西洋参片100g', '补气养阴', 'product/6087.jpg', '<p>西洋参片，补气养阴，清热生津</p>', '/product_detail/6087.jpg', 2, 1, 1, '审核通过', '2026-07-17 11:00:00', '2026-07-17 10:30:00', '2026-07-17 10:30:00', 0);
INSERT INTO `product` VALUES (6088, 5020, 2010, '燕窝礼盒装', '滋补佳品', 'product/6088.jpg', '<p>燕窝礼盒装，天然滋补，养颜美容</p>', '/product_detail/6088.jpg', 2, 1, 1, '审核通过', '2026-07-18 10:00:00', '2026-07-18 09:00:00', '2026-07-18 09:00:00', 0);
INSERT INTO `product` VALUES (6089, 5021, 2010, '鱼油软胶囊100粒', '心脑血管健康', 'product/6089.jpg', '<p>鱼油软胶囊，心脑血管健康，益智补脑</p>', '/product_detail/6089.jpg', 2, 1, 1, '审核通过', '2026-07-18 11:00:00', '2026-07-18 10:30:00', '2026-07-18 10:30:00', 0);
INSERT INTO `product` VALUES (6090, 5002, 2001, '中秋月饼礼盒', '广式月饼', 'product/6090.jpg', '<p>中秋月饼礼盒，广式月饼，团圆美味</p>', '/product_detail/6090.jpg', 2, 1, 1, '审核通过', '2026-07-19 10:00:00', '2026-07-19 09:00:00', '2026-07-19 09:00:00', 0);
INSERT INTO `product` VALUES (6091, 5001, 2001, '坚果大礼包', '送礼佳品', 'product/6091.jpg', '<p>坚果大礼包，送礼佳品，营养丰富</p>', '/product_detail/6091.jpg', 3, 1, 1, '审核通过', '2026-07-19 11:00:00', '2026-07-19 10:30:00', '2026-07-19 10:30:00', 0);
INSERT INTO `product` VALUES (6092, 5007, 2004, '春节年货礼盒', '粮油礼盒', 'product/6092.jpg', '<p>春节年货礼盒，粮油礼盒，年味十足</p>', '/product_detail/6092.jpg', 3, 1, 1, '审核通过', '2026-07-20 10:00:00', '2026-07-20 09:00:00', '2026-07-20 09:00:00', 0);
INSERT INTO `product` VALUES (6093, 5005, 2003, '进口水果礼盒', '鲜果礼盒', 'product/6093.jpg', '<p>进口水果礼盒，鲜果礼盒，送礼体面</p>', '/product_detail/6093.jpg', 3, 1, 1, '审核通过', '2026-07-20 11:00:00', '2026-07-20 10:30:00', '2026-07-20 10:30:00', 0);
INSERT INTO `product` VALUES (6094, 5015, 2004, '海鲜礼盒', '海鲜大礼包', 'product/6094.jpg', '<p>海鲜礼盒，海鲜大礼包，鲜美无比</p>', '/product_detail/6094.jpg', 3, 1, 1, '审核通过', '2026-07-21 10:00:00', '2026-07-21 09:00:00', '2026-07-21 09:00:00', 0);
INSERT INTO `product` VALUES (6095, 5024, 2007, '水星家纺四件套', '全棉印花', 'product/6095.jpg', '<p>水星家纺四件套，全棉印花，舒适睡眠</p>', '/product_detail/6095.jpg', 3, 1, 1, '审核通过', '2026-07-21 11:00:00', '2026-07-21 10:30:00', '2026-07-21 10:30:00', 0);
INSERT INTO `product` VALUES (6096, 5024, 2007, '纯棉毛巾3条装', '柔软亲肤', 'product/6096.jpg', '<p>纯棉毛巾3条装，柔软亲肤，吸水速干</p>', '/product_detail/6096.jpg', 3, 1, 1, '审核通过', '2026-07-22 10:00:00', '2026-07-22 09:00:00', '2026-07-22 09:00:00', 0);
INSERT INTO `product` VALUES (6097, 5024, 2007, '蚕丝被冬被', '保暖舒适', 'product/6097.jpg', '<p>蚕丝被冬被，保暖舒适，亲肤透气</p>', '/product_detail/6097.jpg', 3, 1, 1, '审核通过', '2026-07-22 11:00:00', '2026-07-22 10:30:00', '2026-07-22 10:30:00', 0);
INSERT INTO `product` VALUES (6098, 5024, 2007, '枕头一对', '记忆棉', 'product/6098.jpg', '<p>记忆棉枕头一对，护颈舒适，深度睡眠</p>', '/product_detail/6098.jpg', 3, 1, 1, '审核通过', '2026-07-23 10:00:00', '2026-07-23 09:00:00', '2026-07-23 09:00:00', 0);
INSERT INTO `product` VALUES (6099, 5024, 2007, '浴巾大号', '纯棉加厚', 'product/6099.jpg', '<p>纯棉加厚浴巾大号，柔软吸水，品质生活</p>', '/product_detail/6099.jpg', 3, 1, 1, '审核通过', '2026-07-23 11:00:00', '2026-07-23 10:30:00', '2026-07-23 10:30:00', 0);
INSERT INTO `product` VALUES (6100, 5025, 2007, '欧普LED吸顶灯', '节能护眼', 'product/6100.jpg', '<p>欧普LED吸顶灯，节能护眼，明亮舒适</p>', '/product_detail/6100.jpg', 3, 1, 1, '审核通过', '2026-07-24 10:00:00', '2026-07-24 09:00:00', '2026-07-24 09:00:00', 0);
INSERT INTO `product` VALUES (6101, 5025, 2007, '台灯护眼灯', '学生专用', 'product/6101.jpg', '<p>台灯护眼灯，学生专用，无频闪</p>', '/product_detail/6101.jpg', 3, 1, 1, '审核通过', '2026-07-24 11:00:00', '2026-07-24 10:30:00', '2026-07-24 10:30:00', 0);
INSERT INTO `product` VALUES (6102, 5025, 2007, '落地灯客厅', '简约现代', 'product/6102.jpg', '<p>落地灯客厅，简约现代，温馨照明</p>', '/product_detail/6102.jpg', 3, 1, 1, '审核通过', '2026-07-25 10:00:00', '2026-07-25 09:00:00', '2026-07-25 09:00:00', 0);
INSERT INTO `product` VALUES (6103, 5025, 2007, '床头小夜灯', '暖光护眼', 'product/6103.jpg', '<p>床头小夜灯，暖光护眼，夜间起夜方便</p>', '/product_detail/6103.jpg', 3, 1, 1, '审核通过', '2026-07-25 11:00:00', '2026-07-25 10:30:00', '2026-07-25 10:30:00', 0);
INSERT INTO `product` VALUES (6104, 5025, 2007, '厨房吸顶灯', '防水防油', 'product/6104.jpg', '<p>厨房吸顶灯，防水防油，明亮照明</p>', '/product_detail/6104.jpg', 3, 1, 1, '审核通过', '2026-07-26 10:00:00', '2026-07-26 09:00:00', '2026-07-26 09:00:00', 0);
INSERT INTO `product` VALUES (6105, 5026, 2007, '乐扣乐扣保鲜盒5件套', '密封保鲜', 'product/6105.jpg', '<p>乐扣乐扣保鲜盒5件套，密封保鲜，健康生活</p>', '/product_detail/6105.jpg', 3, 1, 1, '审核通过', '2026-07-27 10:00:00', '2026-07-27 09:00:00', '2026-07-27 09:00:00', 0);
INSERT INTO `product` VALUES (6106, 5026, 2007, '收纳箱大号', '环保材质', 'product/6106.jpg', '<p>收纳箱大号，环保材质，居家收纳必备</p>', '/product_detail/6106.jpg', 3, 1, 1, '审核通过', '2026-07-27 11:00:00', '2026-07-27 10:30:00', '2026-07-27 10:30:00', 0);
INSERT INTO `product` VALUES (6107, 5026, 2007, '抽屉收纳盒', '整理收纳', 'product/6107.jpg', '<p>抽屉收纳盒，整理收纳，告别杂乱</p>', '/product_detail/6107.jpg', 3, 1, 1, '审核通过', '2026-07-28 10:00:00', '2026-07-28 09:00:00', '2026-07-28 09:00:00', 0);
INSERT INTO `product` VALUES (6108, 5026, 2007, '衣柜收纳架', '分层收纳', 'product/6108.jpg', '<p>衣柜收纳架，分层收纳，节省空间</p>', '/product_detail/6108.jpg', 3, 1, 1, '审核通过', '2026-07-28 11:00:00', '2026-07-28 10:30:00', '2026-07-28 10:30:00', 0);
INSERT INTO `product` VALUES (6109, 5027, 2007, '蓝月亮洗衣液3kg', '温和洁净', 'product/6109.jpg', '<p>蓝月亮洗衣液，温和洁净，呵护衣物</p>', '/product_detail/6109.jpg', 3, 1, 1, '审核通过', '2026-07-29 10:00:00', '2026-07-29 09:00:00', '2026-07-29 09:00:00', 0);
INSERT INTO `product` VALUES (6110, 5028, 2007, '维达纸巾抽纸3包', '柔软亲肤', 'product/6110.jpg', '<p>维达纸巾抽纸，柔软亲肤，品质生活</p>', '/product_detail/6110.jpg', 3, 1, 1, '审核通过', '2026-07-29 11:00:00', '2026-07-29 10:30:00', '2026-07-29 10:30:00', 0);
INSERT INTO `product` VALUES (6111, 5027, 2007, '消毒湿巾100片', '杀菌消毒', 'product/6111.jpg', '<p>消毒湿巾，杀菌消毒，卫生安全</p>', '/product_detail/6111.jpg', 3, 1, 1, '审核通过', '2026-07-30 10:00:00', '2026-07-30 09:00:00', '2026-07-30 09:00:00', 0);
INSERT INTO `product` VALUES (6112, 5027, 2007, '洁厕灵500ml', '强力去污', 'product/6112.jpg', '<p>洁厕灵，强力去污，厕所清洁必备</p>', '/product_detail/6112.jpg', 3, 1, 1, '审核通过', '2026-07-30 11:00:00', '2026-07-30 10:30:00', '2026-07-30 10:30:00', 0);
INSERT INTO `product` VALUES (6113, 5029, 2007, '箭牌马桶盖', '缓降静音', 'product/6113.jpg', '<p>箭牌马桶盖，缓降静音，品质卫浴</p>', '/product_detail/6113.jpg', 3, 1, 1, '审核通过', '2026-08-01 10:00:00', '2026-08-01 09:00:00', '2026-08-01 09:00:00', 0);
INSERT INTO `product` VALUES (6114, 5029, 2007, '箭牌花洒套装', '恒温出水', 'product/6114.jpg', '<p>箭牌花洒套装，恒温出水，舒适沐浴</p>', '/product_detail/6114.jpg', 3, 1, 1, '审核通过', '2026-08-01 11:00:00', '2026-08-01 10:30:00', '2026-08-01 10:30:00', 0);
INSERT INTO `product` VALUES (6115, 5029, 2007, '漱口杯套装', '简约设计', 'product/6115.jpg', '<p>漱口杯套装，简约设计，浴室必备</p>', '/product_detail/6115.jpg', 3, 1, 1, '审核通过', '2026-08-02 10:00:00', '2026-08-02 09:00:00', '2026-08-02 09:00:00', 0);
INSERT INTO `product` VALUES (6116, 5030, 2007, '天堂雨伞大号', '防风防雨', 'product/6116.jpg', '<p>天堂雨伞大号，防风防雨，品质保障</p>', '/product_detail/6116.jpg', 3, 1, 1, '审核通过', '2026-08-02 11:00:00', '2026-08-02 10:30:00', '2026-08-02 10:30:00', 0);
INSERT INTO `product` VALUES (6117, 5030, 2007, '雨衣加厚', '户外必备', 'product/6117.jpg', '<p>雨衣加厚，户外必备，风雨无阻</p>', '/product_detail/6117.jpg', 3, 1, 1, '审核通过', '2026-08-03 10:00:00', '2026-08-03 09:00:00', '2026-08-03 09:00:00', 0);
INSERT INTO `product` VALUES (6118, 5030, 2007, '防晒衣轻薄', '透气防晒', 'product/6118.jpg', '<p>防晒衣轻薄，透气防晒，夏季必备</p>', '/product_detail/6118.jpg', 3, 1, 1, '审核通过', '2026-08-03 11:00:00', '2026-08-03 10:30:00', '2026-08-03 10:30:00', 0);
INSERT INTO `product` VALUES (6119, 5031, 2007, '晾衣架落地', '折叠便携', 'product/6119.jpg', '<p>晾衣架落地，折叠便携，晾晒方便</p>', '/product_detail/6119.jpg', 3, 1, 1, '审核通过', '2026-08-04 10:00:00', '2026-08-04 09:00:00', '2026-08-04 09:00:00', 0);
INSERT INTO `product` VALUES (6120, 5031, 2007, '烫衣板家用', '稳固耐用', 'product/6120.jpg', '<p>烫衣板家用，稳固耐用，熨烫方便</p>', '/product_detail/6120.jpg', 3, 1, 1, '审核通过', '2026-08-04 11:00:00', '2026-08-04 10:30:00', '2026-08-04 10:30:00', 0);
INSERT INTO `product` VALUES (6121, 5031, 2007, '衣架10个装', '防滑无痕', 'product/6121.jpg', '<p>衣架10个装，防滑无痕，晾晒必备</p>', '/product_detail/6121.jpg', 3, 1, 1, '审核通过', '2026-08-05 10:00:00', '2026-08-05 09:00:00', '2026-08-05 09:00:00', 0);
INSERT INTO `product` VALUES (6122, 5032, 2007, '宜家装饰花瓶', '简约现代', 'product/6122.jpg', '<p>宜家装饰花瓶，简约现代，家居装饰</p>', '/product_detail/6122.jpg', 3, 1, 1, '审核通过', '2026-08-05 11:00:00', '2026-08-05 10:30:00', '2026-08-05 10:30:00', 0);
INSERT INTO `product` VALUES (6123, 5032, 2007, '仿真花束', '装饰摆件', 'product/6123.jpg', '<p>仿真花束，装饰摆件，无需打理</p>', '/product_detail/6123.jpg', 3, 1, 1, '审核通过', '2026-08-06 10:00:00', '2026-08-06 09:00:00', '2026-08-06 09:00:00', 0);
INSERT INTO `product` VALUES (6124, 5032, 2007, '多肉植物组合', '桌面绿植', 'product/6124.jpg', '<p>多肉植物组合，桌面绿植，净化空气</p>', '/product_detail/6124.jpg', 3, 1, 1, '审核通过', '2026-08-06 11:00:00', '2026-08-06 10:30:00', '2026-08-06 10:30:00', 0);
INSERT INTO `product` VALUES (6125, 5033, 2007, '皇家猫粮1.5kg', '营养均衡', 'product/6125.jpg', '<p>皇家猫粮，营养均衡，关爱宠物</p>', '/product_detail/6125.jpg', 3, 1, 1, '审核通过', '2026-08-07 10:00:00', '2026-08-07 09:00:00', '2026-08-07 09:00:00', 0);
INSERT INTO `product` VALUES (6126, 5033, 2007, '皇家狗粮1.5kg', '营养均衡', 'product/6126.jpg', '<p>皇家狗粮，营养均衡，关爱宠物</p>', '/product_detail/6126.jpg', 3, 1, 1, '审核通过', '2026-08-07 11:00:00', '2026-08-07 10:30:00', '2026-08-07 10:30:00', 0);
INSERT INTO `product` VALUES (6127, 5033, 2007, '猫砂10kg', '无尘结团', 'product/6127.jpg', '<p>猫砂10kg，无尘结团，宠物清洁</p>', '/product_detail/6127.jpg', 3, 1, 1, '审核通过', '2026-08-08 10:00:00', '2026-08-08 09:00:00', '2026-08-08 09:00:00', 0);
INSERT INTO `product` VALUES (6128, 5034, 2008, '苏泊尔不粘锅32cm', '少油烟', 'product/6128.jpg', '<p>苏泊尔不粘锅，少油烟，轻松烹饪</p>', '/product_detail/6128.jpg', 3, 1, 1, '审核通过', '2026-08-08 11:00:00', '2026-08-08 10:30:00', '2026-08-08 10:30:00', 0);
INSERT INTO `product` VALUES (6129, 5034, 2008, '苏泊尔压力锅5L', '高效烹饪', 'product/6129.jpg', '<p>苏泊尔压力锅，高效烹饪，省时省力</p>', '/product_detail/6129.jpg', 3, 1, 1, '审核通过', '2026-08-09 10:00:00', '2026-08-09 09:00:00', '2026-08-09 09:00:00', 0);
INSERT INTO `product` VALUES (6130, 5034, 2008, '苏泊尔炒锅34cm', '铸铁材质', 'product/6130.jpg', '<p>苏泊尔铸铁炒锅，健康烹饪，补铁首选</p>', '/product_detail/6130.jpg', 3, 1, 1, '审核通过', '2026-08-09 11:00:00', '2026-08-09 10:30:00', '2026-08-09 10:30:00', 0);
INSERT INTO `product` VALUES (6131, 5035, 2008, '张小泉菜刀', '锋利耐用', 'product/6131.jpg', '<p>张小泉菜刀，锋利耐用，品质传承</p>', '/product_detail/6131.jpg', 3, 1, 1, '审核通过', '2026-08-10 10:00:00', '2026-08-10 09:00:00', '2026-08-10 09:00:00', 0);
INSERT INTO `product` VALUES (6132, 5035, 2008, '张小泉剪刀', '家用剪刀', 'product/6132.jpg', '<p>张小泉剪刀，家用剪刀，多功能使用</p>', '/product_detail/6132.jpg', 3, 1, 1, '审核通过', '2026-08-10 11:00:00', '2026-08-10 10:30:00', '2026-08-10 10:30:00', 0);
INSERT INTO `product` VALUES (6133, 5035, 2008, '砧板实木', '抗菌防霉', 'product/6133.jpg', '<p>实木砧板，抗菌防霉，厨房必备</p>', '/product_detail/6133.jpg', 3, 1, 1, '审核通过', '2026-08-11 10:00:00', '2026-08-11 09:00:00', '2026-08-11 09:00:00', 0);
INSERT INTO `product` VALUES (6134, 5036, 2008, '富光保温杯500ml', '316不锈钢', 'product/6134.jpg', '<p>富光保温杯，316不锈钢，保温持久</p>', '/product_detail/6134.jpg', 3, 1, 1, '审核通过', '2026-08-11 11:00:00', '2026-08-11 10:30:00', '2026-08-11 10:30:00', 0);
INSERT INTO `product` VALUES (6135, 5036, 2008, '富光玻璃杯350ml', '耐高温', 'product/6135.jpg', '<p>富光玻璃杯，耐高温，健康饮水</p>', '/product_detail/6135.jpg', 3, 1, 1, '审核通过', '2026-08-12 10:00:00', '2026-08-12 09:00:00', '2026-08-12 09:00:00', 0);
INSERT INTO `product` VALUES (6136, 5037, 2008, '康宁玻璃碗套装', '耐热玻璃', 'product/6136.jpg', '<p>康宁玻璃碗套装，耐热玻璃，健康环保</p>', '/product_detail/6136.jpg', 3, 1, 1, '审核通过', '2026-08-12 11:00:00', '2026-08-12 10:30:00', '2026-08-12 10:30:00', 0);
INSERT INTO `product` VALUES (6137, 5037, 2008, '陶瓷碗盘套装', '中式风格', 'product/6137.jpg', '<p>陶瓷碗盘套装，中式风格，餐桌必备</p>', '/product_detail/6137.jpg', 3, 1, 1, '审核通过', '2026-08-13 10:00:00', '2026-08-13 09:00:00', '2026-08-13 09:00:00', 0);
INSERT INTO `product` VALUES (6138, 5038, 2008, '九阳豆浆机', '全自动', 'product/6138.jpg', '<p>九阳豆浆机，全自动，营养早餐</p>', '/product_detail/6138.jpg', 3, 1, 1, '审核通过', '2026-08-13 11:00:00', '2026-08-13 10:30:00', '2026-08-13 10:30:00', 0);
INSERT INTO `product` VALUES (6139, 5038, 2008, '九阳电饭煲4L', '智能预约', 'product/6139.jpg', '<p>九阳电饭煲，智能预约，煮饭更香</p>', '/product_detail/6139.jpg', 3, 1, 1, '审核通过', '2026-08-14 10:00:00', '2026-08-14 09:00:00', '2026-08-14 09:00:00', 0);
INSERT INTO `product` VALUES (6140, 5038, 2008, '厨房置物架', '多层收纳', 'product/6140.jpg', '<p>厨房置物架，多层收纳，节省空间</p>', '/product_detail/6140.jpg', 3, 1, 1, '审核通过', '2026-08-14 11:00:00', '2026-08-14 10:30:00', '2026-08-14 10:30:00', 0);
INSERT INTO `product` VALUES (6141, 5039, 2007, '欧莱雅洗面奶', '深层清洁', 'product/6141.jpg', '<p>欧莱雅洗面奶，深层清洁，洁面首选</p>', '/product_detail/6141.jpg', 3, 1, 1, '审核通过', '2026-08-15 10:00:00', '2026-08-15 09:00:00', '2026-08-15 09:00:00', 0);
INSERT INTO `product` VALUES (6142, 5039, 2007, '欧莱雅面霜', '补水保湿', 'product/6142.jpg', '<p>欧莱雅面霜，补水保湿，滋润肌肤</p>', '/product_detail/6142.jpg', 3, 1, 1, '审核通过', '2026-08-15 11:00:00', '2026-08-15 10:30:00', '2026-08-15 10:30:00', 0);
INSERT INTO `product` VALUES (6143, 5040, 2007, '玉兰油精华液', '提亮肤色', 'product/6143.jpg', '<p>玉兰油精华液，提亮肤色，焕发光彩</p>', '/product_detail/6143.jpg', 3, 1, 1, '审核通过', '2026-08-16 10:00:00', '2026-08-16 09:00:00', '2026-08-16 09:00:00', 0);
INSERT INTO `product` VALUES (6144, 5041, 2007, '多芬沐浴露500ml', '滋润保湿', 'product/6144.jpg', '<p>多芬沐浴露，滋润保湿，温和呵护</p>', '/product_detail/6144.jpg', 3, 1, 1, '审核通过', '2026-08-16 11:00:00', '2026-08-16 10:30:00', '2026-08-16 10:30:00', 0);
INSERT INTO `product` VALUES (6145, 5041, 2007, '多芬身体乳200ml', '持久滋润', 'product/6145.jpg', '<p>多芬身体乳，持久滋润，肌肤嫩滑</p>', '/product_detail/6145.jpg', 3, 1, 1, '审核通过', '2026-08-17 10:00:00', '2026-08-17 09:00:00', '2026-08-17 09:00:00', 0);
INSERT INTO `product` VALUES (6146, 5042, 2007, '潘婷洗发水500ml', '修护秀发', 'product/6146.jpg', '<p>潘婷洗发水，修护秀发，健康亮泽</p>', '/product_detail/6146.jpg', 3, 1, 1, '审核通过', '2026-08-17 11:00:00', '2026-08-17 10:30:00', '2026-08-17 10:30:00', 0);
INSERT INTO `product` VALUES (6147, 5042, 2007, '潘婷护发素300ml', '顺滑修护', 'product/6147.jpg', '<p>潘婷护发素，顺滑修护，头发更柔顺</p>', '/product_detail/6147.jpg', 3, 1, 1, '审核通过', '2026-08-18 10:00:00', '2026-08-18 09:00:00', '2026-08-18 09:00:00', 0);
INSERT INTO `product` VALUES (6148, 5043, 2007, '高露洁牙膏120g', '防蛀美白', 'product/6148.jpg', '<p>高露洁牙膏，防蛀美白，健康口腔</p>', '/product_detail/6148.jpg', 3, 1, 1, '审核通过', '2026-08-18 11:00:00', '2026-08-18 10:30:00', '2026-08-18 10:30:00', 0);
INSERT INTO `product` VALUES (6149, 5043, 2007, '电动牙刷', '声波清洁', 'product/6149.jpg', '<p>电动牙刷，声波清洁，刷牙更干净</p>', '/product_detail/6149.jpg', 3, 1, 1, '审核通过', '2026-08-19 10:00:00', '2026-08-19 09:00:00', '2026-08-19 09:00:00', 0);
INSERT INTO `product` VALUES (6150, 5044, 2007, '护舒宝卫生巾', '日用夜用组合', 'product/6150.jpg', '<p>护舒宝卫生巾，日用夜用组合，贴心呵护</p>', '/product_detail/6150.jpg', 3, 1, 1, '审核通过', '2026-08-19 11:00:00', '2026-08-19 10:30:00', '2026-08-19 10:30:00', 0);
INSERT INTO `product` VALUES (6151, 5045, 2007, '迪奥香水50ml', '经典香氛', 'product/6151.jpg', '<p>迪奥香水，经典香氛，优雅气质</p>', '/product_detail/6151.jpg', 3, 1, 1, '审核通过', '2026-08-20 10:00:00', '2026-08-20 09:00:00', '2026-08-20 09:00:00', 0);
INSERT INTO `product` VALUES (6152, 5046, 2007, '美宝莲口红', '经典红色', 'product/6152.jpg', '<p>美宝莲口红，经典红色，时尚彩妆</p>', '/product_detail/6152.jpg', 3, 1, 1, '审核通过', '2026-08-20 11:00:00', '2026-08-20 10:30:00', '2026-08-20 10:30:00', 0);
INSERT INTO `product` VALUES (6153, 5047, 2009, '美赞臣奶粉3段', '科学配方', 'product/6153.jpg', '<p>美赞臣奶粉，科学配方，呵护成长</p>', '/product_detail/6153.jpg', 3, 1, 1, '审核通过', '2026-08-21 10:00:00', '2026-08-21 09:00:00', '2026-08-21 09:00:00', 0);
INSERT INTO `product` VALUES (6154, 5047, 2009, '美赞臣奶粉1段', '新生儿配方', 'product/6154.jpg', '<p>美赞臣奶粉1段，新生儿配方，营养全面</p>', '/product_detail/6154.jpg', 3, 1, 1, '审核通过', '2026-08-21 11:00:00', '2026-08-21 10:30:00', '2026-08-21 10:30:00', 0);
INSERT INTO `product` VALUES (6155, 5048, 2009, '亨氏米粉', '宝宝辅食', 'product/6155.jpg', '<p>亨氏米粉，宝宝辅食，营养均衡</p>', '/product_detail/6155.jpg', 3, 1, 1, '审核通过', '2026-08-22 10:00:00', '2026-08-22 09:00:00', '2026-08-22 09:00:00', 0);
INSERT INTO `product` VALUES (6156, 5048, 2009, '亨氏果泥', '营养辅食', 'product/6156.jpg', '<p>亨氏果泥，营养辅食，方便喂养</p>', '/product_detail/6156.jpg', 3, 1, 1, '审核通过', '2026-08-22 11:00:00', '2026-08-22 10:30:00', '2026-08-22 10:30:00', 0);
INSERT INTO `product` VALUES (6157, 5049, 2009, '帮宝适纸尿裤', '干爽舒适', 'product/6157.jpg', '<p>帮宝适纸尿裤，干爽舒适，呵护宝宝</p>', '/product_detail/6157.jpg', 3, 1, 1, '审核通过', '2026-08-23 10:00:00', '2026-08-23 09:00:00', '2026-08-23 09:00:00', 0);
INSERT INTO `product` VALUES (6158, 5049, 2009, '湿巾80抽', '婴儿专用', 'product/6158.jpg', '<p>湿巾80抽，婴儿专用，温和无刺激</p>', '/product_detail/6158.jpg', 3, 1, 1, '审核通过', '2026-08-23 11:00:00', '2026-08-23 10:30:00', '2026-08-23 10:30:00', 0);
INSERT INTO `product` VALUES (6159, 5050, 2009, '贝亲奶瓶', '宽口径', 'product/6159.jpg', '<p>贝亲奶瓶，宽口径，方便冲泡</p>', '/product_detail/6159.jpg', 3, 1, 1, '审核通过', '2026-08-24 10:00:00', '2026-08-24 09:00:00', '2026-08-24 09:00:00', 0);
INSERT INTO `product` VALUES (6160, 5050, 2009, '贝亲辅食碗', '宝宝餐具', 'product/6160.jpg', '<p>贝亲辅食碗，宝宝餐具，安全材质</p>', '/product_detail/6160.jpg', 3, 1, 1, '审核通过', '2026-08-24 11:00:00', '2026-08-24 10:30:00', '2026-08-24 10:30:00', 0);
INSERT INTO `product` VALUES (6161, 5050, 2009, '宝宝沐浴露', '温和洗护', 'product/6161.jpg', '<p>宝宝沐浴露，温和洗护，呵护肌肤</p>', '/product_detail/6161.jpg', 3, 1, 1, '审核通过', '2026-08-25 10:00:00', '2026-08-25 09:00:00', '2026-08-25 09:00:00', 0);
INSERT INTO `product` VALUES (6162, 5050, 2009, '宝宝面霜', '保湿滋润', 'product/6162.jpg', '<p>宝宝面霜，保湿滋润，婴儿专用</p>', '/product_detail/6162.jpg', 3, 1, 1, '审核通过', '2026-08-25 11:00:00', '2026-08-25 10:30:00', '2026-08-25 10:30:00', 0);
INSERT INTO `product` VALUES (6163, 5050, 2009, '童装套装', '纯棉舒适', 'product/6163.jpg', '<p>童装套装，纯棉舒适，宝宝穿搭</p>', '/product_detail/6163.jpg', 3, 1, 1, '审核通过', '2026-08-26 10:00:00', '2026-08-26 09:00:00', '2026-08-26 09:00:00', 0);
INSERT INTO `product` VALUES (6164, 5050, 2009, '婴儿连体衣', '纯棉材质', 'product/6164.jpg', '<p>婴儿连体衣，纯棉材质，柔软舒适</p>', '/product_detail/6164.jpg', 3, 1, 1, '审核通过', '2026-08-26 11:00:00', '2026-08-26 10:30:00', '2026-08-26 10:30:00', 0);
INSERT INTO `product` VALUES (6165, 5050, 2009, '孕妇装连衣裙', '宽松舒适', 'product/6165.jpg', '<p>孕妇装连衣裙，宽松舒适，孕期穿搭</p>', '/product_detail/6165.jpg', 3, 1, 1, '审核通过', '2026-08-27 10:00:00', '2026-08-27 09:00:00', '2026-08-27 09:00:00', 0);
INSERT INTO `product` VALUES (6166, 5050, 2009, '孕妇奶粉', '孕期营养', 'product/6166.jpg', '<p>孕妇奶粉，孕期营养，妈妈健康</p>', '/product_detail/6166.jpg', 3, 1, 1, '审核通过', '2026-08-27 11:00:00', '2026-08-27 10:30:00', '2026-08-27 10:30:00', 0);
INSERT INTO `product` VALUES (6167, 5050, 2009, '婴儿推车', '轻便折叠', 'product/6167.jpg', '<p>婴儿推车，轻便折叠，出行方便</p>', '/product_detail/6167.jpg', 3, 1, 1, '审核通过', '2026-08-28 10:00:00', '2026-08-28 09:00:00', '2026-08-28 09:00:00', 0);
INSERT INTO `product` VALUES (6168, 5050, 2009, '安全座椅', '儿童专用', 'product/6168.jpg', '<p>安全座椅，儿童专用，出行安全</p>', '/product_detail/6168.jpg', 3, 1, 1, '审核通过', '2026-08-28 11:00:00', '2026-08-28 10:30:00', '2026-08-28 10:30:00', 0);
INSERT INTO `product` VALUES (6169, 5014, 2011, '新鲜五花肉500g', '农家散养土猪', 'product/6169.jpg', '<p>农家散养土猪五花肉，肥瘦相间，红烧首选</p>', '/product_detail/6169.jpg', 2, 1, 1, '审核通过', '2026-08-29 10:00:00', '2026-08-29 09:00:00', '2026-08-29 09:00:00', 0);
INSERT INTO `product` VALUES (6170, 5015, 2011, '鲜活基围虾500g', '当日海捕', 'product/6170.jpg', '<p>当日海捕鲜活基围虾，肉质Q弹，鲜美可口</p>', '/product_detail/6170.jpg', 2, 1, 1, '审核通过', '2026-08-29 11:00:00', '2026-08-29 10:30:00', '2026-08-29 10:30:00', 0);
INSERT INTO `product` VALUES (6171, 5016, 2012, '飞天茅台53度500ml', '酱香经典', 'product/6171.jpg', '<p>茅台飞天53度，国酒经典，酱香浓郁</p>', '/product_detail/6171.jpg', 2, 1, 1, '审核通过', '2026-08-30 10:00:00', '2026-08-30 09:00:00', '2026-08-30 09:00:00', 0);
INSERT INTO `product` VALUES (6172, 5016, 2012, '五粮液52度500ml', '浓香典范', 'product/6172.jpg', '<p>五粮液52度，浓香典范，品质保证</p>', '/product_detail/6172.jpg', 2, 1, 1, '审核通过', '2026-08-30 11:00:00', '2026-08-30 10:30:00', '2026-08-30 10:30:00', 0);
INSERT INTO `product` VALUES (6173, 5032, 2013, '玫瑰鲜花束11朵', '浪漫表白', 'product/6173.jpg', '<p>精选红玫瑰11朵，浪漫表白首选</p>', '/product_detail/6173.jpg', 2, 1, 1, '审核通过', '2026-08-31 10:00:00', '2026-08-31 09:00:00', '2026-08-31 09:00:00', 0);
INSERT INTO `product` VALUES (6174, 5032, 2013, '多肉植物组合6颗', '桌面绿植', 'product/6174.jpg', '<p>精选多肉植物组合，桌面绿植，净化空气</p>', '/product_detail/6174.jpg', 2, 1, 1, '审核通过', '2026-08-31 11:00:00', '2026-08-31 10:30:00', '2026-08-31 10:30:00', 0);
INSERT INTO `product` VALUES (6175, 5025, 2014, '美的空调1.5匹', '变频节能', 'product/6175.jpg', '<p>美的变频空调1.5匹，节能静音，舒适凉爽</p>', '/product_detail/6175.jpg', 3, 1, 1, '审核通过', '2026-09-01 10:00:00', '2026-09-01 09:00:00', '2026-09-01 09:00:00', 0);
INSERT INTO `product` VALUES (6176, 5025, 2014, '小米电视55英寸', '4K超清', 'product/6176.jpg', '<p>小米电视55英寸，4K超清，智能语音</p>', '/product_detail/6176.jpg', 3, 1, 1, '审核通过', '2026-09-01 11:00:00', '2026-09-01 10:30:00', '2026-09-01 10:30:00', 0);
INSERT INTO `product` VALUES (6177, 5001, 2015, '农夫山泉矿泉水550ml*24', '天然山泉', 'product/6177.jpg', '<p>农夫山泉天然矿泉水，24瓶整箱装</p>', '/product_detail/6177.jpg', 2, 1, 1, '审核通过', '2026-09-02 10:00:00', '2026-09-02 09:00:00', '2026-09-02 09:00:00', 0);
INSERT INTO `product` VALUES (6178, 5003, 2015, '康师傅方便面5连包', '红烧牛肉', 'product/6178.jpg', '<p>康师傅红烧牛肉面，5连包，方便快捷</p>', '/product_detail/6178.jpg', 2, 1, 1, '审核通过', '2026-09-02 11:00:00', '2026-09-02 10:30:00', '2026-09-02 10:30:00', 0);
INSERT INTO `product` VALUES (6179, 5019, 2016, '普洱茶饼357g', '勐海熟茶', 'product/6179.jpg', '<p>普洱熟茶勐海味，陈香醇厚，暖胃养生</p>', '/product_detail/6179.jpg', 2, 1, 1, '审核通过', '2026-09-03 10:00:00', '2026-09-03 09:00:00', '2026-09-03 09:00:00', 0);
INSERT INTO `product` VALUES (6180, 5019, 2016, '陶瓷茶具套装', '功夫茶具', 'product/6180.jpg', '<p>精美陶瓷功夫茶具套装，品茶必备</p>', '/product_detail/6180.jpg', 2, 1, 1, '审核通过', '2026-09-03 11:00:00', '2026-09-03 10:30:00', '2026-09-03 10:30:00', 0);
INSERT INTO `product` VALUES (6181, 5024, 2017, '红木餐桌1.5米', '紫檀木', 'product/6181.jpg', '<p>紫檀木红木餐桌1.5米，古典工艺，品质传承</p>', '/product_detail/6181.jpg', 3, 1, 1, '审核通过', '2026-09-04 10:00:00', '2026-09-04 09:00:00', '2026-09-04 09:00:00', 0);
INSERT INTO `product` VALUES (6182, 5024, 2017, '红木沙发三件套', '黄花梨', 'product/6182.jpg', '<p>黄花梨红木沙发三件套，中式风格，典雅大气</p>', '/product_detail/6182.jpg', 3, 1, 1, '审核通过', '2026-09-04 11:00:00', '2026-09-04 10:30:00', '2026-09-04 10:30:00', 0);
INSERT INTO `product` VALUES (6183, 5025, 2018, 'iPhone 15 Pro 256G', '旗舰手机', 'product/6183.jpg', '<p>iPhone 15 Pro 256G，A17芯片，钛金属设计</p>', '/product_detail/6183.jpg', 3, 1, 1, '审核通过', '2026-09-05 10:00:00', '2026-09-05 09:00:00', '2026-09-05 09:00:00', 0);
INSERT INTO `product` VALUES (6184, 5025, 2018, 'MacBook Air M3', '轻薄便携', 'product/6184.jpg', '<p>MacBook Air M3，轻薄便携，强劲性能</p>', '/product_detail/6184.jpg', 3, 1, 1, '审核通过', '2026-09-05 11:00:00', '2026-09-05 10:30:00', '2026-09-05 10:30:00', 0);
INSERT INTO `product` VALUES (6185, 5019, 2019, '铁观音礼盒装250g', '清香型', 'product/6185.jpg', '<p>铁观音清香型礼盒装，香气高扬，回甘持久</p>', '/product_detail/6185.jpg', 2, 1, 1, '审核通过', '2026-09-06 10:00:00', '2026-09-06 09:00:00', '2026-09-06 09:00:00', 0);
INSERT INTO `product` VALUES (6186, 5019, 2019, '龙井茶叶250g', '明前特级', 'product/6186.jpg', '<p>西湖龙井明前特级，清香甘醇，名茶之首</p>', '/product_detail/6186.jpg', 2, 1, 1, '审核通过', '2026-09-06 11:00:00', '2026-09-06 10:30:00', '2026-09-06 10:30:00', 0);
INSERT INTO `product` VALUES (6187, 5024, 2020, '丝绸旗袍', '真丝面料', 'product/6187.jpg', '<p>100%真丝面料旗袍，传统工艺，优雅大方</p>', '/product_detail/6187.jpg', 2, 1, 1, '审核通过', '2026-09-07 10:00:00', '2026-09-07 09:00:00', '2026-09-07 09:00:00', 0);
INSERT INTO `product` VALUES (6188, 5024, 2020, '丝绸床单四件套', '桑蚕丝', 'product/6188.jpg', '<p>100%桑蚕丝床单四件套，亲肤舒适，奢华享受</p>', '/product_detail/6188.jpg', 2, 1, 1, '审核通过', '2026-09-07 11:00:00', '2026-09-07 10:30:00', '2026-09-07 10:30:00', 0);
INSERT INTO `product` VALUES (6189, 5014, 2021, '招牌红烧肉', '秘制配方', 'product/6189.jpg', '<p>秘制配方招牌红烧肉，肥而不腻，入口即化</p>', '/product_detail/6189.jpg', 2, 1, 1, '审核通过', '2026-09-08 10:00:00', '2026-09-08 09:00:00', '2026-09-08 09:00:00', 0);
INSERT INTO `product` VALUES (6190, 5014, 2021, '海鲜炒饭', '新鲜食材', 'product/6190.jpg', '<p>新鲜海鲜炒饭，粒粒分明，鲜香可口</p>', '/product_detail/6190.jpg', 2, 1, 1, '审核通过', '2026-09-08 11:00:00', '2026-09-08 10:30:00', '2026-09-08 10:30:00', 0);
INSERT INTO `product` VALUES (6191, 5039, 2022, '品牌羽绒服', '90%白鸭绒', 'product/6191.jpg', '<p>90%白鸭绒品牌羽绒服，保暖轻盈，时尚百搭</p>', '/product_detail/6191.jpg', 2, 1, 1, '审核通过', '2026-09-09 10:00:00', '2026-09-09 09:00:00', '2026-09-09 09:00:00', 0);
INSERT INTO `product` VALUES (6192, 5039, 2022, '羊毛大衣', '100%羊毛', 'product/6192.jpg', '<p>100%羊毛大衣，经典版型，气质优雅</p>', '/product_detail/6192.jpg', 2, 1, 1, '审核通过', '2026-09-09 11:00:00', '2026-09-09 10:30:00', '2026-09-09 10:30:00', 0);
INSERT INTO `product` VALUES (6193, 5002, 2023, '畅销小说套装', '经典文学', 'product/6193.jpg', '<p>经典文学畅销小说套装，提升阅读体验</p>', '/product_detail/6193.jpg', 2, 1, 1, '审核通过', '2026-09-10 10:00:00', '2026-09-10 09:00:00', '2026-09-10 09:00:00', 0);
INSERT INTO `product` VALUES (6194, 5026, 2023, '钢笔礼盒套装', '商务办公', 'product/6194.jpg', '<p>高档钢笔礼盒套装，商务办公必备</p>', '/product_detail/6194.jpg', 2, 1, 1, '审核通过', '2026-09-10 11:00:00', '2026-09-10 10:30:00', '2026-09-10 10:30:00', 0);
INSERT INTO `product` VALUES (6195, 5015, 2024, '波士顿龙虾2斤', '进口鲜活', 'product/6195.jpg', '<p>进口波士顿龙虾2斤，鲜活直供，肉质饱满</p>', '/product_detail/6195.jpg', 2, 1, 1, '审核通过', '2026-09-11 10:00:00', '2026-09-11 09:00:00', '2026-09-11 09:00:00', 0);
INSERT INTO `product` VALUES (6196, 5015, 2024, '三文鱼刺身1斤', '挪威进口', 'product/6196.jpg', '<p>挪威进口三文鱼刺身，新鲜直达，肉质鲜嫩</p>', '/product_detail/6196.jpg', 2, 1, 1, '审核通过', '2026-09-11 11:00:00', '2026-09-11 10:30:00', '2026-09-11 10:30:00', 0);
INSERT INTO `product` VALUES (6197, 5020, 2025, '黄金项链20克', '足金999', 'product/6197.jpg', '<p>足金999黄金项链20克，精致工艺，保值收藏</p>', '/product_detail/6197.jpg', 2, 1, 1, '审核通过', '2026-09-12 10:00:00', '2026-09-12 09:00:00', '2026-09-12 09:00:00', 0);
INSERT INTO `product` VALUES (6198, 5020, 2025, '钻石戒指1克拉', 'VVS级', 'product/6198.jpg', '<p>VVS级钻石戒指1克拉，璀璨闪耀，永恒之选</p>', '/product_detail/6198.jpg', 2, 1, 1, '审核通过', '2026-09-12 11:00:00', '2026-09-12 10:30:00', '2026-09-12 10:30:00', 0);

-- ----------------------------
-- Table structure for product_category_relation
-- ----------------------------
DROP TABLE IF EXISTS `product_category_relation`;
CREATE TABLE `product_category_relation`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '记录ID（主键）',
  `product_id` bigint NULL DEFAULT NULL COMMENT '商品ID',
  `category_id` bigint NULL DEFAULT NULL COMMENT '分类ID',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_pcr_product`(`product_id` ASC) USING BTREE,
  INDEX `fk_pcr_category`(`category_id` ASC) USING BTREE,
  CONSTRAINT `fk_pcr_category` FOREIGN KEY (`category_id`) REFERENCES `category` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_pcr_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 199 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '商品分类中间表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of product_category_relation
-- ----------------------------
INSERT INTO `product_category_relation` VALUES (1, 6001, 201);
INSERT INTO `product_category_relation` VALUES (2, 6002, 201);
INSERT INTO `product_category_relation` VALUES (3, 6003, 201);
INSERT INTO `product_category_relation` VALUES (4, 6004, 201);
INSERT INTO `product_category_relation` VALUES (5, 6005, 201);
INSERT INTO `product_category_relation` VALUES (6, 6006, 201);
INSERT INTO `product_category_relation` VALUES (7, 6007, 201);
INSERT INTO `product_category_relation` VALUES (8, 6008, 201);
INSERT INTO `product_category_relation` VALUES (9, 6009, 101);
INSERT INTO `product_category_relation` VALUES (10, 6010, 101);
INSERT INTO `product_category_relation` VALUES (11, 6011, 101);
INSERT INTO `product_category_relation` VALUES (12, 6012, 201);
INSERT INTO `product_category_relation` VALUES (13, 6013, 202);
INSERT INTO `product_category_relation` VALUES (14, 6014, 202);
INSERT INTO `product_category_relation` VALUES (15, 6015, 202);
INSERT INTO `product_category_relation` VALUES (16, 6016, 202);
INSERT INTO `product_category_relation` VALUES (17, 6017, 107);
INSERT INTO `product_category_relation` VALUES (18, 6018, 107);
INSERT INTO `product_category_relation` VALUES (19, 6019, 201);
INSERT INTO `product_category_relation` VALUES (20, 6020, 107);
INSERT INTO `product_category_relation` VALUES (21, 6021, 203);
INSERT INTO `product_category_relation` VALUES (22, 6022, 203);
INSERT INTO `product_category_relation` VALUES (23, 6023, 203);
INSERT INTO `product_category_relation` VALUES (24, 6024, 203);
INSERT INTO `product_category_relation` VALUES (25, 6025, 101);
INSERT INTO `product_category_relation` VALUES (26, 6026, 101);
INSERT INTO `product_category_relation` VALUES (27, 6027, 101);
INSERT INTO `product_category_relation` VALUES (28, 6028, 101);
INSERT INTO `product_category_relation` VALUES (29, 6029, 102);
INSERT INTO `product_category_relation` VALUES (30, 6030, 102);
INSERT INTO `product_category_relation` VALUES (31, 6031, 102);
INSERT INTO `product_category_relation` VALUES (32, 6032, 102);
INSERT INTO `product_category_relation` VALUES (33, 6033, 102);
INSERT INTO `product_category_relation` VALUES (34, 6034, 102);
INSERT INTO `product_category_relation` VALUES (35, 6035, 103);
INSERT INTO `product_category_relation` VALUES (36, 6036, 103);
INSERT INTO `product_category_relation` VALUES (37, 6037, 103);
INSERT INTO `product_category_relation` VALUES (38, 6038, 103);
INSERT INTO `product_category_relation` VALUES (39, 6039, 103);
INSERT INTO `product_category_relation` VALUES (40, 6040, 103);
INSERT INTO `product_category_relation` VALUES (41, 6041, 104);
INSERT INTO `product_category_relation` VALUES (42, 6042, 104);
INSERT INTO `product_category_relation` VALUES (43, 6043, 104);
INSERT INTO `product_category_relation` VALUES (44, 6044, 104);
INSERT INTO `product_category_relation` VALUES (45, 6045, 104);
INSERT INTO `product_category_relation` VALUES (46, 6046, 104);
INSERT INTO `product_category_relation` VALUES (47, 6047, 105);
INSERT INTO `product_category_relation` VALUES (48, 6048, 105);
INSERT INTO `product_category_relation` VALUES (49, 6049, 105);
INSERT INTO `product_category_relation` VALUES (50, 6050, 105);
INSERT INTO `product_category_relation` VALUES (51, 6051, 105);
INSERT INTO `product_category_relation` VALUES (52, 6052, 106);
INSERT INTO `product_category_relation` VALUES (53, 6053, 106);
INSERT INTO `product_category_relation` VALUES (54, 6054, 106);
INSERT INTO `product_category_relation` VALUES (55, 6055, 106);
INSERT INTO `product_category_relation` VALUES (56, 6056, 106);
INSERT INTO `product_category_relation` VALUES (57, 6057, 107);
INSERT INTO `product_category_relation` VALUES (58, 6058, 107);
INSERT INTO `product_category_relation` VALUES (59, 6059, 108);
INSERT INTO `product_category_relation` VALUES (60, 6060, 108);
INSERT INTO `product_category_relation` VALUES (61, 6061, 108);
INSERT INTO `product_category_relation` VALUES (62, 6062, 108);
INSERT INTO `product_category_relation` VALUES (63, 6063, 108);
INSERT INTO `product_category_relation` VALUES (64, 6064, 202);
INSERT INTO `product_category_relation` VALUES (65, 6065, 202);
INSERT INTO `product_category_relation` VALUES (66, 6066, 202);
INSERT INTO `product_category_relation` VALUES (67, 6067, 203);
INSERT INTO `product_category_relation` VALUES (68, 6068, 203);
INSERT INTO `product_category_relation` VALUES (69, 6069, 203);
INSERT INTO `product_category_relation` VALUES (70, 6070, 201);
INSERT INTO `product_category_relation` VALUES (71, 6071, 201);
INSERT INTO `product_category_relation` VALUES (72, 6072, 201);
INSERT INTO `product_category_relation` VALUES (73, 6073, 204);
INSERT INTO `product_category_relation` VALUES (74, 6074, 204);
INSERT INTO `product_category_relation` VALUES (75, 6075, 202);
INSERT INTO `product_category_relation` VALUES (76, 6076, 205);
INSERT INTO `product_category_relation` VALUES (77, 6077, 107);
INSERT INTO `product_category_relation` VALUES (78, 6078, 107);
INSERT INTO `product_category_relation` VALUES (79, 6079, 202);
INSERT INTO `product_category_relation` VALUES (80, 6080, 206);
INSERT INTO `product_category_relation` VALUES (81, 6081, 206);
INSERT INTO `product_category_relation` VALUES (82, 6082, 206);
INSERT INTO `product_category_relation` VALUES (83, 6083, 206);
INSERT INTO `product_category_relation` VALUES (84, 6084, 206);
INSERT INTO `product_category_relation` VALUES (85, 6085, 207);
INSERT INTO `product_category_relation` VALUES (86, 6086, 207);
INSERT INTO `product_category_relation` VALUES (87, 6087, 207);
INSERT INTO `product_category_relation` VALUES (88, 6088, 207);
INSERT INTO `product_category_relation` VALUES (89, 6089, 207);
INSERT INTO `product_category_relation` VALUES (90, 6090, 208);
INSERT INTO `product_category_relation` VALUES (91, 6091, 208);
INSERT INTO `product_category_relation` VALUES (92, 6092, 208);
INSERT INTO `product_category_relation` VALUES (93, 6093, 101);
INSERT INTO `product_category_relation` VALUES (94, 6094, 104);
INSERT INTO `product_category_relation` VALUES (95, 6095, 301);
INSERT INTO `product_category_relation` VALUES (96, 6096, 301);
INSERT INTO `product_category_relation` VALUES (97, 6097, 301);
INSERT INTO `product_category_relation` VALUES (98, 6098, 301);
INSERT INTO `product_category_relation` VALUES (99, 6099, 301);
INSERT INTO `product_category_relation` VALUES (100, 6100, 302);
INSERT INTO `product_category_relation` VALUES (101, 6101, 302);
INSERT INTO `product_category_relation` VALUES (102, 6102, 302);
INSERT INTO `product_category_relation` VALUES (103, 6103, 302);
INSERT INTO `product_category_relation` VALUES (104, 6104, 302);
INSERT INTO `product_category_relation` VALUES (105, 6105, 303);
INSERT INTO `product_category_relation` VALUES (106, 6106, 303);
INSERT INTO `product_category_relation` VALUES (107, 6107, 303);
INSERT INTO `product_category_relation` VALUES (108, 6108, 303);
INSERT INTO `product_category_relation` VALUES (109, 6109, 304);
INSERT INTO `product_category_relation` VALUES (110, 6110, 304);
INSERT INTO `product_category_relation` VALUES (111, 6111, 304);
INSERT INTO `product_category_relation` VALUES (112, 6112, 304);
INSERT INTO `product_category_relation` VALUES (113, 6113, 305);
INSERT INTO `product_category_relation` VALUES (114, 6114, 305);
INSERT INTO `product_category_relation` VALUES (115, 6115, 305);
INSERT INTO `product_category_relation` VALUES (116, 6116, 306);
INSERT INTO `product_category_relation` VALUES (117, 6117, 306);
INSERT INTO `product_category_relation` VALUES (118, 6118, 306);
INSERT INTO `product_category_relation` VALUES (119, 6119, 307);
INSERT INTO `product_category_relation` VALUES (120, 6120, 307);
INSERT INTO `product_category_relation` VALUES (121, 6121, 307);
INSERT INTO `product_category_relation` VALUES (122, 6122, 308);
INSERT INTO `product_category_relation` VALUES (123, 6123, 308);
INSERT INTO `product_category_relation` VALUES (124, 6124, 308);
INSERT INTO `product_category_relation` VALUES (125, 6125, 309);
INSERT INTO `product_category_relation` VALUES (126, 6126, 309);
INSERT INTO `product_category_relation` VALUES (127, 6127, 309);
INSERT INTO `product_category_relation` VALUES (128, 6128, 401);
INSERT INTO `product_category_relation` VALUES (129, 6129, 401);
INSERT INTO `product_category_relation` VALUES (130, 6130, 401);
INSERT INTO `product_category_relation` VALUES (131, 6131, 402);
INSERT INTO `product_category_relation` VALUES (132, 6132, 402);
INSERT INTO `product_category_relation` VALUES (133, 6133, 402);
INSERT INTO `product_category_relation` VALUES (134, 6134, 403);
INSERT INTO `product_category_relation` VALUES (135, 6135, 403);
INSERT INTO `product_category_relation` VALUES (136, 6136, 404);
INSERT INTO `product_category_relation` VALUES (137, 6137, 404);
INSERT INTO `product_category_relation` VALUES (138, 6138, 405);
INSERT INTO `product_category_relation` VALUES (139, 6139, 405);
INSERT INTO `product_category_relation` VALUES (140, 6140, 405);
INSERT INTO `product_category_relation` VALUES (141, 6141, 501);
INSERT INTO `product_category_relation` VALUES (142, 6142, 501);
INSERT INTO `product_category_relation` VALUES (143, 6143, 501);
INSERT INTO `product_category_relation` VALUES (144, 6144, 502);
INSERT INTO `product_category_relation` VALUES (145, 6145, 502);
INSERT INTO `product_category_relation` VALUES (146, 6146, 503);
INSERT INTO `product_category_relation` VALUES (147, 6147, 503);
INSERT INTO `product_category_relation` VALUES (148, 6148, 504);
INSERT INTO `product_category_relation` VALUES (149, 6149, 504);
INSERT INTO `product_category_relation` VALUES (150, 6150, 505);
INSERT INTO `product_category_relation` VALUES (151, 6151, 506);
INSERT INTO `product_category_relation` VALUES (152, 6152, 506);
INSERT INTO `product_category_relation` VALUES (153, 6153, 601);
INSERT INTO `product_category_relation` VALUES (154, 6154, 601);
INSERT INTO `product_category_relation` VALUES (155, 6155, 602);
INSERT INTO `product_category_relation` VALUES (156, 6156, 602);
INSERT INTO `product_category_relation` VALUES (157, 6157, 603);
INSERT INTO `product_category_relation` VALUES (158, 6158, 603);
INSERT INTO `product_category_relation` VALUES (159, 6159, 604);
INSERT INTO `product_category_relation` VALUES (160, 6160, 604);
INSERT INTO `product_category_relation` VALUES (161, 6161, 605);
INSERT INTO `product_category_relation` VALUES (162, 6162, 605);
INSERT INTO `product_category_relation` VALUES (163, 6163, 606);
INSERT INTO `product_category_relation` VALUES (164, 6164, 606);
INSERT INTO `product_category_relation` VALUES (165, 6165, 607);
INSERT INTO `product_category_relation` VALUES (166, 6166, 607);
INSERT INTO `product_category_relation` VALUES (167, 6167, 608);
INSERT INTO `product_category_relation` VALUES (168, 6168, 608);
INSERT INTO `product_category_relation` VALUES (169, 6169, 103);
INSERT INTO `product_category_relation` VALUES (170, 6170, 104);
INSERT INTO `product_category_relation` VALUES (171, 6171, 204);
INSERT INTO `product_category_relation` VALUES (172, 6172, 204);
INSERT INTO `product_category_relation` VALUES (173, 6173, 308);
INSERT INTO `product_category_relation` VALUES (174, 6174, 308);
INSERT INTO `product_category_relation` VALUES (175, 6175, 302);
INSERT INTO `product_category_relation` VALUES (176, 6176, 302);
INSERT INTO `product_category_relation` VALUES (177, 6177, 203);
INSERT INTO `product_category_relation` VALUES (178, 6178, 201);
INSERT INTO `product_category_relation` VALUES (179, 6179, 206);
INSERT INTO `product_category_relation` VALUES (180, 6180, 403);
INSERT INTO `product_category_relation` VALUES (181, 6181, 301);
INSERT INTO `product_category_relation` VALUES (182, 6182, 301);
INSERT INTO `product_category_relation` VALUES (183, 6183, 302);
INSERT INTO `product_category_relation` VALUES (184, 6184, 302);
INSERT INTO `product_category_relation` VALUES (185, 6185, 206);
INSERT INTO `product_category_relation` VALUES (186, 6186, 206);
INSERT INTO `product_category_relation` VALUES (187, 6187, 301);
INSERT INTO `product_category_relation` VALUES (188, 6188, 301);
INSERT INTO `product_category_relation` VALUES (189, 6189, 107);
INSERT INTO `product_category_relation` VALUES (190, 6190, 107);
INSERT INTO `product_category_relation` VALUES (191, 6191, 506);
INSERT INTO `product_category_relation` VALUES (192, 6192, 506);
INSERT INTO `product_category_relation` VALUES (193, 6193, 201);
INSERT INTO `product_category_relation` VALUES (194, 6194, 403);
INSERT INTO `product_category_relation` VALUES (195, 6195, 104);
INSERT INTO `product_category_relation` VALUES (196, 6196, 104);
INSERT INTO `product_category_relation` VALUES (197, 6197, 207);
INSERT INTO `product_category_relation` VALUES (198, 6198, 207);

-- ----------------------------
-- Table structure for product_comment
-- ----------------------------
DROP TABLE IF EXISTS `product_comment`;
CREATE TABLE `product_comment`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '评价ID（主键）',
  `order_item_id` bigint NULL DEFAULT NULL COMMENT '订单明细ID',
  `product_id` bigint NULL DEFAULT NULL COMMENT '商品ID',
  `user_id` bigint NULL DEFAULT NULL COMMENT '用户ID',
  `score` tinyint NULL DEFAULT NULL COMMENT '评分（1~5分）',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '评价内容',
  `images` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '评价图片',
  `anonymous` tinyint NULL DEFAULT NULL COMMENT '是否匿名',
  `create_time` datetime NULL DEFAULT NULL COMMENT '评价时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_product_comment_order_item`(`order_item_id` ASC) USING BTREE,
  INDEX `fk_product_comment_product`(`product_id` ASC) USING BTREE,
  INDEX `fk_product_comment_user`(`user_id` ASC) USING BTREE,
  CONSTRAINT `fk_product_comment_order_item` FOREIGN KEY (`order_item_id`) REFERENCES `order_item` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_product_comment_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_product_comment_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '商品评价表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of product_comment
-- ----------------------------

-- ----------------------------
-- Table structure for recommendation_log
-- ----------------------------
DROP TABLE IF EXISTS `recommendation_log`;
CREATE TABLE `recommendation_log`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '推荐流水ID（主键）',
  `user_id` bigint NULL DEFAULT NULL COMMENT '推荐目标触达用户ID',
  `scene` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '算法展示前台场景栏位',
  `recommended_product_ids` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '下发推荐Spu集快照串',
  `feedback_type` tinyint NULL DEFAULT NULL COMMENT '实际漏斗闭环反馈效果',
  `log_time` datetime NULL DEFAULT NULL COMMENT '推荐曝光展示时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_recomm_user`(`user_id` ASC) USING BTREE,
  CONSTRAINT `fk_recomm_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '个性化算法推荐结果记录表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of recommendation_log
-- ----------------------------

-- ----------------------------
-- Table structure for seckill_activity
-- ----------------------------
DROP TABLE IF EXISTS `seckill_activity`;
CREATE TABLE `seckill_activity`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '活动ID（主键）',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '活动名称',
  `start_time` datetime NULL DEFAULT NULL COMMENT '开始时间',
  `end_time` datetime NULL DEFAULT NULL COMMENT '结束时间',
  `status` tinyint NULL DEFAULT NULL COMMENT '活动状态',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_seckill_activity_time`(`start_time` ASC, `end_time` ASC, `status` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '秒杀活动表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of seckill_activity
-- ----------------------------

-- ----------------------------
-- Table structure for seckill_product
-- ----------------------------
DROP TABLE IF EXISTS `seckill_product`;
CREATE TABLE `seckill_product`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '秒杀关联ID（主键）',
  `seckill_activity_id` bigint NULL DEFAULT NULL COMMENT '秒杀活动ID',
  `product_id` bigint NULL DEFAULT NULL COMMENT '商品SpuID',
  `sku_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '商品SKU码(支持字母数字-)',
  `seckill_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '秒杀专享价',
  `seckill_stock` int NULL DEFAULT NULL COMMENT '秒杀专享库存',
  `sold_count` int NOT NULL DEFAULT 0 COMMENT '已售数量',
  `limit_quantity` tinyint NULL DEFAULT NULL COMMENT '每人限购数量',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态：0禁用 1启用',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_seckill_activity_sku`(`seckill_activity_id` ASC, `sku_id` ASC) USING BTREE,
  INDEX `fk_seckill_act`(`seckill_activity_id` ASC) USING BTREE,
  INDEX `fk_seckill_product`(`product_id` ASC) USING BTREE,
  INDEX `idx_seckill_product_activity_status`(`seckill_activity_id` ASC, `status` ASC) USING BTREE,
  CONSTRAINT `fk_seckill_act` FOREIGN KEY (`seckill_activity_id`) REFERENCES `seckill_activity` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_seckill_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '秒杀商品表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of seckill_product
-- ----------------------------

-- ----------------------------
-- Table structure for share_log
-- ----------------------------
DROP TABLE IF EXISTS `share_log`;
CREATE TABLE `share_log`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志ID（主键）',
  `user_id` bigint NULL DEFAULT NULL COMMENT '分享人用户ID',
  `target_type` tinyint NULL DEFAULT NULL COMMENT '传播媒介类型（商品/活动）',
  `target_id` bigint NULL DEFAULT NULL COMMENT '关联媒介实体物理ID',
  `share_channel` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '触达渠道分发媒介',
  `share_time` datetime NULL DEFAULT NULL COMMENT '分享动作触发时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_share_user`(`user_id` ASC) USING BTREE,
  CONSTRAINT `fk_share_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '推广分享日志表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of share_log
-- ----------------------------

-- ----------------------------
-- Table structure for sku
-- ----------------------------
DROP TABLE IF EXISTS `sku`;
CREATE TABLE `sku`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'SkuID（主键）',
  `product_id` bigint NULL DEFAULT NULL COMMENT '商品ID',
  `specs` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '规格属性(JSON格式)',
  `price` decimal(10, 2) NULL DEFAULT NULL COMMENT '销售价格',
  `stock` int NULL DEFAULT NULL COMMENT '物理库存',
  `sku_code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'SKU编码',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_sku_product`(`product_id` ASC) USING BTREE,
  CONSTRAINT `fk_sku_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 8199 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '商品规格库存表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sku
-- ----------------------------
INSERT INTO `sku` VALUES (8001, 6001, '{\"规格\":\"30包装\",\"净重\":\"600g-750g\"}', 77.00, 90, 'AKS-NUT-30B-750');
INSERT INTO `sku` VALUES (8002, 6002, '{\"规格\":\"1袋装\",\"净重\":\"200g\",\"口味\":\"卤香\"}', 26.00, 180, '\'LPPZ-CHICK-1B-200');
INSERT INTO `sku` VALUES (8003, 6003, '{\"规格\":\"1袋装\",\"净重\":\"500g\"}', 35.90, 150, 'BWW-MANGO-1B-500');
INSERT INTO `sku` VALUES (8004, 6004, '{\"规格\":\"1袋装\",\"净重\":\"520g\"}', 22.90, 220, 'WW-RICE-1B-520');
INSERT INTO `sku` VALUES (8005, 6005, '{\"规格\":\"10包装\",\"单包\":\"68g\"}', 19.90, 300, 'WL-LATIAO-10B-680');
INSERT INTO `sku` VALUES (8006, 6006, '{\"规格\":\"6枚盒装\",\"净重\":\"360g\"}', 35.00, 130, 'LPPZ-YOLK-6P-360');
INSERT INTO `sku` VALUES (8007, 6007, '{\"规格\":\"1盒装\",\"净重\":\"400g\"}', 24.90, 110, 'DIY-CAKE-1B-400');
INSERT INTO `sku` VALUES (8008, 6008, '{\"规格\":\"1袋装\",\"净重\":\"300g\"}', 27.90, 160, 'BWW-SNOW-1B-300');
INSERT INTO `sku` VALUES (8009, 6009, '{\"规格\":\"5斤装\",\"果径\":\"80-85mm\"}', 36.90, 200, 'AKS-APPLE-10J-85');
INSERT INTO `sku` VALUES (8010, 6010, '{\"规格\":\"8斤装\",\"果径\":\"75-80mm\"}', 49.90, 140, 'FJ-ORANGE-8J-75');
INSERT INTO `sku` VALUES (8011, 6011, '{\"规格\":\"12粒礼盒\",\"等级\":\"特级\"}', 118.00, 50, 'ZESP-KIWI-12P-S');
INSERT INTO `sku` VALUES (8012, 6012, '{\"规格\":\"30包装\",\"净重\":\"750g\"}', 85.00, 130, 'WL-NUT-30B-750');
INSERT INTO `sku` VALUES (8013, 6013, '{\"规格\":\"1袋装\",\"净重\":\"5000g\"}', 68.00, 80, 'JLY-RICE-1P-5000');
INSERT INTO `sku` VALUES (8014, 6014, '{\"规格\":\"1桶装\",\"容量\":\"1900ml\"}', 22.90, 160, 'HT-SAUCE-1T-1900');
INSERT INTO `sku` VALUES (8015, 6015, '{\"规格\":\"20包装\",\"单包\":\"80g\"}', 16.90, 300, 'FL-PICKLE-20B-1600');
INSERT INTO `sku` VALUES (8016, 6016, '{\"规格\":\"1袋装\",\"净重\":\"1000g\"}', 22.00, 120, 'HS-FOOD-1B-1000');
INSERT INTO `sku` VALUES (8017, 6017, '{\"规格\":\"1袋装\",\"净重\":\"210g\",\"口味\":\"山椒\"}', 18.90, 220, 'YY-CHICK-1B-210');
INSERT INTO `sku` VALUES (8018, 6018, '{\"规格\":\"1盒\",\"净重\":\"200g\",\"口味\":\"香辣\"}', 24.90, 140, 'JW-DUCK-1H-200');
INSERT INTO `sku` VALUES (8019, 6019, '{\"规格\":\"1袋装\",\"净重\":\"150g\"}', 29.90, 110, 'HD-BEEF-1B-150');
INSERT INTO `sku` VALUES (8020, 6020, '{\"规格\":\"1盒装\",\"净重\":\"300g\"}', 16.90, 170, 'LX-EGG-1H-300');
INSERT INTO `sku` VALUES (8021, 6021, '{\"规格\":\"15瓶装\",\"单瓶\":\"480ml\",\"口味\":\"白桃\"}', 65.00, 90, 'YQSL-DRINK-15B-7200');
INSERT INTO `sku` VALUES (8022, 6022, '{\"规格\":\"1瓶装\",\"容量\":\"900ml\"}', 19.90, 130, 'NFSQ-JUICE-1B-900');
INSERT INTO `sku` VALUES (8023, 6023, '{\"规格\":\"12盒装\",\"单盒\":\"200g\"}', 42.90, 100, 'MN-YOGURT-12B-2400');
INSERT INTO `sku` VALUES (8024, 6024, '{\"规格\":\"1瓶装\",\"容量\":\"1000ml\"}', 22.90, 150, 'XC-MANGOJUICE-1B-1000');
INSERT INTO `sku` VALUES (8025, 6025, '{\"规格\":\"2斤装\",\"等级\":\"JJ级\",\"果径\":\"28-30mm\"}', 128.00, 60, 'CL-CHERRY-2J-JJ');
INSERT INTO `sku` VALUES (8026, 6026, '{\"规格\":\"5斤装\",\"等级\":\"一级\"}', 59.90, 120, 'HN-MANGO-5J-1');
INSERT INTO `sku` VALUES (8027, 6027, '{\"规格\":\"3斤装\",\"等级\":\"特级\"}', 39.90, 150, 'XJ-GRAPE-3J-T');
INSERT INTO `sku` VALUES (8028, 6028, '{\"规格\":\"5斤装\",\"等级\":\"5A\"}', 68.00, 80, 'TH-MANGOSTEEN-5J-5A');
INSERT INTO `sku` VALUES (8029, 6029, '{\"规格\":\"3颗装\",\"净重\":\"600g\"}', 12.90, 200, 'YN-BABYCHINESE-3P-600');
INSERT INTO `sku` VALUES (8030, 6030, '{\"规格\":\"2颗装\",\"净重\":\"400g\"}', 15.90, 180, 'YJ-BROCCOLI-2P-400');
INSERT INTO `sku` VALUES (8031, 6031, '{\"规格\":\"1袋装\",\"净重\":\"500g\"}', 4.90, 300, 'SHQ-CABBAGE-1B-500');
INSERT INTO `sku` VALUES (8032, 6032, '{\"规格\":\"5斤装\",\"净重\":\"2500g\"}', 19.90, 150, 'XHS-TOMATO-5J-2500');
INSERT INTO `sku` VALUES (8033, 6033, '{\"规格\":\"2颗装\",\"净重\":\"600g\"}', 8.90, 220, 'ZG-CABBAGE-2P-600');
INSERT INTO `sku` VALUES (8034, 6034, '{\"规格\":\"3斤装\",\"净重\":\"1500g\"}', 12.90, 180, 'SD-ONION-3J-1500');
INSERT INTO `sku` VALUES (8035, 6035, '{\"规格\":\"1袋装\",\"净重\":\"500g\"}', 28.90, 100, 'HZ-PORK-1B-500');
INSERT INTO `sku` VALUES (8036, 6036, '{\"规格\":\"1袋装\",\"净重\":\"1000g\"}', 68.00, 60, 'AUS-BEEF-1B-1000');
INSERT INTO `sku` VALUES (8037, 6037, '{\"规格\":\"1袋装\",\"净重\":\"1500g\"}', 78.00, 50, 'NM-LAMB-1B-1500');
INSERT INTO `sku` VALUES (8038, 6038, '{\"规格\":\"1袋装\",\"净重\":\"500g\"}', 32.90, 90, 'ZL-PORK-1B-500');
INSERT INTO `sku` VALUES (8039, 6039, '{\"规格\":\"1盒装\",\"净重\":\"500g\"}', 35.90, 80, 'BEEF-ROLL-1H-500');
INSERT INTO `sku` VALUES (8040, 6040, '{\"规格\":\"1袋装\",\"净重\":\"500g\"}', 25.90, 120, 'PIG-FEET-1B-500');
INSERT INTO `sku` VALUES (8041, 6041, '{\"规格\":\"1袋装\",\"净重\":\"400g\"}', 45.90, 70, 'ECU-SHRIMP-1B-400');
INSERT INTO `sku` VALUES (8042, 6042, '{\"规格\":\"1袋装\",\"净重\":\"500g\"}', 88.00, 40, 'NW-SALMON-1B-500');
INSERT INTO `sku` VALUES (8043, 6043, '{\"规格\":\"4只装\",\"净重\":\"800g\"}', 198.00, 30, 'YCH-CRAB-4P-800');
INSERT INTO `sku` VALUES (8044, 6044, '{\"规格\":\"4只装\",\"净重\":\"400g\"}', 68.00, 50, 'ABALONE-4P-400');
INSERT INTO `sku` VALUES (8045, 6045, '{\"规格\":\"1袋装\",\"净重\":\"500g\"}', 28.90, 100, 'SCALLOP-1B-500');
INSERT INTO `sku` VALUES (8046, 6046, '{\"规格\":\"1袋装\",\"净重\":\"500g\"}', 15.90, 150, 'CLAM-1B-500');
INSERT INTO `sku` VALUES (8047, 6047, '{\"规格\":\"1只装\",\"净重\":\"1500g\"}', 58.00, 60, 'TJ-CHICKEN-1P-1500');
INSERT INTO `sku` VALUES (8048, 6048, '{\"规格\":\"30枚装\",\"净重\":\"1800g\"}', 28.90, 100, 'TJ-EGG-30P-1800');
INSERT INTO `sku` VALUES (8049, 6049, '{\"规格\":\"1只装\",\"净重\":\"2000g\"}', 68.00, 50, 'TJ-DUCK-1P-2000');
INSERT INTO `sku` VALUES (8050, 6050, '{\"规格\":\"1袋装\",\"净重\":\"200g\"}', 12.90, 180, 'QUAIL-EGG-1B-200');
INSERT INTO `sku` VALUES (8051, 6051, '{\"规格\":\"1只装\",\"净重\":\"500g\"}', 48.00, 40, 'TJ-PIGEON-1P-500');
INSERT INTO `sku` VALUES (8052, 6052, '{\"规格\":\"1袋装\",\"净重\":\"500g\"}', 25.90, 120, 'WZ-DUMPLING-1B-500');
INSERT INTO `sku` VALUES (8053, 6053, '{\"规格\":\"1袋装\",\"净重\":\"400g\"}', 18.90, 150, 'SN-TANGYUAN-1B-400');
INSERT INTO `sku` VALUES (8054, 6054, '{\"规格\":\"1袋装\",\"净重\":\"500g\"}', 22.90, 130, 'ZD-CHICKEN-1B-500');
INSERT INTO `sku` VALUES (8055, 6055, '{\"规格\":\"10只装\",\"净重\":\"500g\"}', 28.90, 100, 'SD-BUN-10P-500');
INSERT INTO `sku` VALUES (8056, 6056, '{\"规格\":\"10片装\",\"净重\":\"400g\"}', 18.90, 160, 'SZB-PANCAKE-10P-400');
INSERT INTO `sku` VALUES (8057, 6057, '{\"规格\":\"1盒\",\"净重\":\"300g\"}', 29.90, 100, 'ZHY-DUCK-1H-300');
INSERT INTO `sku` VALUES (8058, 6058, '{\"规格\":\"2只装\",\"净重\":\"400g\"}', 38.00, 80, 'CD-RABBIT-2P-400');
INSERT INTO `sku` VALUES (8059, 6059, '{\"规格\":\"1杯\",\"净重\":\"81g\"}', 35.00, 60, 'HDZS-ICE-1C-81');
INSERT INTO `sku` VALUES (8060, 6060, '{\"规格\":\"1盒\",\"容量\":\"500ml\"}', 28.00, 80, 'BX-ICE-1H-500');
INSERT INTO `sku` VALUES (8061, 6061, '{\"规格\":\"1块\",\"净重\":\"200g\"}', 38.00, 50, 'TLMS-CAKE-1P-200');
INSERT INTO `sku` VALUES (8062, 6062, '{\"规格\":\"4个装\",\"净重\":\"400g\"}', 45.00, 60, 'MANGO-PANCAKE-4P-400');
INSERT INTO `sku` VALUES (8063, 6063, '{\"规格\":\"1杯\",\"容量\":\"300ml\"}', 22.00, 100, 'YZML-DRINK-1C-300');
INSERT INTO `sku` VALUES (8064, 6064, '{\"规格\":\"1桶装\",\"容量\":\"5000ml\"}', 98.00, 40, 'LH-OIL-1T-5000');
INSERT INTO `sku` VALUES (8065, 6065, '{\"规格\":\"1瓶装\",\"净重\":\"280g\"}', 12.90, 200, 'LGM-SAUCE-1B-280');
INSERT INTO `sku` VALUES (8066, 6066, '{\"规格\":\"1袋装\",\"净重\":\"2500g\"}', 28.90, 80, 'DB-MILLET-1B-2500');
INSERT INTO `sku` VALUES (8067, 6067, '{\"规格\":\"6瓶装\",\"单瓶\":\"500ml\"}', 45.00, 70, 'QD-BEER-6B-3000');
INSERT INTO `sku` VALUES (8068, 6068, '{\"规格\":\"48杯装\",\"单杯\":\"15g\"}', 68.00, 50, 'QC-COFFEE-48C-720');
INSERT INTO `sku` VALUES (8069, 6069, '{\"规格\":\"24盒装\",\"单盒\":\"250ml\"}', 68.00, 60, 'MN-MILK-24B-6000');
INSERT INTO `sku` VALUES (8070, 6070, '{\"规格\":\"30粒装\",\"净重\":\"300g\"}', 168.00, 30, 'FLR-CHOCOLATE-30P-300');
INSERT INTO `sku` VALUES (8071, 6071, '{\"规格\":\"1袋装\",\"净重\":\"100g\"}', 18.90, 120, 'MJ-CHOCOLATE-1B-100');
INSERT INTO `sku` VALUES (8072, 6072, '{\"规格\":\"1袋装\",\"净重\":\"192g\"}', 22.90, 100, 'LOTTE-BISCUIT-1B-192');
INSERT INTO `sku` VALUES (8073, 6073, '{\"规格\":\"1瓶装\",\"容量\":\"500ml\"}', 1499.00, 10, 'MT-WINE-1B-500');
INSERT INTO `sku` VALUES (8074, 6074, '{\"规格\":\"1瓶装\",\"容量\":\"750ml\"}', 298.00, 20, 'FR-WINE-1B-750');
INSERT INTO `sku` VALUES (8075, 6075, '{\"规格\":\"1盒装\",\"净重\":\"500g\"}', 68.00, 50, 'CQ-HOTPOT-1H-500');
INSERT INTO `sku` VALUES (8076, 6076, '{\"规格\":\"1盒\",\"净重\":\"300g\"}', 48.00, 60, 'YN-FLOWERCAKE-1H-300');
INSERT INTO `sku` VALUES (8077, 6077, '{\"规格\":\"1袋装\",\"净重\":\"500g\"}', 45.00, 80, 'SC-SAUSAGE-1B-500');
INSERT INTO `sku` VALUES (8078, 6078, '{\"规格\":\"1袋装\",\"净重\":\"500g\"}', 48.00, 70, 'HN-BACON-1B-500');
INSERT INTO `sku` VALUES (8079, 6079, '{\"规格\":\"1瓶装\",\"容量\":\"500ml\"}', 38.00, 80, 'SX-VINEGAR-1B-500');
INSERT INTO `sku` VALUES (8080, 6080, '{\"规格\":\"1袋装\",\"净重\":\"250g\"}', 128.00, 30, 'XH-LONGJING-1B-250');
INSERT INTO `sku` VALUES (8081, 6081, '{\"规格\":\"1袋装\",\"净重\":\"250g\"}', 88.00, 40, 'TGY-TIEGUANYIN-1B-250');
INSERT INTO `sku` VALUES (8082, 6082, '{\"规格\":\"1袋装\",\"净重\":\"100g\"}', 168.00, 20, 'DHP-DAHONGPAO-1B-100');
INSERT INTO `sku` VALUES (8083, 6083, '{\"规格\":\"100包\",\"净重\":\"200g\"}', 35.00, 100, 'LDT-TEA-100B-200');
INSERT INTO `sku` VALUES (8084, 6084, '{\"规格\":\"1饼\",\"净重\":\"357g\"}', 268.00, 20, 'PR-Tea-1P-357');
INSERT INTO `sku` VALUES (8085, 6085, '{\"规格\":\"1盒装\",\"净重\":\"250g\"}', 398.00, 20, 'TRT-EJIAO-1H-250');
INSERT INTO `sku` VALUES (8086, 6086, '{\"规格\":\"1罐\",\"净重\":\"450g\"}', 328.00, 30, 'TCBJ-PROTEIN-1G-450');
INSERT INTO `sku` VALUES (8087, 6087, '{\"规格\":\"1瓶装\",\"净重\":\"100g\"}', 168.00, 40, 'YXS-GINSENG-1B-100');
INSERT INTO `sku` VALUES (8088, 6088, '{\"规格\":\"1盒\",\"净重\":\"50g\"}', 888.00, 10, 'YANWO-BIRD-1H-50');
INSERT INTO `sku` VALUES (8089, 6089, '{\"规格\":\"1瓶装\",\"容量\":\"100粒\"}', 198.00, 40, 'TCBJ-FISH-OIL-1B-100');
INSERT INTO `sku` VALUES (8090, 6090, '{\"规格\":\"1盒\",\"净重\":\"800g\"}', 188.00, 30, 'ZY-MOONCAKE-1H-800');
INSERT INTO `sku` VALUES (8091, 6091, '{\"规格\":\"1盒\",\"净重\":\"1000g\"}', 168.00, 40, 'JS-NUT-1H-1000');
INSERT INTO `sku` VALUES (8092, 6092, '{\"规格\":\"1盒\",\"净重\":\"3000g\"}', 298.00, 20, 'NY-GRAIN-1H-3000');
INSERT INTO `sku` VALUES (8093, 6093, '{\"规格\":\"1盒\",\"净重\":\"2000g\"}', 198.00, 30, 'JK-FRUIT-1H-2000');
INSERT INTO `sku` VALUES (8094, 6094, '{\"规格\":\"1盒\",\"净重\":\"2500g\"}', 288.00, 20, 'HX-SEAFOOD-1H-2500');
INSERT INTO `sku` VALUES (8095, 6095, '{\"规格\":\"1套\",\"尺寸\":\"1.8m\"}', 398.00, 30, 'SXJF-BED-1S-180');
INSERT INTO `sku` VALUES (8096, 6096, '{\"规格\":\"3条装\",\"尺寸\":\"34cm*74cm\"}', 48.00, 100, 'CM-TOWEL-3P-2516');
INSERT INTO `sku` VALUES (8097, 6097, '{\"规格\":\"1床\",\"尺寸\":\"2.0m*2.3m\"}', 598.00, 20, 'CSB-QUILT-1B-200');
INSERT INTO `sku` VALUES (8098, 6098, '{\"规格\":\"1对\",\"尺寸\":\"48cm*74cm\"}', 168.00, 40, 'ZT-PILLOW-1P-3552');
INSERT INTO `sku` VALUES (8099, 6099, '{\"规格\":\"1条\",\"尺寸\":\"70cm*140cm\"}', 78.00, 80, 'CM-BATH-1P-9800');
INSERT INTO `sku` VALUES (8100, 6100, '{\"规格\":\"1个\",\"功率\":\"36W\"}', 198.00, 50, 'OP-CEILING-1P-36W');
INSERT INTO `sku` VALUES (8101, 6101, '{\"规格\":\"1个\",\"功率\":\"12W\"}', 88.00, 80, 'OP-DESK-1P-12W');
INSERT INTO `sku` VALUES (8102, 6102, '{\"规格\":\"1个\",\"功率\":\"24W\"}', 158.00, 60, 'OP-FLOOR-1P-24W');
INSERT INTO `sku` VALUES (8103, 6103, '{\"规格\":\"1个\",\"功率\":\"5W\"}', 38.00, 120, 'OP-NIGHT-1P-5W');
INSERT INTO `sku` VALUES (8104, 6104, '{\"规格\":\"1个\",\"功率\":\"24W\"}', 128.00, 70, 'OP-KITCHEN-1P-24W');
INSERT INTO `sku` VALUES (8105, 6105, '{\"规格\":\"5件套\",\"材质\":\"PP\"}', 88.00, 60, 'LLKK-BOX-5P-PP');
INSERT INTO `sku` VALUES (8106, 6106, '{\"规格\":\"1个\",\"尺寸\":\"45cm*35cm*30cm\"}', 45.00, 80, 'SNX-BOX-1P-4725');
INSERT INTO `sku` VALUES (8107, 6107, '{\"规格\":\"3件套\",\"尺寸\":\"25cm*18cm*8cm\"}', 28.00, 120, 'SNX-DRAWER-3P-3600');
INSERT INTO `sku` VALUES (8108, 6108, '{\"规格\":\"1个\",\"尺寸\":\"60cm*40cm*20cm\"}', 58.00, 70, 'SNX-CLOSET-1P-4800');
INSERT INTO `sku` VALUES (8109, 6109, '{\"规格\":\"1瓶装\",\"容量\":\"3000ml\"}', 45.00, 100, 'LYL-WASH-1B-3000');
INSERT INTO `sku` VALUES (8110, 6110, '{\"规格\":\"3包\",\"每包\":\"100抽\"}', 28.00, 120, 'WD-TISSUE-3P-300');
INSERT INTO `sku` VALUES (8111, 6111, '{\"规格\":\"1包\",\"每包\":\"100片\"}', 18.90, 150, 'XD-WIPE-1P-100');
INSERT INTO `sku` VALUES (8112, 6112, '{\"规格\":\"1瓶装\",\"容量\":\"500ml\"}', 12.90, 180, 'JCW-CLEAN-1B-500');
INSERT INTO `sku` VALUES (8113, 6113, '{\"规格\":\"1个\",\"尺寸\":\"44cm*36cm\"}', 88.00, 60, 'JP-TOILET-1P-1584');
INSERT INTO `sku` VALUES (8114, 6114, '{\"规格\":\"1套\",\"材质\":\"不锈钢\"}', 398.00, 30, 'JP-SHOWER-1S-SS');
INSERT INTO `sku` VALUES (8115, 6115, '{\"规格\":\"2个装\",\"材质\":\"塑料\"}', 18.90, 150, 'SKC-SET-2P-PP');
INSERT INTO `sku` VALUES (8116, 6116, '{\"规格\":\"1把\",\"尺寸\":\"105cm\"}', 58.00, 80, 'TT-UMBRELLA-1P-105');
INSERT INTO `sku` VALUES (8117, 6117, '{\"规格\":\"1件\",\"尺寸\":\"均码\"}', 68.00, 60, 'TT-RAINCOAT-1P-F');
INSERT INTO `sku` VALUES (8118, 6118, '{\"规格\":\"1件\",\"颜色\":\"白色\"}', 88.00, 70, 'TT-SUN-1P-W');
INSERT INTO `sku` VALUES (8119, 6119, '{\"规格\":\"1个\",\"材质\":\"不锈钢\"}', 68.00, 60, 'CHY-RACK-1P-SS');
INSERT INTO `sku` VALUES (8120, 6120, '{\"规格\":\"1个\",\"材质\":\"钢木\"}', 88.00, 50, 'CHY-IRONING-1P-WS');
INSERT INTO `sku` VALUES (8121, 6121, '{\"规格\":\"10个装\",\"材质\":\"塑料\"}', 12.90, 200, 'CHY-HANGER-10P-PP');
INSERT INTO `sku` VALUES (8122, 6122, '{\"规格\":\"1个\",\"材质\":\"陶瓷\"}', 68.00, 60, 'YK-VASE-1P-C');
INSERT INTO `sku` VALUES (8123, 6123, '{\"规格\":\"1束\",\"材质\":\"仿真\"}', 45.00, 80, 'FK-FLOWER-1B-F');
INSERT INTO `sku` VALUES (8124, 6124, '{\"规格\":\"1盆\",\"材质\":\"多肉\"}', 28.00, 100, 'DL-PLANT-1P-SUCC');
INSERT INTO `sku` VALUES (8125, 6125, '{\"规格\":\"1袋\",\"净重\":\"1500g\"}', 98.00, 50, 'HJ-CATFOOD-1B-1500');
INSERT INTO `sku` VALUES (8126, 6126, '{\"规格\":\"1袋\",\"净重\":\"1500g\"}', 98.00, 50, 'HJ-DOGFOOD-1B-1500');
INSERT INTO `sku` VALUES (8127, 6127, '{\"规格\":\"1袋\",\"净重\":\"10000g\"}', 58.00, 40, 'CATLITTER-1B-10000');
INSERT INTO `sku` VALUES (8128, 6128, '{\"规格\":\"1个\",\"尺寸\":\"32cm\"}', 298.00, 30, 'EBR-PAN-1P-32');
INSERT INTO `sku` VALUES (8129, 6129, '{\"规格\":\"1个\",\"容量\":\"5L\"}', 398.00, 25, 'EBR-PRESSURE-1P-5L');
INSERT INTO `sku` VALUES (8130, 6130, '{\"规格\":\"1个\",\"尺寸\":\"34cm\"}', 198.00, 40, 'EBR-WOK-1P-34');
INSERT INTO `sku` VALUES (8131, 6131, '{\"规格\":\"1把\",\"尺寸\":\"18cm\"}', 68.00, 60, 'ZXQ-KNIFE-1P-18');
INSERT INTO `sku` VALUES (8132, 6132, '{\"规格\":\"1把\",\"尺寸\":\"10cm\"}', 28.00, 100, 'ZXQ-SCISSORS-1P-10');
INSERT INTO `sku` VALUES (8133, 6133, '{\"规格\":\"1块\",\"尺寸\":\"38cm*26cm\"}', 48.00, 80, 'ZB-CHOPPING-1P-988');
INSERT INTO `sku` VALUES (8134, 6134, '{\"规格\":\"1个\",\"容量\":\"500ml\"}', 68.00, 70, 'FG-MUG-1P-500');
INSERT INTO `sku` VALUES (8135, 6135, '{\"规格\":\"1个\",\"容量\":\"350ml\"}', 38.00, 100, 'FG-GLASS-1P-350');
INSERT INTO `sku` VALUES (8136, 6136, '{\"规格\":\"4件套\",\"材质\":\"玻璃\"}', 128.00, 40, 'KN-BOWL-4P-GLASS');
INSERT INTO `sku` VALUES (8137, 6137, '{\"规格\":\"6件套\",\"材质\":\"陶瓷\"}', 168.00, 35, 'TC-DISH-6P-CER');
INSERT INTO `sku` VALUES (8138, 6138, '{\"规格\":\"1台\",\"容量\":\"1.2L\"}', 398.00, 25, 'JY-SOYMILK-1P-1200');
INSERT INTO `sku` VALUES (8139, 6139, '{\"规格\":\"1台\",\"容量\":\"4L\"}', 298.00, 30, 'JY-RICECOOKER-1P-4L');
INSERT INTO `sku` VALUES (8140, 6140, '{\"规格\":\"1个\",\"尺寸\":\"40cm*30cm*50cm\"}', 58.00, 60, 'KITCHEN-RACK-1P-6000');
INSERT INTO `sku` VALUES (8141, 6141, '{\"规格\":\"1支\",\"容量\":\"100ml\"}', 128.00, 50, 'OLAY-CLEANSER-1P-100');
INSERT INTO `sku` VALUES (8142, 6142, '{\"规格\":\"1瓶\",\"容量\":\"50ml\"}', 298.00, 40, 'OLAY-CREAM-1P-50');
INSERT INTO `sku` VALUES (8143, 6143, '{\"规格\":\"1瓶\",\"容量\":\"30ml\"}', 398.00, 30, 'OLAY-SERUM-1P-30');
INSERT INTO `sku` VALUES (8144, 6144, '{\"规格\":\"1瓶\",\"容量\":\"500ml\"}', 58.00, 80, 'DOVE-BATH-1B-500');
INSERT INTO `sku` VALUES (8145, 6145, '{\"规格\":\"1瓶\",\"容量\":\"200ml\"}', 48.00, 100, 'DOVE-BODY-1B-200');
INSERT INTO `sku` VALUES (8146, 6146, '{\"规格\":\"1瓶\",\"容量\":\"500ml\"}', 68.00, 80, 'PT-SHAMPOO-1B-500');
INSERT INTO `sku` VALUES (8147, 6147, '{\"规格\":\"1瓶\",\"容量\":\"300ml\"}', 58.00, 100, 'PT-CONDITIONER-1B-300');
INSERT INTO `sku` VALUES (8148, 6148, '{\"规格\":\"1支\",\"净重\":\"120g\"}', 28.00, 150, 'GLJ-TOOTHPASTE-1P-120');
INSERT INTO `sku` VALUES (8149, 6149, '{\"规格\":\"1个\",\"颜色\":\"白色\"}', 198.00, 40, 'DY-TOOTHBRUSH-1P-W');
INSERT INTO `sku` VALUES (8150, 6150, '{\"规格\":\"1包\",\"数量\":\"24片\"}', 35.00, 100, 'HSB-PAD-1P-24');
INSERT INTO `sku` VALUES (8151, 6151, '{\"规格\":\"1瓶\",\"容量\":\"50ml\"}', 998.00, 15, 'DIO-PERFUME-1B-50');
INSERT INTO `sku` VALUES (8152, 6152, '{\"规格\":\"1支\",\"颜色\":\"正红\"}', 128.00, 50, 'MBL-LIPSTICK-1P-R');
INSERT INTO `sku` VALUES (8153, 6153, '{\"规格\":\"1罐\",\"净重\":\"900g\"}', 398.00, 30, 'MZYM-MILK-3-1G-900');
INSERT INTO `sku` VALUES (8154, 6154, '{\"规格\":\"1罐\",\"净重\":\"900g\"}', 298.00, 40, 'MZYM-MILK-1-1G-900');
INSERT INTO `sku` VALUES (8155, 6155, '{\"规格\":\"1罐\",\"净重\":\"400g\"}', 88.00, 60, 'HS-RICE-1G-400');
INSERT INTO `sku` VALUES (8156, 6156, '{\"规格\":\"1袋\",\"净重\":\"100g\"}', 35.00, 100, 'HS-PUREE-1B-100');
INSERT INTO `sku` VALUES (8157, 6157, '{\"规格\":\"1包\",\"数量\":\"50片\"}', 88.00, 50, 'BBS-DIAPER-1P-50');
INSERT INTO `sku` VALUES (8158, 6158, '{\"规格\":\"1包\",\"数量\":\"80片\"}', 28.00, 120, 'BBS-WIPE-1P-80');
INSERT INTO `sku` VALUES (8159, 6159, '{\"规格\":\"1个\",\"容量\":\"240ml\"}', 68.00, 60, 'BQ-BOTTLE-1P-240');
INSERT INTO `sku` VALUES (8160, 6160, '{\"规格\":\"1个\",\"材质\":\"PP\"}', 38.00, 80, 'BQ-BOWL-1P-PP');
INSERT INTO `sku` VALUES (8161, 6161, '{\"规格\":\"1瓶\",\"容量\":\"200ml\"}', 48.00, 80, 'BB-BATH-1B-200');
INSERT INTO `sku` VALUES (8162, 6162, '{\"规格\":\"1瓶\",\"容量\":\"50g\"}', 58.00, 70, 'BB-CREAM-1B-50');
INSERT INTO `sku` VALUES (8163, 6163, '{\"规格\":\"1套\",\"尺码\":\"100\"}', 128.00, 50, 'TZ-SET-1S-100');
INSERT INTO `sku` VALUES (8164, 6164, '{\"规格\":\"1件\",\"尺码\":\"90\"}', 88.00, 70, 'YY-ONESIE-1P-90');
INSERT INTO `sku` VALUES (8165, 6165, '{\"规格\":\"1件\",\"尺码\":\"均码\"}', 168.00, 40, 'YF-DRESS-1P-F');
INSERT INTO `sku` VALUES (8166, 6166, '{\"规格\":\"1罐\",\"净重\":\"900g\"}', 198.00, 50, 'YF-MILK-1G-900');
INSERT INTO `sku` VALUES (8167, 6167, '{\"规格\":\"1辆\",\"颜色\":\"蓝色\"}', 598.00, 20, 'TC-STROLLER-1P-B');
INSERT INTO `sku` VALUES (8168, 6168, '{\"规格\":\"1个\",\"适用年龄\":\"0-4岁\"}', 998.00, 15, 'AQ-SEAT-1P-04');
INSERT INTO `sku` VALUES (8169, 6169, '{\"规格\":\"1份\",\"净重\":\"500g\"}', 35.00, 100, 'FRESH-PORK-1P-500');
INSERT INTO `sku` VALUES (8170, 6170, '{\"规格\":\"1份\",\"净重\":\"500g\"}', 68.00, 50, 'FRESH-SHRIMP-1P-500');
INSERT INTO `sku` VALUES (8171, 6171, '{\"规格\":\"1瓶\",\"容量\":\"500ml\"}', 1499.00, 10, 'MOUTAI-53-1B-500');
INSERT INTO `sku` VALUES (8172, 6172, '{\"规格\":\"1瓶\",\"容量\":\"500ml\"}', 599.00, 20, 'WULIANGYE-52-1B-500');
INSERT INTO `sku` VALUES (8173, 6173, '{\"规格\":\"1束\",\"数量\":\"11朵\"}', 168.00, 30, 'FLOWER-ROSE-1B-11');
INSERT INTO `sku` VALUES (8174, 6174, '{\"规格\":\"1盆\",\"数量\":\"6颗\"}', 58.00, 50, 'PLANT-SUCC-1P-6');
INSERT INTO `sku` VALUES (8175, 6175, '{\"规格\":\"1台\",\"匹数\":\"1.5匹\"}', 2599.00, 15, 'MIDEA-AC-1P-15');
INSERT INTO `sku` VALUES (8176, 6176, '{\"规格\":\"1台\",\"尺寸\":\"55英寸\"}', 2999.00, 10, 'MI-TV-1P-55');
INSERT INTO `sku` VALUES (8177, 6177, '{\"规格\":\"1箱\",\"数量\":\"24瓶\"}', 24.90, 100, 'NFSQ-WATER-1C-24');
INSERT INTO `sku` VALUES (8178, 6178, '{\"规格\":\"5包\",\"口味\":\"红烧牛肉\"}', 12.90, 200, 'KSF-NODDLE-5P-BEEF');
INSERT INTO `sku` VALUES (8179, 6179, '{\"规格\":\"1饼\",\"净重\":\"357g\"}', 198.00, 40, 'PUER-TEA-1C-357');
INSERT INTO `sku` VALUES (8180, 6180, '{\"规格\":\"1套\",\"材质\":\"陶瓷\"}', 268.00, 20, 'TEA-SET-1S-CER');
INSERT INTO `sku` VALUES (8181, 6181, '{\"规格\":\"1张\",\"尺寸\":\"1.5米\"}', 8800.00, 5, 'WOOD-TABLE-1P-150');
INSERT INTO `sku` VALUES (8182, 6182, '{\"规格\":\"1套\",\"材质\":\"黄花梨\"}', 8900.00, 5, 'WOOD-SOFA-1S-HHL');
INSERT INTO `sku` VALUES (8183, 6183, '{\"规格\":\"1部\",\"容量\":\"256GB\"}', 5688.00, 10, 'IPHONE-15P-1U-256');
INSERT INTO `sku` VALUES (8184, 6184, '{\"规格\":\"1台\",\"配置\":\"8GB+256GB\"}', 3298.00, 8, 'MACBOOK-AIR-1P-M3');
INSERT INTO `sku` VALUES (8185, 6185, '{\"规格\":\"1盒\",\"净重\":\"250g\"}', 188.00, 30, 'TIEGUANYIN-1H-250');
INSERT INTO `sku` VALUES (8186, 6186, '{\"规格\":\"1盒\",\"净重\":\"250g\"}', 288.00, 25, 'LONGJING-1H-250');
INSERT INTO `sku` VALUES (8187, 6187, '{\"规格\":\"1件\",\"尺码\":\"M码\"}', 598.00, 20, 'SILK-QIPAO-1P-M');
INSERT INTO `sku` VALUES (8188, 6188, '{\"规格\":\"1套\",\"尺寸\":\"1.8米\"}', 1256.00, 15, 'SILK-BED-1S-180');
INSERT INTO `sku` VALUES (8189, 6189, '{\"规格\":\"1份\",\"重量\":\"500g\"}', 68.00, 50, 'RESTAURANT-PORK-1P-500');
INSERT INTO `sku` VALUES (8190, 6190, '{\"规格\":\"1份\",\"份量\":\"2人份\"}', 88.00, 60, 'RESTAURANT-RICE-1P-2');
INSERT INTO `sku` VALUES (8191, 6191, '{\"规格\":\"1件\",\"尺码\":\"L码\"}', 899.00, 25, 'FASHION-DOWN-1P-L');
INSERT INTO `sku` VALUES (8192, 6192, '{\"规格\":\"1件\",\"尺码\":\"M码\"}', 1299.00, 20, 'FASHION-COAT-1P-M');
INSERT INTO `sku` VALUES (8193, 6193, '{\"规格\":\"1套\",\"数量\":\"5本\"}', 88.00, 50, 'BOOK-SET-1S-5');
INSERT INTO `sku` VALUES (8194, 6194, '{\"规格\":\"1套\",\"材质\":\"钢笔\"}', 168.00, 30, 'PEN-SET-1S-PEN');
INSERT INTO `sku` VALUES (8195, 6195, '{\"规格\":\"1只\",\"重量\":\"2斤\"}', 398.00, 20, 'LOBSTER-1P-2');
INSERT INTO `sku` VALUES (8196, 6196, '{\"规格\":\"1份\",\"重量\":\"1斤\"}', 188.00, 30, 'SALMON-1P-1');
INSERT INTO `sku` VALUES (8197, 6197, '{\"规格\":\"1条\",\"重量\":\"20克\"}', 8888.00, 10, 'GOLD-NECKLACE-1P-20');
INSERT INTO `sku` VALUES (8198, 6198, '{\"规格\":\"1枚\",\"克拉\":\"1克拉\"}', 10000.00, 5, 'DIAMOND-RING-1P-1');

-- ----------------------------
-- Table structure for system_admin
-- ----------------------------
DROP TABLE IF EXISTS `system_admin`;
CREATE TABLE `system_admin`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '系统管理员ID（主键）',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '登录账号',
  `password` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '登录密码（加密）',
  `real_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '管理员姓名',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '联系电话',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '邮箱',
  `role` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '系统角色',
  `status` tinyint NULL DEFAULT NULL COMMENT '账号状态',
  `last_login_time` datetime NULL DEFAULT NULL COMMENT '最后登录时间',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '系统管理员信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of system_admin
-- ----------------------------

-- ----------------------------
-- Table structure for system_config
-- ----------------------------
DROP TABLE IF EXISTS `system_config`;
CREATE TABLE `system_config`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '参数ID（主键）',
  `config_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '参数键（唯一）',
  `config_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '参数名称',
  `config_value` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '参数值',
  `value_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '参数类型',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '参数说明',
  `is_system` tinyint NULL DEFAULT NULL COMMENT '是否系统内置（0否，1是）',
  `status` tinyint NULL DEFAULT NULL COMMENT '参数状态（0禁用，1启用）',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '系统参数配置表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of system_config
-- ----------------------------

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID（主键）',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '手机号',
  `nickname` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '昵称',
  `password` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '密码',
  `avatar` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '头像',
  `sex` tinyint NULL DEFAULT NULL COMMENT '性别',
  `status` tinyint NULL DEFAULT NULL COMMENT '账号状态',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1026 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (1001, '17782224500', '陈心意商家', 'chenyi12345', 'user/1001.jpg', 1, 1);
INSERT INTO `user` VALUES (1002, '17782224501', '王瑞商家', 'wanger12345', 'user/1002.jpg', 0, 1);
INSERT INTO `user` VALUES (1003, '17782224502', '李思琪商家', 'lisan12345', 'user/1003.jpg', 1, 1);
INSERT INTO `user` VALUES (1004, '17782224503', '赵红商家', 'zhaosi12345', 'user/1004.jpg', 1, 1);
INSERT INTO `user` VALUES (1005, '17782224504', '钱森商家', 'qianwu12345', 'user/1005.jpg', 1, 1);
INSERT INTO `user` VALUES (1006, '17782224505', '张康泰商家', 'zhangliu12345', 'user/1006.jpg', 1, 1);
INSERT INTO `user` VALUES (1007, '17782224506', '陈勇商家', 'chener12345', 'user/1007.jpg', 1, 1);
INSERT INTO `user` VALUES (1008, '17782224507', '王果苗商家', 'wangyi12345', 'user/1008.jpg', 1, 1);
INSERT INTO `user` VALUES (1009, '17782224508', '李鑫瑞商家', 'lier12345', 'user/1009.jpg', 1, 1);
INSERT INTO `user` VALUES (1010, '17782224509', '赵蕊商家', 'zhaoyi12345', 'user/1010.jpg', 1, 1);
INSERT INTO `user` VALUES (1011, '17782224510', '林芳商家', 'linfang12345', 'user/1011.jpg', 0, 1);
INSERT INTO `user` VALUES (1012, '17782224511', '周伟商家', 'zhouwei12345', 'user/1012.jpg', 1, 1);
INSERT INTO `user` VALUES (1013, '17782224512', '吴敏商家', 'wumin12345', 'user/1013.jpg', 0, 1);
INSERT INTO `user` VALUES (1014, '17782224513', '郑强商家', 'zhengqiang12345', 'user/1014.jpg', 1, 1);
INSERT INTO `user` VALUES (1015, '17782224514', '孙丽商家', 'sunli12345', 'user/1015.jpg', 0, 1);
INSERT INTO `user` VALUES (1016, '17782224515', '马超商家', 'machao12345', 'user/1016.jpg', 1, 1);
INSERT INTO `user` VALUES (1017, '17782224516', '黄忠商家', 'huangzhong12345', 'user/1017.jpg', 0, 1);
INSERT INTO `user` VALUES (1018, '17782224517', '赵云商家', 'zhaoyun12345', 'user/1018.jpg', 1, 1);
INSERT INTO `user` VALUES (1019, '17782224518', '魏延商家', 'weiyan12345', 'user/1019.jpg', 1, 1);
INSERT INTO `user` VALUES (1020, '17782224519', '关羽商家', 'guanyu12345', 'user/1020.jpg', 0, 1);
INSERT INTO `user` VALUES (1021, '17782224520', '张飞商家', 'zhangfei12345', 'user/1021.jpg', 1, 1);
INSERT INTO `user` VALUES (1022, '17782224521', '刘备商家', 'liubei12345', 'user/1022.jpg', 1, 1);
INSERT INTO `user` VALUES (1023, '17782224522', '诸葛亮商家', 'zhugeliang12345', 'user/1023.jpg', 0, 1);
INSERT INTO `user` VALUES (1024, '17782224523', '曹操商家', 'caocao12345', 'user/1024.jpg', 1, 1);
INSERT INTO `user` VALUES (1025, '17782224524', '孙权商家', 'sunquan12345', 'user/1025.jpg', 1, 1);

-- ----------------------------
-- Table structure for user_behavior_log
-- ----------------------------
DROP TABLE IF EXISTS `user_behavior_log`;
CREATE TABLE `user_behavior_log`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志ID（主键）',
  `user_id` bigint NULL DEFAULT NULL COMMENT '埋点主体用户ID',
  `behavior_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '动作词属性编码',
  `target_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '交互模块名称',
  `target_id` bigint NULL DEFAULT NULL COMMENT '资源物理主键ID',
  `duration` int NULL DEFAULT NULL COMMENT '页面停留时长(秒)',
  `log_time` datetime NULL DEFAULT NULL COMMENT '轨迹触发时间戳',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_behavior_user`(`user_id` ASC) USING BTREE,
  CONSTRAINT `fk_behavior_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户行为埋点日志表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of user_behavior_log
-- ----------------------------

-- ----------------------------
-- Table structure for user_binding
-- ----------------------------
DROP TABLE IF EXISTS `user_binding`;
CREATE TABLE `user_binding`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '关系ID（主键）',
  `user_id` bigint NULL DEFAULT NULL COMMENT '当前用户ID',
  `inviter_id` bigint NULL DEFAULT NULL COMMENT '推荐人用户ID',
  `binding_time` datetime NULL DEFAULT NULL COMMENT '锁粉绑定时间',
  `binding_type` tinyint NULL DEFAULT NULL COMMENT '绑定方式',
  `status` tinyint NULL DEFAULT NULL COMMENT '绑定状态',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_user_binding_user`(`user_id` ASC) USING BTREE,
  INDEX `fk_user_binding_inviter`(`inviter_id` ASC) USING BTREE,
  CONSTRAINT `fk_user_binding_inviter` FOREIGN KEY (`inviter_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_user_binding_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户锁粉推荐关系表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of user_binding
-- ----------------------------

-- ----------------------------
-- Table structure for user_message
-- ----------------------------
DROP TABLE IF EXISTS `user_message`;
CREATE TABLE `user_message`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '消息ID（主键）',
  `user_id` bigint NULL DEFAULT NULL COMMENT '用户ID',
  `template_id` bigint NULL DEFAULT NULL COMMENT '消息模板ID',
  `business_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '业务ID（订单/售后/审核等关联ID）',
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '消息标题',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '消息内容',
  `is_read` tinyint NULL DEFAULT NULL COMMENT '是否已读',
  `send_time` datetime NULL DEFAULT NULL COMMENT '发送时间',
  `read_time` datetime NULL DEFAULT NULL COMMENT '阅读时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_user_message_user`(`user_id` ASC) USING BTREE,
  INDEX `fk_user_message_template`(`template_id` ASC) USING BTREE,
  CONSTRAINT `fk_user_message_template` FOREIGN KEY (`template_id`) REFERENCES `message_template` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_user_message_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户站内消息接收表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of user_message
-- ----------------------------

-- ----------------------------
-- Table structure for user_tag
-- ----------------------------
DROP TABLE IF EXISTS `user_tag`;
CREATE TABLE `user_tag`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '标签记录ID（主键）',
  `user_id` bigint NULL DEFAULT NULL COMMENT '指向描摹用户ID',
  `tag_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '标签名称字符串',
  `weight` decimal(5, 2) NULL DEFAULT NULL COMMENT '数仓偏好模型置信度权重',
  `update_time` datetime NULL DEFAULT NULL COMMENT '模型刷算计算时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_tag_user`(`user_id` ASC) USING BTREE,
  CONSTRAINT `fk_tag_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户画像标签表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of user_tag
-- ----------------------------

-- ----------------------------
-- Table structure for user_wallet
-- ----------------------------
DROP TABLE IF EXISTS `user_wallet`;
CREATE TABLE `user_wallet`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '钱包ID（主键）',
  `user_id` bigint NULL DEFAULT NULL COMMENT '用户ID',
  `balance` decimal(10, 2) NULL DEFAULT NULL COMMENT '可用余额',
  `frozen_amount` decimal(10, 2) NULL DEFAULT NULL COMMENT '冻结金额',
  `total_income` decimal(10, 2) NULL DEFAULT NULL COMMENT '累计收入',
  `total_expenditure` decimal(10, 2) NULL DEFAULT NULL COMMENT '累计支出',
  `status` tinyint NULL DEFAULT NULL COMMENT '钱包状态',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_user_wallet_user`(`user_id` ASC) USING BTREE,
  CONSTRAINT `fk_user_wallet_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户/分销商虚拟钱包表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of user_wallet
-- ----------------------------

-- ----------------------------
-- Table structure for withdrawal_apply
-- ----------------------------
DROP TABLE IF EXISTS `withdrawal_apply`;
CREATE TABLE `withdrawal_apply`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '提现申请ID（主键）',
  `wallet_id` bigint NULL DEFAULT NULL COMMENT '钱包ID',
  `user_id` bigint NULL DEFAULT NULL COMMENT '提现用户ID',
  `apply_amount` decimal(10, 2) NULL DEFAULT NULL COMMENT '提现金额',
  `account_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '收款人姓名',
  `account_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '收款账号',
  `bank_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '开户银行',
  `audit_status` tinyint NULL DEFAULT NULL COMMENT '审核状态',
  `audit_time` datetime NULL DEFAULT NULL COMMENT '审核时间',
  `remark` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '审核备注',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_withdrawal_wallet`(`wallet_id` ASC) USING BTREE,
  INDEX `fk_withdrawal_user`(`user_id` ASC) USING BTREE,
  CONSTRAINT `fk_withdrawal_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_withdrawal_wallet` FOREIGN KEY (`wallet_id`) REFERENCES `user_wallet` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '提现申请审批表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of withdrawal_apply
-- ----------------------------

-- ----------------------------
-- Procedure structure for SafeAddColumn
-- ----------------------------
DROP PROCEDURE IF EXISTS `SafeAddColumn`;
delimiter ;;
CREATE PROCEDURE `SafeAddColumn`(IN tableName VARCHAR(64),
    IN colName VARCHAR(64),
    IN colFullDef VARCHAR(1000))
BEGIN
    DECLARE existCount INT DEFAULT 0;
    SELECT COUNT(*) INTO existCount
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = tableName
      AND COLUMN_NAME = colName;

    IF existCount = 0 THEN
        SET @execSql = CONCAT('ALTER TABLE `', tableName, '` ADD COLUMN ', colFullDef);
        PREPARE stmt FROM @execSql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
    END IF;
END
;;
delimiter ;

SET FOREIGN_KEY_CHECKS = 1;
