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
  `appeal_status` tinyint DEFAULT NULL COMMENT '申诉状态（0未申诉 1已申诉）',
  `appeal_time` datetime DEFAULT NULL COMMENT '申诉时间',
  `appeal_reason` varchar(500) DEFAULT NULL COMMENT '申诉原因',
  `intervene_result` tinyint DEFAULT NULL COMMENT '平台介入结果',
  `intervene_action` tinyint DEFAULT NULL COMMENT '平台操作',
  `intervene_remark` varchar(500) DEFAULT NULL COMMENT '介入备注',
  `intervene_time` datetime DEFAULT NULL COMMENT '介入时间',
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
INSERT INTO `after_sale` VALUES (1,51,91,2001,'202605051030010001',2,1,77.00,77.00,'收到的坚果礼盒包装破损，内部独立小包有多袋漏气，与商品详情页展示的完好包装严重不符','[\"/static/product/6001.jpg\"]','三只松鼠每日坚果30包礼盒','{\"规格\":\"30包装\",\"净重\":\"600g-750g\"}',4,0,0,'已审核通过，退款成功',NULL,'2026-05-09 14:30:00',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-05-09 10:00:00','2026-05-10 09:00:00','2026-07-04 09:21:57','退款已到账，处理满意',NULL,0,'2026-05-07 10:00:00'),(7,52,92,2002,'202605061420010002',2,1,39.80,39.80,'商品完全未拆封，仍在七天无理由退货时效范围内，因个人口味偏好原因申请退货退款','[\"/static/product/6005.jpg\"]','卫龙大面筋68g*10包','{\"规格\":\"68g*10包\",\"口味\":\"香辣味\"}',4,0,0,'已审核通过，退款成功',NULL,'2026-05-10 09:30:00',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-05-10 09:00:00','2026-05-11 10:00:00','2026-07-04 09:21:57','收到退款','',0,'2026-05-08 10:00:00');
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
) ENGINE=InnoDB AUTO_INCREMENT=5051 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='品牌表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `brand`
--

LOCK TABLES `brand` WRITE;
/*!40000 ALTER TABLE `brand` DISABLE KEYS */;
INSERT INTO `brand` VALUES (5001,'三只松鼠','/static/brand/5001.jpg','互联网坚果零食第一品牌',NULL),(5002,'良品铺子','/static/brand/5002.jpg','高端全品类零食连锁标杆品牌',NULL),(5003,'卫龙','/static/brand/5003.jpg','国民辣味调味零食第一品牌',NULL),(5004,'旺旺','/static/brand/5004.jpg','国民童年米果零食经典龙头',NULL),(5005,'奉节脐橙','/static/brand/5005.jpg','重庆地标鲜果品牌',NULL),(5006,'沃隆','/static/brand/5006.jpg','每日坚果原创开创品牌',NULL),(5007,'金龙鱼','/static/brand/5007.jpg','国民粮油龙头品牌',NULL),(5008,'涪陵榨菜','/static/brand/5008.jpg','世界三大名腌菜之一',NULL),(5009,'绝味鸭脖','/static/brand/5009.jpg','全国连锁卤味熟食龙头品牌',NULL),(5010,'有友','/static/brand/5010.jpg','重庆本土卤味零食品牌',NULL),(5011,'元气森林','/static/brand/5011.jpg','零糖气泡水健康饮品新锐头部品牌',NULL),(5012,'农夫山泉','/static/brand/5012.jpg','国民天然饮用水果汁龙头',NULL),(5013,'田园时光','/static/brand/5013.jpg','精选时令蔬菜，有机种植，新鲜直达餐桌','2026-06-02 10:00:00'),(5014,'草原牧场','/static/brand/5014.jpg','源头直供优质肉禽蛋品，绿色健康，口感鲜美','2026-06-02 11:00:00'),(5015,'海之鲜','/static/brand/5015.jpg','精选全球优质海鲜，鲜活到家，营养美味','2026-06-03 09:00:00'),(5016,'茅台','/static/brand/5016.jpg','国酒茅台，酱香经典，中国白酒第一品牌','2026-06-03 10:00:00'),(5017,'青岛','/static/brand/5017.jpg','百年啤酒品牌，经典口味，畅饮无限','2026-06-03 10:30:00'),(5018,'雀巢','/static/brand/5018.jpg','全球食品饮料巨头，品质保证，营养健康','2026-06-03 11:00:00'),(5019,'立顿','/static/brand/5019.jpg','全球最大茶饮品牌，经典口味，品质如一','2026-06-04 09:00:00'),(5020,'同仁堂','/static/brand/5020.jpg','百年中药老字号，品质滋补，养生首选','2026-06-04 09:30:00'),(5021,'汤臣倍健','/static/brand/5021.jpg','膳食补充剂领导品牌，科学营养，健康相伴','2026-06-04 10:00:00'),(5022,'费列罗','/static/brand/5022.jpg','意大利知名巧克力品牌，榛果威化，口感丰富','2026-06-04 10:30:00'),(5023,'明治','/static/brand/5023.jpg','日本知名食品品牌，巧克力豆，口感细腻','2026-06-04 11:00:00'),(5024,'水星家纺','/static/brand/5024.jpg','家纺行业领导品牌，舒适睡眠，温馨家居','2026-06-05 09:00:00'),(5025,'欧普照明','/static/brand/5025.jpg','照明行业领导品牌，节能护眼，品质之光','2026-06-05 09:30:00'),(5026,'乐扣乐扣','/static/brand/5026.jpg','保鲜盒领导品牌，密封保鲜，健康生活','2026-06-05 10:00:00'),(5027,'蓝月亮','/static/brand/5027.jpg','洗衣液领导品牌，温和洁净，呵护衣物','2026-06-05 10:30:00'),(5028,'维达','/static/brand/5028.jpg','纸巾领导品牌，柔软亲肤，品质生活','2026-06-05 11:00:00'),(5029,'箭牌','/static/brand/5029.jpg','卫浴领导品牌，品质卫浴，舒适生活','2026-06-06 09:00:00'),(5030,'天堂','/static/brand/5030.jpg','雨伞领导品牌，品质保障，风雨无阻','2026-06-06 09:30:00'),(5031,'茶花','/static/brand/5031.jpg','家居用品领导品牌，品质实用，生活好帮手','2026-06-06 10:00:00'),(5032,'宜家','/static/brand/5032.jpg','全球知名家居品牌，简约设计，温馨生活','2026-06-06 10:30:00'),(5033,'皇家','/static/brand/5033.jpg','宠物食品领导品牌，营养均衡，关爱宠物','2026-06-06 11:00:00'),(5034,'苏泊尔','/static/brand/5034.jpg','厨房电器领导品牌，品质厨房，美味生活','2026-06-07 09:00:00'),(5035,'张小泉','/static/brand/5035.jpg','百年刀剪老字号，锋利耐用，品质传承','2026-06-07 09:30:00'),(5036,'富光','/static/brand/5036.jpg','水杯领导品牌，品质饮水，健康生活','2026-06-07 10:00:00'),(5037,'康宁','/static/brand/5037.jpg','玻璃餐具领导品牌，健康环保，品质生活','2026-06-07 10:30:00'),(5038,'九阳','/static/brand/5038.jpg','厨房小家电领导品牌，智能便捷，美味厨房','2026-06-07 11:00:00'),(5039,'欧莱雅','/static/brand/5039.jpg','全球化妆品领导品牌，科技护肤，美丽绽放','2026-06-08 09:00:00'),(5040,'玉兰油','/static/brand/5040.jpg','全球知名护肤品牌，科学护肤，焕发光彩','2026-06-08 09:30:00'),(5041,'多芬','/static/brand/5041.jpg','全球知名洗护品牌，温和呵护，美丽自信','2026-06-08 10:00:00'),(5042,'潘婷','/static/brand/5042.jpg','全球知名护发品牌，修护秀发，健康亮泽','2026-06-08 10:30:00'),(5043,'高露洁','/static/brand/5043.jpg','全球知名口腔护理品牌，健康口腔，笑容自信','2026-06-08 11:00:00'),(5044,'护舒宝','/static/brand/5044.jpg','全球知名女性护理品牌，贴心呵护，安心每一天','2026-06-09 09:00:00'),(5045,'迪奥','/static/brand/5045.jpg','法国奢侈品牌，经典香水，优雅气质','2026-06-09 09:30:00'),(5046,'美宝莲','/static/brand/5046.jpg','全球知名彩妆品牌，时尚彩妆，美丽绽放','2026-06-09 10:00:00'),(5047,'美赞臣','/static/brand/5047.jpg','全球知名奶粉品牌，科学配方，呵护成长','2026-06-10 09:00:00'),(5048,'亨氏','/static/brand/5048.jpg','全球知名辅食品牌，营养辅食，健康成长','2026-06-10 09:30:00'),(5049,'帮宝适','/static/brand/5049.jpg','全球知名纸尿裤品牌，干爽舒适，呵护宝宝','2026-06-10 10:00:00'),(5050,'贝亲','/static/brand/5050.jpg','日本知名母婴品牌，品质喂养，呵护宝宝','2026-06-10 10:30:00');
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
  `distributor_product_id` bigint DEFAULT NULL,
  `attribution_expires_at` datetime DEFAULT NULL,
  `promotion_code` varchar(50) DEFAULT NULL COMMENT '分销推广码',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `fk_cart_user` (`user_id`) USING BTREE,
  KEY `fk_cart_sku` (`sku_id`) USING BTREE,
  KEY `idx_cart_distribution` (`distributor_product_id`,`attribution_expires_at`),
  CONSTRAINT `fk_cart_sku` FOREIGN KEY (`sku_id`) REFERENCES `sku` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_cart_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=60 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='购物车表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart`
--

LOCK TABLES `cart` WRITE;
/*!40000 ALTER TABLE `cart` DISABLE KEYS */;
INSERT INTO `cart` VALUES (1,1007,8003,2,NULL),(2,1008,8005,1,NULL),(3,1009,8012,1,NULL),(4,1010,8001,3,NULL),(5,1011,8017,2,NULL),(6,1012,8021,1,NULL),(7,1013,8010,1,NULL),(8,1014,8006,4,NULL),(9,1015,8013,1,NULL),(10,1016,8023,2,NULL),(11,1017,8008,3,NULL),(12,1018,8019,1,NULL),(13,1019,8002,2,NULL),(14,1020,8014,5,NULL),(15,1021,8024,2,NULL);
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
INSERT INTO `category` VALUES (1,0,'生鲜果蔬肉禽',1,1),(2,0,'食品饮料滋补',1,2),(3,0,'家居百货日用品',1,3),(4,0,'厨具餐具厨房配件',1,4),(5,0,'个护美妆清洁',1,5),(6,0,'母婴孕童用品',1,6),(101,1,'新鲜水果',2,1),(102,1,'时令蔬菜',2,2),(103,1,'猪牛羊肉',2,3),(104,1,'海鲜水产',2,4),(105,1,'禽肉蛋品',2,5),(106,1,'冷冻速食',2,6),(107,1,'熟食卤味',2,7),(108,1,'甜品饮品',2,8),(201,2,'休闲零食',2,1),(202,2,'粮油米面调味',2,2),(203,2,'酒水饮料冲调',2,3),(204,2,'进口零食酒水',2,4),(205,2,'地方特产礼盒',2,5),(206,2,'茗茶茶饮',2,6),(207,2,'保健食品滋补品',2,7),(208,2,'食品礼券礼盒',2,8),(301,3,'家纺床品毛巾',2,1),(302,3,'家用电器',2,2),(303,3,'收纳储物用品',2,3),(304,3,'清洁消杀纸品',2,4),(305,3,'浴室洗漱用品',2,5),(306,3,'雨伞雨具防护',2,6),(307,3,'洗晒熨烫工具',2,7),(308,3,'装饰摆件花艺',2,8),(309,3,'宠物全品类',2,9),(401,4,'烹饪锅具',2,1),(402,4,'刀剪菜板工具',2,2),(403,4,'水杯酒具茶具',2,3),(404,4,'碗盘餐具',2,4),(405,4,'厨房小配件',2,5),(406,4,'商用酒店厨具',2,6),(501,5,'面部护肤',2,1),(502,5,'身体洗护沐浴',2,2),(503,5,'洗发护发',2,3),(504,5,'口腔护理',2,4),(505,5,'女性卫生巾护理',2,5),(506,5,'香水彩妆饰品',2,6),(601,6,'婴幼儿奶粉',2,1),(602,6,'辅食营养零食',2,2),(603,6,'尿裤湿巾',2,3),(604,6,'喂养餐具器具',2,4),(605,6,'宝宝洗护用品',2,5),(606,6,'童装童鞋寝具',2,6),(607,6,'孕妈妈妈专区',2,7),(608,6,'童车安全座椅',2,8);
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
-- Table structure for table `commission_record`
--

DROP TABLE IF EXISTS `commission_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `commission_record` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `distributor_id` bigint NOT NULL COMMENT '分销员ID',
  `distributor_product_id` bigint NOT NULL COMMENT '推广商品ID',
  `order_id` bigint NOT NULL COMMENT '订单ID',
  `commission_amount` decimal(10,2) NOT NULL COMMENT '佣金金额',
  `status` tinyint NOT NULL DEFAULT '0' COMMENT '状态：0-待结算，1-已结算',
  `settlement_time` datetime DEFAULT NULL COMMENT '结算时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_distributor` (`distributor_id`),
  KEY `idx_order` (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='佣金记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `commission_record`
--

LOCK TABLES `commission_record` WRITE;
/*!40000 ALTER TABLE `commission_record` DISABLE KEYS */;
/*!40000 ALTER TABLE `commission_record` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=200633 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='优惠券主表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `coupon`
--

LOCK TABLES `coupon` WRITE;
/*!40000 ALTER TABLE `coupon` DISABLE KEYS */;
INSERT INTO `coupon` VALUES (1,'新人大礼包 满50减10',1,50.00,10.00,500,180,1,0,1,NULL,0,'2026-05-01 00:00:00','2026-07-31 23:59:59',1,'2026-05-01 00:00:00',NULL),(2,'5月狂欢 满100减20',1,100.00,20.00,300,95,1,100,1,NULL,0,'2026-05-05 00:00:00','2026-05-31 23:59:59',0,'2026-05-01 00:00:00',NULL),(3,'端午特惠 满80减15',1,80.00,15.00,200,130,2,0,1,NULL,0,'2026-05-25 00:00:00','2026-06-10 23:59:59',0,'2026-05-20 00:00:00',NULL),(4,'618年中大促 满150减30',1,150.00,30.00,400,210,2,200,1,NULL,1,'2026-06-12 00:00:00','2026-06-22 23:59:59',0,'2026-06-10 00:00:00',NULL),(5,'夏日清凉季 满60减12',1,60.00,12.00,300,160,2,50,1,NULL,0,'2026-06-20 00:00:00','2026-07-20 23:59:59',1,'2026-06-18 00:00:00',NULL),(6,'银卡专项 满40减8',1,40.00,8.00,200,75,3,0,1,NULL,2,'2026-07-01 00:00:00','2026-07-31 23:59:59',1,'2026-07-01 00:00:00',NULL),(901,'7月夏日狂欢 满100减10',2,100.00,10.00,500,0,NULL,0,1,NULL,0,'2026-07-01 00:00:00','2026-07-31 23:59:59',NULL,NULL,NULL),(902,'7月夏日狂欢 满200减25',2,200.00,25.00,400,0,NULL,0,1,NULL,0,'2026-07-01 00:00:00','2026-07-31 23:59:59',NULL,NULL,NULL),(903,'7月夏日狂欢 满300减45',2,300.00,45.00,300,0,NULL,0,1,NULL,0,'2026-07-01 00:00:00','2026-07-31 23:59:59',NULL,NULL,NULL),(904,'7月夏日狂欢 满500减80',2,500.00,80.00,200,0,NULL,0,1,NULL,0,'2026-07-01 00:00:00','2026-07-31 23:59:59',NULL,NULL,NULL),(905,'7月夏日狂欢 满1000减180',2,1000.00,180.00,100,0,NULL,0,1,NULL,0,'2026-07-01 00:00:00','2026-07-31 23:59:59',NULL,NULL,NULL),(906,'新用户首单礼 满50减15',2,50.00,15.00,200,0,NULL,0,1,NULL,0,'2026-07-01 00:00:00','2026-08-31 23:59:59',NULL,NULL,NULL),(911,'普通会员专享 满80减8',3,80.00,8.00,300,0,NULL,0,1,NULL,0,'2026-07-01 00:00:00','2026-07-31 23:59:59',NULL,NULL,NULL),(912,'普通会员专享 满150减18',3,150.00,18.00,250,0,NULL,0,1,NULL,0,'2026-07-01 00:00:00','2026-07-31 23:59:59',NULL,NULL,NULL),(913,'银牌会员专享 满100减15',3,100.00,15.00,300,0,NULL,0,1,NULL,0,'2026-07-01 00:00:00','2026-07-31 23:59:59',NULL,NULL,NULL),(914,'银牌会员专享 满200减30',3,200.00,30.00,200,0,NULL,0,1,NULL,0,'2026-07-01 00:00:00','2026-07-31 23:59:59',NULL,NULL,NULL),(915,'金牌会员专享 满150减25',3,150.00,25.00,200,0,NULL,0,1,NULL,0,'2026-07-01 00:00:00','2026-07-31 23:59:59',NULL,NULL,NULL),(916,'金牌会员专享 满300减50',3,300.00,50.00,150,0,NULL,0,1,NULL,0,'2026-07-01 00:00:00','2026-07-31 23:59:59',NULL,NULL,NULL),(200101,'润禾小店 满30减5',0,30.00,5.00,200,0,NULL,0,1,NULL,0,'2026-07-01 00:00:00','2026-08-31 23:59:59',NULL,NULL,NULL),(200102,'润禾小店 满60减12',0,60.00,12.00,150,0,NULL,0,1,NULL,0,'2026-07-01 00:00:00','2026-08-31 23:59:59',NULL,NULL,NULL),(200201,'食愈小站 满25减4',0,25.00,4.00,200,0,NULL,0,1,NULL,0,'2026-07-01 00:00:00','2026-08-31 23:59:59',NULL,NULL,NULL),(200202,'食愈小站 满50减10',0,50.00,10.00,150,0,NULL,0,1,NULL,0,'2026-07-01 00:00:00','2026-08-31 23:59:59',NULL,NULL,NULL),(200301,'鲜禧果仓 满40减6',0,40.00,6.00,200,0,NULL,0,1,NULL,0,'2026-07-01 00:00:00','2026-08-31 23:59:59',NULL,NULL,NULL),(200302,'鲜禧果仓 满80减15',0,80.00,15.00,150,0,NULL,0,1,NULL,0,'2026-07-01 00:00:00','2026-08-31 23:59:59',NULL,NULL,NULL),(200401,'家禾粮油 满50减8',0,50.00,8.00,200,0,NULL,0,1,NULL,0,'2026-07-01 00:00:00','2026-08-31 23:59:59',NULL,NULL,NULL),(200402,'家禾粮油 满100减20',0,100.00,20.00,100,0,NULL,0,1,NULL,0,'2026-07-01 00:00:00','2026-08-31 23:59:59',NULL,NULL,NULL),(200501,'巷味卤货 满20减3',0,20.00,3.00,300,0,NULL,0,1,NULL,0,'2026-07-01 00:00:00','2026-08-31 23:59:59',NULL,NULL,NULL),(200502,'巷味卤货 满40减8',0,40.00,8.00,200,0,NULL,0,1,NULL,0,'2026-07-01 00:00:00','2026-08-31 23:59:59',NULL,NULL,NULL),(200601,'果汽鲜饮 满30减5',0,30.00,5.00,200,0,NULL,0,1,NULL,0,'2026-07-01 00:00:00','2026-08-31 23:59:59',NULL,NULL,NULL),(200602,'果汽鲜饮 满60减10',0,60.00,10.00,150,0,NULL,0,1,NULL,0,'2026-07-01 00:00:00','2026-08-31 23:59:59',NULL,NULL,NULL),(200603,'喵吉母婴MiuKids 满30减5',0,30.00,5.00,200,0,NULL,0,1,NULL,0,'2026-07-01 00:00:00','2026-08-31 23:59:59',NULL,NULL,NULL),(200604,'焙爱烘焙坊 满30减5',0,30.00,5.00,200,0,NULL,0,1,NULL,0,'2026-07-01 00:00:00','2026-08-31 23:59:59',NULL,NULL,NULL),(200605,'第七天文具 满30减5',0,30.00,5.00,200,0,NULL,0,1,NULL,0,'2026-07-01 00:00:00','2026-08-31 23:59:59',NULL,NULL,NULL),(200606,'三两茶事 满30减5',0,30.00,5.00,200,0,NULL,0,1,NULL,0,'2026-07-01 00:00:00','2026-08-31 23:59:59',NULL,NULL,NULL),(200607,'元气补给站 满30减5',0,30.00,5.00,200,0,NULL,0,1,NULL,0,'2026-07-01 00:00:00','2026-08-31 23:59:59',NULL,NULL,NULL),(200608,'简舍家生活 满30减5',0,30.00,5.00,200,0,NULL,0,1,NULL,0,'2026-07-01 00:00:00','2026-08-31 23:59:59',NULL,NULL,NULL),(200609,'BikeHero 满30减5',0,30.00,5.00,200,0,NULL,0,1,NULL,0,'2026-07-01 00:00:00','2026-08-31 23:59:59',NULL,NULL,NULL),(200610,'PuddingKids 满30减5',0,30.00,5.00,200,0,NULL,0,1,NULL,0,'2026-07-01 00:00:00','2026-08-31 23:59:59',NULL,NULL,NULL),(200611,'光影书坊 满30减5',0,30.00,5.00,200,0,NULL,0,1,NULL,0,'2026-07-01 00:00:00','2026-08-31 23:59:59',NULL,NULL,NULL),(200612,'创物手作 满30减5',0,30.00,5.00,200,0,NULL,0,1,NULL,0,'2026-07-01 00:00:00','2026-08-31 23:59:59',NULL,NULL,NULL),(200618,'喵吉母婴MiuKids 满60减12',0,60.00,12.00,100,0,NULL,0,1,NULL,0,'2026-07-01 00:00:00','2026-08-31 23:59:59',NULL,NULL,NULL),(200619,'焙爱烘焙坊 满60减12',0,60.00,12.00,100,0,NULL,0,1,NULL,0,'2026-07-01 00:00:00','2026-08-31 23:59:59',NULL,NULL,NULL),(200620,'第七天文具 满60减12',0,60.00,12.00,100,0,NULL,0,1,NULL,0,'2026-07-01 00:00:00','2026-08-31 23:59:59',NULL,NULL,NULL),(200621,'三两茶事 满60减12',0,60.00,12.00,100,0,NULL,0,1,NULL,0,'2026-07-01 00:00:00','2026-08-31 23:59:59',NULL,NULL,NULL),(200622,'元气补给站 满60减12',0,60.00,12.00,100,0,NULL,0,1,NULL,0,'2026-07-01 00:00:00','2026-08-31 23:59:59',NULL,NULL,NULL),(200623,'简舍家生活 满60减12',0,60.00,12.00,100,0,NULL,0,1,NULL,0,'2026-07-01 00:00:00','2026-08-31 23:59:59',NULL,NULL,NULL),(200624,'BikeHero 满60减12',0,60.00,12.00,100,0,NULL,0,1,NULL,0,'2026-07-01 00:00:00','2026-08-31 23:59:59',NULL,NULL,NULL),(200625,'PuddingKids 满60减12',0,60.00,12.00,100,0,NULL,0,1,NULL,0,'2026-07-01 00:00:00','2026-08-31 23:59:59',NULL,NULL,NULL),(200626,'光影书坊 满60减12',0,60.00,12.00,100,0,NULL,0,1,NULL,0,'2026-07-01 00:00:00','2026-08-31 23:59:59',NULL,NULL,NULL),(200627,'创物手作 满60减12',0,60.00,12.00,100,0,NULL,0,1,NULL,0,'2026-07-01 00:00:00','2026-08-31 23:59:59',NULL,NULL,NULL);
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
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `apply_id` bigint NOT NULL COMMENT '对应申请记录ID',
  `total_commission` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '累计佣金',
  `available_commission` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '可提现佣金',
  `frozen_commission` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '冻结佣金',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态：0-禁用，1-正常',
  `apply_time` datetime NOT NULL COMMENT '申请通过时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_id` (`user_id`),
  UNIQUE KEY `uk_apply_id` (`apply_id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='分销员表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `distributor`
--

LOCK TABLES `distributor` WRITE;
/*!40000 ALTER TABLE `distributor` DISABLE KEYS */;
/*!40000 ALTER TABLE `distributor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `distributor_apply`
--

DROP TABLE IF EXISTS `distributor_apply`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `distributor_apply` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` bigint NOT NULL COMMENT '申请用户ID',
  `real_name` varchar(50) NOT NULL COMMENT '真实姓名',
  `id_card_no` varchar(30) NOT NULL COMMENT '身份证号',
  `id_card_front` varchar(255) NOT NULL COMMENT '身份证正面图片',
  `id_card_back` varchar(255) NOT NULL COMMENT '身份证反面图片',
  `bank_name` varchar(100) NOT NULL COMMENT '开户银行',
  `bank_card_no` varchar(50) NOT NULL COMMENT '银行卡号',
  `bank_account_name` varchar(50) NOT NULL COMMENT '开户人姓名',
  `audit_status` tinyint NOT NULL DEFAULT '0' COMMENT '审核状态：0-待审核，1-审核通过，2-审核拒绝',
  `audit_remark` varchar(255) DEFAULT NULL COMMENT '审核备注',
  `audit_time` datetime DEFAULT NULL COMMENT '审核时间',
  `apply_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '申请时间',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_audit_status` (`audit_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='分销员申请表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `distributor_apply`
--

LOCK TABLES `distributor_apply` WRITE;
/*!40000 ALTER TABLE `distributor_apply` DISABLE KEYS */;
/*!40000 ALTER TABLE `distributor_apply` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `distributor_product`
--

DROP TABLE IF EXISTS `distributor_product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `distributor_product` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `distributor_id` bigint NOT NULL COMMENT '分销员ID',
  `distribution_product_id` bigint NOT NULL COMMENT '商家开放分销商品ID',
  `promotion_code` varchar(50) NOT NULL COMMENT '推广码',
  `promotion_url` varchar(500) NOT NULL COMMENT '推广链接',
  `qr_code` varchar(500) DEFAULT NULL COMMENT '二维码',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_promotion_code` (`promotion_code`),
  UNIQUE KEY `uk_distributor_product` (`distributor_id`,`distribution_product_id`),
  KEY `idx_distributor` (`distributor_id`),
  KEY `idx_distribution_product` (`distribution_product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='分销员推广商品';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `distributor_product`
--

LOCK TABLES `distributor_product` WRITE;
/*!40000 ALTER TABLE `distributor_product` DISABLE KEYS */;
/*!40000 ALTER TABLE `distributor_product` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=2036 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='商家表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `merchant`
--

LOCK TABLES `merchant` WRITE;
/*!40000 ALTER TABLE `merchant` DISABLE KEYS */;
INSERT INTO `merchant` VALUES (2001,1001,'润禾生活食铺','/static/merchant/1001.jpg','龙国建','17782224500','重庆市渝中区解放西路 126 号附 8 号',1,'06:00-21:30','润禾生活食铺坐落于渝中区解放西路，主营休闲零食、坚果炒货与精品糕点。店内精选三只松鼠、旺旺、良品铺子等知名品牌，涵盖坚果礼盒、虎皮风爪、雪饼、芒果干等热门单品，满足日常零嘴与亲朋送礼双重需求。我们坚持\"新鲜直达、品质为本\"，每周三批到货确保商品日期新鲜，是街坊邻里的放心零食铺。','2026-05-04 09:15:00'),(2002,1002,'食愈小站','/static/merchant/1002.jpg','周小雪','17782224501','重庆市大渡口区新山村春晖路 66 号',1,'08:00-20:00','食愈小站位于大渡口区春晖路新山村商圈，是一家以\"食愈心灵\"为理念的精致零食小铺。主打卫龙辣条系列、良品铺子手工糕点与蛋黄酥、雪花酥等网红甜品，深受周边写字楼白领和学生群体喜爱。店内每月推出限定口味，搭配手写推荐卡，让每一次购物都成为温暖的小确幸。','2026-05-18 14:30:00'),(2003,1003,'鲜禧果仓','/static/merchant/1003.jpg','林志远','17782224502','重庆市巴南区龙洲湾渝南大道132号',1,'06:30-21:00','鲜禧果仓扎根巴南区龙洲湾，专注高品质应季鲜果与精品坚果。店内常年供应奉节脐橙、阿克苏冰糖心苹果、阳光金果奇异果等地标水果，搭配沃隆每日坚果等健康零嘴。我们与产区直采合作，清晨采摘、当日上架，每一颗水果都经过三道筛选，用\"鲜\"字说话，让街坊吃出季节的味道。','2026-06-02 10:00:00'),(2004,1004,'家禾粮油副食','/static/merchant/1004.jpg','苏婉清','17782224503','重庆市沙坪坝区三峡广场天陈路57号',1,'07:00-20:30','家禾粮油副食位于沙坪坝区三峡广场商圈，专注厨房基础食材一站式供应。经营金龙鱼大米、海天酱油、涪陵榨菜、农家红薯粉等家庭刚需品，覆盖米面粮油、调味品、干货三大品类。我们以\"件件严选、斤斤实惠\"为宗旨，与多家品牌签订年度直供协议，省去中间环节让利顾客，是三峡广场周边居民的\"家庭粮仓\"。','2026-06-20 11:45:00'),(2005,1005,'巷味卤货','/static/merchant/1005.jpg','黄德伟','17782224504','重庆市北碚区天生路49号城南步行街底商',1,'09:00-22:00','巷味卤货扎根北碚城南步行街，传承重庆地道卤味手艺。主打有友泡椒凤爪、五香鹌鹑蛋及绝味锁鲜鸭脖、牛肉脯等人气卤味，采用二十余味中草药秘制卤汤，每日现卤现售。我们坚持\"卤香不怕巷子深\"，以当日鲜卤、真空锁鲜双模式服务周边社区与夜宵爱好者，一口卤味一口酒，就是山城最地道的烟火气。','2026-07-01 08:30:00'),(2006,1006,'果汽鲜饮','/static/merchant/1006.jpg','何雅琴','17782224505','重庆市江北区观音桥建新北路 55 号星光 68 负一楼 17 铺',1,'08:30-21:30','果汽鲜饮位于江北观音桥星光68商圈，专注于高品质饮品与酸奶零售。主营元气森林气泡水系列、农夫山泉鲜榨果汁及元气森林酸奶，覆盖气泡水、纯果汁、乳酸菌饮品三大热门赛道。我们紧邻写字楼与购物中心，以\"低糖、健康、好喝\"为选品标准，为都市白领和年轻家庭提供便捷的饮品补给方案。','2026-07-04 09:00:00'),(2007,1007,'臻品生活馆','merchant/1007.jpg','陈勇','17782224506','重庆市大渡口区新山村街道钢花路 56 号',1,'08:00-22:00','家居百货、个护美妆','2026-06-21 10:42:04'),(2008,1008,'厨乐坊','merchant/1008.jpg','王果苗','17782224507','重庆市渝北区回兴街道宝圣大道学府路 105 号',1,'08:00-22:00','厨具餐具、厨房配件','2026-06-30 10:42:10'),(2009,1009,'贝贝乐母婴馆','merchant/1009.jpg','李鑫瑞','17782224508','重庆市巴南区龙洲湾旭辉城底商 42 号',1,'08:00-22:00','母婴孕童全品类','2026-07-01 10:42:17'),(2010,1010,'滋补堂','merchant/1010.jpg','赵蕊','17782224509','重庆市九龙坡区西彭镇铝城南路 21 号便民商铺',1,'08:00-22:00','保健食品、进口零食','2026-07-03 10:42:22'),(2011,NULL,'喵吉母婴MiuKids','merchant/1011.jpg','苗思琪','18800002011','重庆市沙坪坝区大学城熙街3期B馆1F-11',1,'07:00-23:00','婴幼儿服饰、喂养用品、安全玩具，妈妈的放心选择。','2026-05-04 09:00:00'),(2012,NULL,'焙爱烘焙坊','merchant/1012.jpg','贝甜','18800002012','重庆市渝中区大坪时代天街C馆LG-22',1,'09:00-21:00','烘焙原料、模具工具、包装材料，家庭烘焙爱好者的秘密基地。','2026-05-15 10:00:00'),(2013,1013,'小清新花店','merchant/1013.jpg','吴敏','17782224512','重庆市南岸区南坪万达广场步行街',1,'10:00-22:00','鲜花绿植，节日礼品','2026-06-01 09:00:00'),(2014,NULL,'第七天文具','merchant/1014.jpg','莫文','18800002014','重庆市北碚区城南新区嘉陵风情步行街A5',1,'09:00-21:00','手账文具、笔记本、钢笔彩墨，书写爱好者的乐土。','2026-06-20 08:00:00'),(2015,1015,'便民便利店','merchant/1015.jpg','孙丽','17782224514','重庆市大渡口区九宫庙街道钢花路',1,'06:00-00:00','24小时便利店','2026-07-01 07:00:00'),(2016,NULL,'三两茶事','merchant/1016.jpg','蔡青','18800002016','重庆市南岸区南滨路长嘉汇购物公园L2-15',1,'09:00-21:00','原叶茶、花草茶、精美茶具，一杯茶的时间慢下来。','2026-05-06 09:00:00'),(2017,NULL,'元气补给站','merchant/1017.jpg','袁启','18800002017','重庆市江北区九街高屋A栋底商03',1,'10:00-18:00','健康代餐、蛋白棒、能量饮料，运动达人的能量补给站。','2026-05-18 09:00:00'),(2018,NULL,'简舍家生活','merchant/1018.jpg','简宁','18800002018','重庆市渝北区金开大道爱琴海购物公园B1-18',1,'09:00-21:00','北欧风格家居、简约收纳、生活美学，让家更有温度。','2026-05-28 09:00:00'),(2019,1019,'茗香茶庄','merchant/1019.jpg','魏延','17782224518','重庆市沙坪坝区磁器口古镇',1,'09:00-22:00','名优茶叶，茶具礼品','2026-06-08 09:00:00'),(2020,NULL,'BikeHero','merchant/1020.jpg','齐侠','18800002020','重庆市沙坪坝区大学城北路U城天街B馆B1-07',1,'10:00-20:00','骑行头盔、手套、车灯配件，安全骑行从这里开始。','2026-06-15 09:00:00'),(2021,1021,'味美轩','merchant/1021.jpg','张飞','17782224520','重庆市九龙坡区杨家坪步行街',1,'11:00-22:00','川菜粤菜，特色美食','2026-06-22 09:00:00'),(2022,NULL,'PuddingKids','merchant/1022.jpg','卜婷','18800002022','重庆市九龙坡区石桥铺仁悦天地2F-18',1,'10:00-21:00','0-12岁童装、童鞋、儿童配饰，舒适安全的成长陪伴。','2026-06-28 09:00:00'),(2023,1023,'智慧书屋','merchant/1023.jpg','诸葛亮','17782224522','重庆市渝中区新华书店旁',1,'09:00-21:00','图书文具，文创产品','2026-07-02 09:00:00'),(2024,NULL,'光影书坊','merchant/1024.jpg','舒影','18800002024','重庆市南岸区弹子石老街文创街区3号',1,'09:00-21:00','畅销图书、儿童绘本、文创书签，让阅读温暖时光。','2026-07-03 09:00:00'),(2025,NULL,'创物手作','merchant/1025.jpg','吴创','18800002025','重庆市江北区喵儿石创艺特区2号楼B1',1,'10:00-21:00','手工皮具、布艺DIY材料包、复古饰品，匠人精神的小店。','2026-07-04 09:00:00'),(2026,NULL,'店主张的小店','/static/merchant/1001.jpg','张云帆','13800001001','重庆市渝北区仙桃数据谷东路19号C栋',1,'09:00-18:00','专注于智慧零售解决方案','2026-07-01 08:00:00'),(2027,NULL,'店主李的小店','/static/merchant/1002.jpg','李绿洲','13800001002','重庆市涪陵区龙桥街道北拱社区农科站',1,'08:00-17:00','生态种植，绿色健康','2026-07-02 09:30:00'),(2028,NULL,'店主王的小店','/static/merchant/1003.jpg','王星辰','13800001003','重庆市江北区北滨一路龙湖星悦荟7栋',1,'10:00-19:00','新媒体营销与品牌推广','2026-07-02 10:00:00'),(2029,NULL,'店主赵的小店','/static/merchant/1004.jpg','赵瑞丰','13800001004','重庆市沙坪坝区西永微电园研发楼B座',1,'09:00-18:00','一站式供应链服务商','2026-07-03 08:30:00'),(2030,NULL,'店主陈的小店','/static/merchant/1005.jpg','陈蓝','13800001005','重庆市南岸区茶园新区通江大道99号',1,'09:30-18:30','电商SaaS工具开发商','2026-07-03 14:00:00'),(2031,NULL,'店主周的小店','/static/merchant/1006.jpg','周锦程','13800001006','重庆市渝北区空港物流园A区3号库',1,'08:00-20:00','同城配送与冷链物流','2026-07-04 09:00:00'),(2032,NULL,'店主吴的小店','/static/merchant/1007.jpg','吴乐','13800001007','重庆市九龙坡区万象城L2层208号',1,'10:00-22:00','本地生活服务平台','2026-07-04 11:00:00'),(2033,NULL,'店主郑的小店','/static/merchant/1008.jpg','郑鼎丰','13800001008','重庆市江津区双福国际农贸城干货区22号',1,'06:00-15:00','食品批发与零售','2026-07-05 07:00:00'),(2034,NULL,'店主孙的小店','/static/merchant/1009.jpg','孙悦','13800001009','重庆市渝中区大坪龙湖时代天街C馆5楼',1,'07:00-22:00','连锁健身品牌运营','2026-07-06 08:00:00'),(2035,NULL,'店主林的小店','/static/merchant/1001.jpg','林和信','13800001010','重庆市江北区江北嘴国金中心T1栋22层',1,'09:00-17:30','代理记账与财税咨询','2026-07-06 10:00:00');
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
) ENGINE=InnoDB AUTO_INCREMENT=4026 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='商家入驻申请表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `merchant_apply`
--

LOCK TABLES `merchant_apply` WRITE;
/*!40000 ALTER TABLE `merchant_apply` DISABLE KEYS */;
INSERT INTO `merchant_apply` VALUES (4001,1001,2,'润禾食品商贸有限公司','/static/id_card/front_1001.jpg','/static/id_card/back_1001.jpg','91500101MA03XXX01',NULL,'JY500101XXX01',NULL,'龙国建','17782222101','重庆市渝北区金开大道星光天地12铺','润禾生活食铺',1,'企业资质齐全，证照审核通过',NULL,'2026-06-05 09:10:00'),(4002,1002,1,'食愈小铺食品经营店','/static/id_card/front_1002.jpg','/static/id_card/back_1002.jpg',NULL,NULL,NULL,NULL,'周小雪','17782222102','重庆市江北区观音桥星光68负一楼','食愈小铺',1,'个体证件完整，准予入驻',NULL,'2026-06-08 14:25:00'),(4003,1003,2,'鲜禧果蔬农产品有限公司','/static/id_card/front_1003.jpg','/static/id_card/back_1003.jpg','91500103MA03XXX03',NULL,'JY500103XXX03',NULL,'林志远','17782222103','重庆市南岸区南坪协信星光一层','鲜禧果仓',1,'生鲜食品资质核验无误',NULL,'2026-06-12 10:05:00'),(4004,1004,2,'家禾粮油副食配送公司','/static/id_card/front_1004.jpg','/static/id_card/back_1004.jpg','91500104MA03XXX04',NULL,'JY500104XXX04',NULL,'苏婉清','17782222104','重庆市九龙坡区杨家坪直港大道','家禾粮油副食',1,'粮油经营许可齐全，审核通过',NULL,'2026-06-15 16:30:00'),(4005,1005,1,'巷味卤货小吃店','/static/id_card/front_1005.jpg','/static/id_card/back_1005.jpg',NULL,NULL,NULL,NULL,'黄德伟','17782222105','重庆市渝中区两路口桂花园路','巷味卤货',1,'熟食卫生资质达标，审核通过',NULL,'2026-06-20 11:15:00'),(4006,1006,1,'果汽鲜饮饮品店','/static/id_card/front_1006.jpg','/static/id_card/back_1006.jpg',NULL,NULL,NULL,NULL,'何雅琴','17782222106','重庆市南岸区茶园时代都汇临街铺','果汽鲜饮',1,'资料待补充食品留样记录，暂未通过','2026-06-25 08:40:00','2026-06-25 08:40:00'),(4007,1007,2,'臻品生活商贸有限公司','/id/0000.jpg','/id/0000.jpg','91500107MA03XXX07','/license/1007.jpg','JY500107XXX07','/foodpermit/1007.jpg','陈勇','17782224506','重庆市大渡口区新山村街道钢花路 56 号','臻品生活馆',1,'企业资质齐全，证照审核通过','2026-06-28 10:30:00','2026-06-28 09:10:00'),(4008,1008,2,'厨乐坊厨具用品有限公司','/id/0000.jpg','/id/0000.jpg','91500108MA03XXX08','/license/1008.jpg','JY500108XXX08','/foodpermit/1008.jpg','王果苗','17782224507','重庆市渝北区回兴街道宝圣大道学府路 105 号','厨乐坊',1,'企业资质齐全，证照审核通过','2026-07-03 10:30:00','2026-07-03 09:10:00'),(4009,1009,2,'贝贝乐母婴用品有限公司','/id/0000.jpg','/id/0000.jpg','91500109MA03XXX09','/license/1009.jpg','JY500109XXX09','/foodpermit/1009.jpg','李鑫瑞','17782224508','重庆市巴南区龙洲湾旭辉城底商 42 号','贝贝乐母婴馆',1,'母婴用品资质齐全，证照审核通过','2026-07-04 10:30:00','2026-07-04 09:10:00'),(4010,1010,2,'滋补堂健康食品有限公司','/id/0000.jpg','/id/0000.jpg','91500110MA03XXX10','/license/1010.jpg','JY500110XXX10','/foodpermit/1010.jpg','赵蕊','17782224509','重庆市九龙坡区西彭镇铝城南路 21 号便民商铺','滋补堂',1,'保健食品资质齐全，证照审核通过','2026-07-06 10:30:00','2026-07-06 09:10:00'),(4011,1011,2,'鑫旺生鲜超市有限公司','/id/0000.jpg','/id/0000.jpg','91500111MA03XXX11','/license/1011.jpg','JY500111XXX11','/foodpermit/1011.jpg','林芳','17782224510','重庆市渝北区龙溪街道花卉园西路','鑫旺生鲜超市',1,'生鲜超市资质齐全，证照审核通过','2026-05-05 10:30:00','2026-05-05 09:10:00'),(4012,1012,2,'尚品烟酒贸易有限公司','/id/0000.jpg','/id/0000.jpg','91500112MA03XXX12','/license/1012.jpg','JY500112XXX12','/foodpermit/1012.jpg','周伟','17782224511','重庆市江北区五里店街道五江路','尚品烟酒行',1,'烟酒专卖资质齐全，证照审核通过','2026-05-16 10:30:00','2026-05-16 09:10:00'),(4013,1013,1,'小清新鲜花店','/id/0000.jpg','/id/0000.jpg','91500113MA03XXX13','/license/1013.jpg','JY500113XXX13','/foodpermit/1013.jpg','吴敏','17782224512','重庆市南岸区南坪万达广场步行街','小清新花店',1,'个体证件完整，准予入驻','2026-06-02 10:30:00','2026-06-02 09:10:00'),(4014,1014,2,'优品电器销售有限公司','/id/0000.jpg','/id/0000.jpg','91500114MA03XXX14','/license/1014.jpg','JY500114XXX14','/foodpermit/1014.jpg','郑强','17782224513','重庆市沙坪坝区小龙坎新街','优品电器城',1,'家电销售资质齐全，证照审核通过','2026-06-21 10:30:00','2026-06-21 09:10:00'),(4015,1015,1,'便民便利店','/id/0000.jpg','/id/0000.jpg','91500115MA03XXX15','/license/1015.jpg','JY500115XXX15','/foodpermit/1015.jpg','孙丽','17782224514','重庆市大渡口区九宫庙街道钢花路','便民便利店',1,'个体证件完整，准予入驻','2026-07-02 10:30:00','2026-07-02 09:10:00'),(4016,1016,2,'茶马古道茶业有限公司','/id/0000.jpg','/id/0000.jpg','91500116MA03XXX16','/license/1016.jpg','JY500116XXX16','/foodpermit/1016.jpg','马超','17782224515','重庆市渝中区解放碑步行街','茶马古道茶行',1,'茶叶销售资质齐全，证照审核通过','2026-05-07 10:30:00','2026-05-07 09:10:00'),(4017,1017,2,'古韵红木家具有限公司','/id/0000.jpg','/id/0000.jpg','91500117MA03XXX17','/license/1017.jpg','JY500117XXX17','/foodpermit/1017.jpg','黄忠','17782224516','重庆市南岸区南坪红星美凯龙','古韵红木家具',1,'家具销售资质齐全，证照审核通过','2026-05-19 10:30:00','2026-05-19 09:10:00'),(4018,1018,2,'潮流数码科技有限公司','/id/0000.jpg','/id/0000.jpg','91500118MA03XXX18','/license/1018.jpg','JY500118XXX18','/foodpermit/1018.jpg','赵云','17782224517','重庆市江北区观音桥赛博数码广场','潮流数码馆',1,'数码产品销售资质齐全，证照审核通过','2026-05-29 10:30:00','2026-05-29 09:10:00'),(4019,1019,2,'茗香茶业有限公司','/id/0000.jpg','/id/0000.jpg','91500119MA03XXX19','/license/1019.jpg','JY500119XXX19','/foodpermit/1019.jpg','魏延','17782224518','重庆市沙坪坝区磁器口古镇','茗香茶庄',1,'茶叶销售资质齐全，证照审核通过','2026-06-09 10:30:00','2026-06-09 09:10:00'),(4020,1020,2,'锦绣丝绸制品有限公司','/id/0000.jpg','/id/0000.jpg','91500120MA03XXX20','/license/1020.jpg','JY500120XXX20','/foodpermit/1020.jpg','关羽','17782224519','重庆市渝北区龙溪街道','锦绣丝绸馆',1,'丝绸制品销售资质齐全，证照审核通过','2026-06-16 10:30:00','2026-06-16 09:10:00'),(4021,1021,2,'味美轩餐饮管理有限公司','/id/0000.jpg','/id/0000.jpg','91500121MA03XXX21','/license/1021.jpg','JY500121XXX21','/foodpermit/1021.jpg','张飞','17782224520','重庆市九龙坡区杨家坪步行街','味美轩餐厅',1,'餐饮服务资质齐全，证照审核通过','2026-06-23 10:30:00','2026-06-23 09:10:00'),(4022,1022,2,'精品服饰贸易有限公司','/id/0000.jpg','/id/0000.jpg','91500122MA03XXX22','/license/1022.jpg','JY500122XXX22','/foodpermit/1022.jpg','刘备','17782224521','重庆市南岸区万达广场','精品服饰店',1,'服饰销售资质齐全，证照审核通过','2026-06-29 10:30:00','2026-06-29 09:10:00'),(4023,1023,2,'智慧图书文化有限公司','/id/0000.jpg','/id/0000.jpg','91500123MA03XXX23','/license/1023.jpg','JY500123XXX23','/foodpermit/1023.jpg','诸葛亮','17782224522','重庆市渝中区新华书店旁','智慧书店',1,'图书销售资质齐全，证照审核通过','2026-07-03 10:30:00','2026-07-03 09:10:00'),(4024,1024,2,'四海海鲜餐饮有限公司','/id/0000.jpg','/id/0000.jpg','91500124MA03XXX24','/license/1024.jpg','JY500124XXX24','/foodpermit/1024.jpg','曹操','17782224523','重庆市巴南区鱼洞滨江路','四海海鲜城',1,'海鲜餐饮资质齐全，证照审核通过','2026-07-04 10:30:00','2026-07-04 09:10:00'),(4025,1025,2,'万宝珠宝有限公司','/id/0000.jpg','/id/0000.jpg','91500125MA03XXX25','/license/1025.jpg','JY500125XXX25','/foodpermit/1025.jpg','孙权','17782224524','重庆市江北区北城天街','万宝珠宝行',1,'珠宝销售资质齐全，证照审核通过','2026-07-05 10:30:00','2026-07-05 09:10:00');
/*!40000 ALTER TABLE `merchant_apply` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `merchant_bank_card`
--

DROP TABLE IF EXISTS `merchant_bank_card`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `merchant_bank_card` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `merchant_id` bigint NOT NULL COMMENT '商家ID',
  `bank_name` varchar(100) NOT NULL COMMENT '开户银行名称',
  `bank_card_number` varchar(30) NOT NULL COMMENT '银行卡号',
  `account_name` varchar(50) NOT NULL COMMENT '开户人姓名',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '绑定时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_merchant_id` (`merchant_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='商家银行卡绑定表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `merchant_bank_card`
--

LOCK TABLES `merchant_bank_card` WRITE;
/*!40000 ALTER TABLE `merchant_bank_card` DISABLE KEYS */;
INSERT INTO `merchant_bank_card` VALUES (1,2001,'中国工商 银行','62220000000000009','龙国建','2026-07-06 14:12:59','2026-07-06 14:12:59');
/*!40000 ALTER TABLE `merchant_bank_card` ENABLE KEYS */;
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
-- Table structure for table `merchant_distribution_product`
--

DROP TABLE IF EXISTS `merchant_distribution_product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `merchant_distribution_product` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `merchant_id` bigint NOT NULL COMMENT '商家ID',
  `product_id` bigint NOT NULL COMMENT '商品ID',
  `commission_rate` decimal(5,2) NOT NULL COMMENT '佣金比例(%)',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态：0-关闭分销，1-开启分销',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_product` (`product_id`),
  KEY `idx_merchant` (`merchant_id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='商家开放分销商品表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `merchant_distribution_product`
--

LOCK TABLES `merchant_distribution_product` WRITE;
/*!40000 ALTER TABLE `merchant_distribution_product` DISABLE KEYS */;
INSERT INTO `merchant_distribution_product` VALUES (1,2001,6001,10.00,1,'2026-07-06 15:09:19','2026-07-06 15:09:19'),(2,2001,6002,8.00,1,'2026-07-06 16:15:19','2026-07-06 16:15:19');
/*!40000 ALTER TABLE `merchant_distribution_product` ENABLE KEYS */;
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
  `total_commission` decimal(12,2) DEFAULT '0.00' COMMENT '累计佣金',
  `available_commission` decimal(12,2) DEFAULT '0.00' COMMENT '可提现佣金',
  PRIMARY KEY (`id`),
  KEY `idx_merchant_id` (`merchant_id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=30222 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='商家收益表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `merchant_earnings`
--

LOCK TABLES `merchant_earnings` WRITE;
/*!40000 ALTER TABLE `merchant_earnings` DISABLE KEYS */;
INSERT INTO `merchant_earnings` VALUES (20001,2001,51,'202605051030010001',70.84,2,'2026-05-05 11:00:00','2026-05-05 15:00:00','2026-07-06 14:13:12','2026-05-05 10:30:00',68.37,68.37),(20002,2002,52,'202605061420010002',36.62,2,'2026-05-06 14:50:00','2026-05-06 18:50:00','2026-05-20 10:00:00','2026-05-06 14:20:00',62.72,62.72),(20003,2003,53,'202605070915020003',33.95,2,'2026-05-07 09:45:00','2026-05-07 13:45:00','2026-05-22 09:30:00','2026-05-07 09:15:00',1256.55,1256.55),(20004,2001,54,'202605081645010004',44.99,2,'2026-05-08 17:15:00','2026-05-08 21:15:00','2026-07-06 14:13:12','2026-05-08 16:45:00',68.37,68.37),(20005,2003,55,'202605091130010005',108.56,1,'2026-05-09 12:00:00','2026-05-09 16:00:00',NULL,'2026-05-09 11:30:00',1256.55,1256.55),(20006,2002,56,'202605100850020006',57.87,1,'2026-05-10 09:20:00','2026-05-10 13:20:00',NULL,'2026-05-10 08:50:00',62.72,62.72),(20007,2004,57,'202605121310010007',78.11,1,'2026-05-12 13:40:00','2026-05-12 17:40:00',NULL,'2026-05-12 13:10:00',1279.40,1279.40),(20008,2001,58,'202605141025010008',103.87,2,'2026-05-14 10:55:00','2026-05-14 14:55:00','2026-07-06 14:13:12','2026-05-14 10:25:00',68.37,68.37),(20009,2005,59,'202605170940010009',34.78,1,'2026-05-17 10:10:00','2026-05-17 14:10:00',NULL,'2026-05-17 09:40:00',65.31,65.31),(20010,2006,60,'202605181520010010',59.80,1,'2026-05-18 15:50:00','2026-05-18 19:50:00',NULL,'2026-05-18 15:20:00',55.32,55.32),(20011,2002,61,'202605201105020011',22.91,1,'2026-05-20 11:35:00','2026-05-20 15:35:00',NULL,'2026-05-20 11:05:00',62.72,62.72),(20012,2003,62,'202605211430010012',45.91,1,'2026-05-21 15:00:00','2026-05-21 19:00:00',NULL,'2026-05-21 14:30:00',1256.55,1256.55),(20013,2004,63,'202605221715010013',41.31,1,'2026-05-22 17:45:00','2026-05-22 21:45:00',NULL,'2026-05-22 17:15:00',1279.40,1279.40),(20014,2005,64,'202605241000010014',22.91,1,'2026-05-24 10:30:00','2026-05-24 14:30:00',NULL,'2026-05-24 10:00:00',65.31,65.31),(20015,2001,65,'202605251650020015',70.84,2,'2026-05-25 17:20:00','2026-05-25 21:20:00','2026-07-06 14:13:12','2026-05-25 16:50:00',68.37,68.37),(20016,2006,66,'202605270930010016',60.54,1,'2026-05-27 10:00:00','2026-05-27 14:00:00',NULL,'2026-05-27 09:30:00',55.32,55.32),(20017,2002,67,'202605291345010017',59.52,1,'2026-05-29 14:15:00','2026-05-29 18:15:00',NULL,'2026-05-29 13:45:00',62.72,62.72),(20018,2004,68,'202605301120010018',93.66,1,'2026-05-30 11:50:00','2026-05-30 15:50:00',NULL,'2026-05-30 11:20:00',1279.40,1279.40),(20019,2004,69,'202606011030010019',62.56,1,'2026-06-01 11:00:00','2026-06-01 15:00:00',NULL,'2026-06-01 10:30:00',1279.40,1279.40),(20020,2002,70,'202606031400020020',76.18,1,'2026-06-03 14:30:00','2026-06-03 18:30:00',NULL,'2026-06-03 14:00:00',62.72,62.72),(20021,2001,71,'202606050915010021',54.10,2,'2026-06-05 09:45:00','2026-06-05 13:45:00','2026-07-06 14:13:12','2026-06-05 09:15:00',68.37,68.37),(20022,2003,72,'202606071630020022',78.20,1,'2026-06-07 17:00:00','2026-06-07 21:00:00',NULL,'2026-06-07 16:30:00',1256.55,1256.55),(20023,2005,73,'202606091145010023',27.51,1,'2026-06-09 12:15:00','2026-06-09 16:15:00',NULL,'2026-06-09 11:45:00',65.31,65.31),(20024,2006,74,'202606100850010024',36.62,1,'2026-06-10 09:20:00','2026-06-10 13:20:00',NULL,'2026-06-10 08:50:00',55.32,55.32),(20025,2001,75,'202606121510020025',68.91,2,'2026-06-12 15:40:00','2026-06-12 19:40:00','2026-07-06 14:13:12','2026-06-12 15:10:00',68.37,68.37),(20026,2004,76,'202606131025010026',36.62,1,'2026-06-13 10:55:00','2026-06-13 14:55:00',NULL,'2026-06-13 10:25:00',1279.40,1279.40),(20027,2003,77,'202606141430020027',45.91,1,'2026-06-14 15:00:00','2026-06-14 19:00:00',NULL,'2026-06-14 14:30:00',1256.55,1256.55),(20028,2005,78,'202606151620010028',31.10,1,'2026-06-15 16:50:00','2026-06-15 20:50:00',NULL,'2026-06-15 16:20:00',65.31,65.31),(20029,2005,79,'202606150950010029',32.94,1,'2026-06-15 10:20:00','2026-06-15 14:20:00',NULL,'2026-06-15 09:50:00',65.31,65.31),(20030,2002,80,'202606171130010030',54.92,1,'2026-06-17 12:00:00','2026-06-17 16:00:00',NULL,'2026-06-17 11:30:00',62.72,62.72),(20031,2001,81,'202606181600020031',66.06,2,'2026-06-18 16:30:00','2026-06-18 20:30:00','2026-07-06 14:13:12','2026-06-18 16:00:00',68.37,68.37),(20032,2006,82,'202606201015010032',78.11,1,'2026-06-20 10:45:00','2026-06-20 14:45:00',NULL,'2026-06-20 10:15:00',55.32,55.32),(20033,2004,83,'202606211445010033',40.48,1,'2026-06-21 15:15:00','2026-06-21 19:15:00',NULL,'2026-06-21 14:45:00',1279.40,1279.40),(20034,2002,84,'202606221000020034',51.34,1,'2026-06-22 10:30:00','2026-06-22 14:30:00',NULL,'2026-06-22 10:00:00',62.72,62.72),(20035,2005,85,'202606230930010035',50.42,1,'2026-06-23 10:00:00','2026-06-23 14:00:00',NULL,'2026-06-23 09:30:00',65.31,65.31),(20036,2003,86,'202606241720020036',108.56,1,'2026-06-24 17:50:00','2026-06-24 21:50:00',NULL,'2026-06-24 17:20:00',1256.55,1256.55),(20037,2004,87,'202606261100010037',62.56,1,'2026-06-26 11:30:00','2026-06-26 15:30:00',NULL,'2026-06-26 11:00:00',1279.40,1279.40),(20038,2002,88,'202606271530020038',45.82,1,'2026-06-27 16:00:00','2026-06-27 20:00:00',NULL,'2026-06-27 15:30:00',62.72,62.72),(20039,2001,89,'202606291005010039',94.76,2,'2026-06-29 10:35:00','2026-06-29 14:35:00','2026-07-06 14:13:12','2026-06-29 10:05:00',68.37,68.37),(20040,2006,90,'202606301340010040',39.47,1,'2026-06-30 14:10:00','2026-06-30 18:10:00',NULL,'2026-06-30 13:40:00',55.32,55.32),(20041,2005,91,'202607010920010041',52.16,0,'2026-07-01 09:50:00','2026-07-01 13:50:00',NULL,'2026-07-01 09:20:00',65.31,65.31),(20042,2003,92,'202607021115020042',112.15,0,'2026-07-02 11:45:00','2026-07-02 15:45:00',NULL,'2026-07-02 11:15:00',1256.55,1256.55),(20043,2004,94,'202607031000010044',82.80,0,'2026-07-03 10:30:00','2026-07-03 14:30:00',NULL,'2026-07-03 10:00:00',1279.40,1279.40),(20044,2002,96,'202607040930010046',55.11,0,'2026-07-04 10:00:00','2026-07-04 14:00:00',NULL,'2026-07-04 09:30:00',62.72,62.72),(30001,2003,201,'2026070241347551',0.00,0,'2026-07-02 17:21:35',NULL,NULL,'2026-07-02 17:08:35',1256.55,1256.55),(30002,2003,202,'2026053076870731',93.63,2,'2026-05-30 17:50:42','2026-05-30 21:30:42','2026-06-13 17:30:42','2026-05-30 17:30:42',1256.55,1256.55),(30003,2003,203,'2026060298990796',102.60,2,'2026-06-02 19:41:36','2026-06-02 23:25:36','2026-06-08 19:25:36','2026-06-02 19:25:36',1256.55,1256.55),(30004,2003,204,'2026062650907231',0.00,0,'2026-06-26 12:05:07',NULL,NULL,'2026-06-26 12:00:07',1256.55,1256.55),(30005,2003,205,'2026060293828623',0.00,0,'2026-06-02 17:47:24',NULL,NULL,'2026-06-02 17:37:24',1256.55,1256.55),(30006,2003,206,'2026052757830589',0.00,0,'2026-05-27 13:54:47',NULL,NULL,'2026-05-27 13:43:47',1256.55,1256.55),(30007,2003,207,'2026053171265235',193.36,2,'2026-05-31 14:32:16','2026-05-31 16:16:16','2026-06-11 14:16:16','2026-05-31 14:16:16',1256.55,1256.55),(30008,2003,208,'2026070454113613',109.44,0,'2026-07-04 16:46:10',NULL,NULL,'2026-07-04 16:23:10',1256.55,1256.55),(30009,2003,209,'2026070666586659',68.19,0,'2026-07-06 18:24:25',NULL,NULL,'2026-07-06 18:14:25',1256.55,1256.55),(30010,2003,210,'2026050821264682',77.56,2,'2026-05-08 18:01:47','2026-05-08 19:53:47','2026-05-17 17:53:47','2026-05-08 17:53:47',1256.55,1256.55),(30011,2003,211,'2026061874700746',182.70,2,'2026-06-18 09:08:46','2026-06-18 10:51:46','2026-06-19 08:51:46','2026-06-18 08:51:46',1256.55,1256.55),(30012,2003,212,'2026070771087490',114.31,1,'2026-07-07 12:47:21','2026-07-07 14:36:21',NULL,'2026-07-07 12:36:21',1256.55,1256.55),(30013,2003,213,'2026060696937569',0.00,0,'2026-06-06 13:32:19',NULL,NULL,'2026-06-06 13:04:19',1256.55,1256.55),(30014,2003,214,'2026062176526111',204.21,1,'2026-06-21 20:50:59','2026-06-22 01:22:59',NULL,'2026-06-21 20:22:59',1256.55,1256.55),(30015,2003,215,'2026070488833267',163.68,0,'2026-07-04 12:32:17',NULL,NULL,'2026-07-04 12:06:17',1256.55,1256.55),(30016,2003,216,'2026062786321619',265.61,1,'2026-06-27 13:30:20','2026-06-27 16:20:20',NULL,'2026-06-27 13:20:20',1256.55,1256.55),(30017,2003,217,'2026051720240498',0.00,0,'2026-05-17 20:54:46',NULL,NULL,'2026-05-17 20:27:46',1256.55,1256.55),(30018,2003,218,'2026062216390281',7.93,1,'2026-06-22 15:02:57','2026-06-22 16:35:57',NULL,'2026-06-22 14:35:57',1256.55,1256.55),(30019,2003,219,'2026053123156047',40.71,2,'2026-05-31 18:47:13','2026-05-31 22:35:13','2026-06-10 18:35:13','2026-05-31 18:35:13',1256.55,1256.55),(30020,2003,220,'2026062729856954',180.16,0,'2026-06-27 18:18:49',NULL,NULL,'2026-06-27 18:09:49',1256.55,1256.55),(30021,2003,221,'2026061950964733',12.19,1,'2026-06-19 21:03:56','2026-06-20 01:54:56',NULL,'2026-06-19 20:54:56',1256.55,1256.55),(30022,2003,222,'2026070389967594',80.35,1,'2026-07-03 19:41:51','2026-07-03 21:17:51',NULL,'2026-07-03 19:17:51',1256.55,1256.55),(30023,2003,223,'2026070194524493',35.23,1,'2026-07-01 16:14:48','2026-07-01 22:06:48',NULL,'2026-07-01 16:06:48',1256.55,1256.55),(30024,2003,224,'2026070516189132',26.17,0,'2026-07-05 12:27:31',NULL,NULL,'2026-07-05 12:20:31',1256.55,1256.55),(30025,2003,225,'2026062878674008',249.37,1,'2026-06-28 12:39:53','2026-06-28 16:22:53',NULL,'2026-06-28 12:22:53',1256.55,1256.55),(30026,2003,226,'2026061883299021',0.00,0,'2026-06-18 14:08:32',NULL,NULL,'2026-06-18 13:48:32',1256.55,1256.55),(30027,2003,227,'2026070518083750',278.14,0,'2026-07-05 17:10:18',NULL,NULL,'2026-07-05 17:04:18',1256.55,1256.55),(30028,2003,228,'2026062782692549',173.81,1,'2026-06-27 13:53:41','2026-06-27 18:38:41',NULL,'2026-06-27 13:38:41',1256.55,1256.55),(30029,2003,229,'2026070273951182',306.69,0,'2026-07-02 09:54:46',NULL,NULL,'2026-07-02 09:30:46',1256.55,1256.55),(30030,2003,230,'2026063056664556',0.00,0,'2026-06-30 17:52:25',NULL,NULL,'2026-06-30 17:28:25',1256.55,1256.55),(30031,2003,231,'2026063080420241',196.77,2,'2026-06-30 19:41:00','2026-06-30 23:13:00','2026-07-01 19:13:00','2026-06-30 19:13:00',1256.55,1256.55),(30032,2003,232,'2026070330908412',176.58,1,'2026-07-03 12:05:08','2026-07-03 15:55:08',NULL,'2026-07-03 11:55:08',1256.55,1256.55),(30033,2003,233,'2026062652316931',0.00,0,'2026-06-26 12:57:48',NULL,NULL,'2026-06-26 12:33:48',1256.55,1256.55),(30034,2003,234,'2026060980645408',233.95,2,'2026-06-09 11:39:05','2026-06-09 15:32:05','2026-06-18 11:32:05','2026-06-09 11:32:05',1256.55,1256.55),(30035,2003,235,'2026070330930329',297.60,1,'2026-07-03 09:31:47','2026-07-03 12:22:47',NULL,'2026-07-03 09:22:47',1256.55,1256.55),(30036,2003,236,'2026062992475481',7.61,2,'2026-06-29 20:32:21','2026-06-30 00:14:21','2026-07-12 20:14:21','2026-06-29 20:14:21',1256.55,1256.55),(30037,2003,237,'2026063041127852',120.42,1,'2026-06-30 14:27:37','2026-06-30 18:17:37',NULL,'2026-06-30 14:17:37',1256.55,1256.55),(30038,2004,238,'2026062914712339',125.65,2,'2026-06-29 11:38:34','2026-06-29 14:16:34','2026-07-08 11:16:34','2026-06-29 11:16:34',1279.40,1279.40),(30039,2004,239,'2026061448865507',68.35,2,'2026-06-14 16:45:01','2026-06-14 20:19:01','2026-06-23 16:19:01','2026-06-14 16:19:01',1279.40,1279.40),(30040,2004,240,'2026070185439757',155.12,0,'2026-07-01 21:44:30',NULL,NULL,'2026-07-01 21:37:30',1279.40,1279.40),(30041,2004,241,'2026070216269198',0.00,0,'2026-07-02 11:11:53',NULL,NULL,'2026-07-02 10:54:53',1279.40,1279.40),(30042,2004,242,'2026051332168452',65.17,2,'2026-05-13 17:43:11','2026-05-13 20:27:11','2026-05-22 17:27:11','2026-05-13 17:27:11',1279.40,1279.40),(30043,2004,243,'2026060693666956',73.06,2,'2026-06-06 14:20:04','2026-06-06 18:03:04','2026-06-14 14:03:04','2026-06-06 14:03:04',1279.40,1279.40),(30044,2004,244,'2026061883132940',11.40,1,'2026-06-18 09:31:33','2026-06-18 14:09:33',NULL,'2026-06-18 09:09:33',1279.40,1279.40),(30045,2004,245,'2026062939877908',0.00,0,'2026-06-29 19:44:41',NULL,NULL,'2026-06-29 19:28:41',1279.40,1279.40),(30046,2004,246,'2026070467744654',111.08,0,'2026-07-04 15:57:22',NULL,NULL,'2026-07-04 15:39:22',1279.40,1279.40),(30047,2004,247,'2026070115208655',294.28,2,'2026-07-01 15:30:12','2026-07-01 19:10:12','2026-07-04 15:10:12','2026-07-01 15:10:12',1279.40,1279.40),(30048,2004,248,'2026070481424031',59.14,0,'2026-07-04 13:13:09',NULL,NULL,'2026-07-04 13:07:09',1279.40,1279.40),(30049,2004,249,'2026070180172105',12.38,0,'2026-07-01 12:41:39',NULL,NULL,'2026-07-01 12:11:39',1279.40,1279.40),(30050,2004,250,'2026062273527967',0.00,0,'2026-06-22 14:08:37',NULL,NULL,'2026-06-22 13:40:37',1279.40,1279.40),(30051,2004,251,'2026062751815408',124.35,0,'2026-06-27 19:45:35',NULL,NULL,'2026-06-27 19:37:35',1279.40,1279.40),(30052,2004,252,'2026061634183893',96.10,2,'2026-06-16 10:40:51','2026-06-16 15:24:51','2026-06-18 10:24:51','2026-06-16 10:24:51',1279.40,1279.40),(30053,2004,253,'2026062660168026',126.67,1,'2026-06-26 19:02:24','2026-06-26 21:36:24',NULL,'2026-06-26 18:36:24',1279.40,1279.40),(30054,2004,254,'2026052759686800',48.11,2,'2026-05-27 13:05:25','2026-05-27 18:42:25','2026-06-04 12:42:25','2026-05-27 12:42:25',1279.40,1279.40),(30055,2004,255,'2026070444810904',50.28,1,'2026-07-04 10:48:04','2026-07-04 13:39:04',NULL,'2026-07-04 10:39:04',1279.40,1279.40),(30056,2004,256,'2026061755393756',197.04,2,'2026-06-17 13:56:05','2026-06-17 17:47:05','2026-07-01 13:47:05','2026-06-17 13:47:05',1279.40,1279.40),(30057,2004,257,'2026052196399347',24.05,2,'2026-05-21 11:43:11','2026-05-21 14:16:11','2026-05-28 11:16:11','2026-05-21 11:16:11',1279.40,1279.40),(30058,2004,258,'2026070514697766',372.03,0,'2026-07-05 17:33:52',NULL,NULL,'2026-07-05 17:22:52',1279.40,1279.40),(30059,2004,259,'2026062810723518',147.37,1,'2026-06-28 19:07:17','2026-06-28 20:54:17',NULL,'2026-06-28 18:54:17',1279.40,1279.40),(30060,2004,260,'2026062584688977',112.92,1,'2026-06-25 09:03:30','2026-06-25 14:50:30',NULL,'2026-06-25 08:50:30',1279.40,1279.40),(30061,2004,261,'2026062510863707',0.00,0,'2026-06-25 08:29:40',NULL,NULL,'2026-06-25 08:22:40',1279.40,1279.40),(30062,2004,262,'2026070591420196',160.05,0,'2026-07-05 15:15:03',NULL,NULL,'2026-07-05 14:46:03',1279.40,1279.40),(30063,2004,263,'2026051985672258',50.59,2,'2026-05-19 17:27:46','2026-05-19 19:07:46','2026-05-31 17:07:46','2026-05-19 17:07:46',1279.40,1279.40),(30064,2004,264,'2026070470488737',0.00,0,'2026-07-04 19:14:36',NULL,NULL,'2026-07-04 18:56:36',1279.40,1279.40),(30065,2004,265,'2026052177076787',156.49,2,'2026-05-21 09:53:17','2026-05-21 12:31:17','2026-06-01 09:31:17','2026-05-21 09:31:17',1279.40,1279.40),(30066,2004,266,'2026070543190991',412.51,0,'2026-07-05 22:05:36',NULL,NULL,'2026-07-05 21:52:36',1279.40,1279.40),(30067,2004,267,'2026070527423935',89.17,2,'2026-07-05 14:23:11','2026-07-05 19:13:11','2026-07-18 14:13:11','2026-07-05 14:13:11',1279.40,1279.40),(30068,2004,268,'2026060667737142',293.95,2,'2026-06-06 21:27:52','2026-06-06 23:00:52','2026-06-14 21:00:52','2026-06-06 21:00:52',1279.40,1279.40),(30069,2004,269,'2026070336984580',0.00,0,'2026-07-03 13:08:52',NULL,NULL,'2026-07-03 12:46:52',1279.40,1279.40),(30070,2004,270,'2026070330299016',61.69,0,'2026-07-03 16:25:18',NULL,NULL,'2026-07-03 16:12:18',1279.40,1279.40),(30071,2004,271,'2026062417756140',224.69,2,'2026-06-24 20:35:33','2026-06-25 00:09:33','2026-06-29 20:09:33','2026-06-24 20:09:33',1279.40,1279.40),(30072,2004,272,'2026062957737017',0.00,0,'2026-06-29 12:51:17',NULL,NULL,'2026-06-29 12:46:17',1279.40,1279.40),(30073,2004,273,'2026060345187042',182.30,2,'2026-06-03 18:22:28','2026-06-03 22:58:28','2026-06-05 17:58:28','2026-06-03 17:58:28',1279.40,1279.40),(30074,2004,274,'2026060319245285',80.54,2,'2026-06-03 09:38:26','2026-06-03 12:19:26','2026-06-05 09:19:26','2026-06-03 09:19:26',1279.40,1279.40),(30075,2007,275,'2026052255709501',320.91,2,'2026-05-22 10:28:13','2026-05-22 13:18:13','2026-06-04 10:18:13','2026-05-22 10:18:13',1002.93,1002.93),(30076,2007,276,'2026052438739667',378.44,2,'2026-05-24 21:33:42','2026-05-25 01:19:42','2026-06-07 21:19:42','2026-05-24 21:19:42',1002.93,1002.93),(30077,2007,277,'2026070758112808',331.02,1,'2026-07-07 21:19:17','2026-07-07 23:59:17',NULL,'2026-07-07 20:59:17',1002.93,1002.93),(30078,2007,278,'2026063035195402',877.36,0,'2026-06-30 11:17:03',NULL,NULL,'2026-06-30 10:50:03',1002.93,1002.93),(30079,2007,279,'2026070480788126',0.00,0,'2026-07-04 13:48:55',NULL,NULL,'2026-07-04 13:31:55',1002.93,1002.93),(30080,2007,280,'2026051119658083',85.59,2,'2026-05-11 12:27:36','2026-05-11 18:09:36','2026-05-14 12:09:36','2026-05-11 12:09:36',1002.93,1002.93),(30081,2007,281,'2026070710650211',119.83,0,'2026-07-07 14:30:33',NULL,NULL,'2026-07-07 14:23:33',1002.93,1002.93),(30082,2007,282,'2026070346218744',333.80,0,'2026-07-03 09:26:15',NULL,NULL,'2026-07-03 09:06:15',1002.93,1002.93),(30083,2007,283,'2026062256425791',0.00,0,'2026-06-22 08:08:12',NULL,NULL,'2026-06-22 08:01:12',1002.93,1002.93),(30084,2007,284,'2026051375153367',148.51,2,'2026-05-13 11:13:58','2026-05-13 13:55:58','2026-05-18 10:55:58','2026-05-13 10:55:58',1002.93,1002.93),(30085,2007,285,'2026070214636297',905.81,1,'2026-07-02 10:07:08','2026-07-02 14:52:08',NULL,'2026-07-02 09:52:08',1002.93,1002.93),(30086,2007,286,'2026060614657899',70.90,2,'2026-06-06 13:25:18','2026-06-06 15:58:18','2026-06-09 12:58:18','2026-06-06 12:58:18',1002.93,1002.93),(30087,2007,287,'2026062888458322',0.00,0,'2026-06-28 19:34:38',NULL,NULL,'2026-06-28 19:07:38',1002.93,1002.93),(30088,2007,288,'2026051243248393',0.00,0,'2026-05-12 19:28:48',NULL,NULL,'2026-05-12 19:20:48',1002.93,1002.93),(30089,2007,289,'2026070621609319',0.00,0,'2026-07-06 21:35:01',NULL,NULL,'2026-07-06 21:10:01',1002.93,1002.93),(30090,2007,290,'2026051890529043',0.00,0,'2026-05-18 18:05:41',NULL,NULL,'2026-05-18 17:41:41',1002.93,1002.93),(30091,2007,291,'2026070455145700',142.94,0,'2026-07-04 15:12:27',NULL,NULL,'2026-07-04 15:04:27',1002.93,1002.93),(30092,2007,292,'2026062337487598',0.00,0,'2026-06-23 14:00:01',NULL,NULL,'2026-06-23 13:47:01',1002.93,1002.93),(30093,2007,293,'2026070764899824',95.35,0,'2026-07-07 22:10:47',NULL,NULL,'2026-07-07 21:58:47',1002.93,1002.93),(30094,2007,294,'2026050821595893',738.21,2,'2026-05-08 21:44:33','2026-05-09 02:36:33','2026-05-19 21:36:33','2026-05-08 21:36:33',1002.93,1002.93),(30095,2007,295,'2026061058337195',0.00,0,'2026-06-10 20:56:16',NULL,NULL,'2026-06-10 20:50:16',1002.93,1002.93),(30096,2007,296,'2026062258323320',0.00,0,'2026-06-22 09:24:42',NULL,NULL,'2026-06-22 09:02:42',1002.93,1002.93),(30097,2007,297,'2026070241041934',150.33,1,'2026-07-02 18:29:32','2026-07-02 21:13:32',NULL,'2026-07-02 18:13:32',1002.93,1002.93),(30098,2007,298,'2026061085563186',125.08,2,'2026-06-10 19:21:45','2026-06-10 21:05:45','2026-06-21 19:05:45','2026-06-10 19:05:45',1002.93,1002.93),(30099,2007,299,'2026070288320247',132.16,0,'2026-07-02 17:47:12',NULL,NULL,'2026-07-02 17:21:12',1002.93,1002.93),(30100,2007,300,'2026061087499722',262.90,2,'2026-06-10 15:02:01','2026-06-10 20:54:01','2026-06-22 14:54:01','2026-06-10 14:54:01',1002.93,1002.93),(30101,2007,301,'2026052830126648',330.42,2,'2026-05-28 14:06:33','2026-05-28 18:52:33','2026-06-09 13:52:33','2026-05-28 13:52:33',1002.93,1002.93),(30102,2007,302,'2026062858796532',0.00,0,'2026-06-28 18:05:43',NULL,NULL,'2026-06-28 17:59:43',1002.93,1002.93),(30103,2007,303,'2026070440120296',0.00,0,'2026-07-04 17:13:08',NULL,NULL,'2026-07-04 16:49:08',1002.93,1002.93),(30104,2007,304,'2026060173580264',0.00,0,'2026-06-01 13:52:07',NULL,NULL,'2026-06-01 13:25:07',1002.93,1002.93),(30105,2007,305,'2026070664698209',309.87,0,'2026-07-06 12:11:09',NULL,NULL,'2026-07-06 11:44:09',1002.93,1002.93),(30106,2007,306,'2026070474873424',56.53,1,'2026-07-04 08:22:07','2026-07-04 12:01:07',NULL,'2026-07-04 08:01:07',1002.93,1002.93),(30107,2007,307,'2026052453976616',1143.13,2,'2026-05-24 12:13:19','2026-05-24 17:47:19','2026-06-05 11:47:19','2026-05-24 11:47:19',1002.93,1002.93),(30108,2007,308,'2026060424554610',131.17,2,'2026-06-04 11:09:46','2026-06-04 14:59:46','2026-06-08 10:59:46','2026-06-04 10:59:46',1002.93,1002.93),(30109,2007,309,'2026061743510982',0.00,0,'2026-06-17 20:30:41',NULL,NULL,'2026-06-17 20:14:41',1002.93,1002.93),(30110,2007,310,'2026052241972769',0.00,0,'2026-05-22 09:48:04',NULL,NULL,'2026-05-22 09:37:04',1002.93,1002.93),(30111,2007,311,'2026060645302327',52.21,2,'2026-06-06 13:18:41','2026-06-06 15:55:41','2026-06-16 12:55:41','2026-06-06 12:55:41',1002.93,1002.93),(30112,2010,312,'2026070280707928',687.12,2,'2026-07-02 10:47:53','2026-07-02 16:30:53','2026-07-11 10:30:53','2026-07-02 10:30:53',21073.00,21073.00),(30113,2010,313,'2026070372041709',1687.19,0,'2026-07-03 14:47:15',NULL,NULL,'2026-07-03 14:27:15',21073.00,21073.00),(30114,2010,314,'2026070361578377',182.59,0,'2026-07-03 09:44:32',NULL,NULL,'2026-07-03 09:28:32',21073.00,21073.00),(30115,2010,315,'2026061828204754',580.36,2,'2026-06-18 12:32:11','2026-06-18 15:27:11','2026-06-25 12:27:11','2026-06-18 12:27:11',21073.00,21073.00),(30116,2010,316,'2026070612773639',2523.26,0,'2026-07-06 12:58:53',NULL,NULL,'2026-07-06 12:48:53',21073.00,21073.00),(30117,2010,317,'2026070561193676',484.41,0,'2026-07-05 17:06:52',NULL,NULL,'2026-07-05 16:37:52',21073.00,21073.00),(30118,2010,318,'2026062842659921',304.76,1,'2026-06-28 13:35:19','2026-06-28 19:13:19',NULL,'2026-06-28 13:13:19',21073.00,21073.00),(30119,2010,319,'2026062224268228',2613.31,1,'2026-06-22 21:11:18','2026-06-23 00:52:18',NULL,'2026-06-22 20:52:18',21073.00,21073.00),(30120,2010,320,'2026051583285764',503.98,2,'2026-05-15 15:28:33','2026-05-15 20:05:33','2026-05-26 15:05:33','2026-05-15 15:05:33',21073.00,21073.00),(30121,2010,321,'2026070481475398',527.16,0,'2026-07-04 12:11:45',NULL,NULL,'2026-07-04 11:57:45',21073.00,21073.00),(30122,2010,322,'2026070481252484',2601.97,1,'2026-07-04 12:59:43','2026-07-04 16:33:43',NULL,'2026-07-04 12:33:43',21073.00,21073.00),(30123,2010,323,'2026070799855351',3070.81,0,'2026-07-07 13:44:20',NULL,NULL,'2026-07-07 13:22:20',21073.00,21073.00),(30124,2010,324,'2026051616008224',475.58,2,'2026-05-16 19:24:50','2026-05-16 22:02:50','2026-05-25 19:02:50','2026-05-16 19:02:50',21073.00,21073.00),(30125,2010,325,'2026060190351554',290.03,2,'2026-06-01 08:53:40','2026-06-01 14:44:40','2026-06-13 08:44:40','2026-06-01 08:44:40',21073.00,21073.00),(30126,2010,326,'2026070565695091',170.44,0,'2026-07-05 16:02:04',NULL,NULL,'2026-07-05 15:41:04',21073.00,21073.00),(30127,2010,327,'2026052165114976',516.52,2,'2026-05-21 15:38:21','2026-05-21 17:27:21','2026-05-23 15:27:21','2026-05-21 15:27:21',21073.00,21073.00),(30128,2010,328,'2026051863738448',195.48,2,'2026-05-18 11:22:38','2026-05-18 15:12:38','2026-05-28 11:12:38','2026-05-18 11:12:38',21073.00,21073.00),(30129,2010,329,'2026060880497267',2004.33,2,'2026-06-08 09:18:04','2026-06-08 11:03:04','2026-06-11 09:03:04','2026-06-08 09:03:04',21073.00,21073.00),(30130,2010,330,'2026062413989295',0.00,0,'2026-06-24 12:33:49',NULL,NULL,'2026-06-24 12:24:49',21073.00,21073.00),(30131,2010,331,'2026070362950266',17.61,0,'2026-07-03 19:54:46',NULL,NULL,'2026-07-03 19:44:46',21073.00,21073.00),(30132,2010,332,'2026052144271022',163.03,2,'2026-05-21 11:32:43','2026-05-21 15:26:43','2026-06-02 11:26:43','2026-05-21 11:26:43',21073.00,21073.00),(30133,2010,333,'2026062783191904',0.00,0,'2026-06-27 18:54:42',NULL,NULL,'2026-06-27 18:26:42',21073.00,21073.00),(30134,2010,334,'2026061861402538',1063.14,1,'2026-06-18 11:06:02','2026-06-18 14:01:02',NULL,'2026-06-18 11:01:02',21073.00,21073.00),(30135,2010,335,'2026052588904680',343.38,2,'2026-05-25 20:50:01','2026-05-25 22:38:01','2026-06-03 20:38:01','2026-05-25 20:38:01',21073.00,21073.00),(30136,2010,336,'2026053186859429',2904.66,2,'2026-05-31 11:59:34','2026-05-31 17:39:34','2026-06-13 11:39:34','2026-05-31 11:39:34',21073.00,21073.00),(30137,2010,337,'2026051880992610',2146.90,2,'2026-05-18 14:30:55','2026-05-18 19:10:55','2026-05-20 14:10:55','2026-05-18 14:10:55',21073.00,21073.00),(30138,2010,338,'2026070772573867',0.00,0,'2026-07-07 18:26:45',NULL,NULL,'2026-07-07 18:21:45',21073.00,21073.00),(30139,2010,339,'2026062435040828',1198.04,1,'2026-06-24 12:56:39','2026-06-24 16:28:39',NULL,'2026-06-24 12:28:39',21073.00,21073.00),(30140,2010,340,'2026062925777046',401.08,1,'2026-06-29 12:43:27','2026-06-29 15:25:27',NULL,'2026-06-29 12:25:27',21073.00,21073.00),(30141,2010,341,'2026070197772498',0.00,0,'2026-07-01 15:06:20',NULL,NULL,'2026-07-01 14:58:20',21073.00,21073.00),(30142,2010,342,'2026070383315486',293.12,0,'2026-07-03 20:10:18',NULL,NULL,'2026-07-03 19:50:18',21073.00,21073.00),(30143,2010,343,'2026052785555294',0.00,0,'2026-05-27 09:39:29',NULL,NULL,'2026-05-27 09:22:29',21073.00,21073.00),(30144,2010,344,'2026070176848177',0.00,0,'2026-07-01 13:14:11',NULL,NULL,'2026-07-01 12:45:11',21073.00,21073.00),(30145,2001,345,'2026052343291095',72.24,2,'2026-05-23 12:53:32','2026-05-23 17:29:32','2026-05-28 12:29:32','2026-05-23 12:29:32',68.37,68.37),(30146,2001,346,'2026051013476931',430.49,2,'2026-05-10 09:24:54','2026-05-10 12:07:54','2026-05-23 09:07:54','2026-05-10 09:07:54',68.37,68.37),(30147,2001,347,'2026062829707414',0.00,0,'2026-06-28 19:57:58',NULL,NULL,'2026-06-28 19:27:58',68.37,68.37),(30148,2001,348,'2026062533617003',162.66,2,'2026-06-25 21:36:24','2026-06-26 00:16:24','2026-07-03 21:16:24','2026-06-25 21:16:24',68.37,68.37),(30149,2002,349,'2026063077502671',23.94,1,'2026-06-30 22:04:26','2026-06-30 23:42:26',NULL,'2026-06-30 21:42:26',62.72,62.72),(30150,2002,350,'2026060144249233',150.40,2,'2026-06-01 16:16:26','2026-06-01 19:09:26','2026-06-12 16:09:26','2026-06-01 16:09:26',62.72,62.72),(30151,2002,351,'2026062162280390',0.00,0,'2026-06-21 12:25:24',NULL,NULL,'2026-06-21 12:18:24',62.72,62.72),(30152,2002,352,'2026062957260654',38.71,2,'2026-06-29 10:50:08','2026-06-29 13:24:08','2026-07-12 10:24:08','2026-06-29 10:24:08',62.72,62.72),(30153,2005,353,'2026060590421947',96.17,2,'2026-06-05 10:47:11','2026-06-05 13:32:11','2026-06-12 10:32:11','2026-06-05 10:32:11',65.31,65.31),(30154,2005,354,'2026062340245613',147.12,2,'2026-06-23 21:22:58','2026-06-24 03:17:58','2026-07-05 21:17:58','2026-06-23 21:17:58',65.31,65.31),(30155,2005,355,'2026062290174045',0.00,0,'2026-06-22 12:43:33',NULL,NULL,'2026-06-22 12:13:33',65.31,65.31),(30156,2005,356,'2026070562833483',105.16,1,'2026-07-05 15:45:07','2026-07-05 20:34:07',NULL,'2026-07-05 15:34:07',65.31,65.31),(30157,2006,357,'2026053115978445',122.30,2,'2026-05-31 09:19:34','2026-05-31 14:56:34','2026-06-03 08:56:34','2026-05-31 08:56:34',55.32,55.32),(30158,2006,358,'2026070352941740',86.09,0,'2026-07-03 13:59:28',NULL,NULL,'2026-07-03 13:38:28',55.32,55.32),(30159,2006,359,'2026070510135775',110.38,0,'2026-07-05 12:48:44',NULL,NULL,'2026-07-05 12:34:44',55.32,55.32),(30160,2006,360,'2026062630828420',219.04,2,'2026-06-26 19:41:53','2026-06-26 22:12:53','2026-07-01 19:12:53','2026-06-26 19:12:53',55.32,55.32),(30161,2008,361,'2026070219297603',0.00,0,'2026-07-02 13:13:09',NULL,NULL,'2026-07-02 13:01:09',0.00,0.00),(30162,2008,362,'2026062840943917',299.66,2,'2026-06-28 19:54:32','2026-06-29 01:43:32','2026-07-11 19:43:32','2026-06-28 19:43:32',0.00,0.00),(30163,2008,363,'2026070580761606',524.79,0,'2026-07-05 12:40:28',NULL,NULL,'2026-07-05 12:23:28',0.00,0.00),(30164,2008,364,'2026070338417359',0.00,0,'2026-07-03 14:42:04',NULL,NULL,'2026-07-03 14:26:04',0.00,0.00),(30165,2009,365,'2026061559334795',703.82,2,'2026-06-15 16:22:38','2026-06-15 19:02:38','2026-06-26 16:02:38','2026-06-15 16:02:38',78.50,78.50),(30166,2009,366,'2026070175657791',0.00,0,'2026-07-01 13:55:52',NULL,NULL,'2026-07-01 13:31:52',78.50,78.50),(30167,2009,367,'2026051383704112',695.48,2,'2026-05-13 10:52:49','2026-05-13 15:37:49','2026-05-24 10:37:49','2026-05-13 10:37:49',78.50,78.50),(30168,2009,368,'2026062439920908',0.00,0,'2026-06-24 20:42:57',NULL,NULL,'2026-06-24 20:30:57',78.50,78.50),(30169,2011,369,'2026070318202893',158.71,0,'2026-07-03 15:29:06',NULL,NULL,'2026-07-03 15:06:06',0.00,0.00),(30170,2011,370,'2026070642304847',59.96,0,'2026-07-06 18:51:53',NULL,NULL,'2026-07-06 18:31:53',0.00,0.00),(30171,2011,371,'2026051259444446',31.95,2,'2026-05-12 13:22:37','2026-05-12 16:05:37','2026-05-15 13:05:37','2026-05-12 13:05:37',0.00,0.00),(30172,2011,372,'2026062928936692',214.73,2,'2026-06-29 20:57:50','2026-06-29 23:35:50','2026-07-13 20:35:50','2026-06-29 20:35:50',0.00,0.00),(30173,2012,373,'2026053081842532',2054.80,2,'2026-05-30 18:17:00','2026-05-30 22:08:00','2026-06-04 18:08:00','2026-05-30 18:08:00',879.92,879.92),(30174,2012,374,'2026052097397439',3815.22,2,'2026-05-20 09:18:23','2026-05-20 12:13:23','2026-05-23 09:13:23','2026-05-20 09:13:23',879.92,879.92),(30175,2012,375,'2026052359552897',1870.12,2,'2026-05-23 21:03:58','2026-05-24 02:34:58','2026-05-27 20:34:58','2026-05-23 20:34:58',879.92,879.92),(30176,2012,376,'2026062974661490',548.46,2,'2026-06-29 17:33:36','2026-06-29 19:22:36','2026-07-02 17:22:36','2026-06-29 17:22:36',879.92,879.92),(30177,2013,377,'2026062423881620',253.58,1,'2026-06-24 08:34:36','2026-06-24 10:25:36',NULL,'2026-06-24 08:25:36',57.55,57.55),(30178,2013,378,'2026052948675960',204.97,2,'2026-05-29 15:38:09','2026-05-29 18:25:09','2026-06-02 15:25:09','2026-05-29 15:25:09',57.55,57.55),(30179,2013,379,'2026052943210169',252.65,2,'2026-05-29 12:57:20','2026-05-29 16:27:20','2026-05-31 12:27:20','2026-05-29 12:27:20',57.55,57.55),(30180,2013,380,'2026062850757195',319.04,0,'2026-06-28 09:57:52',NULL,NULL,'2026-06-28 09:37:52',57.55,57.55),(30181,2014,381,'2026062594805333',5358.31,1,'2026-06-25 13:52:37','2026-06-25 17:33:37',NULL,'2026-06-25 13:33:37',1168.00,1168.00),(30182,2014,382,'2026062376027270',7420.70,2,'2026-06-23 19:45:00','2026-06-23 22:23:00','2026-07-01 19:23:00','2026-06-23 19:23:00',1168.00,1168.00),(30183,2014,383,'2026062799910381',0.00,0,'2026-06-27 11:30:19',NULL,NULL,'2026-06-27 11:12:19',1168.00,1168.00),(30184,2014,384,'2026062823031329',0.00,0,'2026-06-28 12:27:04',NULL,NULL,'2026-06-28 12:19:04',1168.00,1168.00),(30185,2015,385,'2026052979287011',0.00,0,'2026-05-29 18:17:05',NULL,NULL,'2026-05-29 17:48:05',0.00,0.00),(30186,2015,386,'2026050892958463',53.82,2,'2026-05-08 18:59:53','2026-05-08 20:33:53','2026-05-22 18:33:53','2026-05-08 18:33:53',0.00,0.00),(30187,2015,387,'2026052618045217',76.58,2,'2026-05-26 17:56:40','2026-05-26 19:39:40','2026-05-27 17:39:40','2026-05-26 17:39:40',0.00,0.00),(30188,2015,388,'2026060136180340',70.98,2,'2026-06-01 09:27:19','2026-06-01 12:12:19','2026-06-14 09:12:19','2026-06-01 09:12:19',0.00,0.00),(30189,2016,389,'2026070477156746',343.27,0,'2026-07-04 13:44:13',NULL,NULL,'2026-07-04 13:38:13',123.15,123.15),(30190,2016,390,'2026060841393846',1077.80,2,'2026-06-08 10:14:09','2026-06-08 15:47:09','2026-06-17 09:47:09','2026-06-08 09:47:09',123.15,123.15),(30191,2016,391,'2026070241902227',248.70,0,'2026-07-02 21:02:09',NULL,NULL,'2026-07-02 20:34:09',123.15,123.15),(30192,2016,392,'2026051685862009',845.60,2,'2026-05-16 21:42:03','2026-05-16 23:31:03','2026-05-19 21:31:03','2026-05-16 21:31:03',123.15,123.15),(30193,2017,393,'2026070534519980',16025.15,0,'2026-07-05 16:59:41',NULL,NULL,'2026-07-05 16:53:41',0.00,0.00),(30194,2017,394,'2026063032625120',0.00,0,'2026-06-30 09:33:30',NULL,NULL,'2026-06-30 09:20:30',0.00,0.00),(30195,2017,395,'2026051360748138',0.00,0,'2026-05-13 19:34:29',NULL,NULL,'2026-05-13 19:04:29',0.00,0.00),(30196,2017,396,'2026062489620574',0.00,0,'2026-06-24 19:06:47',NULL,NULL,'2026-06-24 18:36:47',0.00,0.00),(30197,2018,397,'2026062455682169',13069.75,1,'2026-06-24 21:54:37','2026-06-25 03:24:37',NULL,'2026-06-24 21:24:37',19003.80,19003.80),(30198,2018,398,'2026060999423841',7976.56,2,'2026-06-09 10:36:35','2026-06-09 15:17:35','2026-06-22 10:17:35','2026-06-09 10:17:35',19003.80,19003.80),(30199,2018,399,'2026051763811208',17034.98,2,'2026-05-17 16:06:02','2026-05-17 17:40:02','2026-05-21 15:40:02','2026-05-17 15:40:02',19003.80,19003.80),(30200,2018,400,'2026070588876485',0.00,0,'2026-07-05 09:41:27',NULL,NULL,'2026-07-05 09:21:27',19003.80,19003.80),(30201,2019,401,'2026052778506444',610.18,2,'2026-05-27 14:02:29','2026-05-27 17:54:29','2026-06-04 13:54:29','2026-05-27 13:54:29',71.90,71.90),(30202,2019,402,'2026070228496971',525.65,0,'2026-07-02 15:07:22',NULL,NULL,'2026-07-02 14:43:22',71.90,71.90),(30203,2019,403,'2026051143644699',183.02,2,'2026-05-11 19:22:51','2026-05-12 00:03:51','2026-05-16 19:03:51','2026-05-11 19:03:51',71.90,71.90),(30204,2020,404,'2026051869902538',1221.14,2,'2026-05-18 18:50:37','2026-05-18 20:25:37','2026-05-19 18:25:37','2026-05-18 18:25:37',62.80,62.80),(30205,2020,405,'2026070420365466',3883.96,0,'2026-07-04 09:56:15',NULL,NULL,'2026-07-04 09:51:15',62.80,62.80),(30206,2020,406,'2026070698364077',567.34,0,'2026-07-06 08:19:55',NULL,NULL,'2026-07-06 08:12:55',62.80,62.80),(30207,2021,407,'2026062733224169',0.00,0,'2026-06-27 09:07:29',NULL,NULL,'2026-06-27 09:00:29',0.00,0.00),(30208,2021,408,'2026062614055488',0.00,0,'2026-06-26 19:25:20',NULL,NULL,'2026-06-26 18:58:20',0.00,0.00),(30209,2021,409,'2026051439276159',83.59,2,'2026-05-14 16:35:12','2026-05-14 19:09:12','2026-05-15 16:09:12','2026-05-14 16:09:12',0.00,0.00),(30210,2022,410,'2026051459841212',4993.20,2,'2026-05-14 11:32:13','2026-05-14 16:10:13','2026-05-19 11:10:13','2026-05-14 11:10:13',968.16,968.16),(30211,2022,411,'2026051772736864',2390.74,2,'2026-05-17 13:36:11','2026-05-17 16:22:11','2026-05-18 13:22:11','2026-05-17 13:22:11',968.16,968.16),(30212,2022,412,'2026062256840044',0.00,0,'2026-06-22 11:37:36',NULL,NULL,'2026-06-22 11:16:36',968.16,968.16),(30213,2023,413,'2026070182706348',0.00,0,'2026-07-01 14:10:31',NULL,NULL,'2026-07-01 13:53:31',0.00,0.00),(30214,2023,414,'2026062719117381',313.80,2,'2026-06-27 12:23:42','2026-06-27 15:11:42','2026-07-05 12:11:42','2026-06-27 12:11:42',0.00,0.00),(30215,2023,415,'2026061156266139',218.26,2,'2026-06-11 16:42:33','2026-06-11 19:13:33','2026-06-19 16:13:33','2026-06-11 16:13:33',0.00,0.00),(30216,2024,416,'2026061832829330',367.55,1,'2026-06-18 13:21:45','2026-06-18 15:11:45',NULL,'2026-06-18 13:11:45',62.25,62.25),(30217,2024,417,'2026061976794512',353.08,2,'2026-06-19 14:20:53','2026-06-19 19:58:53','2026-07-03 13:58:53','2026-06-19 13:58:53',62.25,62.25),(30218,2024,418,'2026062341179121',0.00,0,'2026-06-23 15:31:26',NULL,NULL,'2026-06-23 15:26:26',62.25,62.25),(30219,2025,419,'2026070518576463',7882.61,0,'2026-07-05 13:49:03',NULL,NULL,'2026-07-05 13:39:03',13599.36,13599.36),(30220,2025,420,'2026061348926870',44491.77,2,'2026-06-13 19:56:54','2026-06-13 23:44:54','2026-06-26 19:44:54','2026-06-13 19:44:54',13599.36,13599.36),(30221,2025,421,'2026060664575423',26342.93,2,'2026-06-06 13:40:40','2026-06-06 19:31:40','2026-06-15 13:31:40','2026-06-06 13:31:40',13599.36,13599.36);
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
) ENGINE=InnoDB AUTO_INCREMENT=3026 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='商家资质表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `merchant_qualification`
--

LOCK TABLES `merchant_qualification` WRITE;
/*!40000 ALTER TABLE `merchant_qualification` DISABLE KEYS */;
INSERT INTO `merchant_qualification` VALUES (3001,2001,'综合休闲食品、鲜果零食','91500101MA03XXX01','/static/business_license/1001.jpg','JY500101XXX01','/static/food_permit/1001.jpg'),(3002,2002,'网红零食、糕点膨化食品','91500102MA03XXX02','/static/business_license/1002.jpg','JY500102XXX02','/static/food_permit/1002.jpg'),(3003,2003,'新鲜水果、果干蜜饯坚果','91500103MA03XXX03','/static/business_license/1003.jpg','JY500103XXX03','/static/food_permit/1003.jpg'),(3004,2004,'粮油米面、调味罐头速食','91500104MA03XXX04','/static/business_license/1004.jpg','JY500104XXX04','/static/food_permit/1004.jpg'),(3005,2005,'卤味熟食、肉干即食食品','91500105MA03XXX05','/static/business_license/1005.jpg','JY500105XXX05','/static/food_permit/1005.jpg'),(3006,2006,'鲜果现榨气泡饮品、鲜萃茶饮、冷藏即饮果汁汽水','91500106MA03XXX05','/license/1006.jpg','JY500106XXX05','/foodpermit/1001.jpg'),(3007,2007,'家居百货、个护美妆、清洁用品','91500107MA03XXX07','/license/1007.jpg','JY500107XXX07','/foodpermit/1007.jpg'),(3008,2008,'厨具餐具、厨房配件、小家电','91500108MA03XXX08','/license/1008.jpg','JY500108XXX08','/foodpermit/1008.jpg'),(3009,2009,'母婴用品、婴幼儿食品、儿童玩具','91500109MA03XXX09','/license/1009.jpg','JY500109XXX09','/foodpermit/1009.jpg'),(3010,2010,'保健食品、滋补品、进口食品','91500110MA03XXX10','/license/1010.jpg','JY500110XXX10','/foodpermit/1010.jpg'),(3011,2011,'新鲜蔬果、肉蛋禽奶、粮油米面','91500111MA03XXX11','/license/1011.jpg','JY500111XXX11','/foodpermit/1011.jpg'),(3012,2012,'高端白酒、进口红酒、名烟名茶','91500112MA03XXX12','/license/1012.jpg','JY500112XXX12','/foodpermit/1012.jpg'),(3013,2013,'鲜花绿植、盆栽花卉、节日礼品','91500113MA03XXX13','/license/1013.jpg','JY500113XXX13','/foodpermit/1013.jpg'),(3014,2014,'大家电、小家电、数码产品','91500114MA03XXX14','/license/1014.jpg','JY500114XXX14','/foodpermit/1014.jpg'),(3015,2015,'日用百货、零食饮料、便民商品','91500115MA03XXX15','/license/1015.jpg','JY500115XXX15','/foodpermit/1015.jpg'),(3016,2016,'茶叶茶具、名茶品鉴、茶礼定制','91500116MA03XXX16','/license/1016.jpg','JY500116XXX16','/foodpermit/1016.jpg'),(3017,2017,'红木家具、古典工艺、实木定制','91500117MA03XXX17','/license/1017.jpg','JY500117XXX17','/foodpermit/1017.jpg'),(3018,2018,'手机电脑、数码配件、智能设备','91500118MA03XXX18','/license/1018.jpg','JY500118XXX18','/foodpermit/1018.jpg'),(3019,2019,'名优茶叶、茶具礼品、茶点零食','91500119MA03XXX19','/license/1019.jpg','JY500119XXX19','/foodpermit/1019.jpg'),(3020,2020,'丝绸制品、传统工艺、礼品定制','91500120MA03XXX20','/license/1020.jpg','JY500120XXX20','/foodpermit/1020.jpg'),(3021,2021,'川菜粤菜、特色美食、餐饮服务','91500121MA03XXX21','/license/1021.jpg','JY500121XXX21','/foodpermit/1021.jpg'),(3022,2022,'品牌服饰、潮流搭配、鞋帽箱包','91500122MA03XXX22','/license/1022.jpg','JY500122XXX22','/foodpermit/1022.jpg'),(3023,2023,'图书文具、文创产品、教辅材料','91500123MA03XXX23','/license/1023.jpg','JY500123XXX23','/foodpermit/1023.jpg'),(3024,2024,'海鲜水产、新鲜直供、海鲜加工','91500124MA03XXX24','/license/1024.jpg','JY500124XXX24','/foodpermit/1024.jpg'),(3025,2025,'金银珠宝、奢侈品、首饰定制','91500125MA03XXX25','/license/1025.jpg','JY500125XXX25','/foodpermit/1025.jpg');
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
INSERT INTO `operation_admin` VALUES (1,'operator01','56ed087f4411c193dbbb1421745bae12','运营张三','13900001001','zhangsan@example.com','商品运营',1,'2026-07-07 10:55:44','2026-01-01 00:00:00'),(2,'operator02','56ed087f4411c193dbbb1421745bae12','运营李四','13900001002','lisi@example.com','内容运营',1,'2026-07-03 10:00:00','2026-02-01 00:00:00'),(3,'operator03','56ed087f4411c193dbbb1421745bae12','运营王五','13900001003','wangwu@example.com','活动运营',1,'2026-07-02 14:00:00','2026-03-01 00:00:00'),(4,'operator04','56ed087f4411c193dbbb1421745bae12','运营小美','13900001004','xiaomei@example.com','用户运营',1,'2026-07-03 08:30:00','2026-04-01 00:00:00');
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
  `promotion_code` varchar(50) DEFAULT NULL COMMENT '推广码',
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
  `commission` decimal(10,2) DEFAULT '0.00' COMMENT '平台佣金',
  `commission_rate` decimal(5,4) DEFAULT '0.0000' COMMENT '佣金费率',
  `merchant_tier` varchar(20) DEFAULT '' COMMENT '商家层级',
  `platform_subsidy` decimal(10,2) DEFAULT '0.00' COMMENT '平台补贴',
  `net_income` decimal(10,2) DEFAULT '0.00' COMMENT '净收入',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `fk_order_user` (`user_id`) USING BTREE,
  KEY `fk_order_merchant` (`merchant_id`) USING BTREE,
  KEY `fk_order_pickup` (`pickup_point_id`) USING BTREE,
  CONSTRAINT `fk_order_merchant` FOREIGN KEY (`merchant_id`) REFERENCES `merchant` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_order_pickup` FOREIGN KEY (`pickup_point_id`) REFERENCES `pickup_point` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_order_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=422 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='订单主表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order`
--

LOCK TABLES `order` WRITE;
/*!40000 ALTER TABLE `order` DISABLE KEYS */;
INSERT INTO `order` VALUES (51,'202605051030010001',1004,2001,NULL,77.00,82.00,0.00,1,5.00,0.00,0.00,0.00,NULL,4,'IK_1004_20260505103001',0,0,101,'赵六','17782222104',NULL,NULL,NULL,NULL,NULL,'重庆市江北区观音桥建新北路76号阳光花园3栋1502',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,'2026-05-05 11:00:00','2026-05-05 10:31:25',NULL,'2026-05-05 10:30:00','2026-05-05 10:31:25','2026-05-05 10:35:00','2026-05-05 11:20:00','2026-05-06 09:00:00',0,NULL,NULL,4.10,0.0500,'尾部商家',0.00,2.05),(52,'202605061420010002',1004,2002,NULL,39.80,44.80,0.00,1,5.00,0.00,0.00,0.00,NULL,4,'IK_1004_20260506142001',0,0,101,'赵六','17782222104',NULL,NULL,NULL,NULL,NULL,'重庆市江北区观音桥建新北路76号阳光花园3栋1502',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,'2026-05-06 14:50:00','2026-05-06 14:22:30',NULL,'2026-05-06 14:20:00','2026-05-06 14:22:30','2026-05-06 14:28:00','2026-05-06 14:55:00','2026-05-07 10:00:00',0,NULL,NULL,2.24,0.0500,'尾部商家',0.00,1.12),(53,'202605070915020003',1007,2003,9,36.90,36.90,0.00,2,0.00,0.00,0.00,0.00,NULL,4,'IK_1007_20260507091501',0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,'2026-05-07 09:45:00','2026-05-07 09:16:40',NULL,'2026-05-07 09:15:00','2026-05-07 09:16:40','2026-05-07 09:22:00','2026-05-07 10:30:00','2026-05-07 17:00:00',0,'345821',NULL,2.95,0.0800,'腰部商家',0.00,1.48),(54,'202605081645010004',1008,2001,7,48.90,48.90,0.00,2,0.00,0.00,0.00,0.00,NULL,4,'IK_1008_20260508164501',0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,'2026-05-08 17:15:00','2026-05-08 16:46:10',NULL,'2026-05-08 16:45:00','2026-05-08 16:46:10','2026-05-08 16:52:00','2026-05-08 17:30:00','2026-05-09 11:00:00',0,'672109',NULL,2.45,0.0500,'尾部商家',0.00,1.22),(55,'202605091130010005',1004,2003,NULL,118.00,118.00,15.00,1,5.00,0.00,0.00,0.00,NULL,4,'IK_1004_20260509113001',200,2,NULL,'赵六','17782222104',NULL,NULL,NULL,NULL,NULL,'重庆市江北区观音桥建新北路76号阳光花园3栋1502',5001,NULL,5.00,0.00,0.00,NULL,NULL,NULL,1,'2026-05-09 12:00:00','2026-05-09 11:31:50',NULL,'2026-05-09 11:30:00','2026-05-09 11:31:50','2026-05-09 11:38:00','2026-05-09 12:10:00','2026-05-10 09:30:00',0,NULL,NULL,9.44,0.0800,'腰部商家',10.00,4.72),(56,'202605100850020006',1009,2002,8,62.90,62.90,0.00,2,0.00,0.00,0.00,0.00,NULL,4,'IK_1009_20260510085001',0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,'2026-05-10 09:20:00','2026-05-10 08:52:15',NULL,'2026-05-10 08:50:00','2026-05-10 08:52:15','2026-05-10 08:58:00','2026-05-10 09:35:00','2026-05-10 18:00:00',0,'894231',NULL,3.15,0.0500,'尾部商家',0.00,1.57),(57,'202605121310010007',1010,2004,NULL,84.90,89.90,13.00,1,5.00,0.00,0.00,0.00,NULL,4,'IK_1010_20260512131001',0,0,102,'赵一','17782222107',NULL,NULL,NULL,NULL,NULL,'重庆市渝北区冉家坝龙湖水晶郦城2栋1001',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,'2026-05-12 13:40:00','2026-05-12 13:11:30',NULL,'2026-05-12 13:10:00','2026-05-12 13:11:30','2026-05-12 13:20:00','2026-05-12 13:50:00','2026-05-13 08:00:00',0,NULL,NULL,7.19,0.0800,'腰部商家',13.00,3.60),(58,'202605141025010008',1004,2001,NULL,112.90,107.90,10.00,1,5.00,0.00,0.00,0.00,NULL,4,'IK_1004_20260514102501',300,2,101,'赵六','17782222104',NULL,NULL,NULL,NULL,NULL,'重庆市江北区观音桥建新北路76号阳光花园3栋1502',5002,NULL,10.00,0.00,0.00,NULL,NULL,NULL,1,'2026-05-14 10:55:00','2026-05-14 10:27:05',NULL,'2026-05-14 10:25:00','2026-05-14 10:27:05','2026-05-14 10:33:00','2026-05-14 11:00:00','2026-05-15 09:00:00',0,NULL,NULL,5.40,0.0500,'尾部商家',0.00,2.70),(59,'202605170940010009',1011,2005,NULL,37.80,42.80,0.00,1,5.00,0.00,0.00,0.00,NULL,4,'IK_1011_20260517094001',0,0,103,'孙小红','17782222108',NULL,NULL,NULL,NULL,NULL,'重庆市南岸区南坪上海城19栋705',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,'2026-05-17 10:10:00','2026-05-17 09:41:20',NULL,'2026-05-17 09:40:00','2026-05-17 09:41:20','2026-05-17 09:48:00','2026-05-17 10:20:00','2026-05-18 08:30:00',0,NULL,NULL,2.14,0.0500,'尾部商家',0.00,1.07),(60,'202605181520010010',1012,2006,NULL,65.00,70.00,0.00,1,5.00,0.00,0.00,0.00,NULL,4,'IK_1012_20260518152001',0,0,104,'周小明','17782222109',NULL,NULL,NULL,NULL,NULL,'重庆市九龙坡区谢家湾华润24城5栋2203',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,'2026-05-18 15:50:00','2026-05-18 15:21:45',NULL,'2026-05-18 15:20:00','2026-05-18 15:21:45','2026-05-18 15:30:00','2026-05-18 16:05:00','2026-05-19 10:00:00',0,NULL,NULL,3.50,0.0500,'尾部商家',0.00,1.75),(61,'202605201105020011',1004,2002,8,24.90,24.90,0.00,2,0.00,0.00,0.00,0.00,NULL,4,'IK_1004_20260520110501',0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,'2026-05-20 11:35:00','2026-05-20 11:06:30',NULL,'2026-05-20 11:05:00','2026-05-20 11:06:30','2026-05-20 11:12:00','2026-05-20 11:50:00','2026-05-20 17:30:00',0,'156479',NULL,1.25,0.0500,'尾部商家',0.00,0.62),(62,'202605211430010012',1013,2003,NULL,49.90,54.90,0.00,1,5.00,0.00,0.00,0.00,NULL,4,'IK_1013_20260521143001',0,0,105,'吴小丽','17782222110',NULL,NULL,NULL,NULL,NULL,'重庆市大渡口区九宫庙湖榕路锦天康都1栋1204',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,'2026-05-21 15:00:00','2026-05-21 14:31:50',NULL,'2026-05-21 14:30:00','2026-05-21 14:31:50','2026-05-21 14:40:00','2026-05-21 15:15:00','2026-05-22 09:00:00',0,NULL,NULL,4.39,0.0800,'腰部商家',0.00,2.20),(63,'202605221715010013',1008,2004,NULL,44.90,49.90,0.00,1,5.00,0.00,0.00,0.00,NULL,5,'IK_1008_20260522171501',0,0,106,'王一','17782222111',NULL,NULL,NULL,NULL,NULL,'重庆市巴南区鱼洞巴南印象6栋808',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,'2026-05-22 17:45:00','2026-05-22 17:16:30',NULL,'2026-05-22 17:15:00','2026-05-22 17:26:30','2026-05-22 17:22:00','2026-05-22 17:40:00','2026-05-22 17:40:00',0,NULL,NULL,0.00,0.0000,'',0.00,0.00),(64,'202605241000010014',1007,2005,NULL,24.90,29.90,0.00,1,5.00,0.00,0.00,0.00,NULL,4,'IK_1007_20260524100001',0,0,107,'陈二','17782222112',NULL,NULL,NULL,NULL,NULL,'重庆市渝北区龙溪街道武陵路锦江郦城9栋1601',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,'2026-05-24 10:30:00','2026-05-24 10:01:40',NULL,'2026-05-24 10:00:00','2026-05-24 10:01:40','2026-05-24 10:10:00','2026-05-24 10:45:00','2026-05-25 08:30:00',0,NULL,NULL,1.50,0.0500,'尾部商家',0.00,0.75),(65,'202605251650020015',1014,2001,7,77.00,72.00,5.00,2,0.00,0.00,0.00,0.00,NULL,4,'IK_1014_20260525165001',0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,5003,NULL,5.00,0.00,0.00,NULL,NULL,NULL,1,'2026-05-25 17:20:00','2026-05-25 16:51:30',NULL,'2026-05-25 16:50:00','2026-05-25 16:51:30','2026-05-25 16:58:00','2026-05-25 17:30:00','2026-05-26 09:00:00',0,'483290',NULL,3.60,0.0500,'尾部商家',0.00,1.80),(66,'202605270930010016',1009,2006,NULL,65.80,70.80,0.00,1,5.00,0.00,0.00,0.00,NULL,3,'IK_1009_20260527093001',0,0,108,'李二','17782222113',NULL,NULL,NULL,NULL,NULL,'重庆市江北区五里店融景城郎峰11栋505',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,'2026-05-27 10:00:00','2026-05-27 09:31:25',NULL,'2026-05-27 09:30:00','2026-05-27 09:31:25','2026-05-27 09:35:00','2026-05-27 09:55:00','2026-05-27 10:20:00',0,NULL,NULL,3.54,0.0500,'尾部商家',0.00,1.77),(67,'202605291345010017',1004,2002,NULL,64.70,69.70,0.00,1,5.00,0.00,0.00,0.00,NULL,4,'IK_1004_20260529134501',0,0,101,'赵六','17782222104',NULL,NULL,NULL,NULL,NULL,'重庆市江北区观音桥建新北路76号阳光花园3栋1502',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,'2026-05-29 14:15:00','2026-05-29 13:46:10',NULL,'2026-05-29 13:45:00','2026-05-29 13:46:10','2026-05-29 13:52:00','2026-05-29 14:30:00','2026-05-30 09:00:00',0,NULL,NULL,3.49,0.0500,'尾部商家',0.00,1.74),(68,'202605301120010018',1015,2004,NULL,101.80,106.80,10.00,1,5.00,0.00,0.00,0.00,NULL,4,'IK_1015_20260530112001',0,0,109,'郑七','17782222114',NULL,NULL,NULL,NULL,NULL,'重庆市南岸区弹子石国际社区海悦府8栋2806',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,'2026-05-30 11:50:00','2026-05-30 11:22:00',NULL,'2026-05-30 11:20:00','2026-05-30 11:22:00','2026-05-30 11:30:00','2026-05-30 12:05:00','2026-05-31 09:00:00',0,NULL,NULL,8.54,0.0800,'腰部商家',10.00,4.27),(69,'202606011030010019',1004,2004,NULL,68.00,73.00,0.00,1,5.00,0.00,0.00,0.00,NULL,4,'IK_1004_20260601103001',0,0,101,'赵六','17782222104',NULL,NULL,NULL,NULL,NULL,'重庆市江北区观音桥建新北路76号阳光花园3栋1502',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,'2026-06-01 11:00:00','2026-06-01 10:31:30',NULL,'2026-06-01 10:30:00','2026-06-01 10:31:30','2026-06-01 10:38:00','2026-06-01 11:10:00','2026-06-02 09:00:00',0,NULL,NULL,5.84,0.0800,'腰部商家',0.00,2.92),(70,'202606031400020020',1007,2002,8,82.80,82.80,0.00,2,0.00,0.00,0.00,0.00,NULL,4,'IK_1007_20260603140001',0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,'2026-06-03 14:30:00','2026-06-03 14:01:20',NULL,'2026-06-03 14:00:00','2026-06-03 14:01:20','2026-06-03 14:08:00','2026-06-03 14:40:00','2026-06-04 10:00:00',0,'729583',NULL,4.14,0.0500,'尾部商家',0.00,2.07),(71,'202606050915010021',1010,2001,NULL,58.80,63.80,0.00,1,5.00,0.00,0.00,0.00,NULL,4,'IK_1010_20260605091501',0,0,102,'赵一','17782222107',NULL,NULL,NULL,NULL,NULL,'重庆市渝北区冉家坝龙湖水晶郦城2栋1001',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,'2026-06-05 09:45:00','2026-06-05 09:16:10',NULL,'2026-06-05 09:15:00','2026-06-05 09:16:10','2026-06-05 09:22:00','2026-06-05 09:55:00','2026-06-06 08:30:00',0,NULL,NULL,3.19,0.0500,'尾部商家',0.00,1.60),(72,'202606071630020022',1011,2003,9,85.00,85.00,15.00,2,0.00,0.00,0.00,0.00,NULL,4,'IK_1011_20260607163001',200,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,'2026-06-07 17:00:00','2026-06-07 16:32:00',NULL,'2026-06-07 16:30:00','2026-06-07 16:32:00','2026-06-07 16:40:00','2026-06-07 17:20:00','2026-06-08 09:00:00',0,'314670',NULL,6.80,0.0800,'腰部商家',15.00,3.40),(73,'202606091145010023',1008,2005,NULL,29.90,34.90,0.00,1,5.00,0.00,0.00,0.00,NULL,4,'IK_1008_20260609114501',0,0,106,'王一','17782222111',NULL,NULL,NULL,NULL,NULL,'重庆市巴南区鱼洞巴南印象6栋808',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,'2026-06-09 12:15:00','2026-06-09 11:46:40',NULL,'2026-06-09 11:45:00','2026-06-09 11:46:40','2026-06-09 11:55:00','2026-06-09 12:30:00','2026-06-10 08:00:00',0,NULL,NULL,1.75,0.0500,'尾部商家',0.00,0.87),(74,'202606100850010024',1016,2006,NULL,39.80,44.80,0.00,1,5.00,0.00,0.00,0.00,NULL,5,'IK_1016_20260610085001',0,0,110,'冯八','17782222115',NULL,NULL,NULL,NULL,NULL,'重庆市渝中区大坪英利国际2栋2208',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,'2026-06-10 09:20:00','2026-06-10 08:52:00',NULL,'2026-06-10 08:50:00','2026-06-10 09:02:00','2026-06-10 08:56:00','2026-06-10 09:10:00','2026-06-10 09:10:00',0,NULL,NULL,0.00,0.0000,'',0.00,0.00),(75,'202606121510020025',1004,2001,7,74.90,64.90,10.00,2,0.00,0.00,0.00,0.00,NULL,4,'IK_1004_20260612151001',0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,5004,NULL,10.00,0.00,0.00,NULL,NULL,NULL,2,'2026-06-12 15:40:00','2026-06-12 15:11:30',NULL,'2026-06-12 15:10:00','2026-06-12 15:11:30','2026-06-12 15:18:00','2026-06-12 16:00:00','2026-06-13 09:30:00',0,'508923',NULL,3.25,0.0500,'尾部商家',0.00,1.62),(76,'202606131025010026',1017,2004,NULL,39.80,44.80,0.00,1,5.00,0.00,0.00,0.00,NULL,3,'IK_1017_20260613102501',0,0,111,'陈九','17782222116',NULL,NULL,NULL,NULL,NULL,'重庆市九龙坡区石桥铺华宇名都15栋1609',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,'2026-06-13 10:55:00','2026-06-13 10:26:30',NULL,'2026-06-13 10:25:00','2026-06-13 10:26:30','2026-06-13 10:32:00','2026-06-13 11:00:00','2026-06-13 11:20:00',0,NULL,NULL,3.58,0.0800,'腰部商家',0.00,1.79),(77,'202606141430020027',1009,2003,9,49.90,49.90,0.00,2,0.00,0.00,0.00,0.00,NULL,4,'IK_1009_20260614143001',0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,'2026-06-14 15:00:00','2026-06-14 14:31:50',NULL,'2026-06-14 14:30:00','2026-06-14 14:31:50','2026-06-14 14:38:00','2026-06-14 15:10:00','2026-06-14 18:00:00',0,'892105',NULL,3.99,0.0800,'腰部商家',0.00,2.00),(78,'202606151620010028',1009,2005,NULL,33.80,38.80,0.00,1,5.00,0.00,0.00,0.00,NULL,4,'IK_1009_20260615162001',0,0,108,'李二','17782222113',NULL,NULL,NULL,NULL,NULL,'重庆市江北区五里店融景城郎峰11栋505',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,'2026-06-15 16:50:00','2026-06-15 16:21:30',NULL,'2026-06-15 16:20:00','2026-06-15 16:21:30','2026-06-15 16:28:00','2026-06-15 17:00:00','2026-06-16 08:30:00',0,NULL,NULL,1.94,0.0500,'尾部商家',0.00,0.97),(79,'202606150950010029',1018,2005,NULL,35.80,40.80,0.00,1,5.00,0.00,0.00,0.00,NULL,4,'IK_1018_20260615095001',0,0,112,'林十','17782222117',NULL,NULL,NULL,NULL,NULL,'重庆市大渡口区春晖路柏华小区3栋402',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,'2026-06-15 10:20:00','2026-06-15 09:52:00',NULL,'2026-06-15 09:50:00','2026-06-15 09:52:00','2026-06-15 10:00:00','2026-06-15 10:35:00','2026-06-16 09:00:00',0,NULL,NULL,2.04,0.0500,'尾部商家',0.00,1.02),(80,'202606171130010030',1004,2002,NULL,59.70,64.70,0.00,1,5.00,0.00,0.00,0.00,NULL,4,'IK_1004_20260617113001',0,0,101,'赵六','17782222104',NULL,NULL,NULL,NULL,NULL,'重庆市江北区观音桥建新北路76号阳光花园3栋1502',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,'2026-06-17 12:00:00','2026-06-17 11:31:20',NULL,'2026-06-17 11:30:00','2026-06-17 11:31:20','2026-06-17 11:40:00','2026-06-17 12:15:00','2026-06-18 08:30:00',0,NULL,NULL,3.24,0.0500,'尾部商家',0.00,1.62),(81,'202606181600020031',1012,2001,7,71.80,66.80,5.00,2,0.00,0.00,0.00,0.00,NULL,4,'IK_1012_20260618160001',0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,5005,NULL,5.00,0.00,0.00,NULL,NULL,NULL,1,'2026-06-18 16:30:00','2026-06-18 16:01:40',NULL,'2026-06-18 16:00:00','2026-06-18 16:01:40','2026-06-18 16:08:00','2026-06-18 16:45:00','2026-06-19 09:00:00',0,'637451',NULL,3.34,0.0500,'尾部商家',0.00,1.67),(82,'202606201015010032',1010,2006,NULL,84.90,89.90,0.00,1,5.00,0.00,0.00,0.00,NULL,4,'IK_1010_20260620101501',0,0,102,'赵一','17782222107',NULL,NULL,NULL,NULL,NULL,'重庆市渝北区冉家坝龙湖水晶郦城2栋1001',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,'2026-06-20 10:45:00','2026-06-20 10:17:00',NULL,'2026-06-20 10:15:00','2026-06-20 10:17:00','2026-06-20 10:25:00','2026-06-20 10:55:00','2026-06-21 08:30:00',0,NULL,NULL,4.50,0.0500,'尾部商家',0.00,2.25),(83,'202606211445010033',1013,2004,NULL,44.00,49.00,0.00,1,5.00,0.00,0.00,0.00,NULL,4,'IK_1013_20260621144501',0,0,105,'吴小丽','17782222110',NULL,NULL,NULL,NULL,NULL,'重庆市大渡口区九宫庙湖榕路锦天康都1栋1204',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,'2026-06-21 15:15:00','2026-06-21 14:46:30',NULL,'2026-06-21 14:45:00','2026-06-21 14:46:30','2026-06-21 14:55:00','2026-06-21 15:30:00','2026-06-22 09:00:00',0,NULL,NULL,3.92,0.0800,'腰部商家',0.00,1.96),(84,'202606221000020034',1010,2002,8,55.80,55.80,0.00,2,0.00,0.00,0.00,0.00,NULL,4,'IK_1010_20260622100001',0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,'2026-06-22 10:30:00','2026-06-22 10:01:50',NULL,'2026-06-22 10:00:00','2026-06-22 10:01:50','2026-06-22 10:08:00','2026-06-22 10:40:00','2026-06-23 08:00:00',0,'245168',NULL,2.79,0.0500,'尾部商家',0.00,1.40),(85,'202606230930010035',1007,2005,NULL,54.80,54.80,5.00,1,5.00,0.00,0.00,0.00,NULL,4,'IK_1007_20260623093001',0,0,107,'陈二','17782222112',NULL,NULL,NULL,NULL,NULL,'重庆市渝北区龙溪街道武陵路锦江郦城9栋1601',5006,NULL,5.00,0.00,0.00,NULL,NULL,NULL,1,'2026-06-23 10:00:00','2026-06-23 09:31:40',NULL,'2026-06-23 09:30:00','2026-06-23 09:31:40','2026-06-23 09:40:00','2026-06-23 10:15:00','2026-06-24 09:00:00',0,NULL,NULL,2.74,0.0500,'尾部商家',0.00,1.37),(86,'202606241720020036',1019,2003,9,118.00,113.00,5.00,2,0.00,0.00,0.00,0.00,NULL,4,'IK_1019_20260624172001',0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,5007,NULL,5.00,0.00,0.00,NULL,NULL,NULL,1,'2026-06-24 17:50:00','2026-06-24 17:21:30',NULL,'2026-06-24 17:20:00','2026-06-24 17:21:30','2026-06-24 17:28:00','2026-06-24 18:05:00','2026-06-25 09:30:00',0,'419387',NULL,9.04,0.0800,'腰部商家',0.00,4.52),(87,'202606261100010037',1004,2004,NULL,68.00,73.00,0.00,1,5.00,0.00,0.00,0.00,NULL,5,'IK_1004_20260626110001',0,0,101,'赵六','17782222104',NULL,NULL,NULL,NULL,NULL,'重庆市江北区观音桥建新北路76号阳光花园3栋1502',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,'2026-06-26 11:30:00','2026-06-26 11:02:00',NULL,'2026-06-26 11:00:00','2026-06-26 11:12:00','2026-06-26 11:06:00','2026-06-26 11:20:00','2026-06-26 11:20:00',0,NULL,NULL,0.00,0.0000,'',0.00,0.00),(88,'202606271530020038',1020,2002,8,49.80,49.80,0.00,2,0.00,0.00,0.00,0.00,NULL,4,'IK_1020_20260627153001',0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,'2026-06-27 16:00:00','2026-06-27 15:31:20',NULL,'2026-06-27 15:30:00','2026-06-27 15:31:20','2026-06-27 15:38:00','2026-06-27 16:10:00','2026-06-28 09:00:00',0,'706842',NULL,2.49,0.0500,'尾部商家',0.00,1.25),(89,'202606291005010039',1008,2001,NULL,103.00,108.00,0.00,1,5.00,0.00,0.00,0.00,NULL,4,'IK_1008_20260629100501',0,0,106,'王一','17782222111',NULL,NULL,NULL,NULL,NULL,'重庆市巴南区鱼洞巴南印象6栋808',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,'2026-06-29 10:35:00','2026-06-29 10:06:30',NULL,'2026-06-29 10:05:00','2026-06-29 10:06:30','2026-06-29 10:15:00','2026-06-29 10:50:00','2026-06-30 08:30:00',0,NULL,NULL,5.40,0.0500,'尾部商家',0.00,2.70),(90,'202606301340010040',1011,2006,NULL,42.90,47.90,0.00,1,5.00,0.00,0.00,0.00,NULL,3,'IK_1011_20260630134001',0,0,103,'孙小红','17782222108',NULL,NULL,NULL,NULL,NULL,'重庆市南岸区南坪上海城19栋705',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,'2026-06-30 14:10:00','2026-06-30 13:41:20',NULL,'2026-06-30 13:40:00','2026-06-30 13:41:20','2026-06-30 13:48:00','2026-06-30 14:05:00','2026-06-30 14:25:00',0,NULL,NULL,2.40,0.0500,'尾部商家',0.00,1.20),(91,'202607010920010041',1009,2005,NULL,56.70,61.70,0.00,1,5.00,0.00,0.00,0.00,NULL,2,'IK_1009_20260701092001',0,0,108,'李二','17782222113',NULL,NULL,NULL,NULL,NULL,'重庆市江北区五里店融景城郎峰11栋505',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,'2026-07-01 09:50:00','2026-07-01 09:22:00',NULL,'2026-07-01 09:20:00','2026-07-01 09:22:00','2026-07-01 09:28:00','2026-07-01 09:45:00',NULL,0,NULL,NULL,3.09,0.0500,'尾部商家',0.00,1.54),(92,'202607021115020042',1010,2003,9,121.90,121.90,0.00,2,0.00,0.00,0.00,0.00,NULL,1,'IK_1010_20260702111501',0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,'2026-07-02 11:45:00','2026-07-02 11:16:30',NULL,'2026-07-02 11:15:00','2026-07-02 11:16:30',NULL,NULL,NULL,0,'583029',NULL,0.00,0.0000,'',0.00,0.00),(93,'202607021430010043',1013,2006,NULL,68.70,73.70,0.00,1,5.00,0.00,0.00,0.00,NULL,5,'IK_1013_20260702143001',400,3,105,'吴小丽','17782222110',NULL,NULL,NULL,NULL,NULL,'重庆市大渡口区九宫庙湖榕路锦天康都1栋1204',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,'2026-07-02 15:00:00',NULL,'2026-07-04 03:32:45','2026-07-02 14:30:00','2026-07-04 03:32:45',NULL,NULL,NULL,0,NULL,NULL,0.00,0.0000,'',0.00,0.00),(94,'202607031000010044',1007,2004,NULL,90.00,95.00,0.00,1,5.00,0.00,0.00,0.00,NULL,1,'IK_1007_20260703100001',0,0,107,'陈二','17782222112',NULL,NULL,NULL,NULL,NULL,'重庆市渝北区龙溪街道武陵路锦江郦城9栋1601',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,'2026-07-03 10:30:00','2026-07-03 10:02:00',NULL,'2026-07-03 10:00:00','2026-07-03 10:02:00',NULL,NULL,NULL,0,NULL,NULL,0.00,0.0000,'',0.00,0.00),(95,'202607031645020045',1021,2001,7,45.80,45.80,0.00,2,0.00,0.00,0.00,0.00,NULL,5,'IK_1021_20260703164501',0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,'2026-07-03 17:15:00',NULL,'2026-07-04 03:32:45','2026-07-03 16:45:00','2026-07-04 03:32:45',NULL,NULL,NULL,0,'921056',NULL,0.00,0.0000,'',0.00,0.00),(96,'202607040930010046',1008,2002,NULL,59.90,64.90,0.00,1,5.00,0.00,0.00,0.00,NULL,2,'IK_1008_20260704093001',0,0,106,'王一','17782222111',NULL,NULL,NULL,NULL,NULL,'重庆市巴南区鱼洞巴南印象6栋808',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,'2026-07-04 10:00:00','2026-07-04 09:31:50',NULL,'2026-07-04 09:30:00','2026-07-04 09:31:50','2026-07-04 09:36:00','2026-07-04 09:50:00',NULL,0,NULL,NULL,3.25,0.0500,'尾部商家',0.00,1.62),(97,'202607051100010047',1012,2005,NULL,66.70,71.70,0.00,1,5.00,0.00,0.00,0.00,NULL,5,'IK_1012_20260705110001',0,0,104,'周小明','17782222109',NULL,NULL,NULL,NULL,NULL,'重庆市九龙坡区谢家湾华润24城5栋2203',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,'2026-07-05 11:30:00',NULL,'2026-07-06 10:48:37','2026-07-05 11:00:00','2026-07-06 10:48:37',NULL,NULL,NULL,0,NULL,NULL,0.00,0.0000,'',0.00,0.00),(98,'2026070241347551',1017,2003,NULL,14.80,14.80,0.00,1,5.00,0.00,0.00,0.00,NULL,5,'IK_1017_2026070241347551',0,0,NULL,'李四','13800001102','北京市','北京市','朝阳区','望京街道阜通东大街6号院3号楼1802',NULL,'北京市北京市朝阳区望京街道阜通东大街6号院3号楼1802',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-02 17:50:35','2026-07-02 17:08:35',NULL,'2026-07-02 17:17:35',NULL,NULL,0,NULL,NULL,0.00,0.0000,'',0.00,0.00),(100,'2026060298990796',1009,2003,NULL,122.60,122.60,0.00,1,5.00,0.00,0.00,0.00,NULL,4,'IK_1009_2026060298990796',0,0,NULL,'冯十一','13800001109','湖南省','长沙市','岳麓区','麓谷大道658号麓谷信息港B座1502',NULL,'湖南省长沙市岳麓区麓谷大道658号麓谷信息港B座1502',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,NULL,'2026-06-02 19:34:36',NULL,'2026-06-02 19:25:36',NULL,'2026-06-02 19:34:36','2026-06-02 20:14:36','2026-06-02 20:57:36',0,NULL,NULL,9.81,0.0800,'腰部商家',0.00,4.90),(201,'2026070241347551',1017,2003,NULL,14.80,14.80,0.00,1,5.00,0.00,0.00,0.00,NULL,5,'IK_1017_2026070241347551',0,0,NULL,'李四','13800001102','北京市','北京市','朝阳区','望京街道阜通东大街6号院3号楼1802',NULL,'北京市北京市朝阳区望京街道阜通东大街6号院3号楼1802',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-02 17:50:35','2026-07-02 17:08:35',NULL,'2026-07-02 17:17:35',NULL,NULL,0,NULL,NULL,0.00,0.0000,'',0.00,0.00),(202,'2026053076870731',1010,2003,7,100.90,100.90,10.00,2,0.00,0.00,0.00,0.00,NULL,4,'IK_1010_2026053076870731',0,0,NULL,'黄女士','13900010002',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,NULL,'2026-05-30 17:35:42',NULL,'2026-05-30 17:30:42',NULL,'2026-05-30 17:43:42','2026-05-30 18:29:42','2026-05-30 19:22:42',0,'192111',NULL,8.07,0.0800,'腰部商家',10.00,4.04),(203,'2026060298990796',1009,2003,NULL,122.60,122.60,0.00,1,5.00,0.00,0.00,0.00,NULL,4,'IK_1009_2026060298990796',0,0,NULL,'冯十一','13800001109','湖南省','长沙市','岳麓区','麓谷大道658号麓谷信息港B座1502',NULL,'湖南省长沙市岳麓区麓谷大道658号麓谷信息港B座1502',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,NULL,'2026-06-02 19:34:36',NULL,'2026-06-02 19:25:36',NULL,'2026-06-02 19:34:36','2026-06-02 20:14:36','2026-06-02 20:57:36',0,NULL,NULL,9.81,0.0800,'腰部商家',0.00,4.90),(204,'2026062650907231',1008,2003,9,93.70,93.70,0.00,2,0.00,0.00,0.00,0.00,NULL,5,'IK_1008_2026062650907231',0,0,NULL,'黄女士','13900010002',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,'2026-06-26 12:42:07','2026-06-26 12:00:07',NULL,'2026-06-26 12:24:07',NULL,NULL,0,'156667',NULL,0.00,0.0000,'',0.00,0.00),(205,'2026060293828623',1025,2003,NULL,187.60,187.60,0.00,1,5.00,0.00,0.00,0.00,NULL,5,'IK_1025_2026060293828623',0,0,NULL,'陈十二','13800001110','陕西省','西安市','雁塔区','科技二路72号天泽大厦901',NULL,'陕西省西安市雁塔区科技二路72号天泽大厦901',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,'2026-06-02 18:23:24','2026-06-02 17:37:24',NULL,'2026-06-02 17:53:24',NULL,NULL,0,NULL,NULL,0.00,0.0000,'',0.00,0.00),(206,'2026052757830589',1017,2003,NULL,279.90,279.90,0.00,1,5.00,0.00,0.00,0.00,NULL,5,'IK_1017_2026052757830589',0,0,NULL,'陈十二','13800001110','陕西省','西安市','雁塔区','科技二路72号天泽大厦901',NULL,'陕西省西安市雁塔区科技二路72号天泽大厦901',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,'2026-05-27 13:59:47','2026-05-27 13:43:47',NULL,'2026-05-27 14:12:47',NULL,NULL,0,NULL,NULL,0.00,0.0000,'',0.00,0.00),(207,'2026053171265235',1018,2003,9,198.00,198.00,0.00,2,0.00,0.00,0.00,0.00,NULL,4,'IK_1018_2026053171265235',0,0,NULL,'杨女士','13900010004',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,NULL,'2026-05-31 14:17:16',NULL,'2026-05-31 14:16:16',NULL,'2026-05-31 14:40:16','2026-05-31 15:09:16','2026-05-31 15:48:16',0,'895389',NULL,15.84,0.0800,'腰部商家',0.00,7.92),(208,'2026070454113613',1024,2003,8,122.90,122.90,0.00,2,0.00,0.00,0.00,0.00,NULL,2,'IK_1024_2026070454113613',0,0,NULL,'林先生','13900010003',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-04 16:23:10',NULL,'2026-07-04 16:31:10',NULL,NULL,0,'234802',NULL,9.83,0.0800,'腰部商家',0.00,4.92),(209,'2026070666586659',1007,2003,9,69.70,69.70,0.00,2,0.00,0.00,0.00,0.00,NULL,1,'IK_1007_2026070666586659',0,0,NULL,'杨女士','13900010004',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-06 18:14:25',NULL,NULL,NULL,NULL,0,'852670',NULL,0.00,0.0000,'',0.00,0.00),(210,'2026050821264682',1011,2003,NULL,91.70,91.70,0.00,1,5.00,0.00,0.00,0.00,NULL,4,'IK_1011_2026050821264682',0,0,NULL,'郑十','13800001108','广东省','广州市','天河区','体育西路111号建和中心12层',NULL,'广东省广州市天河区体育西路111号建和中心12层',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,NULL,'2026-05-08 17:54:47',NULL,'2026-05-08 17:53:47',NULL,'2026-05-08 17:57:47','2026-05-08 18:17:47','2026-05-08 19:51:47',0,NULL,NULL,7.34,0.0800,'腰部商家',0.00,3.67),(211,'2026061874700746',1014,2003,7,197.80,197.80,10.00,2,0.00,0.00,0.00,0.00,NULL,4,'IK_1014_2026061874700746',0,0,NULL,'林先生','13900010003',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,NULL,'2026-06-18 08:57:46',NULL,'2026-06-18 08:51:46',NULL,'2026-06-18 09:00:46','2026-06-18 09:45:46','2026-06-18 09:38:46',0,'619586',NULL,15.82,0.0800,'腰部商家',10.00,7.91),(212,'2026070771087490',1024,2003,NULL,124.80,124.80,0.00,1,5.00,0.00,0.00,0.00,NULL,3,'IK_1024_2026070771087490',0,0,NULL,'赵六','13800001104','浙江省','杭州市','西湖区','文三路478号华星时代广场A座2201',NULL,'浙江省杭州市西湖区文三路478号华星时代广场A座2201',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,NULL,'2026-07-07 12:40:21',NULL,'2026-07-07 12:36:21',NULL,'2026-07-07 12:42:21','2026-07-07 13:01:21',NULL,0,NULL,NULL,9.98,0.0800,'腰部商家',0.00,4.99),(213,'2026060696937569',1016,2003,9,67.60,67.60,0.00,2,0.00,0.00,0.00,0.00,NULL,5,'IK_1016_2026060696937569',0,0,NULL,'林先生','13900010003',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,'2026-06-06 13:45:19','2026-06-06 13:04:19',NULL,'2026-06-06 13:31:19',NULL,NULL,0,'694725',NULL,0.00,0.0000,'',0.00,0.00),(214,'2026062176526111',1013,2003,NULL,228.80,228.80,0.00,1,5.00,0.00,0.00,0.00,NULL,3,'IK_1013_2026062176526111',0,0,NULL,'赵六','13800001104','浙江省','杭州市','西湖区','文三路478号华星时代广场A座2201',NULL,'浙江省杭州市西湖区文三路478号华星时代广场A座2201',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,NULL,'2026-06-21 20:26:59',NULL,'2026-06-21 20:22:59',NULL,'2026-06-21 20:47:59','2026-06-21 21:04:59',NULL,0,NULL,NULL,18.30,0.0800,'腰部商家',0.00,9.15),(215,'2026070488833267',1017,2003,9,191.80,191.80,0.00,2,0.00,0.00,0.00,0.00,NULL,2,'IK_1017_2026070488833267',0,0,NULL,'林先生','13900010003',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-04 12:06:17',NULL,'2026-07-04 12:14:17',NULL,NULL,0,'463619',NULL,15.34,0.0800,'腰部商家',0.00,7.67),(216,'2026062786321619',1009,2003,NULL,285.80,285.80,0.00,1,5.00,0.00,0.00,0.00,NULL,3,'IK_1009_2026062786321619',0,0,NULL,'陈十二','13800001110','陕西省','西安市','雁塔区','科技二路72号天泽大厦901',NULL,'陕西省西安市雁塔区科技二路72号天泽大厦901',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,NULL,'2026-06-27 13:30:20',NULL,'2026-06-27 13:20:20',NULL,'2026-06-27 13:48:20','2026-06-27 13:41:20',NULL,0,NULL,NULL,22.86,0.0800,'腰部商家',0.00,11.43),(217,'2026051720240498',1023,2003,7,145.60,145.60,0.00,2,0.00,0.00,0.00,0.00,NULL,5,'IK_1023_2026051720240498',0,0,NULL,'黄女士','13900010002',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,'2026-05-17 20:52:46','2026-05-17 20:27:46',NULL,'2026-05-17 20:38:46',NULL,NULL,0,'955197',NULL,0.00,0.0000,'',0.00,0.00),(218,'2026062216390281',1012,2003,NULL,13.90,13.90,0.00,1,5.00,0.00,0.00,0.00,NULL,3,'IK_1012_2026062216390281',0,0,NULL,'周八','13800001106','四川省','成都市','武侯区','天府大道北段1700号环球中心E2-801',NULL,'四川省成都市武侯区天府大道北段1700号环球中心E2-801',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,NULL,'2026-06-22 14:38:57',NULL,'2026-06-22 14:35:57',NULL,'2026-06-22 14:57:57','2026-06-22 15:19:57',NULL,0,NULL,NULL,1.11,0.0800,'腰部商家',0.00,0.56),(219,'2026053123156047',1023,2003,NULL,49.70,49.70,0.00,1,5.00,0.00,0.00,0.00,NULL,4,'IK_1023_2026053123156047',0,0,NULL,'孙七','13800001105','江苏省','南京市','鼓楼区','中山北路28号江苏商厦15层1503',NULL,'江苏省南京市鼓楼区中山北路28号江苏商厦15层1503',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,NULL,'2026-05-31 18:38:13',NULL,'2026-05-31 18:35:13',NULL,'2026-05-31 18:53:13','2026-05-31 19:15:13','2026-05-31 20:06:13',0,NULL,NULL,3.98,0.0800,'腰部商家',0.00,1.99),(220,'2026062729856954',1016,2003,NULL,212.80,212.80,0.00,1,5.00,0.00,0.00,0.00,NULL,2,'IK_1016_2026062729856954',0,0,NULL,'冯十一','13800001109','湖南省','长沙市','岳麓区','麓谷大道658号麓谷信息港B座1502',NULL,'湖南省长沙市岳麓区麓谷大道658号麓谷信息港B座1502',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-06-27 18:09:49',NULL,'2026-06-27 18:31:49',NULL,NULL,0,NULL,NULL,17.02,0.0800,'腰部商家',0.00,8.51),(221,'2026061950964733',1009,2003,8,12.90,12.90,0.00,2,0.00,0.00,0.00,0.00,NULL,3,'IK_1009_2026061950964733',0,0,NULL,'黄女士','13900010002',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,NULL,'2026-06-19 21:01:56',NULL,'2026-06-19 20:54:56',NULL,'2026-06-19 21:12:56','2026-06-19 21:09:56',NULL,0,'627952',NULL,1.03,0.0800,'腰部商家',0.00,0.52),(222,'2026070389967594',1024,2003,9,93.70,93.70,0.00,2,0.00,0.00,0.00,0.00,NULL,3,'IK_1024_2026070389967594',0,0,NULL,'杨女士','13900010004',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,NULL,'2026-07-03 19:24:51',NULL,'2026-07-03 19:17:51',NULL,'2026-07-03 19:25:51','2026-07-03 19:38:51',NULL,0,'670862',NULL,7.50,0.0800,'腰部商家',0.00,3.75),(223,'2026070194524493',1017,2003,NULL,41.90,41.90,0.00,1,5.00,0.00,0.00,0.00,NULL,3,'IK_1017_2026070194524493',0,0,NULL,'张三','13800001101','广东省','深圳市','南山区','科技园路88号创新大厦A座1203',NULL,'广东省深圳市南山区科技园路88号创新大厦A座1203',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,NULL,'2026-07-01 16:13:48',NULL,'2026-07-01 16:06:48',NULL,'2026-07-01 16:20:48','2026-07-01 16:37:48',NULL,0,NULL,NULL,3.35,0.0800,'腰部商家',0.00,1.68),(224,'2026070516189132',1007,2003,NULL,32.60,32.60,0.00,1,5.00,0.00,0.00,0.00,NULL,1,'IK_1007_2026070516189132',0,0,NULL,'陈十二','13800001110','陕西省','西安市','雁塔区','科技二路72号天泽大厦901',NULL,'陕西省西安市雁塔区科技二路72号天泽大厦901',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-05 12:20:31',NULL,NULL,NULL,NULL,0,NULL,NULL,0.00,0.0000,'',0.00,0.00),(225,'2026062878674008',1012,2003,7,283.00,283.00,0.00,2,0.00,0.00,0.00,0.00,NULL,3,'IK_1012_2026062878674008',0,0,NULL,'黄女士','13900010002',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,NULL,'2026-06-28 12:31:53',NULL,'2026-06-28 12:22:53',NULL,'2026-06-28 12:41:53','2026-06-28 12:39:53',NULL,0,'893860',NULL,22.64,0.0800,'腰部商家',0.00,11.32),(226,'2026061883299021',1016,2003,NULL,454.90,454.90,0.00,1,5.00,0.00,0.00,0.00,NULL,5,'IK_1016_2026061883299021',0,0,NULL,'赵六','13800001104','浙江省','杭州市','西湖区','文三路478号华星时代广场A座2201',NULL,'浙江省杭州市西湖区文三路478号华星时代广场A座2201',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,'2026-06-18 14:14:32','2026-06-18 13:48:32',NULL,'2026-06-18 14:08:32',NULL,NULL,0,NULL,NULL,0.00,0.0000,'',0.00,0.00),(227,'2026070518083750',1020,2003,NULL,300.90,300.90,0.00,1,5.00,0.00,0.00,0.00,NULL,1,'IK_1020_2026070518083750',0,0,NULL,'冯十一','13800001109','湖南省','长沙市','岳麓区','麓谷大道658号麓谷信息港B座1502',NULL,'湖南省长沙市岳麓区麓谷大道658号麓谷信息港B座1502',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-05 17:04:18',NULL,NULL,NULL,NULL,0,NULL,NULL,0.00,0.0000,'',0.00,0.00),(228,'2026062782692549',1021,2003,8,196.00,196.00,0.00,2,0.00,0.00,0.00,0.00,NULL,3,'IK_1021_2026062782692549',0,0,NULL,'刘先生','13900010001',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,NULL,'2026-06-27 13:44:41',NULL,'2026-06-27 13:38:41',NULL,'2026-06-27 14:07:41','2026-06-27 14:27:41',NULL,0,'466382',NULL,15.68,0.0800,'腰部商家',0.00,7.84),(229,'2026070273951182',1024,2003,NULL,354.50,354.50,0.00,1,5.00,0.00,0.00,0.00,NULL,1,'IK_1024_2026070273951182',0,0,NULL,'李四','13800001102','北京市','北京市','朝阳区','望京街道阜通东大街6号院3号楼1802',NULL,'北京市北京市朝阳区望京街道阜通东大街6号院3号楼1802',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-02 09:30:46',NULL,NULL,NULL,NULL,0,NULL,NULL,0.00,0.0000,'',0.00,0.00),(230,'2026063056664556',1014,2003,8,258.90,258.90,0.00,2,0.00,0.00,0.00,0.00,NULL,5,'IK_1014_2026063056664556',0,0,NULL,'杨女士','13900010004',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,'2026-06-30 17:40:25','2026-06-30 17:28:25',NULL,'2026-06-30 17:34:25',NULL,NULL,0,'530908',NULL,0.00,0.0000,'',0.00,0.00),(231,'2026063080420241',1013,2003,7,221.70,221.70,25.00,2,0.00,0.00,0.00,0.00,NULL,4,'IK_1013_2026063080420241',0,0,NULL,'刘先生','13900010001',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,NULL,'2026-06-30 19:20:00',NULL,'2026-06-30 19:13:00',NULL,'2026-06-30 19:18:00','2026-06-30 20:06:00','2026-06-30 20:15:00',0,'603426',NULL,17.74,0.0800,'腰部商家',25.00,8.87),(232,'2026070330908412',1022,2003,NULL,198.50,198.50,0.00,1,5.00,0.00,0.00,0.00,NULL,3,'IK_1022_2026070330908412',0,0,NULL,'周八','13800001106','四川省','成都市','武侯区','天府大道北段1700号环球中心E2-801',NULL,'四川省成都市武侯区天府大道北段1700号环球中心E2-801',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,NULL,'2026-07-03 11:56:08',NULL,'2026-07-03 11:55:08',NULL,'2026-07-03 12:01:08','2026-07-03 12:31:08',NULL,0,NULL,NULL,15.88,0.0800,'腰部商家',0.00,7.94),(233,'2026062652316931',1010,2003,8,131.60,131.60,0.00,2,0.00,0.00,0.00,0.00,NULL,5,'IK_1010_2026062652316931',0,0,NULL,'黄女士','13900010002',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,'2026-06-26 13:17:48','2026-06-26 12:33:48',NULL,'2026-06-26 12:50:48',NULL,NULL,0,'832030',NULL,0.00,0.0000,'',0.00,0.00),(234,'2026060980645408',1025,2003,NULL,271.00,271.00,0.00,1,5.00,0.00,0.00,0.00,NULL,4,'IK_1025_2026060980645408',0,0,NULL,'陈十二','13800001110','陕西省','西安市','雁塔区','科技二路72号天泽大厦901',NULL,'陕西省西安市雁塔区科技二路72号天泽大厦901',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,NULL,'2026-06-09 11:34:05',NULL,'2026-06-09 11:32:05',NULL,'2026-06-09 11:34:05','2026-06-09 12:13:05','2026-06-09 12:13:05',0,NULL,NULL,21.68,0.0800,'腰部商家',0.00,10.84),(235,'2026070330930329',1023,2003,9,11729.70,11729.70,0.00,2,0.00,0.00,0.00,0.00,NULL,3,'IK_1023_2026070330930329',0,0,NULL,'林先生','13900010003',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,NULL,'2026-07-03 09:27:47',NULL,'2026-07-03 09:22:47',NULL,'2026-07-03 09:24:47','2026-07-03 09:58:47',NULL,0,'906053',NULL,938.38,0.0800,'腰部商家',0.00,80.00),(236,'2026062992475481',1023,2003,7,8.90,8.90,0.00,2,0.00,0.00,0.00,0.00,NULL,4,'IK_1023_2026062992475481',0,0,NULL,'林先生','13900010003',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,NULL,'2026-06-29 20:20:21',NULL,'2026-06-29 20:14:21',NULL,'2026-06-29 20:43:21','2026-06-29 21:02:21','2026-06-29 21:18:21',0,'772178',NULL,0.71,0.0800,'腰部商家',0.00,0.36),(237,'2026063041127852',1014,2003,8,128.00,128.00,0.00,2,0.00,0.00,0.00,0.00,NULL,3,'IK_1014_2026063041127852',0,0,NULL,'杨女士','13900010004',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,NULL,'2026-06-30 14:18:37',NULL,'2026-06-30 14:17:37',NULL,'2026-06-30 14:37:37','2026-06-30 14:53:37',NULL,0,'839849',NULL,10.24,0.0800,'腰部商家',0.00,5.12),(238,'2026062914712339',1018,2004,NULL,141.00,141.00,0.00,1,5.00,0.00,0.00,0.00,NULL,4,'IK_1018_2026062914712339',0,0,NULL,'郑十','13800001108','广东省','广州市','天河区','体育西路111号建和中心12层',NULL,'广东省广州市天河区体育西路111号建和中心12层',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,NULL,'2026-06-29 11:17:34',NULL,'2026-06-29 11:16:34',NULL,'2026-06-29 11:27:34','2026-06-29 11:45:34','2026-06-29 13:06:34',0,NULL,NULL,11.28,0.0800,'腰部商家',0.00,5.64),(239,'2026061448865507',1017,2004,NULL,78.90,78.90,0.00,1,5.00,0.00,0.00,0.00,NULL,4,'IK_1017_2026061448865507',0,0,NULL,'赵六','13800001104','浙江省','杭州市','西湖区','文三路478号华星时代广场A座2201',NULL,'浙江省杭州市西湖区文三路478号华星时代广场A座2201',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,NULL,'2026-06-14 16:28:01',NULL,'2026-06-14 16:19:01',NULL,'2026-06-14 16:23:01','2026-06-14 16:41:01','2026-06-14 17:46:01',0,NULL,NULL,6.31,0.0800,'腰部商家',0.00,3.16),(240,'2026070185439757',1024,2004,NULL,169.00,169.00,0.00,1,5.00,0.00,0.00,0.00,NULL,2,'IK_1024_2026070185439757',0,0,NULL,'冯十一','13800001109','湖南省','长沙市','岳麓区','麓谷大道658号麓谷信息港B座1502',NULL,'湖南省长沙市岳麓区麓谷大道658号麓谷信息港B座1502',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-01 21:37:30',NULL,'2026-07-01 21:48:30',NULL,NULL,0,NULL,NULL,13.52,0.0800,'腰部商家',0.00,6.76),(241,'2026070216269198',1010,2004,8,792.00,792.00,0.00,2,0.00,0.00,0.00,0.00,NULL,5,'IK_1010_2026070216269198',0,0,NULL,'杨女士','13900010004',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-02 11:19:53','2026-07-02 10:54:53',NULL,'2026-07-02 11:03:53',NULL,NULL,0,'776675',NULL,0.00,0.0000,'',0.00,0.00),(242,'2026051332168452',1017,2004,9,68.00,68.00,0.00,2,0.00,0.00,0.00,0.00,NULL,4,'IK_1017_2026051332168452',0,0,NULL,'杨女士','13900010004',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,NULL,'2026-05-13 17:37:11',NULL,'2026-05-13 17:27:11',NULL,'2026-05-13 17:37:11','2026-05-13 18:00:11','2026-05-13 18:20:11',0,'146818',NULL,5.44,0.0800,'腰部商家',0.00,2.72),(243,'2026060693666956',1023,2004,NULL,81.90,81.90,0.00,1,5.00,0.00,0.00,0.00,NULL,4,'IK_1023_2026060693666956',0,0,NULL,'冯十一','13800001109','湖南省','长沙市','岳麓区','麓谷大道658号麓谷信息港B座1502',NULL,'湖南省长沙市岳麓区麓谷大道658号麓谷信息港B座1502',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,NULL,'2026-06-06 14:08:04',NULL,'2026-06-06 14:03:04',NULL,'2026-06-06 14:15:04','2026-06-06 14:29:04','2026-06-06 15:23:04',0,NULL,NULL,6.55,0.0800,'腰部商家',0.00,3.28),(244,'2026061883132940',1021,2004,NULL,17.90,17.90,0.00,1,5.00,0.00,0.00,0.00,NULL,3,'IK_1021_2026061883132940',0,0,NULL,'冯十一','13800001109','湖南省','长沙市','岳麓区','麓谷大道658号麓谷信息港B座1502',NULL,'湖南省长沙市岳麓区麓谷大道658号麓谷信息港B座1502',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,NULL,'2026-06-18 09:16:33',NULL,'2026-06-18 09:09:33',NULL,'2026-06-18 09:16:33','2026-06-18 10:01:33',NULL,0,NULL,NULL,1.43,0.0800,'腰部商家',0.00,0.72),(245,'2026062939877908',1008,2004,9,196.00,196.00,0.00,2,0.00,0.00,0.00,0.00,NULL,5,'IK_1008_2026062939877908',0,0,NULL,'杨女士','13900010004',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,'2026-06-29 20:18:41','2026-06-29 19:28:41',NULL,'2026-06-29 19:40:41',NULL,NULL,0,'820135',NULL,0.00,0.0000,'',0.00,0.00),(246,'2026070467744654',1023,2004,8,119.60,119.60,0.00,2,0.00,0.00,0.00,0.00,NULL,1,'IK_1023_2026070467744654',0,0,NULL,'黄女士','13900010002',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-04 15:39:22',NULL,NULL,NULL,NULL,0,'992385',NULL,0.00,0.0000,'',0.00,0.00),(247,'2026070115208655',1007,2004,NULL,331.80,331.80,0.00,1,5.00,0.00,0.00,0.00,NULL,4,'IK_1007_2026070115208655',0,0,NULL,'赵六','13800001104','浙江省','杭州市','西湖区','文三路478号华星时代广场A座2201',NULL,'浙江省杭州市西湖区文三路478号华星时代广场A座2201',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,NULL,'2026-07-01 15:11:12',NULL,'2026-07-01 15:10:12',NULL,'2026-07-01 15:29:12','2026-07-01 15:39:12','2026-07-01 17:04:12',0,NULL,NULL,26.54,0.0800,'腰部商家',0.00,13.27),(248,'2026070481424031',1012,2004,NULL,73.00,73.00,0.00,1,5.00,0.00,0.00,0.00,NULL,2,'IK_1012_2026070481424031',0,0,NULL,'陈十二','13800001110','陕西省','西安市','雁塔区','科技二路72号天泽大厦901',NULL,'陕西省西安市雁塔区科技二路72号天泽大厦901',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-04 13:07:09',NULL,'2026-07-04 13:26:09',NULL,NULL,0,NULL,NULL,5.84,0.0800,'腰部商家',0.00,2.92),(249,'2026070180172105',1013,2004,NULL,17.90,17.90,0.00,1,5.00,0.00,0.00,0.00,NULL,2,'IK_1013_2026070180172105',0,0,NULL,'吴九','13800001107','湖北省','武汉市','洪山区','珞喻路1037号华中科技大学东校区',NULL,'湖北省武汉市洪山区珞喻路1037号华中科技大学东校区',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-01 12:11:39',NULL,'2026-07-01 12:36:39',NULL,NULL,0,NULL,NULL,1.43,0.0800,'腰部商家',0.00,0.72),(250,'2026062273527967',1010,2004,NULL,147.80,147.80,0.00,1,5.00,0.00,0.00,0.00,NULL,5,'IK_1010_2026062273527967',0,0,NULL,'王五','13800001103','上海市','上海市','浦东新区','张江高科技园区碧波路690号2号楼501',NULL,'上海市上海市浦东新区张江高科技园区碧波路690号2号楼501',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,'2026-06-22 14:22:37','2026-06-22 13:40:37',NULL,'2026-06-22 13:54:37',NULL,NULL,0,NULL,NULL,0.00,0.0000,'',0.00,0.00),(251,'2026062751815408',1009,2004,7,126.90,126.90,0.00,2,0.00,0.00,0.00,0.00,NULL,2,'IK_1009_2026062751815408',0,0,NULL,'刘先生','13900010001',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-06-27 19:37:35',NULL,'2026-06-27 19:57:35',NULL,NULL,0,'830062',NULL,10.15,0.0800,'腰部商家',0.00,5.08),(252,'2026061634183893',1019,2004,NULL,112.70,112.70,0.00,1,5.00,0.00,0.00,0.00,NULL,4,'IK_1019_2026061634183893',0,0,NULL,'吴九','13800001107','湖北省','武汉市','洪山区','珞喻路1037号华中科技大学东校区',NULL,'湖北省武汉市洪山区珞喻路1037号华中科技大学东校区',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,NULL,'2026-06-16 10:31:51',NULL,'2026-06-16 10:24:51',NULL,'2026-06-16 10:54:51','2026-06-16 11:05:51','2026-06-16 12:03:51',0,NULL,NULL,9.02,0.0800,'腰部商家',0.00,4.51),(253,'2026062660168026',1022,2004,NULL,141.00,141.00,0.00,1,5.00,0.00,0.00,0.00,NULL,3,'IK_1022_2026062660168026',0,0,NULL,'赵六','13800001104','浙江省','杭州市','西湖区','文三路478号华星时代广场A座2201',NULL,'浙江省杭州市西湖区文三路478号华星时代广场A座2201',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,NULL,'2026-06-26 18:45:24',NULL,'2026-06-26 18:36:24',NULL,'2026-06-26 18:47:24','2026-06-26 19:12:24',NULL,0,NULL,NULL,11.28,0.0800,'腰部商家',0.00,5.64),(254,'2026052759686800',1016,2004,NULL,59.70,59.70,0.00,1,5.00,0.00,0.00,0.00,NULL,4,'IK_1016_2026052759686800',0,0,NULL,'陈十二','13800001110','陕西省','西安市','雁塔区','科技二路72号天泽大厦901',NULL,'陕西省西安市雁塔区科技二路72号天泽大厦901',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,NULL,'2026-05-27 12:48:25',NULL,'2026-05-27 12:42:25',NULL,'2026-05-27 12:44:25','2026-05-27 13:17:25','2026-05-27 13:59:25',0,NULL,NULL,4.78,0.0800,'腰部商家',0.00,2.39),(255,'2026070444810904',1021,2004,8,58.00,58.00,0.00,2,0.00,0.00,0.00,0.00,NULL,3,'IK_1021_2026070444810904',0,0,NULL,'林先生','13900010003',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,NULL,'2026-07-04 10:44:04',NULL,'2026-07-04 10:39:04',NULL,'2026-07-04 10:53:04','2026-07-04 11:38:04',NULL,0,'734974',NULL,4.64,0.0800,'腰部商家',0.00,2.32),(256,'2026061755393756',1008,2004,8,211.90,211.90,0.00,2,0.00,0.00,0.00,0.00,NULL,4,'IK_1008_2026061755393756',0,0,NULL,'林先生','13900010003',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,NULL,'2026-06-17 13:57:05',NULL,'2026-06-17 13:47:05',NULL,'2026-06-17 14:06:05','2026-06-17 14:44:05','2026-06-17 15:03:05',0,'625562',NULL,16.95,0.0800,'腰部商家',0.00,8.48),(257,'2026052196399347',1009,2004,8,25.80,25.80,0.00,2,0.00,0.00,0.00,0.00,NULL,4,'IK_1009_2026052196399347',0,0,NULL,'杨女士','13900010004',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,NULL,'2026-05-21 11:26:11',NULL,'2026-05-21 11:16:11',NULL,'2026-05-21 11:27:11','2026-05-21 12:03:11','2026-05-21 11:49:11',0,'280280',NULL,2.06,0.0800,'腰部商家',0.00,1.03),(258,'2026070514697766',1018,2004,NULL,12423.00,12423.00,0.00,1,5.00,0.00,0.00,0.00,NULL,2,'IK_1018_2026070514697766',0,0,NULL,'吴九','13800001107','湖北省','武汉市','洪山区','珞喻路1037号华中科技大学东校区',NULL,'湖北省武汉市洪山区珞喻路1037号华中科技大学东校区',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-05 17:22:52',NULL,'2026-07-05 17:50:52',NULL,NULL,0,NULL,NULL,993.84,0.0800,'腰部商家',0.00,80.00),(259,'2026062810723518',1007,2004,9,172.60,172.60,0.00,2,0.00,0.00,0.00,0.00,NULL,3,'IK_1007_2026062810723518',0,0,NULL,'刘先生','13900010001',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,NULL,'2026-06-28 19:04:17',NULL,'2026-06-28 18:54:17',NULL,'2026-06-28 19:13:17','2026-06-28 19:41:17',NULL,0,'180666',NULL,13.81,0.0800,'腰部商家',0.00,6.90),(260,'2026062584688977',1009,2004,8,130.60,130.60,0.00,2,0.00,0.00,0.00,0.00,NULL,3,'IK_1009_2026062584688977',0,0,NULL,'杨女士','13900010004',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,NULL,'2026-06-25 08:57:30',NULL,'2026-06-25 08:50:30',NULL,'2026-06-25 09:18:30','2026-06-25 09:41:30',NULL,0,'677239',NULL,10.45,0.0800,'腰部商家',0.00,5.22),(261,'2026062510863707',1008,2004,NULL,101.00,101.00,0.00,1,5.00,0.00,0.00,0.00,NULL,5,'IK_1008_2026062510863707',0,0,NULL,'赵六','13800001104','浙江省','杭州市','西湖区','文三路478号华星时代广场A座2201',NULL,'浙江省杭州市西湖区文三路478号华星时代广场A座2201',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,'2026-06-25 09:07:40','2026-06-25 08:22:40',NULL,'2026-06-25 08:46:40',NULL,NULL,0,NULL,NULL,0.00,0.0000,'',0.00,0.00),(262,'2026070591420196',1025,2004,NULL,188.70,188.70,0.00,1,5.00,0.00,0.00,0.00,NULL,1,'IK_1025_2026070591420196',0,0,NULL,'赵六','13800001104','浙江省','杭州市','西湖区','文三路478号华星时代广场A座2201',NULL,'浙江省杭州市西湖区文三路478号华星时代广场A座2201',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-05 14:46:03',NULL,NULL,NULL,NULL,0,NULL,NULL,0.00,0.0000,'',0.00,0.00),(263,'2026051985672258',1019,2004,NULL,59.80,59.80,0.00,1,5.00,0.00,0.00,0.00,NULL,4,'IK_1019_2026051985672258',0,0,NULL,'张三','13800001101','广东省','深圳市','南山区','科技园路88号创新大厦A座1203',NULL,'广东省深圳市南山区科技园路88号创新大厦A座1203',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,NULL,'2026-05-19 17:14:46',NULL,'2026-05-19 17:07:46',NULL,'2026-05-19 17:28:46','2026-05-19 18:06:46','2026-05-19 17:41:46',0,NULL,NULL,4.78,0.0800,'腰部商家',0.00,2.39),(264,'2026070470488737',1010,2004,NULL,230.90,230.90,0.00,1,5.00,0.00,0.00,0.00,NULL,5,'IK_1010_2026070470488737',0,0,NULL,'张三','13800001101','广东省','深圳市','南山区','科技园路88号创新大厦A座1203',NULL,'广东省深圳市南山区科技园路88号创新大厦A座1203',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-04 19:14:36','2026-07-04 18:56:36',NULL,'2026-07-04 19:10:36',NULL,NULL,0,NULL,NULL,0.00,0.0000,'',0.00,0.00),(265,'2026052177076787',1022,2004,9,159.80,159.80,10.00,2,0.00,0.00,0.00,0.00,NULL,4,'IK_1022_2026052177076787',0,0,NULL,'刘先生','13900010001',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,NULL,'2026-05-21 09:41:17',NULL,'2026-05-21 09:31:17',NULL,'2026-05-21 09:42:17','2026-05-21 10:14:17','2026-05-21 11:11:17',0,'235349',NULL,12.78,0.0800,'腰部商家',10.00,6.39),(266,'2026070543190991',1007,2004,NULL,429.90,429.90,0.00,1,5.00,0.00,0.00,0.00,NULL,1,'IK_1007_2026070543190991',0,0,NULL,'周八','13800001106','四川省','成都市','武侯区','天府大道北段1700号环球中心E2-801',NULL,'四川省成都市武侯区天府大道北段1700号环球中心E2-801',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-05 21:52:36',NULL,NULL,NULL,NULL,0,NULL,NULL,0.00,0.0000,'',0.00,0.00),(267,'2026070527423935',1025,2004,8,101.80,101.80,0.00,2,0.00,0.00,0.00,0.00,NULL,4,'IK_1025_2026070527423935',0,0,NULL,'杨女士','13900010004',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,NULL,'2026-07-05 14:16:11',NULL,'2026-07-05 14:13:11',NULL,'2026-07-05 14:27:11','2026-07-05 14:54:11','2026-07-05 16:00:11',0,'464144',NULL,8.14,0.0800,'腰部商家',0.00,4.07),(268,'2026060667737142',1011,2004,NULL,305.90,305.90,45.00,1,5.00,0.00,0.00,0.00,NULL,4,'IK_1011_2026060667737142',0,0,NULL,'吴九','13800001107','湖北省','武汉市','洪山区','珞喻路1037号华中科技大学东校区',NULL,'湖北省武汉市洪山区珞喻路1037号华中科技大学东校区',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,NULL,'2026-06-06 21:04:52',NULL,'2026-06-06 21:00:52',NULL,'2026-06-06 21:15:52','2026-06-06 21:55:52','2026-06-06 22:05:52',0,NULL,NULL,24.47,0.0800,'腰部商家',45.00,12.24),(269,'2026070336984580',1013,2004,NULL,379.70,379.70,0.00,1,5.00,0.00,0.00,0.00,NULL,5,'IK_1013_2026070336984580',0,0,NULL,'李四','13800001102','北京市','北京市','朝阳区','望京街道阜通东大街6号院3号楼1802',NULL,'北京市北京市朝阳区望京街道阜通东大街6号院3号楼1802',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-03 13:39:52','2026-07-03 12:46:52',NULL,'2026-07-03 12:52:52',NULL,NULL,0,NULL,NULL,0.00,0.0000,'',0.00,0.00),(270,'2026070330299016',1015,2004,7,68.00,68.00,0.00,2,0.00,0.00,0.00,0.00,NULL,1,'IK_1015_2026070330299016',0,0,NULL,'林先生','13900010003',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-03 16:12:18',NULL,NULL,NULL,NULL,0,'220518',NULL,0.00,0.0000,'',0.00,0.00),(271,'2026062417756140',1025,2004,7,256.00,256.00,0.00,2,0.00,0.00,0.00,0.00,NULL,4,'IK_1025_2026062417756140',0,0,NULL,'林先生','13900010003',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,NULL,'2026-06-24 20:18:33',NULL,'2026-06-24 20:09:33',NULL,'2026-06-24 20:14:33','2026-06-24 20:38:33','2026-06-24 21:57:33',0,'661636',NULL,20.48,0.0800,'腰部商家',0.00,10.24),(272,'2026062957737017',1025,2004,NULL,249.70,249.70,0.00,1,5.00,0.00,0.00,0.00,NULL,5,'IK_1025_2026062957737017',0,0,NULL,'张三','13800001101','广东省','深圳市','南山区','科技园路88号创新大厦A座1203',NULL,'广东省深圳市南山区科技园路88号创新大厦A座1203',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,'2026-06-29 12:56:17','2026-06-29 12:46:17',NULL,'2026-06-29 13:16:17',NULL,NULL,0,NULL,NULL,0.00,0.0000,'',0.00,0.00),(273,'2026060345187042',1020,2004,NULL,214.60,214.60,0.00,1,5.00,0.00,0.00,0.00,NULL,4,'IK_1020_2026060345187042',0,0,NULL,'李四','13800001102','北京市','北京市','朝阳区','望京街道阜通东大街6号院3号楼1802',NULL,'北京市北京市朝阳区望京街道阜通东大街6号院3号楼1802',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,NULL,'2026-06-03 18:03:28',NULL,'2026-06-03 17:58:28',NULL,'2026-06-03 18:08:28','2026-06-03 18:19:28','2026-06-03 19:10:28',0,NULL,NULL,17.17,0.0800,'腰部商家',0.00,8.58),(274,'2026060319245285',1024,2004,NULL,89.90,89.90,0.00,1,5.00,0.00,0.00,0.00,NULL,4,'IK_1024_2026060319245285',0,0,NULL,'陈十二','13800001110','陕西省','西安市','雁塔区','科技二路72号天泽大厦901',NULL,'陕西省西安市雁塔区科技二路72号天泽大厦901',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,NULL,'2026-06-03 09:29:26',NULL,'2026-06-03 09:19:26',NULL,'2026-06-03 09:32:26','2026-06-03 09:43:26','2026-06-03 10:47:26',0,NULL,NULL,7.19,0.0800,'腰部商家',0.00,3.60),(275,'2026052255709501',1013,2007,NULL,335.00,335.00,45.00,1,5.00,0.00,0.00,0.00,NULL,4,'IK_1013_2026052255709501',0,0,NULL,'郑十','13800001108','广东省','广州市','天河区','体育西路111号建和中心12层',NULL,'广东省广州市天河区体育西路111号建和中心12层',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,NULL,'2026-05-22 10:22:13',NULL,'2026-05-22 10:18:13',NULL,'2026-05-22 10:36:13','2026-05-22 10:51:13','2026-05-22 11:12:13',0,NULL,NULL,26.80,0.0800,'腰部商家',45.00,13.40),(276,'2026052438739667',1012,2007,NULL,403.00,403.00,0.00,1,5.00,0.00,0.00,0.00,NULL,4,'IK_1012_2026052438739667',0,0,NULL,'赵六','13800001104','浙江省','杭州市','西湖区','文三路478号华星时代广场A座2201',NULL,'浙江省杭州市西湖区文三路478号华星时代广场A座2201',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,NULL,'2026-05-24 21:26:42',NULL,'2026-05-24 21:19:42',NULL,'2026-05-24 21:40:42','2026-05-24 22:09:42','2026-05-24 22:18:42',0,NULL,NULL,32.24,0.0800,'腰部商家',0.00,16.12),(277,'2026070758112808',1023,2007,7,372.00,372.00,0.00,2,0.00,0.00,0.00,0.00,NULL,3,'IK_1023_2026070758112808',0,0,NULL,'林先生','13900010003',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,NULL,'2026-07-07 21:01:17',NULL,'2026-07-07 20:59:17',NULL,'2026-07-07 21:10:17','2026-07-07 21:23:17',NULL,0,'308915',NULL,29.76,0.0800,'腰部商家',0.00,14.88),(278,'2026063035195402',1020,2007,8,998.00,998.00,0.00,2,0.00,0.00,0.00,0.00,NULL,2,'IK_1020_2026063035195402',0,0,NULL,'刘先生','13900010001',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-06-30 10:50:03',NULL,'2026-06-30 10:55:03',NULL,NULL,0,'154531',NULL,79.84,0.0800,'腰部商家',0.00,39.92),(279,'2026070480788126',1013,2007,8,156.00,156.00,0.00,2,0.00,0.00,0.00,0.00,NULL,5,'IK_1013_2026070480788126',0,0,NULL,'刘先生','13900010001',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-04 13:59:55','2026-07-04 13:31:55',NULL,'2026-07-04 13:44:55',NULL,NULL,0,'542468',NULL,0.00,0.0000,'',0.00,0.00),(280,'2026051119658083',1023,2007,NULL,93.00,93.00,0.00,1,5.00,0.00,0.00,0.00,NULL,4,'IK_1023_2026051119658083',0,0,NULL,'赵六','13800001104','浙江省','杭州市','西湖区','文三路478号华星时代广场A座2201',NULL,'浙江省杭州市西湖区文三路478号华星时代广场A座2201',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,NULL,'2026-05-11 12:14:36',NULL,'2026-05-11 12:09:36',NULL,'2026-05-11 12:24:36','2026-05-11 12:28:36','2026-05-11 13:53:36',0,NULL,NULL,7.44,0.0800,'腰部商家',0.00,3.72),(281,'2026070710650211',1014,2007,8,128.00,128.00,0.00,2,0.00,0.00,0.00,0.00,NULL,2,'IK_1014_2026070710650211',0,0,NULL,'黄女士','13900010002',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-07 14:23:33',NULL,'2026-07-07 14:33:33',NULL,NULL,0,'343610',NULL,10.24,0.0800,'腰部商家',0.00,5.12),(282,'2026070346218744',1010,2007,NULL,359.00,359.00,0.00,1,5.00,0.00,0.00,0.00,NULL,1,'IK_1010_2026070346218744',0,0,NULL,'吴九','13800001107','湖北省','武汉市','洪山区','珞喻路1037号华中科技大学东校区',NULL,'湖北省武汉市洪山区珞喻路1037号华中科技大学东校区',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-03 09:06:15',NULL,NULL,NULL,NULL,0,NULL,NULL,0.00,0.0000,'',0.00,0.00),(283,'2026062256425791',1011,2007,NULL,2999.00,2999.00,0.00,1,5.00,0.00,0.00,0.00,NULL,5,'IK_1011_2026062256425791',0,0,NULL,'赵六','13800001104','浙江省','杭州市','西湖区','文三路478号华星时代广场A座2201',NULL,'浙江省杭州市西湖区文三路478号华星时代广场A座2201',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,'2026-06-22 08:18:12','2026-06-22 08:01:12',NULL,'2026-06-22 08:18:12',NULL,NULL,0,NULL,NULL,0.00,0.0000,'',0.00,0.00),(284,'2026051375153367',1016,2007,8,164.00,164.00,0.00,2,0.00,0.00,0.00,0.00,NULL,4,'IK_1016_2026051375153367',0,0,NULL,'林先生','13900010003',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,NULL,'2026-05-13 10:57:58',NULL,'2026-05-13 10:55:58',NULL,'2026-05-13 11:12:58','2026-05-13 11:26:58','2026-05-13 12:17:58',0,'778828',NULL,13.12,0.0800,'腰部商家',0.00,6.56),(285,'2026070214636297',1021,2007,NULL,1038.00,1038.00,0.00,1,5.00,0.00,0.00,0.00,NULL,3,'IK_1021_2026070214636297',0,0,NULL,'王五','13800001103','上海市','上海市','浦东新区','张江高科技园区碧波路690号2号楼501',NULL,'上海市上海市浦东新区张江高科技园区碧波路690号2号楼501',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,NULL,'2026-07-02 09:56:08',NULL,'2026-07-02 09:52:08',NULL,'2026-07-02 10:09:08','2026-07-02 10:36:08',NULL,0,NULL,NULL,83.04,0.0800,'腰部商家',0.00,41.52),(286,'2026060614657899',1009,2007,7,78.00,78.00,0.00,2,0.00,0.00,0.00,0.00,NULL,4,'IK_1009_2026060614657899',0,0,NULL,'杨女士','13900010004',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,NULL,'2026-06-06 13:00:18',NULL,'2026-06-06 12:58:18',NULL,'2026-06-06 13:01:18','2026-06-06 13:54:18','2026-06-06 13:51:18',0,'155666',NULL,6.24,0.0800,'腰部商家',0.00,3.12),(287,'2026062888458322',1023,2007,NULL,1055.00,1055.00,0.00,1,5.00,0.00,0.00,0.00,NULL,5,'IK_1023_2026062888458322',0,0,NULL,'郑十','13800001108','广东省','广州市','天河区','体育西路111号建和中心12层',NULL,'广东省广州市天河区体育西路111号建和中心12层',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,'2026-06-28 19:47:38','2026-06-28 19:07:38',NULL,'2026-06-28 19:14:38',NULL,NULL,0,NULL,NULL,0.00,0.0000,'',0.00,0.00),(288,'2026051243248393',1019,2007,NULL,639.00,639.00,0.00,1,5.00,0.00,0.00,0.00,NULL,5,'IK_1019_2026051243248393',0,0,NULL,'孙七','13800001105','江苏省','南京市','鼓楼区','中山北路28号江苏商厦15层1503',NULL,'江苏省南京市鼓楼区中山北路28号江苏商厦15层1503',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,'2026-05-12 20:08:48','2026-05-12 19:20:48',NULL,'2026-05-12 19:33:48',NULL,NULL,0,NULL,NULL,0.00,0.0000,'',0.00,0.00),(289,'2026070621609319',1007,2007,8,134.00,134.00,0.00,2,0.00,0.00,0.00,0.00,NULL,5,'IK_1007_2026070621609319',0,0,NULL,'黄女士','13900010002',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-06 21:53:01','2026-07-06 21:10:01',NULL,'2026-07-06 21:26:01',NULL,NULL,0,'873635',NULL,0.00,0.0000,'',0.00,0.00),(290,'2026051890529043',1018,2007,NULL,161.00,161.00,0.00,1,5.00,0.00,0.00,0.00,NULL,5,'IK_1018_2026051890529043',0,0,NULL,'郑十','13800001108','广东省','广州市','天河区','体育西路111号建和中心12层',NULL,'广东省广州市天河区体育西路111号建和中心12层',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,'2026-05-18 18:40:41','2026-05-18 17:41:41',NULL,'2026-05-18 17:43:41',NULL,NULL,0,NULL,NULL,0.00,0.0000,'',0.00,0.00),(291,'2026070455145700',1010,2007,NULL,151.00,151.00,0.00,1,5.00,0.00,0.00,0.00,NULL,2,'IK_1010_2026070455145700',0,0,NULL,'冯十一','13800001109','湖南省','长沙市','岳麓区','麓谷大道658号麓谷信息港B座1502',NULL,'湖南省长沙市岳麓区麓谷大道658号麓谷信息港B座1502',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-04 15:04:27',NULL,'2026-07-04 15:17:27',NULL,NULL,0,NULL,NULL,12.08,0.0800,'腰部商家',0.00,6.04),(292,'2026062337487598',1012,2007,9,280.00,280.00,0.00,2,0.00,0.00,0.00,0.00,NULL,5,'IK_1012_2026062337487598',0,0,NULL,'杨女士','13900010004',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,'2026-06-23 14:34:01','2026-06-23 13:47:01',NULL,'2026-06-23 14:09:01',NULL,NULL,0,'929398',NULL,0.00,0.0000,'',0.00,0.00),(293,'2026070764899824',1016,2007,NULL,108.00,108.00,0.00,1,5.00,0.00,0.00,0.00,NULL,1,'IK_1016_2026070764899824',0,0,NULL,'陈十二','13800001110','陕西省','西安市','雁塔区','科技二路72号天泽大厦901',NULL,'陕西省西安市雁塔区科技二路72号天泽大厦901',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-07 21:58:47',NULL,NULL,NULL,NULL,0,NULL,NULL,0.00,0.0000,'',0.00,0.00),(294,'2026050821595893',1015,2007,NULL,769.00,769.00,0.00,1,5.00,0.00,0.00,0.00,NULL,4,'IK_1015_2026050821595893',0,0,NULL,'赵六','13800001104','浙江省','杭州市','西湖区','文三路478号华星时代广场A座2201',NULL,'浙江省杭州市西湖区文三路478号华星时代广场A座2201',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,NULL,'2026-05-08 21:40:33',NULL,'2026-05-08 21:36:33',NULL,'2026-05-08 21:57:33','2026-05-08 22:06:33','2026-05-08 22:44:33',0,NULL,NULL,61.52,0.0800,'腰部商家',0.00,30.76),(295,'2026061058337195',1016,2007,NULL,271.00,271.00,0.00,1,5.00,0.00,0.00,0.00,NULL,5,'IK_1016_2026061058337195',0,0,NULL,'周八','13800001106','四川省','成都市','武侯区','天府大道北段1700号环球中心E2-801',NULL,'四川省成都市武侯区天府大道北段1700号环球中心E2-801',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,'2026-06-10 21:05:16','2026-06-10 20:50:16',NULL,'2026-06-10 21:12:16',NULL,NULL,0,NULL,NULL,0.00,0.0000,'',0.00,0.00),(296,'2026062258323320',1008,2007,NULL,231.00,231.00,0.00,1,5.00,0.00,0.00,0.00,NULL,5,'IK_1008_2026062258323320',0,0,NULL,'赵六','13800001104','浙江省','杭州市','西湖区','文三路478号华星时代广场A座2201',NULL,'浙江省杭州市西湖区文三路478号华星时代广场A座2201',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,'2026-06-22 09:29:42','2026-06-22 09:02:42',NULL,'2026-06-22 09:22:42',NULL,NULL,0,NULL,NULL,0.00,0.0000,'',0.00,0.00),(297,'2026070241041934',1008,2007,9,168.00,168.00,0.00,2,0.00,0.00,0.00,0.00,NULL,3,'IK_1008_2026070241041934',0,0,NULL,'林先生','13900010003',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,NULL,'2026-07-02 18:19:32',NULL,'2026-07-02 18:13:32',NULL,'2026-07-02 18:40:32','2026-07-02 19:01:32',NULL,0,'266814',NULL,13.44,0.0800,'腰部商家',0.00,6.72),(298,'2026061085563186',1023,2007,7,146.00,146.00,0.00,2,0.00,0.00,0.00,0.00,NULL,4,'IK_1023_2026061085563186',0,0,NULL,'黄女士','13900010002',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,NULL,'2026-06-10 19:14:45',NULL,'2026-06-10 19:05:45',NULL,'2026-06-10 19:31:45','2026-06-10 19:48:45','2026-06-10 20:08:45',0,'272621',NULL,11.68,0.0800,'腰部商家',0.00,5.84),(299,'2026070288320247',1010,2007,NULL,149.00,149.00,0.00,1,5.00,0.00,0.00,0.00,NULL,2,'IK_1010_2026070288320247',0,0,NULL,'李四','13800001102','北京市','北京市','朝阳区','望京街道阜通东大街6号院3号楼1802',NULL,'北京市北京市朝阳区望京街道阜通东大街6号院3号楼1802',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-02 17:21:12',NULL,'2026-07-02 17:30:12',NULL,NULL,0,NULL,NULL,11.92,0.0800,'腰部商家',0.00,5.96),(300,'2026061087499722',1011,2007,NULL,307.90,307.90,0.00,1,5.00,0.00,0.00,0.00,NULL,4,'IK_1011_2026061087499722',0,0,NULL,'郑十','13800001108','广东省','广州市','天河区','体育西路111号建和中心12层',NULL,'广东省广州市天河区体育西路111号建和中心12层',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,NULL,'2026-06-10 14:58:01',NULL,'2026-06-10 14:54:01',NULL,'2026-06-10 15:16:01','2026-06-10 15:10:01','2026-06-10 16:07:01',0,NULL,NULL,24.63,0.0800,'腰部商家',0.00,12.32),(301,'2026052830126648',1020,2007,7,372.70,372.70,0.00,2,0.00,0.00,0.00,0.00,NULL,4,'IK_1020_2026052830126648',0,0,NULL,'杨女士','13900010004',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,NULL,'2026-05-28 13:53:33',NULL,'2026-05-28 13:52:33',NULL,'2026-05-28 13:54:33','2026-05-28 14:26:33','2026-05-28 15:03:33',0,'286526',NULL,29.82,0.0800,'腰部商家',0.00,14.91),(302,'2026062858796532',1010,2007,NULL,264.80,264.80,0.00,1,5.00,0.00,0.00,0.00,NULL,5,'IK_1010_2026062858796532',0,0,NULL,'孙七','13800001105','江苏省','南京市','鼓楼区','中山北路28号江苏商厦15层1503',NULL,'江苏省南京市鼓楼区中山北路28号江苏商厦15层1503',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,'2026-06-28 18:59:43','2026-06-28 17:59:43',NULL,'2026-06-28 18:06:43',NULL,NULL,0,NULL,NULL,0.00,0.0000,'',0.00,0.00),(303,'2026070440120296',1015,2007,NULL,403.00,403.00,0.00,1,5.00,0.00,0.00,0.00,NULL,5,'IK_1015_2026070440120296',0,0,NULL,'郑十','13800001108','广东省','广州市','天河区','体育西路111号建和中心12层',NULL,'广东省广州市天河区体育西路111号建和中心12层',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-04 17:38:08','2026-07-04 16:49:08',NULL,'2026-07-04 16:52:08',NULL,NULL,0,NULL,NULL,0.00,0.0000,'',0.00,0.00),(304,'2026060173580264',1025,2007,7,820.00,820.00,0.00,2,0.00,0.00,0.00,0.00,NULL,5,'IK_1025_2026060173580264',0,0,NULL,'黄女士','13900010002',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,'2026-06-01 14:02:07','2026-06-01 13:25:07',NULL,'2026-06-01 13:46:07',NULL,NULL,0,'194458',NULL,0.00,0.0000,'',0.00,0.00),(305,'2026070664698209',1007,2007,NULL,361.00,361.00,0.00,1,5.00,0.00,0.00,0.00,NULL,2,'IK_1007_2026070664698209',0,0,NULL,'周八','13800001106','四川省','成都市','武侯区','天府大道北段1700号环球中心E2-801',NULL,'四川省成都市武侯区天府大道北段1700号环球中心E2-801',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-06 11:44:09',NULL,'2026-07-06 11:50:09',NULL,NULL,0,NULL,NULL,28.88,0.0800,'腰部商家',0.00,14.44),(306,'2026070474873424',1013,2007,7,58.00,58.00,0.00,2,0.00,0.00,0.00,0.00,NULL,3,'IK_1013_2026070474873424',0,0,NULL,'黄女士','13900010002',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,NULL,'2026-07-04 08:03:07',NULL,'2026-07-04 08:01:07',NULL,'2026-07-04 08:29:07','2026-07-04 08:50:07',NULL,0,'778153',NULL,4.64,0.0800,'腰部商家',0.00,2.32),(307,'2026052453976616',1018,2007,7,6246.00,6246.00,0.00,2,0.00,0.00,0.00,0.00,NULL,4,'IK_1018_2026052453976616',0,0,NULL,'林先生','13900010003',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,NULL,'2026-05-24 11:53:19',NULL,'2026-05-24 11:47:19',NULL,'2026-05-24 12:15:19','2026-05-24 12:16:19','2026-05-24 13:37:19',0,'777377',NULL,499.68,0.0800,'腰部商家',0.00,80.00),(308,'2026060424554610',1009,2007,NULL,143.00,143.00,0.00,1,5.00,0.00,0.00,0.00,NULL,4,'IK_1009_2026060424554610',0,0,NULL,'吴九','13800001107','湖北省','武汉市','洪山区','珞喻路1037号华中科技大学东校区',NULL,'湖北省武汉市洪山区珞喻路1037号华中科技大学东校区',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,NULL,'2026-06-04 11:05:46',NULL,'2026-06-04 10:59:46',NULL,'2026-06-04 11:25:46','2026-06-04 11:27:46','2026-06-04 11:45:46',0,NULL,NULL,11.44,0.0800,'腰部商家',0.00,5.72),(309,'2026061743510982',1016,2007,8,619.80,619.80,0.00,2,0.00,0.00,0.00,0.00,NULL,5,'IK_1016_2026061743510982',0,0,NULL,'林先生','13900010003',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,'2026-06-17 20:59:41','2026-06-17 20:14:41',NULL,'2026-06-17 20:20:41',NULL,NULL,0,'848701',NULL,0.00,0.0000,'',0.00,0.00),(310,'2026052241972769',1025,2007,NULL,1301.00,1301.00,0.00,1,5.00,0.00,0.00,0.00,NULL,5,'IK_1025_2026052241972769',0,0,NULL,'周八','13800001106','四川省','成都市','武侯区','天府大道北段1700号环球中心E2-801',NULL,'四川省成都市武侯区天府大道北段1700号环球中心E2-801',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,'2026-05-22 10:17:04','2026-05-22 09:37:04',NULL,'2026-05-22 10:05:04',NULL,NULL,0,NULL,NULL,0.00,0.0000,'',0.00,0.00),(311,'2026060645302327',1022,2007,9,56.00,56.00,0.00,2,0.00,0.00,0.00,0.00,NULL,4,'IK_1022_2026060645302327',0,0,NULL,'林先生','13900010003',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,NULL,'2026-06-06 13:05:41',NULL,'2026-06-06 12:55:41',NULL,'2026-06-06 12:57:41','2026-06-06 13:33:41','2026-06-06 14:50:41',0,'161100',NULL,4.48,0.0800,'腰部商家',0.00,2.24),(312,'2026070280707928',1013,2010,NULL,801.00,801.00,0.00,1,5.00,0.00,0.00,0.00,NULL,4,'IK_1013_2026070280707928',0,0,NULL,'冯十一','13800001109','湖南省','长沙市','岳麓区','麓谷大道658号麓谷信息港B座1502',NULL,'湖南省长沙市岳麓区麓谷大道658号麓谷信息港B座1502',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,NULL,'2026-07-02 10:40:53',NULL,'2026-07-02 10:30:53',NULL,'2026-07-02 10:43:53','2026-07-02 11:12:53','2026-07-02 12:03:53',0,NULL,NULL,96.12,0.1200,'头部商家',0.00,40.05),(313,'2026070372041709',1017,2010,9,1971.00,1971.00,0.00,2,0.00,0.00,0.00,0.00,NULL,1,'IK_1017_2026070372041709',0,0,NULL,'刘先生','13900010001',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-03 14:27:15',NULL,NULL,NULL,NULL,0,'493387',NULL,0.00,0.0000,'',0.00,0.00),(314,'2026070361578377',1017,2010,9,196.70,196.70,0.00,2,0.00,0.00,0.00,0.00,NULL,1,'IK_1017_2026070361578377',0,0,NULL,'林先生','13900010003',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-03 09:28:32',NULL,NULL,NULL,NULL,0,'386322',NULL,0.00,0.0000,'',0.00,0.00),(315,'2026061828204754',1021,2010,8,614.00,614.00,0.00,2,0.00,0.00,0.00,0.00,NULL,4,'IK_1021_2026061828204754',0,0,NULL,'杨女士','13900010004',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,NULL,'2026-06-18 12:36:11',NULL,'2026-06-18 12:27:11',NULL,'2026-06-18 12:31:11','2026-06-18 13:10:11','2026-06-18 13:24:11',0,'265595',NULL,73.68,0.1200,'头部商家',0.00,30.70),(316,'2026070612773639',1007,2010,NULL,2813.00,2813.00,0.00,1,5.00,0.00,0.00,0.00,NULL,1,'IK_1007_2026070612773639',0,0,NULL,'冯十一','13800001109','湖南省','长沙市','岳麓区','麓谷大道658号麓谷信息港B座1502',NULL,'湖南省长沙市岳麓区麓谷大道658号麓谷信息港B座1502',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-06 12:48:53',NULL,NULL,NULL,NULL,0,NULL,NULL,0.00,0.0000,'',0.00,0.00),(317,'2026070561193676',1010,2010,NULL,509.00,509.00,0.00,1,5.00,0.00,0.00,0.00,NULL,1,'IK_1010_2026070561193676',0,0,NULL,'陈十二','13800001110','陕西省','西安市','雁塔区','科技二路72号天泽大厦901',NULL,'陕西省西安市雁塔区科技二路72号天泽大厦901',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-05 16:37:52',NULL,NULL,NULL,NULL,0,NULL,NULL,0.00,0.0000,'',0.00,0.00),(318,'2026062842659921',1009,2010,NULL,341.00,341.00,0.00,1,5.00,0.00,0.00,0.00,NULL,3,'IK_1009_2026062842659921',0,0,NULL,'赵六','13800001104','浙江省','杭州市','西湖区','文三路478号华星时代广场A座2201',NULL,'浙江省杭州市西湖区文三路478号华星时代广场A座2201',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,NULL,'2026-06-28 13:23:19',NULL,'2026-06-28 13:13:19',NULL,'2026-06-28 13:21:19','2026-06-28 13:52:19',NULL,0,NULL,NULL,40.92,0.1200,'头部商家',0.00,17.05),(319,'2026062224268228',1023,2010,9,2962.00,2962.00,0.00,2,0.00,0.00,0.00,0.00,NULL,3,'IK_1023_2026062224268228',0,0,NULL,'杨女士','13900010004',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,NULL,'2026-06-22 20:56:18',NULL,'2026-06-22 20:52:18',NULL,'2026-06-22 21:06:18','2026-06-22 21:45:18',NULL,0,'421766',NULL,355.44,0.1200,'头部商家',0.00,100.00),(320,'2026051583285764',1017,2010,NULL,582.80,582.80,0.00,1,5.00,0.00,0.00,0.00,NULL,4,'IK_1017_2026051583285764',0,0,NULL,'冯十一','13800001109','湖南省','长沙市','岳麓区','麓谷大道658号麓谷信息港B座1502',NULL,'湖南省长沙市岳麓区麓谷大道658号麓谷信息港B座1502',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,NULL,'2026-05-15 15:06:33',NULL,'2026-05-15 15:05:33',NULL,'2026-05-15 15:27:33','2026-05-15 15:35:33','2026-05-15 16:58:33',0,NULL,NULL,69.94,0.1200,'头部商家',0.00,29.14),(321,'2026070481475398',1024,2010,NULL,587.00,587.00,0.00,1,5.00,0.00,0.00,0.00,NULL,1,'IK_1024_2026070481475398',0,0,NULL,'郑十','13800001108','广东省','广州市','天河区','体育西路111号建和中心12层',NULL,'广东省广州市天河区体育西路111号建和中心12层',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-04 11:57:45',NULL,NULL,NULL,NULL,0,NULL,NULL,0.00,0.0000,'',0.00,0.00),(322,'2026070481252484',1013,2010,7,2998.00,2998.00,0.00,2,0.00,0.00,0.00,0.00,NULL,3,'IK_1013_2026070481252484',0,0,NULL,'林先生','13900010003',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,NULL,'2026-07-04 12:35:43',NULL,'2026-07-04 12:33:43',NULL,'2026-07-04 12:48:43','2026-07-04 13:19:43',NULL,0,'785462',NULL,359.76,0.1200,'头部商家',0.00,100.00),(323,'2026070799855351',1017,2010,NULL,3201.00,3201.00,0.00,1,5.00,0.00,0.00,0.00,NULL,2,'IK_1017_2026070799855351',0,0,NULL,'冯十一','13800001109','湖南省','长沙市','岳麓区','麓谷大道658号麓谷信息港B座1502',NULL,'湖南省长沙市岳麓区麓谷大道658号麓谷信息港B座1502',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-07 13:22:20',NULL,'2026-07-07 13:41:20',NULL,NULL,0,NULL,NULL,384.12,0.1200,'头部商家',0.00,100.00),(324,'2026051616008224',1022,2010,8,524.00,524.00,80.00,2,0.00,0.00,0.00,0.00,NULL,4,'IK_1022_2026051616008224',0,0,NULL,'杨女士','13900010004',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,NULL,'2026-05-16 19:07:50',NULL,'2026-05-16 19:02:50',NULL,'2026-05-16 19:05:50','2026-05-16 20:01:50','2026-05-16 21:01:50',0,'156786',NULL,62.88,0.1200,'头部商家',80.00,26.20),(325,'2026060190351554',1025,2010,NULL,333.00,333.00,0.00,1,5.00,0.00,0.00,0.00,NULL,4,'IK_1025_2026060190351554',0,0,NULL,'吴九','13800001107','湖北省','武汉市','洪山区','珞喻路1037号华中科技大学东校区',NULL,'湖北省武汉市洪山区珞喻路1037号华中科技大学东校区',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,NULL,'2026-06-01 08:45:40',NULL,'2026-06-01 08:44:40',NULL,'2026-06-01 08:53:40','2026-06-01 09:00:40','2026-06-01 10:19:40',0,NULL,NULL,39.96,0.1200,'头部商家',0.00,16.65),(326,'2026070565695091',1017,2010,8,190.90,190.90,0.00,2,0.00,0.00,0.00,0.00,NULL,2,'IK_1017_2026070565695091',0,0,NULL,'刘先生','13900010001',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-05 15:41:04',NULL,'2026-07-05 16:01:04',NULL,NULL,0,'818423',NULL,22.91,0.1200,'头部商家',0.00,9.55),(327,'2026052165114976',1022,2010,8,564.00,564.00,0.00,2,0.00,0.00,0.00,0.00,NULL,4,'IK_1022_2026052165114976',0,0,NULL,'杨女士','13900010004',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,NULL,'2026-05-21 15:34:21',NULL,'2026-05-21 15:27:21',NULL,'2026-05-21 15:48:21','2026-05-21 16:19:21','2026-05-21 16:28:21',0,'154578',NULL,67.68,0.1200,'头部商家',0.00,28.20),(328,'2026051863738448',1010,2010,9,224.00,224.00,25.00,2,0.00,0.00,0.00,0.00,NULL,4,'IK_1010_2026051863738448',0,0,NULL,'黄女士','13900010002',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,NULL,'2026-05-18 11:21:38',NULL,'2026-05-18 11:12:38',NULL,'2026-05-18 11:40:38','2026-05-18 12:08:38','2026-05-18 13:05:38',0,'121702',NULL,26.88,0.1200,'头部商家',25.00,11.20),(329,'2026060880497267',1013,2010,NULL,153393.00,153393.00,180.00,1,5.00,0.00,0.00,0.00,NULL,4,'IK_1013_2026060880497267',0,0,NULL,'王五','13800001103','上海市','上海市','浦东新区','张江高科技园区碧波路690号2号楼501',NULL,'上海市上海市浦东新区张江高科技园区碧波路690号2号楼501',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,NULL,'2026-06-08 09:07:04',NULL,'2026-06-08 09:03:04',NULL,'2026-06-08 09:30:04','2026-06-08 09:53:04','2026-06-08 10:49:04',0,NULL,NULL,18407.16,0.1200,'头部商家',180.00,100.00),(330,'2026062413989295',1009,2010,NULL,115.90,115.90,0.00,1,5.00,0.00,0.00,0.00,NULL,5,'IK_1009_2026062413989295',0,0,NULL,'吴九','13800001107','湖北省','武汉市','洪山区','珞喻路1037号华中科技大学东校区',NULL,'湖北省武汉市洪山区珞喻路1037号华中科技大学东校区',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,'2026-06-24 13:22:49','2026-06-24 12:24:49',NULL,'2026-06-24 12:50:49',NULL,NULL,0,NULL,NULL,0.00,0.0000,'',0.00,0.00),(331,'2026070362950266',1012,2010,9,18.90,18.90,0.00,2,0.00,0.00,0.00,0.00,NULL,1,'IK_1012_2026070362950266',0,0,NULL,'林先生','13900010003',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-03 19:44:46',NULL,NULL,NULL,NULL,0,'110354',NULL,0.00,0.0000,'',0.00,0.00),(332,'2026052144271022',1018,2010,8,186.90,186.90,10.00,2,0.00,0.00,0.00,0.00,NULL,4,'IK_1018_2026052144271022',0,0,NULL,'刘先生','13900010001',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,NULL,'2026-05-21 11:31:43',NULL,'2026-05-21 11:26:43',NULL,'2026-05-21 11:31:43','2026-05-21 11:49:43','2026-05-21 13:07:43',0,'711352',NULL,22.43,0.1200,'头部商家',10.00,9.35),(333,'2026062783191904',1022,2010,NULL,1151.00,1151.00,0.00,1,5.00,0.00,0.00,0.00,NULL,5,'IK_1022_2026062783191904',0,0,NULL,'吴九','13800001107','湖北省','武汉市','洪山区','珞喻路1037号华中科技大学东校区',NULL,'湖北省武汉市洪山区珞喻路1037号华中科技大学东校区',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,'2026-06-27 19:15:42','2026-06-27 18:26:42',NULL,'2026-06-27 18:55:42',NULL,NULL,0,NULL,NULL,0.00,0.0000,'',0.00,0.00),(334,'2026061861402538',1024,2010,7,1186.00,1186.00,0.00,2,0.00,0.00,0.00,0.00,NULL,3,'IK_1024_2026061861402538',0,0,NULL,'林先生','13900010003',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,NULL,'2026-06-18 11:08:02',NULL,'2026-06-18 11:01:02',NULL,'2026-06-18 11:30:02','2026-06-18 11:20:02',NULL,0,'787874',NULL,142.32,0.1200,'头部商家',0.00,59.30),(335,'2026052588904680',1013,2010,NULL,357.70,357.70,45.00,1,5.00,0.00,0.00,0.00,NULL,4,'IK_1013_2026052588904680',0,0,NULL,'郑十','13800001108','广东省','广州市','天河区','体育西路111号建和中心12层',NULL,'广东省广州市天河区体育西路111号建和中心12层',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,NULL,'2026-05-25 20:47:01',NULL,'2026-05-25 20:38:01',NULL,'2026-05-25 21:06:01','2026-05-25 20:58:01','2026-05-25 22:27:01',0,NULL,NULL,42.92,0.1200,'头部商家',45.00,17.89),(336,'2026053186859429',1020,2010,NULL,3003.00,3003.00,180.00,1,5.00,0.00,0.00,0.00,NULL,4,'IK_1020_2026053186859429',0,0,NULL,'孙七','13800001105','江苏省','南京市','鼓楼区','中山北路28号江苏商厦15层1503',NULL,'江苏省南京市鼓楼区中山北路28号江苏商厦15层1503',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,NULL,'2026-05-31 11:41:34',NULL,'2026-05-31 11:39:34',NULL,'2026-05-31 11:42:34','2026-05-31 12:16:34','2026-05-31 12:36:34',0,NULL,NULL,360.36,0.1200,'头部商家',180.00,100.00),(337,'2026051880992610',1021,2010,NULL,2392.00,2392.00,180.00,1,5.00,0.00,0.00,0.00,NULL,4,'IK_1021_2026051880992610',0,0,NULL,'陈十二','13800001110','陕西省','西安市','雁塔区','科技二路72号天泽大厦901',NULL,'陕西省西安市雁塔区科技二路72号天泽大厦901',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,NULL,'2026-05-18 14:11:55',NULL,'2026-05-18 14:10:55',NULL,'2026-05-18 14:17:55','2026-05-18 14:49:55','2026-05-18 15:59:55',0,NULL,NULL,287.04,0.1200,'头部商家',180.00,100.00),(338,'2026070772573867',1011,2010,NULL,817.00,817.00,0.00,1,5.00,0.00,0.00,0.00,NULL,5,'IK_1011_2026070772573867',0,0,NULL,'郑十','13800001108','广东省','广州市','天河区','体育西路111号建和中心12层',NULL,'广东省广州市天河区体育西路111号建和中心12层',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-07 18:59:45','2026-07-07 18:21:45',NULL,'2026-07-07 18:27:45',NULL,NULL,0,NULL,NULL,0.00,0.0000,'',0.00,0.00),(339,'2026062435040828',1014,2010,8,1322.00,1322.00,0.00,2,0.00,0.00,0.00,0.00,NULL,3,'IK_1014_2026062435040828',0,0,NULL,'杨女士','13900010004',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,NULL,'2026-06-24 12:38:39',NULL,'2026-06-24 12:28:39',NULL,'2026-06-24 12:33:39','2026-06-24 13:01:39',NULL,0,'551700',NULL,158.64,0.1200,'头部商家',0.00,66.10),(340,'2026062925777046',1016,2010,8,432.00,432.00,0.00,2,0.00,0.00,0.00,0.00,NULL,3,'IK_1016_2026062925777046',0,0,NULL,'刘先生','13900010001',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,NULL,'2026-06-29 12:27:27',NULL,'2026-06-29 12:25:27',NULL,'2026-06-29 12:30:27','2026-06-29 12:59:27',NULL,0,'104311',NULL,51.84,0.1200,'头部商家',0.00,21.60),(341,'2026070197772498',1007,2010,NULL,2285.00,2285.00,0.00,1,5.00,0.00,0.00,0.00,NULL,5,'IK_1007_2026070197772498',0,0,NULL,'王五','13800001103','上海市','上海市','浦东新区','张江高科技园区碧波路690号2号楼501',NULL,'上海市上海市浦东新区张江高科技园区碧波路690号2号楼501',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-01 15:32:20','2026-07-01 14:58:20',NULL,'2026-07-01 15:06:20',NULL,NULL,0,NULL,NULL,0.00,0.0000,'',0.00,0.00),(342,'2026070383315486',1007,2010,NULL,318.80,318.80,0.00,1,5.00,0.00,0.00,0.00,NULL,1,'IK_1007_2026070383315486',0,0,NULL,'吴九','13800001107','湖北省','武汉市','洪山区','珞喻路1037号华中科技大学东校区',NULL,'湖北省武汉市洪山区珞喻路1037号华中科技大学东校区',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-03 19:50:18',NULL,NULL,NULL,NULL,0,NULL,NULL,0.00,0.0000,'',0.00,0.00),(343,'2026052785555294',1022,2010,NULL,61.70,61.70,0.00,1,5.00,0.00,0.00,0.00,NULL,5,'IK_1022_2026052785555294',0,0,NULL,'陈十二','13800001110','陕西省','西安市','雁塔区','科技二路72号天泽大厦901',NULL,'陕西省西安市雁塔区科技二路72号天泽大厦901',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,'2026-05-27 10:16:29','2026-05-27 09:22:29',NULL,'2026-05-27 09:29:29',NULL,NULL,0,NULL,NULL,0.00,0.0000,'',0.00,0.00),(344,'2026070176848177',1016,2010,7,216.00,216.00,0.00,2,0.00,0.00,0.00,0.00,NULL,5,'IK_1016_2026070176848177',0,0,NULL,'杨女士','13900010004',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-01 12:59:11','2026-07-01 12:45:11',NULL,'2026-07-01 12:54:11',NULL,NULL,0,'953698',NULL,0.00,0.0000,'',0.00,0.00),(345,'2026052343291095',1022,2001,NULL,83.00,83.00,0.00,1,5.00,0.00,0.00,0.00,NULL,4,'IK_1022_2026052343291095',0,0,NULL,'王五','13800001103','上海市','上海市','浦东新区','张江高科技园区碧波路690号2号楼501',NULL,'上海市上海市浦东新区张江高科技园区碧波路690号2号楼501',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,NULL,'2026-05-23 12:35:32',NULL,'2026-05-23 12:29:32',NULL,'2026-05-23 12:59:32','2026-05-23 13:15:32','2026-05-23 13:23:32',0,NULL,NULL,4.15,0.0500,'尾部商家',0.00,2.08),(346,'2026051013476931',1012,2001,8,473.80,473.80,0.00,2,0.00,0.00,0.00,0.00,NULL,4,'IK_1012_2026051013476931',0,0,NULL,'杨女士','13900010004',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,NULL,'2026-05-10 09:11:54',NULL,'2026-05-10 09:07:54',NULL,'2026-05-10 09:21:54','2026-05-10 10:01:54','2026-05-10 09:56:54',0,'918939',NULL,23.69,0.0500,'尾部商家',0.00,11.85),(347,'2026062829707414',1007,2001,8,420.00,420.00,0.00,2,0.00,0.00,0.00,0.00,NULL,5,'IK_1007_2026062829707414',0,0,NULL,'黄女士','13900010002',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,'2026-06-28 20:24:58','2026-06-28 19:27:58',NULL,'2026-06-28 19:43:58',NULL,NULL,0,'410896',NULL,0.00,0.0000,'',0.00,0.00),(348,'2026062533617003',1020,2001,NULL,195.90,195.90,10.00,1,5.00,0.00,0.00,0.00,NULL,4,'IK_1020_2026062533617003',0,0,NULL,'周八','13800001106','四川省','成都市','武侯区','天府大道北段1700号环球中心E2-801',NULL,'四川省成都市武侯区天府大道北段1700号环球中心E2-801',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,NULL,'2026-06-25 21:23:24',NULL,'2026-06-25 21:16:24',NULL,'2026-06-25 21:42:24','2026-06-25 22:03:24','2026-06-25 23:01:24',0,NULL,NULL,9.80,0.0500,'尾部商家',10.00,4.90),(349,'2026063077502671',1017,2002,8,27.90,27.90,0.00,2,0.00,0.00,0.00,0.00,NULL,3,'IK_1017_2026063077502671',0,0,NULL,'黄女士','13900010002',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,NULL,'2026-06-30 21:50:26',NULL,'2026-06-30 21:42:26',NULL,'2026-06-30 21:53:26','2026-06-30 22:01:26',NULL,0,'644719',NULL,1.40,0.0500,'尾部商家',0.00,0.70),(350,'2026060144249233',1022,2002,9,660.80,660.80,10.00,2,0.00,0.00,0.00,0.00,NULL,4,'IK_1022_2026060144249233',0,0,NULL,'黄女士','13900010002',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,NULL,'2026-06-01 16:15:26',NULL,'2026-06-01 16:09:26',NULL,'2026-06-01 16:20:26','2026-06-01 16:38:26','2026-06-01 17:46:26',0,'108277',NULL,33.04,0.0500,'尾部商家',10.00,10.20),(351,'2026062162280390',1011,2002,NULL,114.80,114.80,0.00,1,5.00,0.00,0.00,0.00,NULL,5,'IK_1011_2026062162280390',0,0,NULL,'李四','13800001102','北京市','北京市','朝阳区','望京街道阜通东大街6号院3号楼1802',NULL,'北京市北京市朝阳区望京街道阜通东大街6号院3号楼1802',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,'2026-06-21 13:02:24','2026-06-21 12:18:24',NULL,'2026-06-21 12:41:24',NULL,NULL,0,NULL,NULL,0.00,0.0000,'',0.00,0.00),(352,'2026062957260654',1021,2002,NULL,44.80,44.80,7.00,1,5.00,0.00,0.00,0.00,NULL,4,'IK_1021_2026062957260654',0,0,NULL,'王五','13800001103','上海市','上海市','浦东新区','张江高科技园区碧波路690号2号楼501',NULL,'上海市上海市浦东新区张江高科技园区碧波路690号2号楼501',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,NULL,'2026-06-29 10:31:08',NULL,'2026-06-29 10:24:08',NULL,'2026-06-29 10:37:08','2026-06-29 10:50:08','2026-06-29 12:01:08',0,NULL,NULL,2.24,0.0500,'尾部商家',7.00,1.12),(353,'2026060590421947',1020,2005,NULL,115.50,115.50,10.00,1,5.00,0.00,0.00,0.00,NULL,4,'IK_1020_2026060590421947',0,0,NULL,'王五','13800001103','上海市','上海市','浦东新区','张江高科技园区碧波路690号2号楼501',NULL,'上海市上海市浦东新区张江高科技园区碧波路690号2号楼501',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,NULL,'2026-06-05 10:35:11',NULL,'2026-06-05 10:32:11',NULL,'2026-06-05 10:49:11','2026-06-05 11:28:11','2026-06-05 12:25:11',0,NULL,NULL,5.78,0.0500,'尾部商家',10.00,2.89),(354,'2026062340245613',1014,2005,NULL,767.50,767.50,12.00,1,5.00,0.00,0.00,0.00,NULL,4,'IK_1014_2026062340245613',0,0,NULL,'冯十一','13800001109','湖南省','长沙市','岳麓区','麓谷大道658号麓谷信息港B座1502',NULL,'湖南省长沙市岳麓区麓谷大道658号麓谷信息港B座1502',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,NULL,'2026-06-23 21:18:58',NULL,'2026-06-23 21:17:58',NULL,'2026-06-23 21:40:58','2026-06-23 21:58:58','2026-06-23 23:00:58',0,NULL,NULL,38.38,0.0500,'尾部商家',12.00,11.56),(355,'2026062290174045',1010,2005,NULL,29.90,29.90,0.00,1,5.00,0.00,0.00,0.00,NULL,5,'IK_1010_2026062290174045',0,0,NULL,'冯十一','13800001109','湖南省','长沙市','岳麓区','麓谷大道658号麓谷信息港B座1502',NULL,'湖南省长沙市岳麓区麓谷大道658号麓谷信息港B座1502',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,'2026-06-22 12:43:33','2026-06-22 12:13:33',NULL,'2026-06-22 12:18:33',NULL,NULL,0,NULL,NULL,0.00,0.0000,'',0.00,0.00),(356,'2026070562833483',1018,2005,NULL,119.00,119.00,0.00,1,5.00,0.00,0.00,0.00,NULL,3,'IK_1018_2026070562833483',0,0,NULL,'张三','13800001101','广东省','深圳市','南山区','科技园路88号创新大厦A座1203',NULL,'广东省深圳市南山区科技园路88号创新大厦A座1203',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,NULL,'2026-07-05 15:37:07',NULL,'2026-07-05 15:34:07',NULL,'2026-07-05 15:39:07','2026-07-05 15:56:07',NULL,0,NULL,NULL,5.95,0.0500,'尾部商家',0.00,2.98),(357,'2026053115978445',1009,2006,7,143.80,143.80,10.00,2,0.00,0.00,0.00,0.00,NULL,4,'IK_1009_2026053115978445',0,0,NULL,'黄女士','13900010002',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,NULL,'2026-05-31 09:01:34',NULL,'2026-05-31 08:56:34',NULL,'2026-05-31 09:11:34','2026-05-31 09:18:34','2026-05-31 10:55:34',0,'129225',NULL,7.19,0.0500,'尾部商家',10.00,3.60),(358,'2026070352941740',1016,2006,9,101.00,101.00,0.00,2,0.00,0.00,0.00,0.00,NULL,2,'IK_1016_2026070352941740',0,0,NULL,'黄女士','13900010002',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-03 13:38:28',NULL,'2026-07-03 13:55:28',NULL,NULL,0,'588852',NULL,5.05,0.0500,'尾部商家',0.00,2.53),(359,'2026070510135775',1021,2006,NULL,117.90,117.90,0.00,1,5.00,0.00,0.00,0.00,NULL,2,'IK_1021_2026070510135775',0,0,NULL,'冯十一','13800001109','湖南省','长沙市','岳麓区','麓谷大道658号麓谷信息港B座1502',NULL,'湖南省长沙市岳麓区麓谷大道658号麓谷信息港B座1502',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-05 12:34:44',NULL,'2026-07-05 12:46:44',NULL,NULL,0,NULL,NULL,5.90,0.0500,'尾部商家',0.00,2.95),(360,'2026062630828420',1014,2006,9,464.70,464.70,45.00,2,0.00,0.00,0.00,0.00,NULL,4,'IK_1014_2026062630828420',0,0,NULL,'黄女士','13900010002',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,NULL,'2026-06-26 19:22:53',NULL,'2026-06-26 19:12:53',NULL,'2026-06-26 19:24:53','2026-06-26 19:53:53','2026-06-26 20:19:53',0,'886759',NULL,23.24,0.0500,'尾部商家',45.00,8.99),(361,'2026070219297603',1010,2008,NULL,447.00,447.00,0.00,1,5.00,0.00,0.00,0.00,NULL,5,'IK_1010_2026070219297603',0,0,NULL,'王五','13800001103','上海市','上海市','浦东新区','张江高科技园区碧波路690号2号楼501',NULL,'上海市上海市浦东新区张江高科技园区碧波路690号2号楼501',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-02 13:38:09','2026-07-02 13:01:09',NULL,'2026-07-02 13:03:09',NULL,NULL,0,NULL,NULL,0.00,0.0000,'',0.00,0.00),(362,'2026062840943917',1024,2008,NULL,331.00,331.00,0.00,1,5.00,0.00,0.00,0.00,NULL,4,'IK_1024_2026062840943917',0,0,NULL,'郑十','13800001108','广东省','广州市','天河区','体育西路111号建和中心12层',NULL,'广东省广州市天河区体育西路111号建和中心12层',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,NULL,'2026-06-28 19:53:32',NULL,'2026-06-28 19:43:32',NULL,'2026-06-28 19:56:32','2026-06-28 20:31:32','2026-06-28 20:21:32',0,NULL,NULL,0.00,0.0000,'小微商家',0.00,3.31),(363,'2026070580761606',1014,2008,NULL,547.00,547.00,0.00,1,5.00,0.00,0.00,0.00,NULL,1,'IK_1014_2026070580761606',0,0,NULL,'张三','13800001101','广东省','深圳市','南山区','科技园路88号创新大厦A座1203',NULL,'广东省深圳市南山区科技园路88号创新大厦A座1203',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-05 12:23:28',NULL,NULL,NULL,NULL,0,NULL,NULL,0.00,0.0000,'',0.00,0.00),(364,'2026070338417359',1014,2008,NULL,717.00,717.00,0.00,1,5.00,0.00,0.00,0.00,NULL,5,'IK_1014_2026070338417359',0,0,NULL,'赵六','13800001104','浙江省','杭州市','西湖区','文三路478号华星时代广场A座2201',NULL,'浙江省杭州市西湖区文三路478号华星时代广场A座2201',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-03 15:17:04','2026-07-03 14:26:04',NULL,'2026-07-03 14:32:04',NULL,NULL,0,NULL,NULL,0.00,0.0000,'',0.00,0.00),(365,'2026061559334795',1007,2009,7,796.00,796.00,0.00,2,0.00,0.00,0.00,0.00,NULL,4,'IK_1007_2026061559334795',0,0,NULL,'黄女士','13900010002',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,NULL,'2026-06-15 16:07:38',NULL,'2026-06-15 16:02:38',NULL,'2026-06-15 16:15:38','2026-06-15 17:02:38','2026-06-15 17:29:38',0,'131134',NULL,39.80,0.0500,'尾部商家',0.00,19.90),(366,'2026070175657791',1025,2009,NULL,1004.00,1004.00,0.00,1,5.00,0.00,0.00,0.00,NULL,5,'IK_1025_2026070175657791',0,0,NULL,'赵六','13800001104','浙江省','杭州市','西湖区','文三路478号华星时代广场A座2201',NULL,'浙江省杭州市西湖区文三路478号华星时代广场A座2201',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-01 13:40:52','2026-07-01 13:31:52',NULL,'2026-07-01 13:42:52',NULL,NULL,0,NULL,NULL,0.00,0.0000,'',0.00,0.00),(367,'2026051383704112',1008,2009,7,774.00,774.00,80.00,2,0.00,0.00,0.00,0.00,NULL,4,'IK_1008_2026051383704112',0,0,NULL,'杨女士','13900010004',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,NULL,'2026-05-13 10:43:49',NULL,'2026-05-13 10:37:49',NULL,'2026-05-13 10:41:49','2026-05-13 11:23:49','2026-05-13 12:01:49',0,'516990',NULL,38.70,0.0500,'尾部商家',80.00,19.35),(368,'2026062439920908',1024,2009,7,260.00,260.00,0.00,2,0.00,0.00,0.00,0.00,NULL,5,'IK_1024_2026062439920908',0,0,NULL,'杨女士','13900010004',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,'2026-06-24 21:23:57','2026-06-24 20:30:57',NULL,'2026-06-24 20:37:57',NULL,NULL,0,'307227',NULL,0.00,0.0000,'',0.00,0.00),(369,'2026070318202893',1011,2011,NULL,178.00,178.00,0.00,1,5.00,0.00,0.00,0.00,NULL,2,'IK_1011_2026070318202893',0,0,NULL,'冯十一','13800001109','湖南省','长沙市','岳麓区','麓谷大道658号麓谷信息港B座1502',NULL,'湖南省长沙市岳麓区麓谷大道658号麓谷信息港B座1502',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-03 15:06:06',NULL,'2026-07-03 15:26:06',NULL,NULL,0,NULL,NULL,0.00,0.0000,'小微商家',0.00,1.78),(370,'2026070642304847',1016,2011,NULL,73.00,73.00,0.00,1,5.00,0.00,0.00,0.00,NULL,2,'IK_1016_2026070642304847',0,0,NULL,'孙七','13800001105','江苏省','南京市','鼓楼区','中山北路28号江苏商厦15层1503',NULL,'江苏省南京市鼓楼区中山北路28号江苏商厦15层1503',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-06 18:31:53',NULL,'2026-07-06 18:44:53',NULL,NULL,0,NULL,NULL,0.00,0.0000,'小微商家',0.00,0.73),(371,'2026051259444446',1009,2011,NULL,40.00,40.00,0.00,1,5.00,0.00,0.00,0.00,NULL,4,'IK_1009_2026051259444446',0,0,NULL,'王五','13800001103','上海市','上海市','浦东新区','张江高科技园区碧波路690号2号楼501',NULL,'上海市上海市浦东新区张江高科技园区碧波路690号2号楼501',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,NULL,'2026-05-12 13:11:37',NULL,'2026-05-12 13:05:37',NULL,'2026-05-12 13:16:37','2026-05-12 13:21:37','2026-05-12 14:26:37',0,NULL,NULL,0.00,0.0000,'小微商家',0.00,0.40),(372,'2026062928936692',1024,2011,8,239.00,239.00,0.00,2,0.00,0.00,0.00,0.00,NULL,4,'IK_1024_2026062928936692',0,0,NULL,'杨女士','13900010004',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,NULL,'2026-06-29 20:38:50',NULL,'2026-06-29 20:35:50',NULL,'2026-06-29 20:44:50','2026-06-29 21:23:50','2026-06-29 21:07:50',0,'196638',NULL,0.00,0.0000,'小微商家',0.00,2.39),(373,'2026053081842532',1018,2012,8,4096.00,4096.00,180.00,2,0.00,0.00,0.00,0.00,NULL,4,'IK_1018_2026053081842532',0,0,NULL,'刘先生','13900010001',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,NULL,'2026-05-30 18:14:00',NULL,'2026-05-30 18:08:00',NULL,'2026-05-30 18:29:00','2026-05-30 18:49:00','2026-05-30 20:02:00',0,'415687',NULL,327.68,0.0800,'腰部商家',180.00,50.00),(374,'2026052097397439',1008,2012,NULL,4201.00,4201.00,0.00,1,5.00,0.00,0.00,0.00,NULL,4,'IK_1008_2026052097397439',0,0,NULL,'王五','13800001103','上海市','上海市','浦东新区','张江高科技园区碧波路690号2号楼501',NULL,'上海市上海市浦东新区张江高科技园区碧波路690号2号楼501',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,NULL,'2026-05-20 09:19:23',NULL,'2026-05-20 09:13:23',NULL,'2026-05-20 09:38:23','2026-05-20 09:31:23','2026-05-20 10:12:23',0,NULL,NULL,336.08,0.0800,'腰部商家',0.00,50.00),(375,'2026052359552897',1009,2012,NULL,2103.00,2103.00,0.00,1,5.00,0.00,0.00,0.00,NULL,4,'IK_1009_2026052359552897',0,0,NULL,'冯十一','13800001109','湖南省','长沙市','岳麓区','麓谷大道658号麓谷信息港B座1502',NULL,'湖南省长沙市岳麓区麓谷大道658号麓谷信息港B座1502',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,NULL,'2026-05-23 20:39:58',NULL,'2026-05-23 20:34:58',NULL,'2026-05-23 20:36:58','2026-05-23 21:07:58','2026-05-23 21:21:58',0,NULL,NULL,168.24,0.0800,'腰部商家',0.00,50.00),(376,'2026062974661490',1007,2012,8,599.00,599.00,80.00,2,0.00,0.00,0.00,0.00,NULL,4,'IK_1007_2026062974661490',0,0,NULL,'杨女士','13900010004',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,NULL,'2026-06-29 17:27:36',NULL,'2026-06-29 17:22:36',NULL,'2026-06-29 17:30:36','2026-06-29 17:38:36','2026-06-29 18:40:36',0,'552717',NULL,47.92,0.0800,'腰部商家',80.00,14.98),(377,'2026062423881620',1019,2013,NULL,289.00,289.00,0.00,1,5.00,0.00,0.00,0.00,NULL,3,'IK_1019_2026062423881620',0,0,NULL,'冯十一','13800001109','湖南省','长沙市','岳麓区','麓谷大道658号麓谷信息港B座1502',NULL,'湖南省长沙市岳麓区麓谷大道658号麓谷信息港B座1502',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,NULL,'2026-06-24 08:30:36',NULL,'2026-06-24 08:25:36',NULL,'2026-06-24 08:40:36','2026-06-24 09:04:36',NULL,0,NULL,NULL,14.45,0.0500,'尾部商家',0.00,7.23),(378,'2026052948675960',1020,2013,NULL,231.00,231.00,25.00,1,5.00,0.00,0.00,0.00,NULL,4,'IK_1020_2026052948675960',0,0,NULL,'陈十二','13800001110','陕西省','西安市','雁塔区','科技二路72号天泽大厦901',NULL,'陕西省西安市雁塔区科技二路72号天泽大厦901',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,NULL,'2026-05-29 15:31:09',NULL,'2026-05-29 15:25:09',NULL,'2026-05-29 15:28:09','2026-05-29 16:07:09','2026-05-29 16:31:09',0,NULL,NULL,11.55,0.0500,'尾部商家',25.00,5.78),(379,'2026052943210169',1015,2013,NULL,289.00,289.00,25.00,1,5.00,0.00,0.00,0.00,NULL,4,'IK_1015_2026052943210169',0,0,NULL,'吴九','13800001107','湖北省','武汉市','洪山区','珞喻路1037号华中科技大学东校区',NULL,'湖北省武汉市洪山区珞喻路1037号华中科技大学东校区',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,NULL,'2026-05-29 12:28:20',NULL,'2026-05-29 12:27:20',NULL,'2026-05-29 12:44:20','2026-05-29 13:17:20','2026-05-29 13:42:20',0,NULL,NULL,14.45,0.0500,'尾部商家',25.00,7.23),(380,'2026062850757195',1022,2013,8,342.00,342.00,0.00,2,0.00,0.00,0.00,0.00,NULL,2,'IK_1022_2026062850757195',0,0,NULL,'林先生','13900010003',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-06-28 09:37:52',NULL,'2026-06-28 09:54:52',NULL,NULL,0,'957981',NULL,17.10,0.0500,'尾部商家',0.00,8.55),(381,'2026062594805333',1019,2014,8,5998.00,5998.00,0.00,2,0.00,0.00,0.00,0.00,NULL,3,'IK_1019_2026062594805333',0,0,NULL,'黄女士','13900010002',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,NULL,'2026-06-25 13:36:37',NULL,'2026-06-25 13:33:37',NULL,'2026-06-25 13:51:37','2026-06-25 14:04:37',NULL,0,'665634',NULL,479.84,0.0800,'腰部商家',0.00,80.00),(382,'2026062376027270',1020,2014,NULL,8602.00,8602.00,0.00,1,5.00,0.00,0.00,0.00,NULL,4,'IK_1020_2026062376027270',0,0,NULL,'陈十二','13800001110','陕西省','西安市','雁塔区','科技二路72号天泽大厦901',NULL,'陕西省西安市雁塔区科技二路72号天泽大厦901',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,NULL,'2026-06-23 19:26:00',NULL,'2026-06-23 19:23:00',NULL,'2026-06-23 19:50:00','2026-06-23 19:49:00','2026-06-23 20:46:00',0,NULL,NULL,688.16,0.0800,'腰部商家',0.00,80.00),(383,'2026062799910381',1025,2014,NULL,13800.00,13800.00,0.00,1,5.00,0.00,0.00,0.00,NULL,5,'IK_1025_2026062799910381',0,0,NULL,'冯十一','13800001109','湖南省','长沙市','岳麓区','麓谷大道658号麓谷信息港B座1502',NULL,'湖南省长沙市岳麓区麓谷大道658号麓谷信息港B座1502',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,'2026-06-27 11:27:19','2026-06-27 11:12:19',NULL,'2026-06-27 11:16:19',NULL,NULL,0,NULL,NULL,0.00,0.0000,'',0.00,0.00),(384,'2026062823031329',1016,2014,NULL,11601.00,11601.00,0.00,1,5.00,0.00,0.00,0.00,NULL,5,'IK_1016_2026062823031329',0,0,NULL,'李四','13800001102','北京市','北京市','朝阳区','望京街道阜通东大街6号院3号楼1802',NULL,'北京市北京市朝阳区望京街道阜通东大街6号院3号楼1802',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,'2026-06-28 13:11:04','2026-06-28 12:19:04',NULL,'2026-06-28 12:49:04',NULL,NULL,0,NULL,NULL,0.00,0.0000,'',0.00,0.00),(385,'2026052979287011',1023,2015,8,37.80,37.80,0.00,2,0.00,0.00,0.00,0.00,NULL,5,'IK_1023_2026052979287011',0,0,NULL,'林先生','13900010003',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,'2026-05-29 18:25:05','2026-05-29 17:48:05',NULL,'2026-05-29 18:07:05',NULL,NULL,0,'467081',NULL,0.00,0.0000,'',0.00,0.00),(386,'2026050892958463',1014,2015,9,62.70,62.70,0.00,2,0.00,0.00,0.00,0.00,NULL,4,'IK_1014_2026050892958463',0,0,NULL,'杨女士','13900010004',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,NULL,'2026-05-08 18:35:53',NULL,'2026-05-08 18:33:53',NULL,'2026-05-08 18:56:53','2026-05-08 19:09:53','2026-05-08 19:12:53',0,'149098',NULL,0.00,0.0000,'小微商家',0.00,0.63),(387,'2026052618045217',1024,2015,8,87.60,87.60,0.00,2,0.00,0.00,0.00,0.00,NULL,4,'IK_1024_2026052618045217',0,0,NULL,'杨女士','13900010004',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,NULL,'2026-05-26 17:45:40',NULL,'2026-05-26 17:39:40',NULL,'2026-05-26 17:43:40','2026-05-26 17:57:40','2026-05-26 19:03:40',0,'302083',NULL,0.00,0.0000,'小微商家',0.00,0.88),(388,'2026060136180340',1025,2015,9,75.60,75.60,0.00,2,0.00,0.00,0.00,0.00,NULL,4,'IK_1025_2026060136180340',0,0,NULL,'杨女士','13900010004',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,NULL,'2026-06-01 09:13:19',NULL,'2026-06-01 09:12:19',NULL,'2026-06-01 09:37:19','2026-06-01 09:34:19','2026-06-01 10:18:19',0,'789415',NULL,0.00,0.0000,'小微商家',0.00,0.76),(389,'2026070477156746',1017,2016,9,396.00,396.00,0.00,2,0.00,0.00,0.00,0.00,NULL,2,'IK_1017_2026070477156746',0,0,NULL,'刘先生','13900010001',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-04 13:38:13',NULL,'2026-07-04 13:42:13',NULL,NULL,0,'458057',NULL,19.80,0.0500,'尾部商家',0.00,9.90),(390,'2026060841393846',1023,2016,8,1130.00,1130.00,0.00,2,0.00,0.00,0.00,0.00,NULL,4,'IK_1023_2026060841393846',0,0,NULL,'林先生','13900010003',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,NULL,'2026-06-08 09:57:09',NULL,'2026-06-08 09:47:09',NULL,'2026-06-08 10:11:09','2026-06-08 10:47:09','2026-06-08 11:35:09',0,'307741',NULL,56.50,0.0500,'尾部商家',0.00,28.25),(391,'2026070241902227',1022,2016,NULL,273.00,273.00,0.00,1,5.00,0.00,0.00,0.00,NULL,1,'IK_1022_2026070241902227',0,0,NULL,'李四','13800001102','北京市','北京市','朝阳区','望京街道阜通东大街6号院3号楼1802',NULL,'北京市北京市朝阳区望京街道阜通东大街6号院3号楼1802',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-02 20:34:09',NULL,NULL,NULL,NULL,0,NULL,NULL,0.00,0.0000,'',0.00,0.00),(392,'2026051685862009',1011,2016,NULL,937.00,937.00,0.00,1,5.00,0.00,0.00,0.00,NULL,4,'IK_1011_2026051685862009',0,0,NULL,'张三','13800001101','广东省','深圳市','南山区','科技园路88号创新大厦A座1203',NULL,'广东省深圳市南山区科技园路88号创新大厦A座1203',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,NULL,'2026-05-16 21:35:03',NULL,'2026-05-16 21:31:03',NULL,'2026-05-16 21:55:03','2026-05-16 21:55:03','2026-05-16 22:21:03',0,NULL,NULL,46.85,0.0500,'尾部商家',0.00,23.43),(393,'2026070534519980',1011,2017,NULL,17705.00,17705.00,0.00,1,5.00,0.00,0.00,0.00,NULL,1,'IK_1011_2026070534519980',0,0,NULL,'王五','13800001103','上海市','上海市','浦东新区','张江高科技园区碧波路690号2号楼501',NULL,'上海市上海市浦东新区张江高科技园区碧波路690号2号楼501',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-05 16:53:41',NULL,NULL,NULL,NULL,0,NULL,NULL,0.00,0.0000,'',0.00,0.00),(394,'2026063032625120',1022,2017,NULL,26705.00,26705.00,0.00,1,5.00,0.00,0.00,0.00,NULL,5,'IK_1022_2026063032625120',0,0,NULL,'陈十二','13800001110','陕西省','西安市','雁塔区','科技二路72号天泽大厦901',NULL,'陕西省西安市雁塔区科技二路72号天泽大厦901',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,'2026-06-30 09:39:30','2026-06-30 09:20:30',NULL,'2026-06-30 09:49:30',NULL,NULL,0,NULL,NULL,0.00,0.0000,'',0.00,0.00),(395,'2026051360748138',1012,2017,9,26600.00,26600.00,0.00,2,0.00,0.00,0.00,0.00,NULL,5,'IK_1012_2026051360748138',0,0,NULL,'刘先生','13900010001',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,'2026-05-13 19:50:29','2026-05-13 19:04:29',NULL,'2026-05-13 19:22:29',NULL,NULL,0,'548682',NULL,0.00,0.0000,'',0.00,0.00),(396,'2026062489620574',1017,2017,NULL,26605.00,26605.00,0.00,1,5.00,0.00,0.00,0.00,NULL,5,'IK_1017_2026062489620574',0,0,NULL,'王五','13800001103','上海市','上海市','浦东新区','张江高科技园区碧波路690号2号楼501',NULL,'上海市上海市浦东新区张江高科技园区碧波路690号2号楼501',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,'2026-06-24 19:17:47','2026-06-24 18:36:47',NULL,'2026-06-24 18:39:47',NULL,NULL,0,NULL,NULL,0.00,0.0000,'',0.00,0.00),(397,'2026062455682169',1023,2018,NULL,131407.00,131407.00,0.00,1,5.00,0.00,0.00,0.00,NULL,3,'IK_1023_2026062455682169',0,0,NULL,'陈十二','13800001110','陕西省','西安市','雁塔区','科技二路72号天泽大厦901',NULL,'陕西省西安市雁塔区科技二路72号天泽大厦901',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,NULL,'2026-06-24 21:32:37',NULL,'2026-06-24 21:24:37',NULL,'2026-06-24 21:46:37','2026-06-24 21:46:37',NULL,0,NULL,NULL,15768.84,0.1200,'头部商家',0.00,100.00),(398,'2026060999423841',1008,2018,8,8986.00,8986.00,0.00,2,0.00,0.00,0.00,0.00,NULL,4,'IK_1008_2026060999423841',0,0,NULL,'黄女士','13900010002',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,NULL,'2026-06-09 10:23:35',NULL,'2026-06-09 10:17:35',NULL,'2026-06-09 10:44:35','2026-06-09 10:52:35','2026-06-09 11:45:35',0,'811930',NULL,1078.32,0.1200,'头部商家',0.00,100.00),(399,'2026051763811208',1013,2018,9,17972.00,17972.00,0.00,2,0.00,0.00,0.00,0.00,NULL,4,'IK_1013_2026051763811208',0,0,NULL,'杨女士','13900010004',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,NULL,'2026-05-17 15:43:02',NULL,'2026-05-17 15:40:02',NULL,'2026-05-17 15:57:02','2026-05-17 16:20:02','2026-05-17 16:37:02',0,'638733',NULL,2156.64,0.1200,'头部商家',0.00,100.00),(400,'2026070588876485',1009,2018,NULL,8991.00,8991.00,0.00,1,5.00,0.00,0.00,0.00,NULL,5,'IK_1009_2026070588876485',0,0,NULL,'冯十一','13800001109','湖南省','长沙市','岳麓区','麓谷大道658号麓谷信息港B座1502',NULL,'湖南省长沙市岳麓区麓谷大道658号麓谷信息港B座1502',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-05 09:32:27','2026-07-05 09:21:27',NULL,'2026-07-05 09:34:27',NULL,NULL,0,NULL,NULL,0.00,0.0000,'',0.00,0.00),(401,'2026052778506444',1016,2019,9,664.00,664.00,0.00,2,0.00,0.00,0.00,0.00,NULL,4,'IK_1016_2026052778506444',0,0,NULL,'杨女士','13900010004',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,NULL,'2026-05-27 13:59:29',NULL,'2026-05-27 13:54:29',NULL,'2026-05-27 14:10:29','2026-05-27 14:15:29','2026-05-27 15:13:29',0,'125145',NULL,33.20,0.0500,'尾部商家',0.00,16.60),(402,'2026070228496971',1024,2019,NULL,581.00,581.00,0.00,1,5.00,0.00,0.00,0.00,NULL,2,'IK_1024_2026070228496971',0,0,NULL,'郑十','13800001108','广东省','广州市','天河区','体育西路111号建和中心12层',NULL,'广东省广州市天河区体育西路111号建和中心12层',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-02 14:43:22',NULL,'2026-07-02 14:59:22',NULL,NULL,0,NULL,NULL,29.05,0.0500,'尾部商家',0.00,14.53),(403,'2026051143644699',1025,2019,NULL,193.00,193.00,0.00,1,5.00,0.00,0.00,0.00,NULL,4,'IK_1025_2026051143644699',0,0,NULL,'孙七','13800001105','江苏省','南京市','鼓楼区','中山北路28号江苏商厦15层1503',NULL,'江苏省南京市鼓楼区中山北路28号江苏商厦15层1503',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,NULL,'2026-05-11 19:12:51',NULL,'2026-05-11 19:03:51',NULL,'2026-05-11 19:17:51','2026-05-11 20:00:51','2026-05-11 21:03:51',0,NULL,NULL,9.65,0.0500,'尾部商家',0.00,4.83),(404,'2026051869902538',1020,2020,9,1256.00,1256.00,0.00,2,0.00,0.00,0.00,0.00,NULL,4,'IK_1020_2026051869902538',0,0,NULL,'杨女士','13900010004',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,NULL,'2026-05-18 18:28:37',NULL,'2026-05-18 18:25:37',NULL,'2026-05-18 18:33:37','2026-05-18 18:45:37','2026-05-18 20:02:37',0,'515694',NULL,62.80,0.0500,'尾部商家',0.00,31.40),(405,'2026070420365466',1012,2020,NULL,4371.00,4371.00,0.00,1,5.00,0.00,0.00,0.00,NULL,1,'IK_1012_2026070420365466',0,0,NULL,'孙七','13800001105','江苏省','南京市','鼓楼区','中山北路28号江苏商厦15层1503',NULL,'江苏省南京市鼓楼区中山北路28号江苏商厦15层1503',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-04 09:51:15',NULL,NULL,NULL,NULL,0,NULL,NULL,0.00,0.0000,'',0.00,0.00),(406,'2026070698364077',1007,2020,NULL,603.00,603.00,0.00,1,5.00,0.00,0.00,0.00,NULL,1,'IK_1007_2026070698364077',0,0,NULL,'郑十','13800001108','广东省','广州市','天河区','体育西路111号建和中心12层',NULL,'广东省广州市天河区体育西路111号建和中心12层',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-06 08:12:55',NULL,NULL,NULL,NULL,0,NULL,NULL,0.00,0.0000,'',0.00,0.00),(407,'2026062733224169',1023,2021,NULL,161.00,161.00,0.00,1,5.00,0.00,0.00,0.00,NULL,5,'IK_1023_2026062733224169',0,0,NULL,'冯十一','13800001109','湖南省','长沙市','岳麓区','麓谷大道658号麓谷信息港B座1502',NULL,'湖南省长沙市岳麓区麓谷大道658号麓谷信息港B座1502',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,'2026-06-27 09:38:29','2026-06-27 09:00:29',NULL,'2026-06-27 09:07:29',NULL,NULL,0,NULL,NULL,0.00,0.0000,'',0.00,0.00),(408,'2026062614055488',1018,2021,7,68.00,68.00,0.00,2,0.00,0.00,0.00,0.00,NULL,5,'IK_1018_2026062614055488',0,0,NULL,'林先生','13900010003',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,'2026-06-26 19:21:20','2026-06-26 18:58:20',NULL,'2026-06-26 19:00:20',NULL,NULL,0,'384041',NULL,0.00,0.0000,'',0.00,0.00),(409,'2026051439276159',1013,2021,7,88.00,88.00,0.00,2,0.00,0.00,0.00,0.00,NULL,4,'IK_1013_2026051439276159',0,0,NULL,'杨女士','13900010004',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,NULL,'2026-05-14 16:13:12',NULL,'2026-05-14 16:09:12',NULL,'2026-05-14 16:16:12','2026-05-14 17:09:12','2026-05-14 17:29:12',0,'926922',NULL,0.00,0.0000,'小微商家',0.00,0.88),(410,'2026051459841212',1024,2022,NULL,5300.00,5300.00,0.00,1,5.00,0.00,0.00,0.00,NULL,4,'IK_1024_2026051459841212',0,0,NULL,'周八','13800001106','四川省','成都市','武侯区','天府大道北段1700号环球中心E2-801',NULL,'四川省成都市武侯区天府大道北段1700号环球中心E2-801',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,NULL,'2026-05-14 11:15:13',NULL,'2026-05-14 11:10:13',NULL,'2026-05-14 11:39:13','2026-05-14 11:54:13','2026-05-14 11:50:13',0,NULL,NULL,424.00,0.0800,'腰部商家',0.00,50.00),(411,'2026051772736864',1011,2022,8,6802.00,6802.00,0.00,2,0.00,0.00,0.00,0.00,NULL,4,'IK_1011_2026051772736864',0,0,NULL,'杨女士','13900010004',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,NULL,'2026-05-17 13:26:11',NULL,'2026-05-17 13:22:11',NULL,'2026-05-17 13:30:11','2026-05-17 13:40:11','2026-05-17 15:22:11',0,'216502',NULL,544.16,0.0800,'腰部商家',0.00,50.00),(412,'2026062256840044',1024,2022,NULL,4001.00,4001.00,0.00,1,5.00,0.00,0.00,0.00,NULL,5,'IK_1024_2026062256840044',0,0,NULL,'冯十一','13800001109','湖南省','长沙市','岳麓区','麓谷大道658号麓谷信息港B座1502',NULL,'湖南省长沙市岳麓区麓谷大道658号麓谷信息港B座1502',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,'2026-06-22 11:33:36','2026-06-22 11:16:36',NULL,'2026-06-22 11:44:36',NULL,NULL,0,NULL,NULL,0.00,0.0000,'',0.00,0.00),(413,'2026070182706348',1014,2023,9,768.00,768.00,0.00,2,0.00,0.00,0.00,0.00,NULL,5,'IK_1014_2026070182706348',0,0,NULL,'林先生','13900010003',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-01 14:03:31','2026-07-01 13:53:31',NULL,'2026-07-01 14:17:31',NULL,NULL,0,'335882',NULL,0.00,0.0000,'',0.00,0.00),(414,'2026062719117381',1016,2023,NULL,349.00,349.00,0.00,1,5.00,0.00,0.00,0.00,NULL,4,'IK_1016_2026062719117381',0,0,NULL,'吴九','13800001107','湖北省','武汉市','洪山区','珞喻路1037号华中科技大学东校区',NULL,'湖北省武汉市洪山区珞喻路1037号华中科技大学东校区',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,NULL,'2026-06-27 12:21:42',NULL,'2026-06-27 12:11:42',NULL,'2026-06-27 12:37:42','2026-06-27 13:09:42','2026-06-27 12:59:42',0,NULL,NULL,0.00,0.0000,'小微商家',0.00,3.49),(415,'2026061156266139',1017,2023,9,256.00,256.00,0.00,2,0.00,0.00,0.00,0.00,NULL,4,'IK_1017_2026061156266139',0,0,NULL,'林先生','13900010003',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,NULL,'2026-06-11 16:22:33',NULL,'2026-06-11 16:13:33',NULL,'2026-06-11 16:43:33','2026-06-11 16:48:33','2026-06-11 17:32:33',0,'534916',NULL,0.00,0.0000,'小微商家',0.00,2.56),(416,'2026061832829330',1017,2024,9,376.00,376.00,0.00,2,0.00,0.00,0.00,0.00,NULL,3,'IK_1017_2026061832829330',0,0,NULL,'杨女士','13900010004',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,NULL,'2026-06-18 13:15:45',NULL,'2026-06-18 13:11:45',NULL,'2026-06-18 13:38:45','2026-06-18 13:37:45',NULL,0,'156263',NULL,18.80,0.0500,'尾部商家',0.00,9.40),(417,'2026061976794512',1016,2024,NULL,869.00,869.00,0.00,1,5.00,0.00,0.00,0.00,NULL,4,'IK_1016_2026061976794512',0,0,NULL,'冯十一','13800001109','湖南省','长沙市','岳麓区','麓谷大道658号麓谷信息港B座1502',NULL,'湖南省长沙市岳麓区麓谷大道658号麓谷信息港B座1502',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,2,NULL,'2026-06-19 14:06:53',NULL,'2026-06-19 13:58:53',NULL,'2026-06-19 14:03:53','2026-06-19 14:51:53','2026-06-19 15:24:53',0,NULL,NULL,43.45,0.0500,'尾部商家',0.00,15.63),(418,'2026062341179121',1020,2024,7,398.00,398.00,0.00,2,0.00,0.00,0.00,0.00,NULL,5,'IK_1020_2026062341179121',0,0,NULL,'刘先生','13900010001',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,'2026-06-23 15:56:26','2026-06-23 15:26:26',NULL,'2026-06-23 15:40:26',NULL,NULL,0,'852275',NULL,0.00,0.0000,'',0.00,0.00),(419,'2026070518576463',1008,2025,8,35542.00,35542.00,0.00,2,0.00,0.00,0.00,0.00,NULL,2,'IK_1008_2026070518576463',0,0,NULL,'林先生','13900010003',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-05 13:39:03',NULL,'2026-07-05 14:08:03',NULL,NULL,0,'652287',NULL,4265.04,0.1200,'头部商家',0.00,100.00),(420,'2026061348926870',1025,2025,NULL,47781.00,47781.00,0.00,1,5.00,0.00,0.00,0.00,NULL,4,'IK_1025_2026061348926870',0,0,NULL,'张三','13800001101','广东省','深圳市','南山区','科技园路88号创新大厦A座1203',NULL,'广东省深圳市南山区科技园路88号创新大厦A座1203',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,NULL,'2026-06-13 19:45:54',NULL,'2026-06-13 19:44:54',NULL,'2026-06-13 20:02:54','2026-06-13 20:22:54','2026-06-13 20:48:54',0,NULL,NULL,5733.72,0.1200,'头部商家',0.00,100.00),(421,'2026060664575423',1009,2025,NULL,30005.00,30005.00,0.00,1,5.00,0.00,0.00,0.00,NULL,4,'IK_1009_2026060664575423',0,0,NULL,'赵六','13800001104','浙江省','杭州市','西湖区','文三路478号华星时代广场A座2201',NULL,'浙江省杭州市西湖区文三路478号华星时代广场A座2201',NULL,NULL,0.00,0.00,0.00,NULL,NULL,NULL,1,NULL,'2026-06-06 13:41:40',NULL,'2026-06-06 13:31:40',NULL,'2026-06-06 13:39:40','2026-06-06 14:09:40','2026-06-06 14:55:40',0,NULL,NULL,3600.60,0.1200,'头部商家',0.00,100.00);
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
  `distributor_product_id` bigint DEFAULT NULL,
  `commission_rate` decimal(5,2) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `fk_items_order` (`order_id`) USING BTREE,
  KEY `fk_items_sku` (`sku_id`) USING BTREE,
  CONSTRAINT `fk_items_order` FOREIGN KEY (`order_id`) REFERENCES `order` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_items_sku` FOREIGN KEY (`sku_id`) REFERENCES `sku` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=623 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='订单明细表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_item`
--

LOCK TABLES `order_item` WRITE;
/*!40000 ALTER TABLE `order_item` DISABLE KEYS */;
INSERT INTO `order_item` VALUES (91,51,6001,8001,'三只松鼠每日坚果30包礼盒','/static/product/6001.jpg','{\"规格\":\"30包装\",\"净重\":\"600g-750g\"}',77.00,77.00,77.00,1,77.00,77.00,'NORMAL',NULL,NULL),(92,52,6005,8005,'卫龙大面筋68g*10包','/static/product/6005.jpg','{\"规格\":\"68g*10包\",\"口味\":\"香辣味\"}',19.90,19.90,19.90,2,39.80,39.80,'NORMAL',NULL,NULL),(93,53,6009,8009,'阿克苏冰糖心苹果5斤','/static/product/6009.jpg','{\"规格\":\"5斤装\",\"果径\":\"80-85mm\"}',36.90,36.90,36.90,1,36.90,36.90,'NORMAL',NULL,NULL),(94,54,6002,8002,'三只松鼠虎皮风爪袋装','/static/product/6002.jpg','{\"规格\":\"袋装\",\"净重\":\"200g\"}',26.00,26.00,26.00,1,26.00,26.00,'NORMAL',NULL,NULL),(95,54,6004,8004,'旺旺雪饼520g','/static/product/6004.jpg','{\"规格\":\"520g\",\"包装\":\"家庭装\"}',22.90,22.90,22.90,1,22.90,22.90,'NORMAL',NULL,NULL),(96,55,6011,8011,'阳光金果奇异果12粒礼盒','/static/product/6011.jpg','{\"规格\":\"12粒礼盒装\",\"单果\":\"90-110g\"}',118.00,118.00,118.00,1,118.00,118.00,'COUPON',NULL,NULL),(97,56,6006,8006,'良品铺子蛋黄酥6枚','/static/product/6006.jpg','{\"规格\":\"6枚装\",\"净重\":\"330g\"}',35.00,35.00,35.00,1,35.00,35.00,'NORMAL',NULL,NULL),(98,56,6008,8008,'良品铺子雪花酥300g','/static/product/6008.jpg','{\"规格\":\"300g\",\"口味\":\"蔓越莓味\"}',27.90,27.90,27.90,1,27.90,27.90,'NORMAL',NULL,NULL),(99,57,6013,8013,'金龙鱼稻花香大米5kg','/static/product/6013.jpg','{\"规格\":\"5kg\",\"产地\":\"五常\"}',68.00,68.00,68.00,1,68.00,68.00,'NORMAL',NULL,NULL),(100,57,6015,8015,'涪陵清爽榨菜80g*20袋','/static/product/6015.jpg','{\"规格\":\"80g*20袋\",\"口味\":\"清爽\"}',16.90,16.90,16.90,1,16.90,16.90,'NORMAL',NULL,NULL),(201,201,6031,8031,'上海青500g','product/6031.jpg','200g',4.90,4.90,4.90,1,4.90,4.90,'NORMAL',NULL,NULL),(202,202,6012,8012,'沃隆每日坚果750g30袋','product/6012.jpg','500g',85.00,85.00,85.00,2,170.00,170.00,'NORMAL',NULL,NULL),(203,202,6030,8030,'有机西兰花2颗装','product/6030.jpg','500g',15.90,15.90,15.90,1,15.90,15.90,'NORMAL',NULL,NULL),(204,203,6033,8033,'紫甘蓝2颗装','product/6033.jpg','500g',8.90,8.90,8.90,2,17.80,17.80,'NORMAL',NULL,NULL),(205,203,6010,8010,'奉节脐橙8斤装','product/6010.jpg','3瓶装',49.90,49.90,49.90,2,99.80,99.80,'NORMAL',NULL,NULL),(206,204,6032,8032,'新鲜西红柿5斤装','product/6032.jpg','3瓶装',19.90,19.90,19.90,1,19.90,19.90,'NORMAL',NULL,NULL),(207,204,6009,8009,'阿克苏冰糖心苹果5斤装','product/6009.jpg','500ml',36.90,36.90,36.90,1,36.90,36.90,'NORMAL',NULL,NULL),(208,205,6026,8026,'海南金煌芒果5斤装','product/6026.jpg','默认规格',59.90,59.90,59.90,2,119.80,119.80,'NORMAL',NULL,NULL),(209,205,6010,8010,'奉节脐橙8斤装','product/6010.jpg','2瓶装',49.90,49.90,49.90,1,49.90,49.90,'NORMAL',NULL,NULL),(210,205,6029,8029,'云南高山娃娃菜3颗装','product/6029.jpg','200g',12.90,12.90,12.90,1,12.90,12.90,'NORMAL',NULL,NULL),(211,206,6012,8012,'沃隆每日坚果750g30袋','product/6012.jpg','小份',85.00,85.00,85.00,1,85.00,85.00,'NORMAL',NULL,NULL),(212,206,6032,8032,'新鲜西红柿5斤装','product/6032.jpg','2瓶装',19.90,19.90,19.90,1,19.90,19.90,'NORMAL',NULL,NULL),(213,207,6093,8093,'进口水果礼盒','product/6093.jpg','默认规格',198.00,198.00,198.00,1,198.00,198.00,'NORMAL',NULL,NULL),(214,208,6031,8031,'上海青500g','product/6031.jpg','3瓶装',4.90,4.90,4.90,3,14.70,14.70,'NORMAL',NULL,NULL),(215,208,6011,8011,'阳光金果奇异果12粒礼盒','product/6011.jpg','500ml',118.00,118.00,118.00,1,118.00,118.00,'NORMAL',NULL,NULL),(216,209,6026,8026,'海南金煌芒果5斤装','product/6026.jpg','250ml',59.90,59.90,59.90,1,59.90,59.90,'NORMAL',NULL,NULL),(217,209,6031,8031,'上海青500g','product/6031.jpg','大份',4.90,4.90,4.90,1,4.90,4.90,'NORMAL',NULL,NULL),(218,210,6029,8029,'云南高山娃娃菜3颗装','product/6029.jpg','200g',12.90,12.90,12.90,1,12.90,12.90,'NORMAL',NULL,NULL),(219,210,6009,8009,'阿克苏冰糖心苹果5斤装','product/6009.jpg','小份',36.90,36.90,36.90,3,110.70,110.70,'NORMAL',NULL,NULL),(220,211,6011,8011,'阳光金果奇异果12粒礼盒','product/6011.jpg','大份',118.00,118.00,118.00,1,118.00,118.00,'NORMAL',NULL,NULL),(221,211,6027,8027,'新疆无籽红提3斤装','product/6027.jpg','500g',39.90,39.90,39.90,2,79.80,79.80,'NORMAL',NULL,NULL),(222,212,6026,8026,'海南金煌芒果5斤装','product/6026.jpg','小份',59.90,59.90,59.90,2,119.80,119.80,'NORMAL',NULL,NULL),(223,213,6034,8034,'山东大葱3斤装','product/6034.jpg','3瓶装',12.90,12.90,12.90,1,12.90,12.90,'NORMAL',NULL,NULL),(224,213,6031,8031,'上海青500g','product/6031.jpg','200g',4.90,4.90,4.90,3,14.70,14.70,'NORMAL',NULL,NULL),(225,213,6009,8009,'阿克苏冰糖心苹果5斤装','product/6009.jpg','200g',36.90,36.90,36.90,2,73.80,73.80,'NORMAL',NULL,NULL),(226,214,6029,8029,'云南高山娃娃菜3颗装','product/6029.jpg','500g',12.90,12.90,12.90,2,25.80,25.80,'NORMAL',NULL,NULL),(227,214,6093,8093,'进口水果礼盒','product/6093.jpg','小份',198.00,198.00,198.00,1,198.00,198.00,'NORMAL',NULL,NULL),(228,215,6011,8011,'阳光金果奇异果12粒礼盒','product/6011.jpg','500ml',118.00,118.00,118.00,2,236.00,236.00,'NORMAL',NULL,NULL),(229,215,6009,8009,'阿克苏冰糖心苹果5斤装','product/6009.jpg','小份',36.90,36.90,36.90,2,73.80,73.80,'NORMAL',NULL,NULL),(230,216,6029,8029,'云南高山娃娃菜3颗装','product/6029.jpg','250ml',12.90,12.90,12.90,1,12.90,12.90,'NORMAL',NULL,NULL),(231,216,6012,8012,'沃隆每日坚果750g30袋','product/6012.jpg','500g',85.00,85.00,85.00,1,85.00,85.00,'NORMAL',NULL,NULL),(232,217,6034,8034,'山东大葱3斤装','product/6034.jpg','小份',12.90,12.90,12.90,2,25.80,25.80,'NORMAL',NULL,NULL),(233,217,6026,8026,'海南金煌芒果5斤装','product/6026.jpg','大份',59.90,59.90,59.90,3,179.70,179.70,'NORMAL',NULL,NULL),(234,218,6033,8033,'紫甘蓝2颗装','product/6033.jpg','1kg',8.90,8.90,8.90,1,8.90,8.90,'NORMAL',NULL,NULL),(235,219,6030,8030,'有机西兰花2颗装','product/6030.jpg','500g',15.90,15.90,15.90,1,15.90,15.90,'NORMAL',NULL,NULL),(236,219,6034,8034,'山东大葱3斤装','product/6034.jpg','大份',12.90,12.90,12.90,1,12.90,12.90,'NORMAL',NULL,NULL),(237,220,6025,8025,'智利车厘子JJ级2斤装','product/6025.jpg','200g',128.00,128.00,128.00,1,128.00,128.00,'NORMAL',NULL,NULL),(238,220,6027,8027,'新疆无籽红提3斤装','product/6027.jpg','3瓶装',39.90,39.90,39.90,1,39.90,39.90,'NORMAL',NULL,NULL),(239,221,6029,8029,'云南高山娃娃菜3颗装','product/6029.jpg','250ml',12.90,12.90,12.90,1,12.90,12.90,'NORMAL',NULL,NULL),(240,222,6009,8009,'阿克苏冰糖心苹果5斤装','product/6009.jpg','2瓶装',36.90,36.90,36.90,1,36.90,36.90,'NORMAL',NULL,NULL),(241,222,6032,8032,'新鲜西红柿5斤装','product/6032.jpg','大份',19.90,19.90,19.90,1,19.90,19.90,'NORMAL',NULL,NULL),(242,223,6009,8009,'阿克苏冰糖心苹果5斤装','product/6009.jpg','默认规格',36.90,36.90,36.90,2,73.80,73.80,'NORMAL',NULL,NULL),(243,224,6029,8029,'云南高山娃娃菜3颗装','product/6029.jpg','2瓶装',12.90,12.90,12.90,1,12.90,12.90,'NORMAL',NULL,NULL),(244,224,6031,8031,'上海青500g','product/6031.jpg','3瓶装',4.90,4.90,4.90,1,4.90,4.90,'NORMAL',NULL,NULL),(245,225,6093,8093,'进口水果礼盒','product/6093.jpg','默认规格',198.00,198.00,198.00,2,396.00,396.00,'NORMAL',NULL,NULL),(246,225,6012,8012,'沃隆每日坚果750g30袋','product/6012.jpg','2瓶装',85.00,85.00,85.00,1,85.00,85.00,'NORMAL',NULL,NULL),(247,226,6093,8093,'进口水果礼盒','product/6093.jpg','1kg',198.00,198.00,198.00,1,198.00,198.00,'NORMAL',NULL,NULL),(248,226,6011,8011,'阳光金果奇异果12粒礼盒','product/6011.jpg','250ml',118.00,118.00,118.00,1,118.00,118.00,'NORMAL',NULL,NULL),(249,226,6030,8030,'有机西兰花2颗装','product/6030.jpg','小份',15.90,15.90,15.90,1,15.90,15.90,'NORMAL',NULL,NULL),(250,227,6093,8093,'进口水果礼盒','product/6093.jpg','2瓶装',198.00,198.00,198.00,2,396.00,396.00,'NORMAL',NULL,NULL),(251,227,6012,8012,'沃隆每日坚果750g30袋','product/6012.jpg','小份',85.00,85.00,85.00,1,85.00,85.00,'NORMAL',NULL,NULL),(252,227,6029,8029,'云南高山娃娃菜3颗装','product/6029.jpg','2瓶装',12.90,12.90,12.90,1,12.90,12.90,'NORMAL',NULL,NULL),(253,228,6025,8025,'智利车厘子JJ级2斤装','product/6025.jpg','200g',128.00,128.00,128.00,2,256.00,256.00,'NORMAL',NULL,NULL),(254,228,6028,8028,'泰国山竹5斤装','product/6028.jpg','200g',68.00,68.00,68.00,2,136.00,136.00,'NORMAL',NULL,NULL),(255,229,6034,8034,'山东大葱3斤装','product/6034.jpg','500ml',12.90,12.90,12.90,1,12.90,12.90,'NORMAL',NULL,NULL),(256,229,6028,8028,'泰国山竹5斤装','product/6028.jpg','500g',68.00,68.00,68.00,2,136.00,136.00,'NORMAL',NULL,NULL),(257,229,6027,8027,'新疆无籽红提3斤装','product/6027.jpg','小份',39.90,39.90,39.90,3,119.70,119.70,'NORMAL',NULL,NULL),(258,230,6025,8025,'智利车厘子JJ级2斤装','product/6025.jpg','默认规格',128.00,128.00,128.00,1,128.00,128.00,'NORMAL',NULL,NULL),(259,230,6034,8034,'山东大葱3斤装','product/6034.jpg','3瓶装',12.90,12.90,12.90,3,38.70,38.70,'NORMAL',NULL,NULL),(260,230,6011,8011,'阳光金果奇异果12粒礼盒','product/6011.jpg','1kg',118.00,118.00,118.00,2,236.00,236.00,'NORMAL',NULL,NULL),(261,231,6009,8009,'阿克苏冰糖心苹果5斤装','product/6009.jpg','250ml',36.90,36.90,36.90,1,36.90,36.90,'NORMAL',NULL,NULL),(262,231,6010,8010,'奉节脐橙8斤装','product/6010.jpg','3瓶装',49.90,49.90,49.90,1,49.90,49.90,'NORMAL',NULL,NULL),(263,231,6012,8012,'沃隆每日坚果750g30袋','product/6012.jpg','默认规格',85.00,85.00,85.00,1,85.00,85.00,'NORMAL',NULL,NULL),(264,232,6009,8009,'阿克苏冰糖心苹果5斤装','product/6009.jpg','3瓶装',36.90,36.90,36.90,2,73.80,73.80,'NORMAL',NULL,NULL),(265,232,6032,8032,'新鲜西红柿5斤装','product/6032.jpg','500g',19.90,19.90,19.90,2,39.80,39.80,'NORMAL',NULL,NULL),(266,232,6010,8010,'奉节脐橙8斤装','product/6010.jpg','3瓶装',49.90,49.90,49.90,2,99.80,99.80,'NORMAL',NULL,NULL),(267,233,6010,8010,'奉节脐橙8斤装','product/6010.jpg','1kg',49.90,49.90,49.90,1,49.90,49.90,'NORMAL',NULL,NULL),(268,233,6030,8030,'有机西兰花2颗装','product/6030.jpg','500g',15.90,15.90,15.90,3,47.70,47.70,'NORMAL',NULL,NULL),(269,234,6028,8028,'泰国山竹5斤装','product/6028.jpg','小份',68.00,68.00,68.00,1,68.00,68.00,'NORMAL',NULL,NULL),(270,234,6093,8093,'进口水果礼盒','product/6093.jpg','200g',198.00,198.00,198.00,2,396.00,396.00,'NORMAL',NULL,NULL),(271,235,6028,8028,'泰国山竹5斤装','product/6028.jpg','1kg',68.00,68.00,68.00,2,136.00,136.00,'NORMAL',NULL,NULL),(272,235,6026,8026,'海南金煌芒果5斤装','product/6026.jpg','200g',59.90,59.90,59.90,1,59.90,59.90,'NORMAL',NULL,NULL),(273,236,6033,8033,'紫甘蓝2颗装','product/6033.jpg','大份',8.90,8.90,8.90,1,8.90,8.90,'NORMAL',NULL,NULL),(274,237,6025,8025,'智利车厘子JJ级2斤装','product/6025.jpg','250ml',128.00,128.00,128.00,2,256.00,256.00,'NORMAL',NULL,NULL),(275,238,6075,8075,'重庆火锅底料礼盒','product/6075.jpg','3瓶装',68.00,68.00,68.00,2,136.00,136.00,'NORMAL',NULL,NULL),(276,238,6044,8044,'鲍鱼4只装','product/6044.jpg','默认规格',68.00,68.00,68.00,1,68.00,68.00,'NORMAL',NULL,NULL),(277,239,6079,8079,'山西陈醋礼盒','product/6079.jpg','1kg',38.00,38.00,38.00,2,76.00,76.00,'NORMAL',NULL,NULL),(278,239,6039,8039,'肥牛卷500g','product/6039.jpg','250ml',35.90,35.90,35.90,1,35.90,35.90,'NORMAL',NULL,NULL),(279,240,6075,8075,'重庆火锅底料礼盒','product/6075.jpg','500ml',68.00,68.00,68.00,3,204.00,204.00,'NORMAL',NULL,NULL),(280,240,6051,8051,'鸽子整只500g','product/6051.jpg','200g',48.00,48.00,48.00,2,96.00,96.00,'NORMAL',NULL,NULL),(281,241,6092,8092,'春节年货礼盒','product/6092.jpg','大份',298.00,298.00,298.00,1,298.00,298.00,'NORMAL',NULL,NULL),(282,241,6064,8064,'鲁花花生油5L','product/6064.jpg','3瓶装',98.00,98.00,98.00,2,196.00,196.00,'NORMAL',NULL,NULL),(283,242,6049,8049,'老鸭整只2kg','product/6049.jpg','200g',68.00,68.00,68.00,2,136.00,136.00,'NORMAL',NULL,NULL),(284,243,6051,8051,'鸽子整只500g','product/6051.jpg','200g',48.00,48.00,48.00,1,48.00,48.00,'NORMAL',NULL,NULL),(285,243,6035,8035,'黑猪五花肉500g','product/6035.jpg','默认规格',28.90,28.90,28.90,2,57.80,57.80,'NORMAL',NULL,NULL),(286,244,6050,8050,'鹌鹑蛋200g','product/6050.jpg','1kg',12.90,12.90,12.90,1,12.90,12.90,'NORMAL',NULL,NULL),(287,245,6064,8064,'鲁花花生油5L','product/6064.jpg','默认规格',98.00,98.00,98.00,2,196.00,196.00,'NORMAL',NULL,NULL),(288,246,6038,8038,'猪里脊500g','product/6038.jpg','500ml',32.90,32.90,32.90,3,98.70,98.70,'NORMAL',NULL,NULL),(289,246,6066,8066,'东北小米2.5kg','product/6066.jpg','小份',28.90,28.90,28.90,2,57.80,57.80,'NORMAL',NULL,NULL),(290,247,6046,8046,'花甲500g','product/6046.jpg','500ml',15.90,15.90,15.90,2,31.80,31.80,'NORMAL',NULL,NULL),(291,247,6065,8065,'老干妈辣椒酱280g','product/6065.jpg','250ml',12.90,12.90,12.90,2,25.80,25.80,'NORMAL',NULL,NULL),(292,247,6092,8092,'春节年货礼盒','product/6092.jpg','200g',298.00,298.00,298.00,1,298.00,298.00,'NORMAL',NULL,NULL),(293,248,6036,8036,'澳洲牛腩块1kg','product/6036.jpg','250ml',68.00,68.00,68.00,1,68.00,68.00,'NORMAL',NULL,NULL),(294,249,6050,8050,'鹌鹑蛋200g','product/6050.jpg','500ml',12.90,12.90,12.90,1,12.90,12.90,'NORMAL',NULL,NULL),(295,250,6042,8042,'挪威三文鱼500g','product/6042.jpg','250ml',88.00,88.00,88.00,1,88.00,88.00,'NORMAL',NULL,NULL),(296,250,6040,8040,'猪蹄500g','product/6040.jpg','500g',25.90,25.90,25.90,2,51.80,51.80,'NORMAL',NULL,NULL),(297,250,6035,8035,'黑猪五花肉500g','product/6035.jpg','500g',28.90,28.90,28.90,2,57.80,57.80,'NORMAL',NULL,NULL),(298,251,6066,8066,'东北小米2.5kg','product/6066.jpg','3瓶装',28.90,28.90,28.90,1,28.90,28.90,'NORMAL',NULL,NULL),(299,251,6064,8064,'鲁花花生油5L','product/6064.jpg','1kg',98.00,98.00,98.00,2,196.00,196.00,'NORMAL',NULL,NULL),(300,252,6039,8039,'肥牛卷500g','product/6039.jpg','500g',35.90,35.90,35.90,2,71.80,71.80,'NORMAL',NULL,NULL),(301,253,6075,8075,'重庆火锅底料礼盒','product/6075.jpg','3瓶装',68.00,68.00,68.00,1,68.00,68.00,'NORMAL',NULL,NULL),(302,253,6044,8044,'鲍鱼4只装','product/6044.jpg','大份',68.00,68.00,68.00,1,68.00,68.00,'NORMAL',NULL,NULL),(303,254,6014,8014,'海天金标生抽1.9L桶装','product/6014.jpg','1kg',22.90,22.90,22.90,1,22.90,22.90,'NORMAL',NULL,NULL),(304,254,6046,8046,'花甲500g','product/6046.jpg','1kg',15.90,15.90,15.90,3,47.70,47.70,'NORMAL',NULL,NULL),(305,255,6047,8047,'农家土鸡整只1.5kg','product/6047.jpg','3瓶装',58.00,58.00,58.00,2,116.00,116.00,'NORMAL',NULL,NULL),(306,256,6039,8039,'肥牛卷500g','product/6039.jpg','2瓶装',35.90,35.90,35.90,2,71.80,71.80,'NORMAL',NULL,NULL),(307,256,6042,8042,'挪威三文鱼500g','product/6042.jpg','小份',88.00,88.00,88.00,2,176.00,176.00,'NORMAL',NULL,NULL),(308,257,6050,8050,'鹌鹑蛋200g','product/6050.jpg','200g',12.90,12.90,12.90,3,38.70,38.70,'NORMAL',NULL,NULL),(309,258,6092,8092,'春节年货礼盒','product/6092.jpg','小份',298.00,298.00,298.00,1,298.00,298.00,'NORMAL',NULL,NULL),(310,258,6075,8075,'重庆火锅底料礼盒','product/6075.jpg','2瓶装',68.00,68.00,68.00,2,136.00,136.00,'NORMAL',NULL,NULL),(311,259,6041,8041,'厄瓜多尔白虾400g','product/6041.jpg','小份',45.90,45.90,45.90,2,91.80,91.80,'NORMAL',NULL,NULL),(312,259,6042,8042,'挪威三文鱼500g','product/6042.jpg','小份',88.00,88.00,88.00,1,88.00,88.00,'NORMAL',NULL,NULL),(313,259,6065,8065,'老干妈辣椒酱280g','product/6065.jpg','2瓶装',12.90,12.90,12.90,1,12.90,12.90,'NORMAL',NULL,NULL),(314,260,6066,8066,'东北小米2.5kg','product/6066.jpg','500ml',28.90,28.90,28.90,2,57.80,57.80,'NORMAL',NULL,NULL),(315,260,6039,8039,'肥牛卷500g','product/6039.jpg','250ml',35.90,35.90,35.90,3,107.70,107.70,'NORMAL',NULL,NULL),(316,260,6038,8038,'猪里脊500g','product/6038.jpg','小份',32.90,32.90,32.90,1,32.90,32.90,'NORMAL',NULL,NULL),(317,261,6051,8051,'鸽子整只500g','product/6051.jpg','250ml',48.00,48.00,48.00,1,48.00,48.00,'NORMAL',NULL,NULL),(318,262,6075,8075,'重庆火锅底料礼盒','product/6075.jpg','大份',68.00,68.00,68.00,1,68.00,68.00,'NORMAL',NULL,NULL),(319,262,6046,8046,'花甲500g','product/6046.jpg','200g',15.90,15.90,15.90,2,31.80,31.80,'NORMAL',NULL,NULL),(320,263,6040,8040,'猪蹄500g','product/6040.jpg','1kg',25.90,25.90,25.90,1,25.90,25.90,'NORMAL',NULL,NULL),(321,263,6066,8066,'东北小米2.5kg','product/6066.jpg','250ml',28.90,28.90,28.90,1,28.90,28.90,'NORMAL',NULL,NULL),(322,264,6016,8016,'农家红薯宽粉1000g','product/6016.jpg','200g',22.00,22.00,22.00,1,22.00,22.00,'NORMAL',NULL,NULL),(323,264,6036,8036,'澳洲牛腩块1kg','product/6036.jpg','小份',68.00,68.00,68.00,1,68.00,68.00,'NORMAL',NULL,NULL),(324,264,6041,8041,'厄瓜多尔白虾400g','product/6041.jpg','200g',45.90,45.90,45.90,1,45.90,45.90,'NORMAL',NULL,NULL),(325,265,6079,8079,'山西陈醋礼盒','product/6079.jpg','250ml',38.00,38.00,38.00,3,114.00,114.00,'NORMAL',NULL,NULL),(326,265,6014,8014,'海天金标生抽1.9L桶装','product/6014.jpg','250ml',22.90,22.90,22.90,2,45.80,45.80,'NORMAL',NULL,NULL),(327,266,6066,8066,'东北小米2.5kg','product/6066.jpg','3瓶装',28.90,28.90,28.90,1,28.90,28.90,'NORMAL',NULL,NULL),(328,266,6043,8043,'鲜活大闸蟹4只装','product/6043.jpg','500g',198.00,198.00,198.00,2,396.00,396.00,'NORMAL',NULL,NULL),(329,267,6015,8015,'涪陵清爽榨菜80g*20袋','product/6015.jpg','小份',16.90,16.90,16.90,2,33.80,33.80,'NORMAL',NULL,NULL),(330,267,6075,8075,'重庆火锅底料礼盒','product/6075.jpg','200g',68.00,68.00,68.00,2,136.00,136.00,'NORMAL',NULL,NULL),(331,268,6050,8050,'鹌鹑蛋200g','product/6050.jpg','小份',12.90,12.90,12.90,2,25.80,25.80,'NORMAL',NULL,NULL),(332,268,6094,8094,'海鲜礼盒','product/6094.jpg','小份',288.00,288.00,288.00,1,288.00,288.00,'NORMAL',NULL,NULL),(333,269,6094,8094,'海鲜礼盒','product/6094.jpg','3瓶装',288.00,288.00,288.00,1,288.00,288.00,'NORMAL',NULL,NULL),(334,269,6035,8035,'黑猪五花肉500g','product/6035.jpg','500ml',28.90,28.90,28.90,1,28.90,28.90,'NORMAL',NULL,NULL),(335,270,6044,8044,'鲍鱼4只装','product/6044.jpg','500g',68.00,68.00,68.00,1,68.00,68.00,'NORMAL',NULL,NULL),(336,271,6043,8043,'鲜活大闸蟹4只装','product/6043.jpg','200g',198.00,198.00,198.00,1,198.00,198.00,'NORMAL',NULL,NULL),(337,271,6047,8047,'农家土鸡整只1.5kg','product/6047.jpg','大份',58.00,58.00,58.00,2,116.00,116.00,'NORMAL',NULL,NULL),(338,272,6042,8042,'挪威三文鱼500g','product/6042.jpg','1kg',88.00,88.00,88.00,1,88.00,88.00,'NORMAL',NULL,NULL),(339,272,6014,8014,'海天金标生抽1.9L桶装','product/6014.jpg','大份',22.90,22.90,22.90,2,45.80,45.80,'NORMAL',NULL,NULL),(340,273,6040,8040,'猪蹄500g','product/6040.jpg','1kg',25.90,25.90,25.90,3,77.70,77.70,'NORMAL',NULL,NULL),(341,273,6039,8039,'肥牛卷500g','product/6039.jpg','500ml',35.90,35.90,35.90,1,35.90,35.90,'NORMAL',NULL,NULL),(342,273,6079,8079,'山西陈醋礼盒','product/6079.jpg','2瓶装',38.00,38.00,38.00,1,38.00,38.00,'NORMAL',NULL,NULL),(343,274,6015,8015,'涪陵清爽榨菜80g*20袋','product/6015.jpg','默认规格',16.90,16.90,16.90,2,33.80,33.80,'NORMAL',NULL,NULL),(344,274,6044,8044,'鲍鱼4只装','product/6044.jpg','2瓶装',68.00,68.00,68.00,1,68.00,68.00,'NORMAL',NULL,NULL),(345,275,6108,8108,'衣柜收纳架','product/6108.jpg','250ml',58.00,58.00,58.00,1,58.00,58.00,'NORMAL',NULL,NULL),(346,275,6127,8127,'猫砂10kg','product/6127.jpg','200g',58.00,58.00,58.00,1,58.00,58.00,'NORMAL',NULL,NULL),(347,275,6125,8125,'皇家猫粮1.5kg','product/6125.jpg','1kg',98.00,98.00,98.00,1,98.00,98.00,'NORMAL',NULL,NULL),(348,276,6143,8143,'玉兰油精华液','product/6143.jpg','小份',398.00,398.00,398.00,2,796.00,796.00,'NORMAL',NULL,NULL),(349,277,6108,8108,'衣柜收纳架','product/6108.jpg','3瓶装',58.00,58.00,58.00,1,58.00,58.00,'NORMAL',NULL,NULL),(350,277,6104,8104,'厨房吸顶灯','product/6104.jpg','大份',128.00,128.00,128.00,2,256.00,256.00,'NORMAL',NULL,NULL),(351,278,6151,8151,'迪奥香水50ml','product/6151.jpg','1kg',998.00,998.00,998.00,1,998.00,998.00,'NORMAL',NULL,NULL),(352,279,6117,8117,'雨衣加厚','product/6117.jpg','小份',68.00,68.00,68.00,1,68.00,68.00,'NORMAL',NULL,NULL),(353,279,6120,8120,'烫衣板家用','product/6120.jpg','200g',88.00,88.00,88.00,2,176.00,176.00,'NORMAL',NULL,NULL),(354,280,6113,8113,'箭牌马桶盖','product/6113.jpg','3瓶装',88.00,88.00,88.00,1,88.00,88.00,'NORMAL',NULL,NULL),(355,281,6152,8152,'美宝莲口红','product/6152.jpg','大份',128.00,128.00,128.00,2,256.00,256.00,'NORMAL',NULL,NULL),(356,282,6099,8099,'浴巾大号','product/6099.jpg','2瓶装',78.00,78.00,78.00,2,156.00,156.00,'NORMAL',NULL,NULL),(357,282,6149,8149,'电动牙刷','product/6149.jpg','250ml',198.00,198.00,198.00,1,198.00,198.00,'NORMAL',NULL,NULL),(358,283,6151,8151,'迪奥香水50ml','product/6151.jpg','250ml',998.00,998.00,998.00,1,998.00,998.00,'NORMAL',NULL,NULL),(359,284,6108,8108,'衣柜收纳架','product/6108.jpg','200g',58.00,58.00,58.00,1,58.00,58.00,'NORMAL',NULL,NULL),(360,284,6096,8096,'纯棉毛巾3条装','product/6096.jpg','200g',48.00,48.00,48.00,2,96.00,96.00,'NORMAL',NULL,NULL),(361,285,6150,8150,'护舒宝卫生巾','product/6150.jpg','3瓶装',35.00,35.00,35.00,1,35.00,35.00,'NORMAL',NULL,NULL),(362,285,6151,8151,'迪奥香水50ml','product/6151.jpg','默认规格',998.00,998.00,998.00,1,998.00,998.00,'NORMAL',NULL,NULL),(363,286,6099,8099,'浴巾大号','product/6099.jpg','500ml',78.00,78.00,78.00,1,78.00,78.00,'NORMAL',NULL,NULL),(364,287,6149,8149,'电动牙刷','product/6149.jpg','3瓶装',198.00,198.00,198.00,3,594.00,594.00,'NORMAL',NULL,NULL),(365,287,6147,8147,'潘婷护发素300ml','product/6147.jpg','小份',58.00,58.00,58.00,1,58.00,58.00,'NORMAL',NULL,NULL),(366,287,6143,8143,'玉兰油精华液','product/6143.jpg','1kg',398.00,398.00,398.00,1,398.00,398.00,'NORMAL',NULL,NULL),(367,288,6098,8098,'枕头一对','product/6098.jpg','3瓶装',168.00,168.00,168.00,2,336.00,336.00,'NORMAL',NULL,NULL),(368,288,6143,8143,'玉兰油精华液','product/6143.jpg','200g',398.00,398.00,398.00,3,1194.00,1194.00,'NORMAL',NULL,NULL),(369,288,6122,8122,'宜家装饰花瓶','product/6122.jpg','默认规格',68.00,68.00,68.00,3,204.00,204.00,'NORMAL',NULL,NULL),(370,289,6107,8107,'抽屉收纳盒','product/6107.jpg','1kg',28.00,28.00,28.00,1,28.00,28.00,'NORMAL',NULL,NULL),(371,289,6099,8099,'浴巾大号','product/6099.jpg','3瓶装',78.00,78.00,78.00,1,78.00,78.00,'NORMAL',NULL,NULL),(372,290,6152,8152,'美宝莲口红','product/6152.jpg','500ml',128.00,128.00,128.00,2,256.00,256.00,'NORMAL',NULL,NULL),(373,290,6107,8107,'抽屉收纳盒','product/6107.jpg','200g',28.00,28.00,28.00,2,56.00,56.00,'NORMAL',NULL,NULL),(374,291,6103,8103,'床头小夜灯','product/6103.jpg','500g',38.00,38.00,38.00,1,38.00,38.00,'NORMAL',NULL,NULL),(375,291,6150,8150,'护舒宝卫生巾','product/6150.jpg','小份',35.00,35.00,35.00,1,35.00,35.00,'NORMAL',NULL,NULL),(376,292,6145,8145,'多芬身体乳200ml','product/6145.jpg','250ml',48.00,48.00,48.00,2,96.00,96.00,'NORMAL',NULL,NULL),(377,292,6117,8117,'雨衣加厚','product/6117.jpg','2瓶装',68.00,68.00,68.00,1,68.00,68.00,'NORMAL',NULL,NULL),(378,292,6116,8116,'天堂雨伞大号','product/6116.jpg','小份',58.00,58.00,58.00,2,116.00,116.00,'NORMAL',NULL,NULL),(379,293,6146,8146,'潘婷洗发水500ml','product/6146.jpg','默认规格',68.00,68.00,68.00,1,68.00,68.00,'NORMAL',NULL,NULL),(380,293,6150,8150,'护舒宝卫生巾','product/6150.jpg','500g',35.00,35.00,35.00,1,35.00,35.00,'NORMAL',NULL,NULL),(381,294,6097,8097,'蚕丝被冬被','product/6097.jpg','3瓶装',598.00,598.00,598.00,1,598.00,598.00,'NORMAL',NULL,NULL),(382,294,6119,8119,'晾衣架落地','product/6119.jpg','250ml',68.00,68.00,68.00,2,136.00,136.00,'NORMAL',NULL,NULL),(383,294,6125,8125,'皇家猫粮1.5kg','product/6125.jpg','200g',98.00,98.00,98.00,1,98.00,98.00,'NORMAL',NULL,NULL),(384,295,6146,8146,'潘婷洗发水500ml','product/6146.jpg','2瓶装',68.00,68.00,68.00,1,68.00,68.00,'NORMAL',NULL,NULL),(385,295,6100,8100,'欧普LED吸顶灯','product/6100.jpg','2瓶装',198.00,198.00,198.00,2,396.00,396.00,'NORMAL',NULL,NULL),(386,296,6102,8102,'落地灯客厅','product/6102.jpg','大份',158.00,158.00,158.00,2,316.00,316.00,'NORMAL',NULL,NULL),(387,296,6122,8122,'宜家装饰花瓶','product/6122.jpg','500ml',68.00,68.00,68.00,1,68.00,68.00,'NORMAL',NULL,NULL),(388,297,6098,8098,'枕头一对','product/6098.jpg','2瓶装',168.00,168.00,168.00,2,336.00,336.00,'NORMAL',NULL,NULL),(389,298,6099,8099,'浴巾大号','product/6099.jpg','默认规格',78.00,78.00,78.00,1,78.00,78.00,'NORMAL',NULL,NULL),(390,298,6146,8146,'潘婷洗发水500ml','product/6146.jpg','1kg',68.00,68.00,68.00,2,136.00,136.00,'NORMAL',NULL,NULL),(391,299,6118,8118,'防晒衣轻薄','product/6118.jpg','默认规格',88.00,88.00,88.00,1,88.00,88.00,'NORMAL',NULL,NULL),(392,299,6124,8124,'多肉植物组合','product/6124.jpg','500ml',28.00,28.00,28.00,2,56.00,56.00,'NORMAL',NULL,NULL),(393,300,6152,8152,'美宝莲口红','product/6152.jpg','200g',128.00,128.00,128.00,2,256.00,256.00,'NORMAL',NULL,NULL),(394,300,6110,8110,'维达纸巾抽纸3包','product/6110.jpg','200g',28.00,28.00,28.00,2,56.00,56.00,'NORMAL',NULL,NULL),(395,300,6115,8115,'漱口杯套装','product/6115.jpg','默认规格',18.90,18.90,18.90,2,37.80,37.80,'NORMAL',NULL,NULL),(396,301,6102,8102,'落地灯客厅','product/6102.jpg','小份',158.00,158.00,158.00,3,474.00,474.00,'NORMAL',NULL,NULL),(397,301,6111,8111,'消毒湿巾100片','product/6111.jpg','200g',18.90,18.90,18.90,1,18.90,18.90,'NORMAL',NULL,NULL),(398,302,6112,8112,'洁厕灵500ml','product/6112.jpg','小份',12.90,12.90,12.90,3,38.70,38.70,'NORMAL',NULL,NULL),(399,302,6119,8119,'晾衣架落地','product/6119.jpg','小份',68.00,68.00,68.00,1,68.00,68.00,'NORMAL',NULL,NULL),(400,302,6125,8125,'皇家猫粮1.5kg','product/6125.jpg','默认规格',98.00,98.00,98.00,1,98.00,98.00,'NORMAL',NULL,NULL),(401,303,6095,8095,'水星家纺四件套','product/6095.jpg','200g',398.00,398.00,398.00,1,398.00,398.00,'NORMAL',NULL,NULL),(402,304,6125,8125,'皇家猫粮1.5kg','product/6125.jpg','500g',98.00,98.00,98.00,2,196.00,196.00,'NORMAL',NULL,NULL),(403,304,6114,8114,'箭牌花洒套装','product/6114.jpg','2瓶装',398.00,398.00,398.00,1,398.00,398.00,'NORMAL',NULL,NULL),(404,304,6152,8152,'美宝莲口红','product/6152.jpg','大份',128.00,128.00,128.00,1,128.00,128.00,'NORMAL',NULL,NULL),(405,305,6109,8109,'蓝月亮洗衣液3kg','product/6109.jpg','3瓶装',45.00,45.00,45.00,1,45.00,45.00,'NORMAL',NULL,NULL),(406,305,6100,8100,'欧普LED吸顶灯','product/6100.jpg','2瓶装',198.00,198.00,198.00,2,396.00,396.00,'NORMAL',NULL,NULL),(407,305,6119,8119,'晾衣架落地','product/6119.jpg','大份',68.00,68.00,68.00,2,136.00,136.00,'NORMAL',NULL,NULL),(408,306,6116,8116,'天堂雨伞大号','product/6116.jpg','小份',58.00,58.00,58.00,1,58.00,58.00,'NORMAL',NULL,NULL),(409,307,6151,8151,'迪奥香水50ml','product/6151.jpg','1kg',998.00,998.00,998.00,2,1996.00,1996.00,'NORMAL',NULL,NULL),(410,307,6120,8120,'烫衣板家用','product/6120.jpg','默认规格',88.00,88.00,88.00,1,88.00,88.00,'NORMAL',NULL,NULL),(411,308,6109,8109,'蓝月亮洗衣液3kg','product/6109.jpg','200g',45.00,45.00,45.00,2,90.00,90.00,'NORMAL',NULL,NULL),(412,308,6145,8145,'多芬身体乳200ml','product/6145.jpg','500g',48.00,48.00,48.00,2,96.00,96.00,'NORMAL',NULL,NULL),(413,309,6100,8100,'欧普LED吸顶灯','product/6100.jpg','200g',198.00,198.00,198.00,3,594.00,594.00,'NORMAL',NULL,NULL),(414,309,6121,8121,'衣架10个装','product/6121.jpg','500g',12.90,12.90,12.90,1,12.90,12.90,'NORMAL',NULL,NULL),(415,310,6151,8151,'迪奥香水50ml','product/6151.jpg','500g',998.00,998.00,998.00,1,998.00,998.00,'NORMAL',NULL,NULL),(416,310,6142,8142,'欧莱雅面霜','product/6142.jpg','2瓶装',298.00,298.00,298.00,1,298.00,298.00,'NORMAL',NULL,NULL),(417,311,6107,8107,'抽屉收纳盒','product/6107.jpg','200g',28.00,28.00,28.00,2,56.00,56.00,'NORMAL',NULL,NULL),(418,312,6085,8085,'同仁堂阿胶250g','product/6085.jpg','默认规格',398.00,398.00,398.00,2,796.00,796.00,'NORMAL',NULL,NULL),(419,313,6086,8086,'汤臣倍健蛋白粉450g','product/6086.jpg','1kg',328.00,328.00,328.00,1,328.00,328.00,'NORMAL',NULL,NULL),(420,313,6076,8076,'云南鲜花饼礼盒','product/6076.jpg','200g',48.00,48.00,48.00,2,96.00,96.00,'NORMAL',NULL,NULL),(421,313,6073,8073,'茅台飞天53度500ml','product/6073.jpg','默认规格',1499.00,1499.00,1499.00,1,1499.00,1499.00,'NORMAL',NULL,NULL),(422,314,6072,8072,'乐天小熊饼干192g','product/6072.jpg','200g',22.90,22.90,22.90,2,45.80,45.80,'NORMAL',NULL,NULL),(423,314,6080,8080,'西湖龙井250g','product/6080.jpg','2瓶装',128.00,128.00,128.00,3,384.00,384.00,'NORMAL',NULL,NULL),(424,315,6084,8084,'普洱熟茶357g','product/6084.jpg','2瓶装',268.00,268.00,268.00,1,268.00,268.00,'NORMAL',NULL,NULL),(425,315,6076,8076,'云南鲜花饼礼盒','product/6076.jpg','200g',48.00,48.00,48.00,2,96.00,96.00,'NORMAL',NULL,NULL),(426,315,6074,8074,'进口红酒750ml','product/6074.jpg','1kg',298.00,298.00,298.00,2,596.00,596.00,'NORMAL',NULL,NULL),(427,316,6088,8088,'燕窝礼盒装','product/6088.jpg','500g',888.00,888.00,888.00,2,1776.00,1776.00,'NORMAL',NULL,NULL),(428,316,6086,8086,'汤臣倍健蛋白粉450g','product/6086.jpg','默认规格',328.00,328.00,328.00,1,328.00,328.00,'NORMAL',NULL,NULL),(429,316,6076,8076,'云南鲜花饼礼盒','product/6076.jpg','默认规格',48.00,48.00,48.00,1,48.00,48.00,'NORMAL',NULL,NULL),(430,317,6087,8087,'西洋参片100g','product/6087.jpg','大份',168.00,168.00,168.00,1,168.00,168.00,'NORMAL',NULL,NULL),(431,318,6070,8070,'费列罗巧克力T30','product/6070.jpg','默认规格',168.00,168.00,168.00,2,336.00,336.00,'NORMAL',NULL,NULL),(432,319,6088,8088,'燕窝礼盒装','product/6088.jpg','250ml',888.00,888.00,888.00,3,2664.00,2664.00,'NORMAL',NULL,NULL),(433,319,6074,8074,'进口红酒750ml','product/6074.jpg','1kg',298.00,298.00,298.00,1,298.00,298.00,'NORMAL',NULL,NULL),(434,320,6071,8071,'明治巧克力豆100g','product/6071.jpg','250ml',18.90,18.90,18.90,1,18.90,18.90,'NORMAL',NULL,NULL),(435,320,6072,8072,'乐天小熊饼干192g','product/6072.jpg','3瓶装',22.90,22.90,22.90,1,22.90,22.90,'NORMAL',NULL,NULL),(436,320,6084,8084,'普洱熟茶357g','product/6084.jpg','1kg',268.00,268.00,268.00,2,536.00,536.00,'NORMAL',NULL,NULL),(437,321,6076,8076,'云南鲜花饼礼盒','product/6076.jpg','默认规格',48.00,48.00,48.00,1,48.00,48.00,'NORMAL',NULL,NULL),(438,321,6087,8087,'西洋参片100g','product/6087.jpg','250ml',168.00,168.00,168.00,3,504.00,504.00,'NORMAL',NULL,NULL),(439,321,6089,8089,'鱼油软胶囊100粒','product/6089.jpg','1kg',198.00,198.00,198.00,1,198.00,198.00,'NORMAL',NULL,NULL),(440,322,6073,8073,'茅台飞天53度500ml','product/6073.jpg','3瓶装',1499.00,1499.00,1499.00,1,1499.00,1499.00,'NORMAL',NULL,NULL),(441,323,6089,8089,'鱼油软胶囊100粒','product/6089.jpg','200g',198.00,198.00,198.00,1,198.00,198.00,'NORMAL',NULL,NULL),(442,323,6073,8073,'茅台飞天53度500ml','product/6073.jpg','200g',1499.00,1499.00,1499.00,2,2998.00,2998.00,'NORMAL',NULL,NULL),(443,324,6080,8080,'西湖龙井250g','product/6080.jpg','1kg',128.00,128.00,128.00,2,256.00,256.00,'NORMAL',NULL,NULL),(444,324,6089,8089,'鱼油软胶囊100粒','product/6089.jpg','250ml',198.00,198.00,198.00,2,396.00,396.00,'NORMAL',NULL,NULL),(445,325,6086,8086,'汤臣倍健蛋白粉450g','product/6086.jpg','2瓶装',328.00,328.00,328.00,3,984.00,984.00,'NORMAL',NULL,NULL),(446,326,6070,8070,'费列罗巧克力T30','product/6070.jpg','3瓶装',168.00,168.00,168.00,2,336.00,336.00,'NORMAL',NULL,NULL),(447,326,6072,8072,'乐天小熊饼干192g','product/6072.jpg','默认规格',22.90,22.90,22.90,1,22.90,22.90,'NORMAL',NULL,NULL),(448,327,6089,8089,'鱼油软胶囊100粒','product/6089.jpg','200g',198.00,198.00,198.00,1,198.00,198.00,'NORMAL',NULL,NULL),(449,327,6070,8070,'费列罗巧克力T30','product/6070.jpg','1kg',168.00,168.00,168.00,1,168.00,168.00,'NORMAL',NULL,NULL),(450,328,6080,8080,'西湖龙井250g','product/6080.jpg','200g',128.00,128.00,128.00,2,256.00,256.00,'NORMAL',NULL,NULL),(451,328,6076,8076,'云南鲜花饼礼盒','product/6076.jpg','200g',48.00,48.00,48.00,1,48.00,48.00,'NORMAL',NULL,NULL),(452,329,6088,8088,'燕窝礼盒装','product/6088.jpg','2瓶装',888.00,888.00,888.00,1,888.00,888.00,'NORMAL',NULL,NULL),(453,329,6085,8085,'同仁堂阿胶250g','product/6085.jpg','500g',398.00,398.00,398.00,1,398.00,398.00,'NORMAL',NULL,NULL),(454,330,6072,8072,'乐天小熊饼干192g','product/6072.jpg','500g',22.90,22.90,22.90,2,45.80,45.80,'NORMAL',NULL,NULL),(455,330,6081,8081,'铁观音250g','product/6081.jpg','200g',88.00,88.00,88.00,1,88.00,88.00,'NORMAL',NULL,NULL),(456,331,6071,8071,'明治巧克力豆100g','product/6071.jpg','3瓶装',18.90,18.90,18.90,1,18.90,18.90,'NORMAL',NULL,NULL),(457,332,6082,8082,'大红袍100g','product/6082.jpg','250ml',168.00,168.00,168.00,1,168.00,168.00,'NORMAL',NULL,NULL),(458,332,6071,8071,'明治巧克力豆100g','product/6071.jpg','3瓶装',18.90,18.90,18.90,2,37.80,37.80,'NORMAL',NULL,NULL),(459,333,6087,8087,'西洋参片100g','product/6087.jpg','500g',168.00,168.00,168.00,1,168.00,168.00,'NORMAL',NULL,NULL),(460,333,6089,8089,'鱼油软胶囊100粒','product/6089.jpg','3瓶装',198.00,198.00,198.00,1,198.00,198.00,'NORMAL',NULL,NULL),(461,333,6080,8080,'西湖龙井250g','product/6080.jpg','3瓶装',128.00,128.00,128.00,2,256.00,256.00,'NORMAL',NULL,NULL),(462,334,6074,8074,'进口红酒750ml','product/6074.jpg','250ml',298.00,298.00,298.00,1,298.00,298.00,'NORMAL',NULL,NULL),(463,334,6088,8088,'燕窝礼盒装','product/6088.jpg','3瓶装',888.00,888.00,888.00,1,888.00,888.00,'NORMAL',NULL,NULL),(464,335,6071,8071,'明治巧克力豆100g','product/6071.jpg','500g',18.90,18.90,18.90,2,37.80,37.80,'NORMAL',NULL,NULL),(465,335,6082,8082,'大红袍100g','product/6082.jpg','200g',168.00,168.00,168.00,1,168.00,168.00,'NORMAL',NULL,NULL),(466,335,6080,8080,'西湖龙井250g','product/6080.jpg','500g',128.00,128.00,128.00,2,256.00,256.00,'NORMAL',NULL,NULL),(467,336,6073,8073,'茅台飞天53度500ml','product/6073.jpg','500g',1499.00,1499.00,1499.00,2,2998.00,2998.00,'NORMAL',NULL,NULL),(468,337,6073,8073,'茅台飞天53度500ml','product/6073.jpg','250ml',1499.00,1499.00,1499.00,1,1499.00,1499.00,'NORMAL',NULL,NULL),(469,337,6088,8088,'燕窝礼盒装','product/6088.jpg','500g',888.00,888.00,888.00,2,1776.00,1776.00,'NORMAL',NULL,NULL),(470,338,6074,8074,'进口红酒750ml','product/6074.jpg','小份',298.00,298.00,298.00,2,596.00,596.00,'NORMAL',NULL,NULL),(471,338,6080,8080,'西湖龙井250g','product/6080.jpg','1kg',128.00,128.00,128.00,1,128.00,128.00,'NORMAL',NULL,NULL),(472,338,6081,8081,'铁观音250g','product/6081.jpg','大份',88.00,88.00,88.00,1,88.00,88.00,'NORMAL',NULL,NULL),(473,339,6085,8085,'同仁堂阿胶250g','product/6085.jpg','小份',398.00,398.00,398.00,1,398.00,398.00,'NORMAL',NULL,NULL),(474,339,6080,8080,'西湖龙井250g','product/6080.jpg','500g',128.00,128.00,128.00,1,128.00,128.00,'NORMAL',NULL,NULL),(475,340,6080,8080,'西湖龙井250g','product/6080.jpg','500g',128.00,128.00,128.00,3,384.00,384.00,'NORMAL',NULL,NULL),(476,340,6076,8076,'云南鲜花饼礼盒','product/6076.jpg','2瓶装',48.00,48.00,48.00,1,48.00,48.00,'NORMAL',NULL,NULL),(477,341,6088,8088,'燕窝礼盒装','product/6088.jpg','默认规格',888.00,888.00,888.00,1,888.00,888.00,'NORMAL',NULL,NULL),(478,341,6070,8070,'费列罗巧克力T30','product/6070.jpg','默认规格',168.00,168.00,168.00,1,168.00,168.00,'NORMAL',NULL,NULL),(479,342,6084,8084,'普洱熟茶357g','product/6084.jpg','大份',268.00,268.00,268.00,1,268.00,268.00,'NORMAL',NULL,NULL),(480,342,6072,8072,'乐天小熊饼干192g','product/6072.jpg','500g',22.90,22.90,22.90,2,45.80,45.80,'NORMAL',NULL,NULL),(481,343,6071,8071,'明治巧克力豆100g','product/6071.jpg','500g',18.90,18.90,18.90,1,18.90,18.90,'NORMAL',NULL,NULL),(482,344,6076,8076,'云南鲜花饼礼盒','product/6076.jpg','250ml',48.00,48.00,48.00,2,96.00,96.00,'NORMAL',NULL,NULL),(483,344,6087,8087,'西洋参片100g','product/6087.jpg','500g',168.00,168.00,168.00,1,168.00,168.00,'NORMAL',NULL,NULL),(484,345,6002,8002,'三只松鼠虎皮风爪袋装','product/6002.jpg','2瓶装',26.00,26.00,26.00,1,26.00,26.00,'NORMAL',NULL,NULL),(485,346,6004,8004,'旺旺雪饼520g家庭装','product/6004.jpg','小份',22.90,22.90,22.90,1,22.90,22.90,'NORMAL',NULL,NULL),(486,346,6002,8002,'三只松鼠虎皮风爪袋装','product/6002.jpg','200g',26.00,26.00,26.00,1,26.00,26.00,'NORMAL',NULL,NULL),(487,346,6090,8090,'中秋月饼礼盒','product/6090.jpg','250ml',188.00,188.00,188.00,3,564.00,564.00,'NORMAL',NULL,NULL),(488,347,6090,8090,'中秋月饼礼盒','product/6090.jpg','2瓶装',188.00,188.00,188.00,1,188.00,188.00,'NORMAL',NULL,NULL),(489,347,6002,8002,'三只松鼠虎皮风爪袋装','product/6002.jpg','默认规格',26.00,26.00,26.00,2,52.00,52.00,'NORMAL',NULL,NULL),(490,347,6001,8001,'三只松鼠每日坚果30包礼盒','product/6001.jpg','3瓶装',77.00,77.00,77.00,1,77.00,77.00,'NORMAL',NULL,NULL),(491,348,6091,8091,'坚果大礼包','product/6091.jpg','小份',168.00,168.00,168.00,1,168.00,168.00,'NORMAL',NULL,NULL),(492,348,6004,8004,'旺旺雪饼520g家庭装','product/6004.jpg','小份',22.90,22.90,22.90,1,22.90,22.90,'NORMAL',NULL,NULL),(493,349,6008,8008,'良品铺子雪花酥300g','product/6008.jpg','1kg',27.90,27.90,27.90,2,55.80,55.80,'NORMAL',NULL,NULL),(494,350,6007,8007,'良品铺子手工黑芝麻软糕400g','product/6007.jpg','小份',24.90,24.90,24.90,3,74.70,74.70,'NORMAL',NULL,NULL),(495,350,6006,8006,'良品铺子蛋黄酥6枚盒装','product/6006.jpg','2瓶装',35.00,35.00,35.00,1,35.00,35.00,'NORMAL',NULL,NULL),(496,351,6006,8006,'良品铺子蛋黄酥6枚盒装','product/6006.jpg','1kg',35.00,35.00,35.00,1,35.00,35.00,'NORMAL',NULL,NULL),(497,351,6005,8005,'卫龙大面筋68g*10包','product/6005.jpg','3瓶装',19.90,19.90,19.90,1,19.90,19.90,'NORMAL',NULL,NULL),(498,352,6005,8005,'卫龙大面筋68g*10包','product/6005.jpg','默认规格',19.90,19.90,19.90,1,19.90,19.90,'NORMAL',NULL,NULL),(499,353,6055,8055,'速冻包子10只装','product/6055.jpg','3瓶装',28.90,28.90,28.90,2,57.80,57.80,'NORMAL',NULL,NULL),(500,353,6053,8053,'思念汤圆400g','product/6053.jpg','500g',18.90,18.90,18.90,3,56.70,56.70,'NORMAL',NULL,NULL),(501,353,6020,8020,'有友现卤五香鹌鹑蛋300g','product/6020.jpg','200g',16.90,16.90,16.90,1,16.90,16.90,'NORMAL',NULL,NULL),(502,354,6055,8055,'速冻包子10只装','product/6055.jpg','1kg',28.90,28.90,28.90,1,28.90,28.90,'NORMAL',NULL,NULL),(503,354,6017,8017,'有友泡椒凤爪210g袋装','product/6017.jpg','1kg',18.90,18.90,18.90,2,37.80,37.80,'NORMAL',NULL,NULL),(504,354,6058,8058,'麻辣兔头2只装','product/6058.jpg','小份',38.00,38.00,38.00,1,38.00,38.00,'NORMAL',NULL,NULL),(505,355,6018,8018,'绝味香辣鸭脖200g锁鲜装','product/6018.jpg','200g',24.90,24.90,24.90,2,49.80,49.80,'NORMAL',NULL,NULL),(506,356,6058,8058,'麻辣兔头2只装','product/6058.jpg','500g',38.00,38.00,38.00,3,114.00,114.00,'NORMAL',NULL,NULL),(507,357,6059,8059,'哈根达斯冰淇淋81g','product/6059.jpg','250ml',35.00,35.00,35.00,1,35.00,35.00,'NORMAL',NULL,NULL),(508,357,6024,8024,'农夫山泉鲜榨芒果复合果汁1L瓶装','product/6024.jpg','2瓶装',22.90,22.90,22.90,1,22.90,22.90,'NORMAL',NULL,NULL),(509,357,6060,8060,'八喜冰淇淋500ml','product/6060.jpg','500ml',28.00,28.00,28.00,1,28.00,28.00,'NORMAL',NULL,NULL),(510,358,6060,8060,'八喜冰淇淋500ml','product/6060.jpg','小份',28.00,28.00,28.00,1,28.00,28.00,'NORMAL',NULL,NULL),(511,358,6062,8062,'芒果班戟4个装','product/6062.jpg','3瓶装',45.00,45.00,45.00,2,90.00,90.00,'NORMAL',NULL,NULL),(512,359,6023,8023,'元气森林酸奶200g*12盒','product/6023.jpg','1kg',42.90,42.90,42.90,2,85.80,85.80,'NORMAL',NULL,NULL),(513,359,6083,8083,'立顿红茶包100包','product/6083.jpg','500ml',35.00,35.00,35.00,2,70.00,70.00,'NORMAL',NULL,NULL),(514,360,6022,8022,'农夫山泉100%鲜榨橙汁900ml','product/6022.jpg','250ml',19.90,19.90,19.90,1,19.90,19.90,'NORMAL',NULL,NULL),(515,360,6021,8021,'元气森林白桃气泡水480ml*15瓶','product/6021.jpg','200g',65.00,65.00,65.00,2,130.00,130.00,'NORMAL',NULL,NULL),(516,361,6135,8135,'富光玻璃杯350ml','product/6135.jpg','默认规格',38.00,38.00,38.00,1,38.00,38.00,'NORMAL',NULL,NULL),(517,361,6128,8128,'苏泊尔不粘锅32cm','product/6128.jpg','500ml',298.00,298.00,298.00,3,894.00,894.00,'NORMAL',NULL,NULL),(518,361,6131,8131,'张小泉菜刀','product/6131.jpg','大份',68.00,68.00,68.00,1,68.00,68.00,'NORMAL',NULL,NULL),(519,362,6130,8130,'苏泊尔炒锅34cm','product/6130.jpg','250ml',198.00,198.00,198.00,3,594.00,594.00,'NORMAL',NULL,NULL),(520,362,6136,8136,'康宁玻璃碗套装','product/6136.jpg','大份',128.00,128.00,128.00,3,384.00,384.00,'NORMAL',NULL,NULL),(521,363,6129,8129,'苏泊尔压力锅5L','product/6129.jpg','500ml',398.00,398.00,398.00,1,398.00,398.00,'NORMAL',NULL,NULL),(522,363,6131,8131,'张小泉菜刀','product/6131.jpg','2瓶装',68.00,68.00,68.00,1,68.00,68.00,'NORMAL',NULL,NULL),(523,363,6135,8135,'富光玻璃杯350ml','product/6135.jpg','1kg',38.00,38.00,38.00,3,114.00,114.00,'NORMAL',NULL,NULL),(524,364,6128,8128,'苏泊尔不粘锅32cm','product/6128.jpg','1kg',298.00,298.00,298.00,1,298.00,298.00,'NORMAL',NULL,NULL),(525,364,6140,8140,'厨房置物架','product/6140.jpg','250ml',58.00,58.00,58.00,1,58.00,58.00,'NORMAL',NULL,NULL),(526,365,6158,8158,'湿巾80抽','product/6158.jpg','小份',28.00,28.00,28.00,2,56.00,56.00,'NORMAL',NULL,NULL),(527,365,6165,8165,'孕妇装连衣裙','product/6165.jpg','3瓶装',168.00,168.00,168.00,2,336.00,336.00,'NORMAL',NULL,NULL),(528,365,6157,8157,'帮宝适纸尿裤','product/6157.jpg','小份',88.00,88.00,88.00,1,88.00,88.00,'NORMAL',NULL,NULL),(529,366,6156,8156,'亨氏果泥','product/6156.jpg','250ml',35.00,35.00,35.00,1,35.00,35.00,'NORMAL',NULL,NULL),(530,366,6154,8154,'美赞臣奶粉1段','product/6154.jpg','小份',298.00,298.00,298.00,1,298.00,298.00,'NORMAL',NULL,NULL),(531,367,6157,8157,'帮宝适纸尿裤','product/6157.jpg','2瓶装',88.00,88.00,88.00,1,88.00,88.00,'NORMAL',NULL,NULL),(532,367,6155,8155,'亨氏米粉','product/6155.jpg','500g',88.00,88.00,88.00,1,88.00,88.00,'NORMAL',NULL,NULL),(533,367,6167,8167,'婴儿推车','product/6167.jpg','小份',598.00,598.00,598.00,2,1196.00,1196.00,'NORMAL',NULL,NULL),(534,368,6158,8158,'湿巾80抽','product/6158.jpg','500ml',28.00,28.00,28.00,2,56.00,56.00,'NORMAL',NULL,NULL),(535,368,6157,8157,'帮宝适纸尿裤','product/6157.jpg','小份',88.00,88.00,88.00,1,88.00,88.00,'NORMAL',NULL,NULL),(536,369,6169,8169,'新鲜五花肉500g','product/6169.jpg','默认规格',35.00,35.00,35.00,1,35.00,35.00,'NORMAL',NULL,NULL),(537,369,6170,8170,'鲜活基围虾500g','product/6170.jpg','小份',68.00,68.00,68.00,2,136.00,136.00,'NORMAL',NULL,NULL),(538,370,6170,8170,'鲜活基围虾500g','product/6170.jpg','250ml',68.00,68.00,68.00,1,68.00,68.00,'NORMAL',NULL,NULL),(539,371,6169,8169,'新鲜五花肉500g','product/6169.jpg','大份',35.00,35.00,35.00,2,70.00,70.00,'NORMAL',NULL,NULL),(540,372,6169,8169,'新鲜五花肉500g','product/6169.jpg','200g',35.00,35.00,35.00,1,35.00,35.00,'NORMAL',NULL,NULL),(541,372,6170,8170,'鲜活基围虾500g','product/6170.jpg','500g',68.00,68.00,68.00,2,136.00,136.00,'NORMAL',NULL,NULL),(542,373,6172,8172,'五粮液52度500ml','product/6172.jpg','2瓶装',599.00,599.00,599.00,1,599.00,599.00,'NORMAL',NULL,NULL),(543,373,6171,8171,'飞天茅台53度500ml','product/6171.jpg','2瓶装',1499.00,1499.00,1499.00,3,4497.00,4497.00,'NORMAL',NULL,NULL),(544,374,6172,8172,'五粮液52度500ml','product/6172.jpg','500ml',599.00,599.00,599.00,1,599.00,599.00,'NORMAL',NULL,NULL),(545,374,6171,8171,'飞天茅台53度500ml','product/6171.jpg','200g',1499.00,1499.00,1499.00,3,4497.00,4497.00,'NORMAL',NULL,NULL),(546,375,6172,8172,'五粮液52度500ml','product/6172.jpg','2瓶装',599.00,599.00,599.00,1,599.00,599.00,'NORMAL',NULL,NULL),(547,375,6171,8171,'飞天茅台53度500ml','product/6171.jpg','200g',1499.00,1499.00,1499.00,1,1499.00,1499.00,'NORMAL',NULL,NULL),(548,376,6172,8172,'五粮液52度500ml','product/6172.jpg','默认规格',599.00,599.00,599.00,1,599.00,599.00,'NORMAL',NULL,NULL),(549,377,6174,8174,'多肉植物组合6颗','product/6174.jpg','大份',58.00,58.00,58.00,1,58.00,58.00,'NORMAL',NULL,NULL),(550,377,6173,8173,'玫瑰鲜花束11朵','product/6173.jpg','大份',168.00,168.00,168.00,1,168.00,168.00,'NORMAL',NULL,NULL),(551,378,6174,8174,'多肉植物组合6颗','product/6174.jpg','1kg',58.00,58.00,58.00,1,58.00,58.00,'NORMAL',NULL,NULL),(552,378,6173,8173,'玫瑰鲜花束11朵','product/6173.jpg','200g',168.00,168.00,168.00,1,168.00,168.00,'NORMAL',NULL,NULL),(553,379,6174,8174,'多肉植物组合6颗','product/6174.jpg','2瓶装',58.00,58.00,58.00,2,116.00,116.00,'NORMAL',NULL,NULL),(554,379,6173,8173,'玫瑰鲜花束11朵','product/6173.jpg','500g',168.00,168.00,168.00,1,168.00,168.00,'NORMAL',NULL,NULL),(555,380,6174,8174,'多肉植物组合6颗','product/6174.jpg','默认规格',58.00,58.00,58.00,3,174.00,174.00,'NORMAL',NULL,NULL),(556,380,6173,8173,'玫瑰鲜花束11朵','product/6173.jpg','小份',168.00,168.00,168.00,2,336.00,336.00,'NORMAL',NULL,NULL),(557,381,6176,8176,'小米电视55英寸','product/6176.jpg','小份',2999.00,2999.00,2999.00,1,2999.00,2999.00,'NORMAL',NULL,NULL),(558,382,6175,8175,'美的空调1.5匹','product/6175.jpg','500ml',2599.00,2599.00,2599.00,1,2599.00,2599.00,'NORMAL',NULL,NULL),(559,382,6176,8176,'小米电视55英寸','product/6176.jpg','2瓶装',2999.00,2999.00,2999.00,2,5998.00,5998.00,'NORMAL',NULL,NULL),(560,383,6176,8176,'小米电视55英寸','product/6176.jpg','3瓶装',2999.00,2999.00,2999.00,2,5998.00,5998.00,'NORMAL',NULL,NULL),(561,383,6175,8175,'美的空调1.5匹','product/6175.jpg','500ml',2599.00,2599.00,2599.00,1,2599.00,2599.00,'NORMAL',NULL,NULL),(562,384,6176,8176,'小米电视55英寸','product/6176.jpg','小份',2999.00,2999.00,2999.00,2,5998.00,5998.00,'NORMAL',NULL,NULL),(563,384,6175,8175,'美的空调1.5匹','product/6175.jpg','200g',2599.00,2599.00,2599.00,1,2599.00,2599.00,'NORMAL',NULL,NULL),(564,385,6177,8177,'农夫山泉矿泉水550ml*24','product/6177.jpg','500ml',24.90,24.90,24.90,1,24.90,24.90,'NORMAL',NULL,NULL),(565,385,6178,8178,'康师傅方便面5连包','product/6178.jpg','1kg',12.90,12.90,12.90,1,12.90,12.90,'NORMAL',NULL,NULL),(566,386,6178,8178,'康师傅方便面5连包','product/6178.jpg','大份',12.90,12.90,12.90,2,25.80,25.80,'NORMAL',NULL,NULL),(567,386,6177,8177,'农夫山泉矿泉水550ml*24','product/6177.jpg','2瓶装',24.90,24.90,24.90,1,24.90,24.90,'NORMAL',NULL,NULL),(568,387,6177,8177,'农夫山泉矿泉水550ml*24','product/6177.jpg','500g',24.90,24.90,24.90,1,24.90,24.90,'NORMAL',NULL,NULL),(569,387,6178,8178,'康师傅方便面5连包','product/6178.jpg','500g',12.90,12.90,12.90,1,12.90,12.90,'NORMAL',NULL,NULL),(570,388,6177,8177,'农夫山泉矿泉水550ml*24','product/6177.jpg','小份',24.90,24.90,24.90,3,74.70,74.70,'NORMAL',NULL,NULL),(571,388,6178,8178,'康师傅方便面5连包','product/6178.jpg','大份',12.90,12.90,12.90,1,12.90,12.90,'NORMAL',NULL,NULL),(572,389,6179,8179,'普洱茶饼357g','product/6179.jpg','3瓶装',198.00,198.00,198.00,1,198.00,198.00,'NORMAL',NULL,NULL),(573,390,6180,8180,'陶瓷茶具套装','product/6180.jpg','1kg',268.00,268.00,268.00,2,536.00,536.00,'NORMAL',NULL,NULL),(574,390,6179,8179,'普洱茶饼357g','product/6179.jpg','1kg',198.00,198.00,198.00,1,198.00,198.00,'NORMAL',NULL,NULL),(575,391,6180,8180,'陶瓷茶具套装','product/6180.jpg','200g',268.00,268.00,268.00,1,268.00,268.00,'NORMAL',NULL,NULL),(576,392,6180,8180,'陶瓷茶具套装','product/6180.jpg','200g',268.00,268.00,268.00,2,536.00,536.00,'NORMAL',NULL,NULL),(577,392,6179,8179,'普洱茶饼357g','product/6179.jpg','3瓶装',198.00,198.00,198.00,1,198.00,198.00,'NORMAL',NULL,NULL),(578,393,6182,8182,'红木沙发三件套','product/6182.jpg','250ml',8900.00,8900.00,8900.00,1,8900.00,8900.00,'NORMAL',NULL,NULL),(579,393,6181,8181,'红木餐桌1.5米','product/6181.jpg','3瓶装',8800.00,8800.00,8800.00,1,8800.00,8800.00,'NORMAL',NULL,NULL),(580,394,6182,8182,'红木沙发三件套','product/6182.jpg','小份',8900.00,8900.00,8900.00,1,8900.00,8900.00,'NORMAL',NULL,NULL),(581,395,6182,8182,'红木沙发三件套','product/6182.jpg','250ml',8900.00,8900.00,8900.00,1,8900.00,8900.00,'NORMAL',NULL,NULL),(582,395,6181,8181,'红木餐桌1.5米','product/6181.jpg','小份',8800.00,8800.00,8800.00,1,8800.00,8800.00,'NORMAL',NULL,NULL),(583,396,6181,8181,'红木餐桌1.5米','product/6181.jpg','250ml',8800.00,8800.00,8800.00,1,8800.00,8800.00,'NORMAL',NULL,NULL),(584,396,6182,8182,'红木沙发三件套','product/6182.jpg','3瓶装',8900.00,8900.00,8900.00,1,8900.00,8900.00,'NORMAL',NULL,NULL),(585,397,6183,8183,'iPhone 15 Pro 256G','product/6183.jpg','250ml',5688.00,5688.00,5688.00,1,5688.00,5688.00,'NORMAL',NULL,NULL),(586,397,6184,8184,'MacBook Air M3','product/6184.jpg','大份',3298.00,3298.00,3298.00,1,3298.00,3298.00,'NORMAL',NULL,NULL),(587,398,6184,8184,'MacBook Air M3','product/6184.jpg','3瓶装',3298.00,3298.00,3298.00,1,3298.00,3298.00,'NORMAL',NULL,NULL),(588,398,6183,8183,'iPhone 15 Pro 256G','product/6183.jpg','大份',5688.00,5688.00,5688.00,2,11376.00,11376.00,'NORMAL',NULL,NULL),(589,399,6184,8184,'MacBook Air M3','product/6184.jpg','500ml',3298.00,3298.00,3298.00,1,3298.00,3298.00,'NORMAL',NULL,NULL),(590,399,6183,8183,'iPhone 15 Pro 256G','product/6183.jpg','500g',5688.00,5688.00,5688.00,1,5688.00,5688.00,'NORMAL',NULL,NULL),(591,400,6183,8183,'iPhone 15 Pro 256G','product/6183.jpg','大份',5688.00,5688.00,5688.00,3,17064.00,17064.00,'NORMAL',NULL,NULL),(592,400,6184,8184,'MacBook Air M3','product/6184.jpg','500ml',3298.00,3298.00,3298.00,1,3298.00,3298.00,'NORMAL',NULL,NULL),(593,401,6185,8185,'铁观音礼盒装250g','product/6185.jpg','小份',188.00,188.00,188.00,1,188.00,188.00,'NORMAL',NULL,NULL),(594,401,6186,8186,'龙井茶叶250g','product/6186.jpg','500g',288.00,288.00,288.00,1,288.00,288.00,'NORMAL',NULL,NULL),(595,402,6186,8186,'龙井茶叶250g','product/6186.jpg','250ml',288.00,288.00,288.00,1,288.00,288.00,'NORMAL',NULL,NULL),(596,403,6185,8185,'铁观音礼盒装250g','product/6185.jpg','3瓶装',188.00,188.00,188.00,3,564.00,564.00,'NORMAL',NULL,NULL),(597,404,6188,8188,'丝绸床单四件套','product/6188.jpg','2瓶装',1256.00,1256.00,1256.00,1,1256.00,1256.00,'NORMAL',NULL,NULL),(598,405,6188,8188,'丝绸床单四件套','product/6188.jpg','1kg',1256.00,1256.00,1256.00,1,1256.00,1256.00,'NORMAL',NULL,NULL),(599,405,6187,8187,'丝绸旗袍','product/6187.jpg','小份',598.00,598.00,598.00,1,598.00,598.00,'NORMAL',NULL,NULL),(600,406,6187,8187,'丝绸旗袍','product/6187.jpg','3瓶装',598.00,598.00,598.00,1,598.00,598.00,'NORMAL',NULL,NULL),(601,407,6189,8189,'招牌红烧肉','product/6189.jpg','大份',68.00,68.00,68.00,2,136.00,136.00,'NORMAL',NULL,NULL),(602,407,6190,8190,'海鲜炒饭','product/6190.jpg','默认规格',88.00,88.00,88.00,2,176.00,176.00,'NORMAL',NULL,NULL),(603,408,6189,8189,'招牌红烧肉','product/6189.jpg','200g',68.00,68.00,68.00,1,68.00,68.00,'NORMAL',NULL,NULL),(604,409,6190,8190,'海鲜炒饭','product/6190.jpg','250ml',88.00,88.00,88.00,1,88.00,88.00,'NORMAL',NULL,NULL),(605,410,6191,8191,'品牌羽绒服','product/6191.jpg','小份',899.00,899.00,899.00,1,899.00,899.00,'NORMAL',NULL,NULL),(606,410,6192,8192,'羊毛大衣','product/6192.jpg','小份',1299.00,1299.00,1299.00,3,3897.00,3897.00,'NORMAL',NULL,NULL),(607,411,6192,8192,'羊毛大衣','product/6192.jpg','500g',1299.00,1299.00,1299.00,1,1299.00,1299.00,'NORMAL',NULL,NULL),(608,412,6192,8192,'羊毛大衣','product/6192.jpg','200g',1299.00,1299.00,1299.00,2,2598.00,2598.00,'NORMAL',NULL,NULL),(609,412,6191,8191,'品牌羽绒服','product/6191.jpg','1kg',899.00,899.00,899.00,2,1798.00,1798.00,'NORMAL',NULL,NULL),(610,413,6193,8193,'畅销小说套装','product/6193.jpg','3瓶装',88.00,88.00,88.00,1,88.00,88.00,'NORMAL',NULL,NULL),(611,413,6194,8194,'钢笔礼盒套装','product/6194.jpg','小份',168.00,168.00,168.00,1,168.00,168.00,'NORMAL',NULL,NULL),(612,414,6193,8193,'畅销小说套装','product/6193.jpg','500g',88.00,88.00,88.00,1,88.00,88.00,'NORMAL',NULL,NULL),(613,414,6194,8194,'钢笔礼盒套装','product/6194.jpg','2瓶装',168.00,168.00,168.00,3,504.00,504.00,'NORMAL',NULL,NULL),(614,415,6193,8193,'畅销小说套装','product/6193.jpg','2瓶装',88.00,88.00,88.00,1,88.00,88.00,'NORMAL',NULL,NULL),(615,415,6194,8194,'钢笔礼盒套装','product/6194.jpg','3瓶装',168.00,168.00,168.00,2,336.00,336.00,'NORMAL',NULL,NULL),(616,416,6196,8196,'三文鱼刺身1斤','product/6196.jpg','大份',188.00,188.00,188.00,1,188.00,188.00,'NORMAL',NULL,NULL),(617,417,6196,8196,'三文鱼刺身1斤','product/6196.jpg','200g',188.00,188.00,188.00,1,188.00,188.00,'NORMAL',NULL,NULL),(618,418,6195,8195,'波士顿龙虾2斤','product/6195.jpg','小份',398.00,398.00,398.00,2,796.00,796.00,'NORMAL',NULL,NULL),(619,419,6197,8197,'黄金项链20克','product/6197.jpg','500g',8888.00,8888.00,8888.00,1,8888.00,8888.00,'NORMAL',NULL,NULL),(620,420,6198,8198,'钻石戒指1克拉','product/6198.jpg','小份',10000.00,10000.00,10000.00,1,10000.00,10000.00,'NORMAL',NULL,NULL),(621,420,6197,8197,'黄金项链20克','product/6197.jpg','250ml',8888.00,8888.00,8888.00,3,26664.00,26664.00,'NORMAL',NULL,NULL),(622,421,6198,8198,'钻石戒指1克拉','product/6198.jpg','小份',10000.00,10000.00,10000.00,1,10000.00,10000.00,'NORMAL',NULL,NULL);
/*!40000 ALTER TABLE `order_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_review`
--

DROP TABLE IF EXISTS `order_review`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_review` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_id` bigint NOT NULL COMMENT '订单ID',
  `order_sn` varchar(50) DEFAULT NULL COMMENT '订单编号',
  `user_id` bigint DEFAULT NULL COMMENT '用户ID',
  `merchant_id` bigint NOT NULL COMMENT '商家ID',
  `product_id` bigint DEFAULT NULL COMMENT '商品ID',
  `rating` tinyint NOT NULL COMMENT '评分 1-5',
  `content` text COMMENT '评价内容',
  `images` varchar(1000) DEFAULT NULL COMMENT '评价图片,逗号分隔',
  `is_anonymous` tinyint DEFAULT '0' COMMENT '0=实名 1=匿名',
  `appeal_status` tinyint DEFAULT '0' COMMENT '0=正常展示 1=申诉中 2=已屏蔽 3=申诉驳回',
  `appeal_reason` varchar(500) DEFAULT NULL COMMENT '申诉原因',
  `appeal_evidence` varchar(1000) DEFAULT NULL COMMENT '申诉证明材料(图片路径,逗号分隔)',
  `appeal_time` datetime DEFAULT NULL COMMENT '申诉时间',
  `audit_result` varchar(200) DEFAULT NULL COMMENT '审核结果说明',
  `audit_time` datetime DEFAULT NULL COMMENT '审核时间',
  `create_time` datetime DEFAULT NULL COMMENT '评价时间',
  PRIMARY KEY (`id`),
  KEY `idx_order_id` (`order_id`),
  KEY `idx_merchant_id` (`merchant_id`),
  KEY `idx_rating` (`merchant_id`,`rating`),
  KEY `idx_appeal` (`appeal_status`)
) ENGINE=InnoDB AUTO_INCREMENT=328 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='订单评价表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_review`
--

LOCK TABLES `order_review` WRITE;
/*!40000 ALTER TABLE `order_review` DISABLE KEYS */;
INSERT INTO `order_review` VALUES (1,52,'202605061420010002',1004,2002,NULL,5,'商品不错，物流很快。整体满意，值得推荐给朋友。','',0,0,NULL,NULL,NULL,NULL,NULL,'2026-05-17 14:20:00'),(2,55,'202605091130010005',1004,2003,NULL,3,'商品不错，物流很快。整体满意，值得推荐给朋友。','',0,0,NULL,NULL,NULL,NULL,NULL,'2026-05-20 11:30:00'),(3,56,'202605100850020006',1009,2002,NULL,5,'商品不错，物流很快。整体满意，下次还会再来购买的。','',0,0,NULL,NULL,NULL,NULL,NULL,'2026-05-12 08:50:00'),(4,57,'202605121310010007',1010,2004,NULL,3,'商品不错，物流很快。整体满意，下次还会再来购买的。','',0,0,NULL,NULL,NULL,NULL,NULL,'2026-05-23 13:10:00'),(5,58,'202605141025010008',1004,2001,NULL,4,'商品不错，物流很快。整体满意，值得推荐给朋友。','',0,0,NULL,NULL,NULL,NULL,NULL,'2026-05-24 10:25:00'),(6,59,'202605170940010009',1011,2005,NULL,4,'商品不错，物流很快。整体满意，值得推荐给朋友。','',0,0,NULL,NULL,NULL,NULL,NULL,'2026-05-27 09:40:00'),(7,60,'202605181520010010',1012,2006,NULL,4,'商品不错，物流很快。整体满意，值得推荐给朋友。','',0,0,NULL,NULL,NULL,NULL,NULL,'2026-05-22 15:20:00'),(8,61,'202605201105020011',1004,2002,NULL,3,'商品不错，物流很快。整体满意，值得推荐给朋友。','',0,0,NULL,NULL,NULL,NULL,NULL,'2026-05-23 11:05:00'),(9,62,'202605211430010012',1013,2003,NULL,4,'商品不错，物流很快。整体满意，下次还会再来购买的。','',0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-01 14:30:00'),(10,65,'202605251650020015',1014,2001,NULL,5,'商品不错，物流很快。整体满意，值得推荐给朋友。','',0,0,NULL,NULL,NULL,NULL,NULL,'2026-05-28 16:50:00'),(11,67,'202605291345010017',1004,2002,NULL,5,'商品不错，物流很快。整体满意，值得推荐给朋友。','',0,0,NULL,NULL,NULL,NULL,NULL,'2026-05-31 13:45:00'),(12,71,'202606050915010021',1010,2001,NULL,5,'商品不错，物流很快。整体满意，下次还会再来购买的。','',0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-12 09:15:00'),(13,72,'202606071630020022',1011,2003,NULL,4,'商品不错，物流很快。整体满意，下次还会再来购买的。','',0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-12 16:30:00'),(14,73,'202606091145010023',1008,2005,NULL,3,'商品不错，物流很快。整体满意，下次还会再来购买的。','',0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-19 11:45:00'),(15,75,'202606121510020025',1004,2001,NULL,4,'商品不错，物流很快。整体满意，下次还会再来购买的。','',0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-22 15:10:00'),(16,78,'202606151620010028',1009,2005,NULL,4,'商品不错，物流很快。整体满意，下次还会再来购买的。','',0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-23 16:20:00'),(17,79,'202606150950010029',1018,2005,NULL,4,'商品不错，物流很快。整体满意，值得推荐给朋友。','',0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-17 09:50:00'),(18,80,'202606171130010030',1004,2002,NULL,2,'商品不错，物流很快。整体满意，下次还会再来购买的。','',0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-26 11:30:00'),(19,83,'202606211445010033',1013,2004,NULL,5,'商品不错，物流很快。整体满意，值得推荐给朋友。','',0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-23 14:45:00'),(20,84,'202606221000020034',1010,2002,NULL,5,'商品不错，物流很快。整体满意，值得推荐给朋友。','',0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-26 10:00:00'),(21,86,'202606241720020036',1019,2003,NULL,3,'商品不错，物流很快。整体满意，值得推荐给朋友。','',0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-26 17:20:00'),(22,100,'2026060298990796',1009,2003,NULL,4,'商品不错，物流很快。整体满意，下次还会再来购买的。','',0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-10 19:25:36'),(23,207,'2026053171265235',1018,2003,NULL,4,'商品不错，物流很快。整体满意，下次还会再来购买的。','',0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-10 14:16:16'),(24,210,'2026050821264682',1011,2003,NULL,4,'商品不错，物流很快。整体满意，值得推荐给朋友。','',0,0,NULL,NULL,NULL,NULL,NULL,'2026-05-13 17:53:47'),(25,211,'2026061874700746',1014,2003,NULL,4,'商品不错，物流很快。整体满意，下次还会再来购买的。','',0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-20 08:51:46'),(26,231,'2026063080420241',1013,2003,NULL,5,'商品不错，物流很快。整体满意，值得推荐给朋友。','',0,0,NULL,NULL,NULL,NULL,NULL,'2026-07-02 19:13:00'),(27,234,'2026060980645408',1025,2003,NULL,5,'商品不错，物流很快。整体满意，值得推荐给朋友。','',0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-20 11:32:05'),(28,236,'2026062992475481',1023,2003,NULL,5,'商品不错，物流很快。整体满意，值得推荐给朋友。','',0,0,NULL,NULL,NULL,NULL,NULL,'2026-07-01 20:14:21'),(29,238,'2026062914712339',1018,2004,NULL,5,'商品不错，物流很快。整体满意，值得推荐给朋友。','',0,0,NULL,NULL,NULL,NULL,NULL,'2026-07-04 11:16:34'),(30,239,'2026061448865507',1017,2004,NULL,3,'商品不错，物流很快。整体满意，下次还会再来购买的。','',0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-25 16:19:01'),(31,243,'2026060693666956',1023,2004,NULL,5,'商品不错，物流很快。整体满意，值得推荐给朋友。','',0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-08 14:03:04'),(32,254,'2026052759686800',1016,2004,NULL,4,'商品不错，物流很快。整体满意，值得推荐给朋友。','',0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-03 12:42:25'),(33,257,'2026052196399347',1009,2004,NULL,4,'商品不错，物流很快。整体满意，下次还会再来购买的。','',0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-01 11:16:11'),(34,263,'2026051985672258',1019,2004,NULL,4,'商品不错，物流很快。整体满意，下次还会再来购买的。','',0,0,NULL,NULL,NULL,NULL,NULL,'2026-05-23 17:07:46'),(35,265,'2026052177076787',1022,2004,NULL,4,'商品不错，物流很快。整体满意，下次还会再来购买的。','',0,0,NULL,NULL,NULL,NULL,NULL,'2026-05-26 09:31:17'),(36,267,'2026070527423935',1025,2004,NULL,5,'商品不错，物流很快。整体满意，值得推荐给朋友。','',0,0,NULL,NULL,NULL,NULL,NULL,'2026-07-15 14:13:11'),(37,268,'2026060667737142',1011,2004,NULL,2,'商品不错，物流很快。整体满意，下次还会再来购买的。','',0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-10 21:00:52'),(38,274,'2026060319245285',1024,2004,NULL,5,'商品不错，物流很快。整体满意，值得推荐给朋友。','',0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-06 09:19:26'),(39,275,'2026052255709501',1013,2007,NULL,4,'商品不错，物流很快。整体满意，下次还会再来购买的。','',0,0,NULL,NULL,NULL,NULL,NULL,'2026-05-24 10:18:13'),(40,280,'2026051119658083',1023,2007,NULL,4,'商品不错，物流很快。整体满意，值得推荐给朋友。','',0,0,NULL,NULL,NULL,NULL,NULL,'2026-05-15 12:09:36'),(41,294,'2026050821595893',1015,2007,NULL,4,'商品不错，物流很快。整体满意，下次还会再来购买的。','',0,0,NULL,NULL,NULL,NULL,NULL,'2026-05-19 21:36:33'),(42,298,'2026061085563186',1023,2007,NULL,5,'商品不错，物流很快。整体满意，值得推荐给朋友。','',0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-14 19:05:45'),(43,300,'2026061087499722',1011,2007,NULL,5,'商品不错，物流很快。整体满意，值得推荐给朋友。','',0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-13 14:54:01'),(44,301,'2026052830126648',1020,2007,NULL,5,'商品不错，物流很快。整体满意，下次还会再来购买的。','',0,0,NULL,NULL,NULL,NULL,NULL,'2026-05-31 13:52:33'),(45,307,'2026052453976616',1018,2007,NULL,4,'商品不错，物流很快。整体满意，值得推荐给朋友。','',0,0,NULL,NULL,NULL,NULL,NULL,'2026-05-29 11:47:19'),(46,311,'2026060645302327',1022,2007,NULL,5,'商品不错，物流很快。整体满意，下次还会再来购买的。','',0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-14 12:55:41'),(47,320,'2026051583285764',1017,2010,NULL,5,'商品不错，物流很快。整体满意，值得推荐给朋友。','',0,0,NULL,NULL,NULL,NULL,NULL,'2026-05-21 15:05:33'),(48,324,'2026051616008224',1022,2010,NULL,4,'商品不错，物流很快。整体满意，值得推荐给朋友。','',0,0,NULL,NULL,NULL,NULL,NULL,'2026-05-25 19:02:50'),(49,327,'2026052165114976',1022,2010,NULL,5,'商品不错，物流很快。整体满意，下次还会再来购买的。','',0,0,NULL,NULL,NULL,NULL,NULL,'2026-05-29 15:27:21'),(50,328,'2026051863738448',1010,2010,NULL,5,'商品不错，物流很快。整体满意，值得推荐给朋友。','',0,0,NULL,NULL,NULL,NULL,NULL,'2026-05-24 11:12:38'),(51,335,'2026052588904680',1013,2010,NULL,4,'商品不错，物流很快。整体满意，值得推荐给朋友。','',0,0,NULL,NULL,NULL,NULL,NULL,'2026-05-27 20:38:01'),(52,345,'2026052343291095',1022,2001,NULL,5,'商品不错，物流很快。整体满意，值得推荐给朋友。','',0,0,NULL,NULL,NULL,NULL,NULL,'2026-05-25 12:29:32'),(53,348,'2026062533617003',1020,2001,NULL,3,'商品不错，物流很快。整体满意，值得推荐给朋友。','',0,0,NULL,NULL,NULL,NULL,NULL,'2026-07-05 21:16:24'),(54,352,'2026062957260654',1021,2002,NULL,5,'商品不错，物流很快。整体满意，下次还会再来购买的。','',0,0,NULL,NULL,NULL,NULL,NULL,'2026-07-06 10:24:08'),(55,354,'2026062340245613',1014,2005,NULL,4,'商品不错，物流很快。整体满意，值得推荐给朋友。','',0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-28 21:17:58'),(56,362,'2026062840943917',1024,2008,NULL,5,'商品不错，物流很快。整体满意，值得推荐给朋友。','',0,0,NULL,NULL,NULL,NULL,NULL,'2026-07-06 19:43:32'),(57,367,'2026051383704112',1008,2009,NULL,4,'商品不错，物流很快。整体满意，值得推荐给朋友。','',0,0,NULL,NULL,NULL,NULL,NULL,'2026-05-16 10:37:49'),(58,372,'2026062928936692',1024,2011,NULL,5,'商品不错，物流很快。整体满意，值得推荐给朋友。','',0,0,NULL,NULL,NULL,NULL,NULL,'2026-07-04 20:35:50'),(59,375,'2026052359552897',1009,2012,NULL,4,'商品不错，物流很快。整体满意，下次还会再来购买的。','',0,0,NULL,NULL,NULL,NULL,NULL,'2026-05-30 20:34:58'),(60,376,'2026062974661490',1007,2012,NULL,4,'商品不错，物流很快。整体满意，值得推荐给朋友。','',0,0,NULL,NULL,NULL,NULL,NULL,'2026-07-02 17:22:36'),(61,378,'2026052948675960',1020,2013,NULL,5,'商品不错，物流很快。整体满意，值得推荐给朋友。','',0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-01 15:25:09'),(62,382,'2026062376027270',1020,2014,NULL,4,'商品不错，物流很快。整体满意，下次还会再来购买的。','',0,0,NULL,NULL,NULL,NULL,NULL,'2026-07-03 19:23:00'),(63,386,'2026050892958463',1014,2015,NULL,5,'商品不错，物流很快。整体满意，下次还会再来购买的。','',0,0,NULL,NULL,NULL,NULL,NULL,'2026-05-12 18:33:53'),(64,387,'2026052618045217',1024,2015,NULL,5,'商品不错，物流很快。整体满意，下次还会再来购买的。','',0,0,NULL,NULL,NULL,NULL,NULL,'2026-05-28 17:39:40'),(65,388,'2026060136180340',1025,2015,NULL,5,'商品不错，物流很快。整体满意，下次还会再来购买的。','',0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-03 09:12:19'),(66,390,'2026060841393846',1023,2016,NULL,5,'商品不错，物流很快。整体满意，值得推荐给朋友。','',0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-18 09:47:09'),(67,398,'2026060999423841',1008,2018,NULL,4,'商品不错，物流很快。整体满意，下次还会再来购买的。','',0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-17 10:17:35'),(68,399,'2026051763811208',1013,2018,NULL,3,'商品不错，物流很快。整体满意，下次还会再来购买的。','',0,0,NULL,NULL,NULL,NULL,NULL,'2026-05-20 15:40:02'),(69,403,'2026051143644699',1025,2019,NULL,4,'商品不错，物流很快。整体满意，值得推荐给朋友。','',0,0,NULL,NULL,NULL,NULL,NULL,'2026-05-17 19:03:51'),(70,404,'2026051869902538',1020,2020,NULL,3,'商品不错，物流很快。整体满意，值得推荐给朋友。','',0,0,NULL,NULL,NULL,NULL,NULL,'2026-05-27 18:25:37'),(71,410,'2026051459841212',1024,2022,NULL,5,'商品不错，物流很快。整体满意，下次还会再来购买的。','',0,0,NULL,NULL,NULL,NULL,NULL,'2026-05-19 11:10:13'),(72,415,'2026061156266139',1017,2023,NULL,4,'商品不错，物流很快。整体满意，值得推荐给朋友。','',0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-14 16:13:33'),(73,417,'2026061976794512',1016,2024,NULL,4,'商品不错，物流很快。整体满意，值得推荐给朋友。','',0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-29 13:58:53'),(74,420,'2026061348926870',1025,2025,NULL,5,'商品不错，物流很快。整体满意，下次还会再来购买的。','',0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-23 19:44:54'),(75,421,'2026060664575423',1009,2025,NULL,4,'商品不错，物流很快。整体满意，值得推荐给朋友。','',0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-13 13:31:40'),(128,51,'202605051030010001',1004,2001,NULL,1,'客服态度不好，处理问题很慢，不会再买了。','',0,0,NULL,NULL,NULL,NULL,NULL,'2026-05-08 10:30:00'),(129,53,'202605070915020003',1007,2003,NULL,1,'快递包装破损，东西有瑕疵，不太满意。','',0,1,'该用户存在恶意差评嫌疑，证据已上传','/static/license/1001.jpg','2026-07-05 10:00:00',NULL,NULL,'2026-05-14 09:15:00'),(130,77,'202606141430020027',1009,2003,NULL,1,'客服态度不好，处理问题很慢，不会再买了。','',0,1,'该用户存在恶意差评嫌疑，证据已上传','/static/license/1001.jpg','2026-07-05 10:00:00',NULL,NULL,'2026-06-23 14:30:00'),(131,85,'202606230930010035',1007,2005,NULL,2,'商品质量太差了，和描述完全不符，非常失望。','',0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-28 09:30:00'),(132,89,'202606291005010039',1008,2001,NULL,1,'快递包装破损，东西有瑕疵，不太满意。','',0,0,NULL,NULL,NULL,NULL,NULL,'2026-07-05 10:05:00'),(133,203,'2026060298990796',1009,2003,NULL,1,'快递包装破损，东西有瑕疵，不太满意。','',0,1,'该用户存在恶意差评嫌疑，证据已上传','/static/license/1001.jpg','2026-07-05 10:00:00',NULL,NULL,'2026-06-05 19:25:36'),(134,242,'2026051332168452',1017,2004,NULL,1,'快递包装破损，东西有瑕疵，不太满意。','',0,1,'竞争对手恶意评价，请求平台核实屏蔽','/static/license/1002.jpg','2026-07-04 15:00:00',NULL,NULL,'2026-05-16 17:27:11'),(135,286,'2026060614657899',1009,2007,NULL,2,'快递包装破损，东西有瑕疵，不太满意。','',0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-14 12:58:18'),(136,308,'2026060424554610',1009,2007,NULL,1,'快递包装破损，东西有瑕疵，不太满意。','',0,3,'商家申诉（历史已驳回）','/static/license/1002.jpg','2026-07-02 09:00:00','经平台核实，评价内容属实，申诉驳回','2026-07-03 16:00:00','2026-06-13 10:59:46'),(137,329,'2026060880497267',1013,2010,NULL,1,'客服态度不好，处理问题很慢，不会再买了。','',0,2,'已核实为虚假评价（历史申诉已处理）','/static/license/1001.jpg','2026-07-01 08:00:00','经核实该评价为用户恶意差评，予以屏蔽处理','2026-07-03 14:00:00','2026-06-18 09:03:04'),(138,332,'2026052144271022',1018,2010,NULL,1,'快递包装破损，东西有瑕疵，不太满意。','',0,2,'已核实为虚假评价（历史申诉已处理）','/static/license/1001.jpg','2026-07-01 08:00:00','经核实该评价为用户恶意差评，予以屏蔽处理','2026-07-03 14:00:00','2026-05-26 11:26:43'),(139,353,'2026060590421947',1020,2005,NULL,1,'商品质量太差了，和描述完全不符，非常失望。','',0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-12 10:32:11'),(140,360,'2026062630828420',1014,2006,NULL,1,'商品质量太差了，和描述完全不符，非常失望。','',0,0,NULL,NULL,NULL,NULL,NULL,'2026-07-05 19:12:53'),(141,373,'2026053081842532',1018,2012,NULL,2,'商品质量太差了，和描述完全不符，非常失望。','',0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-04 18:08:00'),(142,392,'2026051685862009',1011,2016,NULL,2,'商品质量太差了，和描述完全不符，非常失望。','',0,0,NULL,NULL,NULL,NULL,NULL,'2026-05-26 21:31:03'),(143,68,'202605301120010018',1015,2004,NULL,5,'商品质量很好，物流快，服务态度佳。已经是第3次购买了。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-07 11:20:00'),(144,69,'202606011030010019',1004,2004,NULL,5,'商品质量很好，物流快，服务态度佳。已经是第3次购买了。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-14 10:30:00'),(145,202,'2026053076870731',1010,2003,NULL,3,'商品质量很好，物流快，服务态度佳。已经是第3次购买了。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-02 17:30:42'),(146,219,'2026053123156047',1023,2003,NULL,4,'商品质量很好，物流快，服务态度佳。已经是第2次购买了。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-12 18:35:13'),(147,247,'2026070115208655',1007,2004,NULL,4,'商品质量很好，物流快，服务态度佳。已经是第3次购买了。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-07-10 15:10:12'),(148,252,'2026061634183893',1019,2004,NULL,4,'商品质量很好，物流快，服务态度佳。已经是第3次购买了。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-20 10:24:51'),(149,256,'2026061755393756',1008,2004,NULL,5,'商品质量很好，物流快，服务态度佳。已经是第4次购买了。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-24 13:47:05'),(150,271,'2026062417756140',1025,2004,NULL,4,'商品质量很好，物流快，服务态度佳。已经是第1次购买了。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-26 20:09:33'),(151,273,'2026060345187042',1020,2004,NULL,4,'商品质量很好，物流快，服务态度佳。已经是第3次购买了。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-16 17:58:28'),(152,276,'2026052438739667',1012,2007,NULL,4,'商品质量很好，物流快，服务态度佳。已经是第1次购买了。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-01 21:19:42'),(153,284,'2026051375153367',1016,2007,NULL,5,'商品质量很好，物流快，服务态度佳。已经是第3次购买了。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-05-22 10:55:58'),(154,312,'2026070280707928',1013,2010,NULL,4,'商品质量很好，物流快，服务态度佳。已经是第3次购买了。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-07-09 10:30:53'),(155,315,'2026061828204754',1021,2010,NULL,4,'商品质量很好，物流快，服务态度佳。已经是第4次购买了。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-27 12:27:11'),(156,325,'2026060190351554',1025,2010,NULL,5,'商品质量很好，物流快，服务态度佳。已经是第4次购买了。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-14 08:44:40'),(157,336,'2026053186859429',1020,2010,NULL,3,'商品质量很好，物流快，服务态度佳。已经是第5次购买了。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-03 11:39:34'),(158,337,'2026051880992610',1021,2010,NULL,5,'商品质量很好，物流快，服务态度佳。已经是第4次购买了。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-05-27 14:10:55'),(174,53,'202605070915020003',1007,2003,NULL,3,'商品不错，物流很快。整体满意，值得推荐给朋友。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-05-11 09:15:00'),(175,54,'202605081645010004',1008,2001,NULL,3,'商品不错，物流很快。整体满意，下次还会再来购买的。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-05-16 16:45:00'),(176,57,'202605121310010007',1010,2004,NULL,3,'商品不错，物流很快。整体满意，下次还会再来购买的。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-05-21 13:10:00'),(177,60,'202605181520010010',1012,2006,NULL,5,'商品不错，物流很快。整体满意，值得推荐给朋友。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-05-29 15:20:00'),(178,68,'202605301120010018',1015,2004,NULL,4,'商品不错，物流很快。整体满意，下次还会再来购买的。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-10 11:20:00'),(179,70,'202606031400020020',1007,2002,NULL,5,'商品不错，物流很快。整体满意，值得推荐给朋友。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-10 14:00:00'),(180,71,'202606050915010021',1010,2001,NULL,5,'商品不错，物流很快。整体满意，下次还会再来购买的。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-16 09:15:00'),(181,73,'202606091145010023',1008,2005,NULL,5,'商品不错，物流很快。整体满意，值得推荐给朋友。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-12 11:45:00'),(182,77,'202606141430020027',1009,2003,NULL,3,'商品不错，物流很快。整体满意，值得推荐给朋友。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-18 14:30:00'),(183,84,'202606221000020034',1010,2002,NULL,4,'商品不错，物流很快。整体满意，值得推荐给朋友。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-27 10:00:00'),(184,88,'202606271530020038',1020,2002,NULL,5,'商品不错，物流很快。整体满意，值得推荐给朋友。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-07-02 15:30:00'),(185,210,'2026050821264682',1011,2003,NULL,4,'商品不错，物流很快。整体满意，值得推荐给朋友。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-05-12 17:53:47'),(186,243,'2026060693666956',1023,2004,NULL,5,'商品不错，物流很快。整体满意，值得推荐给朋友。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-10 14:03:04'),(187,247,'2026070115208655',1007,2004,NULL,2,'商品不错，物流很快。整体满意，值得推荐给朋友。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-07-03 15:10:12'),(188,252,'2026061634183893',1019,2004,NULL,5,'商品不错，物流很快。整体满意，下次还会再来购买的。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-23 10:24:51'),(189,275,'2026052255709501',1013,2007,NULL,5,'商品不错，物流很快。整体满意，值得推荐给朋友。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-05-31 10:18:13'),(190,284,'2026051375153367',1016,2007,NULL,3,'商品不错，物流很快。整体满意，下次还会再来购买的。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-05-19 10:55:58'),(191,307,'2026052453976616',1018,2007,NULL,4,'商品不错，物流很快。整体满意，下次还会再来购买的。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-05-30 11:47:19'),(192,312,'2026070280707928',1013,2010,NULL,1,'商品不错，物流很快。整体满意，下次还会再来购买的。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-07-11 10:30:53'),(193,324,'2026051616008224',1022,2010,NULL,4,'商品不错，物流很快。整体满意，下次还会再来购买的。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-05-25 19:02:50'),(194,327,'2026052165114976',1022,2010,NULL,3,'商品不错，物流很快。整体满意，下次还会再来购买的。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-05-28 15:27:21'),(195,329,'2026060880497267',1013,2010,NULL,4,'商品不错，物流很快。整体满意，值得推荐给朋友。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-13 09:03:04'),(196,332,'2026052144271022',1018,2010,NULL,4,'商品不错，物流很快。整体满意，值得推荐给朋友。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-05-26 11:26:43'),(197,337,'2026051880992610',1021,2010,NULL,4,'商品不错，物流很快。整体满意，值得推荐给朋友。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-05-22 14:10:55'),(198,350,'2026060144249233',1022,2002,NULL,3,'商品不错，物流很快。整体满意，值得推荐给朋友。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-10 16:09:26'),(199,354,'2026062340245613',1014,2005,NULL,3,'商品不错，物流很快。整体满意，值得推荐给朋友。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-25 21:17:58'),(200,357,'2026053115978445',1009,2006,NULL,3,'商品不错，物流很快。整体满意，值得推荐给朋友。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-11 08:56:34'),(201,360,'2026062630828420',1014,2006,NULL,4,'商品不错，物流很快。整体满意，值得推荐给朋友。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-28 19:12:53'),(202,371,'2026051259444446',1009,2011,NULL,4,'商品不错，物流很快。整体满意，值得推荐给朋友。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-05-20 13:05:37'),(203,372,'2026062928936692',1024,2011,NULL,4,'商品不错，物流很快。整体满意，下次还会再来购买的。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-07-05 20:35:50'),(204,374,'2026052097397439',1008,2012,NULL,2,'商品不错，物流很快。整体满意，值得推荐给朋友。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-05-26 09:13:23'),(205,382,'2026062376027270',1020,2014,NULL,4,'商品不错，物流很快。整体满意，值得推荐给朋友。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-30 19:23:00'),(206,386,'2026050892958463',1014,2015,NULL,4,'商品不错，物流很快。整体满意，值得推荐给朋友。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-05-12 18:33:53'),(207,390,'2026060841393846',1023,2016,NULL,4,'商品不错，物流很快。整体满意，值得推荐给朋友。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-16 09:47:09'),(208,401,'2026052778506444',1016,2019,NULL,4,'商品不错，物流很快。整体满意，下次还会再来购买的。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-03 13:54:29'),(209,403,'2026051143644699',1025,2019,NULL,4,'商品不错，物流很快。整体满意，下次还会再来购买的。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-05-20 19:03:51'),(210,409,'2026051439276159',1013,2021,NULL,3,'商品不错，物流很快。整体满意，下次还会再来购买的。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-05-25 16:09:12'),(211,410,'2026051459841212',1024,2022,NULL,3,'商品不错，物流很快。整体满意，值得推荐给朋友。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-05-24 11:10:13'),(212,411,'2026051772736864',1011,2022,NULL,5,'商品不错，物流很快。整体满意，下次还会再来购买的。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-05-26 13:22:11'),(213,421,'2026060664575423',1009,2025,NULL,4,'商品不错，物流很快。整体满意，下次还会再来购买的。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-15 13:31:40'),(237,56,'202605100850020006',1009,2002,NULL,1,'快递包装破损，东西有瑕疵，不太满意。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-05-14 08:50:00'),(238,57,'202605121310010007',1010,2004,NULL,1,'商品质量太差了，和描述完全不符，非常失望。',NULL,0,1,'竞争对手恶意评价，请求平台核实屏蔽','/static/license/1002.jpg','2026-07-04 15:00:00',NULL,NULL,'2026-05-21 13:10:00'),(239,58,'202605141025010008',1004,2001,NULL,2,'快递包装破损，东西有瑕疵，不太满意。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-05-21 10:25:00'),(240,60,'202605181520010010',1012,2006,NULL,2,'快递包装破损，东西有瑕疵，不太满意。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-05-24 15:20:00'),(241,65,'202605251650020015',1014,2001,NULL,1,'快递包装破损，东西有瑕疵，不太满意。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-04 16:50:00'),(242,67,'202605291345010017',1004,2002,NULL,1,'快递包装破损，东西有瑕疵，不太满意。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-07 13:45:00'),(243,73,'202606091145010023',1008,2005,NULL,1,'商品质量太差了，和描述完全不符，非常失望。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-13 11:45:00'),(244,79,'202606150950010029',1018,2005,NULL,1,'快递包装破损，东西有瑕疵，不太满意。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-19 09:50:00'),(245,83,'202606211445010033',1013,2004,NULL,2,'商品质量太差了，和描述完全不符，非常失望。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-07-01 14:45:00'),(246,100,'2026060298990796',1009,2003,NULL,1,'客服态度不好，处理问题很慢，不会再买了。',NULL,0,1,'该用户存在恶意差评嫌疑，证据已上传','/static/license/1001.jpg','2026-07-05 10:00:00',NULL,NULL,'2026-06-05 19:25:36'),(247,211,'2026061874700746',1014,2003,NULL,2,'快递包装破损，东西有瑕疵，不太满意。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-28 08:51:46'),(248,231,'2026063080420241',1013,2003,NULL,1,'快递包装破损，东西有瑕疵，不太满意。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-07-04 19:13:00'),(249,254,'2026052759686800',1016,2004,NULL,2,'商品质量太差了，和描述完全不符，非常失望。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-03 12:42:25'),(250,263,'2026051985672258',1019,2004,NULL,2,'快递包装破损，东西有瑕疵，不太满意。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-05-22 17:07:46'),(251,286,'2026060614657899',1009,2007,NULL,1,'快递包装破损，东西有瑕疵，不太满意。',NULL,0,3,'商家申诉（历史已驳回）','/static/license/1002.jpg','2026-07-02 09:00:00','经平台核实，评价内容属实，申诉驳回','2026-07-03 16:00:00','2026-06-10 12:58:18'),(252,53,'202605070915020003',1007,2003,NULL,5,'已经是第5次购买了，质量稳定。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-05-18 09:15:00'),(253,62,'202605211430010012',1013,2003,NULL,5,'已经是第5次购买了，质量稳定。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-05-30 14:30:00'),(254,203,'2026060298990796',1009,2003,NULL,5,'已经是第2次购买了，质量稳定。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-12 19:25:36'),(255,239,'2026061448865507',1017,2004,NULL,5,'已经是第5次购买了，质量稳定。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-18 16:19:01'),(256,267,'2026070527423935',1025,2004,NULL,5,'已经是第3次购买了，质量稳定。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-07-11 14:13:11'),(257,271,'2026062417756140',1025,2004,NULL,4,'已经是第3次购买了，质量稳定。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-07-04 20:09:33'),(258,294,'2026050821595893',1015,2007,NULL,4,'已经是第5次购买了，质量稳定。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-05-11 21:36:33'),(259,300,'2026061087499722',1011,2007,NULL,3,'已经是第3次购买了，质量稳定。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-21 14:54:01'),(267,59,'202605170940010009',1011,2005,NULL,5,'商品不错，物流很快。整体满意，下次还会再来购买的。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-05-22 09:40:00'),(268,64,'202605241000010014',1007,2005,NULL,4,'商品不错，物流很快。整体满意，下次还会再来购买的。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-05-27 10:00:00'),(269,69,'202606011030010019',1004,2004,NULL,3,'商品不错，物流很快。整体满意，下次还会再来购买的。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-07 10:30:00'),(270,78,'202606151620010028',1009,2005,NULL,5,'商品不错，物流很快。整体满意，值得推荐给朋友。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-22 16:20:00'),(271,80,'202606171130010030',1004,2002,NULL,2,'商品不错，物流很快。整体满意，值得推荐给朋友。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-26 11:30:00'),(272,210,'2026050821264682',1011,2003,NULL,4,'商品不错，物流很快。整体满意，值得推荐给朋友。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-05-13 17:53:47'),(273,219,'2026053123156047',1023,2003,NULL,4,'商品不错，物流很快。整体满意，值得推荐给朋友。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-04 18:35:13'),(274,256,'2026061755393756',1008,2004,NULL,5,'商品不错，物流很快。整体满意，值得推荐给朋友。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-23 13:47:05'),(275,263,'2026051985672258',1019,2004,NULL,4,'商品不错，物流很快。整体满意，值得推荐给朋友。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-05-29 17:07:46'),(276,265,'2026052177076787',1022,2004,NULL,4,'商品不错，物流很快。整体满意，值得推荐给朋友。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-05-24 09:31:17'),(277,268,'2026060667737142',1011,2004,NULL,3,'商品不错，物流很快。整体满意，值得推荐给朋友。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-08 21:00:52'),(278,275,'2026052255709501',1013,2007,NULL,4,'商品不错，物流很快。整体满意，下次还会再来购买的。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-05-24 10:18:13'),(279,294,'2026050821595893',1015,2007,NULL,3,'商品不错，物流很快。整体满意，值得推荐给朋友。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-05-13 21:36:33'),(280,298,'2026061085563186',1023,2007,NULL,5,'商品不错，物流很快。整体满意，下次还会再来购买的。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-15 19:05:45'),(281,315,'2026061828204754',1021,2010,NULL,5,'商品不错，物流很快。整体满意，值得推荐给朋友。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-26 12:27:11'),(282,327,'2026052165114976',1022,2010,NULL,3,'商品不错，物流很快。整体满意，下次还会再来购买的。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-05-31 15:27:21'),(283,328,'2026051863738448',1010,2010,NULL,4,'商品不错，物流很快。整体满意，值得推荐给朋友。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-05-22 11:12:38'),(284,345,'2026052343291095',1022,2001,NULL,3,'商品不错，物流很快。整体满意，下次还会再来购买的。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-05-25 12:29:32'),(285,346,'2026051013476931',1012,2001,NULL,4,'商品不错，物流很快。整体满意，下次还会再来购买的。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-05-12 09:07:54'),(286,348,'2026062533617003',1020,2001,NULL,4,'商品不错，物流很快。整体满意，下次还会再来购买的。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-30 21:16:24'),(287,350,'2026060144249233',1022,2002,NULL,5,'商品不错，物流很快。整体满意，值得推荐给朋友。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-07 16:09:26'),(288,362,'2026062840943917',1024,2008,NULL,4,'商品不错，物流很快。整体满意，下次还会再来购买的。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-07-05 19:43:32'),(289,371,'2026051259444446',1009,2011,NULL,4,'商品不错，物流很快。整体满意，值得推荐给朋友。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-05-14 13:05:37'),(290,372,'2026062928936692',1024,2011,NULL,4,'商品不错，物流很快。整体满意，值得推荐给朋友。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-07-06 20:35:50'),(291,373,'2026053081842532',1018,2012,NULL,5,'商品不错，物流很快。整体满意，下次还会再来购买的。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-05 18:08:00'),(292,378,'2026052948675960',1020,2013,NULL,5,'商品不错，物流很快。整体满意，值得推荐给朋友。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-01 15:25:09'),(293,379,'2026052943210169',1015,2013,NULL,5,'商品不错，物流很快。整体满意，值得推荐给朋友。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-09 12:27:20'),(294,388,'2026060136180340',1025,2015,NULL,3,'商品不错，物流很快。整体满意，下次还会再来购买的。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-09 09:12:19'),(295,390,'2026060841393846',1023,2016,NULL,5,'商品不错，物流很快。整体满意，值得推荐给朋友。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-15 09:47:09'),(296,392,'2026051685862009',1011,2016,NULL,4,'商品不错，物流很快。整体满意，值得推荐给朋友。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-05-18 21:31:03'),(297,414,'2026062719117381',1016,2023,NULL,5,'商品不错，物流很快。整体满意，值得推荐给朋友。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-30 12:11:42'),(298,54,'202605081645010004',1008,2001,NULL,2,'快递包装破损，东西有瑕疵，不太满意。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-05-14 16:45:00'),(299,56,'202605100850020006',1009,2002,NULL,1,'快递包装破损，东西有瑕疵，不太满意。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-05-13 08:50:00'),(300,58,'202605141025010008',1004,2001,NULL,2,'快递包装破损，东西有瑕疵，不太满意。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-05-19 10:25:00'),(301,65,'202605251650020015',1014,2001,NULL,1,'商品质量太差了，和描述完全不符，非常失望。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-02 16:50:00'),(302,75,'202606121510020025',1004,2001,NULL,2,'快递包装破损，东西有瑕疵，不太满意。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-21 15:10:00'),(303,82,'202606201015010032',1010,2006,NULL,1,'商品质量太差了，和描述完全不符，非常失望。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-24 10:15:00'),(304,83,'202606211445010033',1013,2004,NULL,2,'商品质量太差了，和描述完全不符，非常失望。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-28 14:45:00'),(305,89,'202606291005010039',1008,2001,NULL,1,'客服态度不好，处理问题很慢，不会再买了。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-07-08 10:05:00'),(306,219,'2026053123156047',1023,2003,NULL,2,'客服态度不好，处理问题很慢，不会再买了。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-04 18:35:13'),(307,267,'2026070527423935',1025,2004,NULL,1,'商品质量太差了，和描述完全不符，非常失望。',NULL,0,1,'竞争对手恶意评价，请求平台核实屏蔽','/static/license/1002.jpg','2026-07-04 15:00:00',NULL,NULL,'2026-07-13 14:13:11'),(308,274,'2026060319245285',1024,2004,NULL,1,'商品质量太差了，和描述完全不符，非常失望。',NULL,0,1,'竞争对手恶意评价，请求平台核实屏蔽','/static/license/1002.jpg','2026-07-04 15:00:00',NULL,NULL,'2026-06-10 09:19:26'),(309,276,'2026052438739667',1012,2007,NULL,2,'客服态度不好，处理问题很慢，不会再买了。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-03 21:19:42'),(310,280,'2026051119658083',1023,2007,NULL,1,'快递包装破损，东西有瑕疵，不太满意。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-05-18 12:09:36'),(311,284,'2026051375153367',1016,2007,NULL,2,'商品质量太差了，和描述完全不符，非常失望。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-05-17 10:55:58'),(312,315,'2026061828204754',1021,2010,NULL,2,'快递包装破损，东西有瑕疵，不太满意。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-26 12:27:11'),(313,236,'2026062992475481',1023,2003,NULL,5,'已经是第1次购买了，质量稳定。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-07-11 20:14:21'),(314,257,'2026052196399347',1009,2004,NULL,4,'已经是第1次购买了，质量稳定。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-05-27 11:16:11'),(315,268,'2026060667737142',1011,2004,NULL,5,'已经是第2次购买了，质量稳定。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-14 21:00:52'),(316,274,'2026060319245285',1024,2004,NULL,4,'已经是第2次购买了，质量稳定。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-13 09:19:26'),(317,301,'2026052830126648',1020,2007,NULL,5,'已经是第3次购买了，质量稳定。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-06 13:52:33'),(318,308,'2026060424554610',1009,2007,NULL,5,'已经是第4次购买了，质量稳定。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-09 10:59:46'),(319,320,'2026051583285764',1017,2010,NULL,3,'已经是第3次购买了，质量稳定。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-05-17 15:05:33'),(320,325,'2026060190351554',1025,2010,NULL,3,'已经是第3次购买了，质量稳定。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-04 08:44:40'),(321,329,'2026060880497267',1013,2010,NULL,4,'已经是第5次购买了，质量稳定。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-18 09:03:04'),(322,335,'2026052588904680',1013,2010,NULL,4,'已经是第2次购买了，质量稳定。',NULL,0,0,NULL,NULL,NULL,NULL,NULL,'2026-06-07 20:38:01');
/*!40000 ALTER TABLE `order_review` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='订单状态流水表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_status_log`
--

LOCK TABLES `order_status_log` WRITE;
/*!40000 ALTER TABLE `order_status_log` DISABLE KEYS */;
INSERT INTO `order_status_log` VALUES (1,93,0,5,'CANCELLED','SYSTEM',NULL,'支付超时自动取消','2026-07-04 03:32:46'),(2,95,0,5,'CANCELLED','SYSTEM',NULL,'支付超时自动取消','2026-07-04 03:32:46'),(3,97,0,5,'CANCELLED','SYSTEM',NULL,'支付超时自动取消','2026-07-06 10:48:37');
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
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
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
INSERT INTO `pickup_point` VALUES (7,2001,'润禾生活食铺自提点','重庆市渝中区解放西路126号附8号','17782224500',NULL,1,1,NULL,'2026-05-10 10:00:00',NULL,NULL,NULL),(8,2002,'食愈小站自提点','重庆市大渡口区新山村春晖路66号','17782224501',NULL,1,1,NULL,'2026-05-10 10:00:00',NULL,NULL,NULL),(9,2003,'鲜禧果仓自提点','重庆市巴南区龙洲湾渝南大道132号','17782224502',NULL,1,1,NULL,'2026-05-10 10:00:00',NULL,NULL,NULL);
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
  `force_off_shelf` tinyint DEFAULT '0' COMMENT '管理员强制下架标记 0-正常 1-强制下架不可恢复',
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
) ENGINE=InnoDB AUTO_INCREMENT=6199 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='商品主表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product`
--

LOCK TABLES `product` WRITE;
/*!40000 ALTER TABLE `product` DISABLE KEYS */;
INSERT INTO `product` VALUES (6001,5001,2001,'三只松鼠每日坚果30包礼盒','果仁饱满 营养均衡','/static/product/6001.jpg','<p>混合坚果独立小袋，全家代餐零食</p>',NULL,3,1,0,1,NULL,'2026-07-06 09:26:07',NULL,'2026-07-06 09:26:07',35),(6002,5001,2001,'三只松鼠虎皮风爪袋装','软烂脱骨 卤香入味','/static/product/6002.jpg','<p>老卤慢炖鸡爪，追剧网红即食卤味零食</p>',NULL,3,1,0,1,NULL,'2026-07-06 09:26:07',NULL,'2026-07-06 09:26:07',25),(6003,5002,2001,'良品铺子芒果干500g大包装','果肉厚实 酸甜不腻','/static/product/6003.jpg','<p>鲜芒果低温烘干，无过多添加蜜饯</p>',NULL,3,1,0,1,NULL,'2026-07-06 09:26:07',NULL,'2026-07-06 09:26:07',18),(6004,5004,2001,'旺旺雪饼520g家庭装','酥脆米香 童年味道','/static/product/6004.jpg','<p>经典膨化米饼，办公室家庭常备小零食</p>',NULL,3,1,0,1,NULL,'2026-07-06 09:26:07',NULL,'2026-07-06 09:26:07',42),(6005,5003,2002,'卫龙大面筋68g*10包','香辣劲道 解馋小吃','/static/product/6005.jpg','<p>经典麻辣辣条，便携独立小包办公室零食</p>',NULL,3,1,0,1,NULL,'2026-07-06 09:26:07',NULL,'2026-07-06 09:26:07',28),(6006,5002,2002,'良品铺子蛋黄酥6枚盒装','绵密沙糯 多层馅料','/static/product/6006.jpg','<p>雪媚娘红豆咸蛋黄点心，下午茶糕点</p>',NULL,3,1,0,1,NULL,'2026-07-06 09:26:07',NULL,'2026-07-06 09:26:07',15),(6007,5002,2002,'良品铺子手工黑芝麻软糕400g','软糯香甜 无添加蔗糖','/static/product/6007.jpg','<p>传统手工糕点，老人小孩均可食用</p>',NULL,3,1,0,1,NULL,'2026-07-06 09:26:07',NULL,'2026-07-06 09:26:07',12),(6008,5002,2002,'良品铺子雪花酥300g','奶香浓郁 坚果混合','/static/product/6008.jpg','<p>牛轧雪花酥，蔓越莓坚果组合网红点心</p>',NULL,3,1,0,1,NULL,'2026-07-06 09:26:07',NULL,'2026-07-06 09:26:07',32),(6009,5005,2003,'阿克苏冰糖心苹果5斤装','产地直发 甜脆多汁','/static/product/6009.jpg','<p>正宗阿克苏冰糖心苹果，果园现摘冷链直达</p>',NULL,3,1,0,1,NULL,'2026-07-06 09:26:07',NULL,'2026-07-06 09:26:07',48),(6010,5005,2003,'奉节脐橙8斤装','重庆本地鲜果 爆汁清甜','/static/product/6010.jpg','<p>奉节核心产区脐橙，皮薄无渣现摘现发</p>',NULL,3,1,0,1,NULL,'2026-07-06 09:26:07',NULL,'2026-07-06 09:26:07',35),(6011,5005,2003,'阳光金果奇异果12粒礼盒','高维C 香甜软嫩','/static/product/6011.jpg','<p>新西兰进口奇异果，高端送礼鲜果礼盒</p>',NULL,3,1,0,1,NULL,'2026-07-06 09:26:07',NULL,'2026-07-06 09:26:07',22),(6012,5006,2003,'沃隆每日坚果750g30袋','科学配比 孕妇可食','/static/product/6012.jpg','<p>无添加盐糖，独立小袋适合每日代餐</p>',NULL,3,1,0,1,NULL,'2026-07-06 09:26:07',NULL,'2026-07-06 09:26:07',55),(6013,5007,2004,'金龙鱼稻花香大米5kg袋装','米油丰厚 软糯香甜','/static/product/6013.jpg','<p>东北五常产区大米，家用煮饭首选</p>',NULL,3,1,0,1,NULL,'2026-07-06 09:26:07',NULL,'2026-07-06 09:26:07',20),(6014,5007,2004,'海天金标生抽1.9L桶装','粮食酿造 凉拌红烧通用','/static/product/6014.jpg','<p>180天酿造酱油，鲜香味足家用调味</p>',NULL,3,1,0,1,NULL,'2026-07-06 09:26:07',NULL,'2026-07-06 09:26:07',12),(6015,5008,2004,'涪陵清爽榨菜80g*20袋','重庆特产 配粥下饭小菜','/static/product/6015.jpg','<p>地道涪陵榨菜，低盐清爽独立小包</p>',NULL,3,1,0,1,NULL,'2026-07-06 09:26:07',NULL,'2026-07-06 09:26:07',22),(6016,5003,2004,'农家红薯宽粉1000g','久煮不烂 火锅炖菜专用','/static/product/6016.jpg','<p>纯红薯手工制作宽粉条，无胶无添加</p>',NULL,3,1,0,1,NULL,'2026-07-06 09:26:07',NULL,'2026-07-06 09:26:07',8),(6017,5010,2005,'有友泡椒凤爪210g袋装','重庆经典 酸辣入味','/static/product/6017.jpg','<p>地道山椒泡凤爪，追剧解馋网红卤味</p>',NULL,2,1,0,1,NULL,'2026-07-06 09:26:07',NULL,'2026-07-06 09:26:07',65),(6018,5009,2005,'绝味香辣鸭脖200g锁鲜装','鲜卤现发 麻辣够味','/static/product/6018.jpg','<p>气调锁鲜鸭脖，开袋即食熟食</p>',NULL,2,1,0,1,NULL,'2026-07-06 09:26:07',NULL,'2026-07-06 09:26:07',42),(6019,5009,2005,'绝味原切牛肉脯150g','肉质紧实 肉香浓郁','/static/product/6019.jpg','<p>谷饲牛肉制作肉干，无淀粉添加</p>',NULL,2,1,0,1,NULL,'2026-07-06 09:26:07',NULL,'2026-07-06 09:26:07',35),(6020,5010,2005,'有友现卤五香鹌鹑蛋300g','卤香浓郁 独立小包','/static/product/6020.jpg','<p>手工老卤慢炖鹌鹑蛋，日常解馋小食</p>',NULL,2,1,0,1,NULL,'2026-07-06 09:26:07',NULL,'2026-07-06 09:26:07',78),(6021,5011,2006,'元气森林白桃气泡水480ml*15瓶','0糖0脂0卡 清爽解腻','/static/product/6021.jpg','<p>白桃果味苏打汽水，冰镇夏日饮品</p>',NULL,3,1,0,1,NULL,'2026-07-06 09:26:07',NULL,'2026-07-06 09:26:07',38),(6022,5012,2006,'农夫山泉100%鲜榨橙汁900ml','鲜果原榨 无浓缩还原','/static/product/6022.jpg','<p>新鲜橙子压榨果汁，家庭日常饮品</p>',NULL,3,1,0,1,NULL,'2026-07-06 09:26:07',NULL,'2026-07-06 09:26:07',22),(6023,5011,2006,'元气森林酸奶200g*12盒','浓稠顺滑 早餐代餐','/static/product/6023.jpg','<p>生牛乳发酵常温酸奶，儿童老人均可饮用</p>',NULL,3,1,0,1,NULL,'2026-07-06 09:26:07',NULL,'2026-07-06 09:26:07',18),(6024,5011,2006,'农夫山泉鲜榨芒果复合果汁1L瓶装','果香浓郁 冰镇更好喝','/static/product/6024.jpg','<p>多种热带水果复配果汁，聚会分享饮品</p>',NULL,3,1,0,1,NULL,'2026-07-06 09:26:07',NULL,'2026-07-06 09:26:07',45),(6025,5005,2003,'智利车厘子JJ级2斤装','进口鲜果 颗颗饱满','/static/product/6025.jpg','<p>智利空运车厘子，新鲜直达，甜蜜多汁</p>','/product_detail/6025.jpg',2,1,0,1,'审核通过','2026-06-16 10:00:00','2026-06-16 09:00:00','2026-06-16 09:00:00',0),(6026,5005,2003,'海南金煌芒果5斤装','核小肉厚 香甜多汁','/static/product/6026.jpg','<p>海南产地直发金煌芒果，果肉金黄细腻</p>','/product_detail/6026.jpg',2,1,0,1,'审核通过','2026-06-16 11:00:00','2026-06-16 10:30:00','2026-06-16 10:30:00',0),(6027,5005,2003,'新疆无籽红提3斤装','脆甜爽口 无籽多汁','/static/product/6027.jpg','<p>新疆吐鲁番无籽红提，阳光充足甜度高</p>','/product_detail/6027.jpg',2,1,0,1,'审核通过','2026-06-17 10:00:00','2026-06-17 09:00:00','2026-06-17 09:00:00',0),(6028,5005,2003,'泰国山竹5斤装','软糯清甜 果肉饱满','/static/product/6028.jpg','<p>泰国进口山竹，新鲜采摘，香甜可口</p>','/product_detail/6028.jpg',2,1,0,1,'审核通过','2026-06-17 11:00:00','2026-06-17 10:30:00','2026-06-17 10:30:00',0),(6029,5013,2003,'云南高山娃娃菜3颗装','清甜脆嫩 无公害','/static/product/6029.jpg','<p>云南高山种植娃娃菜，口感清甜脆嫩</p>','/product_detail/6029.jpg',2,1,0,1,'审核通过','2026-06-18 10:00:00','2026-06-18 09:00:00','2026-06-18 09:00:00',0),(6030,5013,2003,'有机西兰花2颗装','绿色有机 营养丰富','/static/product/6030.jpg','<p>有机种植西兰花，富含维生素，营养健康</p>','/product_detail/6030.jpg',2,1,0,1,'审核通过','2026-06-18 11:00:00','2026-06-18 10:30:00','2026-06-18 10:30:00',0),(6031,5013,2003,'上海青500g','新鲜翠绿 口感清脆','/static/product/6031.jpg','<p>本地新鲜上海青，翠绿鲜嫩，炒菜首选</p>','/product_detail/6031.jpg',2,1,0,1,'审核通过','2026-06-19 10:00:00','2026-06-19 09:00:00','2026-06-19 09:00:00',0),(6032,5013,2003,'新鲜西红柿5斤装','自然成熟 酸甜可口','/static/product/6032.jpg','<p>露天种植西红柿，自然成熟，沙甜可口</p>','/product_detail/6032.jpg',2,1,0,1,'审核通过','2026-06-19 11:00:00','2026-06-19 10:30:00','2026-06-19 10:30:00',0),(6033,5013,2003,'紫甘蓝2颗装','脆爽多汁 营养丰富','/static/product/6033.jpg','<p>新鲜紫甘蓝，脆爽多汁，凉拌佳品</p>','/product_detail/6033.jpg',2,1,0,1,'审核通过','2026-06-20 10:00:00','2026-06-20 09:00:00','2026-06-20 09:00:00',0),(6034,5013,2003,'山东大葱3斤装','葱白脆嫩 葱香浓郁','/static/product/6034.jpg','<p>山东章丘大葱，葱白脆嫩，葱香浓郁</p>','/product_detail/6034.jpg',2,1,0,1,'审核通过','2026-06-20 11:00:00','2026-06-20 10:30:00','2026-06-20 10:30:00',0),(6035,5014,2004,'黑猪五花肉500g','肥瘦相间 肉质鲜嫩','/static/product/6035.jpg','<p>农家散养黑猪五花肉，肥瘦相间，红烧首选</p>','/product_detail/6035.jpg',2,1,0,1,'审核通过','2026-06-21 10:00:00','2026-06-21 09:00:00','2026-06-21 09:00:00',0),(6036,5014,2004,'澳洲牛腩块1kg','进口牛肉 炖煮佳品','/static/product/6036.jpg','<p>澳洲进口牛腩块，肉质紧实，红烧炖煮皆宜</p>','/product_detail/6036.jpg',2,1,0,1,'审核通过','2026-06-21 11:00:00','2026-06-21 10:30:00','2026-06-21 10:30:00',0),(6037,5014,2004,'内蒙古羊排1.5kg','草原羊肉 鲜嫩无膻','/static/product/6037.jpg','<p>内蒙古草原羊排，肉质鲜嫩，无膻味</p>','/product_detail/6037.jpg',2,1,0,1,'审核通过','2026-06-22 10:00:00','2026-06-22 09:00:00','2026-06-22 09:00:00',0),(6038,5014,2004,'猪里脊500g','肉质细嫩 炒菜首选','/static/product/6038.jpg','<p>新鲜猪里脊肉，肉质细嫩，适合炒菜</p>','/product_detail/6038.jpg',2,1,0,1,'审核通过','2026-06-22 11:00:00','2026-06-22 10:30:00','2026-06-22 10:30:00',0),(6039,5014,2004,'肥牛卷500g','火锅必备 鲜嫩可口','/static/product/6039.jpg','<p>优质肥牛卷，火锅涮肉必备，鲜嫩可口</p>','/product_detail/6039.jpg',2,1,0,1,'审核通过','2026-06-23 10:00:00','2026-06-23 09:00:00','2026-06-23 09:00:00',0),(6040,5014,2004,'猪蹄500g','胶原蛋白丰富','/static/product/6040.jpg','<p>新鲜猪蹄，富含胶原蛋白，炖汤佳品</p>','/product_detail/6040.jpg',2,1,0,1,'审核通过','2026-06-23 11:00:00','2026-06-23 10:30:00','2026-06-23 10:30:00',0),(6041,5015,2004,'厄瓜多尔白虾400g','进口海虾 肉质Q弹','/static/product/6041.jpg','<p>厄瓜多尔进口白虾，肉质Q弹，鲜美可口</p>','/product_detail/6041.jpg',2,1,0,1,'审核通过','2026-06-24 10:00:00','2026-06-24 09:00:00','2026-06-24 09:00:00',0),(6042,5015,2004,'挪威三文鱼500g','进口刺身级','/static/product/6042.jpg','<p>挪威进口三文鱼，刺身级品质，肉质鲜嫩</p>','/product_detail/6042.jpg',2,1,0,1,'审核通过','2026-06-24 11:00:00','2026-06-24 10:30:00','2026-06-24 10:30:00',0),(6043,5015,2004,'鲜活大闸蟹4只装','阳澄湖产区','/static/product/6043.jpg','<p>阳澄湖大闸蟹，膏满黄肥，鲜美无比</p>','/product_detail/6043.jpg',2,1,0,1,'审核通过','2026-06-25 10:00:00','2026-06-25 09:00:00','2026-06-25 09:00:00',0),(6044,5015,2004,'鲍鱼4只装','新鲜活鲍','/static/product/6044.jpg','<p>新鲜活鲍鱼，肉质鲜嫩，滋补佳品</p>','/product_detail/6044.jpg',2,1,0,1,'审核通过','2026-06-25 11:00:00','2026-06-25 10:30:00','2026-06-25 10:30:00',0),(6045,5015,2004,'扇贝肉500g','冷冻新鲜','/static/product/6045.jpg','<p>新鲜扇贝肉，冷冻锁鲜，肉质饱满</p>','/product_detail/6045.jpg',2,1,0,1,'审核通过','2026-06-26 10:00:00','2026-06-26 09:00:00','2026-06-26 09:00:00',0),(6046,5015,2004,'花甲500g','鲜活新鲜','/static/product/6046.jpg','<p>鲜活花甲，肉质鲜美，蒜蓉粉丝蒸首选</p>','/product_detail/6046.jpg',2,1,0,1,'审核通过','2026-06-26 11:00:00','2026-06-26 10:30:00','2026-06-26 10:30:00',0),(6047,5014,2004,'农家土鸡整只1.5kg','散养土鸡','/static/product/6047.jpg','<p>农家散养土鸡，肉质紧实，炖汤鲜美</p>','/product_detail/6047.jpg',2,1,0,1,'审核通过','2026-06-27 10:00:00','2026-06-27 09:00:00','2026-06-27 09:00:00',0),(6048,5014,2004,'鲜鸡蛋30枚','农家土鸡蛋','/static/product/6048.jpg','<p>农家散养土鸡蛋，蛋黄金黄浓稠</p>','/product_detail/6048.jpg',2,1,0,1,'审核通过','2026-06-27 11:00:00','2026-06-27 10:30:00','2026-06-27 10:30:00',0),(6049,5014,2004,'老鸭整只2kg','散养老鸭','/static/product/6049.jpg','<p>农家散养老鸭，肉质紧实，煲汤首选</p>','/product_detail/6049.jpg',2,1,0,1,'审核通过','2026-06-28 10:00:00','2026-06-28 09:00:00','2026-06-28 09:00:00',0),(6050,5014,2004,'鹌鹑蛋200g','新鲜鹌鹑蛋','/static/product/6050.jpg','<p>新鲜鹌鹑蛋，营养丰富，小巧可口</p>','/product_detail/6050.jpg',2,1,0,1,'审核通过','2026-06-28 11:00:00','2026-06-28 10:30:00','2026-06-28 10:30:00',0),(6051,5014,2004,'鸽子整只500g','新鲜乳鸽','/static/product/6051.jpg','<p>新鲜乳鸽，肉质细嫩，营养滋补</p>','/product_detail/6051.jpg',2,1,0,1,'审核通过','2026-06-29 10:00:00','2026-06-29 09:00:00','2026-06-29 09:00:00',0),(6052,5014,2005,'湾仔码头水饺500g','手工水饺','/static/product/6052.jpg','<p>湾仔码头手工水饺，皮薄馅大，鲜美可口</p>','/product_detail/6052.jpg',2,1,0,1,'审核通过','2026-06-29 11:00:00','2026-06-29 10:30:00','2026-06-29 10:30:00',0),(6053,5014,2005,'思念汤圆400g','黑芝麻馅','/static/product/6053.jpg','<p>思念黑芝麻汤圆，软糯香甜，传统美味</p>','/product_detail/6053.jpg',2,1,0,1,'审核通过','2026-06-30 10:00:00','2026-06-30 09:00:00','2026-06-30 09:00:00',0),(6054,5014,2005,'正大鸡排500g','速冻半成品','/static/product/6054.jpg','<p>正大鸡排，外酥里嫩，油炸美味</p>','/product_detail/6054.jpg',2,1,0,1,'审核通过','2026-06-30 11:00:00','2026-06-30 10:30:00','2026-06-30 10:30:00',0),(6055,5014,2005,'速冻包子10只装','鲜肉馅','/static/product/6055.jpg','<p>速冻鲜肉包子，皮薄馅足，早餐必备</p>','/product_detail/6055.jpg',2,1,0,1,'审核通过','2026-07-01 10:00:00','2026-07-01 09:00:00','2026-07-01 09:00:00',0),(6056,5014,2005,'手抓饼10片装','家庭装','/static/product/6056.jpg','<p>手抓饼家庭装，早餐方便快捷，美味可口</p>','/product_detail/6056.jpg',2,1,0,1,'审核通过','2026-07-01 11:00:00','2026-07-01 10:30:00','2026-07-01 10:30:00',0),(6057,5009,2005,'周黑鸭锁鲜装300g','麻辣鲜香','/static/product/6057.jpg','<p>周黑鸭锁鲜装，麻辣鲜香，回味无穷</p>','/product_detail/6057.jpg',2,1,0,1,'审核通过','2026-07-02 10:00:00','2026-07-02 09:00:00','2026-07-02 09:00:00',0),(6058,5010,2005,'麻辣兔头2只装','成都特色','/static/product/6058.jpg','<p>成都特色麻辣兔头，麻辣鲜香，回味无穷</p>','/product_detail/6058.jpg',2,1,0,1,'审核通过','2026-07-02 11:00:00','2026-07-02 10:30:00','2026-07-02 10:30:00',0),(6059,5022,2006,'哈根达斯冰淇淋81g','香草口味','/static/product/6059.jpg','<p>哈根达斯香草冰淇淋，丝滑细腻，美味享受</p>','[\"product/6059_detail_1.jpg\"]/product_detail/6059.jpg',2,1,0,1,'审核通过','2026-07-03 10:00:00','2026-07-03 09:00:00','2026-07-03 09:00:00',0),(6060,5022,2006,'八喜冰淇淋500ml','草莓口味','/static/product/6060.jpg','<p>八喜草莓冰淇淋，香甜细腻，夏日清凉</p>','/product_detail/6060.jpg',2,1,0,1,'审核通过','2026-07-03 11:00:00','2026-07-03 10:30:00','2026-07-03 10:30:00',0),(6061,5022,2006,'提拉米苏蛋糕切块','意式甜点','/static/product/6061.jpg','<p>意式提拉米苏蛋糕，香浓顺滑，下午茶首选</p>','/product_detail/6061.jpg',2,1,0,1,'审核通过','2026-07-04 10:00:00','2026-07-04 09:00:00','2026-07-04 09:00:00',0),(6062,5022,2006,'芒果班戟4个装','港式甜品','/static/product/6062.jpg','<p>港式芒果班戟，皮薄馅大，香甜可口</p>','/product_detail/6062.jpg',2,1,0,1,'审核通过','2026-07-04 11:00:00','2026-07-04 10:30:00','2026-07-04 10:30:00',0),(6063,5022,2006,'杨枝甘露300ml','港式饮品','/static/product/6063.jpg','<p>港式杨枝甘露，芒果西柚西米，清爽美味</p>','/product_detail/6063.jpg',2,1,0,1,'审核通过','2026-07-05 10:00:00','2026-07-05 09:00:00','2026-07-05 09:00:00',0),(6064,5007,2004,'鲁花花生油5L','压榨一级','/static/product/6064.jpg','<p>鲁花压榨一级花生油，香浓纯正，炒菜更香</p>','/product_detail/6064.jpg',2,1,0,1,'审核通过','2026-07-06 10:00:00','2026-07-06 09:00:00','2026-07-06 09:00:00',0),(6065,5008,2004,'老干妈辣椒酱280g','经典风味','/static/product/6065.jpg','<p>老干妈辣椒酱，香辣可口，下饭神器</p>','/product_detail/6065.jpg',2,1,0,1,'审核通过','2026-07-06 11:00:00','2026-07-06 10:30:00','2026-07-06 10:30:00',0),(6066,5007,2004,'东北小米2.5kg','农家特产','/static/product/6066.jpg','<p>东北农家小米，金黄饱满，熬粥香浓</p>','/product_detail/6066.jpg',2,1,0,1,'审核通过','2026-07-07 10:00:00','2026-07-07 09:00:00','2026-07-07 09:00:00',0),(6067,5017,2006,'青岛啤酒经典500ml*6','百年经典','/static/product/6067.jpg','<p>青岛啤酒经典款，百年酿造工艺，畅饮无限</p>','/product_detail/6067.jpg',2,1,0,1,'审核通过','2026-07-07 11:00:00','2026-07-07 10:30:00','2026-07-07 10:30:00',0),(6068,5018,2006,'雀巢咖啡1+2原味48杯','速溶咖啡','/static/product/6068.jpg','<p>雀巢咖啡1+2原味，香浓顺滑，提神醒脑</p>','/product_detail/6068.jpg',2,1,0,1,'审核通过','2026-07-08 10:00:00','2026-07-08 09:00:00','2026-07-08 09:00:00',0),(6069,5012,2006,'蒙牛纯牛奶250ml*24','优质奶源','/static/product/6069.jpg','<p>蒙牛纯牛奶，优质奶源，营养健康</p>','/product_detail/6069.jpg',2,1,0,1,'审核通过','2026-07-08 11:00:00','2026-07-08 10:30:00','2026-07-08 10:30:00',0),(6070,5022,2010,'费列罗巧克力T30','榛果威化','/static/product/6070.jpg','<p>费列罗榛果威化巧克力，香浓美味，送礼首选</p>','/product_detail/6070.jpg',2,1,0,1,'审核通过','2026-07-09 10:00:00','2026-07-09 09:00:00','2026-07-09 09:00:00',0),(6071,5023,2010,'明治巧克力豆100g','缤纷口味','/static/product/6071.jpg','<p>明治巧克力豆，缤纷口味，口感细腻</p>','/product_detail/6071.jpg',2,1,0,1,'审核通过','2026-07-09 11:00:00','2026-07-09 10:30:00','2026-07-09 10:30:00',0),(6072,5023,2010,'乐天小熊饼干192g','夹心饼干','/static/product/6072.jpg','<p>乐天小熊饼干，香浓夹心，可爱造型</p>','/product_detail/6072.jpg',2,1,0,1,'审核通过','2026-07-10 10:00:00','2026-07-10 09:00:00','2026-07-10 09:00:00',0),(6073,5016,2010,'茅台飞天53度500ml','酱香经典','/static/product/6073.jpg','<p>茅台飞天53度，国酒经典，酱香浓郁</p>','/product_detail/6073.jpg',2,1,0,1,'审核通过','2026-07-10 11:00:00','2026-07-10 10:30:00','2026-07-10 10:30:00',0),(6074,5016,2010,'进口红酒750ml','法国产区','/static/product/6074.jpg','<p>法国进口红酒，果香浓郁，口感醇厚</p>','/product_detail/6074.jpg',2,1,0,1,'审核通过','2026-07-11 10:00:00','2026-07-11 09:00:00','2026-07-11 09:00:00',0),(6075,5008,2004,'重庆火锅底料礼盒','麻辣鲜香','/static/product/6075.jpg','<p>重庆火锅底料礼盒，麻辣鲜香，正宗川味</p>','/product_detail/6075.jpg',2,1,0,1,'审核通过','2026-07-11 11:00:00','2026-07-11 10:30:00','2026-07-11 10:30:00',0),(6076,5022,2010,'云南鲜花饼礼盒','花香四溢','/static/product/6076.jpg','<p>云南鲜花饼礼盒，花香四溢，酥软可口</p>','/product_detail/6076.jpg',2,1,0,1,'审核通过','2026-07-12 10:00:00','2026-07-12 09:00:00','2026-07-12 09:00:00',0),(6077,5014,2005,'四川腊肠礼盒','麻辣鲜香','/static/product/6077.jpg','<p>四川腊肠礼盒，麻辣鲜香，年味十足</p>','/product_detail/6077.jpg',2,1,0,1,'审核通过','2026-07-12 11:00:00','2026-07-12 10:30:00','2026-07-12 10:30:00',0),(6078,5014,2005,'湖南腊肉礼盒','烟熏风味','/static/product/6078.jpg','<p>湖南腊肉礼盒，烟熏风味，香气扑鼻</p>','/product_detail/6078.jpg',2,1,0,1,'审核通过','2026-07-13 10:00:00','2026-07-13 09:00:00','2026-07-13 09:00:00',0),(6079,5008,2004,'山西陈醋礼盒','百年老醋','/static/product/6079.jpg','<p>山西陈醋礼盒，百年老醋，酸香浓郁</p>','/product_detail/6079.jpg',2,1,0,1,'审核通过','2026-07-13 11:00:00','2026-07-13 10:30:00','2026-07-13 10:30:00',0),(6080,5019,2010,'西湖龙井250g','明前茶','/static/product/6080.jpg','<p>西湖龙井明前茶，清香甘醇，名茶之首</p>','/product_detail/6080.jpg',2,1,0,1,'审核通过','2026-07-14 10:00:00','2026-07-14 09:00:00','2026-07-14 09:00:00',0),(6081,5019,2010,'铁观音250g','清香型','/static/product/6081.jpg','<p>铁观音清香型，香气高扬，回甘持久</p>','/product_detail/6081.jpg',2,1,0,1,'审核通过','2026-07-14 11:00:00','2026-07-14 10:30:00','2026-07-14 10:30:00',0),(6082,5019,2010,'大红袍100g','岩茶之王','/static/product/6082.jpg','<p>大红袍岩茶之王，香气馥郁，岩韵悠长</p>','/product_detail/6082.jpg',2,1,0,1,'审核通过','2026-07-15 10:00:00','2026-07-15 09:00:00','2026-07-15 09:00:00',0),(6083,5019,2006,'立顿红茶包100包','经典红茶','/static/product/6083.jpg','<p>立顿红茶包，经典口味，方便快捷</p>','/product_detail/6083.jpg',2,1,0,1,'审核通过','2026-07-15 11:00:00','2026-07-15 10:30:00','2026-07-15 10:30:00',0),(6084,5019,2010,'普洱熟茶357g','勐海味','/static/product/6084.jpg','<p>普洱熟茶勐海味，陈香醇厚，暖胃养生</p>','/product_detail/6084.jpg',2,1,0,1,'审核通过','2026-07-16 10:00:00','2026-07-16 09:00:00','2026-07-16 09:00:00',0),(6085,5020,2010,'同仁堂阿胶250g','补血养颜','/static/product/6085.jpg','<p>同仁堂阿胶，补血养颜，滋阴润燥</p>','/product_detail/6085.jpg',2,1,0,1,'审核通过','2026-07-16 11:00:00','2026-07-16 10:30:00','2026-07-16 10:30:00',0),(6086,5021,2010,'汤臣倍健蛋白粉450g','增强免疫力','/static/product/6086.jpg','<p>汤臣倍健蛋白粉，增强免疫力，营养补充</p>','/product_detail/6086.jpg',2,1,0,1,'审核通过','2026-07-17 10:00:00','2026-07-17 09:00:00','2026-07-17 09:00:00',0),(6087,5020,2010,'西洋参片100g','补气养阴','/static/product/6087.jpg','<p>西洋参片，补气养阴，清热生津</p>','/product_detail/6087.jpg',2,1,0,1,'审核通过','2026-07-17 11:00:00','2026-07-17 10:30:00','2026-07-17 10:30:00',0),(6088,5020,2010,'燕窝礼盒装','滋补佳品','/static/product/6088.jpg','<p>燕窝礼盒装，天然滋补，养颜美容</p>','/product_detail/6088.jpg',2,1,0,1,'审核通过','2026-07-18 10:00:00','2026-07-18 09:00:00','2026-07-18 09:00:00',0),(6089,5021,2010,'鱼油软胶囊100粒','心脑血管健康','/static/product/6089.jpg','<p>鱼油软胶囊，心脑血管健康，益智补脑</p>','/product_detail/6089.jpg',2,1,0,1,'审核通过','2026-07-18 11:00:00','2026-07-18 10:30:00','2026-07-18 10:30:00',0),(6090,5002,2001,'中秋月饼礼盒','广式月饼','/static/product/6090.jpg','<p>中秋月饼礼盒，广式月饼，团圆美味</p>','/product_detail/6090.jpg',2,1,0,1,'审核通过','2026-07-19 10:00:00','2026-07-19 09:00:00','2026-07-19 09:00:00',0),(6091,5001,2001,'坚果大礼包','送礼佳品','/static/product/6091.jpg','<p>坚果大礼包，送礼佳品，营养丰富</p>','/product_detail/6091.jpg',3,1,0,1,'审核通过','2026-07-19 11:00:00','2026-07-19 10:30:00','2026-07-19 10:30:00',0),(6092,5007,2004,'春节年货礼盒','粮油礼盒','/static/product/6092.jpg','<p>春节年货礼盒，粮油礼盒，年味十足</p>','/product_detail/6092.jpg',3,1,0,1,'审核通过','2026-07-20 10:00:00','2026-07-20 09:00:00','2026-07-20 09:00:00',0),(6093,5005,2003,'进口水果礼盒','鲜果礼盒','/static/product/6093.jpg','<p>进口水果礼盒，鲜果礼盒，送礼体面</p>','/product_detail/6093.jpg',3,1,0,1,'审核通过','2026-07-20 11:00:00','2026-07-20 10:30:00','2026-07-20 10:30:00',0),(6094,5015,2004,'海鲜礼盒','海鲜大礼包','/static/product/6094.jpg','<p>海鲜礼盒，海鲜大礼包，鲜美无比</p>','/product_detail/6094.jpg',3,1,0,1,'审核通过','2026-07-21 10:00:00','2026-07-21 09:00:00','2026-07-21 09:00:00',0),(6095,5024,2007,'水星家纺四件套','全棉印花','/static/product/6095.jpg','<p>水星家纺四件套，全棉印花，舒适睡眠</p>','/product_detail/6095.jpg',3,1,0,1,'审核通过','2026-07-21 11:00:00','2026-07-21 10:30:00','2026-07-21 10:30:00',0),(6096,5024,2007,'纯棉毛巾3条装','柔软亲肤','/static/product/6096.jpg','<p>纯棉毛巾3条装，柔软亲肤，吸水速干</p>','/product_detail/6096.jpg',3,1,0,1,'审核通过','2026-07-22 10:00:00','2026-07-22 09:00:00','2026-07-22 09:00:00',0),(6097,5024,2007,'蚕丝被冬被','保暖舒适','/static/product/6097.jpg','<p>蚕丝被冬被，保暖舒适，亲肤透气</p>','/product_detail/6097.jpg',3,1,0,1,'审核通过','2026-07-22 11:00:00','2026-07-22 10:30:00','2026-07-22 10:30:00',0),(6098,5024,2007,'枕头一对','记忆棉','/static/product/6098.jpg','<p>记忆棉枕头一对，护颈舒适，深度睡眠</p>','/product_detail/6098.jpg',3,1,0,1,'审核通过','2026-07-23 10:00:00','2026-07-23 09:00:00','2026-07-23 09:00:00',0),(6099,5024,2007,'浴巾大号','纯棉加厚','/static/product/6099.jpg','<p>纯棉加厚浴巾大号，柔软吸水，品质生活</p>','/product_detail/6099.jpg',3,1,0,1,'审核通过','2026-07-23 11:00:00','2026-07-23 10:30:00','2026-07-23 10:30:00',0),(6100,5025,2007,'欧普LED吸顶灯','节能护眼','/static/product/6100.jpg','<p>欧普LED吸顶灯，节能护眼，明亮舒适</p>','/product_detail/6100.jpg',3,1,0,1,'审核通过','2026-07-24 10:00:00','2026-07-24 09:00:00','2026-07-24 09:00:00',0),(6101,5025,2007,'台灯护眼灯','学生专用','/static/product/6101.jpg','<p>台灯护眼灯，学生专用，无频闪</p>','/product_detail/6101.jpg',3,1,0,1,'审核通过','2026-07-24 11:00:00','2026-07-24 10:30:00','2026-07-24 10:30:00',0),(6102,5025,2007,'落地灯客厅','简约现代','/static/product/6102.jpg','<p>落地灯客厅，简约现代，温馨照明</p>','/product_detail/6102.jpg',3,1,0,1,'审核通过','2026-07-25 10:00:00','2026-07-25 09:00:00','2026-07-25 09:00:00',0),(6103,5025,2007,'床头小夜灯','暖光护眼','/static/product/6103.jpg','<p>床头小夜灯，暖光护眼，夜间起夜方便</p>','/product_detail/6103.jpg',3,1,0,1,'审核通过','2026-07-25 11:00:00','2026-07-25 10:30:00','2026-07-25 10:30:00',0),(6104,5025,2007,'厨房吸顶灯','防水防油','/static/product/6104.jpg','<p>厨房吸顶灯，防水防油，明亮照明</p>','/product_detail/6104.jpg',3,1,0,1,'审核通过','2026-07-26 10:00:00','2026-07-26 09:00:00','2026-07-26 09:00:00',0),(6105,5026,2007,'乐扣乐扣保鲜盒5件套','密封保鲜','/static/product/6105.jpg','<p>乐扣乐扣保鲜盒5件套，密封保鲜，健康生活</p>','/product_detail/6105.jpg',3,1,0,1,'审核通过','2026-07-27 10:00:00','2026-07-27 09:00:00','2026-07-27 09:00:00',0),(6106,5026,2007,'收纳箱大号','环保材质','/static/product/6106.jpg','<p>收纳箱大号，环保材质，居家收纳必备</p>','/product_detail/6106.jpg',3,1,0,1,'审核通过','2026-07-27 11:00:00','2026-07-27 10:30:00','2026-07-27 10:30:00',0),(6107,5026,2007,'抽屉收纳盒','整理收纳','/static/product/6107.jpg','<p>抽屉收纳盒，整理收纳，告别杂乱</p>','/product_detail/6107.jpg',3,1,0,1,'审核通过','2026-07-28 10:00:00','2026-07-28 09:00:00','2026-07-28 09:00:00',0),(6108,5026,2007,'衣柜收纳架','分层收纳','/static/product/6108.jpg','<p>衣柜收纳架，分层收纳，节省空间</p>','/product_detail/6108.jpg',3,1,0,1,'审核通过','2026-07-28 11:00:00','2026-07-28 10:30:00','2026-07-28 10:30:00',0),(6109,5027,2007,'蓝月亮洗衣液3kg','温和洁净','/static/product/6109.jpg','<p>蓝月亮洗衣液，温和洁净，呵护衣物</p>','/product_detail/6109.jpg',3,1,0,1,'审核通过','2026-07-29 10:00:00','2026-07-29 09:00:00','2026-07-29 09:00:00',0),(6110,5028,2007,'维达纸巾抽纸3包','柔软亲肤','/static/product/6110.jpg','<p>维达纸巾抽纸，柔软亲肤，品质生活</p>','/product_detail/6110.jpg',3,1,0,1,'审核通过','2026-07-29 11:00:00','2026-07-29 10:30:00','2026-07-29 10:30:00',0),(6111,5027,2007,'消毒湿巾100片','杀菌消毒','/static/product/6111.jpg','<p>消毒湿巾，杀菌消毒，卫生安全</p>','/product_detail/6111.jpg',3,1,0,1,'审核通过','2026-07-30 10:00:00','2026-07-30 09:00:00','2026-07-30 09:00:00',0),(6112,5027,2007,'洁厕灵500ml','强力去污','/static/product/6112.jpg','<p>洁厕灵，强力去污，厕所清洁必备</p>','/product_detail/6112.jpg',3,1,0,1,'审核通过','2026-07-30 11:00:00','2026-07-30 10:30:00','2026-07-30 10:30:00',0),(6113,5029,2007,'箭牌马桶盖','缓降静音','/static/product/6113.jpg','<p>箭牌马桶盖，缓降静音，品质卫浴</p>','/product_detail/6113.jpg',3,1,0,1,'审核通过','2026-08-01 10:00:00','2026-08-01 09:00:00','2026-08-01 09:00:00',0),(6114,5029,2007,'箭牌花洒套装','恒温出水','/static/product/6114.jpg','<p>箭牌花洒套装，恒温出水，舒适沐浴</p>','/product_detail/6114.jpg',3,1,0,1,'审核通过','2026-08-01 11:00:00','2026-08-01 10:30:00','2026-08-01 10:30:00',0),(6115,5029,2007,'漱口杯套装','简约设计','/static/product/6115.jpg','<p>漱口杯套装，简约设计，浴室必备</p>','/product_detail/6115.jpg',3,1,0,1,'审核通过','2026-08-02 10:00:00','2026-08-02 09:00:00','2026-08-02 09:00:00',0),(6116,5030,2007,'天堂雨伞大号','防风防雨','/static/product/6116.jpg','<p>天堂雨伞大号，防风防雨，品质保障</p>','/product_detail/6116.jpg',3,1,0,1,'审核通过','2026-08-02 11:00:00','2026-08-02 10:30:00','2026-08-02 10:30:00',0),(6117,5030,2007,'雨衣加厚','户外必备','/static/product/6117.jpg','<p>雨衣加厚，户外必备，风雨无阻</p>','/product_detail/6117.jpg',3,1,0,1,'审核通过','2026-08-03 10:00:00','2026-08-03 09:00:00','2026-08-03 09:00:00',0),(6118,5030,2007,'防晒衣轻薄','透气防晒','/static/product/6118.jpg','<p>防晒衣轻薄，透气防晒，夏季必备</p>','/product_detail/6118.jpg',3,1,0,1,'审核通过','2026-08-03 11:00:00','2026-08-03 10:30:00','2026-08-03 10:30:00',0),(6119,5031,2007,'晾衣架落地','折叠便携','/static/product/6119.jpg','<p>晾衣架落地，折叠便携，晾晒方便</p>','/product_detail/6119.jpg',3,1,0,1,'审核通过','2026-08-04 10:00:00','2026-08-04 09:00:00','2026-08-04 09:00:00',0),(6120,5031,2007,'烫衣板家用','稳固耐用','/static/product/6120.jpg','<p>烫衣板家用，稳固耐用，熨烫方便</p>','/product_detail/6120.jpg',3,1,0,1,'审核通过','2026-08-04 11:00:00','2026-08-04 10:30:00','2026-08-04 10:30:00',0),(6121,5031,2007,'衣架10个装','防滑无痕','/static/product/6121.jpg','<p>衣架10个装，防滑无痕，晾晒必备</p>','/product_detail/6121.jpg',3,1,0,1,'审核通过','2026-08-05 10:00:00','2026-08-05 09:00:00','2026-08-05 09:00:00',0),(6122,5032,2007,'宜家装饰花瓶','简约现代','/static/product/6122.jpg','<p>宜家装饰花瓶，简约现代，家居装饰</p>','/product_detail/6122.jpg',3,1,0,1,'审核通过','2026-08-05 11:00:00','2026-08-05 10:30:00','2026-08-05 10:30:00',0),(6123,5032,2007,'仿真花束','装饰摆件','/static/product/6123.jpg','<p>仿真花束，装饰摆件，无需打理</p>','/product_detail/6123.jpg',3,1,0,1,'审核通过','2026-08-06 10:00:00','2026-08-06 09:00:00','2026-08-06 09:00:00',0),(6124,5032,2007,'多肉植物组合','桌面绿植','/static/product/6124.jpg','<p>多肉植物组合，桌面绿植，净化空气</p>','/product_detail/6124.jpg',3,1,0,1,'审核通过','2026-08-06 11:00:00','2026-08-06 10:30:00','2026-08-06 10:30:00',0),(6125,5033,2007,'皇家猫粮1.5kg','营养均衡','/static/product/6125.jpg','<p>皇家猫粮，营养均衡，关爱宠物</p>','/product_detail/6125.jpg',3,1,0,1,'审核通过','2026-08-07 10:00:00','2026-08-07 09:00:00','2026-08-07 09:00:00',0),(6126,5033,2007,'皇家狗粮1.5kg','营养均衡','/static/product/6126.jpg','<p>皇家狗粮，营养均衡，关爱宠物</p>','/product_detail/6126.jpg',3,1,0,1,'审核通过','2026-08-07 11:00:00','2026-08-07 10:30:00','2026-08-07 10:30:00',0),(6127,5033,2007,'猫砂10kg','无尘结团','/static/product/6127.jpg','<p>猫砂10kg，无尘结团，宠物清洁</p>','/product_detail/6127.jpg',3,1,0,1,'审核通过','2026-08-08 10:00:00','2026-08-08 09:00:00','2026-08-08 09:00:00',0),(6128,5034,2008,'苏泊尔不粘锅32cm','少油烟','/static/product/6128.jpg','<p>苏泊尔不粘锅，少油烟，轻松烹饪</p>','/product_detail/6128.jpg',3,1,0,1,'审核通过','2026-08-08 11:00:00','2026-08-08 10:30:00','2026-08-08 10:30:00',0),(6129,5034,2008,'苏泊尔压力锅5L','高效烹饪','/static/product/6129.jpg','<p>苏泊尔压力锅，高效烹饪，省时省力</p>','/product_detail/6129.jpg',3,1,0,1,'审核通过','2026-08-09 10:00:00','2026-08-09 09:00:00','2026-08-09 09:00:00',0),(6130,5034,2008,'苏泊尔炒锅34cm','铸铁材质','/static/product/6130.jpg','<p>苏泊尔铸铁炒锅，健康烹饪，补铁首选</p>','/product_detail/6130.jpg',3,1,0,1,'审核通过','2026-08-09 11:00:00','2026-08-09 10:30:00','2026-08-09 10:30:00',0),(6131,5035,2008,'张小泉菜刀','锋利耐用','/static/product/6131.jpg','<p>张小泉菜刀，锋利耐用，品质传承</p>','/product_detail/6131.jpg',3,1,0,1,'审核通过','2026-08-10 10:00:00','2026-08-10 09:00:00','2026-08-10 09:00:00',0),(6132,5035,2008,'张小泉剪刀','家用剪刀','/static/product/6132.jpg','<p>张小泉剪刀，家用剪刀，多功能使用</p>','/product_detail/6132.jpg',3,1,0,1,'审核通过','2026-08-10 11:00:00','2026-08-10 10:30:00','2026-08-10 10:30:00',0),(6133,5035,2008,'砧板实木','抗菌防霉','/static/product/6133.jpg','<p>实木砧板，抗菌防霉，厨房必备</p>','/product_detail/6133.jpg',3,1,0,1,'审核通过','2026-08-11 10:00:00','2026-08-11 09:00:00','2026-08-11 09:00:00',0),(6134,5036,2008,'富光保温杯500ml','316不锈钢','/static/product/6134.jpg','<p>富光保温杯，316不锈钢，保温持久</p>','/product_detail/6134.jpg',3,1,0,1,'审核通过','2026-08-11 11:00:00','2026-08-11 10:30:00','2026-08-11 10:30:00',0),(6135,5036,2008,'富光玻璃杯350ml','耐高温','/static/product/6135.jpg','<p>富光玻璃杯，耐高温，健康饮水</p>','/product_detail/6135.jpg',3,1,0,1,'审核通过','2026-08-12 10:00:00','2026-08-12 09:00:00','2026-08-12 09:00:00',0),(6136,5037,2008,'康宁玻璃碗套装','耐热玻璃','/static/product/6136.jpg','<p>康宁玻璃碗套装，耐热玻璃，健康环保</p>','/product_detail/6136.jpg',3,1,0,1,'审核通过','2026-08-12 11:00:00','2026-08-12 10:30:00','2026-08-12 10:30:00',0),(6137,5037,2008,'陶瓷碗盘套装','中式风格','/static/product/6137.jpg','<p>陶瓷碗盘套装，中式风格，餐桌必备</p>','/product_detail/6137.jpg',3,1,0,1,'审核通过','2026-08-13 10:00:00','2026-08-13 09:00:00','2026-08-13 09:00:00',0),(6138,5038,2008,'九阳豆浆机','全自动','/static/product/6138.jpg','<p>九阳豆浆机，全自动，营养早餐</p>','/product_detail/6138.jpg',3,1,0,1,'审核通过','2026-08-13 11:00:00','2026-08-13 10:30:00','2026-08-13 10:30:00',0),(6139,5038,2008,'九阳电饭煲4L','智能预约','/static/product/6139.jpg','<p>九阳电饭煲，智能预约，煮饭更香</p>','/product_detail/6139.jpg',3,1,0,1,'审核通过','2026-08-14 10:00:00','2026-08-14 09:00:00','2026-08-14 09:00:00',0),(6140,5038,2008,'厨房置物架','多层收纳','/static/product/6140.jpg','<p>厨房置物架，多层收纳，节省空间</p>','/product_detail/6140.jpg',3,1,0,1,'审核通过','2026-08-14 11:00:00','2026-08-14 10:30:00','2026-08-14 10:30:00',0),(6141,5039,2007,'欧莱雅洗面奶','深层清洁','/static/product/6141.jpg','<p>欧莱雅洗面奶，深层清洁，洁面首选</p>','/product_detail/6141.jpg',3,1,0,1,'审核通过','2026-08-15 10:00:00','2026-08-15 09:00:00','2026-08-15 09:00:00',0),(6142,5039,2007,'欧莱雅面霜','补水保湿','/static/product/6142.jpg','<p>欧莱雅面霜，补水保湿，滋润肌肤</p>','/product_detail/6142.jpg',3,1,0,1,'审核通过','2026-08-15 11:00:00','2026-08-15 10:30:00','2026-08-15 10:30:00',0),(6143,5040,2007,'玉兰油精华液','提亮肤色','/static/product/6143.jpg','<p>玉兰油精华液，提亮肤色，焕发光彩</p>','/product_detail/6143.jpg',3,1,0,1,'审核通过','2026-08-16 10:00:00','2026-08-16 09:00:00','2026-08-16 09:00:00',0),(6144,5041,2007,'多芬沐浴露500ml','滋润保湿','/static/product/6144.jpg','<p>多芬沐浴露，滋润保湿，温和呵护</p>','/product_detail/6144.jpg',3,1,0,1,'审核通过','2026-08-16 11:00:00','2026-08-16 10:30:00','2026-08-16 10:30:00',0),(6145,5041,2007,'多芬身体乳200ml','持久滋润','/static/product/6145.jpg','<p>多芬身体乳，持久滋润，肌肤嫩滑</p>','/product_detail/6145.jpg',3,1,0,1,'审核通过','2026-08-17 10:00:00','2026-08-17 09:00:00','2026-08-17 09:00:00',0),(6146,5042,2007,'潘婷洗发水500ml','修护秀发','/static/product/6146.jpg','<p>潘婷洗发水，修护秀发，健康亮泽</p>','/product_detail/6146.jpg',3,1,0,1,'审核通过','2026-08-17 11:00:00','2026-08-17 10:30:00','2026-08-17 10:30:00',0),(6147,5042,2007,'潘婷护发素300ml','顺滑修护','/static/product/6147.jpg','<p>潘婷护发素，顺滑修护，头发更柔顺</p>','/product_detail/6147.jpg',3,1,0,1,'审核通过','2026-08-18 10:00:00','2026-08-18 09:00:00','2026-08-18 09:00:00',0),(6148,5043,2007,'高露洁牙膏120g','防蛀美白','/static/product/6148.jpg','<p>高露洁牙膏，防蛀美白，健康口腔</p>','/product_detail/6148.jpg',3,1,0,1,'审核通过','2026-08-18 11:00:00','2026-08-18 10:30:00','2026-08-18 10:30:00',0),(6149,5043,2007,'电动牙刷','声波清洁','/static/product/6149.jpg','<p>电动牙刷，声波清洁，刷牙更干净</p>','/product_detail/6149.jpg',3,1,0,1,'审核通过','2026-08-19 10:00:00','2026-08-19 09:00:00','2026-08-19 09:00:00',0),(6150,5044,2007,'护舒宝卫生巾','日用夜用组合','/static/product/6150.jpg','<p>护舒宝卫生巾，日用夜用组合，贴心呵护</p>','/product_detail/6150.jpg',3,1,0,1,'审核通过','2026-08-19 11:00:00','2026-08-19 10:30:00','2026-08-19 10:30:00',0),(6151,5045,2007,'迪奥香水50ml','经典香氛','/static/product/6151.jpg','<p>迪奥香水，经典香氛，优雅气质</p>','/product_detail/6151.jpg',3,1,0,1,'审核通过','2026-08-20 10:00:00','2026-08-20 09:00:00','2026-08-20 09:00:00',0),(6152,5046,2007,'美宝莲口红','经典红色','/static/product/6152.jpg','<p>美宝莲口红，经典红色，时尚彩妆</p>','/product_detail/6152.jpg',3,1,0,1,'审核通过','2026-08-20 11:00:00','2026-08-20 10:30:00','2026-08-20 10:30:00',0),(6153,5047,2009,'美赞臣奶粉3段','科学配方','/static/product/6153.jpg','<p>美赞臣奶粉，科学配方，呵护成长</p>','/product_detail/6153.jpg',3,1,0,1,'审核通过','2026-08-21 10:00:00','2026-08-21 09:00:00','2026-08-21 09:00:00',0),(6154,5047,2009,'美赞臣奶粉1段','新生儿配方','/static/product/6154.jpg','<p>美赞臣奶粉1段，新生儿配方，营养全面</p>','/product_detail/6154.jpg',3,1,0,1,'审核通过','2026-08-21 11:00:00','2026-08-21 10:30:00','2026-08-21 10:30:00',0),(6155,5048,2009,'亨氏米粉','宝宝辅食','/static/product/6155.jpg','<p>亨氏米粉，宝宝辅食，营养均衡</p>','/product_detail/6155.jpg',3,1,0,1,'审核通过','2026-08-22 10:00:00','2026-08-22 09:00:00','2026-08-22 09:00:00',0),(6156,5048,2009,'亨氏果泥','营养辅食','/static/product/6156.jpg','<p>亨氏果泥，营养辅食，方便喂养</p>','/product_detail/6156.jpg',3,1,0,1,'审核通过','2026-08-22 11:00:00','2026-08-22 10:30:00','2026-08-22 10:30:00',0),(6157,5049,2009,'帮宝适纸尿裤','干爽舒适','/static/product/6157.jpg','<p>帮宝适纸尿裤，干爽舒适，呵护宝宝</p>','/product_detail/6157.jpg',3,1,0,1,'审核通过','2026-08-23 10:00:00','2026-08-23 09:00:00','2026-08-23 09:00:00',0),(6158,5049,2009,'湿巾80抽','婴儿专用','/static/product/6158.jpg','<p>湿巾80抽，婴儿专用，温和无刺激</p>','/product_detail/6158.jpg',3,1,0,1,'审核通过','2026-08-23 11:00:00','2026-08-23 10:30:00','2026-08-23 10:30:00',0),(6159,5050,2009,'贝亲奶瓶','宽口径','/static/product/6159.jpg','<p>贝亲奶瓶，宽口径，方便冲泡</p>','/product_detail/6159.jpg',3,1,0,1,'审核通过','2026-08-24 10:00:00','2026-08-24 09:00:00','2026-08-24 09:00:00',0),(6160,5050,2009,'贝亲辅食碗','宝宝餐具','/static/product/6160.jpg','<p>贝亲辅食碗，宝宝餐具，安全材质</p>','/product_detail/6160.jpg',3,1,0,1,'审核通过','2026-08-24 11:00:00','2026-08-24 10:30:00','2026-08-24 10:30:00',0),(6161,5050,2009,'宝宝沐浴露','温和洗护','/static/product/6161.jpg','<p>宝宝沐浴露，温和洗护，呵护肌肤</p>','/product_detail/6161.jpg',3,1,0,1,'审核通过','2026-08-25 10:00:00','2026-08-25 09:00:00','2026-08-25 09:00:00',0),(6162,5050,2009,'宝宝面霜','保湿滋润','/static/product/6162.jpg','<p>宝宝面霜，保湿滋润，婴儿专用</p>','/product_detail/6162.jpg',3,1,0,1,'审核通过','2026-08-25 11:00:00','2026-08-25 10:30:00','2026-08-25 10:30:00',0),(6163,5050,2009,'童装套装','纯棉舒适','/static/product/6163.jpg','<p>童装套装，纯棉舒适，宝宝穿搭</p>','/product_detail/6163.jpg',3,1,0,1,'审核通过','2026-08-26 10:00:00','2026-08-26 09:00:00','2026-08-26 09:00:00',0),(6164,5050,2009,'婴儿连体衣','纯棉材质','/static/product/6164.jpg','<p>婴儿连体衣，纯棉材质，柔软舒适</p>','/product_detail/6164.jpg',3,1,0,1,'审核通过','2026-08-26 11:00:00','2026-08-26 10:30:00','2026-08-26 10:30:00',0),(6165,5050,2009,'孕妇装连衣裙','宽松舒适','/static/product/6165.jpg','<p>孕妇装连衣裙，宽松舒适，孕期穿搭</p>','/product_detail/6165.jpg',3,1,0,1,'审核通过','2026-08-27 10:00:00','2026-08-27 09:00:00','2026-08-27 09:00:00',0),(6166,5050,2009,'孕妇奶粉','孕期营养','/static/product/6166.jpg','<p>孕妇奶粉，孕期营养，妈妈健康</p>','/product_detail/6166.jpg',3,1,0,1,'审核通过','2026-08-27 11:00:00','2026-08-27 10:30:00','2026-08-27 10:30:00',0),(6167,5050,2009,'婴儿推车','轻便折叠','/static/product/6167.jpg','<p>婴儿推车，轻便折叠，出行方便</p>','/product_detail/6167.jpg',3,1,0,1,'审核通过','2026-08-28 10:00:00','2026-08-28 09:00:00','2026-08-28 09:00:00',0),(6168,5050,2009,'安全座椅','儿童专用','/static/product/6168.jpg','<p>安全座椅，儿童专用，出行安全</p>','/product_detail/6168.jpg',3,1,0,1,'审核通过','2026-08-28 11:00:00','2026-08-28 10:30:00','2026-08-28 10:30:00',0),(6169,5014,2011,'新鲜五花肉500g','农家散养土猪','/static/product/6169.jpg','<p>农家散养土猪五花肉，肥瘦相间，红烧首选</p>','/product_detail/6169.jpg',2,1,0,1,'审核通过','2026-08-29 10:00:00','2026-08-29 09:00:00','2026-08-29 09:00:00',0),(6170,5015,2011,'鲜活基围虾500g','当日海捕','/static/product/6170.jpg','<p>当日海捕鲜活基围虾，肉质Q弹，鲜美可口</p>','/product_detail/6170.jpg',2,1,0,1,'审核通过','2026-08-29 11:00:00','2026-08-29 10:30:00','2026-08-29 10:30:00',0),(6171,5016,2012,'飞天茅台53度500ml','酱香经典','/static/product/6171.jpg','<p>茅台飞天53度，国酒经典，酱香浓郁</p>','/product_detail/6171.jpg',2,1,0,1,'审核通过','2026-08-30 10:00:00','2026-08-30 09:00:00','2026-08-30 09:00:00',0),(6172,5016,2012,'五粮液52度500ml','浓香典范','/static/product/6172.jpg','<p>五粮液52度，浓香典范，品质保证</p>','/product_detail/6172.jpg',2,1,0,1,'审核通过','2026-08-30 11:00:00','2026-08-30 10:30:00','2026-08-30 10:30:00',0),(6173,5032,2013,'玫瑰鲜花束11朵','浪漫表白','/static/product/6173.jpg','<p>精选红玫瑰11朵，浪漫表白首选</p>','/product_detail/6173.jpg',2,1,0,1,'审核通过','2026-08-31 10:00:00','2026-08-31 09:00:00','2026-08-31 09:00:00',0),(6174,5032,2013,'多肉植物组合6颗','桌面绿植','/static/product/6174.jpg','<p>精选多肉植物组合，桌面绿植，净化空气</p>','/product_detail/6174.jpg',2,1,0,1,'审核通过','2026-08-31 11:00:00','2026-08-31 10:30:00','2026-08-31 10:30:00',0),(6175,5025,2014,'美的空调1.5匹','变频节能','/static/product/6175.jpg','<p>美的变频空调1.5匹，节能静音，舒适凉爽</p>','/product_detail/6175.jpg',3,1,0,1,'审核通过','2026-09-01 10:00:00','2026-09-01 09:00:00','2026-09-01 09:00:00',0),(6176,5025,2014,'小米电视55英寸','4K超清','/static/product/6176.jpg','<p>小米电视55英寸，4K超清，智能语音</p>','/product_detail/6176.jpg',3,1,0,1,'审核通过','2026-09-01 11:00:00','2026-09-01 10:30:00','2026-09-01 10:30:00',0),(6177,5001,2015,'农夫山泉矿泉水550ml*24','天然山泉','/static/product/6177.jpg','<p>农夫山泉天然矿泉水，24瓶整箱装</p>','/product_detail/6177.jpg',2,1,0,1,'审核通过','2026-09-02 10:00:00','2026-09-02 09:00:00','2026-09-02 09:00:00',0),(6178,5003,2015,'康师傅方便面5连包','红烧牛肉','/static/product/6178.jpg','<p>康师傅红烧牛肉面，5连包，方便快捷</p>','/product_detail/6178.jpg',2,1,0,1,'审核通过','2026-09-02 11:00:00','2026-09-02 10:30:00','2026-09-02 10:30:00',0),(6179,5019,2016,'普洱茶饼357g','勐海熟茶','/static/product/6179.jpg','<p>普洱熟茶勐海味，陈香醇厚，暖胃养生</p>','/product_detail/6179.jpg',2,1,0,1,'审核通过','2026-09-03 10:00:00','2026-09-03 09:00:00','2026-09-03 09:00:00',0),(6180,5019,2016,'陶瓷茶具套装','功夫茶具','/static/product/6180.jpg','<p>精美陶瓷功夫茶具套装，品茶必备</p>','/product_detail/6180.jpg',2,1,0,1,'审核通过','2026-09-03 11:00:00','2026-09-03 10:30:00','2026-09-03 10:30:00',0),(6181,5024,2017,'红木餐桌1.5米','紫檀木','/static/product/6181.jpg','<p>紫檀木红木餐桌1.5米，古典工艺，品质传承</p>','/product_detail/6181.jpg',3,1,0,1,'审核通过','2026-09-04 10:00:00','2026-09-04 09:00:00','2026-09-04 09:00:00',0),(6182,5024,2017,'红木沙发三件套','黄花梨','/static/product/6182.jpg','<p>黄花梨红木沙发三件套，中式风格，典雅大气</p>','/product_detail/6182.jpg',3,1,0,1,'审核通过','2026-09-04 11:00:00','2026-09-04 10:30:00','2026-09-04 10:30:00',0),(6183,5025,2018,'iPhone 15 Pro 256G','旗舰手机','/static/product/6183.jpg','<p>iPhone 15 Pro 256G，A17芯片，钛金属设计</p>','/product_detail/6183.jpg',3,1,0,1,'审核通过','2026-09-05 10:00:00','2026-09-05 09:00:00','2026-09-05 09:00:00',0),(6184,5025,2018,'MacBook Air M3','轻薄便携','/static/product/6184.jpg','<p>MacBook Air M3，轻薄便携，强劲性能</p>','/product_detail/6184.jpg',3,1,0,1,'审核通过','2026-09-05 11:00:00','2026-09-05 10:30:00','2026-09-05 10:30:00',0),(6185,5019,2019,'铁观音礼盒装250g','清香型','/static/product/6185.jpg','<p>铁观音清香型礼盒装，香气高扬，回甘持久</p>','/product_detail/6185.jpg',2,1,0,1,'审核通过','2026-09-06 10:00:00','2026-09-06 09:00:00','2026-09-06 09:00:00',0),(6186,5019,2019,'龙井茶叶250g','明前特级','/static/product/6186.jpg','<p>西湖龙井明前特级，清香甘醇，名茶之首</p>','/product_detail/6186.jpg',2,1,0,1,'审核通过','2026-09-06 11:00:00','2026-09-06 10:30:00','2026-09-06 10:30:00',0),(6187,5024,2020,'丝绸旗袍','真丝面料','/static/product/6187.jpg','<p>100%真丝面料旗袍，传统工艺，优雅大方</p>','/product_detail/6187.jpg',2,1,0,1,'审核通过','2026-09-07 10:00:00','2026-09-07 09:00:00','2026-09-07 09:00:00',0),(6188,5024,2020,'丝绸床单四件套','桑蚕丝','/static/product/6188.jpg','<p>100%桑蚕丝床单四件套，亲肤舒适，奢华享受</p>','/product_detail/6188.jpg',2,1,0,1,'审核通过','2026-09-07 11:00:00','2026-09-07 10:30:00','2026-09-07 10:30:00',0),(6189,5014,2021,'招牌红烧肉料理包','秘制配方','/static/product/6189.jpg','<p>秘制配方招牌红烧肉，肥而不腻，入口即化</p>','/product_detail/6189.jpg',2,1,0,1,'审核通过','2026-09-08 10:00:00','2026-09-08 09:00:00','2026-09-08 09:00:00',0),(6190,5014,2021,'海鲜炒饭料理包','现炒口感，无添加','/static/product/6190.jpg','<p>新鲜海鲜炒饭，粒粒分明，鲜香可口</p>','/product_detail/6190.jpg',2,1,0,1,'审核通过','2026-09-08 11:00:00','2026-09-08 10:30:00','2026-09-08 10:30:00',0),(6191,5039,2022,'品牌羽绒服','90%白鸭绒','/static/product/6191.jpg','<p>90%白鸭绒品牌羽绒服，保暖轻盈，时尚百搭</p>','/product_detail/6191.jpg',2,1,0,1,'审核通过','2026-09-09 10:00:00','2026-09-09 09:00:00','2026-09-09 09:00:00',0),(6192,5039,2022,'羊毛大衣','100%羊毛','/static/product/6192.jpg','<p>100%羊毛大衣，经典版型，气质优雅</p>','/product_detail/6192.jpg',2,1,0,1,'审核通过','2026-09-09 11:00:00','2026-09-09 10:30:00','2026-09-09 10:30:00',0),(6193,5002,2023,'畅销小说套装','经典文学','/static/product/6193.jpg','<p>经典文学畅销小说套装，提升阅读体验</p>','/product_detail/6193.jpg',2,1,0,1,'审核通过','2026-09-10 10:00:00','2026-09-10 09:00:00','2026-09-10 09:00:00',0),(6194,5026,2023,'钢笔礼盒套装','商务办公','/static/product/6194.jpg','<p>高档钢笔礼盒套装，商务办公必备</p>','/product_detail/6194.jpg',2,1,0,1,'审核通过','2026-09-10 11:00:00','2026-09-10 10:30:00','2026-09-10 10:30:00',0),(6195,5015,2024,'波士顿龙虾2斤','进口鲜活','/static/product/6195.jpg','<p>进口波士顿龙虾2斤，鲜活直供，肉质饱满</p>','/product_detail/6195.jpg',2,1,0,1,'审核通过','2026-09-11 10:00:00','2026-09-11 09:00:00','2026-09-11 09:00:00',0),(6196,5015,2024,'三文鱼刺身1斤','挪威进口','/static/product/6196.jpg','<p>挪威进口三文鱼刺身，新鲜直达，肉质鲜嫩</p>','/product_detail/6196.jpg',2,1,0,1,'审核通过','2026-09-11 11:00:00','2026-09-11 10:30:00','2026-09-11 10:30:00',0),(6197,5020,2025,'黄金项链20克','足金999','/static/product/6197.jpg','<p>足金999黄金项链20克，精致工艺，保值收藏</p>','/product_detail/6197.jpg',2,1,0,1,'审核通过','2026-09-12 10:00:00','2026-09-12 09:00:00','2026-09-12 09:00:00',0),(6198,5020,2025,'钻石戒指1克拉','VVS级','/static/product/6198.jpg','<p>VVS级钻石戒指1克拉，璀璨闪耀，永恒之选</p>','/product_detail/6198.jpg',2,1,0,1,'审核通过','2026-09-12 11:00:00','2026-09-12 10:30:00','2026-09-12 10:30:00',0);
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
INSERT INTO `product_category_relation` VALUES (1,6001,201),(2,6002,201),(3,6003,201),(4,6004,201),(5,6005,201),(6,6006,201),(7,6007,201),(8,6008,201),(9,6009,101),(10,6010,101),(11,6011,101),(12,6012,201),(13,6013,202),(14,6014,202),(15,6015,202),(16,6016,202),(17,6017,107),(18,6018,107),(19,6019,201),(20,6020,107),(21,6021,203),(22,6022,203),(23,6023,203),(24,6024,203),(25,6025,101),(26,6026,101),(27,6027,101),(28,6028,101),(29,6029,102),(30,6030,102),(31,6031,102),(32,6032,102),(33,6033,102),(34,6034,102),(35,6035,103),(36,6036,103),(37,6037,103),(38,6038,103),(39,6039,103),(40,6040,103),(41,6041,104),(42,6042,104),(43,6043,104),(44,6044,104),(45,6045,104),(46,6046,104),(47,6047,105),(48,6048,105),(49,6049,105),(50,6050,105),(51,6051,105),(52,6052,106),(53,6053,106),(54,6054,106),(55,6055,106),(56,6056,106),(57,6057,107),(58,6058,107),(59,6059,108),(60,6060,108),(61,6061,108),(62,6062,108),(63,6063,108),(64,6064,202),(65,6065,202),(66,6066,202),(67,6067,203),(68,6068,203),(69,6069,203),(70,6070,201),(71,6071,201),(72,6072,201),(73,6073,204),(74,6074,204),(75,6075,202),(76,6076,205),(77,6077,107),(78,6078,107),(79,6079,202),(80,6080,206),(81,6081,206),(82,6082,206),(83,6083,206),(84,6084,206),(85,6085,207),(86,6086,207),(87,6087,207),(88,6088,207),(89,6089,207),(90,6090,208),(91,6091,208),(92,6092,208),(93,6093,101),(94,6094,104),(95,6095,301),(96,6096,301),(97,6097,301),(98,6098,301),(99,6099,301),(100,6100,302),(101,6101,302),(102,6102,302),(103,6103,302),(104,6104,302),(105,6105,303),(106,6106,303),(107,6107,303),(108,6108,303),(109,6109,304),(110,6110,304),(111,6111,304),(112,6112,304),(113,6113,305),(114,6114,305),(115,6115,305),(116,6116,306),(117,6117,306),(118,6118,306),(119,6119,307),(120,6120,307),(121,6121,307),(122,6122,308),(123,6123,308),(124,6124,308),(125,6125,309),(126,6126,309),(127,6127,309),(128,6128,401),(129,6129,401),(130,6130,401),(131,6131,402),(132,6132,402),(133,6133,402),(134,6134,403),(135,6135,403),(136,6136,404),(137,6137,404),(138,6138,405),(139,6139,405),(140,6140,405),(141,6141,501),(142,6142,501),(143,6143,501),(144,6144,502),(145,6145,502),(146,6146,503),(147,6147,503),(148,6148,504),(149,6149,504),(150,6150,505),(151,6151,506),(152,6152,506),(153,6153,601),(154,6154,601),(155,6155,602),(156,6156,602),(157,6157,603),(158,6158,603),(159,6159,604),(160,6160,604),(161,6161,605),(162,6162,605),(163,6163,606),(164,6164,606),(165,6165,607),(166,6166,607),(167,6167,608),(168,6168,608),(169,6169,103),(170,6170,104),(171,6171,204),(172,6172,204),(173,6173,308),(174,6174,308),(175,6175,302),(176,6176,302),(177,6177,203),(178,6178,201),(179,6179,206),(180,6180,403),(181,6181,301),(182,6182,301),(183,6183,302),(184,6184,302),(185,6185,206),(186,6186,206),(187,6187,301),(188,6188,301),(189,6189,107),(190,6190,107),(191,6191,506),(192,6192,506),(193,6193,201),(194,6194,403),(195,6195,104),(196,6196,104),(197,6197,506),(198,6198,506),(7001,6001,201),(7002,6002,201),(7003,6003,201),(7004,6004,201),(7005,6005,201),(7006,6006,201),(7007,6007,201),(7008,6008,201),(7009,6009,101),(7010,6010,101),(7011,6011,101),(7012,6012,201),(7013,6013,202),(7014,6014,202),(7015,6015,202),(7016,6016,202),(7017,6017,107),(7018,6018,107),(7019,6019,103),(7020,6020,107),(7021,6021,203),(7022,6022,203),(7023,6023,203),(7024,6024,203);
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
  `order_id` bigint DEFAULT NULL COMMENT '订单ID',
  `order_item_id` bigint DEFAULT NULL COMMENT '订单明细ID',
  `product_id` bigint DEFAULT NULL COMMENT '商品ID',
  `sku_id` bigint DEFAULT NULL COMMENT 'SKU ID',
  `user_id` bigint DEFAULT NULL COMMENT '用户ID',
  `score` tinyint DEFAULT NULL COMMENT '评分（1~5分）',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '评价内容',
  `images` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '评价图片',
  `anonymous` tinyint DEFAULT NULL COMMENT '是否匿名',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态：0-隐藏，1-展示，2-用户删除，3-后台屏蔽',
  `create_time` datetime DEFAULT NULL COMMENT '评价时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `delete_time` datetime DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_order_item_user` (`order_item_id`,`user_id`),
  KEY `fk_product_comment_order_item` (`order_item_id`) USING BTREE,
  KEY `fk_product_comment_product` (`product_id`) USING BTREE,
  KEY `fk_product_comment_user` (`user_id`) USING BTREE,
  KEY `idx_product_comment_order_id` (`order_id`) USING BTREE,
  KEY `idx_product_comment_sku_id` (`sku_id`) USING BTREE,
  KEY `idx_product_comment_status` (`status`) USING BTREE,
  KEY `idx_product_comment_create_time` (`create_time`) USING BTREE,
  CONSTRAINT `fk_product_comment_order` FOREIGN KEY (`order_id`) REFERENCES `order` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_product_comment_order_item` FOREIGN KEY (`order_item_id`) REFERENCES `order_item` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_product_comment_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_product_comment_sku` FOREIGN KEY (`sku_id`) REFERENCES `sku` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_product_comment_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='商品评价表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_comment`
--

LOCK TABLES `product_comment` WRITE;
/*!40000 ALTER TABLE `product_comment` DISABLE KEYS */;
INSERT INTO `product_comment` VALUES (1,53,93,6009,8009,1007,5,'味道不错，包装完好','',0,1,'2026-05-09 10:00:00','2026-07-07 09:45:11',NULL),(2,54,94,6002,8002,1008,4,'物流很快，品质很好','',0,1,'2026-05-11 09:00:00','2026-07-07 09:45:11',NULL),(3,54,95,6004,8004,1008,5,'旺旺雪饼还是小时候的味道，很好吃','',0,1,'2026-05-11 09:30:00','2026-07-07 09:45:11',NULL),(4,56,97,6006,8006,1009,4,'蛋黄酥口感不错，会回购的','',0,1,'2026-05-13 08:00:00','2026-07-07 09:45:11',NULL),(5,56,98,6008,8008,1009,5,'雪花酥奶香味很浓，好吃','',1,1,'2026-05-13 09:00:00','2026-07-07 09:45:11',NULL),(6,57,99,6013,8013,1010,5,'大米质量很好，煮饭很香','',0,1,'2026-05-15 10:00:00','2026-07-07 09:45:11',NULL),(7,57,100,6015,8015,1010,4,'价格实惠，会回购','',0,1,'2026-05-15 11:00:00','2026-07-07 09:45:11',NULL);
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
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_seckill_activity_sku` (`seckill_activity_id`,`sku_id`),
  KEY `fk_seckill_act` (`seckill_activity_id`) USING BTREE,
  KEY `fk_seckill_product` (`product_id`) USING BTREE,
  KEY `idx_seckill_product_activity_status` (`seckill_activity_id`,`status`),
  CONSTRAINT `fk_seckill_act` FOREIGN KEY (`seckill_activity_id`) REFERENCES `seckill_activity` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_seckill_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='秒杀商品表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `seckill_product`
--

LOCK TABLES `seckill_product` WRITE;
/*!40000 ALTER TABLE `seckill_product` DISABLE KEYS */;
INSERT INTO `seckill_product` VALUES (1,1,6009,'AKS-APPLE-10J-85',29.90,50,48,3,1,NULL,NULL),(2,1,6010,'FJ-ORANGE-8J-75',39.90,40,35,3,1,NULL,NULL),(3,1,6012,'WL-NUT-30B-750',69.00,30,25,3,1,NULL,NULL),(4,1,6016,'HS-FOOD-1B-1000',16.90,40,20,3,1,NULL,NULL),(5,2,6001,'AKS-NUT-30B-750',59.00,60,55,3,1,NULL,NULL),(6,2,6008,'BWW-SNOW-1B-300',19.90,30,28,3,1,NULL,NULL),(7,2,6017,'YY-CHICK-1B-210',13.90,80,75,3,1,NULL,NULL),(8,2,6021,'YQSL-DRINK-15B-7200',49.00,40,32,3,1,NULL,NULL),(9,2,6014,'HT-SAUCE-1T-1900',17.90,50,22,3,1,NULL,NULL),(10,3,6018,'JW-DUCK-1H-200',18.90,50,10,3,1,NULL,NULL),(11,3,6022,'NFSQ-JUICE-1B-900',14.90,60,8,3,1,NULL,NULL),(12,3,6024,'XC-MANGOJUICE-1B-1000',16.90,50,5,3,1,NULL,NULL),(13,3,6003,'BWW-MANGO-1B-500',28.90,40,3,3,1,NULL,NULL),(16,1,6001,'8001',59.90,50,0,2,NULL,NULL,NULL),(17,1,6005,'8005',12.90,80,0,3,NULL,NULL,NULL),(18,1,6009,'8009',25.90,60,0,2,NULL,NULL,NULL),(19,1,6017,'8017',12.90,100,0,5,NULL,NULL,NULL),(20,2,6002,'8002',19.90,60,0,3,NULL,NULL,NULL),(21,2,6012,'8012',65.00,40,0,2,NULL,NULL,NULL),(22,2,6018,'8018',18.90,50,0,3,NULL,NULL,NULL),(23,2,6021,'8021',49.90,40,0,2,NULL,NULL,NULL),(24,3,6006,'8006',25.00,50,0,2,NULL,NULL,NULL),(25,3,6013,'8013',55.00,30,0,2,NULL,NULL,NULL),(26,3,6020,'8020',59.90,30,0,3,NULL,NULL,NULL),(27,3,6024,'8024',34.90,40,0,2,NULL,NULL,NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=8199 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='商品规格库存表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sku`
--

LOCK TABLES `sku` WRITE;
/*!40000 ALTER TABLE `sku` DISABLE KEYS */;
INSERT INTO `sku` VALUES (8001,6001,'{\"规格\":\"30包装\",\"净重\":\"600g-750g\"}',77.00,90,'AKS-NUT-30B-750'),(8002,6002,'{\"规格\":\"1袋装\",\"净重\":\"200g\",\"口味\":\"卤香\"}',26.00,180,'LPPZ-CHICK-1B-200'),(8003,6003,'{\"规格\":\"1袋装\",\"净重\":\"500g\"}',35.90,150,'BWW-MANGO-1B-500'),(8004,6004,'{\"规格\":\"1袋装\",\"净重\":\"520g\"}',22.90,222,'WW-RICE-1B-520'),(8005,6005,'{\"规格\":\"10包装\",\"单包\":\"68g\"}',19.90,300,'WL-LATIAO-10B-680'),(8006,6006,'{\"规格\":\"6枚盒装\",\"净重\":\"360g\"}',35.00,130,'LPPZ-YOLK-6P-360'),(8007,6007,'{\"规格\":\"1盒装\",\"净重\":\"400g\"}',24.90,110,'DIY-CAKE-1B-400'),(8008,6008,'{\"规格\":\"1袋装\",\"净重\":\"300g\"}',27.90,160,'BWW-SNOW-1B-300'),(8009,6009,'{\"规格\":\"5斤装\",\"果径\":\"80-85mm\"}',36.90,200,'AKS-APPLE-10J-85'),(8010,6010,'{\"规格\":\"8斤装\",\"果径\":\"75-80mm\"}',49.90,140,'FJ-ORANGE-8J-75'),(8011,6011,'{\"规格\":\"12粒礼盒\",\"等级\":\"特级\"}',118.00,50,'ZESP-KIWI-12P-S'),(8012,6012,'{\"规格\":\"30包装\",\"净重\":\"750g\"}',85.00,130,'WL-NUT-30B-750'),(8013,6013,'{\"规格\":\"1袋装\",\"净重\":\"5000g\"}',68.00,80,'JLY-RICE-1P-5000'),(8014,6014,'{\"规格\":\"1桶装\",\"容量\":\"1900ml\"}',22.90,160,'HT-SAUCE-1T-1900'),(8015,6015,'{\"规格\":\"20包装\",\"单包\":\"80g\"}',16.90,300,'FL-PICKLE-20B-1600'),(8016,6016,'{\"规格\":\"1袋装\",\"净重\":\"1000g\"}',22.00,120,'HS-FOOD-1B-1000'),(8017,6017,'{\"规格\":\"1袋装\",\"净重\":\"210g\",\"口味\":\"山椒\"}',18.90,220,'YY-CHICK-1B-210'),(8018,6018,'{\"规格\":\"1盒\",\"净重\":\"200g\",\"口味\":\"香辣\"}',24.90,142,'JW-DUCK-1H-200'),(8019,6019,'{\"规格\":\"1袋装\",\"净重\":\"150g\"}',29.90,110,'HD-BEEF-1B-150'),(8020,6020,'{\"规格\":\"1盒装\",\"净重\":\"300g\"}',16.90,171,'LX-EGG-1H-300'),(8021,6021,'{\"规格\":\"15瓶装\",\"单瓶\":\"480ml\",\"口味\":\"白桃\"}',65.00,90,'YQSL-DRINK-15B-7200'),(8022,6022,'{\"规格\":\"1瓶装\",\"容量\":\"900ml\"}',19.90,130,'NFSQ-JUICE-1B-900'),(8023,6023,'{\"规格\":\"12盒装\",\"单盒\":\"200g\"}',42.90,100,'MN-YOGURT-12B-2400'),(8024,6024,'{\"规格\":\"1瓶装\",\"容量\":\"1000ml\"}',22.90,153,'XC-MANGOJUICE-1B-1000'),(8025,6025,'{\"规格\":\"2斤装\",\"等级\":\"JJ级\",\"果径\":\"28-30mm\"}',128.00,60,'CL-CHERRY-2J-JJ'),(8026,6026,'{\"规格\":\"5斤装\",\"等级\":\"一级\"}',59.90,120,'HN-MANGO-5J-1'),(8027,6027,'{\"规格\":\"3斤装\",\"等级\":\"特级\"}',39.90,150,'XJ-GRAPE-3J-T'),(8028,6028,'{\"规格\":\"5斤装\",\"等级\":\"5A\"}',68.00,80,'TH-MANGOSTEEN-5J-5A'),(8029,6029,'{\"规格\":\"3颗装\",\"净重\":\"600g\"}',12.90,200,'YN-BABYCHINESE-3P-600'),(8030,6030,'{\"规格\":\"2颗装\",\"净重\":\"400g\"}',15.90,180,'YJ-BROCCOLI-2P-400'),(8031,6031,'{\"规格\":\"1袋装\",\"净重\":\"500g\"}',4.90,300,'SHQ-CABBAGE-1B-500'),(8032,6032,'{\"规格\":\"5斤装\",\"净重\":\"2500g\"}',19.90,150,'XHS-TOMATO-5J-2500'),(8033,6033,'{\"规格\":\"2颗装\",\"净重\":\"600g\"}',8.90,220,'ZG-CABBAGE-2P-600'),(8034,6034,'{\"规格\":\"3斤装\",\"净重\":\"1500g\"}',12.90,180,'SD-ONION-3J-1500'),(8035,6035,'{\"规格\":\"1袋装\",\"净重\":\"500g\"}',28.90,100,'HZ-PORK-1B-500'),(8036,6036,'{\"规格\":\"1袋装\",\"净重\":\"1000g\"}',68.00,60,'AUS-BEEF-1B-1000'),(8037,6037,'{\"规格\":\"1袋装\",\"净重\":\"1500g\"}',78.00,50,'NM-LAMB-1B-1500'),(8038,6038,'{\"规格\":\"1袋装\",\"净重\":\"500g\"}',32.90,90,'ZL-PORK-1B-500'),(8039,6039,'{\"规格\":\"1盒装\",\"净重\":\"500g\"}',35.90,80,'BEEF-ROLL-1H-500'),(8040,6040,'{\"规格\":\"1袋装\",\"净重\":\"500g\"}',25.90,120,'PIG-FEET-1B-500'),(8041,6041,'{\"规格\":\"1袋装\",\"净重\":\"400g\"}',45.90,70,'ECU-SHRIMP-1B-400'),(8042,6042,'{\"规格\":\"1袋装\",\"净重\":\"500g\"}',88.00,40,'NW-SALMON-1B-500'),(8043,6043,'{\"规格\":\"4只装\",\"净重\":\"800g\"}',198.00,30,'YCH-CRAB-4P-800'),(8044,6044,'{\"规格\":\"4只装\",\"净重\":\"400g\"}',68.00,50,'ABALONE-4P-400'),(8045,6045,'{\"规格\":\"1袋装\",\"净重\":\"500g\"}',28.90,100,'SCALLOP-1B-500'),(8046,6046,'{\"规格\":\"1袋装\",\"净重\":\"500g\"}',15.90,150,'CLAM-1B-500'),(8047,6047,'{\"规格\":\"1只装\",\"净重\":\"1500g\"}',58.00,60,'TJ-CHICKEN-1P-1500'),(8048,6048,'{\"规格\":\"30枚装\",\"净重\":\"1800g\"}',28.90,100,'TJ-EGG-30P-1800'),(8049,6049,'{\"规格\":\"1只装\",\"净重\":\"2000g\"}',68.00,50,'TJ-DUCK-1P-2000'),(8050,6050,'{\"规格\":\"1袋装\",\"净重\":\"200g\"}',12.90,180,'QUAIL-EGG-1B-200'),(8051,6051,'{\"规格\":\"1只装\",\"净重\":\"500g\"}',48.00,40,'TJ-PIGEON-1P-500'),(8052,6052,'{\"规格\":\"1袋装\",\"净重\":\"500g\"}',25.90,120,'WZ-DUMPLING-1B-500'),(8053,6053,'{\"规格\":\"1袋装\",\"净重\":\"400g\"}',18.90,150,'SN-TANGYUAN-1B-400'),(8054,6054,'{\"规格\":\"1袋装\",\"净重\":\"500g\"}',22.90,130,'ZD-CHICKEN-1B-500'),(8055,6055,'{\"规格\":\"10只装\",\"净重\":\"500g\"}',28.90,100,'SD-BUN-10P-500'),(8056,6056,'{\"规格\":\"10片装\",\"净重\":\"400g\"}',18.90,160,'SZB-PANCAKE-10P-400'),(8057,6057,'{\"规格\":\"1盒\",\"净重\":\"300g\"}',29.90,100,'ZHY-DUCK-1H-300'),(8058,6058,'{\"规格\":\"2只装\",\"净重\":\"400g\"}',38.00,80,'CD-RABBIT-2P-400'),(8059,6059,'{\"规格\":\"1杯\",\"净重\":\"81g\"}',35.00,60,'HDZS-ICE-1C-81'),(8060,6060,'{\"规格\":\"1盒\",\"容量\":\"500ml\"}',28.00,80,'BX-ICE-1H-500'),(8061,6061,'{\"规格\":\"1块\",\"净重\":\"200g\"}',38.00,50,'TLMS-CAKE-1P-200'),(8062,6062,'{\"规格\":\"4个装\",\"净重\":\"400g\"}',45.00,60,'MANGO-PANCAKE-4P-400'),(8063,6063,'{\"规格\":\"1杯\",\"容量\":\"300ml\"}',22.00,100,'YZML-DRINK-1C-300'),(8064,6064,'{\"规格\":\"1桶装\",\"容量\":\"5000ml\"}',98.00,40,'LH-OIL-1T-5000'),(8065,6065,'{\"规格\":\"1瓶装\",\"净重\":\"280g\"}',12.90,200,'LGM-SAUCE-1B-280'),(8066,6066,'{\"规格\":\"1袋装\",\"净重\":\"2500g\"}',28.90,80,'DB-MILLET-1B-2500'),(8067,6067,'{\"规格\":\"6瓶装\",\"单瓶\":\"500ml\"}',45.00,70,'QD-BEER-6B-3000'),(8068,6068,'{\"规格\":\"48杯装\",\"单杯\":\"15g\"}',68.00,50,'QC-COFFEE-48C-720'),(8069,6069,'{\"规格\":\"24盒装\",\"单盒\":\"250ml\"}',68.00,60,'MN-MILK-24B-6000'),(8070,6070,'{\"规格\":\"30粒装\",\"净重\":\"300g\"}',168.00,30,'FLR-CHOCOLATE-30P-300'),(8071,6071,'{\"规格\":\"1袋装\",\"净重\":\"100g\"}',18.90,120,'MJ-CHOCOLATE-1B-100'),(8072,6072,'{\"规格\":\"1袋装\",\"净重\":\"192g\"}',22.90,100,'LOTTE-BISCUIT-1B-192'),(8073,6073,'{\"规格\":\"1瓶装\",\"容量\":\"500ml\"}',1499.00,10,'MT-WINE-1B-500'),(8074,6074,'{\"规格\":\"1瓶装\",\"容量\":\"750ml\"}',298.00,20,'FR-WINE-1B-750'),(8075,6075,'{\"规格\":\"1盒装\",\"净重\":\"500g\"}',68.00,50,'CQ-HOTPOT-1H-500'),(8076,6076,'{\"规格\":\"1盒\",\"净重\":\"300g\"}',48.00,60,'YN-FLOWERCAKE-1H-300'),(8077,6077,'{\"规格\":\"1袋装\",\"净重\":\"500g\"}',45.00,80,'SC-SAUSAGE-1B-500'),(8078,6078,'{\"规格\":\"1袋装\",\"净重\":\"500g\"}',48.00,70,'HN-BACON-1B-500'),(8079,6079,'{\"规格\":\"1瓶装\",\"容量\":\"500ml\"}',38.00,80,'SX-VINEGAR-1B-500'),(8080,6080,'{\"规格\":\"1袋装\",\"净重\":\"250g\"}',128.00,30,'XH-LONGJING-1B-250'),(8081,6081,'{\"规格\":\"1袋装\",\"净重\":\"250g\"}',88.00,40,'TGY-TIEGUANYIN-1B-250'),(8082,6082,'{\"规格\":\"1袋装\",\"净重\":\"100g\"}',168.00,20,'DHP-DAHONGPAO-1B-100'),(8083,6083,'{\"规格\":\"100包\",\"净重\":\"200g\"}',35.00,100,'LDT-TEA-100B-200'),(8084,6084,'{\"规格\":\"1饼\",\"净重\":\"357g\"}',268.00,20,'PR-Tea-1P-357'),(8085,6085,'{\"规格\":\"1盒装\",\"净重\":\"250g\"}',398.00,20,'TRT-EJIAO-1H-250'),(8086,6086,'{\"规格\":\"1罐\",\"净重\":\"450g\"}',328.00,30,'TCBJ-PROTEIN-1G-450'),(8087,6087,'{\"规格\":\"1瓶装\",\"净重\":\"100g\"}',168.00,40,'YXS-GINSENG-1B-100'),(8088,6088,'{\"规格\":\"1盒\",\"净重\":\"50g\"}',888.00,10,'YANWO-BIRD-1H-50'),(8089,6089,'{\"规格\":\"1瓶装\",\"容量\":\"100粒\"}',198.00,40,'TCBJ-FISH-OIL-1B-100'),(8090,6090,'{\"规格\":\"1盒\",\"净重\":\"800g\"}',188.00,30,'ZY-MOONCAKE-1H-800'),(8091,6091,'{\"规格\":\"1盒\",\"净重\":\"1000g\"}',168.00,40,'JS-NUT-1H-1000'),(8092,6092,'{\"规格\":\"1盒\",\"净重\":\"3000g\"}',298.00,20,'NY-GRAIN-1H-3000'),(8093,6093,'{\"规格\":\"1盒\",\"净重\":\"2000g\"}',198.00,30,'JK-FRUIT-1H-2000'),(8094,6094,'{\"规格\":\"1盒\",\"净重\":\"2500g\"}',288.00,20,'HX-SEAFOOD-1H-2500'),(8095,6095,'{\"规格\":\"1套\",\"尺寸\":\"1.8m\"}',398.00,30,'SXJF-BED-1S-180'),(8096,6096,'{\"规格\":\"3条装\",\"尺寸\":\"34cm*74cm\"}',48.00,100,'CM-TOWEL-3P-2516'),(8097,6097,'{\"规格\":\"1床\",\"尺寸\":\"2.0m*2.3m\"}',598.00,20,'CSB-QUILT-1B-200'),(8098,6098,'{\"规格\":\"1对\",\"尺寸\":\"48cm*74cm\"}',168.00,40,'ZT-PILLOW-1P-3552'),(8099,6099,'{\"规格\":\"1条\",\"尺寸\":\"70cm*140cm\"}',78.00,80,'CM-BATH-1P-9800'),(8100,6100,'{\"规格\":\"1个\",\"功率\":\"36W\"}',198.00,50,'OP-CEILING-1P-36W'),(8101,6101,'{\"规格\":\"1个\",\"功率\":\"12W\"}',88.00,80,'OP-DESK-1P-12W'),(8102,6102,'{\"规格\":\"1个\",\"功率\":\"24W\"}',158.00,60,'OP-FLOOR-1P-24W'),(8103,6103,'{\"规格\":\"1个\",\"功率\":\"5W\"}',38.00,120,'OP-NIGHT-1P-5W'),(8104,6104,'{\"规格\":\"1个\",\"功率\":\"24W\"}',128.00,70,'OP-KITCHEN-1P-24W'),(8105,6105,'{\"规格\":\"5件套\",\"材质\":\"PP\"}',88.00,60,'LLKK-BOX-5P-PP'),(8106,6106,'{\"规格\":\"1个\",\"尺寸\":\"45cm*35cm*30cm\"}',45.00,80,'SNX-BOX-1P-4725'),(8107,6107,'{\"规格\":\"3件套\",\"尺寸\":\"25cm*18cm*8cm\"}',28.00,120,'SNX-DRAWER-3P-3600'),(8108,6108,'{\"规格\":\"1个\",\"尺寸\":\"60cm*40cm*20cm\"}',58.00,70,'SNX-CLOSET-1P-4800'),(8109,6109,'{\"规格\":\"1瓶装\",\"容量\":\"3000ml\"}',45.00,100,'LYL-WASH-1B-3000'),(8110,6110,'{\"规格\":\"3包\",\"每包\":\"100抽\"}',28.00,120,'WD-TISSUE-3P-300'),(8111,6111,'{\"规格\":\"1包\",\"每包\":\"100片\"}',18.90,150,'XD-WIPE-1P-100'),(8112,6112,'{\"规格\":\"1瓶装\",\"容量\":\"500ml\"}',12.90,180,'JCW-CLEAN-1B-500'),(8113,6113,'{\"规格\":\"1个\",\"尺寸\":\"44cm*36cm\"}',88.00,60,'JP-TOILET-1P-1584'),(8114,6114,'{\"规格\":\"1套\",\"材质\":\"不锈钢\"}',398.00,30,'JP-SHOWER-1S-SS'),(8115,6115,'{\"规格\":\"2个装\",\"材质\":\"塑料\"}',18.90,150,'SKC-SET-2P-PP'),(8116,6116,'{\"规格\":\"1把\",\"尺寸\":\"105cm\"}',58.00,80,'TT-UMBRELLA-1P-105'),(8117,6117,'{\"规格\":\"1件\",\"尺寸\":\"均码\"}',68.00,60,'TT-RAINCOAT-1P-F'),(8118,6118,'{\"规格\":\"1件\",\"颜色\":\"白色\"}',88.00,70,'TT-SUN-1P-W'),(8119,6119,'{\"规格\":\"1个\",\"材质\":\"不锈钢\"}',68.00,60,'CHY-RACK-1P-SS'),(8120,6120,'{\"规格\":\"1个\",\"材质\":\"钢木\"}',88.00,50,'CHY-IRONING-1P-WS'),(8121,6121,'{\"规格\":\"10个装\",\"材质\":\"塑料\"}',12.90,200,'CHY-HANGER-10P-PP'),(8122,6122,'{\"规格\":\"1个\",\"材质\":\"陶瓷\"}',68.00,60,'YK-VASE-1P-C'),(8123,6123,'{\"规格\":\"1束\",\"材质\":\"仿真\"}',45.00,80,'FK-FLOWER-1B-F'),(8124,6124,'{\"规格\":\"1盆\",\"材质\":\"多肉\"}',28.00,100,'DL-PLANT-1P-SUCC'),(8125,6125,'{\"规格\":\"1袋\",\"净重\":\"1500g\"}',98.00,50,'HJ-CATFOOD-1B-1500'),(8126,6126,'{\"规格\":\"1袋\",\"净重\":\"1500g\"}',98.00,50,'HJ-DOGFOOD-1B-1500'),(8127,6127,'{\"规格\":\"1袋\",\"净重\":\"10000g\"}',58.00,40,'CATLITTER-1B-10000'),(8128,6128,'{\"规格\":\"1个\",\"尺寸\":\"32cm\"}',298.00,30,'EBR-PAN-1P-32'),(8129,6129,'{\"规格\":\"1个\",\"容量\":\"5L\"}',398.00,25,'EBR-PRESSURE-1P-5L'),(8130,6130,'{\"规格\":\"1个\",\"尺寸\":\"34cm\"}',198.00,40,'EBR-WOK-1P-34'),(8131,6131,'{\"规格\":\"1把\",\"尺寸\":\"18cm\"}',68.00,60,'ZXQ-KNIFE-1P-18'),(8132,6132,'{\"规格\":\"1把\",\"尺寸\":\"10cm\"}',28.00,100,'ZXQ-SCISSORS-1P-10'),(8133,6133,'{\"规格\":\"1块\",\"尺寸\":\"38cm*26cm\"}',48.00,80,'ZB-CHOPPING-1P-988'),(8134,6134,'{\"规格\":\"1个\",\"容量\":\"500ml\"}',68.00,70,'FG-MUG-1P-500'),(8135,6135,'{\"规格\":\"1个\",\"容量\":\"350ml\"}',38.00,100,'FG-GLASS-1P-350'),(8136,6136,'{\"规格\":\"4件套\",\"材质\":\"玻璃\"}',128.00,40,'KN-BOWL-4P-GLASS'),(8137,6137,'{\"规格\":\"6件套\",\"材质\":\"陶瓷\"}',168.00,35,'TC-DISH-6P-CER'),(8138,6138,'{\"规格\":\"1台\",\"容量\":\"1.2L\"}',398.00,25,'JY-SOYMILK-1P-1200'),(8139,6139,'{\"规格\":\"1台\",\"容量\":\"4L\"}',298.00,30,'JY-RICECOOKER-1P-4L'),(8140,6140,'{\"规格\":\"1个\",\"尺寸\":\"40cm*30cm*50cm\"}',58.00,60,'KITCHEN-RACK-1P-6000'),(8141,6141,'{\"规格\":\"1支\",\"容量\":\"100ml\"}',128.00,50,'OLAY-CLEANSER-1P-100'),(8142,6142,'{\"规格\":\"1瓶\",\"容量\":\"50ml\"}',298.00,40,'OLAY-CREAM-1P-50'),(8143,6143,'{\"规格\":\"1瓶\",\"容量\":\"30ml\"}',398.00,30,'OLAY-SERUM-1P-30'),(8144,6144,'{\"规格\":\"1瓶\",\"容量\":\"500ml\"}',58.00,80,'DOVE-BATH-1B-500'),(8145,6145,'{\"规格\":\"1瓶\",\"容量\":\"200ml\"}',48.00,100,'DOVE-BODY-1B-200'),(8146,6146,'{\"规格\":\"1瓶\",\"容量\":\"500ml\"}',68.00,80,'PT-SHAMPOO-1B-500'),(8147,6147,'{\"规格\":\"1瓶\",\"容量\":\"300ml\"}',58.00,100,'PT-CONDITIONER-1B-300'),(8148,6148,'{\"规格\":\"1支\",\"净重\":\"120g\"}',28.00,150,'GLJ-TOOTHPASTE-1P-120'),(8149,6149,'{\"规格\":\"1个\",\"颜色\":\"白色\"}',198.00,40,'DY-TOOTHBRUSH-1P-W'),(8150,6150,'{\"规格\":\"1包\",\"数量\":\"24片\"}',35.00,100,'HSB-PAD-1P-24'),(8151,6151,'{\"规格\":\"1瓶\",\"容量\":\"50ml\"}',998.00,15,'DIO-PERFUME-1B-50'),(8152,6152,'{\"规格\":\"1支\",\"颜色\":\"正红\"}',128.00,50,'MBL-LIPSTICK-1P-R'),(8153,6153,'{\"规格\":\"1罐\",\"净重\":\"900g\"}',398.00,30,'MZYM-MILK-3-1G-900'),(8154,6154,'{\"规格\":\"1罐\",\"净重\":\"900g\"}',298.00,40,'MZYM-MILK-1-1G-900'),(8155,6155,'{\"规格\":\"1罐\",\"净重\":\"400g\"}',88.00,60,'HS-RICE-1G-400'),(8156,6156,'{\"规格\":\"1袋\",\"净重\":\"100g\"}',35.00,100,'HS-PUREE-1B-100'),(8157,6157,'{\"规格\":\"1包\",\"数量\":\"50片\"}',88.00,50,'BBS-DIAPER-1P-50'),(8158,6158,'{\"规格\":\"1包\",\"数量\":\"80片\"}',28.00,120,'BBS-WIPE-1P-80'),(8159,6159,'{\"规格\":\"1个\",\"容量\":\"240ml\"}',68.00,60,'BQ-BOTTLE-1P-240'),(8160,6160,'{\"规格\":\"1个\",\"材质\":\"PP\"}',38.00,80,'BQ-BOWL-1P-PP'),(8161,6161,'{\"规格\":\"1瓶\",\"容量\":\"200ml\"}',48.00,80,'BB-BATH-1B-200'),(8162,6162,'{\"规格\":\"1瓶\",\"容量\":\"50g\"}',58.00,70,'BB-CREAM-1B-50'),(8163,6163,'{\"规格\":\"1套\",\"尺码\":\"100\"}',128.00,50,'TZ-SET-1S-100'),(8164,6164,'{\"规格\":\"1件\",\"尺码\":\"90\"}',88.00,70,'YY-ONESIE-1P-90'),(8165,6165,'{\"规格\":\"1件\",\"尺码\":\"均码\"}',168.00,40,'YF-DRESS-1P-F'),(8166,6166,'{\"规格\":\"1罐\",\"净重\":\"900g\"}',198.00,50,'YF-MILK-1G-900'),(8167,6167,'{\"规格\":\"1辆\",\"颜色\":\"蓝色\"}',598.00,20,'TC-STROLLER-1P-B'),(8168,6168,'{\"规格\":\"1个\",\"适用年龄\":\"0-4岁\"}',998.00,15,'AQ-SEAT-1P-04'),(8169,6169,'{\"规格\":\"1份\",\"净重\":\"500g\"}',35.00,100,'FRESH-PORK-1P-500'),(8170,6170,'{\"规格\":\"1份\",\"净重\":\"500g\"}',68.00,50,'FRESH-SHRIMP-1P-500'),(8171,6171,'{\"规格\":\"1瓶\",\"容量\":\"500ml\"}',1499.00,10,'MOUTAI-53-1B-500'),(8172,6172,'{\"规格\":\"1瓶\",\"容量\":\"500ml\"}',599.00,20,'WULIANGYE-52-1B-500'),(8173,6173,'{\"规格\":\"1束\",\"数量\":\"11朵\"}',168.00,30,'FLOWER-ROSE-1B-11'),(8174,6174,'{\"规格\":\"1盆\",\"数量\":\"6颗\"}',58.00,50,'PLANT-SUCC-1P-6'),(8175,6175,'{\"规格\":\"1台\",\"匹数\":\"1.5匹\"}',2599.00,15,'MIDEA-AC-1P-15'),(8176,6176,'{\"规格\":\"1台\",\"尺寸\":\"55英寸\"}',2999.00,10,'MI-TV-1P-55'),(8177,6177,'{\"规格\":\"1箱\",\"数量\":\"24瓶\"}',24.90,100,'NFSQ-WATER-1C-24'),(8178,6178,'{\"规格\":\"5包\",\"口味\":\"红烧牛肉\"}',12.90,200,'KSF-NODDLE-5P-BEEF'),(8179,6179,'{\"规格\":\"1饼\",\"净重\":\"357g\"}',198.00,40,'PUER-TEA-1C-357'),(8180,6180,'{\"规格\":\"1套\",\"材质\":\"陶瓷\"}',268.00,20,'TEA-SET-1S-CER'),(8181,6181,'{\"规格\":\"1张\",\"尺寸\":\"1.5米\"}',8800.00,5,'WOOD-TABLE-1P-150'),(8182,6182,'{\"规格\":\"1套\",\"材质\":\"黄花梨\"}',8900.00,5,'WOOD-SOFA-1S-HHL'),(8183,6183,'{\"规格\":\"1部\",\"容量\":\"256GB\"}',5688.00,10,'IPHONE-15P-1U-256'),(8184,6184,'{\"规格\":\"1台\",\"配置\":\"8GB+256GB\"}',3298.00,8,'MACBOOK-AIR-1P-M3'),(8185,6185,'{\"规格\":\"1盒\",\"净重\":\"250g\"}',188.00,30,'TIEGUANYIN-1H-250'),(8186,6186,'{\"规格\":\"1盒\",\"净重\":\"250g\"}',288.00,25,'LONGJING-1H-250'),(8187,6187,'{\"规格\":\"1件\",\"尺码\":\"M码\"}',598.00,20,'SILK-QIPAO-1P-M'),(8188,6188,'{\"规格\":\"1套\",\"尺寸\":\"1.8米\"}',1256.00,15,'SILK-BED-1S-180'),(8189,6189,'{\"规格\":\"1份\",\"重量\":\"500g\"}',68.00,50,'RESTAURANT-PORK-1P-500'),(8190,6190,'{\"规格\":\"1份\",\"份量\":\"2人份\"}',88.00,60,'RESTAURANT-RICE-1P-2'),(8191,6191,'{\"规格\":\"1件\",\"尺码\":\"L码\"}',899.00,25,'FASHION-DOWN-1P-L'),(8192,6192,'{\"规格\":\"1件\",\"尺码\":\"M码\"}',1299.00,20,'FASHION-COAT-1P-M'),(8193,6193,'{\"规格\":\"1套\",\"数量\":\"5本\"}',88.00,50,'BOOK-SET-1S-5'),(8194,6194,'{\"规格\":\"1套\",\"材质\":\"钢笔\"}',168.00,30,'PEN-SET-1S-PEN'),(8195,6195,'{\"规格\":\"1只\",\"重量\":\"2斤\"}',398.00,20,'LOBSTER-1P-2'),(8196,6196,'{\"规格\":\"1份\",\"重量\":\"1斤\"}',188.00,30,'SALMON-1P-1'),(8197,6197,'{\"规格\":\"1条\",\"重量\":\"20克\"}',8888.00,10,'GOLD-NECKLACE-1P-20'),(8198,6198,'{\"规格\":\"1枚\",\"克拉\":\"1克拉\"}',10000.00,5,'DIAMOND-RING-1P-1');
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
-- Table structure for table `withdraw_record`
--

DROP TABLE IF EXISTS `withdraw_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `withdraw_record` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `distributor_id` bigint NOT NULL COMMENT '分销员ID',
  `amount` decimal(10,2) NOT NULL COMMENT '提现金额',
  `bank_name` varchar(100) NOT NULL COMMENT '开户银行',
  `bank_card_no` varchar(50) NOT NULL COMMENT '银行卡号',
  `account_name` varchar(50) NOT NULL COMMENT '开户人',
  `status` tinyint NOT NULL DEFAULT '0' COMMENT '提现状态：0-处理中，1-提现成功，2-提现失败',
  `apply_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '申请时间',
  PRIMARY KEY (`id`),
  KEY `idx_distributor` (`distributor_id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='提现记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `withdraw_record`
--

LOCK TABLES `withdraw_record` WRITE;
/*!40000 ALTER TABLE `withdraw_record` DISABLE KEYS */;
/*!40000 ALTER TABLE `withdraw_record` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='提现申请表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `withdrawal_record`
--

LOCK TABLES `withdrawal_record` WRITE;
/*!40000 ALTER TABLE `withdrawal_record` DISABLE KEYS */;
INSERT INTO `withdrawal_record` VALUES (1,2001,574.37,'62220000000000009','龙国建','中国工商 银行',0,NULL,'2026-07-06 14:13:12',NULL),(10,2003,16292.21,'62220000000000001','龙国建','中国工商银行',2,NULL,'2026-07-01 18:22:00','2026-07-03 13:35:00'),(11,2003,5375.15,'62280000000000003','王建国','中国农业银行',0,NULL,'2026-06-04 08:03:00',NULL),(12,2003,13908.53,'62270000000000002','陈明华','中国建设银行',1,NULL,'2026-05-26 09:13:00','2026-05-28 10:58:00'),(13,2003,6252.16,'62220000000000001','龙国建','中国工商银行',0,NULL,'2026-05-16 14:35:00',NULL),(14,2004,11500.53,'62270000000000002','陈明华','中国建设银行',1,NULL,'2026-06-04 10:11:00','2026-06-05 14:34:00'),(15,2004,9601.22,'62280000000000003','王建国','中国农业银行',1,NULL,'2026-06-12 11:55:00','2026-06-13 16:23:00'),(16,2004,19767.35,'62280000000000003','王建国','中国农业银行',1,NULL,'2026-06-04 14:42:00','2026-06-05 13:01:00'),(17,2004,18404.04,'62270000000000002','陈明华','中国建设银行',1,NULL,'2026-07-02 18:37:00','2026-07-04 17:02:00'),(18,2004,6020.19,'62220000000000001','龙国建','中国工商银行',2,NULL,'2026-06-19 11:44:00','2026-06-21 14:46:00'),(19,2007,3548.99,'62280000000000003','王建国','中国农业银行',1,NULL,'2026-06-13 10:00:00','2026-06-16 12:41:00'),(20,2007,16690.60,'62280000000000003','王建国','中国农业银行',0,NULL,'2026-06-20 15:51:00',NULL),(21,2007,2023.96,'62280000000000003','王建国','中国农业银行',2,NULL,'2026-05-14 09:38:00','2026-05-15 15:46:00'),(22,2007,7000.90,'62280000000000003','王建国','中国农业银行',1,NULL,'2026-06-29 14:20:00','2026-06-30 15:53:00'),(23,2010,7599.39,'62280000000000003','王建国','中国农业银行',1,NULL,'2026-07-03 13:48:00','2026-07-05 13:53:00'),(24,2010,13531.57,'62220000000000001','龙国建','中国工商银行',1,NULL,'2026-06-01 13:54:00','2026-06-04 16:12:00'),(25,2010,11147.25,'62220000000000001','龙国建','中国工商银行',0,NULL,'2026-06-03 09:48:00',NULL),(26,2001,809.65,'62270000000000012','张华','中国建设银行',1,NULL,'2026-06-24 12:20:00','2026-06-25 17:24:00'),(27,2001,1991.34,'62220000000000011','李明','中国工商银行',2,NULL,'2026-06-16 13:58:00','2026-06-18 14:17:00'),(28,2002,547.99,'62270000000000012','张华','中国建设银行',0,NULL,'2026-07-04 15:53:00',NULL),(29,2005,1543.37,'62270000000000012','张华','中国建设银行',0,NULL,'2026-06-12 14:12:00',NULL),(30,2005,2977.71,'62220000000000011','李明','中国工商银行',0,NULL,'2026-06-18 13:08:00',NULL),(31,2006,571.16,'62280000000000013','王芳','中国农业银行',0,NULL,'2026-06-14 15:54:00',NULL),(32,2006,2559.00,'62280000000000013','王芳','中国农业银行',0,NULL,'2026-06-15 13:05:00',NULL),(33,2008,444.61,'62220000000000011','李明','中国工商银行',1,NULL,'2026-05-29 18:50:00','2026-06-01 15:20:00'),(34,2009,2568.64,'62270000000000012','张华','中国建设银行',0,NULL,'2026-06-23 09:19:00',NULL),(35,2011,2012.37,'62280000000000013','王芳','中国农业银行',0,NULL,'2026-07-06 10:39:00',NULL),(36,2011,202.35,'62220000000000011','李明','中国工商银行',1,NULL,'2026-07-02 12:10:00','2026-07-05 09:24:00'),(37,2012,180.71,'62270000000000012','张华','中国建设银行',1,NULL,'2026-06-30 10:20:00','2026-07-01 11:47:00'),(38,2013,1508.63,'62220000000000011','李明','中国工商银行',1,NULL,'2026-06-18 10:50:00','2026-06-20 10:43:00'),(39,2014,2911.48,'62280000000000013','王芳','中国农业银行',1,NULL,'2026-06-19 08:24:00','2026-06-22 17:18:00'),(40,2015,138.88,'62280000000000013','王芳','中国农业银行',1,NULL,'2026-07-04 12:09:00','2026-07-07 16:27:00'),(41,2016,2959.29,'62270000000000012','张华','中国建设银行',0,NULL,'2026-06-22 11:05:00',NULL),(42,2017,1089.89,'62280000000000013','王芳','中国农业银行',1,NULL,'2026-06-15 09:09:00','2026-06-18 11:18:00'),(43,2018,808.18,'62220000000000011','李明','中国工商银行',1,NULL,'2026-06-28 15:13:00','2026-07-01 17:08:00'),(44,2018,2373.42,'62280000000000013','王芳','中国农业银行',2,NULL,'2026-06-25 17:12:00','2026-06-26 09:47:00'),(45,2019,1772.48,'62270000000000012','张华','中国建设银行',0,NULL,'2026-06-03 09:43:00',NULL),(46,2019,2311.53,'62270000000000012','张华','中国建设银行',0,NULL,'2026-06-20 08:43:00',NULL),(47,2020,127.65,'62220000000000011','李明','中国工商银行',1,NULL,'2026-06-24 14:31:00','2026-06-25 15:19:00'),(48,2021,1094.50,'62270000000000012','张华','中国建设银行',1,NULL,'2026-06-17 08:54:00','2026-06-20 12:43:00'),(49,2022,2952.07,'62270000000000012','张华','中国建设银行',2,NULL,'2026-07-02 15:22:00','2026-07-04 16:37:00'),(50,2023,1475.84,'62270000000000012','张华','中国建设银行',1,NULL,'2026-06-25 09:28:00','2026-06-26 09:02:00'),(51,2024,753.06,'62270000000000012','张华','中国建设银行',0,NULL,'2026-05-24 17:56:00',NULL),(52,2025,1723.64,'62220000000000011','李明','中国工商银行',0,NULL,'2026-06-05 11:22:00',NULL);
/*!40000 ALTER TABLE `withdrawal_record` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-07-07 15:30:56
