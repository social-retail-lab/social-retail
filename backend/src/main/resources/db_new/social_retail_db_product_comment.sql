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
INSERT INTO `product_comment` VALUES
(1,93,6009,1007,5,'味道不错，包装完好','',0,'2026-05-09 10:00:00'),
(2,94,6002,1008,4,'物流很快，品质很好','',0,'2026-05-11 09:00:00'),
(3,95,6004,1008,5,'旺旺雪饼还是小时候的味道，很好吃','',0,'2026-05-11 09:30:00'),
(4,97,6006,1009,4,'蛋黄酥口感不错，会回购的','',0,'2026-05-13 08:00:00'),
(5,98,6008,1009,5,'雪花酥奶香味很浓，好吃','',1,'2026-05-13 09:00:00'),
(6,99,6013,1010,5,'大米质量很好，煮饭很香','',0,'2026-05-15 10:00:00'),
(7,100,6015,1010,4,'价格实惠，会回购','',0,'2026-05-15 11:00:00'),
(8,103,6017,1011,5,'泡椒凤爪非常好吃，酸辣够味','',0,'2026-05-20 09:00:00'),
(9,104,6021,1012,3,'一般般，没有想象中好','',1,'2026-05-21 08:00:00'),
(10,106,6010,1013,4,'脐橙很新鲜，水分足','',0,'2026-05-24 10:00:00'),
(11,109,6018,1007,5,'鸭脖很入味，麻辣鲜香','',0,'2026-05-27 08:30:00'),
(12,110,6001,1014,5,'每日坚果品质不错，独立包装很方便','',0,'2026-05-29 10:00:00'),
(13,115,6013,1015,5,'五常大米就是好，煮出来的饭粒粒分明','',0,'2026-06-02 09:00:00'),
(14,116,6015,1015,4,'榨菜味道正宗，下饭神器','',0,'2026-06-02 10:00:00'),
(15,118,6005,1007,4,'辣条味道不错，就是有点少','',0,'2026-06-06 08:00:00'),
(16,119,6006,1007,5,'蛋黄酥第二次购买了，品质一如既往地好','',0,'2026-06-06 09:00:00'),
(17,121,6003,1010,3,'芒果干偏甜，不太适合我的口味','',1,'2026-06-08 15:00:00'),
(18,122,6004,1010,5,'雪饼一如既往的好吃，孩子们很喜欢','',0,'2026-06-08 16:00:00'),
(19,130,6010,1009,4,'物流很快，橙子很新鲜','',0,'2026-06-17 08:00:00'),
(20,132,6017,1018,5,'有友的泡椒凤爪真的太经典了','',0,'2026-06-19 10:00:00');
/*!40000 ALTER TABLE `product_comment` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-07-04 16:00:00
