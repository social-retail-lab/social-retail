-- MySQL dump 10.13  Distrib 8.0.39, for Win64 (x86_64)
--
-- Host: localhost    Database: social_retail_db
-- ------------------------------------------------------
-- Server version	8.0.39

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

--
-- Current Database: `social_retail_db`
--

/*!40000 DROP DATABASE IF EXISTS `social_retail_db`*/;

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `social_retail_db` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `social_retail_db`;

--
-- Table structure for table `address`
--

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

--
-- Dumping data for table `address`
--

LOCK TABLES `address` WRITE;
/*!40000 ALTER TABLE `address` DISABLE KEYS */;
INSERT INTO `address` VALUES (1,1004,'赵四商家','17782224503','重庆市','重庆市','渝北区','龙山大道168号',1),(2,1007,'陈二','17782224506','重庆市','重庆市','南岸区','南滨路88号',1),(3,1007,'陈二','17782224506','重庆市','重庆市','南岸区','学府大道22号',0),(4,1008,'王一','17782224507','重庆市','重庆市','江北区','观音桥步行街9号',1),(5,1008,'王一','17782224507','重庆市','重庆市','江北区','建新东路56号',0),(6,1009,'李二','17782224508','重庆市','重庆市','沙坪坝区','三峡广场1号',1),(7,1009,'李二','17782224508','重庆市','重庆市','沙坪坝区','大学城中路20号',0),(8,1010,'赵一','17782224509','重庆市','重庆市','九龙坡区','杨家坪正街12号',1),(9,1010,'赵一','17782224509','重庆市','重庆市','九龙坡区','石桥铺科园一路30号',0),(10,1011,'孙小红','17782224510','重庆市','重庆市','渝中区','解放碑步行街88号',1),(11,1011,'孙小红','17782224510','重庆市','重庆市','渝中区','大坪正街45号',0),(12,1012,'周小明','17782224511','重庆市','重庆市','巴南区','龙洲大道100号',1),(13,1012,'周小明','17782224511','重庆市','重庆市','巴南区','鱼洞街道15号',0),(14,1013,'吴小丽','17782224512','重庆市','重庆市','大渡口区','春晖路街道58号',1),(15,1013,'吴小丽','17782224512','重庆市','重庆市','大渡口区','九宫庙商圈12号',0),(16,1014,'郑小刚','17782224513','重庆市','重庆市','北碚区','天生路2号',1),(17,1014,'郑小刚','17782224513','重庆市','重庆市','北碚区','云华路200号',0),(18,1015,'冯小美','17782224514','重庆市','重庆市','渝北区','新南路168号',1),(19,1015,'冯小美','17782224514','重庆市','重庆市','渝北区','金开大道66号',0),(20,1016,'褚小强','17782224515','重庆市','重庆市','南岸区','弹子石新街33号',1),(21,1016,'褚小强','17782224515','重庆市','重庆市','南岸区','茶园新区99号',0),(22,1017,'蒋小芳','17782224516','重庆市','重庆市','江北区','北滨一路55号',1),(23,1018,'韩小龙','17782224517','重庆市','重庆市','沙坪坝区','小龙坎正街76号',1),(24,1019,'杨小燕','17782224518','重庆市','重庆市','九龙坡区','西郊路10号',1),(25,1020,'朱小杰','17782224519','重庆市','重庆市','渝中区','石油路街道120号',1),(26,1021,'秦小慧','17782224520','重庆市','重庆市','巴南区','李家沱正街88号',1),(27,1022,'许小东','17782224521','重庆市','重庆市','大渡口区','钢花路60号',1),(28,1023,'何小琴','17782224522','重庆市','重庆市','北碚区','城南新区18号',1),(29,1024,'吕小伟','17782224523','重庆市','重庆市','南岸区','四公里街200号',1),(30,1025,'施小玲','17782224524','重庆市','重庆市','渝北区','黄泥磅街道35号',1);
/*!40000 ALTER TABLE `address` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `after_sale`
--

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

--
-- Dumping data for table `after_sale`
--

LOCK TABLES `after_sale` WRITE;
/*!40000 ALTER TABLE `after_sale` DISABLE KEYS */;
INSERT INTO `after_sale` VALUES (1,51,91,2001,'202605051030010001',2,1,77.00,77.00,'收到的坚果礼盒包装破损，内部独立小包有多袋漏气，与商品详情页展示的完好包装严重不符','[\"/static/product/6001.jpg\"]','三只松鼠每日坚果30包礼盒','{\"规格\":\"30包装\",\"净重\":\"600g-750g\"}',4,0,0,'已审核通过，退款成功',NULL,'2026-05-09 14:30:00',1,'2026-05-09 10:00:00','2026-05-10 09:00:00','2026-07-04 09:21:57','退款已到账，处理满意',NULL,0,'2026-05-07 10:00:00'),(2,65,110,2001,'202605251650020015',1,1,77.00,NULL,'下单后发现同款商品在别的平台有更优惠的价格，商品尚未发货故申请仅退款',NULL,'三只松鼠每日坚果30包礼盒','{\"规格\":\"30包装\",\"净重\":\"600g-750g\"}',1,0,0,NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-04 09:21:57',NULL,'',0,'2026-07-03 16:00:00'),(3,72,123,2003,'202606071630020022',2,1,85.00,NULL,'到货后发现实际为25袋装而非下单时标注的30袋装，包装规格与商品描述不符','[\"/static/product/6012.jpg\"]','沃隆每日坚果750g30袋','{\"规格\":\"750g 30袋\",\"品种\":\"混合坚果\"}',2,0,0,'同意退货，请寄回商品',NULL,'2026-06-11 11:20:00',0,NULL,NULL,'2026-07-04 09:21:57',NULL,'',0,'2026-06-10 09:00:00'),(4,58,102,2001,'202605141025010008',1,1,35.90,NULL,'下单时误选了500g大包装规格，原计划购买200g小包装，商品尚未拆封希望退货','[\"/static/product/6003.jpg\"]','良品铺子芒果干500g','{\"规格\":\"500g\",\"口味\":\"原味\"}',5,0,0,'抱歉，已超过售后时效','您的订单已确认收货超过7天，根据平台售后规则暂不支持退款申请。建议下次购买前仔细核对商品规格，给您带来不便深表歉意。','2026-05-17 10:00:00',NULL,NULL,NULL,'2026-07-04 09:21:57','售后被拒，理由不合理','',0,'2026-05-16 08:00:00'),(5,80,134,2002,'202606171130010030',2,1,59.70,NULL,'快递外箱完好但内部有两包卫龙大面筋包装袋破裂，调味红油渗出污染了其余8包商品，附有开箱视频为证','[\"/static/product/6005.jpg\"]','卫龙大面筋68g*10包','{\"规格\":\"68g*10包\",\"口味\":\"香辣味\"}',3,0,0,'同意退货，请尽快寄回',NULL,'2026-06-21 16:00:00',1,'2026-06-21 16:00:00',NULL,'2026-07-04 09:21:57',NULL,'',0,'2026-06-20 10:00:00'),(6,89,146,2001,'202606291005010039',1,1,26.00,26.00,'虎皮风爪口感偏硬嚼不动，且部分鸡爪有明显腥味未处理干净，与宣传的\"鲜香软糯\"品质差距较大','[\"/static/product/6002.jpg\"]','三只松鼠虎皮风爪袋装','{\"规格\":\"袋装\",\"净重\":\"200g\"}',4,0,0,'已审核通过，退款成功',NULL,'2026-07-02 09:00:00',NULL,NULL,'2026-07-02 09:00:00','2026-07-04 09:21:57','处理速度很快','',0,'2026-07-01 10:00:00'),(7,52,92,2002,'202605061420010002',2,1,39.80,39.80,'商品完全未拆封，仍在七天无理由退货时效范围内，因个人口味偏好原因申请退货退款','[\"/static/product/6005.jpg\"]','卫龙大面筋68g*10包','{\"规格\":\"68g*10包\",\"口味\":\"香辣味\"}',4,0,0,'已审核通过，退款成功',NULL,'2026-05-10 09:30:00',1,'2026-05-10 09:00:00','2026-05-11 10:00:00','2026-07-04 09:21:57','收到退款','',0,'2026-05-08 10:00:00'),(8,60,104,2006,'202605181520010010',1,1,65.00,NULL,'购买后发现家人已从超市购买了同款白桃气泡水两箱，为避免囤积浪费故申请未使用部分的退款','[\"/static/product/6021.jpg\"]','元气森林白桃气泡水480ml*15瓶','{\"规格\":\"480ml*15瓶\",\"口味\":\"白桃味\"}',5,0,0,'订单已完成超7天，不支持退款','您的订单已确认收货且超过七天无理由退货时效，平台暂不支持该笔退款申请。感谢您的理解与支持，祝您生活愉快。','2026-05-28 09:00:00',NULL,NULL,NULL,'2026-07-04 09:21:57','商家拒绝理由牵强，商品实际签收仅第4天就申请售后，不应被拒','',0,'2026-05-26 08:00:00');
/*!40000 ALTER TABLE `after_sale` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bargain_activity`
--

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

--
-- Dumping data for table `bargain_activity`
--

LOCK TABLES `bargain_activity` WRITE;
/*!40000 ALTER TABLE `bargain_activity` DISABLE KEYS */;
/*!40000 ALTER TABLE `bargain_activity` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bargain_help_log`
--

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

--
-- Dumping data for table `bargain_help_log`
--

LOCK TABLES `bargain_help_log` WRITE;
/*!40000 ALTER TABLE `bargain_help_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `bargain_help_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `brand`
--

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

--
-- Dumping data for table `brand`
--

LOCK TABLES `brand` WRITE;
/*!40000 ALTER TABLE `brand` DISABLE KEYS */;
INSERT INTO `brand` VALUES (5001,'三只松鼠','/static/brand/5001.jpg','互联网坚果零食第一品牌',NULL),(5002,'良品铺子','/static/brand/5002.jpg','高端全品类零食连锁标杆品牌',NULL),(5003,'卫龙','/static/brand/5003.jpg','国民辣味调味零食第一品牌',NULL),(5004,'旺旺','/static/brand/5004.jpg','国民童年米果零食经典龙头',NULL),(5005,'奉节脐橙','/static/brand/5005.jpg','重庆地标鲜果品牌',NULL),(5006,'沃隆','/static/brand/5006.jpg','每日坚果原创开创品牌',NULL),(5007,'金龙鱼','/static/brand/5007.jpg','国民粮油龙头品牌',NULL),(5008,'涪陵榨菜','/static/brand/5008.jpg','世界三大名腌菜之一',NULL),(5009,'绝味鸭脖','/static/brand/5009.jpg','全国连锁卤味熟食龙头品牌',NULL),(5010,'有友','/static/brand/5010.jpg','重庆本土卤味零食品牌',NULL),(5011,'元气森林','/static/brand/5011.jpg','零糖气泡水健康饮品新锐头部品牌',NULL),(5012,'农夫山泉','/static/brand/5012.jpg','国民天然饮用水果汁龙头',NULL);
/*!40000 ALTER TABLE `brand` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cart`
--

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

--
-- Dumping data for table `cart`
--

LOCK TABLES `cart` WRITE;
/*!40000 ALTER TABLE `cart` DISABLE KEYS */;
INSERT INTO `cart` VALUES (1,1007,8003,2),(2,1008,8005,1),(3,1009,8012,1),(4,1010,8001,3),(5,1011,8017,2),(6,1012,8021,1),(7,1013,8010,1),(8,1014,8006,4),(9,1015,8013,1),(10,1016,8023,2),(11,1017,8008,3),(12,1018,8019,1),(13,1019,8002,2),(14,1020,8014,5),(15,1021,8024,2);
/*!40000 ALTER TABLE `cart` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `category`
--

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

--
-- Dumping data for table `category`
--

LOCK TABLES `category` WRITE;
/*!40000 ALTER TABLE `category` DISABLE KEYS */;
INSERT INTO `category` VALUES (1,0,'生鲜果蔬肉禽',1,1),(2,0,'食品饮料滋补',1,2),(3,0,'家居百货日用品',1,3),(4,0,'厨具餐具厨房配件',1,4),(5,0,'个护美妆清洁',1,5),(6,0,'母婴孕童用品',1,6),(101,1,'新鲜水果',2,1),(102,1,'时令蔬菜',2,2),(103,1,'猪牛羊肉',2,3),(104,1,'海鲜水产',2,4),(105,1,'禽肉蛋品',2,5),(106,1,'冷冻速食',2,6),(107,1,'熟食卤味',2,7),(108,1,'甜品饮品',2,8),(201,2,'休闲零食',2,1),(202,2,'粮油米面调味',2,2),(203,2,'酒水饮料冲调',2,3),(204,2,'进口零食酒水',2,4),(205,2,'地方特产礼盒',2,5),(206,2,'茗茶茶饮',2,6),(207,2,'保健食品滋补品',2,7),(208,2,'食品礼券礼盒',2,8),(301,3,'家纺床品毛巾',2,1),(302,3,'灯具照明',2,2),(303,3,'收纳储物用品',2,3),(304,3,'清洁消杀纸品',2,4),(305,3,'浴室洗漱用品',2,5),(306,3,'雨伞雨具防护',2,6),(307,3,'洗晒熨烫工具',2,7),(308,3,'装饰摆件花艺',2,8),(309,3,'宠物全品类',2,9),(401,4,'烹饪锅具',2,1),(402,4,'刀剪菜板工具',2,2),(403,4,'水杯酒具茶具',2,3),(404,4,'碗盘餐具',2,4),(405,4,'厨房小配件',2,5),(406,4,'商用酒店厨具',2,6),(501,5,'面部护肤',2,1),(502,5,'身体洗护沐浴',2,2),(503,5,'洗发护发',2,3),(504,5,'口腔护理',2,4),(505,5,'女性卫生巾护理',2,5),(506,5,'香水彩妆',2,6),(601,6,'婴幼儿奶粉',2,1),(602,6,'辅食营养零食',2,2),(603,6,'尿裤湿巾',2,3),(604,6,'喂养餐具器具',2,4),(605,6,'宝宝洗护用品',2,5),(606,6,'童装童鞋寝具',2,6),(607,6,'孕妈妈妈专区',2,7),(608,6,'童车安全座椅',2,8);
/*!40000 ALTER TABLE `category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `commission_log`
--

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

--
-- Dumping data for table `commission_log`
--

LOCK TABLES `commission_log` WRITE;
/*!40000 ALTER TABLE `commission_log` DISABLE KEYS */;
INSERT INTO `commission_log` VALUES (1,1,54,48.90,4.89,1,'2026-05-15 10:00:00'),(2,1,89,103.00,10.30,1,'2026-07-01 10:00:00'),(3,2,57,84.90,8.49,1,'2026-05-20 10:00:00'),(4,2,82,84.90,8.49,0,NULL),(5,1,73,29.90,2.99,0,NULL),(6,2,71,58.80,5.88,0,NULL);
/*!40000 ALTER TABLE `commission_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `coupon`
--

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

--
-- Dumping data for table `coupon`
--

LOCK TABLES `coupon` WRITE;
/*!40000 ALTER TABLE `coupon` DISABLE KEYS */;
INSERT INTO `coupon` VALUES (1,'新人大礼包 满50减10',1,50.00,10.00,500,180,1,0,1,NULL,0,'2026-05-01 00:00:00','2026-07-31 23:59:59',1,'2026-05-01 00:00:00',NULL),(2,'5月狂欢 满100减20',1,100.00,20.00,300,95,1,100,1,NULL,0,'2026-05-05 00:00:00','2026-05-31 23:59:59',0,'2026-05-01 00:00:00',NULL),(3,'端午特惠 满80减15',1,80.00,15.00,200,130,2,0,1,NULL,0,'2026-05-25 00:00:00','2026-06-10 23:59:59',0,'2026-05-20 00:00:00',NULL),(4,'618年中大促 满150减30',1,150.00,30.00,400,210,2,200,1,NULL,1,'2026-06-12 00:00:00','2026-06-22 23:59:59',0,'2026-06-10 00:00:00',NULL),(5,'夏日清凉季 满60减12',1,60.00,12.00,300,160,2,50,1,NULL,0,'2026-06-20 00:00:00','2026-07-20 23:59:59',1,'2026-06-18 00:00:00',NULL),(6,'银卡专项 满40减8',1,40.00,8.00,200,75,3,0,1,NULL,2,'2026-07-01 00:00:00','2026-07-31 23:59:59',1,'2026-07-01 00:00:00',NULL);
/*!40000 ALTER TABLE `coupon` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `coupon_user`
--

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

--
-- Dumping data for table `coupon_user`
--

LOCK TABLES `coupon_user` WRITE;
/*!40000 ALTER TABLE `coupon_user` DISABLE KEYS */;
INSERT INTO `coupon_user` VALUES (51,1,1007,53,1,'2026-05-03 10:00:00','2026-05-07 09:22:00'),(52,1,1008,54,1,'2026-05-04 09:30:00','2026-05-08 16:52:00'),(53,1,1009,66,1,'2026-05-02 14:00:00','2026-05-27 09:35:00'),(54,1,1010,57,1,'2026-05-03 11:00:00','2026-05-12 13:20:00'),(55,1,1011,59,1,'2026-05-05 08:30:00','2026-05-17 09:48:00'),(56,1,1012,60,1,'2026-05-03 15:00:00','2026-05-18 15:30:00'),(57,1,1013,NULL,0,'2026-05-04 10:30:00',NULL),(58,1,1014,65,1,'2026-05-05 16:00:00','2026-05-25 16:58:00'),(59,1,1015,NULL,0,'2026-05-02 09:00:00',NULL),(60,1,1016,NULL,0,'2026-05-05 14:30:00',NULL),(61,1,1017,NULL,0,'2026-05-03 08:00:00',NULL),(62,1,1018,NULL,0,'2026-05-06 11:00:00',NULL),(63,1,1019,NULL,0,'2026-05-04 16:30:00',NULL),(64,1,1020,88,1,'2026-05-03 13:00:00','2026-06-27 15:38:00'),(65,1,1021,NULL,0,'2026-05-02 10:00:00',NULL),(66,1,1022,NULL,0,'2026-05-03 09:30:00',NULL),(67,1,1023,NULL,0,'2026-05-05 11:30:00',NULL),(68,1,1024,NULL,0,'2026-05-04 14:00:00',NULL),(69,1,1025,NULL,0,'2026-05-06 08:30:00',NULL),(70,2,1007,64,1,'2026-05-06 10:00:00','2026-05-24 10:10:00'),(71,2,1008,63,1,'2026-05-07 09:00:00','2026-05-22 17:22:00'),(72,2,1009,56,1,'2026-05-08 14:00:00','2026-05-10 08:58:00'),(73,2,1010,NULL,0,'2026-05-06 15:00:00',NULL),(74,2,1011,NULL,0,'2026-05-07 11:00:00',NULL),(75,2,1012,NULL,0,'2026-05-08 08:30:00',NULL),(76,2,1013,NULL,0,'2026-05-09 10:00:00',NULL),(77,2,1014,65,1,'2026-05-10 14:30:00','2026-05-25 16:58:00'),(78,2,1015,68,1,'2026-05-08 16:00:00','2026-05-30 11:30:00'),(79,2,1016,NULL,0,'2026-05-09 09:00:00',NULL),(80,3,1007,70,1,'2026-05-26 10:00:00','2026-06-03 14:08:00'),(81,3,1008,73,1,'2026-05-27 09:00:00','2026-06-09 11:55:00'),(82,3,1009,66,1,'2026-05-26 08:00:00','2026-05-27 09:35:00'),(83,3,1010,71,1,'2026-05-28 11:00:00','2026-06-05 09:22:00'),(84,3,1011,72,1,'2026-05-29 14:00:00','2026-06-07 16:40:00'),(85,3,1012,NULL,0,'2026-05-30 09:00:00',NULL),(86,3,1013,NULL,0,'2026-05-26 15:00:00',NULL),(87,3,1014,NULL,0,'2026-05-27 10:00:00',NULL),(88,4,1007,NULL,0,'2026-06-13 10:00:00',NULL),(89,4,1008,NULL,0,'2026-06-14 09:00:00',NULL),(90,4,1009,77,1,'2026-06-13 08:00:00','2026-06-14 14:38:00'),(91,4,1010,82,1,'2026-06-14 11:00:00','2026-06-20 10:25:00'),(92,4,1011,NULL,0,'2026-06-15 14:00:00',NULL),(93,4,1012,81,1,'2026-06-13 15:00:00','2026-06-18 16:08:00'),(94,4,1013,83,1,'2026-06-14 10:00:00','2026-06-21 14:55:00'),(95,4,1014,NULL,0,'2026-06-15 09:00:00',NULL),(96,4,1015,NULL,0,'2026-06-13 16:00:00',NULL),(97,4,1016,NULL,0,'2026-06-16 08:30:00',NULL),(98,4,1017,76,1,'2026-06-13 08:30:00','2026-06-13 10:32:00'),(99,4,1018,79,1,'2026-06-14 14:00:00','2026-06-15 10:00:00'),(100,5,1009,91,1,'2026-06-28 10:00:00','2026-07-01 09:28:00'),(101,5,1010,84,1,'2026-06-22 08:00:00','2026-06-22 10:08:00'),(102,5,1011,90,1,'2026-06-25 14:00:00','2026-06-30 13:48:00'),(103,5,1012,NULL,0,'2026-06-23 09:00:00',NULL),(104,5,1013,83,1,'2026-06-21 08:30:00','2026-06-21 14:55:00'),(105,5,1014,NULL,0,'2026-06-24 10:00:00',NULL),(106,5,1015,NULL,0,'2026-06-25 15:00:00',NULL),(107,5,1016,NULL,0,'2026-06-22 11:00:00',NULL),(108,6,1001,NULL,0,'2026-07-01 09:00:00',NULL),(109,6,1002,NULL,0,'2026-07-01 10:00:00',NULL),(110,6,1003,NULL,0,'2026-07-01 11:00:00',NULL),(111,6,1004,NULL,0,'2026-07-02 08:30:00',NULL),(112,6,1005,NULL,0,'2026-07-02 09:30:00',NULL),(113,6,1006,NULL,0,'2026-07-02 14:00:00',NULL);
/*!40000 ALTER TABLE `coupon_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `delivery`
--

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

--
-- Dumping data for table `delivery`
--

LOCK TABLES `delivery` WRITE;
/*!40000 ALTER TABLE `delivery` DISABLE KEYS */;
INSERT INTO `delivery` VALUES (21,51,'DL202605051035000001','张骑手','13911112201',4,'2026-05-05 10:38:00','2026-05-05 11:18:00',NULL,NULL),(22,52,'DL202605061428000001','李骑手','13911112202',4,'2026-05-06 14:32:00','2026-05-06 14:52:00',NULL,NULL),(23,55,'DL202605091138000001','王骑手','13911112203',4,'2026-05-09 11:42:00','2026-05-09 12:08:00',NULL,NULL),(24,57,'DL202605121320000001','赵骑手','13911112204',4,'2026-05-12 13:24:00','2026-05-12 13:48:00',NULL,NULL),(25,58,'DL202605141033000001','刘骑手','13911112205',4,'2026-05-14 10:36:00','2026-05-14 10:58:00',NULL,NULL),(26,59,'DL202605170948000001','陈骑手','13911112206',4,'2026-05-17 09:52:00','2026-05-17 10:18:00',NULL,NULL),(27,60,'DL202605181530000001','张骑手','13911112201',4,'2026-05-18 15:34:00','2026-05-18 16:03:00',NULL,NULL),(28,62,'DL202605211440000001','李骑手','13911112202',4,'2026-05-21 14:44:00','2026-05-21 15:13:00',NULL,NULL),(29,64,'DL202605241010000001','王骑手','13911112203',4,'2026-05-24 10:15:00','2026-05-24 10:43:00',NULL,NULL),(30,66,'DL202605270938000001','赵骑手','13911112204',3,'2026-05-27 09:55:00',NULL,NULL,NULL),(31,67,'DL202605291354000001','刘骑手','13911112205',4,'2026-05-29 13:56:00','2026-05-29 14:28:00',NULL,NULL),(32,68,'DL202605301130000001','陈骑手','13911112206',4,'2026-05-30 11:34:00','2026-05-30 12:03:00',NULL,NULL),(33,69,'DL202606011038000001','张骑手','13911112201',4,'2026-06-01 10:42:00','2026-06-01 11:08:00',NULL,NULL),(34,71,'DL202606050922000001','李骑手','13911112202',4,'2026-06-05 09:26:00','2026-06-05 09:53:00',NULL,NULL),(35,73,'DL202606091155000001','王骑手','13911112203',4,'2026-06-09 11:59:00','2026-06-09 12:28:00',NULL,NULL),(36,76,'DL202606131038000001','赵骑手','13911112204',3,'2026-06-13 11:02:00',NULL,NULL,NULL),(37,78,'DL202606151630000001','刘骑手','13911112205',4,'2026-06-15 16:32:00','2026-06-15 16:58:00',NULL,NULL),(38,79,'DL202606151002000001','陈骑手','13911112206',4,'2026-06-15 10:04:00','2026-06-15 10:33:00',NULL,NULL),(39,80,'DL202606171140000001','张骑手','13911112201',4,'2026-06-17 11:44:00','2026-06-17 12:13:00',NULL,NULL),(40,82,'DL202606201025000001','李骑手','13911112202',4,'2026-06-20 10:28:00','2026-06-20 10:53:00',NULL,NULL),(41,83,'DL202606211455000001','王骑手','13911112203',4,'2026-06-21 14:59:00','2026-06-21 15:28:00',NULL,NULL),(42,85,'DL202606230940000001','赵骑手','13911112204',4,'2026-06-23 09:44:00','2026-06-23 10:13:00',NULL,NULL),(43,89,'DL202606291015000001','刘骑手','13911112205',4,'2026-06-29 10:19:00','2026-06-29 10:48:00',NULL,NULL),(44,90,'DL202606301350000001','陈骑手','13911112206',3,'2026-06-30 14:06:00',NULL,NULL,NULL);
/*!40000 ALTER TABLE `delivery` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `delivery_status_log`
--

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

--
-- Dumping data for table `delivery_status_log`
--

LOCK TABLES `delivery_status_log` WRITE;
/*!40000 ALTER TABLE `delivery_status_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `delivery_status_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `discount_rule`
--

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

--
-- Dumping data for table `discount_rule`
--

LOCK TABLES `discount_rule` WRITE;
/*!40000 ALTER TABLE `discount_rule` DISABLE KEYS */;
/*!40000 ALTER TABLE `discount_rule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `distributor`
--

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

--
-- Dumping data for table `distributor`
--

LOCK TABLES `distributor` WRITE;
/*!40000 ALTER TABLE `distributor` DISABLE KEYS */;
INSERT INTO `distributor` VALUES (1,1008,150.00,0.00,1,'2026-05-20 10:00:00'),(2,1010,80.00,20.00,1,'2026-06-01 14:00:00'),(3,1015,0.00,0.00,0,'2026-07-02 09:00:00');
/*!40000 ALTER TABLE `distributor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `file_record`
--

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

--
-- Dumping data for table `file_record`
--

LOCK TABLES `file_record` WRITE;
/*!40000 ALTER TABLE `file_record` DISABLE KEYS */;
/*!40000 ALTER TABLE `file_record` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `growth_log`
--

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

--
-- Dumping data for table `growth_log`
--

LOCK TABLES `growth_log` WRITE;
/*!40000 ALTER TABLE `growth_log` DISABLE KEYS */;
INSERT INTO `growth_log` VALUES (1,1007,2,3,3,'每日签到','2026-05-05 08:00:00'),(2,1008,2,2,2,'每日签到','2026-05-05 08:10:00'),(3,1009,2,5,5,'每日签到','2026-05-06 08:00:00'),(4,1010,2,1,1,'每日签到','2026-05-06 09:00:00'),(5,1007,1,36,39,'消费获得-订单202605070915020003','2026-05-07 17:00:00'),(6,1008,1,48,50,'消费获得-订单202605081645010004','2026-05-09 11:00:00'),(7,1009,1,62,67,'消费获得-订单202605100850020006','2026-05-10 18:00:00'),(8,1010,2,4,5,'每日签到','2026-05-11 08:00:00'),(9,1010,1,89,94,'消费获得-订单202605121310010007','2026-05-13 08:00:00'),(10,1011,2,3,3,'每日签到','2026-05-14 08:00:00'),(11,1007,2,2,41,'每日签到','2026-05-16 08:00:00'),(12,1011,1,42,45,'消费获得-订单202605170940010009','2026-05-18 08:30:00'),(13,1012,1,70,70,'消费获得-订单202605181520010010','2026-05-19 10:00:00'),(14,1013,2,1,1,'每日签到','2026-05-19 08:30:00'),(15,1013,1,54,55,'消费获得-订单202605211430010012','2026-05-22 09:00:00'),(16,1009,2,3,70,'每日签到','2026-05-23 08:00:00'),(17,1007,1,29,70,'消费获得-订单202605241000010014','2026-05-25 08:30:00'),(18,1014,1,72,72,'消费获得-订单202605251650020015','2026-05-26 09:00:00'),(19,1015,2,2,2,'每日签到','2026-05-28 09:00:00'),(20,1015,1,106,108,'消费获得-订单202605301120010018','2026-05-31 09:00:00'),(21,1010,2,5,99,'每日签到','2026-06-01 08:00:00'),(22,1007,1,82,152,'消费获得-订单202606031400020020','2026-06-04 10:00:00'),(23,1010,1,63,162,'消费获得-订单202606050915010021','2026-06-06 08:30:00'),(24,1011,1,85,130,'消费获得-订单202606071630020022','2026-06-08 09:00:00'),(25,1008,1,34,84,'消费获得-订单202606091145010023','2026-06-10 08:00:00'),(26,1009,1,49,119,'消费获得-订单202606141430020027','2026-06-14 18:00:00'),(27,1009,1,38,157,'消费获得-订单202606151620010028','2026-06-16 08:30:00'),(28,1018,1,40,40,'消费获得-订单202606150950010029','2026-06-16 09:00:00'),(29,1012,1,66,136,'消费获得-订单202606181600020031','2026-06-19 09:00:00'),(30,1010,1,89,251,'消费获得-订单202606201015010032','2026-06-21 08:30:00'),(31,1007,3,10,162,'评价获得','2026-06-21 10:00:00'),(32,1013,1,49,104,'消费获得-订单202606211445010033','2026-06-22 09:00:00'),(33,1010,1,55,306,'消费获得-订单202606221000020034','2026-06-23 08:00:00'),(34,1007,1,54,216,'消费获得-订单202606230930010035','2026-06-24 09:00:00'),(35,1019,1,113,113,'消费获得-订单202606241720020036','2026-06-25 09:30:00'),(36,1007,2,4,220,'每日签到','2026-06-27 08:00:00'),(37,1020,1,49,49,'消费获得-订单202606271530020038','2026-06-28 09:00:00'),(38,1008,1,108,192,'消费获得-订单202606291005010039','2026-06-30 08:30:00'),(39,1010,3,10,316,'评价获得','2026-07-01 14:00:00'),(40,1007,2,3,223,'每日签到','2026-07-03 08:00:00');
/*!40000 ALTER TABLE `growth_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `member`
--

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

--
-- Dumping data for table `member`
--

LOCK TABLES `member` WRITE;
/*!40000 ALTER TABLE `member` DISABLE KEYS */;
INSERT INTO `member` VALUES (1,1001,2,2000,3000),(2,1002,2,1500,2500),(3,1003,2,1200,2000),(4,1004,2,1000,1500),(5,1005,2,800,1200),(6,1006,2,500,800),(7,1007,3,800,600),(8,1008,2,500,350),(9,1009,1,300,150),(10,1010,3,100,80),(11,1011,1,300,0),(12,1012,1,280,0),(13,1013,1,650,0),(14,1014,1,220,0),(15,1015,1,200,0),(16,1016,1,180,0),(17,1017,1,150,0),(18,1018,1,130,0),(19,1019,1,100,0),(20,1020,1,80,0),(21,1021,1,60,0),(22,1022,1,40,0),(23,1023,1,20,0),(24,1024,1,10,0),(25,1025,1,0,0);
/*!40000 ALTER TABLE `member` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `merchant`
--

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

--
-- Dumping data for table `merchant`
--

LOCK TABLES `merchant` WRITE;
/*!40000 ALTER TABLE `merchant` DISABLE KEYS */;
INSERT INTO `merchant` VALUES (2001,1001,'润禾生活食铺','/static/merchant/1001.jpg','龙国建','17782224500','重庆市渝中区解放西路 126 号附 8 号',1,'06:00-21:30','润禾生活食铺坐落于渝中区解放西路，主营休闲零食、坚果炒货与精品糕点。店内精选三只松鼠、旺旺、良品铺子等知名品牌，涵盖坚果礼盒、虎皮风爪、雪饼、芒果干等热门单品，满足日常零嘴与亲朋送礼双重需求。我们坚持\"新鲜直达、品质为本\"，每周三批到货确保商品日期新鲜，是街坊邻里的放心零食铺。','2026-05-04 09:15:00'),(2002,1002,'食愈小站','/static/merchant/1002.jpg','周小雪','17782224501','重庆市大渡口区新山村春晖路 66 号',1,'08:00-20:00','食愈小站位于大渡口区春晖路新山村商圈，是一家以\"食愈心灵\"为理念的精致零食小铺。主打卫龙辣条系列、良品铺子手工糕点与蛋黄酥、雪花酥等网红甜品，深受周边写字楼白领和学生群体喜爱。店内每月推出限定口味，搭配手写推荐卡，让每一次购物都成为温暖的小确幸。','2026-05-18 14:30:00'),(2003,1003,'鲜禧果仓','/static/merchant/1003.jpg','林志远','17782224502','重庆市巴南区龙洲湾渝南大道132号',1,'06:30-21:00','鲜禧果仓扎根巴南区龙洲湾，专注高品质应季鲜果与精品坚果。店内常年供应奉节脐橙、阿克苏冰糖心苹果、阳光金果奇异果等地标水果，搭配沃隆每日坚果等健康零嘴。我们与产区直采合作，清晨采摘、当日上架，每一颗水果都经过三道筛选，用\"鲜\"字说话，让街坊吃出季节的味道。','2026-06-02 10:00:00'),(2004,1004,'家禾粮油副食','/static/merchant/1004.jpg','苏婉清','17782224503','重庆市沙坪坝区三峡广场天陈路57号',1,'07:00-20:30','家禾粮油副食位于沙坪坝区三峡广场商圈，专注厨房基础食材一站式供应。经营金龙鱼大米、海天酱油、涪陵榨菜、农家红薯粉等家庭刚需品，覆盖米面粮油、调味品、干货三大品类。我们以\"件件严选、斤斤实惠\"为宗旨，与多家品牌签订年度直供协议，省去中间环节让利顾客，是三峡广场周边居民的\"家庭粮仓\"。','2026-06-20 11:45:00'),(2005,1005,'巷味卤货','/static/merchant/1005.jpg','黄德伟','17782224504','重庆市北碚区天生路49号城南步行街底商',1,'09:00-22:00','巷味卤货扎根北碚城南步行街，传承重庆地道卤味手艺。主打有友泡椒凤爪、五香鹌鹑蛋及绝味锁鲜鸭脖、牛肉脯等人气卤味，采用二十余味中草药秘制卤汤，每日现卤现售。我们坚持\"卤香不怕巷子深\"，以当日鲜卤、真空锁鲜双模式服务周边社区与夜宵爱好者，一口卤味一口酒，就是山城最地道的烟火气。','2026-07-01 08:30:00'),(2006,1006,'果汽鲜饮','/static/merchant/1006.jpg','何雅琴','17782224505','重庆市江北区观音桥建新北路 55 号星光 68 负一楼 17 铺',0,'08:30-21:30','果汽鲜饮位于江北观音桥星光68商圈，专注于高品质饮品与酸奶零售。主营元气森林气泡水系列、农夫山泉鲜榨果汁及元气森林酸奶，覆盖气泡水、纯果汁、乳酸菌饮品三大热门赛道。我们紧邻写字楼与购物中心，以\"低糖、健康、好喝\"为选品标准，为都市白领和年轻家庭提供便捷的饮品补给方案。','2026-07-04 09:00:00');
/*!40000 ALTER TABLE `merchant` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `merchant_apply`
--

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

--
-- Dumping data for table `merchant_apply`
--

LOCK TABLES `merchant_apply` WRITE;
/*!40000 ALTER TABLE `merchant_apply` DISABLE KEYS */;
INSERT INTO `merchant_apply` VALUES (4001,1001,2,'润禾食品商贸有限公司','/static/id_card/front_1001.jpg','/static/id_card/back_1001.jpg','91500101MA03XXX01',NULL,'JY500101XXX01',NULL,'龙国建','17782222101','重庆市渝北区金开大道星光天地12铺','润禾生活食铺',1,'企业资质齐全，证照审核通过',NULL,'2026-06-05 09:10:00'),(4002,1002,1,'食愈小铺食品经营店','/static/id_card/front_1002.jpg','/static/id_card/back_1002.jpg',NULL,NULL,NULL,NULL,'周小雪','17782222102','重庆市江北区观音桥星光68负一楼','食愈小铺',1,'个体证件完整，准予入驻',NULL,'2026-06-08 14:25:00'),(4003,1003,2,'鲜禧果蔬农产品有限公司','/static/id_card/front_1003.jpg','/static/id_card/back_1003.jpg','91500103MA03XXX03',NULL,'JY500103XXX03',NULL,'林志远','17782222103','重庆市南岸区南坪协信星光一层','鲜禧果仓',1,'生鲜食品资质核验无误',NULL,'2026-06-12 10:05:00'),(4004,1004,2,'家禾粮油副食配送公司','/static/id_card/front_1004.jpg','/static/id_card/back_1004.jpg','91500104MA03XXX04',NULL,'JY500104XXX04',NULL,'苏婉清','17782222104','重庆市九龙坡区杨家坪直港大道','家禾粮油副食',1,'粮油经营许可齐全，审核通过',NULL,'2026-06-15 16:30:00'),(4005,1005,1,'巷味卤货小吃店','/static/id_card/front_1005.jpg','/static/id_card/back_1005.jpg',NULL,NULL,NULL,NULL,'黄德伟','17782222105','重庆市渝中区两路口桂花园路','巷味卤货',1,'熟食卫生资质达标，审核通过',NULL,'2026-06-20 11:15:00'),(4006,1006,1,'果汽鲜饮饮品店','/static/id_card/front_1006.jpg','/static/id_card/back_1006.jpg',NULL,NULL,NULL,NULL,'何雅琴','17782222106','重庆市南岸区茶园时代都汇临街铺','果汽鲜饮',1,'资料待补充食品留样记录，暂未通过','2026-06-25 08:40:00','2026-06-25 08:40:00');
/*!40000 ALTER TABLE `merchant_apply` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `merchant_coupon`
--

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

--
-- Dumping data for table `merchant_coupon`
--

LOCK TABLES `merchant_coupon` WRITE;
/*!40000 ALTER TABLE `merchant_coupon` DISABLE KEYS */;
INSERT INTO `merchant_coupon` VALUES (1,2001,'新人减3元',1,0.01,3.00,200,0,1,1,NULL,'2026-07-03 00:00:00','2026-07-16 00:00:00',1,'2026-07-04 08:41:00','2026-07-04 08:41:00');
/*!40000 ALTER TABLE `merchant_coupon` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `merchant_coupon_tier`
--

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

--
-- Dumping data for table `merchant_coupon_tier`
--

LOCK TABLES `merchant_coupon_tier` WRITE;
/*!40000 ALTER TABLE `merchant_coupon_tier` DISABLE KEYS */;
/*!40000 ALTER TABLE `merchant_coupon_tier` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `merchant_coupon_user`
--

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

--
-- Dumping data for table `merchant_coupon_user`
--

LOCK TABLES `merchant_coupon_user` WRITE;
/*!40000 ALTER TABLE `merchant_coupon_user` DISABLE KEYS */;
/*!40000 ALTER TABLE `merchant_coupon_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `merchant_earnings`
--

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

--
-- Dumping data for table `merchant_earnings`
--

LOCK TABLES `merchant_earnings` WRITE;
/*!40000 ALTER TABLE `merchant_earnings` DISABLE KEYS */;
/*!40000 ALTER TABLE `merchant_earnings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `merchant_info_change`
--

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

--
-- Dumping data for table `merchant_info_change`
--

LOCK TABLES `merchant_info_change` WRITE;
/*!40000 ALTER TABLE `merchant_info_change` DISABLE KEYS */;
INSERT INTO `merchant_info_change` VALUES (1,2001,'INFO_CHANGE','{\"contactName\":\"陈一\",\"businessHours\":null,\"contactPhone\":\"17782224500\",\"shopAddress\":\"重庆市渝中区解放西路 126 号附 8 号\",\"introduction\":null,\"merchantName\":\"润禾生活食铺\"}','{\"contactName\":\"陈一\",\"businessHours\":\"9:00~23:))\",\"contactPhone\":\"17782224500\",\"shopAddress\":\"重庆市渝中区解放西路 126 号附 8 号\",\"introduction\":\"\",\"merchantName\":\"润禾生活食铺\"}',0,NULL,'2026-07-04 08:43:50',NULL);
/*!40000 ALTER TABLE `merchant_info_change` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `merchant_promotion_participation`
--

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

--
-- Dumping data for table `merchant_promotion_participation`
--

LOCK TABLES `merchant_promotion_participation` WRITE;
/*!40000 ALTER TABLE `merchant_promotion_participation` DISABLE KEYS */;
/*!40000 ALTER TABLE `merchant_promotion_participation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `merchant_qualification`
--

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

--
-- Dumping data for table `merchant_qualification`
--

LOCK TABLES `merchant_qualification` WRITE;
/*!40000 ALTER TABLE `merchant_qualification` DISABLE KEYS */;
INSERT INTO `merchant_qualification` VALUES (3001,2001,'综合休闲食品、鲜果零食','91500101MA03XXX01','/static/business_license/1001.jpg','JY500101XXX01','/static/food_permit/1001.jpg'),(3002,2002,'网红零食、糕点膨化食品','91500102MA03XXX02','/static/business_license/1002.jpg','JY500102XXX02','/static/food_permit/1002.jpg'),(3003,2003,'新鲜水果、果干蜜饯坚果','91500103MA03XXX03','/static/business_license/1003.jpg','JY500103XXX03','/static/food_permit/1003.jpg'),(3004,2004,'粮油米面、调味罐头速食','91500104MA03XXX04','/static/business_license/1004.jpg','JY500104XXX04','/static/food_permit/1004.jpg'),(3005,2005,'卤味熟食、肉干即食食品','91500105MA03XXX05','/static/business_license/1005.jpg','JY500105XXX05','/static/food_permit/1005.jpg');
/*!40000 ALTER TABLE `merchant_qualification` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `message_template`
--

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

--
-- Dumping data for table `message_template`
--

LOCK TABLES `message_template` WRITE;
/*!40000 ALTER TABLE `message_template` DISABLE KEYS */;
/*!40000 ALTER TABLE `message_template` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notice`
--

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

--
-- Dumping data for table `notice`
--

LOCK TABLES `notice` WRITE;
/*!40000 ALTER TABLE `notice` DISABLE KEYS */;
/*!40000 ALTER TABLE `notice` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notification`
--

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

--
-- Dumping data for table `notification`
--

LOCK TABLES `notification` WRITE;
/*!40000 ALTER TABLE `notification` DISABLE KEYS */;
/*!40000 ALTER TABLE `notification` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `operation_admin`
--

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

--
-- Dumping data for table `operation_admin`
--

LOCK TABLES `operation_admin` WRITE;
/*!40000 ALTER TABLE `operation_admin` DISABLE KEYS */;
INSERT INTO `operation_admin` VALUES (1,'operator01','56ed087f4411c193dbbb1421745bae12','运营张三','13900001001','zhangsan@example.com','商品运营',1,'2026-07-04 08:41:40','2026-01-01 00:00:00'),(2,'operator02','56ed087f4411c193dbbb1421745bae12','运营李四','13900001002','lisi@example.com','内容运营',1,'2026-07-03 10:00:00','2026-02-01 00:00:00'),(3,'operator03','56ed087f4411c193dbbb1421745bae12','运营王五','13900001003','wangwu@example.com','活动运营',1,'2026-07-02 14:00:00','2026-03-01 00:00:00'),(4,'operator04','56ed087f4411c193dbbb1421745bae12','运营小美','13900001004','xiaomei@example.com','用户运营',1,'2026-07-03 08:30:00','2026-04-01 00:00:00');
/*!40000 ALTER TABLE `operation_admin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order`
--

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

--
-- Dumping data for table `order`
--

LOCK TABLES `order` WRITE;
/*!40000 ALTER TABLE `order` DISABLE KEYS */;
INSERT INTO `order` VALUES (51,'202605051030010001',1004,2001,NULL,77.00,82.00,0.00,1,5.00,0.00,0.00,0.00,4,'IK_1004_20260505103001',0,0,101,'赵六','17782222104',NULL,NULL,NULL,NULL,NULL,'重庆市江北区观音桥建新北路76号阳光花园3栋1502',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,'2026-05-05 11:00:00','2026-05-05 10:31:25',NULL,'2026-05-05 10:30:00','2026-05-05 10:31:25','2026-05-05 10:35:00','2026-05-05 11:20:00','2026-05-06 09:00:00',0,NULL,NULL),(52,'202605061420010002',1004,2002,NULL,39.80,44.80,0.00,1,5.00,0.00,0.00,0.00,4,'IK_1004_20260506142001',0,0,101,'赵六','17782222104',NULL,NULL,NULL,NULL,NULL,'重庆市江北区观音桥建新北路76号阳光花园3栋1502',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,'2026-05-06 14:50:00','2026-05-06 14:22:30',NULL,'2026-05-06 14:20:00','2026-05-06 14:22:30','2026-05-06 14:28:00','2026-05-06 14:55:00','2026-05-07 10:00:00',0,NULL,NULL),(53,'202605070915020003',1007,2003,9,36.90,36.90,0.00,2,0.00,0.00,0.00,0.00,4,'IK_1007_20260507091501',0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,'2026-05-07 09:45:00','2026-05-07 09:16:40',NULL,'2026-05-07 09:15:00','2026-05-07 09:16:40','2026-05-07 09:22:00','2026-05-07 10:30:00','2026-05-07 17:00:00',0,'345821',NULL),(54,'202605081645010004',1008,2001,7,48.90,48.90,0.00,2,0.00,0.00,0.00,0.00,4,'IK_1008_20260508164501',0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,'2026-05-08 17:15:00','2026-05-08 16:46:10',NULL,'2026-05-08 16:45:00','2026-05-08 16:46:10','2026-05-08 16:52:00','2026-05-08 17:30:00','2026-05-09 11:00:00',0,'672109',NULL),(55,'202605091130010005',1004,2003,NULL,118.00,118.00,5.00,1,5.00,0.00,0.00,0.00,4,'IK_1004_20260509113001',200,2,NULL,'赵六','17782222104',NULL,NULL,NULL,NULL,NULL,'重庆市江北区观音桥建新北路76号阳光花园3栋1502',5001,NULL,5.00,0.00,0.00,NULL,NULL,NULL,1,'2026-05-09 12:00:00','2026-05-09 11:31:50',NULL,'2026-05-09 11:30:00','2026-05-09 11:31:50','2026-05-09 11:38:00','2026-05-09 12:10:00','2026-05-10 09:30:00',0,NULL,NULL),(56,'202605100850020006',1009,2002,8,62.90,62.90,0.00,2,0.00,0.00,0.00,0.00,4,'IK_1009_20260510085001',0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,'2026-05-10 09:20:00','2026-05-10 08:52:15',NULL,'2026-05-10 08:50:00','2026-05-10 08:52:15','2026-05-10 08:58:00','2026-05-10 09:35:00','2026-05-10 18:00:00',0,'894231',NULL),(57,'202605121310010007',1010,2004,NULL,84.90,89.90,0.00,1,5.00,0.00,0.00,0.00,4,'IK_1010_20260512131001',0,0,102,'赵一','17782222107',NULL,NULL,NULL,NULL,NULL,'重庆市渝北区冉家坝龙湖水晶郦城2栋1001',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,'2026-05-12 13:40:00','2026-05-12 13:11:30',NULL,'2026-05-12 13:10:00','2026-05-12 13:11:30','2026-05-12 13:20:00','2026-05-12 13:50:00','2026-05-13 08:00:00',0,NULL,NULL),(58,'202605141025010008',1004,2001,NULL,112.90,107.90,10.00,1,5.00,0.00,0.00,0.00,4,'IK_1004_20260514102501',300,2,101,'赵六','17782222104',NULL,NULL,NULL,NULL,NULL,'重庆市江北区观音桥建新北路76号阳光花园3栋1502',5002,NULL,10.00,0.00,0.00,NULL,NULL,NULL,1,'2026-05-14 10:55:00','2026-05-14 10:27:05',NULL,'2026-05-14 10:25:00','2026-05-14 10:27:05','2026-05-14 10:33:00','2026-05-14 11:00:00','2026-05-15 09:00:00',0,NULL,NULL),(59,'202605170940010009',1011,2005,NULL,37.80,42.80,0.00,1,5.00,0.00,0.00,0.00,4,'IK_1011_20260517094001',0,0,103,'孙小红','17782222108',NULL,NULL,NULL,NULL,NULL,'重庆市南岸区南坪上海城19栋705',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,'2026-05-17 10:10:00','2026-05-17 09:41:20',NULL,'2026-05-17 09:40:00','2026-05-17 09:41:20','2026-05-17 09:48:00','2026-05-17 10:20:00','2026-05-18 08:30:00',0,NULL,NULL),(60,'202605181520010010',1012,2006,NULL,65.00,70.00,0.00,1,5.00,0.00,0.00,0.00,4,'IK_1012_20260518152001',0,0,104,'周小明','17782222109',NULL,NULL,NULL,NULL,NULL,'重庆市九龙坡区谢家湾华润24城5栋2203',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,'2026-05-18 15:50:00','2026-05-18 15:21:45',NULL,'2026-05-18 15:20:00','2026-05-18 15:21:45','2026-05-18 15:30:00','2026-05-18 16:05:00','2026-05-19 10:00:00',0,NULL,NULL),(61,'202605201105020011',1004,2002,8,24.90,24.90,0.00,2,0.00,0.00,0.00,0.00,4,'IK_1004_20260520110501',0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,'2026-05-20 11:35:00','2026-05-20 11:06:30',NULL,'2026-05-20 11:05:00','2026-05-20 11:06:30','2026-05-20 11:12:00','2026-05-20 11:50:00','2026-05-20 17:30:00',0,'156479',NULL),(62,'202605211430010012',1013,2003,NULL,49.90,54.90,0.00,1,5.00,0.00,0.00,0.00,4,'IK_1013_20260521143001',0,0,105,'吴小丽','17782222110',NULL,NULL,NULL,NULL,NULL,'重庆市大渡口区九宫庙湖榕路锦天康都1栋1204',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,'2026-05-21 15:00:00','2026-05-21 14:31:50',NULL,'2026-05-21 14:30:00','2026-05-21 14:31:50','2026-05-21 14:40:00','2026-05-21 15:15:00','2026-05-22 09:00:00',0,NULL,NULL),(63,'202605221715010013',1008,2004,NULL,44.90,49.90,0.00,1,5.00,0.00,0.00,0.00,5,'IK_1008_20260522171501',0,0,106,'王一','17782222111',NULL,NULL,NULL,NULL,NULL,'重庆市巴南区鱼洞巴南印象6栋808',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,'2026-05-22 17:45:00','2026-05-22 17:16:30',NULL,'2026-05-22 17:15:00','2026-05-22 17:26:30','2026-05-22 17:22:00','2026-05-22 17:40:00','2026-05-22 17:40:00',0,NULL,NULL),(64,'202605241000010014',1007,2005,NULL,24.90,29.90,0.00,1,5.00,0.00,0.00,0.00,4,'IK_1007_20260524100001',0,0,107,'陈二','17782222112',NULL,NULL,NULL,NULL,NULL,'重庆市渝北区龙溪街道武陵路锦江郦城9栋1601',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,'2026-05-24 10:30:00','2026-05-24 10:01:40',NULL,'2026-05-24 10:00:00','2026-05-24 10:01:40','2026-05-24 10:10:00','2026-05-24 10:45:00','2026-05-25 08:30:00',0,NULL,NULL),(65,'202605251650020015',1014,2001,7,77.00,72.00,5.00,2,0.00,0.00,0.00,0.00,4,'IK_1014_20260525165001',0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,5003,NULL,5.00,0.00,0.00,NULL,NULL,NULL,1,'2026-05-25 17:20:00','2026-05-25 16:51:30',NULL,'2026-05-25 16:50:00','2026-05-25 16:51:30','2026-05-25 16:58:00','2026-05-25 17:30:00','2026-05-26 09:00:00',0,'483290',NULL),(66,'202605270930010016',1009,2006,NULL,65.80,70.80,0.00,1,5.00,0.00,0.00,0.00,3,'IK_1009_20260527093001',0,0,108,'李二','17782222113',NULL,NULL,NULL,NULL,NULL,'重庆市江北区五里店融景城郎峰11栋505',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,'2026-05-27 10:00:00','2026-05-27 09:31:25',NULL,'2026-05-27 09:30:00','2026-05-27 09:31:25','2026-05-27 09:35:00','2026-05-27 09:55:00','2026-05-27 10:20:00',0,NULL,NULL),(67,'202605291345010017',1004,2002,NULL,64.70,69.70,0.00,1,5.00,0.00,0.00,0.00,4,'IK_1004_20260529134501',0,0,101,'赵六','17782222104',NULL,NULL,NULL,NULL,NULL,'重庆市江北区观音桥建新北路76号阳光花园3栋1502',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,'2026-05-29 14:15:00','2026-05-29 13:46:10',NULL,'2026-05-29 13:45:00','2026-05-29 13:46:10','2026-05-29 13:52:00','2026-05-29 14:30:00','2026-05-30 09:00:00',0,NULL,NULL),(68,'202605301120010018',1015,2004,NULL,101.80,106.80,0.00,1,5.00,0.00,0.00,0.00,4,'IK_1015_20260530112001',0,0,109,'郑七','17782222114',NULL,NULL,NULL,NULL,NULL,'重庆市南岸区弹子石国际社区海悦府8栋2806',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,'2026-05-30 11:50:00','2026-05-30 11:22:00',NULL,'2026-05-30 11:20:00','2026-05-30 11:22:00','2026-05-30 11:30:00','2026-05-30 12:05:00','2026-05-31 09:00:00',0,NULL,NULL),(69,'202606011030010019',1004,2004,NULL,68.00,73.00,0.00,1,5.00,0.00,0.00,0.00,4,'IK_1004_20260601103001',0,0,101,'赵六','17782222104',NULL,NULL,NULL,NULL,NULL,'重庆市江北区观音桥建新北路76号阳光花园3栋1502',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,'2026-06-01 11:00:00','2026-06-01 10:31:30',NULL,'2026-06-01 10:30:00','2026-06-01 10:31:30','2026-06-01 10:38:00','2026-06-01 11:10:00','2026-06-02 09:00:00',0,NULL,NULL),(70,'202606031400020020',1007,2002,8,82.80,82.80,0.00,2,0.00,0.00,0.00,0.00,4,'IK_1007_20260603140001',0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,'2026-06-03 14:30:00','2026-06-03 14:01:20',NULL,'2026-06-03 14:00:00','2026-06-03 14:01:20','2026-06-03 14:08:00','2026-06-03 14:40:00','2026-06-04 10:00:00',0,'729583',NULL),(71,'202606050915010021',1010,2001,NULL,58.80,63.80,0.00,1,5.00,0.00,0.00,0.00,4,'IK_1010_20260605091501',0,0,102,'赵一','17782222107',NULL,NULL,NULL,NULL,NULL,'重庆市渝北区冉家坝龙湖水晶郦城2栋1001',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,'2026-06-05 09:45:00','2026-06-05 09:16:10',NULL,'2026-06-05 09:15:00','2026-06-05 09:16:10','2026-06-05 09:22:00','2026-06-05 09:55:00','2026-06-06 08:30:00',0,NULL,NULL),(72,'202606071630020022',1011,2003,9,85.00,85.00,0.00,2,0.00,0.00,0.00,0.00,4,'IK_1011_20260607163001',200,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,'2026-06-07 17:00:00','2026-06-07 16:32:00',NULL,'2026-06-07 16:30:00','2026-06-07 16:32:00','2026-06-07 16:40:00','2026-06-07 17:20:00','2026-06-08 09:00:00',0,'314670',NULL),(73,'202606091145010023',1008,2005,NULL,29.90,34.90,0.00,1,5.00,0.00,0.00,0.00,4,'IK_1008_20260609114501',0,0,106,'王一','17782222111',NULL,NULL,NULL,NULL,NULL,'重庆市巴南区鱼洞巴南印象6栋808',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,'2026-06-09 12:15:00','2026-06-09 11:46:40',NULL,'2026-06-09 11:45:00','2026-06-09 11:46:40','2026-06-09 11:55:00','2026-06-09 12:30:00','2026-06-10 08:00:00',0,NULL,NULL),(74,'202606100850010024',1016,2006,NULL,39.80,44.80,0.00,1,5.00,0.00,0.00,0.00,5,'IK_1016_20260610085001',0,0,110,'冯八','17782222115',NULL,NULL,NULL,NULL,NULL,'重庆市渝中区大坪英利国际2栋2208',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,'2026-06-10 09:20:00','2026-06-10 08:52:00',NULL,'2026-06-10 08:50:00','2026-06-10 09:02:00','2026-06-10 08:56:00','2026-06-10 09:10:00','2026-06-10 09:10:00',0,NULL,NULL),(75,'202606121510020025',1004,2001,7,74.90,64.90,10.00,2,0.00,0.00,0.00,0.00,4,'IK_1004_20260612151001',0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,5004,NULL,10.00,0.00,0.00,NULL,NULL,NULL,2,'2026-06-12 15:40:00','2026-06-12 15:11:30',NULL,'2026-06-12 15:10:00','2026-06-12 15:11:30','2026-06-12 15:18:00','2026-06-12 16:00:00','2026-06-13 09:30:00',0,'508923',NULL),(76,'202606131025010026',1017,2004,NULL,39.80,44.80,0.00,1,5.00,0.00,0.00,0.00,3,'IK_1017_20260613102501',0,0,111,'陈九','17782222116',NULL,NULL,NULL,NULL,NULL,'重庆市九龙坡区石桥铺华宇名都15栋1609',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,'2026-06-13 10:55:00','2026-06-13 10:26:30',NULL,'2026-06-13 10:25:00','2026-06-13 10:26:30','2026-06-13 10:32:00','2026-06-13 11:00:00','2026-06-13 11:20:00',0,NULL,NULL),(77,'202606141430020027',1009,2003,9,49.90,49.90,0.00,2,0.00,0.00,0.00,0.00,4,'IK_1009_20260614143001',0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,'2026-06-14 15:00:00','2026-06-14 14:31:50',NULL,'2026-06-14 14:30:00','2026-06-14 14:31:50','2026-06-14 14:38:00','2026-06-14 15:10:00','2026-06-14 18:00:00',0,'892105',NULL),(78,'202606151620010028',1009,2005,NULL,33.80,38.80,0.00,1,5.00,0.00,0.00,0.00,4,'IK_1009_20260615162001',0,0,108,'李二','17782222113',NULL,NULL,NULL,NULL,NULL,'重庆市江北区五里店融景城郎峰11栋505',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,'2026-06-15 16:50:00','2026-06-15 16:21:30',NULL,'2026-06-15 16:20:00','2026-06-15 16:21:30','2026-06-15 16:28:00','2026-06-15 17:00:00','2026-06-16 08:30:00',0,NULL,NULL),(79,'202606150950010029',1018,2005,NULL,35.80,40.80,0.00,1,5.00,0.00,0.00,0.00,4,'IK_1018_20260615095001',0,0,112,'林十','17782222117',NULL,NULL,NULL,NULL,NULL,'重庆市大渡口区春晖路柏华小区3栋402',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,'2026-06-15 10:20:00','2026-06-15 09:52:00',NULL,'2026-06-15 09:50:00','2026-06-15 09:52:00','2026-06-15 10:00:00','2026-06-15 10:35:00','2026-06-16 09:00:00',0,NULL,NULL),(80,'202606171130010030',1004,2002,NULL,59.70,64.70,0.00,1,5.00,0.00,0.00,0.00,4,'IK_1004_20260617113001',0,0,101,'赵六','17782222104',NULL,NULL,NULL,NULL,NULL,'重庆市江北区观音桥建新北路76号阳光花园3栋1502',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,'2026-06-17 12:00:00','2026-06-17 11:31:20',NULL,'2026-06-17 11:30:00','2026-06-17 11:31:20','2026-06-17 11:40:00','2026-06-17 12:15:00','2026-06-18 08:30:00',0,NULL,NULL),(81,'202606181600020031',1012,2001,7,71.80,66.80,5.00,2,0.00,0.00,0.00,0.00,4,'IK_1012_20260618160001',0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,5005,NULL,5.00,0.00,0.00,NULL,NULL,NULL,1,'2026-06-18 16:30:00','2026-06-18 16:01:40',NULL,'2026-06-18 16:00:00','2026-06-18 16:01:40','2026-06-18 16:08:00','2026-06-18 16:45:00','2026-06-19 09:00:00',0,'637451',NULL),(82,'202606201015010032',1010,2006,NULL,84.90,89.90,0.00,1,5.00,0.00,0.00,0.00,4,'IK_1010_20260620101501',0,0,102,'赵一','17782222107',NULL,NULL,NULL,NULL,NULL,'重庆市渝北区冉家坝龙湖水晶郦城2栋1001',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,'2026-06-20 10:45:00','2026-06-20 10:17:00',NULL,'2026-06-20 10:15:00','2026-06-20 10:17:00','2026-06-20 10:25:00','2026-06-20 10:55:00','2026-06-21 08:30:00',0,NULL,NULL),(83,'202606211445010033',1013,2004,NULL,44.00,49.00,0.00,1,5.00,0.00,0.00,0.00,4,'IK_1013_20260621144501',0,0,105,'吴小丽','17782222110',NULL,NULL,NULL,NULL,NULL,'重庆市大渡口区九宫庙湖榕路锦天康都1栋1204',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,'2026-06-21 15:15:00','2026-06-21 14:46:30',NULL,'2026-06-21 14:45:00','2026-06-21 14:46:30','2026-06-21 14:55:00','2026-06-21 15:30:00','2026-06-22 09:00:00',0,NULL,NULL),(84,'202606221000020034',1010,2002,8,55.80,55.80,0.00,2,0.00,0.00,0.00,0.00,4,'IK_1010_20260622100001',0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,'2026-06-22 10:30:00','2026-06-22 10:01:50',NULL,'2026-06-22 10:00:00','2026-06-22 10:01:50','2026-06-22 10:08:00','2026-06-22 10:40:00','2026-06-23 08:00:00',0,'245168',NULL),(85,'202606230930010035',1007,2005,NULL,54.80,54.80,5.00,1,5.00,0.00,0.00,0.00,4,'IK_1007_20260623093001',0,0,107,'陈二','17782222112',NULL,NULL,NULL,NULL,NULL,'重庆市渝北区龙溪街道武陵路锦江郦城9栋1601',5006,NULL,5.00,0.00,0.00,NULL,NULL,NULL,1,'2026-06-23 10:00:00','2026-06-23 09:31:40',NULL,'2026-06-23 09:30:00','2026-06-23 09:31:40','2026-06-23 09:40:00','2026-06-23 10:15:00','2026-06-24 09:00:00',0,NULL,NULL),(86,'202606241720020036',1019,2003,9,118.00,113.00,5.00,2,0.00,0.00,0.00,0.00,4,'IK_1019_20260624172001',0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,5007,NULL,5.00,0.00,0.00,NULL,NULL,NULL,1,'2026-06-24 17:50:00','2026-06-24 17:21:30',NULL,'2026-06-24 17:20:00','2026-06-24 17:21:30','2026-06-24 17:28:00','2026-06-24 18:05:00','2026-06-25 09:30:00',0,'419387',NULL),(87,'202606261100010037',1004,2004,NULL,68.00,73.00,0.00,1,5.00,0.00,0.00,0.00,5,'IK_1004_20260626110001',0,0,101,'赵六','17782222104',NULL,NULL,NULL,NULL,NULL,'重庆市江北区观音桥建新北路76号阳光花园3栋1502',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,'2026-06-26 11:30:00','2026-06-26 11:02:00',NULL,'2026-06-26 11:00:00','2026-06-26 11:12:00','2026-06-26 11:06:00','2026-06-26 11:20:00','2026-06-26 11:20:00',0,NULL,NULL),(88,'202606271530020038',1020,2002,8,49.80,49.80,0.00,2,0.00,0.00,0.00,0.00,4,'IK_1020_20260627153001',0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,'2026-06-27 16:00:00','2026-06-27 15:31:20',NULL,'2026-06-27 15:30:00','2026-06-27 15:31:20','2026-06-27 15:38:00','2026-06-27 16:10:00','2026-06-28 09:00:00',0,'706842',NULL),(89,'202606291005010039',1008,2001,NULL,103.00,108.00,0.00,1,5.00,0.00,0.00,0.00,4,'IK_1008_20260629100501',0,0,106,'王一','17782222111',NULL,NULL,NULL,NULL,NULL,'重庆市巴南区鱼洞巴南印象6栋808',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,'2026-06-29 10:35:00','2026-06-29 10:06:30',NULL,'2026-06-29 10:05:00','2026-06-29 10:06:30','2026-06-29 10:15:00','2026-06-29 10:50:00','2026-06-30 08:30:00',0,NULL,NULL),(90,'202606301340010040',1011,2006,NULL,42.90,47.90,0.00,1,5.00,0.00,0.00,0.00,3,'IK_1011_20260630134001',0,0,103,'孙小红','17782222108',NULL,NULL,NULL,NULL,NULL,'重庆市南岸区南坪上海城19栋705',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,'2026-06-30 14:10:00','2026-06-30 13:41:20',NULL,'2026-06-30 13:40:00','2026-06-30 13:41:20','2026-06-30 13:48:00','2026-06-30 14:05:00','2026-06-30 14:25:00',0,NULL,NULL),(91,'202607010920010041',1009,2005,NULL,56.70,61.70,0.00,1,5.00,0.00,0.00,0.00,2,'IK_1009_20260701092001',0,0,108,'李二','17782222113',NULL,NULL,NULL,NULL,NULL,'重庆市江北区五里店融景城郎峰11栋505',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,'2026-07-01 09:50:00','2026-07-01 09:22:00',NULL,'2026-07-01 09:20:00','2026-07-01 09:22:00','2026-07-01 09:28:00','2026-07-01 09:45:00',NULL,0,NULL,NULL),(92,'202607021115020042',1010,2003,9,121.90,121.90,0.00,2,0.00,0.00,0.00,0.00,1,'IK_1010_20260702111501',0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,'2026-07-02 11:45:00','2026-07-02 11:16:30',NULL,'2026-07-02 11:15:00','2026-07-02 11:16:30',NULL,NULL,NULL,0,'583029',NULL),(93,'202607021430010043',1013,2006,NULL,68.70,73.70,0.00,1,5.00,0.00,0.00,0.00,5,'IK_1013_20260702143001',400,3,105,'吴小丽','17782222110',NULL,NULL,NULL,NULL,NULL,'重庆市大渡口区九宫庙湖榕路锦天康都1栋1204',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,'2026-07-02 15:00:00',NULL,'2026-07-04 03:32:45','2026-07-02 14:30:00','2026-07-04 03:32:45',NULL,NULL,NULL,0,NULL,NULL),(94,'202607031000010044',1007,2004,NULL,90.00,95.00,0.00,1,5.00,0.00,0.00,0.00,1,'IK_1007_20260703100001',0,0,107,'陈二','17782222112',NULL,NULL,NULL,NULL,NULL,'重庆市渝北区龙溪街道武陵路锦江郦城9栋1601',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,'2026-07-03 10:30:00','2026-07-03 10:02:00',NULL,'2026-07-03 10:00:00','2026-07-03 10:02:00',NULL,NULL,NULL,0,NULL,NULL),(95,'202607031645020045',1021,2001,7,45.80,45.80,0.00,2,0.00,0.00,0.00,0.00,5,'IK_1021_20260703164501',0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,'2026-07-03 17:15:00',NULL,'2026-07-04 03:32:45','2026-07-03 16:45:00','2026-07-04 03:32:45',NULL,NULL,NULL,0,'921056',NULL),(96,'202607040930010046',1008,2002,NULL,59.90,64.90,0.00,1,5.00,0.00,0.00,0.00,2,'IK_1008_20260704093001',0,0,106,'王一','17782222111',NULL,NULL,NULL,NULL,NULL,'重庆市巴南区鱼洞巴南印象6栋808',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,'2026-07-04 10:00:00','2026-07-04 09:31:50',NULL,'2026-07-04 09:30:00','2026-07-04 09:31:50','2026-07-04 09:36:00','2026-07-04 09:50:00',NULL,0,NULL,NULL),(97,'202607051100010047',1012,2005,NULL,66.70,71.70,0.00,1,5.00,0.00,0.00,0.00,0,'IK_1012_20260705110001',0,0,104,'周小明','17782222109',NULL,NULL,NULL,NULL,NULL,'重庆市九龙坡区谢家湾华润24城5栋2203',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,'2026-07-05 11:30:00',NULL,NULL,'2026-07-05 11:00:00','2026-07-05 11:00:00',NULL,NULL,NULL,0,NULL,NULL);
/*!40000 ALTER TABLE `order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_item`
--

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

--
-- Dumping data for table `order_item`
--

LOCK TABLES `order_item` WRITE;
/*!40000 ALTER TABLE `order_item` DISABLE KEYS */;
INSERT INTO `order_item` VALUES (91,51,6001,8001,'三只松鼠每日坚果30包礼盒','/static/product/6001.jpg','{\"规格\":\"30包装\",\"净重\":\"600g-750g\"}',77.00,77.00,77.00,1,77.00,77.00,'NORMAL'),(92,52,6005,8005,'卫龙大面筋68g*10包','/static/product/6005.jpg','{\"规格\":\"68g*10包\",\"口味\":\"香辣味\"}',19.90,19.90,19.90,2,39.80,39.80,'NORMAL'),(93,53,6009,8009,'阿克苏冰糖心苹果5斤','/static/product/6009.jpg','{\"规格\":\"5斤装\",\"果径\":\"80-85mm\"}',36.90,36.90,36.90,1,36.90,36.90,'NORMAL'),(94,54,6002,8002,'三只松鼠虎皮风爪袋装','/static/product/6002.jpg','{\"规格\":\"袋装\",\"净重\":\"200g\"}',26.00,26.00,26.00,1,26.00,26.00,'NORMAL'),(95,54,6004,8004,'旺旺雪饼520g','/static/product/6004.jpg','{\"规格\":\"520g\",\"包装\":\"家庭装\"}',22.90,22.90,22.90,1,22.90,22.90,'NORMAL'),(96,55,6011,8011,'阳光金果奇异果12粒礼盒','/static/product/6011.jpg','{\"规格\":\"12粒礼盒装\",\"单果\":\"90-110g\"}',118.00,118.00,118.00,1,118.00,118.00,'COUPON'),(97,56,6006,8006,'良品铺子蛋黄酥6枚','/static/product/6006.jpg','{\"规格\":\"6枚装\",\"净重\":\"330g\"}',35.00,35.00,35.00,1,35.00,35.00,'NORMAL'),(98,56,6008,8008,'良品铺子雪花酥300g','/static/product/6008.jpg','{\"规格\":\"300g\",\"口味\":\"蔓越莓味\"}',27.90,27.90,27.90,1,27.90,27.90,'NORMAL'),(99,57,6013,8013,'金龙鱼稻花香大米5kg','/static/product/6013.jpg','{\"规格\":\"5kg\",\"产地\":\"五常\"}',68.00,68.00,68.00,1,68.00,68.00,'NORMAL'),(100,57,6015,8015,'涪陵清爽榨菜80g*20袋','/static/product/6015.jpg','{\"规格\":\"80g*20袋\",\"口味\":\"清爽\"}',16.90,16.90,16.90,1,16.90,16.90,'NORMAL'),(101,58,6001,8001,'三只松鼠每日坚果30包礼盒','/static/product/6001.jpg','{\"规格\":\"30包装\",\"净重\":\"600g-750g\"}',77.00,77.00,77.00,1,77.00,77.00,'NORMAL'),(102,58,6003,8003,'良品铺子芒果干500g','/static/product/6003.jpg','{\"规格\":\"500g\",\"口味\":\"原味\"}',35.90,35.90,35.90,1,35.90,35.90,'COUPON'),(103,59,6017,8017,'有友泡椒凤爪210g','/static/product/6017.jpg','{\"规格\":\"210g\",\"口味\":\"泡椒味\"}',18.90,18.90,18.90,2,37.80,37.80,'NORMAL'),(104,60,6021,8021,'元气森林白桃气泡水480ml*15瓶','/static/product/6021.jpg','{\"规格\":\"480ml*15瓶\",\"口味\":\"白桃味\"}',65.00,65.00,65.00,1,65.00,65.00,'NORMAL'),(105,61,6007,8007,'良品铺子手工黑芝麻软糕400g','/static/product/6007.jpg','{\"规格\":\"400g\",\"口味\":\"黑芝麻味\"}',24.90,24.90,24.90,1,24.90,24.90,'NORMAL'),(106,62,6010,8010,'奉节脐橙8斤','/static/product/6010.jpg','{\"规格\":\"8斤装\",\"果径\":\"75-80mm\"}',49.90,49.90,49.90,1,49.90,49.90,'NORMAL'),(107,63,6014,8014,'海天金标生抽1.9L','/static/product/6014.jpg','{\"规格\":\"1.9L\",\"类型\":\"生抽\"}',22.90,22.90,22.90,1,22.90,22.90,'NORMAL'),(108,63,6016,8016,'农家红薯宽粉1000g','/static/product/6016.jpg','{\"规格\":\"1000g\",\"类型\":\"红薯粉\"}',22.00,22.00,22.00,1,22.00,22.00,'NORMAL'),(109,64,6018,8018,'绝味香辣鸭脖200g','/static/product/6018.jpg','{\"规格\":\"200g\",\"口味\":\"香辣味\"}',24.90,24.90,24.90,1,24.90,24.90,'NORMAL'),(110,65,6001,8001,'三只松鼠每日坚果30包礼盒','/static/product/6001.jpg','{\"规格\":\"30包装\",\"净重\":\"600g-750g\"}',77.00,77.00,77.00,1,77.00,77.00,'COUPON'),(111,66,6023,8023,'元气森林酸奶200g*12盒','/static/product/6023.jpg','{\"规格\":\"200g*12盒\",\"口味\":\"原味\"}',42.90,42.90,42.90,1,42.90,42.90,'NORMAL'),(112,66,6024,8024,'农夫山泉鲜榨芒果复合果汁1L','/static/product/6024.jpg','{\"规格\":\"1L\",\"口味\":\"芒果味\"}',22.90,22.90,22.90,1,22.90,22.90,'NORMAL'),(113,67,6005,8005,'卫龙大面筋68g*10包','/static/product/6005.jpg','{\"规格\":\"68g*10包\",\"口味\":\"香辣味\"}',19.90,19.90,19.90,2,39.80,39.80,'NORMAL'),(114,67,6007,8007,'良品铺子手工黑芝麻软糕400g','/static/product/6007.jpg','{\"规格\":\"400g\",\"口味\":\"黑芝麻味\"}',24.90,24.90,24.90,1,24.90,24.90,'NORMAL'),(115,68,6013,8013,'金龙鱼稻花香大米5kg','/static/product/6013.jpg','{\"规格\":\"5kg\",\"产地\":\"五常\"}',68.00,68.00,68.00,1,68.00,68.00,'NORMAL'),(116,68,6015,8015,'涪陵清爽榨菜80g*20袋','/static/product/6015.jpg','{\"规格\":\"80g*20袋\",\"口味\":\"清爽\"}',16.90,16.90,16.90,2,33.80,33.80,'NORMAL'),(117,69,6013,8013,'金龙鱼稻花香大米5kg','/static/product/6013.jpg','{\"规格\":\"5kg\",\"产地\":\"五常\"}',68.00,68.00,68.00,1,68.00,68.00,'NORMAL'),(118,70,6005,8005,'卫龙大面筋68g*10包','/static/product/6005.jpg','{\"规格\":\"68g*10包\",\"口味\":\"香辣味\"}',19.90,19.90,19.90,1,19.90,19.90,'NORMAL'),(119,70,6006,8006,'良品铺子蛋黄酥6枚','/static/product/6006.jpg','{\"规格\":\"6枚装\",\"净重\":\"330g\"}',35.00,35.00,35.00,1,35.00,35.00,'NORMAL'),(120,70,6008,8008,'良品铺子雪花酥300g','/static/product/6008.jpg','{\"规格\":\"300g\",\"口味\":\"蔓越莓味\"}',27.90,27.90,27.90,1,27.90,27.90,'NORMAL'),(121,71,6003,8003,'良品铺子芒果干500g','/static/product/6003.jpg','{\"规格\":\"500g\",\"口味\":\"原味\"}',35.90,35.90,35.90,1,35.90,35.90,'NORMAL'),(122,71,6004,8004,'旺旺雪饼520g','/static/product/6004.jpg','{\"规格\":\"520g\",\"包装\":\"家庭装\"}',22.90,22.90,22.90,1,22.90,22.90,'NORMAL'),(123,72,6012,8012,'沃隆每日坚果750g30袋','/static/product/6012.jpg','{\"规格\":\"750g 30袋\",\"品种\":\"混合坚果\"}',85.00,85.00,85.00,1,85.00,85.00,'NORMAL'),(124,73,6019,8019,'绝味原切牛肉脯150g','/static/product/6019.jpg','{\"规格\":\"150g\",\"口味\":\"原味\"}',29.90,29.90,29.90,1,29.90,29.90,'NORMAL'),(125,74,6022,8022,'农夫山泉100%鲜榨橙汁900ml','/static/product/6022.jpg','{\"规格\":\"900ml\",\"类型\":\"NFC鲜榨\"}',19.90,19.90,19.90,2,39.80,39.80,'NORMAL'),(126,75,6002,8002,'三只松鼠虎皮风爪袋装','/static/product/6002.jpg','{\"规格\":\"袋装\",\"净重\":\"200g\"}',26.00,26.00,26.00,2,52.00,52.00,'NORMAL'),(127,75,6004,8004,'旺旺雪饼520g','/static/product/6004.jpg','{\"规格\":\"520g\",\"包装\":\"家庭装\"}',22.90,22.90,22.90,1,22.90,22.90,'COUPON'),(128,76,6014,8014,'海天金标生抽1.9L','/static/product/6014.jpg','{\"规格\":\"1.9L\",\"类型\":\"生抽\"}',22.90,22.90,22.90,1,22.90,22.90,'NORMAL'),(129,76,6015,8015,'涪陵清爽榨菜80g*20袋','/static/product/6015.jpg','{\"规格\":\"80g*20袋\",\"口味\":\"清爽\"}',16.90,16.90,16.90,1,16.90,16.90,'NORMAL'),(130,77,6010,8010,'奉节脐橙8斤','/static/product/6010.jpg','{\"规格\":\"8斤装\",\"果径\":\"75-80mm\"}',49.90,49.90,49.90,1,49.90,49.90,'NORMAL'),(131,78,6020,8020,'有友现卤五香鹌鹑蛋300g','/static/product/6020.jpg','{\"规格\":\"300g\",\"口味\":\"五香味\"}',16.90,16.90,16.90,2,33.80,33.80,'NORMAL'),(132,79,6017,8017,'有友泡椒凤爪210g','/static/product/6017.jpg','{\"规格\":\"210g\",\"口味\":\"泡椒味\"}',18.90,18.90,18.90,1,18.90,18.90,'NORMAL'),(133,79,6020,8020,'有友现卤五香鹌鹑蛋300g','/static/product/6020.jpg','{\"规格\":\"300g\",\"口味\":\"五香味\"}',16.90,16.90,16.90,1,16.90,16.90,'NORMAL'),(134,80,6005,8005,'卫龙大面筋68g*10包','/static/product/6005.jpg','{\"规格\":\"68g*10包\",\"口味\":\"香辣味\"}',19.90,19.90,19.90,3,59.70,59.70,'NORMAL'),(135,81,6003,8003,'良品铺子芒果干500g','/static/product/6003.jpg','{\"规格\":\"500g\",\"口味\":\"原味\"}',35.90,35.90,35.90,2,71.80,71.80,'COUPON'),(136,82,6021,8021,'元气森林白桃气泡水480ml*15瓶','/static/product/6021.jpg','{\"规格\":\"480ml*15瓶\",\"口味\":\"白桃味\"}',65.00,65.00,65.00,1,65.00,65.00,'NORMAL'),(137,82,6022,8022,'农夫山泉100%鲜榨橙汁900ml','/static/product/6022.jpg','{\"规格\":\"900ml\",\"类型\":\"NFC鲜榨\"}',19.90,19.90,19.90,1,19.90,19.90,'NORMAL'),(138,83,6016,8016,'农家红薯宽粉1000g','/static/product/6016.jpg','{\"规格\":\"1000g\",\"类型\":\"红薯粉\"}',22.00,22.00,22.00,2,44.00,44.00,'NORMAL'),(139,84,6008,8008,'良品铺子雪花酥300g','/static/product/6008.jpg','{\"规格\":\"300g\",\"口味\":\"蔓越莓味\"}',27.90,27.90,27.90,2,55.80,55.80,'NORMAL'),(140,85,6018,8018,'绝味香辣鸭脖200g','/static/product/6018.jpg','{\"规格\":\"200g\",\"口味\":\"香辣味\"}',24.90,24.90,24.90,1,24.90,24.90,'NORMAL'),(141,85,6019,8019,'绝味原切牛肉脯150g','/static/product/6019.jpg','{\"规格\":\"150g\",\"口味\":\"原味\"}',29.90,29.90,29.90,1,29.90,29.90,'COUPON'),(142,86,6011,8011,'阳光金果奇异果12粒礼盒','/static/product/6011.jpg','{\"规格\":\"12粒礼盒装\",\"单果\":\"90-110g\"}',118.00,118.00,118.00,1,118.00,118.00,'COUPON'),(143,87,6013,8013,'金龙鱼稻花香大米5kg','/static/product/6013.jpg','{\"规格\":\"5kg\",\"产地\":\"五常\"}',68.00,68.00,68.00,1,68.00,68.00,'NORMAL'),(144,88,6007,8007,'良品铺子手工黑芝麻软糕400g','/static/product/6007.jpg','{\"规格\":\"400g\",\"口味\":\"黑芝麻味\"}',24.90,24.90,24.90,2,49.80,49.80,'NORMAL'),(145,89,6001,8001,'三只松鼠每日坚果30包礼盒','/static/product/6001.jpg','{\"规格\":\"30包装\",\"净重\":\"600g-750g\"}',77.00,77.00,77.00,1,77.00,77.00,'NORMAL'),(146,89,6002,8002,'三只松鼠虎皮风爪袋装','/static/product/6002.jpg','{\"规格\":\"袋装\",\"净重\":\"200g\"}',26.00,26.00,26.00,1,26.00,26.00,'NORMAL'),(147,90,6023,8023,'元气森林酸奶200g*12盒','/static/product/6023.jpg','{\"规格\":\"200g*12盒\",\"口味\":\"原味\"}',42.90,42.90,42.90,1,42.90,42.90,'NORMAL'),(148,91,6017,8017,'有友泡椒凤爪210g','/static/product/6017.jpg','{\"规格\":\"210g\",\"口味\":\"泡椒味\"}',18.90,18.90,18.90,3,56.70,56.70,'NORMAL'),(149,92,6009,8009,'阿克苏冰糖心苹果5斤','/static/product/6009.jpg','{\"规格\":\"5斤装\",\"果径\":\"80-85mm\"}',36.90,36.90,36.90,1,36.90,36.90,'NORMAL'),(150,92,6012,8012,'沃隆每日坚果750g30袋','/static/product/6012.jpg','{\"规格\":\"750g 30袋\",\"品种\":\"混合坚果\"}',85.00,85.00,85.00,1,85.00,85.00,'SECKILL'),(151,93,6024,8024,'农夫山泉鲜榨芒果复合果汁1L','/static/product/6024.jpg','{\"规格\":\"1L\",\"口味\":\"芒果味\"}',22.90,22.90,22.90,3,68.70,68.70,'NORMAL'),(152,94,6013,8013,'金龙鱼稻花香大米5kg','/static/product/6013.jpg','{\"规格\":\"5kg\",\"产地\":\"五常\"}',68.00,68.00,68.00,1,68.00,68.00,'NORMAL'),(153,94,6016,8016,'农家红薯宽粉1000g','/static/product/6016.jpg','{\"规格\":\"1000g\",\"类型\":\"红薯粉\"}',22.00,22.00,22.00,1,22.00,22.00,'NORMAL'),(154,95,6004,8004,'旺旺雪饼520g','/static/product/6004.jpg','{\"规格\":\"520g\",\"包装\":\"家庭装\"}',22.90,22.90,22.90,2,45.80,45.80,'NORMAL'),(155,96,6006,8006,'良品铺子蛋黄酥6枚','/static/product/6006.jpg','{\"规格\":\"6枚装\",\"净重\":\"330g\"}',35.00,35.00,35.00,1,35.00,35.00,'NORMAL'),(156,96,6007,8007,'良品铺子手工黑芝麻软糕400g','/static/product/6007.jpg','{\"规格\":\"400g\",\"口味\":\"黑芝麻味\"}',24.90,24.90,24.90,1,24.90,24.90,'NORMAL'),(157,97,6018,8018,'绝味香辣鸭脖200g','/static/product/6018.jpg','{\"规格\":\"200g\",\"口味\":\"香辣味\"}',24.90,24.90,24.90,2,49.80,49.80,'NORMAL'),(158,97,6020,8020,'有友现卤五香鹌鹑蛋300g','/static/product/6020.jpg','{\"规格\":\"300g\",\"口味\":\"五香味\"}',16.90,16.90,16.90,1,16.90,16.90,'NORMAL');
/*!40000 ALTER TABLE `order_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_status_log`
--

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

--
-- Dumping data for table `order_status_log`
--

LOCK TABLES `order_status_log` WRITE;
/*!40000 ALTER TABLE `order_status_log` DISABLE KEYS */;
INSERT INTO `order_status_log` VALUES (1,93,0,5,'CANCELLED','SYSTEM',NULL,'支付超时自动取消','2026-07-04 03:32:46'),(2,95,0,5,'CANCELLED','SYSTEM',NULL,'支付超时自动取消','2026-07-04 03:32:46');
/*!40000 ALTER TABLE `order_status_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payment`
--

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

--
-- Dumping data for table `payment`
--

LOCK TABLES `payment` WRITE;
/*!40000 ALTER TABLE `payment` DISABLE KEYS */;
INSERT INTO `payment` VALUES (41,51,'PAY202605051031250001',NULL,1,82.00,1,'2026-05-05 10:31:25',NULL,NULL,0,0.00,NULL,'2026-07-04 03:18:51','2026-07-04 03:18:51'),(42,52,'PAY202605061422300001',NULL,2,44.80,1,'2026-05-06 14:22:30',NULL,NULL,0,0.00,NULL,'2026-07-04 03:18:51','2026-07-04 03:18:51'),(43,53,'PAY202605070916400001',NULL,1,36.90,1,'2026-05-07 09:16:40',NULL,NULL,0,0.00,NULL,'2026-07-04 03:18:51','2026-07-04 03:18:51'),(44,54,'PAY202605081646100001',NULL,2,48.90,1,'2026-05-08 16:46:10',NULL,NULL,0,0.00,NULL,'2026-07-04 03:18:51','2026-07-04 03:18:51'),(45,55,'PAY202605091131500001',NULL,1,118.00,1,'2026-05-09 11:31:50',NULL,NULL,0,0.00,NULL,'2026-07-04 03:18:51','2026-07-04 03:18:51'),(46,56,'PAY202605100852150001',NULL,2,62.90,1,'2026-05-10 08:52:15',NULL,NULL,0,0.00,NULL,'2026-07-04 03:18:51','2026-07-04 03:18:51'),(47,57,'PAY202605121311300001',NULL,1,89.90,1,'2026-05-12 13:11:30',NULL,NULL,0,0.00,NULL,'2026-07-04 03:18:51','2026-07-04 03:18:51'),(48,58,'PAY202605141027050001',NULL,1,107.90,1,'2026-05-14 10:27:05',NULL,NULL,0,0.00,NULL,'2026-07-04 03:18:51','2026-07-04 03:18:51'),(49,59,'PAY202605170941200001',NULL,2,42.80,1,'2026-05-17 09:41:20',NULL,NULL,0,0.00,NULL,'2026-07-04 03:18:51','2026-07-04 03:18:51'),(50,60,'PAY202605181521450001',NULL,1,70.00,1,'2026-05-18 15:21:45',NULL,NULL,0,0.00,NULL,'2026-07-04 03:18:51','2026-07-04 03:18:51'),(51,61,'PAY202605201106300001',NULL,2,24.90,1,'2026-05-20 11:06:30',NULL,NULL,0,0.00,NULL,'2026-07-04 03:18:51','2026-07-04 03:18:51'),(52,62,'PAY202605211431500001',NULL,1,54.90,1,'2026-05-21 14:31:50',NULL,NULL,0,0.00,NULL,'2026-07-04 03:18:51','2026-07-04 03:18:51'),(53,63,'PAY202605221716300001',NULL,2,49.90,1,'2026-05-22 17:16:30',NULL,NULL,1,49.90,'2026-05-22 17:40:00','2026-07-04 03:18:51','2026-07-04 03:18:51'),(54,64,'PAY202605241001400001',NULL,1,29.90,1,'2026-05-24 10:01:40',NULL,NULL,0,0.00,NULL,'2026-07-04 03:18:51','2026-07-04 03:18:51'),(55,65,'PAY202605251651300001',NULL,1,72.00,1,'2026-05-25 16:51:30',NULL,NULL,0,0.00,NULL,'2026-07-04 03:18:51','2026-07-04 03:18:51'),(56,66,'PAY202605270931250001',NULL,2,70.80,1,'2026-05-27 09:31:25',NULL,NULL,0,0.00,NULL,'2026-07-04 03:18:51','2026-07-04 03:18:51'),(57,67,'PAY202605291346100001',NULL,1,69.70,1,'2026-05-29 13:46:10',NULL,NULL,0,0.00,NULL,'2026-07-04 03:18:51','2026-07-04 03:18:51'),(58,68,'PAY202605301122000001',NULL,2,106.80,1,'2026-05-30 11:22:00',NULL,NULL,0,0.00,NULL,'2026-07-04 03:18:51','2026-07-04 03:18:51'),(59,69,'PAY202606011031300001',NULL,1,73.00,1,'2026-06-01 10:31:30',NULL,NULL,0,0.00,NULL,'2026-07-04 03:18:51','2026-07-04 03:18:51'),(60,70,'PAY202606031401200001',NULL,2,82.80,1,'2026-06-03 14:01:20',NULL,NULL,0,0.00,NULL,'2026-07-04 03:18:51','2026-07-04 03:18:51'),(61,71,'PAY202606050916100001',NULL,1,63.80,1,'2026-06-05 09:16:10',NULL,NULL,0,0.00,NULL,'2026-07-04 03:18:51','2026-07-04 03:18:51'),(62,72,'PAY202606071632000001',NULL,1,85.00,1,'2026-06-07 16:32:00',NULL,NULL,0,0.00,NULL,'2026-07-04 03:18:51','2026-07-04 03:18:51'),(63,73,'PAY202606091146400001',NULL,2,34.90,1,'2026-06-09 11:46:40',NULL,NULL,0,0.00,NULL,'2026-07-04 03:18:51','2026-07-04 03:18:51'),(64,74,'PAY202606100852000001',NULL,1,44.80,1,'2026-06-10 08:52:00',NULL,NULL,1,44.80,'2026-06-10 09:10:00','2026-07-04 03:18:51','2026-07-04 03:18:51'),(65,75,'PAY202606121511300001',NULL,2,64.90,1,'2026-06-12 15:11:30',NULL,NULL,0,0.00,NULL,'2026-07-04 03:18:51','2026-07-04 03:18:51'),(66,76,'PAY202606131026300001',NULL,1,44.80,1,'2026-06-13 10:26:30',NULL,NULL,0,0.00,NULL,'2026-07-04 03:18:51','2026-07-04 03:18:51'),(67,77,'PAY202606141431500001',NULL,2,49.90,1,'2026-06-14 14:31:50',NULL,NULL,0,0.00,NULL,'2026-07-04 03:18:51','2026-07-04 03:18:51'),(68,78,'PAY202606151621300001',NULL,1,38.80,1,'2026-06-15 16:21:30',NULL,NULL,0,0.00,NULL,'2026-07-04 03:18:51','2026-07-04 03:18:51'),(69,79,'PAY202606150952000001',NULL,2,40.80,1,'2026-06-15 09:52:00',NULL,NULL,0,0.00,NULL,'2026-07-04 03:18:51','2026-07-04 03:18:51'),(70,80,'PAY202606171131200001',NULL,1,64.70,1,'2026-06-17 11:31:20',NULL,NULL,0,0.00,NULL,'2026-07-04 03:18:51','2026-07-04 03:18:51'),(71,81,'PAY202606181601400001',NULL,1,66.80,1,'2026-06-18 16:01:40',NULL,NULL,0,0.00,NULL,'2026-07-04 03:18:51','2026-07-04 03:18:51'),(72,82,'PAY202606201017000001',NULL,2,89.90,1,'2026-06-20 10:17:00',NULL,NULL,0,0.00,NULL,'2026-07-04 03:18:51','2026-07-04 03:18:51'),(73,83,'PAY202606211446300001',NULL,1,49.00,1,'2026-06-21 14:46:30',NULL,NULL,0,0.00,NULL,'2026-07-04 03:18:51','2026-07-04 03:18:51'),(74,84,'PAY202606221001500001',NULL,2,55.80,1,'2026-06-22 10:01:50',NULL,NULL,0,0.00,NULL,'2026-07-04 03:18:51','2026-07-04 03:18:51'),(75,85,'PAY202606230931400001',NULL,1,54.80,1,'2026-06-23 09:31:40',NULL,NULL,0,0.00,NULL,'2026-07-04 03:18:51','2026-07-04 03:18:51'),(76,86,'PAY202606241721300001',NULL,1,113.00,1,'2026-06-24 17:21:30',NULL,NULL,0,0.00,NULL,'2026-07-04 03:18:51','2026-07-04 03:18:51'),(77,87,'PAY202606261102000001',NULL,2,73.00,1,'2026-06-26 11:02:00',NULL,NULL,1,73.00,'2026-06-26 11:20:00','2026-07-04 03:18:51','2026-07-04 03:18:51'),(78,88,'PAY202606271531200001',NULL,2,49.80,1,'2026-06-27 15:31:20',NULL,NULL,0,0.00,NULL,'2026-07-04 03:18:51','2026-07-04 03:18:51'),(79,89,'PAY202606291006300001',NULL,1,108.00,1,'2026-06-29 10:06:30',NULL,NULL,0,0.00,NULL,'2026-07-04 03:18:51','2026-07-04 03:18:51'),(80,90,'PAY202606301341200001',NULL,1,47.90,1,'2026-06-30 13:41:20',NULL,NULL,0,0.00,NULL,'2026-07-04 03:18:51','2026-07-04 03:18:51'),(81,91,'PAY202607010922000001',NULL,2,61.70,1,'2026-07-01 09:22:00',NULL,NULL,0,0.00,NULL,'2026-07-04 03:18:51','2026-07-04 03:18:51'),(82,92,'PAY202607021116300001',NULL,1,121.90,1,'2026-07-02 11:16:30',NULL,NULL,0,0.00,NULL,'2026-07-04 03:18:51','2026-07-04 03:18:51'),(83,94,'PAY202607031002000001',NULL,2,95.00,1,'2026-07-03 10:02:00',NULL,NULL,0,0.00,NULL,'2026-07-04 03:18:51','2026-07-04 03:18:51'),(84,96,'PAY202607040931500001',NULL,1,64.90,1,'2026-07-04 09:31:50',NULL,NULL,0,0.00,NULL,'2026-07-04 03:18:51','2026-07-04 03:18:51');
/*!40000 ALTER TABLE `payment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pickup_point`
--

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

--
-- Dumping data for table `pickup_point`
--

LOCK TABLES `pickup_point` WRITE;
/*!40000 ALTER TABLE `pickup_point` DISABLE KEYS */;
INSERT INTO `pickup_point` VALUES (7,2001,'润禾生活食铺自提点','重庆市渝中区解放西路126号附8号','17782224500',NULL,1,1,NULL,'2026-05-10 10:00:00',NULL,NULL),(8,2002,'食愈小站自提点','重庆市大渡口区新山村春晖路66号','17782224501',NULL,1,1,NULL,'2026-05-10 10:00:00',NULL,NULL),(9,2003,'鲜禧果仓自提点','重庆市巴南区龙洲湾渝南大道132号','17782224502',NULL,1,1,NULL,'2026-05-10 10:00:00',NULL,NULL);
/*!40000 ALTER TABLE `pickup_point` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `platform_account_summary`
--

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

--
-- Dumping data for table `platform_account_summary`
--

LOCK TABLES `platform_account_summary` WRITE;
/*!40000 ALTER TABLE `platform_account_summary` DISABLE KEYS */;
INSERT INTO `platform_account_summary` VALUES (1,0.00,0.00,0.00,0.00,'2026-07-04 03:18:52');
/*!40000 ALTER TABLE `platform_account_summary` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `platform_promotion`
--

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

--
-- Dumping data for table `platform_promotion`
--

LOCK TABLES `platform_promotion` WRITE;
/*!40000 ALTER TABLE `platform_promotion` DISABLE KEYS */;
/*!40000 ALTER TABLE `platform_promotion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `platform_promotion_tier`
--

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

--
-- Dumping data for table `platform_promotion_tier`
--

LOCK TABLES `platform_promotion_tier` WRITE;
/*!40000 ALTER TABLE `platform_promotion_tier` DISABLE KEYS */;
/*!40000 ALTER TABLE `platform_promotion_tier` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `platform_revenue_detail`
--

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

--
-- Dumping data for table `platform_revenue_detail`
--

LOCK TABLES `platform_revenue_detail` WRITE;
/*!40000 ALTER TABLE `platform_revenue_detail` DISABLE KEYS */;
INSERT INTO `platform_revenue_detail` VALUES (1001,51,2001,'COMMISSION',6.16,'订单#51 平台佣金(8%)','2026-05-05 11:00:00'),(1002,51,2001,'SUBSIDY',0.00,'无补贴','2026-05-05 11:00:00'),(1003,52,2002,'COMMISSION',3.18,'订单#52 平台佣金(8%)','2026-05-06 14:50:00'),(1004,53,2003,'COMMISSION',2.95,'订单#53 平台佣金(8%)','2026-05-07 09:45:00'),(1005,54,2001,'COMMISSION',3.91,'订单#54 平台佣金(8%)','2026-05-08 17:15:00'),(1006,55,2003,'COMMISSION',8.80,'订单#55 平台佣金(8%-优惠后)','2026-05-09 12:00:00'),(1007,55,2003,'SUBSIDY',5.00,'订单#55 优惠券补贴','2026-05-09 12:00:00'),(1008,56,2002,'COMMISSION',5.03,'订单#56 平台佣金(8%)','2026-05-10 09:20:00'),(1009,57,2004,'COMMISSION',6.79,'订单#57 平台佣金(8%)','2026-05-12 13:40:00'),(1010,58,2001,'COMMISSION',8.63,'订单#58 平台佣金(8%-优惠后)','2026-05-14 10:55:00'),(1011,58,2001,'SUBSIDY',10.00,'订单#58 满减补贴','2026-05-14 10:55:00'),(1012,59,2005,'COMMISSION',3.02,'订单#59 平台佣金(8%)','2026-05-17 10:10:00'),(1013,60,2006,'COMMISSION',5.20,'订单#60 平台佣金(8%)','2026-05-18 15:50:00'),(1014,61,2002,'COMMISSION',1.99,'订单#61 平台佣金(8%)','2026-05-20 11:35:00'),(1015,62,2003,'COMMISSION',3.99,'订单#62 平台佣金(8%)','2026-05-21 15:00:00'),(1016,63,2004,'COMMISSION',3.59,'订单#63 平台佣金(8%)','2026-05-22 17:45:00'),(1017,64,2005,'COMMISSION',1.99,'订单#64 平台佣金(8%)','2026-05-24 10:30:00'),(1018,65,2001,'COMMISSION',5.76,'订单#65 平台佣金(8%-优惠后)','2026-05-25 17:20:00'),(1019,65,2001,'SUBSIDY',5.00,'订单#65 秒杀补贴','2026-05-25 17:20:00'),(1020,66,2006,'COMMISSION',5.26,'订单#66 平台佣金(8%)','2026-05-27 10:00:00'),(1021,67,2002,'COMMISSION',5.18,'订单#67 平台佣金(8%)','2026-05-29 14:15:00'),(1022,68,2004,'COMMISSION',8.14,'订单#68 平台佣金(8%)','2026-05-30 11:50:00'),(1023,69,2004,'COMMISSION',5.44,'订单#69 平台佣金(8%)','2026-06-01 11:00:00'),(1024,70,2002,'COMMISSION',6.62,'订单#70 平台佣金(8%)','2026-06-03 14:30:00'),(1025,71,2001,'COMMISSION',4.70,'订单#71 平台佣金(8%)','2026-06-05 09:45:00'),(1026,72,2003,'COMMISSION',6.80,'订单#72 平台佣金(8%-优惠后)','2026-06-07 17:00:00'),(1027,72,2003,'SUBSIDY',5.00,'订单#72 优惠券补贴','2026-06-07 17:00:00'),(1028,73,2005,'COMMISSION',2.39,'订单#73 平台佣金(8%)','2026-06-09 12:15:00'),(1029,74,2006,'COMMISSION',3.18,'订单#74 平台佣金(8%)','2026-06-10 09:20:00'),(1030,75,2001,'COMMISSION',5.19,'订单#75 平台佣金(8%-优惠后)','2026-06-12 15:40:00'),(1031,75,2001,'SUBSIDY',10.00,'订单#75 秒杀补贴','2026-06-12 15:40:00'),(1032,76,2004,'COMMISSION',3.18,'订单#76 平台佣金(8%)','2026-06-13 10:55:00'),(1033,77,2003,'COMMISSION',3.99,'订单#77 平台佣金(8%)','2026-06-14 15:00:00'),(1034,78,2005,'COMMISSION',2.70,'订单#78 平台佣金(8%)','2026-06-15 16:50:00'),(1035,79,2005,'COMMISSION',2.86,'订单#79 平台佣金(8%)','2026-06-15 10:20:00'),(1036,80,2002,'COMMISSION',4.78,'订单#80 平台佣金(8%)','2026-06-17 12:00:00'),(1037,81,2001,'COMMISSION',5.34,'订单#81 平台佣金(8%-优惠后)','2026-06-18 16:30:00'),(1038,81,2001,'SUBSIDY',5.00,'订单#81 秒杀补贴','2026-06-18 16:30:00'),(1039,82,2006,'COMMISSION',6.79,'订单#82 平台佣金(8%)','2026-06-20 10:45:00'),(1040,83,2004,'COMMISSION',3.52,'订单#83 平台佣金(8%)','2026-06-21 15:15:00'),(1041,84,2002,'COMMISSION',4.46,'订单#84 平台佣金(8%)','2026-06-22 10:30:00'),(1042,85,2005,'COMMISSION',4.38,'订单#85 平台佣金(8%-优惠后)','2026-06-23 10:00:00'),(1043,85,2005,'SUBSIDY',5.00,'订单#85 秒杀补贴','2026-06-23 10:00:00'),(1044,86,2003,'COMMISSION',9.04,'订单#86 平台佣金(8%-优惠后)','2026-06-24 17:50:00'),(1045,86,2003,'SUBSIDY',5.00,'订单#86 秒杀补贴','2026-06-24 17:50:00'),(1046,87,2004,'COMMISSION',5.44,'订单#87 平台佣金(8%)','2026-06-26 11:30:00'),(1047,88,2002,'COMMISSION',3.98,'订单#88 平台佣金(8%)','2026-06-27 16:00:00'),(1048,89,2001,'COMMISSION',8.24,'订单#89 平台佣金(8%)','2026-06-29 10:35:00'),(1049,90,2006,'COMMISSION',3.43,'订单#90 平台佣金(8%)','2026-06-30 14:10:00'),(1050,91,2005,'COMMISSION',4.54,'订单#91 平台佣金(8%)','2026-07-01 09:50:00'),(1051,92,2003,'COMMISSION',9.75,'订单#92 平台佣金(8%)','2026-07-02 11:45:00'),(1052,93,2006,'COMMISSION',5.50,'订单#93 平台佣金(8%)','2026-07-02 15:00:00'),(1053,94,2004,'COMMISSION',7.20,'订单#94 平台佣金(8%)','2026-07-03 10:30:00'),(1054,95,2001,'COMMISSION',3.66,'订单#95 平台佣金(8%)','2026-07-03 17:15:00'),(1055,96,2002,'COMMISSION',4.79,'订单#96 平台佣金(8%)','2026-07-04 10:00:00'),(1056,97,2005,'COMMISSION',5.34,'订单#97 平台佣金(8%)','2026-07-05 11:30:00');
/*!40000 ALTER TABLE `platform_revenue_detail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `points_log`
--

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

--
-- Dumping data for table `points_log`
--

LOCK TABLES `points_log` WRITE;
/*!40000 ALTER TABLE `points_log` DISABLE KEYS */;
INSERT INTO `points_log` VALUES (1,1007,2,10,10,'每日签到','2026-05-05 08:00:00'),(2,1008,2,15,15,'每日签到','2026-05-05 08:10:00'),(3,1009,2,8,8,'每日签到','2026-05-05 08:30:00'),(4,1010,2,12,12,'每日签到','2026-05-06 09:00:00'),(5,1007,1,36,46,'购物获得-订单202605070915020003','2026-05-07 17:00:00'),(6,1007,2,5,51,'每日签到','2026-05-08 07:30:00'),(7,1008,1,48,63,'购物获得-订单202605081645010004','2026-05-09 11:00:00'),(8,1008,2,18,81,'每日签到','2026-05-09 08:00:00'),(9,1009,1,62,70,'购物获得-订单202605100850020006','2026-05-10 18:00:00'),(10,1009,2,7,77,'每日签到','2026-05-10 07:45:00'),(11,1010,2,20,20,'每日签到','2026-05-11 08:30:00'),(12,1010,1,89,109,'购物获得-订单202605121310010007','2026-05-13 08:00:00'),(13,1011,2,13,13,'每日签到','2026-05-14 08:00:00'),(14,1012,2,6,6,'每日签到','2026-05-15 08:15:00'),(15,1011,1,42,55,'购物获得-订单202605170940010009','2026-05-18 08:30:00'),(16,1012,1,70,76,'购物获得-订单202605181520010010','2026-05-19 10:00:00'),(17,1013,2,9,9,'每日签到','2026-05-19 08:00:00'),(18,1007,2,11,62,'每日签到','2026-05-20 08:00:00'),(19,1008,3,-50,31,'兑换优惠券消耗','2026-05-20 12:00:00'),(20,1013,1,54,63,'购物获得-订单202605211430010012','2026-05-22 09:00:00'),(21,1014,2,16,16,'每日签到','2026-05-22 08:30:00'),(22,1009,3,-80,-3,'兑换优惠券消耗','2026-05-23 10:00:00'),(23,1007,1,29,91,'购物获得-订单202605241000010014','2026-05-25 08:30:00'),(24,1014,1,72,88,'购物获得-订单202605251650020015','2026-05-26 09:00:00'),(25,1010,2,14,123,'每日签到','2026-05-26 08:00:00'),(26,1007,2,8,99,'每日签到','2026-05-27 08:15:00'),(27,1015,2,17,17,'每日签到','2026-05-28 08:00:00'),(28,1011,3,-30,25,'兑换优惠券消耗','2026-05-28 15:00:00'),(29,1008,2,5,36,'每日签到','2026-05-30 09:00:00'),(30,1015,1,106,123,'购物获得-订单202605301120010018','2026-05-31 09:00:00'),(31,1009,2,12,9,'每日签到','2026-06-01 08:00:00'),(32,1017,2,18,18,'每日签到','2026-06-02 08:30:00'),(33,1007,1,82,181,'购物获得-订单202606031400020020','2026-06-04 10:00:00'),(34,1010,1,63,186,'购物获得-订单202606050915010021','2026-06-06 08:30:00'),(35,1011,1,85,110,'购物获得-订单202606071630020022','2026-06-08 09:00:00'),(36,1008,1,34,70,'购物获得-订单202606091145010023','2026-06-10 08:00:00'),(37,1009,2,15,24,'每日签到','2026-06-10 08:00:00'),(38,1007,4,77,258,'退款退回-售后订单1','2026-06-10 12:00:00'),(39,1010,2,11,197,'每日签到','2026-06-11 08:00:00'),(40,1009,1,49,73,'购物获得-订单202606141430020027','2026-06-14 18:00:00'),(41,1009,1,38,111,'购物获得-订单202606151620010028','2026-06-16 08:30:00'),(42,1018,1,40,40,'购物获得-订单202606150950010029','2026-06-16 09:00:00'),(43,1018,2,10,50,'每日签到','2026-06-17 08:00:00'),(44,1012,1,66,142,'购物获得-订单202606181600020031','2026-06-19 09:00:00'),(45,1010,1,89,286,'购物获得-订单202606201015010032','2026-06-21 08:30:00'),(46,1013,1,49,112,'购物获得-订单202606211445010033','2026-06-22 09:00:00'),(47,1010,1,55,341,'购物获得-订单202606221000020034','2026-06-23 08:00:00'),(48,1007,1,54,312,'购物获得-订单202606230930010035','2026-06-24 09:00:00'),(49,1019,1,113,113,'购物获得-订单202606241720020036','2026-06-25 09:30:00'),(50,1010,3,-100,241,'兑换优惠券消耗','2026-06-26 10:00:00'),(51,1007,2,7,319,'每日签到','2026-06-27 08:00:00'),(52,1020,1,49,49,'购物获得-订单202606271530020038','2026-06-28 09:00:00'),(53,1008,1,108,178,'购物获得-订单202606291005010039','2026-06-30 08:30:00'),(54,1008,4,77,255,'退款退回-售后订单2','2026-07-02 09:00:00'),(55,1020,2,19,68,'每日签到','2026-07-02 08:00:00'),(56,1007,3,-50,269,'兑换优惠券消耗','2026-07-03 14:00:00'),(57,1019,2,13,126,'每日签到','2026-07-03 08:00:00'),(58,1015,2,8,131,'每日签到','2026-07-04 08:00:00'),(59,1009,2,14,125,'每日签到','2026-07-04 08:30:00'),(60,1013,2,6,118,'每日签到','2026-07-05 08:00:00'),(61,1013,5,400,650,'订单取消，退回抵扣积分，订单号：202607021430010043','2026-07-04 03:32:46');
/*!40000 ALTER TABLE `points_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `poster`
--

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

--
-- Dumping data for table `poster`
--

LOCK TABLES `poster` WRITE;
/*!40000 ALTER TABLE `poster` DISABLE KEYS */;
INSERT INTO `poster` VALUES (1,'618年中大促海报','/static/poster/poster_01.jpg','{\"width\":200,\"height\":200,\"x\":150,\"y\":400}',1),(2,'新用户邀请海报','/static/poster/poster_02.jpg','{\"width\":180,\"height\":180,\"x\":160,\"y\":380}',1),(3,'每日特价海报','/static/poster/poster_03.jpg','{\"width\":220,\"height\":220,\"x\":140,\"y\":420}',0);
/*!40000 ALTER TABLE `poster` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product`
--

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

--
-- Dumping data for table `product`
--

LOCK TABLES `product` WRITE;
/*!40000 ALTER TABLE `product` DISABLE KEYS */;
INSERT INTO `product` VALUES (6001,5001,2001,'三只松鼠每日坚果30包礼盒','果仁饱满 营养均衡','/static/product/6001.jpg','<p>混合坚果独立小袋，全家代餐零食</p>',NULL,3,1,NULL,NULL,NULL,NULL,NULL,35),(6002,5001,2001,'三只松鼠虎皮风爪袋装','软烂脱骨 卤香入味','/static/product/6002.jpg','<p>老卤慢炖鸡爪，追剧网红即食卤味零食</p>',NULL,3,1,NULL,NULL,NULL,NULL,NULL,25),(6003,5002,2001,'良品铺子芒果干500g大包装','果肉厚实 酸甜不腻','/static/product/6003.jpg','<p>鲜芒果低温烘干，无过多添加蜜饯</p>',NULL,3,1,NULL,NULL,NULL,NULL,NULL,18),(6004,5004,2001,'旺旺雪饼520g家庭装','酥脆米香 童年味道','/static/product/6004.jpg','<p>经典膨化米饼，办公室家庭常备小零食</p>',NULL,3,1,NULL,NULL,NULL,NULL,NULL,42),(6005,5003,2002,'卫龙大面筋68g*10包','香辣劲道 解馋小吃','/static/product/6005.jpg','<p>经典麻辣辣条，便携独立小包办公室零食</p>',NULL,3,1,NULL,NULL,NULL,NULL,NULL,28),(6006,5002,2002,'良品铺子蛋黄酥6枚盒装','绵密沙糯 多层馅料','/static/product/6006.jpg','<p>雪媚娘红豆咸蛋黄点心，下午茶糕点</p>',NULL,3,1,NULL,NULL,NULL,NULL,NULL,15),(6007,5002,2002,'良品铺子手工黑芝麻软糕400g','软糯香甜 无添加蔗糖','/static/product/6007.jpg','<p>传统手工糕点，老人小孩均可食用</p>',NULL,3,1,NULL,NULL,NULL,NULL,NULL,12),(6008,5002,2002,'良品铺子雪花酥300g','奶香浓郁 坚果混合','/static/product/6008.jpg','<p>牛轧雪花酥，蔓越莓坚果组合网红点心</p>',NULL,3,1,NULL,NULL,NULL,NULL,NULL,32),(6009,5005,2003,'阿克苏冰糖心苹果5斤装','产地直发 甜脆多汁','/static/product/6009.jpg','<p>正宗阿克苏冰糖心苹果，果园现摘冷链直达</p>',NULL,3,1,NULL,NULL,NULL,NULL,NULL,48),(6010,5005,2003,'奉节脐橙8斤装','重庆本地鲜果 爆汁清甜','/static/product/6010.jpg','<p>奉节核心产区脐橙，皮薄无渣现摘现发</p>',NULL,3,1,NULL,NULL,NULL,NULL,NULL,35),(6011,5005,2003,'阳光金果奇异果12粒礼盒','高维C 香甜软嫩','/static/product/6011.jpg','<p>新西兰进口奇异果，高端送礼鲜果礼盒</p>',NULL,3,1,NULL,NULL,NULL,NULL,NULL,22),(6012,5006,2003,'沃隆每日坚果750g30袋','科学配比 孕妇可食','/static/product/6012.jpg','<p>无添加盐糖，独立小袋适合每日代餐</p>',NULL,3,1,NULL,NULL,NULL,NULL,NULL,55),(6013,5007,2004,'金龙鱼稻花香大米5kg袋装','米油丰厚 软糯香甜','/static/product/6013.jpg','<p>东北五常产区大米，家用煮饭首选</p>',NULL,3,1,NULL,NULL,NULL,NULL,NULL,20),(6014,5007,2004,'海天金标生抽1.9L桶装','粮食酿造 凉拌红烧通用','/static/product/6014.jpg','<p>180天酿造酱油，鲜香味足家用调味</p>',NULL,3,1,NULL,NULL,NULL,NULL,NULL,12),(6015,5008,2004,'涪陵清爽榨菜80g*20袋','重庆特产 配粥下饭小菜','/static/product/6015.jpg','<p>地道涪陵榨菜，低盐清爽独立小包</p>',NULL,3,1,NULL,NULL,NULL,NULL,NULL,22),(6016,5003,2004,'农家红薯宽粉1000g','久煮不烂 火锅炖菜专用','/static/product/6016.jpg','<p>纯红薯手工制作宽粉条，无胶无添加</p>',NULL,3,1,NULL,NULL,NULL,NULL,NULL,8),(6017,5010,2005,'有友泡椒凤爪210g袋装','重庆经典 酸辣入味','/static/product/6017.jpg','<p>地道山椒泡凤爪，追剧解馋网红卤味</p>',NULL,2,1,NULL,NULL,NULL,NULL,NULL,65),(6018,5009,2005,'绝味香辣鸭脖200g锁鲜装','鲜卤现发 麻辣够味','/static/product/6018.jpg','<p>气调锁鲜鸭脖，开袋即食熟食</p>',NULL,2,1,NULL,NULL,NULL,NULL,NULL,42),(6019,5009,2005,'绝味原切牛肉脯150g','肉质紧实 肉香浓郁','/static/product/6019.jpg','<p>谷饲牛肉制作肉干，无淀粉添加</p>',NULL,2,1,NULL,NULL,NULL,NULL,NULL,35),(6020,5010,2005,'有友现卤五香鹌鹑蛋300g','卤香浓郁 独立小包','/static/product/6020.jpg','<p>手工老卤慢炖鹌鹑蛋，日常解馋小食</p>',NULL,2,1,NULL,NULL,NULL,NULL,NULL,78),(6021,5011,2006,'元气森林白桃气泡水480ml*15瓶','0糖0脂0卡 清爽解腻','/static/product/6021.jpg','<p>白桃果味苏打汽水，冰镇夏日饮品</p>',NULL,3,1,NULL,NULL,NULL,NULL,NULL,38),(6022,5012,2006,'农夫山泉100%鲜榨橙汁900ml','鲜果原榨 无浓缩还原','/static/product/6022.jpg','<p>新鲜橙子压榨果汁，家庭日常饮品</p>',NULL,3,1,NULL,NULL,NULL,NULL,NULL,22),(6023,5011,2006,'元气森林酸奶200g*12盒','浓稠顺滑 早餐代餐','/static/product/6023.jpg','<p>生牛乳发酵常温酸奶，儿童老人均可饮用</p>',NULL,3,1,NULL,NULL,NULL,NULL,NULL,18),(6024,5011,2006,'农夫山泉鲜榨芒果复合果汁1L瓶装','果香浓郁 冰镇更好喝','/static/product/6024.jpg','<p>多种热带水果复配果汁，聚会分享饮品</p>',NULL,3,1,NULL,NULL,NULL,NULL,NULL,45);
/*!40000 ALTER TABLE `product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_category_relation`
--

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

--
-- Dumping data for table `product_category_relation`
--

LOCK TABLES `product_category_relation` WRITE;
/*!40000 ALTER TABLE `product_category_relation` DISABLE KEYS */;
INSERT INTO `product_category_relation` VALUES (7001,6001,201),(7002,6002,201),(7003,6003,201),(7004,6004,201),(7005,6005,201),(7006,6006,201),(7007,6007,201),(7008,6008,201),(7009,6009,101),(7010,6010,101),(7011,6011,101),(7012,6012,201),(7013,6013,202),(7014,6014,202),(7015,6015,202),(7016,6016,202),(7017,6017,107),(7018,6018,107),(7019,6019,103),(7020,6020,107),(7021,6021,203),(7022,6022,203),(7023,6023,203),(7024,6024,203);
/*!40000 ALTER TABLE `product_category_relation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_comment`
--

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

--
-- Dumping data for table `product_comment`
--

LOCK TABLES `product_comment` WRITE;
/*!40000 ALTER TABLE `product_comment` DISABLE KEYS */;
INSERT INTO `product_comment` VALUES (1,93,6009,1007,5,'味道不错，包装完好','',0,'2026-05-09 10:00:00'),(2,94,6002,1008,4,'物流很快，品质很好','',0,'2026-05-11 09:00:00'),(3,95,6004,1008,5,'旺旺雪饼还是小时候的味道，很好吃','',0,'2026-05-11 09:30:00'),(4,97,6006,1009,4,'蛋黄酥口感不错，会回购的','',0,'2026-05-13 08:00:00'),(5,98,6008,1009,5,'雪花酥奶香味很浓，好吃','',1,'2026-05-13 09:00:00'),(6,99,6013,1010,5,'大米质量很好，煮饭很香','',0,'2026-05-15 10:00:00'),(7,100,6015,1010,4,'价格实惠，会回购','',0,'2026-05-15 11:00:00'),(8,103,6017,1011,5,'泡椒凤爪非常好吃，酸辣够味','',0,'2026-05-20 09:00:00'),(9,104,6021,1012,3,'一般般，没有想象中好','',1,'2026-05-21 08:00:00'),(10,106,6010,1013,4,'脐橙很新鲜，水分足','',0,'2026-05-24 10:00:00'),(11,109,6018,1007,5,'鸭脖很入味，麻辣鲜香','',0,'2026-05-27 08:30:00'),(12,110,6001,1014,5,'每日坚果品质不错，独立包装很方便','',0,'2026-05-29 10:00:00'),(13,115,6013,1015,5,'五常大米就是好，煮出来的饭粒粒分明','',0,'2026-06-02 09:00:00'),(14,116,6015,1015,4,'榨菜味道正宗，下饭神器','',0,'2026-06-02 10:00:00'),(15,118,6005,1007,4,'辣条味道不错，就是有点少','',0,'2026-06-06 08:00:00'),(16,119,6006,1007,5,'蛋黄酥第二次购买了，品质一如既往地好','',0,'2026-06-06 09:00:00'),(17,121,6003,1010,3,'芒果干偏甜，不太适合我的口味','',1,'2026-06-08 15:00:00'),(18,122,6004,1010,5,'雪饼一如既往的好吃，孩子们很喜欢','',0,'2026-06-08 16:00:00'),(19,130,6010,1009,4,'物流很快，橙子很新鲜','',0,'2026-06-17 08:00:00'),(20,132,6017,1018,5,'有友的泡椒凤爪真的太经典了','',0,'2026-06-19 10:00:00');
/*!40000 ALTER TABLE `product_comment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `recommendation_log`
--

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

--
-- Dumping data for table `recommendation_log`
--

LOCK TABLES `recommendation_log` WRITE;
/*!40000 ALTER TABLE `recommendation_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `recommendation_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `seckill_activity`
--

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

--
-- Dumping data for table `seckill_activity`
--

LOCK TABLES `seckill_activity` WRITE;
/*!40000 ALTER TABLE `seckill_activity` DISABLE KEYS */;
INSERT INTO `seckill_activity` VALUES (1,'5月生鲜秒杀节','2026-05-15 10:00:00','2026-05-17 23:59:59',2),(2,'618超级秒杀','2026-06-16 10:00:00','2026-06-19 23:59:59',2),(3,'7月清凉秒杀','2026-07-04 10:00:00','2026-07-06 23:59:59',1);
/*!40000 ALTER TABLE `seckill_activity` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `seckill_product`
--

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

--
-- Dumping data for table `seckill_product`
--

LOCK TABLES `seckill_product` WRITE;
/*!40000 ALTER TABLE `seckill_product` DISABLE KEYS */;
INSERT INTO `seckill_product` VALUES (1,1,6009,'AKS-APPLE-10J-85',29.90,50,48,3,1),(2,1,6010,'FJ-ORANGE-8J-75',39.90,40,35,3,1),(3,1,6012,'WL-NUT-30B-750',69.00,30,25,3,1),(4,1,6016,'HS-FOOD-1B-1000',16.90,40,20,3,1),(5,2,6001,'AKS-NUT-30B-750',59.00,60,55,3,1),(6,2,6008,'BWW-SNOW-1B-300',19.90,30,28,3,1),(7,2,6017,'YY-CHICK-1B-210',13.90,80,75,3,1),(8,2,6021,'YQSL-DRINK-15B-7200',49.00,40,32,3,1),(9,2,6014,'HT-SAUCE-1T-1900',17.90,50,22,3,1),(10,3,6018,'JW-DUCK-1H-200',18.90,50,10,3,1),(11,3,6022,'NFSQ-JUICE-1B-900',14.90,60,8,3,1),(12,3,6024,'XC-MANGOJUICE-1B-1000',16.90,50,5,3,1),(13,3,6003,'BWW-MANGO-1B-500',28.90,40,3,3,1);
/*!40000 ALTER TABLE `seckill_product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `share_log`
--

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

--
-- Dumping data for table `share_log`
--

LOCK TABLES `share_log` WRITE;
/*!40000 ALTER TABLE `share_log` DISABLE KEYS */;
INSERT INTO `share_log` VALUES (1,1004,1,201,'wechat','2026-05-10 08:30:00'),(2,1007,1,301,'timeline','2026-05-12 10:15:00'),(3,1008,2,1,'wechat','2026-05-15 14:20:00'),(4,1009,1,401,'qq','2026-05-18 09:45:00'),(5,1010,2,2,'wechat','2026-05-22 16:30:00'),(6,1011,1,101,'timeline','2026-06-01 11:00:00'),(7,1012,2,1,'qq','2026-06-05 07:50:00'),(8,1013,1,501,'wechat','2026-06-10 13:25:00'),(9,1014,1,601,'timeline','2026-06-15 18:40:00'),(10,1004,1,102,'wechat','2026-06-20 10:10:00'),(11,1015,2,3,'qq','2026-06-22 15:55:00'),(12,1016,1,701,'wechat','2026-06-25 09:20:00'),(13,1017,1,801,'timeline','2026-06-28 12:35:00'),(14,1018,2,2,'wechat','2026-07-01 08:15:00'),(15,1019,1,901,'qq','2026-07-03 10:50:00');
/*!40000 ALTER TABLE `share_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sku`
--

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

--
-- Dumping data for table `sku`
--

LOCK TABLES `sku` WRITE;
/*!40000 ALTER TABLE `sku` DISABLE KEYS */;
INSERT INTO `sku` VALUES (8001,6001,'{\"规格\":\"30包装\",\"净重\":\"600g-750g\"}',77.00,90,'AKS-NUT-30B-750'),(8002,6002,'{\"规格\":\"1袋装\",\"净重\":\"200g\",\"口味\":\"卤香\"}',26.00,180,'LPPZ-CHICK-1B-200'),(8003,6003,'{\"规格\":\"1袋装\",\"净重\":\"500g\"}',35.90,150,'BWW-MANGO-1B-500'),(8004,6004,'{\"规格\":\"1袋装\",\"净重\":\"520g\"}',22.90,222,'WW-RICE-1B-520'),(8005,6005,'{\"规格\":\"10包装\",\"单包\":\"68g\"}',19.90,300,'WL-LATIAO-10B-680'),(8006,6006,'{\"规格\":\"6枚盒装\",\"净重\":\"360g\"}',35.00,130,'LPPZ-YOLK-6P-360'),(8007,6007,'{\"规格\":\"1盒装\",\"净重\":\"400g\"}',24.90,110,'DIY-CAKE-1B-400'),(8008,6008,'{\"规格\":\"1袋装\",\"净重\":\"300g\"}',27.90,160,'BWW-SNOW-1B-300'),(8009,6009,'{\"规格\":\"5斤装\",\"果径\":\"80-85mm\"}',36.90,200,'AKS-APPLE-10J-85'),(8010,6010,'{\"规格\":\"8斤装\",\"果径\":\"75-80mm\"}',49.90,140,'FJ-ORANGE-8J-75'),(8011,6011,'{\"规格\":\"12粒礼盒\",\"等级\":\"特级\"}',118.00,50,'ZESP-KIWI-12P-S'),(8012,6012,'{\"规格\":\"30包装\",\"净重\":\"750g\"}',85.00,130,'WL-NUT-30B-750'),(8013,6013,'{\"规格\":\"1袋装\",\"净重\":\"5000g\"}',68.00,80,'JLY-RICE-1P-5000'),(8014,6014,'{\"规格\":\"1桶装\",\"容量\":\"1900ml\"}',22.90,160,'HT-SAUCE-1T-1900'),(8015,6015,'{\"规格\":\"20包装\",\"单包\":\"80g\"}',16.90,300,'FL-PICKLE-20B-1600'),(8016,6016,'{\"规格\":\"1袋装\",\"净重\":\"1000g\"}',22.00,120,'HS-FOOD-1B-1000'),(8017,6017,'{\"规格\":\"1袋装\",\"净重\":\"210g\",\"口味\":\"山椒\"}',18.90,220,'YY-CHICK-1B-210'),(8018,6018,'{\"规格\":\"1盒\",\"净重\":\"200g\",\"口味\":\"香辣\"}',24.90,140,'JW-DUCK-1H-200'),(8019,6019,'{\"规格\":\"1袋装\",\"净重\":\"150g\"}',29.90,110,'HD-BEEF-1B-150'),(8020,6020,'{\"规格\":\"1盒装\",\"净重\":\"300g\"}',16.90,170,'LX-EGG-1H-300'),(8021,6021,'{\"规格\":\"15瓶装\",\"单瓶\":\"480ml\",\"口味\":\"白桃\"}',65.00,90,'YQSL-DRINK-15B-7200'),(8022,6022,'{\"规格\":\"1瓶装\",\"容量\":\"900ml\"}',19.90,130,'NFSQ-JUICE-1B-900'),(8023,6023,'{\"规格\":\"12盒装\",\"单盒\":\"200g\"}',42.90,100,'MN-YOGURT-12B-2400'),(8024,6024,'{\"规格\":\"1瓶装\",\"容量\":\"1000ml\"}',22.90,153,'XC-MANGOJUICE-1B-1000');
/*!40000 ALTER TABLE `sku` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `system_admin`
--

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

--
-- Dumping data for table `system_admin`
--

LOCK TABLES `system_admin` WRITE;
/*!40000 ALTER TABLE `system_admin` DISABLE KEYS */;
INSERT INTO `system_admin` VALUES (1,'superadmin','56ed087f4411c193dbbb1421745bae12','超级管理员','13800000000','admin@socialretail.com','SUPER_ADMIN',1,'2026-07-03 08:00:00','2026-01-01 00:00:00'),(2,'sysadmin01','56ed087f4411c193dbbb1421745bae12','系统管理员A','13800000001','sysadmin01@socialretail.com','ADMIN',1,'2026-07-02 09:00:00','2026-03-01 00:00:00');
/*!40000 ALTER TABLE `system_admin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `system_config`
--

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

--
-- Dumping data for table `system_config`
--

LOCK TABLES `system_config` WRITE;
/*!40000 ALTER TABLE `system_config` DISABLE KEYS */;
INSERT INTO `system_config` VALUES (1,'site_name','站点名称','SOCIAL零售','STRING','系统站点名称',1,1,'2026-01-01 00:00:00','2026-01-01 00:00:00'),(2,'site_logo','站点Logo','/static/system/logo.png','IMAGE','站点Logo图片URL',1,1,'2026-01-01 00:00:00','2026-01-01 00:00:00'),(3,'delivery_fee','配送费','5.00','DECIMAL','默认配送费金额（元）',1,1,'2026-01-01 00:00:00','2026-01-01 00:00:00'),(4,'free_delivery_threshold','免运费门槛','99.00','DECIMAL','满多少金额免运费',1,1,'2026-01-01 00:00:00','2026-01-01 00:00:00'),(5,'points_exchange_rate','积分兑换比例','100','INTEGER','100积分=1元',1,1,'2026-01-01 00:00:00','2026-01-01 00:00:00'),(6,'max_refund_days','最大退款天数','7','INTEGER','订单完成后多久可申请退款',1,1,'2026-01-01 00:00:00','2026-01-01 00:00:00'),(7,'auto_confirm_days','自动确认收货天数','15','INTEGER','发货后多少天自动确认收货',1,1,'2026-01-01 00:00:00','2026-01-01 00:00:00'),(8,'seckill_refresh_interval','秒杀库存刷新间隔','5','INTEGER','秒杀活动前台库存刷新间隔（秒）',0,1,'2026-05-01 00:00:00','2026-05-10 00:00:00');
/*!40000 ALTER TABLE `system_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

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

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1001,'17782224500','陈一商家','e18ca020a37ff8c10fc1166f1de931ef','/static/avatar/1001.jpg',1,1),(1002,'17782224501','王二商家','e18ca020a37ff8c10fc1166f1de931ef','/static/avatar/1002.jpg',0,1),(1003,'17782224502','李三商家','e18ca020a37ff8c10fc1166f1de931ef','/static/avatar/1003.jpg',1,1),(1004,'17782224503','赵四商家','e18ca020a37ff8c10fc1166f1de931ef','/static/avatar/1004.jpg',1,1),(1005,'17782224504','钱五商家','e18ca020a37ff8c10fc1166f1de931ef','/static/avatar/1005.jpg',1,1),(1006,'17782224505','张六商家','e18ca020a37ff8c10fc1166f1de931ef','/static/avatar/1006.jpg',1,1),(1007,'17782224506','陈二','e18ca020a37ff8c10fc1166f1de931ef','/static/avatar/1007.jpg',1,1),(1008,'17782224507','王一','e18ca020a37ff8c10fc1166f1de931ef','/static/avatar/1008.jpg',1,1),(1009,'17782224508','李二','e18ca020a37ff8c10fc1166f1de931ef','/static/avatar/1009.jpg',1,1),(1010,'17782224509','赵一','e18ca020a37ff8c10fc1166f1de931ef','/static/avatar/1010.jpg',1,1),(1011,'17782224510','孙小红','e18ca020a37ff8c10fc1166f1de931ef','/static/avatar/1001.jpg',0,1),(1012,'17782224511','周小明','e18ca020a37ff8c10fc1166f1de931ef','/static/avatar/1001.jpg',1,1),(1013,'17782224512','吴小丽','e18ca020a37ff8c10fc1166f1de931ef','/static/avatar/1001.jpg',0,1),(1014,'17782224513','郑小刚','e18ca020a37ff8c10fc1166f1de931ef','/static/avatar/1001.jpg',1,1),(1015,'17782224514','冯小美','e18ca020a37ff8c10fc1166f1de931ef','/static/avatar/1001.jpg',0,1),(1016,'17782224515','褚小强','e18ca020a37ff8c10fc1166f1de931ef','/static/avatar/1001.jpg',1,1),(1017,'17782224516','蒋小芳','e18ca020a37ff8c10fc1166f1de931ef','/static/avatar/1001.jpg',0,1),(1018,'17782224517','韩小龙','e18ca020a37ff8c10fc1166f1de931ef','/static/avatar/1001.jpg',1,1),(1019,'17782224518','杨小燕','e18ca020a37ff8c10fc1166f1de931ef','/static/avatar/1001.jpg',0,1),(1020,'17782224519','朱小杰','e18ca020a37ff8c10fc1166f1de931ef','/static/avatar/1001.jpg',1,1),(1021,'17782224520','秦小慧','e18ca020a37ff8c10fc1166f1de931ef','/static/avatar/1001.jpg',0,1),(1022,'17782224521','许小东','e18ca020a37ff8c10fc1166f1de931ef','/static/avatar/1001.jpg',1,1),(1023,'17782224522','何小琴','e18ca020a37ff8c10fc1166f1de931ef','/static/avatar/1001.jpg',0,1),(1024,'17782224523','吕小伟','e18ca020a37ff8c10fc1166f1de931ef','/static/avatar/1001.jpg',1,1),(1025,'17782224524','施小玲','e18ca020a37ff8c10fc1166f1de931ef','/static/avatar/1001.jpg',0,1);
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_behavior_log`
--

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

--
-- Dumping data for table `user_behavior_log`
--

LOCK TABLES `user_behavior_log` WRITE;
/*!40000 ALTER TABLE `user_behavior_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_behavior_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_binding`
--

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

--
-- Dumping data for table `user_binding`
--

LOCK TABLES `user_binding` WRITE;
/*!40000 ALTER TABLE `user_binding` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_binding` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_message`
--

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

--
-- Dumping data for table `user_message`
--

LOCK TABLES `user_message` WRITE;
/*!40000 ALTER TABLE `user_message` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_message` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_tag`
--

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

--
-- Dumping data for table `user_tag`
--

LOCK TABLES `user_tag` WRITE;
/*!40000 ALTER TABLE `user_tag` DISABLE KEYS */;
INSERT INTO `user_tag` VALUES (1,1004,'高频购买',0.92,'2026-06-15 10:00:00'),(2,1004,'水果偏好',0.85,'2026-06-15 10:00:00'),(3,1007,'活跃用户',0.88,'2026-06-20 14:00:00'),(4,1007,'零食爱好者',0.78,'2026-06-20 14:00:00'),(5,1008,'高频购买',0.76,'2026-06-18 09:30:00'),(6,1008,'品质追求',0.82,'2026-06-18 09:30:00'),(7,1009,'活跃用户',0.90,'2026-06-22 11:00:00'),(8,1009,'价格敏感',0.73,'2026-06-22 11:00:00'),(9,1010,'高频购买',0.81,'2026-06-25 16:00:00'),(10,1010,'水果偏好',0.79,'2026-06-25 16:00:00'),(11,1011,'新用户',0.95,'2026-06-10 08:00:00'),(12,1011,'价格敏感',0.68,'2026-06-28 10:00:00'),(13,1012,'活跃用户',0.74,'2026-06-15 13:00:00'),(14,1013,'新用户',0.91,'2026-06-12 09:00:00'),(15,1014,'活跃用户',0.77,'2026-06-20 15:30:00'),(16,1014,'品质追求',0.71,'2026-06-20 15:30:00'),(17,1015,'新用户',0.88,'2026-06-08 10:00:00'),(18,1016,'沉睡用户',0.65,'2026-07-01 08:00:00'),(19,1017,'新用户',0.86,'2026-06-18 11:30:00'),(20,1018,'零食爱好者',0.72,'2026-06-25 14:00:00');
/*!40000 ALTER TABLE `user_tag` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_wallet`
--

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

--
-- Dumping data for table `user_wallet`
--

LOCK TABLES `user_wallet` WRITE;
/*!40000 ALTER TABLE `user_wallet` DISABLE KEYS */;
INSERT INTO `user_wallet` VALUES (1,1001,1850.00,50.00,2100.00,250.00,1,'2026-07-03 18:00:00'),(2,1002,1150.00,30.00,1380.00,230.00,1,'2026-07-03 18:00:00'),(3,1003,1020.00,0.00,1280.00,260.00,1,'2026-07-03 18:00:00'),(4,1004,820.00,20.00,960.00,140.00,1,'2026-07-03 18:00:00'),(5,1005,1480.00,40.00,1750.00,270.00,1,'2026-07-03 18:00:00'),(6,1006,380.00,0.00,520.00,140.00,1,'2026-07-03 18:00:00');
/*!40000 ALTER TABLE `user_wallet` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `withdrawal_apply`
--

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

--
-- Dumping data for table `withdrawal_apply`
--

LOCK TABLES `withdrawal_apply` WRITE;
/*!40000 ALTER TABLE `withdrawal_apply` DISABLE KEYS */;
/*!40000 ALTER TABLE `withdrawal_apply` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `withdrawal_record`
--

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

--
-- Dumping data for table `withdrawal_record`
--

LOCK TABLES `withdrawal_record` WRITE;
/*!40000 ALTER TABLE `withdrawal_record` DISABLE KEYS */;
/*!40000 ALTER TABLE `withdrawal_record` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'social_retail_db'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-07-04 10:09:33
