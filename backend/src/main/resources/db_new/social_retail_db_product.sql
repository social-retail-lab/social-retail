-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: localhost    Database: social_retail_db
-- ------------------------------------------------------
-- Server version	8.0.46

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

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
  `sale_type` tinyint DEFAULT NULL COMMENT '销售模式（自提/配送）',
  `status` tinyint DEFAULT NULL COMMENT '上架状态',
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
INSERT INTO `product` VALUES (6001,5001,2001,'三只松鼠每日坚果30包礼盒','果仁饱满 营养均衡','/static/product/6001.jpg','<p>混合坚果独立小袋，全家代餐零食</p>',3,1,35),(6002,5001,2001,'三只松鼠虎皮风爪袋装','软烂脱骨 卤香入味','/static/product/6002.jpg','<p>老卤慢炖鸡爪，追剧网红即食卤味零食</p>',3,1,25),(6003,5002,2001,'良品铺子芒果干500g大包装','果肉厚实 酸甜不腻','/static/product/6003.jpg','<p>鲜芒果低温烘干，无过多添加蜜饯</p>',3,1,18),(6004,5004,2001,'旺旺雪饼520g家庭装','酥脆米香 童年味道','/static/product/6004.jpg','<p>经典膨化米饼，办公室家庭常备小零食</p>',3,1,42),(6005,5003,2002,'卫龙大面筋68g*10包','香辣劲道 解馋小吃','/static/product/6005.jpg','<p>经典麻辣辣条，便携独立小包办公室零食</p>',3,1,28),(6006,5002,2002,'良品铺子蛋黄酥6枚盒装','绵密沙糯 多层馅料','/static/product/6006.jpg','<p>雪媚娘红豆咸蛋黄点心，下午茶糕点</p>',3,1,15),(6007,5002,2002,'良品铺子手工黑芝麻软糕400g','软糯香甜 无添加蔗糖','/static/product/6007.jpg','<p>传统手工糕点，老人小孩均可食用</p>',3,1,12),(6008,5002,2002,'良品铺子雪花酥300g','奶香浓郁 坚果混合','/static/product/6008.jpg','<p>牛轧雪花酥，蔓越莓坚果组合网红点心</p>',3,1,32),(6009,5005,2003,'阿克苏冰糖心苹果5斤装','产地直发 甜脆多汁','/static/product/6009.jpg','<p>正宗阿克苏冰糖心苹果，果园现摘冷链直达</p>',3,1,48),(6010,5005,2003,'奉节脐橙8斤装','重庆本地鲜果 爆汁清甜','/static/product/6010.jpg','<p>奉节核心产区脐橙，皮薄无渣现摘现发</p>',3,1,35),(6011,5005,2003,'阳光金果奇异果12粒礼盒','高维C 香甜软嫩','/static/product/6011.jpg','<p>新西兰进口奇异果，高端送礼鲜果礼盒</p>',3,1,22),(6012,5006,2003,'沃隆每日坚果750g30袋','科学配比 孕妇可食','/static/product/6012.jpg','<p>无添加盐糖，独立小袋适合每日代餐</p>',3,1,55),(6013,5007,2004,'金龙鱼稻花香大米5kg袋装','米油丰厚 软糯香甜','/static/product/6013.jpg','<p>东北五常产区大米，家用煮饭首选</p>',3,1,20),(6014,5007,2004,'海天金标生抽1.9L桶装','粮食酿造 凉拌红烧通用','/static/product/6014.jpg','<p>180天酿造酱油，鲜香味足家用调味</p>',3,1,12),(6015,5008,2004,'涪陵清爽榨菜80g*20袋','重庆特产 配粥下饭小菜','/static/product/6015.jpg','<p>地道涪陵榨菜，低盐清爽独立小包</p>',3,1,22),(6016,5003,2004,'农家红薯宽粉1000g','久煮不烂 火锅炖菜专用','/static/product/6016.jpg','<p>纯红薯手工制作宽粉条，无胶无添加</p>',3,1,8),(6017,5010,2005,'有友泡椒凤爪210g袋装','重庆经典 酸辣入味','/static/product/6017.jpg','<p>地道山椒泡凤爪，追剧解馋网红卤味</p>',2,1,65),(6018,5009,2005,'绝味香辣鸭脖200g锁鲜装','鲜卤现发 麻辣够味','/static/product/6018.jpg','<p>气调锁鲜鸭脖，开袋即食熟食</p>',2,1,42),(6019,5009,2005,'绝味原切牛肉脯150g','肉质紧实 肉香浓郁','/static/product/6019.jpg','<p>谷饲牛肉制作肉干，无淀粉添加</p>',2,1,35),(6020,5010,2005,'有友现卤五香鹌鹑蛋300g','卤香浓郁 独立小包','/static/product/6020.jpg','<p>手工老卤慢炖鹌鹑蛋，日常解馋小食</p>',2,1,78),(6021,5011,2006,'元气森林白桃气泡水480ml*15瓶','0糖0脂0卡 清爽解腻','/static/product/6021.jpg','<p>白桃果味苏打汽水，冰镇夏日饮品</p>',3,1,38),(6022,5012,2006,'农夫山泉100%鲜榨橙汁900ml','鲜果原榨 无浓缩还原','/static/product/6022.jpg','<p>新鲜橙子压榨果汁，家庭日常饮品</p>',3,1,22),(6023,5011,2006,'元气森林酸奶200g*12盒','浓稠顺滑 早餐代餐','/static/product/6023.jpg','<p>生牛乳发酵常温酸奶，儿童老人均可饮用</p>',3,1,18),(6024,5011,2006,'农夫山泉鲜榨芒果复合果汁1L瓶装','果香浓郁 冰镇更好喝','/static/product/6024.jpg','<p>多种热带水果复配果汁，聚会分享饮品</p>',3,1,45);
/*!40000 ALTER TABLE `product` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-07-04 15:30:00
