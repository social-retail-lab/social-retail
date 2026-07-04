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
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-07-04 11:00:00
