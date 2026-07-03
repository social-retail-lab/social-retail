-- ==========================================
-- 1. 创建并切换数据库
-- ==========================================
CREATE DATABASE IF NOT EXISTS `social_retail_db` CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `social_retail_db`;

-- ==========================================
-- 2. 用户中心 (User Center)
-- ==========================================

-- User（用户表）
CREATE TABLE IF NOT EXISTS `user` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '用户ID（主键）',
  `phone` VARCHAR(20) DEFAULT NULL COMMENT '手机号',
  `nickname` VARCHAR(50) DEFAULT NULL COMMENT '昵称',
  `password` VARCHAR(200) DEFAULT NULL COMMENT '密码',
  `avatar` VARCHAR(200) DEFAULT NULL COMMENT '头像',
  `sex` TINYINT DEFAULT NULL COMMENT '性别',
  `status` TINYINT DEFAULT NULL COMMENT '账号状态',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- Member（会员表）
CREATE TABLE IF NOT EXISTS `member` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '会员ID（主键）',
  `user_id` BIGINT DEFAULT NULL COMMENT '用户ID',
  `member_level` TINYINT DEFAULT NULL COMMENT '会员等级',
  `points_balance` INT DEFAULT NULL COMMENT '积分余额',
  `growth_value` INT DEFAULT NULL COMMENT '成长值',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_member_user` (`user_id`),
  CONSTRAINT `fk_member_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='会员表';

-- Distributor（分销员表）
CREATE TABLE IF NOT EXISTS `distributor` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '分销员ID（主键）',
  `user_id` BIGINT DEFAULT NULL COMMENT '用户ID',
  `total_commission` DECIMAL(10,2) DEFAULT NULL COMMENT '累计佣金',
  `frozen_commission` DECIMAL(10,2) DEFAULT NULL COMMENT '冻结佣金',
  `status` TINYINT DEFAULT NULL COMMENT '分销状态',
  `apply_time` DATETIME DEFAULT NULL COMMENT '申请时间',
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_distributor_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='分销员表';

-- Address（收货地址表）
CREATE TABLE IF NOT EXISTS `address` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '地址ID（主键）',
  `user_id` BIGINT DEFAULT NULL COMMENT '用户ID',
  `consignee` VARCHAR(50) DEFAULT NULL COMMENT '收货人姓名',
  `phone` VARCHAR(20) DEFAULT NULL COMMENT '收货人电话',
  `province` VARCHAR(50) DEFAULT NULL COMMENT '省份',
  `city` VARCHAR(50) DEFAULT NULL COMMENT '城市',
  `district` VARCHAR(50) DEFAULT NULL COMMENT '区县',
  `detailed_address` VARCHAR(200) DEFAULT NULL COMMENT '详细地址',
  `is_default` TINYINT DEFAULT NULL COMMENT '是否默认地址',
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_address_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='收货地址表';


-- ==========================================
-- 3. 商家中心 (Merchant Center)
-- ==========================================

-- Merchant（商家表）
CREATE TABLE IF NOT EXISTS `merchant` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '商家ID（主键）',
  `user_id` BIGINT DEFAULT NULL COMMENT '关联用户ID',
  `merchant_name` VARCHAR(100) DEFAULT NULL COMMENT '商家名称',
  `logo` VARCHAR(200) DEFAULT NULL COMMENT '商家Logo',
  `contact_name` VARCHAR(50) DEFAULT NULL COMMENT '联系人',
  `contact_phone` VARCHAR(20) DEFAULT NULL COMMENT '联系电话',
  `shop_address` VARCHAR(200) DEFAULT NULL COMMENT '店铺地址',
  `status` TINYINT DEFAULT NULL COMMENT '营业状态',
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_merchant_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商家表';

