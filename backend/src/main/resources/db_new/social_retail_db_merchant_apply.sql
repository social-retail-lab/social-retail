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
-- Table structure for table `merchant_apply`
--

DROP TABLE IF EXISTS `merchant_apply`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `merchant_apply` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '申请ID（主键）',
  `user_id` bigint DEFAULT NULL COMMENT '申请人用户ID',
  `apply_type` tinyint DEFAULT NULL COMMENT '申请类型（1个人，2企业）',
  `company_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '企业/商家名称',
  `id_card_front` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '身份证正面图片',
  `id_card_back` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '身份证反面图片',
  `license_number` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '营业执照注册号',
  `license_image` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '营业执照图片',
  `food_permit_number` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '食品经营许可证号',
  `food_permit_image` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '食品许可证图片',
  `contact_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '联系人',
  `contact_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '联系电话',
  `shop_address` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '店铺地址',
  `shop_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '店铺名称',
  `audit_status` tinyint DEFAULT NULL COMMENT '审核状态',
  `audit_remark` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '审核备注',
  `apply_time` datetime DEFAULT NULL COMMENT '提交时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `fk_merchant_apply_user` (`user_id`) USING BTREE,
  CONSTRAINT `fk_merchant_apply_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4007 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='商家入驻申请表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `merchant_apply`
--

LOCK TABLES `merchant_apply` WRITE;
/*!40000 ALTER TABLE `merchant_apply` DISABLE KEYS */;
INSERT INTO `merchant_apply` VALUES (4001,1001,2,'润禾食品商贸有限公司','/static/id_card/front_1001.jpg','/static/id_card/back_1001.jpg','91500101MA03XXX01',NULL,'JY500101XXX01',NULL,'陈一','17782222101','重庆市渝北区金开大道星光天地12铺','润禾生活食铺',1,'企业资质齐全，证照审核通过','2026-06-05 09:10:00'),(4002,1002,1,'食愈小铺食品经营店','/static/id_card/front_1002.jpg','/static/id_card/back_1002.jpg',NULL,NULL,NULL,NULL,'王二','17782222102','重庆市江北区观音桥星光68负一楼','食愈小铺',1,'个体证件完整，准予入驻','2026-06-08 14:25:00'),(4003,1003,2,'鲜禧果蔬农产品有限公司','/static/id_card/front_1003.jpg','/static/id_card/back_1003.jpg','91500103MA03XXX03',NULL,'JY500103XXX03',NULL,'李三','17782222103','重庆市南岸区南坪协信星光一层','鲜禧果仓',1,'生鲜食品资质核验无误','2026-06-12 10:05:00'),(4004,1004,2,'家禾粮油副食配送公司','/static/id_card/front_1004.jpg','/static/id_card/back_1004.jpg','91500104MA03XXX04',NULL,'JY500104XXX04',NULL,'赵四','17782222104','重庆市九龙坡区杨家坪直港大道','家禾粮油副食',1,'粮油经营许可齐全，审核通过','2026-06-15 16:30:00'),(4005,1005,1,'巷味卤货小吃店','/static/id_card/front_1005.jpg','/static/id_card/back_1005.jpg',NULL,NULL,NULL,NULL,'钱五','17782222105','重庆市渝中区两路口桂花园路','巷味卤货',1,'熟食卫生资质达标，审核通过','2026-06-20 11:15:00'),(4006,1006,1,'果汽鲜饮饮品店','/static/id_card/front_1006.jpg','/static/id_card/back_1006.jpg',NULL,NULL,NULL,NULL,'张六','17782222106','重庆市南岸区茶园时代都汇临街铺','果汽鲜饮',0,'资料待补充食品留样记录，暂未通过','2026-06-25 08:40:00');
/*!40000 ALTER TABLE `merchant_apply` ENABLE KEYS */;
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
