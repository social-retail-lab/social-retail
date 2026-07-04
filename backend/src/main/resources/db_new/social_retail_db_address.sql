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
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-07-04 10:00:00
