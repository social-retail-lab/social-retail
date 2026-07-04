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
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID（主键）',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '手机号',
  `nickname` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '昵称',
  `password` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '密码',
  `avatar` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '头像',
  `sex` tinyint DEFAULT NULL COMMENT '性别',
  `status` tinyint DEFAULT NULL COMMENT '账号状态',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1026 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='用户表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1001,'17782224500','陈一商家','e18ca020a37ff8c10fc1166f1de931ef','/static/avatar/1001.jpg',1,1),(1002,'17782224501','王二商家','e18ca020a37ff8c10fc1166f1de931ef','/static/avatar/1002.jpg',0,1),(1003,'17782224502','李三商家','e18ca020a37ff8c10fc1166f1de931ef','/static/avatar/1003.jpg',1,1),(1004,'17782224503','赵四商家','e18ca020a37ff8c10fc1166f1de931ef','/static/avatar/1004.jpg',1,1),(1005,'17782224504','钱五商家','e18ca020a37ff8c10fc1166f1de931ef','/static/avatar/1005.jpg',1,1),(1006,'17782224505','张六商家','e18ca020a37ff8c10fc1166f1de931ef','/static/avatar/1006.jpg',1,1),(1007,'17782224506','陈二','e18ca020a37ff8c10fc1166f1de931ef','/static/avatar/1007.jpg',1,1),(1008,'17782224507','王一','e18ca020a37ff8c10fc1166f1de931ef','/static/avatar/1008.jpg',1,1),(1009,'17782224508','李二','e18ca020a37ff8c10fc1166f1de931ef','/static/avatar/1009.jpg',1,1),(1010,'17782224509','赵一','e18ca020a37ff8c10fc1166f1de931ef','/static/avatar/1010.jpg',1,1),(1011,'17782224510','孙小红','e18ca020a37ff8c10fc1166f1de931ef','/static/avatar/1001.jpg',0,1),(1012,'17782224511','周小明','e18ca020a37ff8c10fc1166f1de931ef','/static/avatar/1001.jpg',1,1),(1013,'17782224512','吴小丽','e18ca020a37ff8c10fc1166f1de931ef','/static/avatar/1001.jpg',0,1),(1014,'17782224513','郑小刚','e18ca020a37ff8c10fc1166f1de931ef','/static/avatar/1001.jpg',1,1),(1015,'17782224514','冯小美','e18ca020a37ff8c10fc1166f1de931ef','/static/avatar/1001.jpg',0,1),(1016,'17782224515','褚小强','e18ca020a37ff8c10fc1166f1de931ef','/static/avatar/1001.jpg',1,1),(1017,'17782224516','蒋小芳','e18ca020a37ff8c10fc1166f1de931ef','/static/avatar/1001.jpg',0,1),(1018,'17782224517','韩小龙','e18ca020a37ff8c10fc1166f1de931ef','/static/avatar/1001.jpg',1,1),(1019,'17782224518','杨小燕','e18ca020a37ff8c10fc1166f1de931ef','/static/avatar/1001.jpg',0,1),(1020,'17782224519','朱小杰','e18ca020a37ff8c10fc1166f1de931ef','/static/avatar/1001.jpg',1,1),(1021,'17782224520','秦小慧','e18ca020a37ff8c10fc1166f1de931ef','/static/avatar/1001.jpg',0,1),(1022,'17782224521','许小东','e18ca020a37ff8c10fc1166f1de931ef','/static/avatar/1001.jpg',1,1),(1023,'17782224522','何小琴','e18ca020a37ff8c10fc1166f1de931ef','/static/avatar/1001.jpg',0,1),(1024,'17782224523','吕小伟','e18ca020a37ff8c10fc1166f1de931ef','/static/avatar/1001.jpg',1,1),(1025,'17782224524','施小玲','e18ca020a37ff8c10fc1166f1de931ef','/static/avatar/1001.jpg',0,1);
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
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