-- MerchantQualification（商家资质表）
CREATE TABLE IF NOT EXISTS `merchant_qualification` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '资质ID（主键）',
  `merchant_id` BIGINT DEFAULT NULL COMMENT '商家ID',
  `license_number` VARCHAR(50) DEFAULT NULL COMMENT '营业执照注册号',
  `license_image` VARCHAR(200) DEFAULT NULL COMMENT '营业执照图片',
  `food_permit_number` VARCHAR(50) DEFAULT NULL COMMENT '食品经营许可证号',
  `food_permit_image` VARCHAR(200) DEFAULT NULL COMMENT '食品许可证图片',
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_qualification_merchant` FOREIGN KEY (`merchant_id`) REFERENCES `merchant` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商家资质表';

-- MerchantApply（商家入驻申请表）
CREATE TABLE IF NOT EXISTS `merchant_apply` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '申请ID（主键）',
  `user_id` BIGINT DEFAULT NULL COMMENT '申请人用户ID',
  `company_name` VARCHAR(100) DEFAULT NULL COMMENT '企业/商家名称',
  `id_card_front` VARCHAR(200) DEFAULT NULL COMMENT '身份证正面图片',
  `id_card_back` VARCHAR(200) DEFAULT NULL COMMENT '身份证反面图片',
  `audit_status` TINYINT DEFAULT NULL COMMENT '审核状态',
  `audit_remark` VARCHAR(200) DEFAULT NULL COMMENT '审核备注',
  `apply_time` DATETIME DEFAULT NULL COMMENT '提交时间',
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_merchant_apply_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商家入驻申请表';


-- ==========================================
-- 4. 商品中心 (Product Center)
-- ==========================================

-- Brand（品牌表）
CREATE TABLE IF NOT EXISTS `brand` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '品牌ID（主键）',
  `name` VARCHAR(100) DEFAULT NULL COMMENT '品牌名称',
  `logo` VARCHAR(200) DEFAULT NULL COMMENT '品牌Logo',
  `description` TEXT DEFAULT NULL COMMENT '品牌介绍',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='品牌表';

-- Category（商品分类表）
CREATE TABLE IF NOT EXISTS `category` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '分类ID（主键）',
  `parent_id` BIGINT DEFAULT NULL COMMENT '上级分类ID',
  `name` VARCHAR(50) DEFAULT NULL COMMENT '分类名称',
  `level` TINYINT DEFAULT NULL COMMENT '层级等级',
  `sort_order` INT DEFAULT NULL COMMENT '排序值',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商品分类表';

-- Product（商品主表）
CREATE TABLE IF NOT EXISTS `product` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '商品ID（主键）',
  `brand_id` BIGINT DEFAULT NULL COMMENT '品牌ID',
  `merchant_id` BIGINT DEFAULT NULL COMMENT '商家ID',
  `title` VARCHAR(200) DEFAULT NULL COMMENT '商品名称',
  `sub_title` VARCHAR(200) DEFAULT NULL COMMENT '副标题',
  `main_image` VARCHAR(200) DEFAULT NULL COMMENT '商品主图',
  `detail_desc` TEXT DEFAULT NULL COMMENT '详情描述',
  `sale_type` TINYINT DEFAULT NULL COMMENT '销售模式（自提/配送）',
  `status` TINYINT DEFAULT NULL COMMENT '上架状态',
  `sold_count` BIGINT NOT NULL DEFAULT 0 COMMENT '已售数量',
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_product_brand` FOREIGN KEY (`brand_id`) REFERENCES `brand` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_product_merchant` FOREIGN KEY (`merchant_id`) REFERENCES `merchant` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商品主表';

-- Sku（商品规格库存表）
CREATE TABLE IF NOT EXISTS `sku` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT 'SkuID（主键）',
  `product_id` BIGINT DEFAULT NULL COMMENT '商品ID',
  `specs` VARCHAR(200) DEFAULT NULL COMMENT '规格属性(JSON格式)',
  `price` DECIMAL(10,2) DEFAULT NULL COMMENT '销售价格',
  `stock` INT DEFAULT NULL COMMENT '物理库存',
  `sku_code` VARCHAR(100) DEFAULT NULL COMMENT 'SKU编码',
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_sku_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商品规格库存表';

-- ProductCategoryRelation（商品分类中间表）
CREATE TABLE IF NOT EXISTS `product_category_relation` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '记录ID（主键）',
  `product_id` BIGINT DEFAULT NULL COMMENT '商品ID',
  `category_id` BIGINT DEFAULT NULL COMMENT '分类ID',
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_pcr_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_pcr_category` FOREIGN KEY (`category_id`) REFERENCES `category` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商品分类中间表';


