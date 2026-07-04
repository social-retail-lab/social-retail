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
-- Table structure for table `seckill_product`
--

DROP TABLE IF EXISTS `seckill_product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `seckill_product` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '秒杀关联ID（主键）',
  `seckill_activity_id` bigint DEFAULT NULL COMMENT '秒杀活动ID',
  `product_id` bigint DEFAULT NULL COMMENT '商品SpuID',
  `sku_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '商品SKU编码',
  `seckill_price` decimal(10,2) DEFAULT NULL COMMENT '秒杀专享价',
  `seckill_stock` int DEFAULT NULL COMMENT '秒杀专享库存',
  `sold_count` int DEFAULT '0' COMMENT '已售数量',
  `limit_quantity` tinyint DEFAULT NULL COMMENT '每人限购数量',
  `status` tinyint DEFAULT NULL COMMENT '状态（1启用）',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `fk_seckill_act` (`seckill_activity_id`) USING BTREE,
  KEY `fk_seckill_product` (`product_id`) USING BTREE,
  CONSTRAINT `fk_seckill_act` FOREIGN KEY (`seckill_activity_id`) REFERENCES `seckill_activity` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_seckill_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='秒杀商品表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `seckill_product`
--

LOCK TABLES `seckill_product` WRITE;
/*!40000 ALTER TABLE `seckill_product` DISABLE KEYS */;
INSERT INTO `seckill_product` VALUES
(1,1,6009,'AKS-APPLE-10J-85',29.90,50,48,3,1),
(2,1,6010,'FJ-ORANGE-8J-75',39.90,40,35,3,1),
(3,1,6012,'WL-NUT-30B-750',69.00,30,25,3,1),
(4,1,6016,'HS-FOOD-1B-1000',16.90,40,20,3,1),
(5,2,6001,'AKS-NUT-30B-750',59.00,60,55,3,1),
(6,2,6008,'BWW-SNOW-1B-300',19.90,30,28,3,1),
(7,2,6017,'YY-CHICK-1B-210',13.90,80,75,3,1),
(8,2,6021,'YQSL-DRINK-15B-7200',49.00,40,32,3,1),
(9,2,6014,'HT-SAUCE-1T-1900',17.90,50,22,3,1),
(10,3,6018,'JW-DUCK-1H-200',18.90,50,10,3,1),
(11,3,6022,'NFSQ-JUICE-1B-900',14.90,60,8,3,1),
(12,3,6024,'XC-MANGOJUICE-1B-1000',16.90,50,5,3,1),
(13,3,6003,'BWW-MANGO-1B-500',28.90,40,3,3,1);
/*!40000 ALTER TABLE `seckill_product` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-07-04 10:30:00
