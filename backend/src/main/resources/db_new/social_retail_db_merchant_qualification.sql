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
  `food_permit_number` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '食品经营许可证号',
  `food_permit_image` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '食品许可证图片',
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
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-07-03 15:52:30