-- ==========================================
-- 5. 订单交易中心 (Order & Transaction Center)
-- ==========================================

-- Cart（购物车表）
CREATE TABLE IF NOT EXISTS `cart` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '购物车ID（主键）',
  `user_id` BIGINT DEFAULT NULL COMMENT '用户ID',
  `sku_id` BIGINT DEFAULT NULL COMMENT 'SkuID',
  `quantity` INT DEFAULT NULL COMMENT '购买数量',
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_cart_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_cart_sku` FOREIGN KEY (`sku_id`) REFERENCES `sku` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='购物车表';

-- PickupPoint（自提点表）
CREATE TABLE IF NOT EXISTS `pickup_point` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '自提点ID（主键）',
  `merchant_id` BIGINT DEFAULT NULL COMMENT '所属商家ID',
  `name` VARCHAR(100) DEFAULT NULL COMMENT '自提点名称',
  `address` VARCHAR(200) DEFAULT NULL COMMENT '自提点详细地址',
  `contact_phone` VARCHAR(20) DEFAULT NULL COMMENT '联系电话',
  `status` TINYINT DEFAULT NULL COMMENT '营业状态',
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_pickup_merchant` FOREIGN KEY (`merchant_id`) REFERENCES `merchant` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='自提点表';

-- Order（订单主表）
CREATE TABLE IF NOT EXISTS `order` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '订单ID（主键）',
  `order_sn` VARCHAR(50) DEFAULT NULL COMMENT '订单编号',
  `idempotent_key` VARCHAR(100) DEFAULT NULL COMMENT '用户提交订单幂等键',
  `user_id` BIGINT DEFAULT NULL COMMENT '用户ID',
  `merchant_id` BIGINT DEFAULT NULL COMMENT '商家ID',
  `pickup_point_id` BIGINT DEFAULT NULL COMMENT '自提点ID',
  `total_amount` DECIMAL(10,2) DEFAULT NULL COMMENT '订单总价',
  `pay_amount` DECIMAL(10,2) DEFAULT NULL COMMENT '应付金额',
  `used_points` INT NOT NULL DEFAULT 0 COMMENT '订单使用积分',
  `points_status` TINYINT NOT NULL DEFAULT 0 COMMENT '积分状态：0无 1预占 2已扣减 3已释放',
  `delivery_type` TINYINT DEFAULT NULL COMMENT '配送方式',
  `status` TINYINT DEFAULT NULL COMMENT '订单状态',
  `create_time` DATETIME DEFAULT NULL COMMENT '下单时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_order_user_idempotent` (`user_id`, `idempotent_key`),
  CONSTRAINT `fk_order_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_order_merchant` FOREIGN KEY (`merchant_id`) REFERENCES `merchant` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_order_pickup` FOREIGN KEY (`pickup_point_id`) REFERENCES `pickup_point` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='订单主表';

-- OrderItem（订单明细表）
CREATE TABLE IF NOT EXISTS `order_item` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '明细ID（主键）',
  `order_id` BIGINT DEFAULT NULL COMMENT '订单ID',
  `sku_id` BIGINT DEFAULT NULL COMMENT 'SkuID',
  `product_name` VARCHAR(200) DEFAULT NULL COMMENT '商品快照名称',
  `sku_specs` VARCHAR(200) DEFAULT NULL COMMENT '规格快照',
  `price` DECIMAL(10,2) DEFAULT NULL COMMENT '购买单价',
  `quantity` INT DEFAULT NULL COMMENT '购买数量',
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_items_order` FOREIGN KEY (`order_id`) REFERENCES `order` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_items_sku` FOREIGN KEY (`sku_id`) REFERENCES `sku` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='订单明细表';

-- Payment（支付记录表）
CREATE TABLE IF NOT EXISTS `payment` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '支付ID（主键）',
  `order_id` BIGINT DEFAULT NULL COMMENT '订单ID',
  `pay_sn` VARCHAR(50) DEFAULT NULL COMMENT '支付流水号',
  `pay_platform` TINYINT DEFAULT NULL COMMENT '支付通道',
  `amount` DECIMAL(10,2) DEFAULT NULL COMMENT '实际支付金额',
  `status` TINYINT DEFAULT NULL COMMENT '支付状态',
  `pay_time` DATETIME DEFAULT NULL COMMENT '支付成功时间',
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_payment_order` FOREIGN KEY (`order_id`) REFERENCES `order` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='支付记录表';

