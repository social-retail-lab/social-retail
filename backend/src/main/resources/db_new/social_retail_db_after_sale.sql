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
-- Table structure for table `after_sale`
--

DROP TABLE IF EXISTS `after_sale`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `after_sale` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '售后ID（主键）',
  `order_id` bigint DEFAULT NULL COMMENT '订单ID',
  `order_item_id` bigint DEFAULT NULL COMMENT '订单明细ID',
  `order_sn` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '订单编号',
  `type` tinyint DEFAULT NULL COMMENT '售后类型（1=仅退款 2=退货退款）',
  `refund_amount` decimal(10,2) DEFAULT NULL COMMENT '申请退款金额',
  `actual_refund_amount` decimal(10,2) DEFAULT NULL COMMENT '实际退款金额',
  `reason` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '申请原因',
  `evidence_images` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '凭证图片',
  `product_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '商品快照名称',
  `sku_specs` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '规格快照(JSON)',
  `status` tinyint DEFAULT NULL COMMENT '售后状态（0=待审核 1=待商家处理 2=商家同意 3=用户已退货 4=已完成 5=已拒绝）',
  `audit_remark` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '审核备注',
  `audit_time` datetime DEFAULT NULL COMMENT '审核时间',
  `return_received_status` tinyint DEFAULT NULL COMMENT '退货收货状态',
  `return_received_time` datetime DEFAULT NULL COMMENT '退货收货时间',
  `complete_time` datetime DEFAULT NULL COMMENT '完成时间',
  `feedback_content` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '反馈内容',
  `feedback_images` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '反馈图片',
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
INSERT INTO `after_sale` VALUES
(1,51,91,'202605051030010001',2,77.00,77.00,'商品与描述不符','','三只松鼠每日坚果30包礼盒','{\"规格\":\"30包装\",\"净重\":\"600g-750g\"}',4,'已审核通过，退款成功','2026-05-07 14:00:00',1,'2026-05-09 10:00:00','2026-05-10 09:00:00','退款已到账，处理满意','','2026-05-07 10:00:00'),
(2,65,110,'202605251650020015',1,77.00,NULL,'不想要了','','三只松鼠每日坚果30包礼盒','{\"规格\":\"30包装\",\"净重\":\"600g-750g\"}',1,NULL,NULL,NULL,NULL,NULL,NULL,'','2026-07-03 16:00:00'),
(3,72,123,'202606071630020022',2,85.00,NULL,'尺码不合适','','沃隆每日坚果750g30袋','{\"规格\":\"750g 30袋\",\"品种\":\"混合坚果\"}',2,'同意退货，请寄回商品','2026-06-10 10:00:00',NULL,NULL,NULL,NULL,'','2026-06-10 09:00:00'),
(4,58,102,'202605141025010008',1,35.90,NULL,'买错了','','良品铺子芒果干500g','{\"规格\":\"500g\",\"口味\":\"原味\"}',5,'抱歉，已超过售后时效','2026-05-16 09:00:00',NULL,NULL,NULL,'售后被拒，理由不合理','','2026-05-16 08:00:00'),
(5,80,134,'202606171130010030',2,59.70,NULL,'收到商品破损','','卫龙大面筋68g*10包','{\"规格\":\"68g*10包\",\"口味\":\"香辣味\"}',3,'同意退货，请尽快寄回','2026-06-20 14:00:00',0,'2026-06-21 16:00:00',NULL,NULL,'','2026-06-20 10:00:00'),
(6,89,146,'202606291005010039',1,26.00,26.00,'效果不好','','三只松鼠虎皮风爪袋装','{\"规格\":\"袋装\",\"净重\":\"200g\"}',4,'已审核通过，退款成功','2026-07-01 15:00:00',NULL,NULL,'2026-07-02 09:00:00','处理速度很快','','2026-07-01 10:00:00'),
(7,52,92,'202605061420010002',2,39.80,39.80,'七天无理由退货','','卫龙大面筋68g*10包','{\"规格\":\"68g*10包\",\"口味\":\"香辣味\"}',4,'已审核通过，退款成功','2026-05-08 16:00:00',1,'2026-05-10 09:00:00','2026-05-11 10:00:00','收到退款','','2026-05-08 10:00:00'),
(8,60,104,'202605181520010010',1,65.00,NULL,'不想要了','','元气森林白桃气泡水480ml*15瓶','{\"规格\":\"480ml*15瓶\",\"口味\":\"白桃味\"}',5,'订单已完成超7天，不支持退款','2026-05-26 10:00:00',NULL,NULL,NULL,NULL,'','2026-05-26 08:00:00');
/*!40000 ALTER TABLE `after_sale` ENABLE KEYS */;
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
