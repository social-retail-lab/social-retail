SET FOREIGN_KEY_CHECKS=0;


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
DROP TABLE IF EXISTS `address`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `address` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '地址ID（主键）',
  `user_id` bigint DEFAULT NULL COMMENT '用户ID',
  `consignee` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '收货人姓名',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '收货人电话',
  `province` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '省份',
  `city` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '城市',
  `district` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '区县',
  `detailed_address` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '详细地址',
  `is_default` tinyint DEFAULT NULL COMMENT '是否默认地址',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `fk_address_user` (`user_id`) USING BTREE,
  CONSTRAINT `fk_address_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='收货地址表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `after_sale`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `after_sale` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '售后ID（主键）',
  `order_id` bigint DEFAULT NULL COMMENT '订单ID',
  `order_item_id` bigint DEFAULT NULL COMMENT '订单明细ID',
  `merchant_id` bigint DEFAULT NULL COMMENT '商家ID（用于后台处理归属）',
  `order_sn` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '订单编号',
  `type` tinyint DEFAULT NULL COMMENT '售后类型（1=仅退款 2=退货退款）',
  `service_type` tinyint DEFAULT '1' COMMENT '售后服务类型：1退款 2退货退款',
  `refund_amount` decimal(10,2) DEFAULT NULL COMMENT '申请退款金额',
  `actual_refund_amount` decimal(10,2) DEFAULT NULL COMMENT '实际退款金额',
  `reason` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '申请原因',
  `evidence_images` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '凭证图片',
  `product_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '商品快照名称',
  `sku_specs` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '规格快照(JSON)',
  `status` tinyint DEFAULT NULL COMMENT '售后状态（0=待审核 1=待商家处理 2=商家同意 3=用户已退货 4=已完成 5=已拒绝）',
  `audit_status` tinyint NOT NULL DEFAULT '0' COMMENT '审核状态：0待审核 1通过 2拒绝',
  `refund_status` tinyint DEFAULT '0' COMMENT '退款状态：0未退款 1退款中 2退款成功 3退款失败',
  `audit_remark` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '审核备注',
  `reject_reason` varchar(500) DEFAULT NULL COMMENT '拒绝原因',
  `audit_time` datetime DEFAULT NULL COMMENT '审核时间',
  `return_received_status` tinyint DEFAULT NULL COMMENT '退货收货状态',
  `return_received_time` datetime DEFAULT NULL COMMENT '退货收货时间',
  `complete_time` datetime DEFAULT NULL COMMENT '完成时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `feedback_content` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '反馈内容',
  `feedback_images` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '反馈图片',
  `is_deleted` tinyint DEFAULT '0' COMMENT '逻辑删除标记',
  `apply_time` datetime DEFAULT NULL COMMENT '申请时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `fk_after_sale_order` (`order_id`) USING BTREE,
  KEY `fk_after_sale_item` (`order_item_id`) USING BTREE,
  CONSTRAINT `fk_after_sale_item` FOREIGN KEY (`order_item_id`) REFERENCES `order_item` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_after_sale_order` FOREIGN KEY (`order_id`) REFERENCES `order` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='售后申请表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `bargain_activity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bargain_activity` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '砍价活动ID（主键）',
  `user_id` bigint DEFAULT NULL COMMENT '发起用户ID',
  `product_id` bigint DEFAULT NULL COMMENT '商品SpuID',
  `sku_id` bigint DEFAULT NULL COMMENT '商品SkuID',
  `target_price` decimal(10,2) DEFAULT NULL COMMENT '砍价目标底价',
  `current_price` decimal(10,2) DEFAULT NULL COMMENT '当前砍后金额',
  `end_time` datetime DEFAULT NULL COMMENT '结束时限',
  `status` tinyint DEFAULT NULL COMMENT '砍价状态',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `fk_bargain_user` (`user_id`) USING BTREE,
  KEY `fk_bargain_product` (`product_id`) USING BTREE,
  KEY `fk_bargain_sku` (`sku_id`) USING BTREE,
  CONSTRAINT `fk_bargain_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_bargain_sku` FOREIGN KEY (`sku_id`) REFERENCES `sku` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_bargain_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='砍价活动表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `bargain_help_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bargain_help_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '帮砍记录ID',
  `bargain_record_id` bigint NOT NULL COMMENT '砍价记录ID，对应 bargain_activity.id',
  `helper_user_id` bigint NOT NULL COMMENT '帮砍用户ID',
  `cut_amount` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '本次帮砍金额',
  `before_price` decimal(10,2) DEFAULT NULL COMMENT '帮砍前价格',
  `after_price` decimal(10,2) DEFAULT NULL COMMENT '帮砍后价格',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '帮砍时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_bargain_helper` (`bargain_record_id`,`helper_user_id`),
  KEY `fk_bargain_help_user` (`helper_user_id`),
  CONSTRAINT `fk_bargain_help_record` FOREIGN KEY (`bargain_record_id`) REFERENCES `bargain_activity` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_bargain_help_user` FOREIGN KEY (`helper_user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='砍价帮砍记录表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `brand`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `brand` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '品牌ID（主键）',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '品牌名称',
  `logo` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '品牌Logo',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '品牌介绍',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5013 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='品牌表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `cart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cart` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '购物车ID（主键）',
  `user_id` bigint DEFAULT NULL COMMENT '用户ID',
  `sku_id` bigint DEFAULT NULL COMMENT 'SkuID',
  `quantity` int DEFAULT NULL COMMENT '购买数量',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `fk_cart_user` (`user_id`) USING BTREE,
  KEY `fk_cart_sku` (`sku_id`) USING BTREE,
  CONSTRAINT `fk_cart_sku` FOREIGN KEY (`sku_id`) REFERENCES `sku` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_cart_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='购物车表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `category` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '分类ID（主键）',
  `parent_id` bigint DEFAULT NULL COMMENT '上级分类ID',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '分类名称',
  `level` tinyint DEFAULT NULL COMMENT '层级等级',
  `sort_order` int DEFAULT NULL COMMENT '排序值',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=609 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='商品分类表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `commission_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `commission_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '流水ID（主键）',
  `distributor_id` bigint DEFAULT NULL COMMENT '收益人分销员ID',
  `order_id` bigint DEFAULT NULL COMMENT '关联交易触发订单ID',
  `order_amount` decimal(10,2) DEFAULT NULL COMMENT '计提基数总金额',
  `commission_amount` decimal(10,2) DEFAULT NULL COMMENT '本次分润佣金金额',
  `status` tinyint DEFAULT NULL COMMENT '清算状态',
  `settlement_time` datetime DEFAULT NULL COMMENT '入账钱包清算时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `fk_comm_distributor` (`distributor_id`) USING BTREE,
  KEY `fk_comm_order` (`order_id`) USING BTREE,
  CONSTRAINT `fk_comm_distributor` FOREIGN KEY (`distributor_id`) REFERENCES `distributor` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_comm_order` FOREIGN KEY (`order_id`) REFERENCES `order` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='佣金流水结算表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `coupon`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `coupon` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '优惠券ID（主键）',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '优惠券名称',
  `type` tinyint DEFAULT NULL COMMENT '适用类型（1=满减）',
  `min_consume` decimal(10,2) DEFAULT NULL COMMENT '满减门槛金额',
  `discount_amount` decimal(10,2) DEFAULT NULL COMMENT '面值抵扣金额',
  `total_count` int DEFAULT NULL COMMENT '发行总量',
  `received_count` int DEFAULT '0' COMMENT '已领取数量',
  `per_user_limit` tinyint DEFAULT NULL COMMENT '每人限领数量',
  `exchange_points` int DEFAULT '0' COMMENT '兑换所需积分',
  `validity_type` tinyint DEFAULT '1' COMMENT '有效期类型: 1=固定时间段, 2=领取后N天失效',
  `validity_days` int DEFAULT NULL COMMENT '有效期天数(validity_type=2时有效)',
  `member_level_required` tinyint DEFAULT '0' COMMENT '所需会员等级（0不限制）',
  `valid_start` datetime DEFAULT NULL COMMENT '有效期开始时间',
  `valid_end` datetime DEFAULT NULL COMMENT '有效期截止时间',
  `status` tinyint DEFAULT NULL COMMENT '状态（1启用）',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='优惠券主表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `coupon_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `coupon_user` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '领用记录ID（主键）',
  `coupon_id` bigint DEFAULT NULL COMMENT '优惠券模版ID',
  `user_id` bigint DEFAULT NULL COMMENT '持有用户ID',
  `order_id` bigint DEFAULT NULL COMMENT '核销抵扣订单ID',
  `status` tinyint DEFAULT NULL COMMENT '状态（0未使用 1已使用 2已过期）',
  `receive_time` datetime DEFAULT NULL COMMENT '领取时间',
  `use_time` datetime DEFAULT NULL COMMENT '使用核销时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `fk_coupon_template` (`coupon_id`) USING BTREE,
  KEY `fk_coupon_user` (`user_id`) USING BTREE,
  KEY `fk_coupon_order` (`order_id`) USING BTREE,
  CONSTRAINT `fk_coupon_order` FOREIGN KEY (`order_id`) REFERENCES `order` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_coupon_template` FOREIGN KEY (`coupon_id`) REFERENCES `coupon` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_coupon_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=114 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='优惠券领用记录表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `delivery`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `delivery` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '配送单ID（主键）',
  `order_id` bigint DEFAULT NULL COMMENT '订单ID',
  `delivery_sn` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '物流运单号',
  `dispatcher_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '配送员/骑手姓名',
  `dispatcher_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '配送员电话',
  `status` tinyint DEFAULT NULL COMMENT '配送状态',
  `start_time` datetime DEFAULT NULL COMMENT '出发时间',
  `end_time` datetime DEFAULT NULL COMMENT '送达时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '配送备注',
  `simulate_complete_time` datetime DEFAULT NULL COMMENT '模拟配送完成时间(2分钟后)',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `fk_delivery_order` (`order_id`) USING BTREE,
  CONSTRAINT `fk_delivery_order` FOREIGN KEY (`order_id`) REFERENCES `order` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=45 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='配送单表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `delivery_status_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `delivery_status_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志ID',
  `delivery_id` bigint NOT NULL COMMENT '配送单ID',
  `from_status` tinyint DEFAULT NULL COMMENT '变更前状态',
  `to_status` tinyint NOT NULL COMMENT '变更后状态',
  `status_text` varchar(50) DEFAULT NULL COMMENT '状态描述',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_delivery_id` (`delivery_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='配送状态流水表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `discount_rule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `discount_rule` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '满减满折规则ID',
  `title` varchar(100) DEFAULT NULL COMMENT '规则名称',
  `type` tinyint NOT NULL COMMENT '规则类型：1满减 2满折',
  `min_amount` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '满足金额门槛',
  `discount_amount` decimal(10,2) DEFAULT NULL COMMENT '满减金额',
  `discount_rate` decimal(5,2) DEFAULT NULL COMMENT '折扣比例，如8.50表示8.5折',
  `start_time` datetime DEFAULT NULL COMMENT '开始时间',
  `end_time` datetime DEFAULT NULL COMMENT '结束时间',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态：0禁用 1启用',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='满减满折规则表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `distributor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `distributor` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '分销员ID（主键）',
  `user_id` bigint DEFAULT NULL COMMENT '用户ID',
  `total_commission` decimal(10,2) DEFAULT NULL COMMENT '累计佣金',
  `frozen_commission` decimal(10,2) DEFAULT NULL COMMENT '冻结佣金',
  `status` tinyint DEFAULT NULL COMMENT '分销状态',
  `apply_time` datetime DEFAULT NULL COMMENT '申请时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `fk_distributor_user` (`user_id`) USING BTREE,
  CONSTRAINT `fk_distributor_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='分销员表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `file_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `file_record` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '文件ID',
  `owner_user_id` bigint NOT NULL COMMENT '上传用户ID',
  `upload_type` varchar(30) NOT NULL COMMENT '上传业务类型',
  `business_id` bigint DEFAULT NULL COMMENT '关联业务ID',
  `original_name` varchar(255) NOT NULL COMMENT '原文件名',
  `stored_path` varchar(500) NOT NULL COMMENT 'uploads目录下的相对路径',
  `file_size` bigint NOT NULL COMMENT '文件大小（字节）',
  `content_type` varchar(100) NOT NULL COMMENT '实际图片类型',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `is_deleted` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_file_stored_path` (`stored_path`),
  KEY `idx_file_owner` (`owner_user_id`,`is_deleted`),
  KEY `idx_file_business` (`upload_type`,`business_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='本地上传文件元数据';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `growth_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `growth_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志ID（主键）',
  `user_id` bigint DEFAULT NULL COMMENT '用户ID',
  `type` tinyint DEFAULT NULL COMMENT '来源渠道类型',
  `change_growth` int DEFAULT NULL COMMENT '变更成长值数额',
  `current_growth` int DEFAULT NULL COMMENT '最新累计总成长值',
  `remark` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '行为场景备注',
  `create_time` datetime DEFAULT NULL COMMENT '变动记录时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `fk_growth_log_user` (`user_id`) USING BTREE,
  CONSTRAINT `fk_growth_log_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='成长值变更日志表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `member`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `member` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '会员ID（主键）',
  `user_id` bigint NOT NULL,
  `member_level` tinyint NOT NULL DEFAULT '1',
  `points_balance` int NOT NULL DEFAULT '0',
  `growth_value` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_member_user` (`user_id`),
  KEY `fk_member_user` (`user_id`) USING BTREE,
  CONSTRAINT `fk_member_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='会员表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `merchant`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `merchant` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '商家ID（主键）',
  `user_id` bigint DEFAULT NULL COMMENT '关联用户ID',
  `merchant_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '商家名称',
  `logo` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '商家Logo',
  `contact_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '联系人',
  `contact_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '联系电话',
  `shop_address` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '店铺地址',
  `status` tinyint DEFAULT NULL COMMENT '营业状态',
  `business_hours` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '营业时间',
  `introduction` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '店铺介绍',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `fk_merchant_user` (`user_id`) USING BTREE,
  CONSTRAINT `fk_merchant_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2007 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='商家表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `merchant_apply`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `merchant_apply` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '申请ID（主键）',
  `user_id` bigint DEFAULT NULL COMMENT '申请人用户ID',
  `apply_type` tinyint DEFAULT NULL COMMENT '申请类型（1个人，2企业）',
  `company_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '企业/商家名称',
  `id_card_front` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '身份证正面图片',
  `id_card_back` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '身份证反面图片',
  `license_number` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '营业执照注册号',
  `license_image` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '营业执照图片',
  `food_permit_number` varchar(50) DEFAULT NULL COMMENT '食品经营许可证号',
  `food_permit_image` varchar(200) DEFAULT NULL COMMENT '食品许可证图片URL',
  `contact_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '联系人',
  `contact_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '联系电话',
  `shop_address` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '店铺地址',
  `shop_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '店铺名称',
  `audit_status` tinyint DEFAULT NULL COMMENT '审核状态',
  `audit_remark` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '审核备注',
  `audit_time` datetime DEFAULT NULL COMMENT '审核时间',
  `apply_time` datetime DEFAULT NULL COMMENT '提交时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `fk_merchant_apply_user` (`user_id`) USING BTREE,
  CONSTRAINT `fk_merchant_apply_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4007 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='商家入驻申请表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `merchant_coupon`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `merchant_coupon` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '商家券ID',
  `merchant_id` bigint NOT NULL COMMENT '商家ID',
  `title` varchar(100) NOT NULL COMMENT '券名称',
  `type` tinyint NOT NULL COMMENT '类型：1固定金额 2满减',
  `min_consume` decimal(10,2) DEFAULT '0.00' COMMENT '最低消费金额（固定金额卷使用门槛）',
  `discount_amount` decimal(10,2) DEFAULT NULL COMMENT '固定优惠金额（type=1时生效）',
  `total_count` int DEFAULT NULL COMMENT '发行总量',
  `received_count` int NOT NULL DEFAULT '0' COMMENT '已领取数量',
  `per_user_limit` int NOT NULL DEFAULT '1' COMMENT '每人限领',
  `validity_type` tinyint DEFAULT '1' COMMENT '有效期类型: 1=固定时间段, 2=领取后N天失效',
  `validity_days` int DEFAULT NULL COMMENT '有效期天数(validity_type=2时有效)',
  `valid_start` datetime DEFAULT NULL COMMENT '有效期开始',
  `valid_end` datetime DEFAULT NULL COMMENT '有效期结束',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '0禁用 1启用',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_merchant_id` (`merchant_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='商家优惠券模板表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `merchant_coupon_tier`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `merchant_coupon_tier` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '梯度ID',
  `coupon_id` bigint NOT NULL COMMENT '关联 merchant_coupon.id',
  `min_amount` decimal(10,2) NOT NULL COMMENT '满金额',
  `discount_amount` decimal(10,2) NOT NULL COMMENT '减金额',
  `sort_order` int NOT NULL DEFAULT '0' COMMENT '排序',
  PRIMARY KEY (`id`),
  KEY `idx_coupon_id` (`coupon_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='商家满减卷梯度表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `merchant_coupon_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `merchant_coupon_user` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '领用记录ID',
  `coupon_id` bigint NOT NULL COMMENT '商家券ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `order_id` bigint DEFAULT NULL COMMENT '核销订单ID',
  `status` tinyint DEFAULT '0' COMMENT '0未使用 1已使用 2已过期',
  `receive_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `use_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_coupon_id` (`coupon_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_order_id` (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='商家优惠券领取记录表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `merchant_earnings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `merchant_earnings` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '收益ID',
  `merchant_id` bigint NOT NULL COMMENT '商家ID',
  `order_id` bigint DEFAULT NULL COMMENT '订单ID',
  `order_sn` varchar(50) DEFAULT NULL COMMENT '订单编号',
  `amount` decimal(10,2) NOT NULL COMMENT '收益金额',
  `status` tinyint NOT NULL DEFAULT '0' COMMENT '状态 0-冻结中 1-可提现 2-已提现',
  `freeze_time` datetime DEFAULT NULL COMMENT '冻结时间(订单完成时间)',
  `unfreeze_time` datetime DEFAULT NULL COMMENT '解冻时间(冻结后4小时)',
  `withdraw_time` datetime DEFAULT NULL COMMENT '提现时间',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_merchant_id` (`merchant_id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='商家收益表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `merchant_info_change`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `merchant_info_change` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '变更ID',
  `merchant_id` bigint NOT NULL COMMENT '商家ID',
  `request_type` varchar(30) NOT NULL COMMENT '请求类型: INFO_CHANGE-信息修改, QUALIFICATION_UPGRADE-升级企业资质',
  `old_data` text COMMENT '旧数据(JSON)',
  `new_data` text COMMENT '新数据(JSON)',
  `audit_status` tinyint NOT NULL DEFAULT '0' COMMENT '审核状态: 0-待审核, 1-通过, 2-驳回',
  `audit_remark` varchar(500) DEFAULT NULL COMMENT '审核备注/理由',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `audit_time` datetime DEFAULT NULL COMMENT '审核时间',
  PRIMARY KEY (`id`),
  KEY `idx_merchant_id` (`merchant_id`),
  KEY `idx_audit_status` (`audit_status`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='商家信息变更审核表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `merchant_promotion_participation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `merchant_promotion_participation` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `merchant_id` bigint NOT NULL COMMENT '商家ID',
  `promotion_id` bigint NOT NULL COMMENT '促销活动ID',
  `status` tinyint NOT NULL DEFAULT '0' COMMENT '0未参与 1已参与',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_merchant_promotion` (`merchant_id`,`promotion_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='商家参与平台促销记录表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `merchant_qualification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `merchant_qualification` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '资质ID（主键）',
  `merchant_id` bigint DEFAULT NULL COMMENT '商家ID',
  `business_category` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '经营类目',
  `license_number` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '营业执照注册号',
  `license_image` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '营业执照图片',
  `food_permit_number` varchar(50) DEFAULT NULL COMMENT '食品经营许可证号',
  `food_permit_image` varchar(200) DEFAULT NULL COMMENT '食品许可证图片URL',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `fk_qualification_merchant` (`merchant_id`) USING BTREE,
  CONSTRAINT `fk_qualification_merchant` FOREIGN KEY (`merchant_id`) REFERENCES `merchant` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3007 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='商家资质表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `message_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `message_template` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '模板ID（主键）',
  `template_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '模板编码',
  `template_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '模板名称',
  `message_type` tinyint DEFAULT NULL COMMENT '消息类型（1站内信、2短信、3邮件）',
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '消息标题',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '消息模板内容',
  `status` tinyint DEFAULT NULL COMMENT '启用状态',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='消息通知模板表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `notice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notice` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '公告ID（主键）',
  `title` varchar(200) NOT NULL COMMENT '公告标题',
  `summary` varchar(500) DEFAULT NULL COMMENT '公告摘要',
  `content` text NOT NULL COMMENT '公告内容',
  `target_type` varchar(20) DEFAULT 'ALL' COMMENT '接收范围（USER=用户端，MERCHANT=商家端，ALL=全平台）',
  `status` tinyint DEFAULT '1' COMMENT '状态（0草稿，1已发布，2已下线）',
  `publish_time` datetime DEFAULT NULL COMMENT '发布时间',
  `expire_time` datetime DEFAULT NULL COMMENT '过期时间',
  `is_top` tinyint DEFAULT '0' COMMENT '是否置顶（0否 1是）',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_target_type` (`target_type`),
  KEY `idx_publish_time` (`publish_time`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='系统公告表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `notification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notification` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '通知ID',
  `user_id` bigint DEFAULT NULL COMMENT '目标用户ID（运营平台管理员）',
  `merchant_id` bigint DEFAULT NULL COMMENT '目标商家ID',
  `type` varchar(50) NOT NULL COMMENT '通知类型: AUDIT_RESULT/ORDER_STATUS/AFTERSALE_STATUS等',
  `title` varchar(200) DEFAULT NULL COMMENT '通知标题',
  `content` varchar(500) DEFAULT NULL COMMENT '通知内容',
  `is_read` tinyint NOT NULL DEFAULT '0' COMMENT '是否已读: 0未读 1已读',
  `related_id` bigint DEFAULT NULL COMMENT '关联业务ID',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_user_read` (`user_id`,`is_read`),
  KEY `idx_merchant_read` (`merchant_id`,`is_read`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='消息通知表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `operation_admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `operation_admin` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '运营管理员ID（主键）',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '登录账号',
  `password` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '登录密码（加密）',
  `real_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '真实姓名',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '联系电话',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '邮箱',
  `role` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '运营角色',
  `status` tinyint DEFAULT NULL COMMENT '账号状态',
  `last_login_time` datetime DEFAULT NULL COMMENT '最后登录时间',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='运营管理员信息表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '订单ID（主键）',
  `order_sn` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '订单编号',
  `user_id` bigint DEFAULT NULL COMMENT '用户ID',
  `merchant_id` bigint DEFAULT NULL COMMENT '商家ID',
  `pickup_point_id` bigint DEFAULT NULL COMMENT '自提点ID',
  `total_amount` decimal(10,2) DEFAULT NULL COMMENT '订单总价',
  `pay_amount` decimal(10,2) DEFAULT NULL COMMENT '应付金额',
  `discount_amount` decimal(10,2) DEFAULT '0.00' COMMENT '优惠金额',
  `delivery_type` tinyint DEFAULT NULL COMMENT '配送方式',
  `delivery_fee` decimal(10,2) DEFAULT '0.00' COMMENT '配送费',
  `seckill_discount` decimal(10,2) DEFAULT '0.00' COMMENT '秒杀优惠金额',
  `bargain_discount` decimal(10,2) DEFAULT '0.00' COMMENT '砍价优惠金额',
  `promotion_discount` decimal(10,2) DEFAULT '0.00' COMMENT '促销优惠金额',
  `status` tinyint DEFAULT NULL COMMENT '订单状态',
  `idempotent_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '幂等键',
  `used_points` int DEFAULT '0' COMMENT '使用积分',
  `points_status` tinyint DEFAULT '0' COMMENT '积分状态',
  `address_id` bigint DEFAULT NULL COMMENT '收货地址ID',
  `consignee` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '收货人',
  `consignee_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '收货人电话',
  `province` varchar(50) DEFAULT NULL COMMENT '省份快照',
  `city` varchar(50) DEFAULT NULL COMMENT '城市快照',
  `district` varchar(50) DEFAULT NULL COMMENT '区县快照',
  `detailed_address` varchar(200) DEFAULT NULL COMMENT '详细地址快照',
  `phone` varchar(20) DEFAULT NULL COMMENT '收货人电话快照',
  `consignee_address` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '收货地址快照',
  `coupon_user_id` bigint DEFAULT NULL COMMENT '优惠券领用ID',
  `merchant_coupon_user_id` bigint DEFAULT NULL COMMENT '使用的商家优惠券记录ID',
  `coupon_discount` decimal(10,2) DEFAULT '0.00' COMMENT '优惠券抵扣',
  `points_deduction` decimal(10,2) DEFAULT '0.00' COMMENT '积分抵扣金额',
  `merchant_coupon_discount` decimal(10,2) DEFAULT '0.00' COMMENT '商家优惠券抵扣金额',
  `seckill_id` bigint DEFAULT NULL COMMENT '秒杀活动ID',
  `bargain_id` bigint DEFAULT NULL COMMENT '砍价活动ID',
  `promotion_snapshot` text COMMENT '营销优惠快照JSON',
  `pay_method` tinyint DEFAULT NULL COMMENT '支付方式',
  `pay_expire_time` datetime DEFAULT NULL COMMENT '支付过期时间',
  `pay_time` datetime DEFAULT NULL COMMENT '支付时间',
  `cancel_time` datetime DEFAULT NULL COMMENT '取消时间',
  `create_time` datetime DEFAULT NULL COMMENT '下单时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `accept_time` datetime DEFAULT NULL COMMENT '接单时间',
  `prepare_time` datetime DEFAULT NULL COMMENT '备货完成时间',
  `complete_time` datetime DEFAULT NULL COMMENT '完成时间',
  `user_deleted` tinyint DEFAULT '0' COMMENT '用户删除标记',
  `pickup_code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '自提码',
  `remark` varchar(500) DEFAULT NULL COMMENT '订单备注',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `fk_order_user` (`user_id`) USING BTREE,
  KEY `fk_order_merchant` (`merchant_id`) USING BTREE,
  KEY `fk_order_pickup` (`pickup_point_id`) USING BTREE,
  CONSTRAINT `fk_order_merchant` FOREIGN KEY (`merchant_id`) REFERENCES `merchant` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_order_pickup` FOREIGN KEY (`pickup_point_id`) REFERENCES `pickup_point` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_order_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=98 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='订单主表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `order_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_item` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '明细ID（主键）',
  `order_id` bigint DEFAULT NULL COMMENT '订单ID',
  `product_id` bigint DEFAULT NULL COMMENT '商品ID',
  `sku_id` bigint DEFAULT NULL COMMENT 'SkuID',
  `product_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '商品快照名称',
  `product_image` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '商品图片快照',
  `sku_specs` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '规格快照',
  `origin_price` decimal(10,2) DEFAULT NULL COMMENT '商品原价',
  `price` decimal(10,2) DEFAULT NULL COMMENT '购买单价',
  `final_price` decimal(10,2) DEFAULT NULL COMMENT '最终单价',
  `quantity` int DEFAULT NULL COMMENT '购买数量',
  `item_origin_amount` decimal(10,2) DEFAULT NULL COMMENT '原价小计',
  `item_final_amount` decimal(10,2) DEFAULT NULL COMMENT '实付小计',
  `promotion_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT 'NORMAL' COMMENT '促销类型',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `fk_items_order` (`order_id`) USING BTREE,
  KEY `fk_items_sku` (`sku_id`) USING BTREE,
  CONSTRAINT `fk_items_order` FOREIGN KEY (`order_id`) REFERENCES `order` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_items_sku` FOREIGN KEY (`sku_id`) REFERENCES `sku` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=159 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='订单明细表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `order_status_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_status_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志ID',
  `order_id` bigint NOT NULL COMMENT '订单ID',
  `from_status` tinyint DEFAULT NULL COMMENT '变更前状态',
  `to_status` tinyint NOT NULL COMMENT '变更后状态',
  `status_text` varchar(50) DEFAULT NULL COMMENT '状态描述',
  `operator_type` varchar(20) DEFAULT NULL COMMENT '操作者类型 merchant/user/system',
  `operator_id` bigint DEFAULT NULL COMMENT '操作者ID',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_order_id` (`order_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='订单状态流水表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `payment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payment` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '支付ID（主键）',
  `order_id` bigint DEFAULT NULL COMMENT '订单ID',
  `pay_sn` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '支付流水号',
  `third_trade_no` varchar(100) DEFAULT NULL COMMENT '第三方支付交易号，如支付宝trade_no',
  `pay_platform` tinyint DEFAULT NULL COMMENT '支付通道',
  `amount` decimal(10,2) DEFAULT NULL COMMENT '实际支付金额',
  `status` tinyint DEFAULT NULL COMMENT '支付状态',
  `pay_time` datetime DEFAULT NULL COMMENT '支付成功时间',
  `callback_time` datetime DEFAULT NULL COMMENT '支付回调时间',
  `fail_reason` varchar(255) DEFAULT NULL COMMENT '支付失败原因',
  `refund_status` tinyint DEFAULT '0' COMMENT '退款状态',
  `refund_amount` decimal(10,2) DEFAULT '0.00' COMMENT '退款金额',
  `refund_time` datetime DEFAULT NULL COMMENT '退款时间',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_payment_pay_sn` (`pay_sn`),
  KEY `fk_payment_order` (`order_id`) USING BTREE,
  KEY `idx_payment_order_id` (`order_id`),
  KEY `idx_payment_status` (`status`),
  CONSTRAINT `fk_payment_order` FOREIGN KEY (`order_id`) REFERENCES `order` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=85 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='支付记录表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `pickup_point`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pickup_point` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '自提点ID（主键）',
  `merchant_id` bigint DEFAULT NULL COMMENT '所属商家ID',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '自提点名称',
  `address` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '自提点详细地址',
  `contact_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '联系电话',
  `business_hours` varchar(100) DEFAULT NULL COMMENT '营业时间',
  `status` tinyint DEFAULT NULL COMMENT '营业状态',
  `audit_status` tinyint DEFAULT NULL COMMENT '审核状态',
  `audit_remark` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '审核备注',
  `audit_time` datetime DEFAULT NULL COMMENT '审核通过时间',
  `image` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '自提点照片',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `fk_pickup_merchant` (`merchant_id`) USING BTREE,
  CONSTRAINT `fk_pickup_merchant` FOREIGN KEY (`merchant_id`) REFERENCES `merchant` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='自提点表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `platform_account_summary`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `platform_account_summary` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `total_revenue` decimal(14,2) NOT NULL DEFAULT '0.00' COMMENT '总收入',
  `total_expenditure` decimal(14,2) NOT NULL DEFAULT '0.00' COMMENT '总支出',
  `net_profit` decimal(14,2) NOT NULL DEFAULT '0.00' COMMENT '净收益',
  `frozen_amount` decimal(14,2) NOT NULL DEFAULT '0.00' COMMENT '冻结金额（待结算订单）',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='平台账户汇总表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `platform_promotion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `platform_promotion` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '活动ID',
  `title` varchar(100) NOT NULL COMMENT '活动名称',
  `start_time` datetime NOT NULL COMMENT '开始时间',
  `end_time` datetime NOT NULL COMMENT '结束时间',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态：0已关闭 1进行中',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='平台促销活动表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `platform_promotion_tier`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `platform_promotion_tier` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '梯度ID',
  `promotion_id` bigint NOT NULL COMMENT '关联 platform_promotion.id',
  `min_amount` decimal(10,2) NOT NULL COMMENT '满金额',
  `discount_amount` decimal(10,2) NOT NULL COMMENT '减金额',
  `sort_order` int NOT NULL DEFAULT '0' COMMENT '排序（越小越优先匹配）',
  PRIMARY KEY (`id`),
  KEY `idx_promotion_id` (`promotion_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='平台促销梯度表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `platform_revenue_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `platform_revenue_detail` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '流水ID',
  `order_id` bigint DEFAULT NULL COMMENT '关联订单ID',
  `merchant_id` bigint DEFAULT NULL COMMENT '关联商家ID',
  `type` varchar(50) NOT NULL COMMENT '类型：commission佣金收入/coupon_subsidy平台贴补/service_fee服务费/other',
  `amount` decimal(10,2) NOT NULL COMMENT '金额（正=收入 负=支出）',
  `description` varchar(500) DEFAULT NULL COMMENT '描述',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_order_id` (`order_id`),
  KEY `idx_merchant_id` (`merchant_id`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB AUTO_INCREMENT=1057 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='平台流水明细表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `points_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `points_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志ID（主键）',
  `user_id` bigint DEFAULT NULL COMMENT '用户ID',
  `type` tinyint DEFAULT NULL COMMENT '变更动作类型',
  `change_points` int DEFAULT NULL COMMENT '变动积分值',
  `current_points` int DEFAULT NULL COMMENT '变动后余额',
  `remark` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '事务场景备注',
  `create_time` datetime DEFAULT NULL COMMENT '记录生成时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `fk_points_log_user` (`user_id`) USING BTREE,
  CONSTRAINT `fk_points_log_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=62 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='积分变更日志表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `poster`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `poster` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '海报ID（主键）',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '海报主题模板名称',
  `bg_image` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '背景原图素材URL',
  `qr_code_config` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '二维码动态图层配置参数',
  `status` tinyint DEFAULT NULL COMMENT '使用状态',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='裂变海报配置表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '商品ID（主键）',
  `brand_id` bigint DEFAULT NULL COMMENT '品牌ID',
  `merchant_id` bigint DEFAULT NULL COMMENT '商家ID',
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '商品名称',
  `sub_title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '副标题',
  `main_image` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '商品主图',
  `detail_desc` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '详情描述',
  `detail_images` text COMMENT '详情图片(JSON数组)',
  `sale_type` tinyint DEFAULT NULL COMMENT '销售模式（自提/配送）',
  `status` tinyint DEFAULT NULL COMMENT '上架状态',
  `audit_status` tinyint DEFAULT NULL COMMENT '审核状态(0待审/1通过/2拒绝)',
  `audit_remark` varchar(200) DEFAULT NULL COMMENT '审核备注',
  `audit_time` datetime DEFAULT NULL COMMENT '审核时间',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `sold_count` bigint NOT NULL DEFAULT '0' COMMENT '已售数量',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `fk_product_brand` (`brand_id`) USING BTREE,
  KEY `fk_product_merchant` (`merchant_id`) USING BTREE,
  CONSTRAINT `fk_product_brand` FOREIGN KEY (`brand_id`) REFERENCES `brand` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_product_merchant` FOREIGN KEY (`merchant_id`) REFERENCES `merchant` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6025 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='商品主表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `product_category_relation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_category_relation` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '记录ID（主键）',
  `product_id` bigint DEFAULT NULL COMMENT '商品ID',
  `category_id` bigint DEFAULT NULL COMMENT '分类ID',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `fk_pcr_product` (`product_id`) USING BTREE,
  KEY `fk_pcr_category` (`category_id`) USING BTREE,
  CONSTRAINT `fk_pcr_category` FOREIGN KEY (`category_id`) REFERENCES `category` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_pcr_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7025 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='商品分类中间表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `product_comment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_comment` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '评价ID（主键）',
  `order_item_id` bigint DEFAULT NULL COMMENT '订单明细ID',
  `product_id` bigint DEFAULT NULL COMMENT '商品ID',
  `user_id` bigint DEFAULT NULL COMMENT '用户ID',
  `score` tinyint DEFAULT NULL COMMENT '评分（1~5分）',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '评价内容',
  `images` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '评价图片',
  `anonymous` tinyint DEFAULT NULL COMMENT '是否匿名',
  `create_time` datetime DEFAULT NULL COMMENT '评价时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `fk_product_comment_order_item` (`order_item_id`) USING BTREE,
  KEY `fk_product_comment_product` (`product_id`) USING BTREE,
  KEY `fk_product_comment_user` (`user_id`) USING BTREE,
  CONSTRAINT `fk_product_comment_order_item` FOREIGN KEY (`order_item_id`) REFERENCES `order_item` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_product_comment_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_product_comment_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='商品评价表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `recommendation_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recommendation_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '推荐流水ID（主键）',
  `user_id` bigint DEFAULT NULL COMMENT '推荐目标触达用户ID',
  `scene` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '算法展示前台场景栏位',
  `recommended_product_ids` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '下发推荐Spu集快照串',
  `feedback_type` tinyint DEFAULT NULL COMMENT '实际漏斗闭环反馈效果',
  `log_time` datetime DEFAULT NULL COMMENT '推荐曝光展示时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `fk_recomm_user` (`user_id`) USING BTREE,
  CONSTRAINT `fk_recomm_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='个性化算法推荐结果记录表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `seckill_activity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `seckill_activity` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '活动ID（主键）',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '活动名称',
  `start_time` datetime DEFAULT NULL COMMENT '开始时间',
  `end_time` datetime DEFAULT NULL COMMENT '结束时间',
  `status` tinyint DEFAULT NULL COMMENT '活动状态',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_seckill_activity_time` (`start_time`,`end_time`,`status`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='秒杀活动表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `seckill_product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `seckill_product` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '秒杀关联ID（主键）',
  `seckill_activity_id` bigint DEFAULT NULL COMMENT '秒杀活动ID',
  `product_id` bigint DEFAULT NULL COMMENT '商品SpuID',
  `sku_id` varchar(100) DEFAULT NULL COMMENT '商品SKU码(支持字母数字-)',
  `seckill_price` decimal(10,2) DEFAULT NULL COMMENT '秒杀专享价',
  `seckill_stock` int DEFAULT NULL COMMENT '秒杀专享库存',
  `sold_count` int DEFAULT '0' COMMENT '已售数量',
  `limit_quantity` tinyint DEFAULT NULL COMMENT '每人限购数量',
  `status` tinyint DEFAULT NULL COMMENT '状态（1启用）',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_seckill_activity_sku` (`seckill_activity_id`,`sku_id`),
  KEY `fk_seckill_act` (`seckill_activity_id`) USING BTREE,
  KEY `fk_seckill_product` (`product_id`) USING BTREE,
  KEY `idx_seckill_product_activity_status` (`seckill_activity_id`,`status`),
  CONSTRAINT `fk_seckill_act` FOREIGN KEY (`seckill_activity_id`) REFERENCES `seckill_activity` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_seckill_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='秒杀商品表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `share_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `share_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志ID（主键）',
  `user_id` bigint DEFAULT NULL COMMENT '分享人用户ID',
  `target_type` tinyint DEFAULT NULL COMMENT '传播媒介类型（商品/活动）',
  `target_id` bigint DEFAULT NULL COMMENT '关联媒介实体物理ID',
  `share_channel` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '触达渠道分发媒介',
  `share_time` datetime DEFAULT NULL COMMENT '分享动作触发时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `fk_share_user` (`user_id`) USING BTREE,
  CONSTRAINT `fk_share_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='推广分享日志表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sku`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sku` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'SkuID（主键）',
  `product_id` bigint DEFAULT NULL COMMENT '商品ID',
  `specs` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '规格属性(JSON格式)',
  `price` decimal(10,2) DEFAULT NULL COMMENT '销售价格',
  `stock` int DEFAULT NULL COMMENT '物理库存',
  `sku_code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'SKU编码',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `fk_sku_product` (`product_id`) USING BTREE,
  CONSTRAINT `fk_sku_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8025 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='商品规格库存表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `system_admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `system_admin` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '系统管理员ID（主键）',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '登录账号',
  `password` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '登录密码（加密）',
  `real_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '管理员姓名',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '联系电话',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '邮箱',
  `role` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '系统角色',
  `status` tinyint DEFAULT NULL COMMENT '账号状态',
  `last_login_time` datetime DEFAULT NULL COMMENT '最后登录时间',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='系统管理员信息表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `system_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `system_config` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '参数ID（主键）',
  `config_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '参数键（唯一）',
  `config_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '参数名称',
  `config_value` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '参数值',
  `value_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '参数类型',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '参数说明',
  `is_system` tinyint DEFAULT NULL COMMENT '是否系统内置（0否，1是）',
  `status` tinyint DEFAULT NULL COMMENT '参数状态（0禁用，1启用）',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='系统参数配置表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID（主键）',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '手机号',
  `nickname` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '昵称',
  `password` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '密码',
  `avatar` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '头像',
  `sex` tinyint DEFAULT NULL COMMENT '性别',
  `status` tinyint DEFAULT NULL COMMENT '账号状态',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1026 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='用户表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `user_behavior_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_behavior_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志ID（主键）',
  `user_id` bigint DEFAULT NULL COMMENT '埋点主体用户ID',
  `behavior_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '动作词属性编码',
  `target_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '交互模块名称',
  `target_id` bigint DEFAULT NULL COMMENT '资源物理主键ID',
  `duration` int DEFAULT NULL COMMENT '页面停留时长(秒)',
  `log_time` datetime DEFAULT NULL COMMENT '轨迹触发时间戳',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `fk_behavior_user` (`user_id`) USING BTREE,
  CONSTRAINT `fk_behavior_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='用户行为埋点日志表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `user_binding`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_binding` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '关系ID（主键）',
  `user_id` bigint DEFAULT NULL COMMENT '当前用户ID',
  `inviter_id` bigint DEFAULT NULL COMMENT '推荐人用户ID',
  `binding_time` datetime DEFAULT NULL COMMENT '锁粉绑定时间',
  `binding_type` tinyint DEFAULT NULL COMMENT '绑定方式',
  `status` tinyint DEFAULT NULL COMMENT '绑定状态',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `fk_user_binding_user` (`user_id`) USING BTREE,
  KEY `fk_user_binding_inviter` (`inviter_id`) USING BTREE,
  CONSTRAINT `fk_user_binding_inviter` FOREIGN KEY (`inviter_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_user_binding_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='用户锁粉推荐关系表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `user_message`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_message` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '消息ID（主键）',
  `user_id` bigint DEFAULT NULL COMMENT '用户ID',
  `template_id` bigint DEFAULT NULL COMMENT '消息模板ID',
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '消息标题',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '消息内容',
  `is_read` tinyint DEFAULT NULL COMMENT '是否已读',
  `send_time` datetime DEFAULT NULL COMMENT '发送时间',
  `read_time` datetime DEFAULT NULL COMMENT '阅读时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `fk_user_message_user` (`user_id`) USING BTREE,
  KEY `fk_user_message_template` (`template_id`) USING BTREE,
  CONSTRAINT `fk_user_message_template` FOREIGN KEY (`template_id`) REFERENCES `message_template` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_user_message_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='用户站内消息接收表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `user_tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_tag` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '标签记录ID（主键）',
  `user_id` bigint DEFAULT NULL COMMENT '指向描摹用户ID',
  `tag_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '标签名称字符串',
  `weight` decimal(5,2) DEFAULT NULL COMMENT '数仓偏好模型置信度权重',
  `update_time` datetime DEFAULT NULL COMMENT '模型刷算计算时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `fk_tag_user` (`user_id`) USING BTREE,
  CONSTRAINT `fk_tag_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='用户画像标签表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `user_wallet`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_wallet` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '钱包ID（主键）',
  `user_id` bigint DEFAULT NULL COMMENT '用户ID',
  `balance` decimal(10,2) DEFAULT NULL COMMENT '可用余额',
  `frozen_amount` decimal(10,2) DEFAULT NULL COMMENT '冻结金额',
  `total_income` decimal(10,2) DEFAULT NULL COMMENT '累计收入',
  `total_expenditure` decimal(10,2) DEFAULT NULL COMMENT '累计支出',
  `status` tinyint DEFAULT NULL COMMENT '钱包状态',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `fk_user_wallet_user` (`user_id`) USING BTREE,
  CONSTRAINT `fk_user_wallet_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='用户/分销商虚拟钱包表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `withdrawal_apply`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `withdrawal_apply` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '提现申请ID（主键）',
  `wallet_id` bigint DEFAULT NULL COMMENT '钱包ID',
  `user_id` bigint DEFAULT NULL COMMENT '提现用户ID',
  `apply_amount` decimal(10,2) DEFAULT NULL COMMENT '提现金额',
  `account_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '收款人姓名',
  `account_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '收款账号',
  `bank_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '开户银行',
  `audit_status` tinyint DEFAULT NULL COMMENT '审核状态',
  `audit_time` datetime DEFAULT NULL COMMENT '审核时间',
  `remark` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '审核备注',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `fk_withdrawal_wallet` (`wallet_id`) USING BTREE,
  KEY `fk_withdrawal_user` (`user_id`) USING BTREE,
  CONSTRAINT `fk_withdrawal_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_withdrawal_wallet` FOREIGN KEY (`wallet_id`) REFERENCES `user_wallet` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='提现申请审批表';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `withdrawal_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `withdrawal_record` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '提现ID',
  `merchant_id` bigint NOT NULL COMMENT '商家ID',
  `amount` decimal(10,2) NOT NULL COMMENT '提现金额',
  `bank_card_number` varchar(50) NOT NULL COMMENT '银行卡号',
  `account_name` varchar(50) NOT NULL COMMENT '开户人姓名',
  `bank_name` varchar(100) DEFAULT NULL COMMENT '银行名称',
  `status` tinyint NOT NULL DEFAULT '0' COMMENT '状态 0-处理中 1-已汇款 2-失败',
  `remark` varchar(500) DEFAULT NULL COMMENT '处理备注',
  `apply_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '申请时间',
  `process_time` datetime DEFAULT NULL COMMENT '处理时间',
  PRIMARY KEY (`id`),
  KEY `idx_merchant_id` (`merchant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='提现申请表';
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;


SET FOREIGN_KEY_CHECKS=1;