-- Delivery（配送单表）
CREATE TABLE IF NOT EXISTS `delivery` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '配送单ID（主键）',
  `order_id` BIGINT DEFAULT NULL COMMENT '订单ID',
  `delivery_sn` VARCHAR(50) DEFAULT NULL COMMENT '物流运单号',
  `dispatcher_name` VARCHAR(50) DEFAULT NULL COMMENT '配送员/骑手姓名',
  `dispatcher_phone` VARCHAR(20) DEFAULT NULL COMMENT '配送员电话',
  `status` TINYINT DEFAULT NULL COMMENT '配送状态',
  `start_time` DATETIME DEFAULT NULL COMMENT '出发时间',
  `end_time` DATETIME DEFAULT NULL COMMENT '送达时间',
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_delivery_order` FOREIGN KEY (`order_id`) REFERENCES `order` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='配送单表';

-- AfterSale（售后申请表）
CREATE TABLE IF NOT EXISTS `after_sale` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '售后ID（主键）',
  `order_id` BIGINT DEFAULT NULL COMMENT '订单ID',
  `order_item_id` BIGINT DEFAULT NULL COMMENT '订单明细ID',
  `type` TINYINT DEFAULT NULL COMMENT '售后类型（仅退款/退货退款）',
  `refund_amount` DECIMAL(10,2) DEFAULT NULL COMMENT '申请退款金额',
  `reason` VARCHAR(200) DEFAULT NULL COMMENT '申请原因',
  `status` TINYINT DEFAULT NULL COMMENT '售后状态',
  `apply_time` DATETIME DEFAULT NULL COMMENT '申请时间',
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_after_sale_order` FOREIGN KEY (`order_id`) REFERENCES `order` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_after_sale_item` FOREIGN KEY (`order_item_id`) REFERENCES `order_item` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='售后申请表';


-- ==========================================
-- 6. 营销中心 (Marketing Center)
-- ==========================================

-- SeckillActivity（秒杀活动表）
CREATE TABLE IF NOT EXISTS `seckill_activity` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '活动ID（主键）',
  `title` VARCHAR(100) DEFAULT NULL COMMENT '活动名称',
  `start_time` DATETIME DEFAULT NULL COMMENT '开始时间',
  `end_time` DATETIME DEFAULT NULL COMMENT '结束时间',
  `status` TINYINT DEFAULT NULL COMMENT '活动状态',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='秒杀活动表';

-- SeckillProduct（秒杀商品表）
CREATE TABLE IF NOT EXISTS `seckill_product` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '秒杀关联ID（主键）',
  `seckill_activity_id` BIGINT DEFAULT NULL COMMENT '秒杀活动ID',
  `product_id` BIGINT DEFAULT NULL COMMENT '商品SpuID',
  `sku_id` BIGINT DEFAULT NULL COMMENT '商品SkuID',
  `seckill_price` DECIMAL(10,2) DEFAULT NULL COMMENT '秒杀专享价',
  `seckill_stock` INT DEFAULT NULL COMMENT '秒杀专享库存',
  `sold_count` INT NOT NULL DEFAULT 0 COMMENT '已售数量',
  `limit_quantity` TINYINT DEFAULT NULL COMMENT '每人限购数量',
  `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态：0禁用 1启用',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_seckill_activity_sku` (`seckill_activity_id`, `sku_id`),
  CONSTRAINT `fk_seckill_act` FOREIGN KEY (`seckill_activity_id`) REFERENCES `seckill_activity` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_seckill_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_seckill_sku` FOREIGN KEY (`sku_id`) REFERENCES `sku` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='秒杀商品表';

-- BargainActivity（砍价活动表）
CREATE TABLE IF NOT EXISTS `bargain_activity` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '砍价活动ID（主键）',
  `user_id` BIGINT DEFAULT NULL COMMENT '发起用户ID',
  `product_id` BIGINT DEFAULT NULL COMMENT '商品SpuID',
  `sku_id` BIGINT DEFAULT NULL COMMENT '商品SkuID',
  `target_price` DECIMAL(10,2) DEFAULT NULL COMMENT '砍价目标底价',
  `current_price` DECIMAL(10,2) DEFAULT NULL COMMENT '当前砍后金额',
  `end_time` DATETIME DEFAULT NULL COMMENT '结束时限',
  `status` TINYINT DEFAULT NULL COMMENT '砍价状态',
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_bargain_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_bargain_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_bargain_sku` FOREIGN KEY (`sku_id`) REFERENCES `sku` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='砍价活动表';

