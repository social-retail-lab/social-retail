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
INSERT INTO `sku` VALUES (8001,6001,'{\"规格\":\"30包装\",\"净重\":\"600g-750g\"}',77.00,90,'AKS-NUT-30B-750'),(8002,6002,'{\"规格\":\"1袋装\",\"净重\":\"200g\",\"口味\":\"卤香\"}',26.00,180,'LPPZ-CHICK-1B-200'),(8003,6003,'{\"规格\":\"1袋装\",\"净重\":\"500g\"}',35.90,150,'BWW-MANGO-1B-500'),(8004,6004,'{\"规格\":\"1袋装\",\"净重\":\"520g\"}',22.90,220,'WW-RICE-1B-520'),(8005,6005,'{\"规格\":\"10包装\",\"单包\":\"68g\"}',19.90,300,'WL-LATIAO-10B-680'),(8006,6006,'{\"规格\":\"6枚盒装\",\"净重\":\"360g\"}',35.00,130,'LPPZ-YOLK-6P-360'),(8007,6007,'{\"规格\":\"1盒装\",\"净重\":\"400g\"}',24.90,110,'DIY-CAKE-1B-400'),(8008,6008,'{\"规格\":\"1袋装\",\"净重\":\"300g\"}',27.90,160,'BWW-SNOW-1B-300'),(8009,6009,'{\"规格\":\"5斤装\",\"果径\":\"80-85mm\"}',36.90,200,'AKS-APPLE-10J-85'),(8010,6010,'{\"规格\":\"8斤装\",\"果径\":\"75-80mm\"}',49.90,140,'FJ-ORANGE-8J-75'),(8011,6011,'{\"规格\":\"12粒礼盒\",\"等级\":\"特级\"}',118.00,50,'ZESP-KIWI-12P-S'),(8012,6012,'{\"规格\":\"30包装\",\"净重\":\"750g\"}',85.00,130,'WL-NUT-30B-750'),(8013,6013,'{\"规格\":\"1袋装\",\"净重\":\"5000g\"}',68.00,80,'JLY-RICE-1P-5000'),(8014,6014,'{\"规格\":\"1桶装\",\"容量\":\"1900ml\"}',22.90,160,'HT-SAUCE-1T-1900'),(8015,6015,'{\"规格\":\"20包装\",\"单包\":\"80g\"}',16.90,300,'FL-PICKLE-20B-1600'),(8016,6016,'{\"规格\":\"1袋装\",\"净重\":\"1000g\"}',22.00,120,'HS-FOOD-1B-1000'),(8017,6017,'{\"规格\":\"1袋装\",\"净重\":\"210g\",\"口味\":\"山椒\"}',18.90,220,'YY-CHICK-1B-210'),(8018,6018,'{\"规格\":\"1盒\",\"净重\":\"200g\",\"口味\":\"香辣\"}',24.90,140,'JW-DUCK-1H-200'),(8019,6019,'{\"规格\":\"1袋装\",\"净重\":\"150g\"}',29.90,110,'HD-BEEF-1B-150'),(8020,6020,'{\"规格\":\"1盒装\",\"净重\":\"300g\"}',16.90,170,'LX-EGG-1H-300'),(8021,6021,'{\"规格\":\"15瓶装\",\"单瓶\":\"480ml\",\"口味\":\"白桃\"}',65.00,90,'YQSL-DRINK-15B-7200'),(8022,6022,'{\"规格\":\"1瓶装\",\"容量\":\"900ml\"}',19.90,130,'NFSQ-JUICE-1B-900'),(8023,6023,'{\"规格\":\"12盒装\",\"单盒\":\"200g\"}',42.90,100,'MN-YOGURT-12B-2400'),(8024,6024,'{\"规格\":\"1瓶装\",\"容量\":\"1000ml\"}',22.90,150,'XC-MANGOJUICE-1B-1000');
/*!40000 ALTER TABLE `sku` ENABLE KEYS */;
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
