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
-- Table structure for table `category`
--

DROP TABLE IF EXISTS `category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `category` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '分类ID（主键）',
  `parent_id` bigint DEFAULT NULL COMMENT '上级分类ID',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '分类名称',
  `level` tinyint DEFAULT NULL COMMENT '层级等级',
  `sort_order` int DEFAULT NULL COMMENT '排序值',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=609 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='商品分类表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `category`
--

LOCK TABLES `category` WRITE;
/*!40000 ALTER TABLE `category` DISABLE KEYS */;
INSERT INTO `category` VALUES (1,0,'生鲜果蔬肉禽',1,1),(2,0,'食品饮料滋补',1,2),(3,0,'家居百货日用品',1,3),(4,0,'厨具餐具厨房配件',1,4),(5,0,'个护美妆清洁',1,5),(6,0,'母婴孕童用品',1,6),(101,1,'新鲜水果',2,1),(102,1,'时令蔬菜',2,2),(103,1,'猪牛羊肉',2,3),(104,1,'海鲜水产',2,4),(105,1,'禽肉蛋品',2,5),(106,1,'冷冻速食',2,6),(107,1,'熟食卤味',2,7),(108,1,'甜品饮品',2,8),(201,2,'休闲零食',2,1),(202,2,'粮油米面调味',2,2),(203,2,'酒水饮料冲调',2,3),(204,2,'进口零食酒水',2,4),(205,2,'地方特产礼盒',2,5),(206,2,'茗茶茶饮',2,6),(207,2,'保健食品滋补品',2,7),(208,2,'食品礼券礼盒',2,8),(301,3,'家纺床品毛巾',2,1),(302,3,'灯具照明',2,2),(303,3,'收纳储物用品',2,3),(304,3,'清洁消杀纸品',2,4),(305,3,'浴室洗漱用品',2,5),(306,3,'雨伞雨具防护',2,6),(307,3,'洗晒熨烫工具',2,7),(308,3,'装饰摆件花艺',2,8),(309,3,'宠物全品类',2,9),(401,4,'烹饪锅具',2,1),(402,4,'刀剪菜板工具',2,2),(403,4,'水杯酒具茶具',2,3),(404,4,'碗盘餐具',2,4),(405,4,'厨房小配件',2,5),(406,4,'商用酒店厨具',2,6),(501,5,'面部护肤',2,1),(502,5,'身体洗护沐浴',2,2),(503,5,'洗发护发',2,3),(504,5,'口腔护理',2,4),(505,5,'女性卫生巾护理',2,5),(506,5,'香水彩妆',2,6),(601,6,'婴幼儿奶粉',2,1),(602,6,'辅食营养零食',2,2),(603,6,'尿裤湿巾',2,3),(604,6,'喂养餐具器具',2,4),(605,6,'宝宝洗护用品',2,5),(606,6,'童装童鞋寝具',2,6),(607,6,'孕妈妈妈专区',2,7),(608,6,'童车安全座椅',2,8);
/*!40000 ALTER TABLE `category` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-07-03 15:52:31