-- Coupon（优惠券主表）
CREATE TABLE IF NOT EXISTS `coupon` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '优惠券ID（主键）',
  `title` VARCHAR(100) DEFAULT NULL COMMENT '优惠券名称',
  `type` TINYINT DEFAULT NULL COMMENT '适用类型',
  `min_consume` DECIMAL(10,2) DEFAULT NULL COMMENT '满减门槛金额',
  `discount_amount` DECIMAL(10,2) DEFAULT NULL COMMENT '面值抵扣金额',
  `total_count` INT DEFAULT NULL COMMENT '发行总量',
  `received_count` INT NOT NULL DEFAULT 0 COMMENT '已领取数量',
  `per_user_limit` INT NOT NULL DEFAULT 1 COMMENT '每人限领数量',
  `exchange_points` INT DEFAULT 0 COMMENT '兑换所需积分',
  `valid_start` DATETIME DEFAULT NULL COMMENT '有效期开始时间',
  `valid_end` DATETIME DEFAULT NULL COMMENT '有效期截止时间',
  `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态：0禁用 1启用',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='优惠券主表';

-- CouponUser（优惠券领用记录表）
CREATE TABLE IF NOT EXISTS `coupon_user` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '领用记录ID（主键）',
  `coupon_id` BIGINT DEFAULT NULL COMMENT '优惠券模版ID',
  `user_id` BIGINT DEFAULT NULL COMMENT '持有用户ID',
  `order_id` BIGINT DEFAULT NULL COMMENT '核销抵扣订单ID',
  `status` TINYINT DEFAULT NULL COMMENT '状态（未使用/已用/过期）',
  `receive_time` DATETIME DEFAULT NULL COMMENT '领取时间',
  `use_time` DATETIME DEFAULT NULL COMMENT '使用核销时间',
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_coupon_template` FOREIGN KEY (`coupon_id`) REFERENCES `coupon` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_coupon_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_coupon_order` FOREIGN KEY (`order_id`) REFERENCES `order` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='优惠券领用记录表';


-- ==========================================
-- 7. 会员中心 (Member Center - Logs)
-- ==========================================

-- PointsLog（积分变更日志表）
CREATE TABLE IF NOT EXISTS `points_log` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '日志ID（主键）',
  `user_id` BIGINT DEFAULT NULL COMMENT '用户ID',
  `type` TINYINT DEFAULT NULL COMMENT '变更动作类型',
  `change_points` INT DEFAULT NULL COMMENT '变动积分值',
  `current_points` INT DEFAULT NULL COMMENT '变动后余额',
  `remark` VARCHAR(200) DEFAULT NULL COMMENT '事务场景备注',
  `create_time` DATETIME DEFAULT NULL COMMENT '记录生成时间',
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_points_log_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='积分变更日志表';

-- GrowthLog（成长值变更日志表）
CREATE TABLE IF NOT EXISTS `growth_log` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '日志ID（主键）',
  `user_id` BIGINT DEFAULT NULL COMMENT '用户ID',
  `type` TINYINT DEFAULT NULL COMMENT '来源渠道类型',
  `change_growth` INT DEFAULT NULL COMMENT '变更成长值数额',
  `current_growth` INT DEFAULT NULL COMMENT '最新累计总成长值',
  `remark` VARCHAR(200) DEFAULT NULL COMMENT '行为场景备注',
  `create_time` DATETIME DEFAULT NULL COMMENT '变动记录时间',
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_growth_log_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='成长值变更日志表';


-- ==========================================
-- 8. 社交裂变中心 (Social Fission Center)
-- ==========================================

-- Poster（裂变海报配置表）
CREATE TABLE IF NOT EXISTS `poster` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '海报ID（主键）',
  `title` VARCHAR(100) DEFAULT NULL COMMENT '海报主题模板名称',
  `bg_image` VARCHAR(200) DEFAULT NULL COMMENT '背景原图素材URL',
  `qr_code_config` TEXT DEFAULT NULL COMMENT '二维码动态图层配置参数',
  `status` TINYINT DEFAULT NULL COMMENT '使用状态',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='裂变海报配置表';

-- ShareLog（推广分享日志表）
CREATE TABLE IF NOT EXISTS `share_log` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '日志ID（主键）',
  `user_id` BIGINT DEFAULT NULL COMMENT '分享人用户ID',
  `target_type` TINYINT DEFAULT NULL COMMENT '传播媒介类型（商品/活动）',
  `target_id` BIGINT DEFAULT NULL COMMENT '关联媒介实体物理ID',
  `share_channel` VARCHAR(50) DEFAULT NULL COMMENT '触达渠道分发媒介',
  `share_time` DATETIME DEFAULT NULL COMMENT '分享动作触发时间',
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_share_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='推广分享日志表';

-- CommissionLog（佣金流水结算表）
CREATE TABLE IF NOT EXISTS `commission_log` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '流水ID（主键）',
  `distributor_id` BIGINT DEFAULT NULL COMMENT '收益人分销员ID',
  `order_id` BIGINT DEFAULT NULL COMMENT '关联交易触发订单ID',
  `order_amount` DECIMAL(10,2) DEFAULT NULL COMMENT '计提基数总金额',
  `commission_amount` DECIMAL(10,2) DEFAULT NULL COMMENT '本次分润佣金金额',
  `status` TINYINT DEFAULT NULL COMMENT '清算状态',
  `settlement_time` DATETIME DEFAULT NULL COMMENT '入账钱包清算时间',
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_comm_distributor` FOREIGN KEY (`distributor_id`) REFERENCES `distributor` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_comm_order` FOREIGN KEY (`order_id`) REFERENCES `order` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='佣金流水结算表';


-- ==========================================
-- 9. 数据分析中心 (Data Analysis Center)
-- ==========================================

-- UserBehaviorLog（用户行为埋点日志表）
CREATE TABLE IF NOT EXISTS `user_behavior_log` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '日志ID（主键）',
  `user_id` BIGINT DEFAULT NULL COMMENT '埋点主体用户ID',
  `behavior_type` VARCHAR(50) DEFAULT NULL COMMENT '动作词属性编码',
  `target_type` VARCHAR(50) DEFAULT NULL COMMENT '交互模块名称',
  `target_id` BIGINT DEFAULT NULL COMMENT '资源物理主键ID',
  `duration` INT DEFAULT NULL COMMENT '页面停留时长(秒)',
  `log_time` DATETIME DEFAULT NULL COMMENT '轨迹触发时间戳',
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_behavior_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户行为埋点日志表';

-- UserTag（用户画像标签表）
CREATE TABLE IF NOT EXISTS `user_tag` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '标签记录ID（主键）',
  `user_id` BIGINT DEFAULT NULL COMMENT '指向描摹用户ID',
  `tag_name` VARCHAR(100) DEFAULT NULL COMMENT '标签名称字符串',
  `weight` DECIMAL(5,2) DEFAULT NULL COMMENT '数仓偏好模型置信度权重',
  `update_time` DATETIME DEFAULT NULL COMMENT '模型刷算计算时间',
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_tag_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户画像标签表';

-- RecommendationLog（个性化算法推荐结果记录表）
CREATE TABLE IF NOT EXISTS `recommendation_log` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '推荐流水ID（主键）',
  `user_id` BIGINT DEFAULT NULL COMMENT '推荐目标触达用户ID',
  `scene` VARCHAR(50) DEFAULT NULL COMMENT '算法展示前台场景栏位',
  `recommended_product_ids` TEXT DEFAULT NULL COMMENT '下发推荐Spu集快照串',
  `feedback_type` TINYINT DEFAULT NULL COMMENT '实际漏斗闭环反馈效果',
  `log_time` DATETIME DEFAULT NULL COMMENT '推荐曝光展示时间',
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_recomm_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='个性化算法推荐结果记录表';

-- ==========================================
-- 10. 其他
-- ==========================================

-- Message Template（消息通知模板表）
CREATE TABLE IF NOT EXISTS `message_template` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '模板ID（主键）',
  `template_code` VARCHAR(50) DEFAULT NULL COMMENT '模板编码',
  `template_name` VARCHAR(100) DEFAULT NULL COMMENT '模板名称',
  `message_type` TINYINT DEFAULT NULL COMMENT '消息类型（1站内信、2短信、3邮件）',
  `title` VARCHAR(200) DEFAULT NULL COMMENT '消息标题',
  `content` TEXT COMMENT '消息模板内容',
  `status` TINYINT DEFAULT NULL COMMENT '启用状态',
  `create_time` DATETIME DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='消息通知模板表';


-- User Message（用户站内消息接收表）
CREATE TABLE IF NOT EXISTS `user_message` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '消息ID（主键）',
  `user_id` BIGINT DEFAULT NULL COMMENT '用户ID',
  `template_id` BIGINT DEFAULT NULL COMMENT '消息模板ID',
  `title` VARCHAR(200) DEFAULT NULL COMMENT '消息标题',
  `content` TEXT COMMENT '消息内容',
  `is_read` TINYINT DEFAULT NULL COMMENT '是否已读',
  `send_time` DATETIME DEFAULT NULL COMMENT '发送时间',
  `read_time` DATETIME DEFAULT NULL COMMENT '阅读时间',
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_user_message_user`
    FOREIGN KEY (`user_id`) REFERENCES `user`(`id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_user_message_template`
    FOREIGN KEY (`template_id`) REFERENCES `message_template`(`id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户站内消息接收表';


-- User Binding（用户锁粉推荐关系表）
CREATE TABLE IF NOT EXISTS `user_binding` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '关系ID（主键）',
  `user_id` BIGINT DEFAULT NULL COMMENT '当前用户ID',
  `inviter_id` BIGINT DEFAULT NULL COMMENT '推荐人用户ID',
  `binding_time` DATETIME DEFAULT NULL COMMENT '锁粉绑定时间',
  `binding_type` TINYINT DEFAULT NULL COMMENT '绑定方式',
  `status` TINYINT DEFAULT NULL COMMENT '绑定状态',
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_user_binding_user`
    FOREIGN KEY (`user_id`) REFERENCES `user`(`id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_user_binding_inviter`
    FOREIGN KEY (`inviter_id`) REFERENCES `user`(`id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户锁粉推荐关系表';


-- User Wallet（用户/分销商虚拟钱包表）
CREATE TABLE IF NOT EXISTS `user_wallet` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '钱包ID（主键）',
  `user_id` BIGINT DEFAULT NULL COMMENT '用户ID',
  `balance` DECIMAL(10,2) DEFAULT NULL COMMENT '可用余额',
  `frozen_amount` DECIMAL(10,2) DEFAULT NULL COMMENT '冻结金额',
  `total_income` DECIMAL(10,2) DEFAULT NULL COMMENT '累计收入',
  `total_expenditure` DECIMAL(10,2) DEFAULT NULL COMMENT '累计支出',
  `status` TINYINT DEFAULT NULL COMMENT '钱包状态',
  `update_time` DATETIME DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_user_wallet_user`
    FOREIGN KEY (`user_id`) REFERENCES `user`(`id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户/分销商虚拟钱包表';


-- Withdrawal Apply（提现申请审批表）
CREATE TABLE IF NOT EXISTS `withdrawal_apply` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '提现申请ID（主键）',
  `wallet_id` BIGINT DEFAULT NULL COMMENT '钱包ID',
  `user_id` BIGINT DEFAULT NULL COMMENT '提现用户ID',
  `apply_amount` DECIMAL(10,2) DEFAULT NULL COMMENT '提现金额',
  `account_name` VARCHAR(50) DEFAULT NULL COMMENT '收款人姓名',
  `account_no` VARCHAR(50) DEFAULT NULL COMMENT '收款账号',
  `bank_name` VARCHAR(100) DEFAULT NULL COMMENT '开户银行',
  `audit_status` TINYINT DEFAULT NULL COMMENT '审核状态',
  `audit_time` DATETIME DEFAULT NULL COMMENT '审核时间',
  `remark` VARCHAR(200) DEFAULT NULL COMMENT '审核备注',
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_withdrawal_wallet`
    FOREIGN KEY (`wallet_id`) REFERENCES `user_wallet`(`id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_withdrawal_user`
    FOREIGN KEY (`user_id`) REFERENCES `user`(`id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='提现申请审批表';


-- Product Comment（商品评价表）
CREATE TABLE IF NOT EXISTS `product_comment` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '评价ID（主键）',
  `order_item_id` BIGINT DEFAULT NULL COMMENT '订单明细ID',
  `product_id` BIGINT DEFAULT NULL COMMENT '商品ID',
  `user_id` BIGINT DEFAULT NULL COMMENT '用户ID',
  `score` TINYINT DEFAULT NULL COMMENT '评分（1~5分）',
  `content` TEXT COMMENT '评价内容',
  `images` VARCHAR(500) DEFAULT NULL COMMENT '评价图片',
  `anonymous` TINYINT DEFAULT NULL COMMENT '是否匿名',
  `create_time` DATETIME DEFAULT NULL COMMENT '评价时间',
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_product_comment_order_item`
    FOREIGN KEY (`order_item_id`) REFERENCES `order_item`(`id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_product_comment_product`
    FOREIGN KEY (`product_id`) REFERENCES `product`(`id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_product_comment_user`
    FOREIGN KEY (`user_id`) REFERENCES `user`(`id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商品评价表';


-- Operation Admin（运营管理员信息表）
CREATE TABLE IF NOT EXISTS `operation_admin` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '运营管理员ID（主键）',
  `username` VARCHAR(50) DEFAULT NULL COMMENT '登录账号',
  `password` VARCHAR(200) DEFAULT NULL COMMENT '登录密码（加密）',
  `real_name` VARCHAR(50) DEFAULT NULL COMMENT '真实姓名',
  `phone` VARCHAR(20) DEFAULT NULL COMMENT '联系电话',
  `email` VARCHAR(100) DEFAULT NULL COMMENT '邮箱',
  `status` TINYINT DEFAULT NULL COMMENT '账号状态',
  `last_login_time` DATETIME DEFAULT NULL COMMENT '最后登录时间',
  `create_time` DATETIME DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='运营管理员信息表';


-- System Admin（系统管理员信息表）
CREATE TABLE IF NOT EXISTS `system_admin` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '系统管理员ID（主键）',
  `username` VARCHAR(50) DEFAULT NULL COMMENT '登录账号',
  `password` VARCHAR(200) DEFAULT NULL COMMENT '登录密码（加密）',
  `real_name` VARCHAR(50) DEFAULT NULL COMMENT '管理员姓名',
  `phone` VARCHAR(20) DEFAULT NULL COMMENT '联系电话',
  `email` VARCHAR(100) DEFAULT NULL COMMENT '邮箱',
  `role` VARCHAR(50) DEFAULT NULL COMMENT '系统角色',
  `status` TINYINT DEFAULT NULL COMMENT '账号状态',
  `last_login_time` DATETIME DEFAULT NULL COMMENT '最后登录时间',
  `create_time` DATETIME DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统管理员信息表';


-- System Config（系统参数配置表）
CREATE TABLE IF NOT EXISTS `system_config` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '参数ID（主键）',
  `config_key` VARCHAR(100) DEFAULT NULL COMMENT '参数键（唯一）',
  `config_name` VARCHAR(100) DEFAULT NULL COMMENT '参数名称',
  `config_value` VARCHAR(500) DEFAULT NULL COMMENT '参数值',
  `value_type` VARCHAR(20) DEFAULT NULL COMMENT '参数类型',
  `description` VARCHAR(255) DEFAULT NULL COMMENT '参数说明',
  `is_system` TINYINT DEFAULT NULL COMMENT '是否系统内置（0否，1是）',
  `status` TINYINT DEFAULT NULL COMMENT '参数状态（0禁用，1启用）',
  `create_time` DATETIME DEFAULT NULL COMMENT '创建时间',
  `update_time` DATETIME DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统参数配置表';
