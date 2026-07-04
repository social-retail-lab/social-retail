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
  `member_level_required` tinyint DEFAULT '0' COMMENT '所需会员等级（0不限制）',
  `valid_start` datetime DEFAULT NULL COMMENT '有效期开始时间',
  `valid_end` datetime DEFAULT NULL COMMENT '有效期截止时间',
  `status` tinyint DEFAULT NULL COMMENT '状态（1启用）',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='优惠券主表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `coupon`
--

LOCK TABLES `coupon` WRITE;
/*!40000 ALTER TABLE `coupon` DISABLE KEYS */;
INSERT INTO `coupon` VALUES
(1,'新人大礼包 满50减10',1,50.00,10.00,500,180,1,0,0,'2026-05-01 00:00:00','2026-07-31 23:59:59',1,'2026-05-01 00:00:00'),
(2,'5月狂欢 满100减20',1,100.00,20.00,300,95,1,100,0,'2026-05-05 00:00:00','2026-05-31 23:59:59',1,'2026-05-01 00:00:00'),
(3,'端午特惠 满80减15',1,80.00,15.00,200,130,2,0,0,'2026-05-25 00:00:00','2026-06-10 23:59:59',1,'2026-05-20 00:00:00'),
(4,'618年中大促 满150减30',1,150.00,30.00,400,210,2,200,1,'2026-06-12 00:00:00','2026-06-22 23:59:59',1,'2026-06-10 00:00:00'),
(5,'夏日清凉季 满60减12',1,60.00,12.00,300,160,2,50,0,'2026-06-20 00:00:00','2026-07-20 23:59:59',1,'2026-06-18 00:00:00'),
(6,'银卡专项 满40减8',1,40.00,8.00,200,75,3,0,2,'2026-07-01 00:00:00','2026-07-31 23:59:59',1,'2026-07-01 00:00:00');
/*!40000 ALTER TABLE `coupon` ENABLE KEYS */;
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
