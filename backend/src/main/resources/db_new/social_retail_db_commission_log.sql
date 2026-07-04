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
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-07-04 11:00:00
