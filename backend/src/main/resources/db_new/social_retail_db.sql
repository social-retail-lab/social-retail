-- ============================================================
-- SOCIAL零售 数据库初始化脚本
-- 整合版本：包含所有表的 DROP/CREATE 及初始数据
-- ============================================================

CREATE DATABASE IF NOT EXISTS social_retail_db CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE social_retail_db;
SET FOREIGN_KEY_CHECKS = 0;

-- ============================================================
-- 1. user
-- ============================================================
DROP TABLE IF EXISTS `user`;
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

INSERT INTO `user` VALUES
(1001,'17782224500','陈一商家','e18ca020a37ff8c10fc1166f1de931ef','/static/avatar/1001.jpg',1,1),
(1002,'17782224501','王二商家','e18ca020a37ff8c10fc1166f1de931ef','/static/avatar/1002.jpg',0,1),
(1003,'17782224502','李三商家','e18ca020a37ff8c10fc1166f1de931ef','/static/avatar/1003.jpg',1,1),
(1004,'17782224503','赵四商家','e18ca020a37ff8c10fc1166f1de931ef','/static/avatar/1004.jpg',1,1),
(1005,'17782224504','钱五商家','e18ca020a37ff8c10fc1166f1de931ef','/static/avatar/1005.jpg',1,1),
(1006,'17782224505','张六商家','e18ca020a37ff8c10fc1166f1de931ef','/static/avatar/1006.jpg',1,1),
(1007,'17782224506','陈二','e18ca020a37ff8c10fc1166f1de931ef','/static/avatar/1007.jpg',1,1),
(1008,'17782224507','王一','e18ca020a37ff8c10fc1166f1de931ef','/static/avatar/1008.jpg',1,1),
(1009,'17782224508','李二','e18ca020a37ff8c10fc1166f1de931ef','/static/avatar/1009.jpg',1,1),
(1010,'17782224509','赵一','e18ca020a37ff8c10fc1166f1de931ef','/static/avatar/1010.jpg',1,1),
(1011,'17782224510','孙小红','e18ca020a37ff8c10fc1166f1de931ef','/static/avatar/1001.jpg',0,1),
(1012,'17782224511','周小明','e18ca020a37ff8c10fc1166f1de931ef','/static/avatar/1001.jpg',1,1),
(1013,'17782224512','吴小丽','e18ca020a37ff8c10fc1166f1de931ef','/static/avatar/1001.jpg',0,1),
(1014,'17782224513','郑小刚','e18ca020a37ff8c10fc1166f1de931ef','/static/avatar/1001.jpg',1,1),
(1015,'17782224514','冯小美','e18ca020a37ff8c10fc1166f1de931ef','/static/avatar/1001.jpg',0,1),
(1016,'17782224515','褚小强','e18ca020a37ff8c10fc1166f1de931ef','/static/avatar/1001.jpg',1,1),
(1017,'17782224516','蒋小芳','e18ca020a37ff8c10fc1166f1de931ef','/static/avatar/1001.jpg',0,1),
(1018,'17782224517','韩小龙','e18ca020a37ff8c10fc1166f1de931ef','/static/avatar/1001.jpg',1,1),
(1019,'17782224518','杨小燕','e18ca020a37ff8c10fc1166f1de931ef','/static/avatar/1001.jpg',0,1),
(1020,'17782224519','朱小杰','e18ca020a37ff8c10fc1166f1de931ef','/static/avatar/1001.jpg',1,1),
(1021,'17782224520','秦小慧','e18ca020a37ff8c10fc1166f1de931ef','/static/avatar/1001.jpg',0,1),
(1022,'17782224521','许小东','e18ca020a37ff8c10fc1166f1de931ef','/static/avatar/1001.jpg',1,1),
(1023,'17782224522','何小琴','e18ca020a37ff8c10fc1166f1de931ef','/static/avatar/1001.jpg',0,1),
(1024,'17782224523','吕小伟','e18ca020a37ff8c10fc1166f1de931ef','/static/avatar/1001.jpg',1,1),
(1025,'17782224524','施小玲','e18ca020a37ff8c10fc1166f1de931ef','/static/avatar/1001.jpg',0,1);

-- ============================================================
-- 2. member
-- ============================================================
DROP TABLE IF EXISTS `member`;
CREATE TABLE `member` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '会员ID（主键）',
  `user_id` bigint DEFAULT NULL COMMENT '用户ID',
  `member_level` tinyint DEFAULT NULL COMMENT '会员等级',
  `points_balance` int DEFAULT NULL COMMENT '积分余额',
  `growth_value` int DEFAULT NULL COMMENT '成长值',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `fk_member_user` (`user_id`) USING BTREE,
  CONSTRAINT `fk_member_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='会员表';

INSERT INTO `member` VALUES
(1,1001,2,2000,3000),(2,1002,2,1500,2500),(3,1003,2,1200,2000),(4,1004,2,1000,1500),(5,1005,2,800,1200),(6,1006,2,500,800),(7,1007,3,800,600),(8,1008,2,500,350),(9,1009,1,300,150),(10,1010,3,100,80),(11,1011,1,300,0),(12,1012,1,280,0),(13,1013,1,250,0),(14,1014,1,220,0),(15,1015,1,200,0),(16,1016,1,180,0),(17,1017,1,150,0),(18,1018,1,130,0),(19,1019,1,100,0),(20,1020,1,80,0),(21,1021,1,60,0),(22,1022,1,40,0),(23,1023,1,20,0),(24,1024,1,10,0),(25,1025,1,0,0);

-- ============================================================
-- 3. distributor
-- ============================================================
DROP TABLE IF EXISTS `distributor`;
CREATE TABLE `distributor` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '分销员ID（主键）',
  `user_id` bigint DEFAULT NULL COMMENT '用户ID',
  `total_commission` decimal(10,2) DEFAULT NULL COMMENT '累计佣金',
  `frozen_commission` decimal(10,2) DEFAULT NULL COMMENT '冻结佣金',
  `status` tinyint DEFAULT NULL COMMENT '分销状态',
  `apply_time` datetime DEFAULT NULL COMMENT '申请时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `fk_distributor_user` (`user_id`) USING BTREE,
  CONSTRAINT `fk_distributor_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='分销员表';

INSERT INTO `distributor` VALUES
(1,1008,150.00,0.00,1,'2026-05-20 10:00:00'),
(2,1010,80.00,20.00,1,'2026-06-01 14:00:00'),
(3,1015,0.00,0.00,0,'2026-07-02 09:00:00');

-- ============================================================
-- 4. merchant
-- ============================================================
DROP TABLE IF EXISTS `merchant`;
CREATE TABLE `merchant` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '商家ID（主键）',
  `user_id` bigint DEFAULT NULL COMMENT '关联用户ID',
  `merchant_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '商家名称',
  `logo` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '商家Logo',
  `contact_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '联系人',
  `contact_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '联系电话',
  `shop_address` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '店铺地址',
  `status` tinyint DEFAULT NULL COMMENT '营业状态',
  `business_hours` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '营业时间',
  `introduction` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '店铺介绍',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `fk_merchant_user` (`user_id`) USING BTREE,
  CONSTRAINT `fk_merchant_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2007 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='商家表';

INSERT INTO `merchant` VALUES
(2001,1001,'润禾生活食铺','/static/merchant/1001.jpg','陈一','17782224500','重庆市渝中区解放西路 126 号附 8 号',1,NULL,NULL,NULL),
(2002,1002,'食愈小站','/static/merchant/1002.jpg','王二','17782224501','重庆市大渡口区新山村春晖路 66 号',1,NULL,NULL,NULL),
(2003,1003,'鲜禧果仓','/static/merchant/1003.jpg','李三','17782224502','重庆市巴南区龙洲湾渝南大道132号',1,NULL,NULL,NULL),
(2004,1004,'家禾粮油副食','/static/merchant/1004.jpg','赵四','17782224503','重庆市沙坪坝区三峡广场天陈路57号',1,NULL,NULL,NULL),
(2005,1005,'巷味卤货','/static/merchant/1005.jpg','钱五','17782224504','重庆市北碚区天生路49号城南步行街底商',1,NULL,NULL,NULL),
(2006,1006,'果汽鲜饮','/static/merchant/1006.jpg','张六','17782224505','重庆市江北区观音桥建新北路 55 号星光 68 负一楼 17 铺',0,NULL,NULL,NULL);

-- ============================================================
-- 5. address
-- ============================================================
DROP TABLE IF EXISTS `address`;
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

INSERT INTO `address` VALUES
(1,1004,'赵四商家','17782224503','重庆市','重庆市','渝北区','龙山大道168号',1),
(2,1007,'陈二','17782224506','重庆市','重庆市','南岸区','南滨路88号',1),
(3,1007,'陈二','17782224506','重庆市','重庆市','南岸区','学府大道22号',0),
(4,1008,'王一','17782224507','重庆市','重庆市','江北区','观音桥步行街9号',1),
(5,1008,'王一','17782224507','重庆市','重庆市','江北区','建新东路56号',0),
(6,1009,'李二','17782224508','重庆市','重庆市','沙坪坝区','三峡广场1号',1),
(7,1009,'李二','17782224508','重庆市','重庆市','沙坪坝区','大学城中路20号',0),
(8,1010,'赵一','17782224509','重庆市','重庆市','九龙坡区','杨家坪正街12号',1),
(9,1010,'赵一','17782224509','重庆市','重庆市','九龙坡区','石桥铺科园一路30号',0),
(10,1011,'孙小红','17782224510','重庆市','重庆市','渝中区','解放碑步行街88号',1),
(11,1011,'孙小红','17782224510','重庆市','重庆市','渝中区','大坪正街45号',0),
(12,1012,'周小明','17782224511','重庆市','重庆市','巴南区','龙洲大道100号',1),
(13,1012,'周小明','17782224511','重庆市','重庆市','巴南区','鱼洞街道15号',0),
(14,1013,'吴小丽','17782224512','重庆市','重庆市','大渡口区','春晖路街道58号',1),
(15,1013,'吴小丽','17782224512','重庆市','重庆市','大渡口区','九宫庙商圈12号',0),
(16,1014,'郑小刚','17782224513','重庆市','重庆市','北碚区','天生路2号',1),
(17,1014,'郑小刚','17782224513','重庆市','重庆市','北碚区','云华路200号',0),
(18,1015,'冯小美','17782224514','重庆市','重庆市','渝北区','新南路168号',1),
(19,1015,'冯小美','17782224514','重庆市','重庆市','渝北区','金开大道66号',0),
(20,1016,'褚小强','17782224515','重庆市','重庆市','南岸区','弹子石新街33号',1),
(21,1016,'褚小强','17782224515','重庆市','重庆市','南岸区','茶园新区99号',0),
(22,1017,'蒋小芳','17782224516','重庆市','重庆市','江北区','北滨一路55号',1),
(23,1018,'韩小龙','17782224517','重庆市','重庆市','沙坪坝区','小龙坎正街76号',1),
(24,1019,'杨小燕','17782224518','重庆市','重庆市','九龙坡区','西郊路10号',1),
(25,1020,'朱小杰','17782224519','重庆市','重庆市','渝中区','石油路街道120号',1),
(26,1021,'秦小慧','17782224520','重庆市','重庆市','巴南区','李家沱正街88号',1),
(27,1022,'许小东','17782224521','重庆市','重庆市','大渡口区','钢花路60号',1),
(28,1023,'何小琴','17782224522','重庆市','重庆市','北碚区','城南新区18号',1),
(29,1024,'吕小伟','17782224523','重庆市','重庆市','南岸区','四公里街200号',1),
(30,1025,'施小玲','17782224524','重庆市','重庆市','渝北区','黄泥磅街道35号',1);

-- ============================================================
-- 6. user_wallet
-- ============================================================
DROP TABLE IF EXISTS `user_wallet`;
CREATE TABLE `user_wallet` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '钱包ID（主键）',
  `user_id` bigint DEFAULT NULL COMMENT '用户ID',
  `balance` decimal(10,2) DEFAULT NULL COMMENT '可用余额',
  `frozen_amount` decimal(10,2) DEFAULT NULL COMMENT '冻结金额',
  `total_income` decimal(10,2) DEFAULT NULL COMMENT '累计收入',
  `total_expenditure` decimal(10,2) DEFAULT NULL COMMENT '累计支出',
  `status` tinyint DEFAULT NULL COMMENT '钱包状态',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `fk_user_wallet_user` (`user_id`) USING BTREE,
  CONSTRAINT `fk_user_wallet_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='用户/分销商虚拟钱包表';

INSERT INTO `user_wallet` VALUES
(1,1001,1850.00,50.00,2100.00,250.00,1,'2026-07-03 18:00:00'),
(2,1002,1150.00,30.00,1380.00,230.00,1,'2026-07-03 18:00:00'),
(3,1003,1020.00,0.00,1280.00,260.00,1,'2026-07-03 18:00:00'),
(4,1004,820.00,20.00,960.00,140.00,1,'2026-07-03 18:00:00'),
(5,1005,1480.00,40.00,1750.00,270.00,1,'2026-07-03 18:00:00'),
(6,1006,380.00,0.00,520.00,140.00,1,'2026-07-03 18:00:00');

-- ============================================================
-- 7. user_binding
-- ============================================================
DROP TABLE IF EXISTS `user_binding`;
CREATE TABLE `user_binding` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '关系ID（主键）',
  `user_id` bigint DEFAULT NULL COMMENT '当前用户ID',
  `inviter_id` bigint DEFAULT NULL COMMENT '推荐人用户ID',
  `binding_time` datetime DEFAULT NULL COMMENT '锁粉绑定时间',
  `binding_type` tinyint DEFAULT NULL COMMENT '绑定方式',
  `status` tinyint DEFAULT NULL COMMENT '绑定状态',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `fk_user_binding_user` (`user_id`) USING BTREE,
  KEY `fk_user_binding_inviter` (`inviter_id`) USING BTREE,
  CONSTRAINT `fk_user_binding_inviter` FOREIGN KEY (`inviter_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_user_binding_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='用户锁粉推荐关系表';

-- ============================================================
-- 8. user_message
-- ============================================================
DROP TABLE IF EXISTS `user_message`;
CREATE TABLE `user_message` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '消息ID（主键）',
  `user_id` bigint DEFAULT NULL COMMENT '用户ID',
  `template_id` bigint DEFAULT NULL COMMENT '消息模板ID',
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '消息标题',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '消息内容',
  `is_read` tinyint DEFAULT NULL COMMENT '是否已读',
  `send_time` datetime DEFAULT NULL COMMENT '发送时间',
  `read_time` datetime DEFAULT NULL COMMENT '阅读时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `fk_user_message_user` (`user_id`) USING BTREE,
  KEY `fk_user_message_template` (`template_id`) USING BTREE,
  CONSTRAINT `fk_user_message_template` FOREIGN KEY (`template_id`) REFERENCES `message_template` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_user_message_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='用户站内消息接收表';

-- ============================================================
-- 9. user_tag
-- ============================================================
DROP TABLE IF EXISTS `user_tag`;
CREATE TABLE `user_tag` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '标签记录ID（主键）',
  `user_id` bigint DEFAULT NULL COMMENT '指向描摹用户ID',
  `tag_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '标签名称字符串',
  `weight` decimal(5,2) DEFAULT NULL COMMENT '数仓偏好模型置信度权重',
  `update_time` datetime DEFAULT NULL COMMENT '模型刷算计算时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `fk_tag_user` (`user_id`) USING BTREE,
  CONSTRAINT `fk_tag_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='用户画像标签表';

INSERT INTO `user_tag` VALUES
(1,1004,'高频购买',0.92,'2026-06-15 10:00:00'),
(2,1004,'水果偏好',0.85,'2026-06-15 10:00:00'),
(3,1007,'活跃用户',0.88,'2026-06-20 14:00:00'),
(4,1007,'零食爱好者',0.78,'2026-06-20 14:00:00'),
(5,1008,'高频购买',0.76,'2026-06-18 09:30:00'),
(6,1008,'品质追求',0.82,'2026-06-18 09:30:00'),
(7,1009,'活跃用户',0.90,'2026-06-22 11:00:00'),
(8,1009,'价格敏感',0.73,'2026-06-22 11:00:00'),
(9,1010,'高频购买',0.81,'2026-06-25 16:00:00'),
(10,1010,'水果偏好',0.79,'2026-06-25 16:00:00'),
(11,1011,'新用户',0.95,'2026-06-10 08:00:00'),
(12,1011,'价格敏感',0.68,'2026-06-28 10:00:00'),
(13,1012,'活跃用户',0.74,'2026-06-15 13:00:00'),
(14,1013,'新用户',0.91,'2026-06-12 09:00:00'),
(15,1014,'活跃用户',0.77,'2026-06-20 15:30:00'),
(16,1014,'品质追求',0.71,'2026-06-20 15:30:00'),
(17,1015,'新用户',0.88,'2026-06-08 10:00:00'),
(18,1016,'沉睡用户',0.65,'2026-07-01 08:00:00'),
(19,1017,'新用户',0.86,'2026-06-18 11:30:00'),
(20,1018,'零食爱好者',0.72,'2026-06-25 14:00:00');

-- ============================================================
-- 10. user_behavior_log
-- ============================================================
DROP TABLE IF EXISTS `user_behavior_log`;
CREATE TABLE `user_behavior_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志ID（主键）',
  `user_id` bigint DEFAULT NULL COMMENT '埋点主体用户ID',
  `behavior_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '动作词属性编码',
  `target_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '交互模块名称',
  `target_id` bigint DEFAULT NULL COMMENT '资源物理主键ID',
  `duration` int DEFAULT NULL COMMENT '页面停留时长(秒)',
  `log_time` datetime DEFAULT NULL COMMENT '轨迹触发时间戳',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `fk_behavior_user` (`user_id`) USING BTREE,
  CONSTRAINT `fk_behavior_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='用户行为埋点日志表';

-- ============================================================
-- 11. brand
-- ============================================================
DROP TABLE IF EXISTS `brand`;
CREATE TABLE `brand` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '品牌ID（主键）',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '品牌名称',
  `logo` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '品牌Logo',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '品牌介绍',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5013 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='品牌表';

INSERT INTO `brand` VALUES
(5001,'三只松鼠','/static/brand/5001.jpg','互联网坚果零食第一品牌',NULL),
(5002,'良品铺子','/static/brand/5002.jpg','高端全品类零食连锁标杆品牌',NULL),
(5003,'卫龙','/static/brand/5003.jpg','国民辣味调味零食第一品牌',NULL),
(5004,'旺旺','/static/brand/5004.jpg','国民童年米果零食经典龙头',NULL),
(5005,'奉节脐橙','/static/brand/5005.jpg','重庆地标鲜果品牌',NULL),
(5006,'沃隆','/static/brand/5006.jpg','每日坚果原创开创品牌',NULL),
(5007,'金龙鱼','/static/brand/5007.jpg','国民粮油龙头品牌',NULL),
(5008,'涪陵榨菜','/static/brand/5008.jpg','世界三大名腌菜之一',NULL),
(5009,'绝味鸭脖','/static/brand/5009.jpg','全国连锁卤味熟食龙头品牌',NULL),
(5010,'有友','/static/brand/5010.jpg','重庆本土卤味零食品牌',NULL),
(5011,'元气森林','/static/brand/5011.jpg','零糖气泡水健康饮品新锐头部品牌',NULL),
(5012,'农夫山泉','/static/brand/5012.jpg','国民天然饮用水果汁龙头',NULL);

-- ============================================================
-- 12. category
-- ============================================================
DROP TABLE IF EXISTS `category`;
CREATE TABLE `category` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '分类ID（主键）',
  `parent_id` bigint DEFAULT NULL COMMENT '上级分类ID',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '分类名称',
  `level` tinyint DEFAULT NULL COMMENT '层级等级',
  `sort_order` int DEFAULT NULL COMMENT '排序值',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=609 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='商品分类表';

INSERT INTO `category` VALUES
(1,0,'生鲜果蔬肉禽',1,1),(2,0,'食品饮料滋补',1,2),(3,0,'家居百货日用品',1,3),(4,0,'厨具餐具厨房配件',1,4),(5,0,'个护美妆清洁',1,5),(6,0,'母婴孕童用品',1,6),
(101,1,'新鲜水果',2,1),(102,1,'时令蔬菜',2,2),(103,1,'猪牛羊肉',2,3),(104,1,'海鲜水产',2,4),(105,1,'禽肉蛋品',2,5),(106,1,'冷冻速食',2,6),(107,1,'熟食卤味',2,7),(108,1,'甜品饮品',2,8),
(201,2,'休闲零食',2,1),(202,2,'粮油米面调味',2,2),(203,2,'酒水饮料冲调',2,3),(204,2,'进口零食酒水',2,4),(205,2,'地方特产礼盒',2,5),(206,2,'茗茶茶饮',2,6),(207,2,'保健食品滋补品',2,7),(208,2,'食品礼券礼盒',2,8),
(301,3,'家纺床品毛巾',2,1),(302,3,'灯具照明',2,2),(303,3,'收纳储物用品',2,3),(304,3,'清洁消杀纸品',2,4),(305,3,'浴室洗漱用品',2,5),(306,3,'雨伞雨具防护',2,6),(307,3,'洗晒熨烫工具',2,7),(308,3,'装饰摆件花艺',2,8),(309,3,'宠物全品类',2,9),
(401,4,'烹饪锅具',2,1),(402,4,'刀剪菜板工具',2,2),(403,4,'水杯酒具茶具',2,3),(404,4,'碗盘餐具',2,4),(405,4,'厨房小配件',2,5),(406,4,'商用酒店厨具',2,6),
(501,5,'面部护肤',2,1),(502,5,'身体洗护沐浴',2,2),(503,5,'洗发护发',2,3),(504,5,'口腔护理',2,4),(505,5,'女性卫生巾护理',2,5),(506,5,'香水彩妆',2,6),
(601,6,'婴幼儿奶粉',2,1),(602,6,'辅食营养零食',2,2),(603,6,'尿裤湿巾',2,3),(604,6,'喂养餐具器具',2,4),(605,6,'宝宝洗护用品',2,5),(606,6,'童装童鞋寝具',2,6),(607,6,'孕妈妈妈专区',2,7),(608,6,'童车安全座椅',2,8);

-- ============================================================
-- 13. product
-- ============================================================
DROP TABLE IF EXISTS `product`;
CREATE TABLE `product` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '商品ID（主键）',
  `brand_id` bigint DEFAULT NULL COMMENT '品牌ID',
  `merchant_id` bigint DEFAULT NULL COMMENT '商家ID',
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '商品名称',
  `sub_title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '副标题',
  `main_image` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '商品主图',
  `detail_desc` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '详情描述',
  `sale_type` tinyint DEFAULT NULL COMMENT '销售模式（自提/配送）',
  `status` tinyint DEFAULT NULL COMMENT '上架状态',
  `sold_count` bigint NOT NULL DEFAULT '0' COMMENT '已售数量',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `fk_product_brand` (`brand_id`) USING BTREE,
  KEY `fk_product_merchant` (`merchant_id`) USING BTREE,
  CONSTRAINT `fk_product_brand` FOREIGN KEY (`brand_id`) REFERENCES `brand` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_product_merchant` FOREIGN KEY (`merchant_id`) REFERENCES `merchant` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6025 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='商品主表';

INSERT INTO `product` VALUES
(6001,5001,2001,'三只松鼠每日坚果30包礼盒','果仁饱满 营养均衡','/static/product/6001.jpg','<p>混合坚果独立小袋，全家代餐零食</p>',3,1,35),
(6002,5001,2001,'三只松鼠虎皮风爪袋装','软烂脱骨 卤香入味','/static/product/6002.jpg','<p>老卤慢炖鸡爪，追剧网红即食卤味零食</p>',3,1,25),
(6003,5002,2001,'良品铺子芒果干500g大包装','果肉厚实 酸甜不腻','/static/product/6003.jpg','<p>鲜芒果低温烘干，无过多添加蜜饯</p>',3,1,18),
(6004,5004,2001,'旺旺雪饼520g家庭装','酥脆米香 童年味道','/static/product/6004.jpg','<p>经典膨化米饼，办公室家庭常备小零食</p>',3,1,42),
(6005,5003,2002,'卫龙大面筋68g*10包','香辣劲道 解馋小吃','/static/product/6005.jpg','<p>经典麻辣辣条，便携独立小包办公室零食</p>',3,1,28),
(6006,5002,2002,'良品铺子蛋黄酥6枚盒装','绵密沙糯 多层馅料','/static/product/6006.jpg','<p>雪媚娘红豆咸蛋黄点心，下午茶糕点</p>',3,1,15),
(6007,5002,2002,'良品铺子手工黑芝麻软糕400g','软糯香甜 无添加蔗糖','/static/product/6007.jpg','<p>传统手工糕点，老人小孩均可食用</p>',3,1,12),
(6008,5002,2002,'良品铺子雪花酥300g','奶香浓郁 坚果混合','/static/product/6008.jpg','<p>牛轧雪花酥，蔓越莓坚果组合网红点心</p>',3,1,32),
(6009,5005,2003,'阿克苏冰糖心苹果5斤装','产地直发 甜脆多汁','/static/product/6009.jpg','<p>正宗阿克苏冰糖心苹果，果园现摘冷链直达</p>',3,1,48),
(6010,5005,2003,'奉节脐橙8斤装','重庆本地鲜果 爆汁清甜','/static/product/6010.jpg','<p>奉节核心产区脐橙，皮薄无渣现摘现发</p>',3,1,35),
(6011,5005,2003,'阳光金果奇异果12粒礼盒','高维C 香甜软嫩','/static/product/6011.jpg','<p>新西兰进口奇异果，高端送礼鲜果礼盒</p>',3,1,22),
(6012,5006,2003,'沃隆每日坚果750g30袋','科学配比 孕妇可食','/static/product/6012.jpg','<p>无添加盐糖，独立小袋适合每日代餐</p>',3,1,55),
(6013,5007,2004,'金龙鱼稻花香大米5kg袋装','米油丰厚 软糯香甜','/static/product/6013.jpg','<p>东北五常产区大米，家用煮饭首选</p>',3,1,20),
(6014,5007,2004,'海天金标生抽1.9L桶装','粮食酿造 凉拌红烧通用','/static/product/6014.jpg','<p>180天酿造酱油，鲜香味足家用调味</p>',3,1,12),
(6015,5008,2004,'涪陵清爽榨菜80g*20袋','重庆特产 配粥下饭小菜','/static/product/6015.jpg','<p>地道涪陵榨菜，低盐清爽独立小包</p>',3,1,22),
(6016,5003,2004,'农家红薯宽粉1000g','久煮不烂 火锅炖菜专用','/static/product/6016.jpg','<p>纯红薯手工制作宽粉条，无胶无添加</p>',3,1,8),
(6017,5010,2005,'有友泡椒凤爪210g袋装','重庆经典 酸辣入味','/static/product/6017.jpg','<p>地道山椒泡凤爪，追剧解馋网红卤味</p>',2,1,65),
(6018,5009,2005,'绝味香辣鸭脖200g锁鲜装','鲜卤现发 麻辣够味','/static/product/6018.jpg','<p>气调锁鲜鸭脖，开袋即食熟食</p>',2,1,42),
(6019,5009,2005,'绝味原切牛肉脯150g','肉质紧实 肉香浓郁','/static/product/6019.jpg','<p>谷饲牛肉制作肉干，无淀粉添加</p>',2,1,35),
(6020,5010,2005,'有友现卤五香鹌鹑蛋300g','卤香浓郁 独立小包','/static/product/6020.jpg','<p>手工老卤慢炖鹌鹑蛋，日常解馋小食</p>',2,1,78),
(6021,5011,2006,'元气森林白桃气泡水480ml*15瓶','0糖0脂0卡 清爽解腻','/static/product/6021.jpg','<p>白桃果味苏打汽水，冰镇夏日饮品</p>',3,1,38),
(6022,5012,2006,'农夫山泉100%鲜榨橙汁900ml','鲜果原榨 无浓缩还原','/static/product/6022.jpg','<p>新鲜橙子压榨果汁，家庭日常饮品</p>',3,1,22),
(6023,5011,2006,'元气森林酸奶200g*12盒','浓稠顺滑 早餐代餐','/static/product/6023.jpg','<p>生牛乳发酵常温酸奶，儿童老人均可饮用</p>',3,1,18),
(6024,5011,2006,'农夫山泉鲜榨芒果复合果汁1L瓶装','果香浓郁 冰镇更好喝','/static/product/6024.jpg','<p>多种热带水果复配果汁，聚会分享饮品</p>',3,1,45);

-- ============================================================
-- 14. product_category_relation
-- ============================================================
DROP TABLE IF EXISTS `product_category_relation`;
CREATE TABLE `product_category_relation` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '记录ID（主键）',
  `product_id` bigint DEFAULT NULL COMMENT '商品ID',
  `category_id` bigint DEFAULT NULL COMMENT '分类ID',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `fk_pcr_product` (`product_id`) USING BTREE,
  KEY `fk_pcr_category` (`category_id`) USING BTREE,
  CONSTRAINT `fk_pcr_category` FOREIGN KEY (`category_id`) REFERENCES `category` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_pcr_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7025 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='商品分类中间表';

INSERT INTO `product_category_relation` VALUES
(7001,6001,201),(7002,6002,201),(7003,6003,201),(7004,6004,201),(7005,6005,201),(7006,6006,201),(7007,6007,201),(7008,6008,201),
(7009,6009,101),(7010,6010,101),(7011,6011,101),(7012,6012,201),
(7013,6013,202),(7014,6014,202),(7015,6015,202),(7016,6016,202),
(7017,6017,107),(7018,6018,107),(7019,6019,103),(7020,6020,107),
(7021,6021,203),(7022,6022,203),(7023,6023,203),(7024,6024,203);

-- ============================================================
-- 15. sku
-- ============================================================
DROP TABLE IF EXISTS `sku`;
CREATE TABLE `sku` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'SkuID（主键）',
  `product_id` bigint DEFAULT NULL COMMENT '商品ID',
  `specs` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '规格属性(JSON格式)',
  `price` decimal(10,2) DEFAULT NULL COMMENT '销售价格',
  `stock` int DEFAULT NULL COMMENT '物理库存',
  `sku_code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'SKU编码',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `fk_sku_product` (`product_id`) USING BTREE,
  CONSTRAINT `fk_sku_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8025 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='商品规格库存表';

INSERT INTO `sku` VALUES
(8001,6001,'{"规格":"30包装","净重":"600g-750g"}',77.00,90,'AKS-NUT-30B-750'),
(8002,6002,'{"规格":"1袋装","净重":"200g","口味":"卤香"}',26.00,180,'LPPZ-CHICK-1B-200'),
(8003,6003,'{"规格":"1袋装","净重":"500g"}',35.90,150,'BWW-MANGO-1B-500'),
(8004,6004,'{"规格":"1袋装","净重":"520g"}',22.90,220,'WW-RICE-1B-520'),
(8005,6005,'{"规格":"10包装","单包":"68g"}',19.90,300,'WL-LATIAO-10B-680'),
(8006,6006,'{"规格":"6枚盒装","净重":"360g"}',35.00,130,'LPPZ-YOLK-6P-360'),
(8007,6007,'{"规格":"1盒装","净重":"400g"}',24.90,110,'DIY-CAKE-1B-400'),
(8008,6008,'{"规格":"1袋装","净重":"300g"}',27.90,160,'BWW-SNOW-1B-300'),
(8009,6009,'{"规格":"5斤装","果径":"80-85mm"}',36.90,200,'AKS-APPLE-10J-85'),
(8010,6010,'{"规格":"8斤装","果径":"75-80mm"}',49.90,140,'FJ-ORANGE-8J-75'),
(8011,6011,'{"规格":"12粒礼盒","等级":"特级"}',118.00,50,'ZESP-KIWI-12P-S'),
(8012,6012,'{"规格":"30包装","净重":"750g"}',85.00,130,'WL-NUT-30B-750'),
(8013,6013,'{"规格":"1袋装","净重":"5000g"}',68.00,80,'JLY-RICE-1P-5000'),
(8014,6014,'{"规格":"1桶装","容量":"1900ml"}',22.90,160,'HT-SAUCE-1T-1900'),
(8015,6015,'{"规格":"20包装","单包":"80g"}',16.90,300,'FL-PICKLE-20B-1600'),
(8016,6016,'{"规格":"1袋装","净重":"1000g"}',22.00,120,'HS-FOOD-1B-1000'),
(8017,6017,'{"规格":"1袋装","净重":"210g","口味":"山椒"}',18.90,220,'YY-CHICK-1B-210'),
(8018,6018,'{"规格":"1盒","净重":"200g","口味":"香辣"}',24.90,140,'JW-DUCK-1H-200'),
(8019,6019,'{"规格":"1袋装","净重":"150g"}',29.90,110,'HD-BEEF-1B-150'),
(8020,6020,'{"规格":"1盒装","净重":"300g"}',16.90,170,'LX-EGG-1H-300'),
(8021,6021,'{"规格":"15瓶装","单瓶":"480ml","口味":"白桃"}',65.00,90,'YQSL-DRINK-15B-7200'),
(8022,6022,'{"规格":"1瓶装","容量":"900ml"}',19.90,130,'NFSQ-JUICE-1B-900'),
(8023,6023,'{"规格":"12盒装","单盒":"200g"}',42.90,100,'MN-YOGURT-12B-2400'),
(8024,6024,'{"规格":"1瓶装","容量":"1000ml"}',22.90,150,'XC-MANGOJUICE-1B-1000');

-- ============================================================
-- 16. cart
-- ============================================================
DROP TABLE IF EXISTS `cart`;
CREATE TABLE `cart` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '购物车ID（主键）',
  `user_id` bigint DEFAULT NULL COMMENT '用户ID',
  `sku_id` bigint DEFAULT NULL COMMENT 'SkuID',
  `quantity` int DEFAULT NULL COMMENT '购买数量',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `fk_cart_user` (`user_id`) USING BTREE,
  KEY `fk_cart_sku` (`sku_id`) USING BTREE,
  CONSTRAINT `fk_cart_sku` FOREIGN KEY (`sku_id`) REFERENCES `sku` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_cart_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='购物车表';

INSERT INTO `cart` VALUES
(1,1007,8003,2),(2,1008,8005,1),(3,1009,8012,1),(4,1010,8001,3),(5,1011,8017,2),(6,1012,8021,1),(7,1013,8010,1),(8,1014,8006,4),(9,1015,8013,1),(10,1016,8023,2),(11,1017,8008,3),(12,1018,8019,1),(13,1019,8002,2),(14,1020,8014,5),(15,1021,8024,2);

-- ============================================================
-- 17. merchant_apply
-- ============================================================
DROP TABLE IF EXISTS `merchant_apply`;
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

INSERT INTO `merchant_apply` VALUES
(4001,1001,2,'润禾食品商贸有限公司','/static/id_card/front_1001.jpg','/static/id_card/back_1001.jpg','91500101MA03XXX01',NULL,'JY500101XXX01',NULL,'陈一','17782222101','重庆市渝北区金开大道星光天地12铺','润禾生活食铺',1,'企业资质齐全，证照审核通过','2026-06-05 09:10:00'),
(4002,1002,1,'食愈小铺食品经营店','/static/id_card/front_1002.jpg','/static/id_card/back_1002.jpg',NULL,NULL,NULL,NULL,'王二','17782222102','重庆市江北区观音桥星光68负一楼','食愈小铺',1,'个体证件完整，准予入驻','2026-06-08 14:25:00'),
(4003,1003,2,'鲜禧果蔬农产品有限公司','/static/id_card/front_1003.jpg','/static/id_card/back_1003.jpg','91500103MA03XXX03',NULL,'JY500103XXX03',NULL,'李三','17782222103','重庆市南岸区南坪协信星光一层','鲜禧果仓',1,'生鲜食品资质核验无误','2026-06-12 10:05:00'),
(4004,1004,2,'家禾粮油副食配送公司','/static/id_card/front_1004.jpg','/static/id_card/back_1004.jpg','91500104MA03XXX04',NULL,'JY500104XXX04',NULL,'赵四','17782222104','重庆市九龙坡区杨家坪直港大道','家禾粮油副食',1,'粮油经营许可齐全，审核通过','2026-06-15 16:30:00'),
(4005,1005,1,'巷味卤货小吃店','/static/id_card/front_1005.jpg','/static/id_card/back_1005.jpg',NULL,NULL,NULL,NULL,'钱五','17782222105','重庆市渝中区两路口桂花园路','巷味卤货',1,'熟食卫生资质达标，审核通过','2026-06-20 11:15:00'),
(4006,1006,1,'果汽鲜饮饮品店','/static/id_card/front_1006.jpg','/static/id_card/back_1006.jpg',NULL,NULL,NULL,NULL,'张六','17782222106','重庆市南岸区茶园时代都汇临街铺','果汽鲜饮',0,'资料待补充食品留样记录，暂未通过','2026-06-25 08:40:00');

-- ============================================================
-- 18. merchant_qualification
-- ============================================================
DROP TABLE IF EXISTS `merchant_qualification`;
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

INSERT INTO `merchant_qualification` VALUES
(3001,2001,'综合休闲食品、鲜果零食','91500101MA03XXX01','/static/business_license/1001.jpg','JY500101XXX01','/static/food_permit/1001.jpg'),
(3002,2002,'网红零食、糕点膨化食品','91500102MA03XXX02','/static/business_license/1002.jpg','JY500102XXX02','/static/food_permit/1002.jpg'),
(3003,2003,'新鲜水果、果干蜜饯坚果','91500103MA03XXX03','/static/business_license/1003.jpg','JY500103XXX03','/static/food_permit/1003.jpg'),
(3004,2004,'粮油米面、调味罐头速食','91500104MA03XXX04','/static/business_license/1004.jpg','JY500104XXX04','/static/food_permit/1004.jpg'),
(3005,2005,'卤味熟食、肉干即食食品','91500105MA03XXX05','/static/business_license/1005.jpg','JY500105XXX05','/static/food_permit/1005.jpg');

-- ============================================================
-- 19. pickup_point
-- ============================================================
DROP TABLE IF EXISTS `pickup_point`;
CREATE TABLE `pickup_point` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '自提点ID（主键）',
  `merchant_id` bigint DEFAULT NULL COMMENT '所属商家ID',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '自提点名称',
  `address` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '自提点详细地址',
  `contact_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '联系电话',
  `status` tinyint DEFAULT NULL COMMENT '营业状态',
  `audit_status` tinyint DEFAULT NULL COMMENT '审核状态',
  `audit_remark` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '审核备注',
  `audit_time` datetime DEFAULT NULL COMMENT '审核通过时间',
  `image` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '自提点照片',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `fk_pickup_merchant` (`merchant_id`) USING BTREE,
  CONSTRAINT `fk_pickup_merchant` FOREIGN KEY (`merchant_id`) REFERENCES `merchant` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='自提点表';

INSERT INTO `pickup_point` VALUES
(7,2001,'润禾生活食铺自提点','重庆市渝中区解放西路126号附8号','17782224500',1,1,NULL,'2026-05-10 10:00:00',NULL,NULL),
(8,2002,'食愈小站自提点','重庆市大渡口区新山村春晖路66号','17782224501',1,1,NULL,'2026-05-10 10:00:00',NULL,NULL),
(9,2003,'鲜禧果仓自提点','重庆市巴南区龙洲湾渝南大道132号','17782224502',1,1,NULL,'2026-05-10 10:00:00',NULL,NULL);

-- ============================================================
-- 20. order
-- ============================================================
DROP TABLE IF EXISTS `order`;
CREATE TABLE `order` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '订单ID（主键）',
  `order_sn` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '订单编号',
  `user_id` bigint DEFAULT NULL COMMENT '用户ID',
  `merchant_id` bigint DEFAULT NULL COMMENT '商家ID',
  `pickup_point_id` bigint DEFAULT NULL COMMENT '自提点ID',
  `total_amount` decimal(10,2) DEFAULT NULL COMMENT '订单总价',
  `pay_amount` decimal(10,2) DEFAULT NULL COMMENT '应付金额',
  `discount_amount` decimal(10,2) DEFAULT '0.00' COMMENT '优惠金额',
  `delivery_type` tinyint DEFAULT NULL COMMENT '配送方式',
  `delivery_fee` decimal(10,2) DEFAULT '0.00' COMMENT '配送费',
  `status` tinyint DEFAULT NULL COMMENT '订单状态',
  `idempotent_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '幂等键',
  `used_points` int DEFAULT '0' COMMENT '使用积分',
  `points_status` tinyint DEFAULT '0' COMMENT '积分状态',
  `address_id` bigint DEFAULT NULL COMMENT '收货地址ID',
  `consignee` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '收货人',
  `consignee_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '收货人电话',
  `consignee_address` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '收货地址快照',
  `coupon_user_id` bigint DEFAULT NULL COMMENT '优惠券领用ID',
  `coupon_discount` decimal(10,2) DEFAULT '0.00' COMMENT '优惠券抵扣',
  `seckill_id` bigint DEFAULT NULL COMMENT '秒杀活动ID',
  `bargain_id` bigint DEFAULT NULL COMMENT '砍价活动ID',
  `pay_method` tinyint DEFAULT NULL COMMENT '支付方式',
  `pay_expire_time` datetime DEFAULT NULL COMMENT '支付过期时间',
  `pay_time` datetime DEFAULT NULL COMMENT '支付时间',
  `cancel_time` datetime DEFAULT NULL COMMENT '取消时间',
  `create_time` datetime DEFAULT NULL COMMENT '下单时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `accept_time` datetime DEFAULT NULL COMMENT '接单时间',
  `prepare_time` datetime DEFAULT NULL COMMENT '备货完成时间',
  `complete_time` datetime DEFAULT NULL COMMENT '完成时间',
  `user_deleted` tinyint DEFAULT '0' COMMENT '用户删除标记',
  `pickup_code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '自提码',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `fk_order_user` (`user_id`) USING BTREE,
  KEY `fk_order_merchant` (`merchant_id`) USING BTREE,
  KEY `fk_order_pickup` (`pickup_point_id`) USING BTREE,
  CONSTRAINT `fk_order_merchant` FOREIGN KEY (`merchant_id`) REFERENCES `merchant` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_order_pickup` FOREIGN KEY (`pickup_point_id`) REFERENCES `pickup_point` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_order_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=98 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='订单主表';

INSERT INTO `order` VALUES
(51,'202605051030010001',1004,2001,NULL,77.00,82.00,0.00,1,5.00,4,'IK_1004_20260505103001',0,0,101,'赵六','17782222104','重庆市江北区观音桥建新北路76号阳光花园3栋1502',NULL,0.00,NULL,NULL,1,'2026-05-05 11:00:00','2026-05-05 10:31:25',NULL,'2026-05-05 10:30:00','2026-05-05 10:31:25','2026-05-05 10:35:00','2026-05-05 11:20:00','2026-05-06 09:00:00',0,NULL),
(52,'202605061420010002',1004,2002,NULL,39.80,44.80,0.00,1,5.00,4,'IK_1004_20260506142001',0,0,101,'赵六','17782222104','重庆市江北区观音桥建新北路76号阳光花园3栋1502',NULL,0.00,NULL,NULL,2,'2026-05-06 14:50:00','2026-05-06 14:22:30',NULL,'2026-05-06 14:20:00','2026-05-06 14:22:30','2026-05-06 14:28:00','2026-05-06 14:55:00','2026-05-07 10:00:00',0,NULL),
(53,'202605070915020003',1007,2003,9,36.90,36.90,0.00,2,0.00,4,'IK_1007_20260507091501',0,0,NULL,NULL,NULL,NULL,NULL,0.00,NULL,NULL,1,'2026-05-07 09:45:00','2026-05-07 09:16:40',NULL,'2026-05-07 09:15:00','2026-05-07 09:16:40','2026-05-07 09:22:00','2026-05-07 10:30:00','2026-05-07 17:00:00',0,'345821'),
(54,'202605081645010004',1008,2001,7,48.90,48.90,0.00,2,0.00,4,'IK_1008_20260508164501',0,0,NULL,NULL,NULL,NULL,NULL,0.00,NULL,NULL,2,'2026-05-08 17:15:00','2026-05-08 16:46:10',NULL,'2026-05-08 16:45:00','2026-05-08 16:46:10','2026-05-08 16:52:00','2026-05-08 17:30:00','2026-05-09 11:00:00',0,'672109'),
(55,'202605091130010005',1004,2003,NULL,118.00,118.00,5.00,1,5.00,4,'IK_1004_20260509113001',200,2,NULL,'赵六','17782222104','重庆市江北区观音桥建新北路76号阳光花园3栋1502',5001,5.00,NULL,NULL,1,'2026-05-09 12:00:00','2026-05-09 11:31:50',NULL,'2026-05-09 11:30:00','2026-05-09 11:31:50','2026-05-09 11:38:00','2026-05-09 12:10:00','2026-05-10 09:30:00',0,NULL),
(56,'202605100850020006',1009,2002,8,62.90,62.90,0.00,2,0.00,4,'IK_1009_20260510085001',0,0,NULL,NULL,NULL,NULL,NULL,0.00,NULL,NULL,2,'2026-05-10 09:20:00','2026-05-10 08:52:15',NULL,'2026-05-10 08:50:00','2026-05-10 08:52:15','2026-05-10 08:58:00','2026-05-10 09:35:00','2026-05-10 18:00:00',0,'894231'),
(57,'202605121310010007',1010,2004,NULL,84.90,89.90,0.00,1,5.00,4,'IK_1010_20260512131001',0,0,102,'赵一','17782222107','重庆市渝北区冉家坝龙湖水晶郦城2栋1001',NULL,0.00,NULL,NULL,1,'2026-05-12 13:40:00','2026-05-12 13:11:30',NULL,'2026-05-12 13:10:00','2026-05-12 13:11:30','2026-05-12 13:20:00','2026-05-12 13:50:00','2026-05-13 08:00:00',0,NULL),
(58,'202605141025010008',1004,2001,NULL,112.90,107.90,10.00,1,5.00,4,'IK_1004_20260514102501',300,2,101,'赵六','17782222104','重庆市江北区观音桥建新北路76号阳光花园3栋1502',5002,10.00,NULL,NULL,1,'2026-05-14 10:55:00','2026-05-14 10:27:05',NULL,'2026-05-14 10:25:00','2026-05-14 10:27:05','2026-05-14 10:33:00','2026-05-14 11:00:00','2026-05-15 09:00:00',0,NULL),
(59,'202605170940010009',1011,2005,NULL,37.80,42.80,0.00,1,5.00,4,'IK_1011_20260517094001',0,0,103,'孙小红','17782222108','重庆市南岸区南坪上海城19栋705',NULL,0.00,NULL,NULL,2,'2026-05-17 10:10:00','2026-05-17 09:41:20',NULL,'2026-05-17 09:40:00','2026-05-17 09:41:20','2026-05-17 09:48:00','2026-05-17 10:20:00','2026-05-18 08:30:00',0,NULL),
(60,'202605181520010010',1012,2006,NULL,65.00,70.00,0.00,1,5.00,4,'IK_1012_20260518152001',0,0,104,'周小明','17782222109','重庆市九龙坡区谢家湾华润24城5栋2203',NULL,0.00,NULL,NULL,1,'2026-05-18 15:50:00','2026-05-18 15:21:45',NULL,'2026-05-18 15:20:00','2026-05-18 15:21:45','2026-05-18 15:30:00','2026-05-18 16:05:00','2026-05-19 10:00:00',0,NULL),
(61,'202605201105020011',1004,2002,8,24.90,24.90,0.00,2,0.00,4,'IK_1004_20260520110501',0,0,NULL,NULL,NULL,NULL,NULL,0.00,NULL,NULL,2,'2026-05-20 11:35:00','2026-05-20 11:06:30',NULL,'2026-05-20 11:05:00','2026-05-20 11:06:30','2026-05-20 11:12:00','2026-05-20 11:50:00','2026-05-20 17:30:00',0,'156479'),
(62,'202605211430010012',1013,2003,NULL,49.90,54.90,0.00,1,5.00,4,'IK_1013_20260521143001',0,0,105,'吴小丽','17782222110','重庆市大渡口区九宫庙湖榕路锦天康都1栋1204',NULL,0.00,NULL,NULL,1,'2026-05-21 15:00:00','2026-05-21 14:31:50',NULL,'2026-05-21 14:30:00','2026-05-21 14:31:50','2026-05-21 14:40:00','2026-05-21 15:15:00','2026-05-22 09:00:00',0,NULL),
(63,'202605221715010013',1008,2004,NULL,44.90,49.90,0.00,1,5.00,5,'IK_1008_20260522171501',0,0,106,'王一','17782222111','重庆市巴南区鱼洞巴南印象6栋808',NULL,0.00,NULL,NULL,2,'2026-05-22 17:45:00','2026-05-22 17:16:30',NULL,'2026-05-22 17:15:00','2026-05-22 17:26:30','2026-05-22 17:22:00','2026-05-22 17:40:00','2026-05-22 17:40:00',0,NULL),
(64,'202605241000010014',1007,2005,NULL,24.90,29.90,0.00,1,5.00,4,'IK_1007_20260524100001',0,0,107,'陈二','17782222112','重庆市渝北区龙溪街道武陵路锦江郦城9栋1601',NULL,0.00,NULL,NULL,1,'2026-05-24 10:30:00','2026-05-24 10:01:40',NULL,'2026-05-24 10:00:00','2026-05-24 10:01:40','2026-05-24 10:10:00','2026-05-24 10:45:00','2026-05-25 08:30:00',0,NULL),
(65,'202605251650020015',1014,2001,7,77.00,72.00,5.00,2,0.00,4,'IK_1014_20260525165001',0,0,NULL,NULL,NULL,NULL,5003,5.00,NULL,NULL,1,'2026-05-25 17:20:00','2026-05-25 16:51:30',NULL,'2026-05-25 16:50:00','2026-05-25 16:51:30','2026-05-25 16:58:00','2026-05-25 17:30:00','2026-05-26 09:00:00',0,'483290'),
(66,'202605270930010016',1009,2006,NULL,65.80,70.80,0.00,1,5.00,3,'IK_1009_20260527093001',0,0,108,'李二','17782222113','重庆市江北区五里店融景城郎峰11栋505',NULL,0.00,NULL,NULL,2,'2026-05-27 10:00:00','2026-05-27 09:31:25',NULL,'2026-05-27 09:30:00','2026-05-27 09:31:25','2026-05-27 09:35:00','2026-05-27 09:55:00','2026-05-27 10:20:00',0,NULL),
(67,'202605291345010017',1004,2002,NULL,64.70,69.70,0.00,1,5.00,4,'IK_1004_20260529134501',0,0,101,'赵六','17782222104','重庆市江北区观音桥建新北路76号阳光花园3栋1502',NULL,0.00,NULL,NULL,1,'2026-05-29 14:15:00','2026-05-29 13:46:10',NULL,'2026-05-29 13:45:00','2026-05-29 13:46:10','2026-05-29 13:52:00','2026-05-29 14:30:00','2026-05-30 09:00:00',0,NULL),
(68,'202605301120010018',1015,2004,NULL,101.80,106.80,0.00,1,5.00,4,'IK_1015_20260530112001',0,0,109,'郑七','17782222114','重庆市南岸区弹子石国际社区海悦府8栋2806',NULL,0.00,NULL,NULL,2,'2026-05-30 11:50:00','2026-05-30 11:22:00',NULL,'2026-05-30 11:20:00','2026-05-30 11:22:00','2026-05-30 11:30:00','2026-05-30 12:05:00','2026-05-31 09:00:00',0,NULL),
(69,'202606011030010019',1004,2004,NULL,68.00,73.00,0.00,1,5.00,4,'IK_1004_20260601103001',0,0,101,'赵六','17782222104','重庆市江北区观音桥建新北路76号阳光花园3栋1502',NULL,0.00,NULL,NULL,1,'2026-06-01 11:00:00','2026-06-01 10:31:30',NULL,'2026-06-01 10:30:00','2026-06-01 10:31:30','2026-06-01 10:38:00','2026-06-01 11:10:00','2026-06-02 09:00:00',0,NULL),
(70,'202606031400020020',1007,2002,8,82.80,82.80,0.00,2,0.00,4,'IK_1007_20260603140001',0,0,NULL,NULL,NULL,NULL,NULL,0.00,NULL,NULL,2,'2026-06-03 14:30:00','2026-06-03 14:01:20',NULL,'2026-06-03 14:00:00','2026-06-03 14:01:20','2026-06-03 14:08:00','2026-06-03 14:40:00','2026-06-04 10:00:00',0,'729583'),
(71,'202606050915010021',1010,2001,NULL,58.80,63.80,0.00,1,5.00,4,'IK_1010_20260605091501',0,0,102,'赵一','17782222107','重庆市渝北区冉家坝龙湖水晶郦城2栋1001',NULL,0.00,NULL,NULL,1,'2026-06-05 09:45:00','2026-06-05 09:16:10',NULL,'2026-06-05 09:15:00','2026-06-05 09:16:10','2026-06-05 09:22:00','2026-06-05 09:55:00','2026-06-06 08:30:00',0,NULL),
(72,'202606071630020022',1011,2003,9,85.00,85.00,0.00,2,0.00,4,'IK_1011_20260607163001',200,2,NULL,NULL,NULL,NULL,NULL,0.00,NULL,NULL,1,'2026-06-07 17:00:00','2026-06-07 16:32:00',NULL,'2026-06-07 16:30:00','2026-06-07 16:32:00','2026-06-07 16:40:00','2026-06-07 17:20:00','2026-06-08 09:00:00',0,'314670'),
(73,'202606091145010023',1008,2005,NULL,29.90,34.90,0.00,1,5.00,4,'IK_1008_20260609114501',0,0,106,'王一','17782222111','重庆市巴南区鱼洞巴南印象6栋808',NULL,0.00,NULL,NULL,2,'2026-06-09 12:15:00','2026-06-09 11:46:40',NULL,'2026-06-09 11:45:00','2026-06-09 11:46:40','2026-06-09 11:55:00','2026-06-09 12:30:00','2026-06-10 08:00:00',0,NULL),
(74,'202606100850010024',1016,2006,NULL,39.80,44.80,0.00,1,5.00,5,'IK_1016_20260610085001',0,0,110,'冯八','17782222115','重庆市渝中区大坪英利国际2栋2208',NULL,0.00,NULL,NULL,1,'2026-06-10 09:20:00','2026-06-10 08:52:00',NULL,'2026-06-10 08:50:00','2026-06-10 09:02:00','2026-06-10 08:56:00','2026-06-10 09:10:00','2026-06-10 09:10:00',0,NULL),
(75,'202606121510020025',1004,2001,7,74.90,64.90,10.00,2,0.00,4,'IK_1004_20260612151001',0,0,NULL,NULL,NULL,NULL,5004,10.00,NULL,NULL,2,'2026-06-12 15:40:00','2026-06-12 15:11:30',NULL,'2026-06-12 15:10:00','2026-06-12 15:11:30','2026-06-12 15:18:00','2026-06-12 16:00:00','2026-06-13 09:30:00',0,'508923'),
(76,'202606131025010026',1017,2004,NULL,39.80,44.80,0.00,1,5.00,3,'IK_1017_20260613102501',0,0,111,'陈九','17782222116','重庆市九龙坡区石桥铺华宇名都15栋1609',NULL,0.00,NULL,NULL,1,'2026-06-13 10:55:00','2026-06-13 10:26:30',NULL,'2026-06-13 10:25:00','2026-06-13 10:26:30','2026-06-13 10:32:00','2026-06-13 11:00:00','2026-06-13 11:20:00',0,NULL),
(77,'202606141430020027',1009,2003,9,49.90,49.90,0.00,2,0.00,4,'IK_1009_20260614143001',0,0,NULL,NULL,NULL,NULL,NULL,0.00,NULL,NULL,2,'2026-06-14 15:00:00','2026-06-14 14:31:50',NULL,'2026-06-14 14:30:00','2026-06-14 14:31:50','2026-06-14 14:38:00','2026-06-14 15:10:00','2026-06-14 18:00:00',0,'892105'),
(78,'202606151620010028',1009,2005,NULL,33.80,38.80,0.00,1,5.00,4,'IK_1009_20260615162001',0,0,108,'李二','17782222113','重庆市江北区五里店融景城郎峰11栋505',NULL,0.00,NULL,NULL,1,'2026-06-15 16:50:00','2026-06-15 16:21:30',NULL,'2026-06-15 16:20:00','2026-06-15 16:21:30','2026-06-15 16:28:00','2026-06-15 17:00:00','2026-06-16 08:30:00',0,NULL),
(79,'202606150950010029',1018,2005,NULL,35.80,40.80,0.00,1,5.00,4,'IK_1018_20260615095001',0,0,112,'林十','17782222117','重庆市大渡口区春晖路柏华小区3栋402',NULL,0.00,NULL,NULL,2,'2026-06-15 10:20:00','2026-06-15 09:52:00',NULL,'2026-06-15 09:50:00','2026-06-15 09:52:00','2026-06-15 10:00:00','2026-06-15 10:35:00','2026-06-16 09:00:00',0,NULL),
(80,'202606171130010030',1004,2002,NULL,59.70,64.70,0.00,1,5.00,4,'IK_1004_20260617113001',0,0,101,'赵六','17782222104','重庆市江北区观音桥建新北路76号阳光花园3栋1502',NULL,0.00,NULL,NULL,1,'2026-06-17 12:00:00','2026-06-17 11:31:20',NULL,'2026-06-17 11:30:00','2026-06-17 11:31:20','2026-06-17 11:40:00','2026-06-17 12:15:00','2026-06-18 08:30:00',0,NULL),
(81,'202606181600020031',1012,2001,7,71.80,66.80,5.00,2,0.00,4,'IK_1012_20260618160001',0,0,NULL,NULL,NULL,NULL,5005,5.00,NULL,NULL,1,'2026-06-18 16:30:00','2026-06-18 16:01:40',NULL,'2026-06-18 16:00:00','2026-06-18 16:01:40','2026-06-18 16:08:00','2026-06-18 16:45:00','2026-06-19 09:00:00',0,'637451'),
(82,'202606201015010032',1010,2006,NULL,84.90,89.90,0.00,1,5.00,4,'IK_1010_20260620101501',0,0,102,'赵一','17782222107','重庆市渝北区冉家坝龙湖水晶郦城2栋1001',NULL,0.00,NULL,NULL,2,'2026-06-20 10:45:00','2026-06-20 10:17:00',NULL,'2026-06-20 10:15:00','2026-06-20 10:17:00','2026-06-20 10:25:00','2026-06-20 10:55:00','2026-06-21 08:30:00',0,NULL),
(83,'202606211445010033',1013,2004,NULL,44.00,49.00,0.00,1,5.00,4,'IK_1013_20260621144501',0,0,105,'吴小丽','17782222110','重庆市大渡口区九宫庙湖榕路锦天康都1栋1204',NULL,0.00,NULL,NULL,1,'2026-06-21 15:15:00','2026-06-21 14:46:30',NULL,'2026-06-21 14:45:00','2026-06-21 14:46:30','2026-06-21 14:55:00','2026-06-21 15:30:00','2026-06-22 09:00:00',0,NULL),
(84,'202606221000020034',1010,2002,8,55.80,55.80,0.00,2,0.00,4,'IK_1010_20260622100001',0,0,NULL,NULL,NULL,NULL,NULL,0.00,NULL,NULL,2,'2026-06-22 10:30:00','2026-06-22 10:01:50',NULL,'2026-06-22 10:00:00','2026-06-22 10:01:50','2026-06-22 10:08:00','2026-06-22 10:40:00','2026-06-23 08:00:00',0,'245168'),
(85,'202606230930010035',1007,2005,NULL,54.80,54.80,5.00,1,5.00,4,'IK_1007_20260623093001',0,0,107,'陈二','17782222112','重庆市渝北区龙溪街道武陵路锦江郦城9栋1601',5006,5.00,NULL,NULL,1,'2026-06-23 10:00:00','2026-06-23 09:31:40',NULL,'2026-06-23 09:30:00','2026-06-23 09:31:40','2026-06-23 09:40:00','2026-06-23 10:15:00','2026-06-24 09:00:00',0,NULL),
(86,'202606241720020036',1019,2003,9,118.00,113.00,5.00,2,0.00,4,'IK_1019_20260624172001',0,0,NULL,NULL,NULL,NULL,5007,5.00,NULL,NULL,1,'2026-06-24 17:50:00','2026-06-24 17:21:30',NULL,'2026-06-24 17:20:00','2026-06-24 17:21:30','2026-06-24 17:28:00','2026-06-24 18:05:00','2026-06-25 09:30:00',0,'419387'),
(87,'202606261100010037',1004,2004,NULL,68.00,73.00,0.00,1,5.00,5,'IK_1004_20260626110001',0,0,101,'赵六','17782222104','重庆市江北区观音桥建新北路76号阳光花园3栋1502',NULL,0.00,NULL,NULL,2,'2026-06-26 11:30:00','2026-06-26 11:02:00',NULL,'2026-06-26 11:00:00','2026-06-26 11:12:00','2026-06-26 11:06:00','2026-06-26 11:20:00','2026-06-26 11:20:00',0,NULL),
(88,'202606271530020038',1020,2002,8,49.80,49.80,0.00,2,0.00,4,'IK_1020_20260627153001',0,0,NULL,NULL,NULL,NULL,NULL,0.00,NULL,NULL,2,'2026-06-27 16:00:00','2026-06-27 15:31:20',NULL,'2026-06-27 15:30:00','2026-06-27 15:31:20','2026-06-27 15:38:00','2026-06-27 16:10:00','2026-06-28 09:00:00',0,'706842'),
(89,'202606291005010039',1008,2001,NULL,103.00,108.00,0.00,1,5.00,4,'IK_1008_20260629100501',0,0,106,'王一','17782222111','重庆市巴南区鱼洞巴南印象6栋808',NULL,0.00,NULL,NULL,1,'2026-06-29 10:35:00','2026-06-29 10:06:30',NULL,'2026-06-29 10:05:00','2026-06-29 10:06:30','2026-06-29 10:15:00','2026-06-29 10:50:00','2026-06-30 08:30:00',0,NULL),
(90,'202606301340010040',1011,2006,NULL,42.90,47.90,0.00,1,5.00,3,'IK_1011_20260630134001',0,0,103,'孙小红','17782222108','重庆市南岸区南坪上海城19栋705',NULL,0.00,NULL,NULL,1,'2026-06-30 14:10:00','2026-06-30 13:41:20',NULL,'2026-06-30 13:40:00','2026-06-30 13:41:20','2026-06-30 13:48:00','2026-06-30 14:05:00','2026-06-30 14:25:00',0,NULL),
(91,'202607010920010041',1009,2005,NULL,56.70,61.70,0.00,1,5.00,2,'IK_1009_20260701092001',0,0,108,'李二','17782222113','重庆市江北区五里店融景城郎峰11栋505',NULL,0.00,NULL,NULL,2,'2026-07-01 09:50:00','2026-07-01 09:22:00',NULL,'2026-07-01 09:20:00','2026-07-01 09:22:00','2026-07-01 09:28:00','2026-07-01 09:45:00',NULL,0,NULL),
(92,'202607021115020042',1010,2003,9,121.90,121.90,0.00,2,0.00,1,'IK_1010_20260702111501',0,0,NULL,NULL,NULL,NULL,NULL,0.00,NULL,NULL,1,'2026-07-02 11:45:00','2026-07-02 11:16:30',NULL,'2026-07-02 11:15:00','2026-07-02 11:16:30',NULL,NULL,NULL,0,'583029'),
(93,'202607021430010043',1013,2006,NULL,68.70,73.70,0.00,1,5.00,0,'IK_1013_20260702143001',400,1,105,'吴小丽','17782222110','重庆市大渡口区九宫庙湖榕路锦天康都1栋1204',NULL,0.00,NULL,NULL,1,'2026-07-02 15:00:00',NULL,NULL,'2026-07-02 14:30:00','2026-07-02 14:30:00',NULL,NULL,NULL,0,NULL),
(94,'202607031000010044',1007,2004,NULL,90.00,95.00,0.00,1,5.00,1,'IK_1007_20260703100001',0,0,107,'陈二','17782222112','重庆市渝北区龙溪街道武陵路锦江郦城9栋1601',NULL,0.00,NULL,NULL,2,'2026-07-03 10:30:00','2026-07-03 10:02:00',NULL,'2026-07-03 10:00:00','2026-07-03 10:02:00',NULL,NULL,NULL,0,NULL),
(95,'202607031645020045',1021,2001,7,45.80,45.80,0.00,2,0.00,0,'IK_1021_20260703164501',0,0,NULL,NULL,NULL,NULL,NULL,0.00,NULL,NULL,2,'2026-07-03 17:15:00',NULL,NULL,'2026-07-03 16:45:00','2026-07-03 16:45:00',NULL,NULL,NULL,0,'921056'),
(96,'202607040930010046',1008,2002,NULL,59.90,64.90,0.00,1,5.00,2,'IK_1008_20260704093001',0,0,106,'王一','17782222111','重庆市巴南区鱼洞巴南印象6栋808',NULL,0.00,NULL,NULL,1,'2026-07-04 10:00:00','2026-07-04 09:31:50',NULL,'2026-07-04 09:30:00','2026-07-04 09:31:50','2026-07-04 09:36:00','2026-07-04 09:50:00',NULL,0,NULL),
(97,'202607051100010047',1012,2005,NULL,66.70,71.70,0.00,1,5.00,0,'IK_1012_20260705110001',0,0,104,'周小明','17782222109','重庆市九龙坡区谢家湾华润24城5栋2203',NULL,0.00,NULL,NULL,2,'2026-07-05 11:30:00',NULL,NULL,'2026-07-05 11:00:00','2026-07-05 11:00:00',NULL,NULL,NULL,0,NULL);

-- ============================================================
-- 21. order_item
-- ============================================================
DROP TABLE IF EXISTS `order_item`;
CREATE TABLE `order_item` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '明细ID（主键）',
  `order_id` bigint DEFAULT NULL COMMENT '订单ID',
  `product_id` bigint DEFAULT NULL COMMENT '商品ID',
  `sku_id` bigint DEFAULT NULL COMMENT 'SkuID',
  `product_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '商品快照名称',
  `product_image` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '商品图片快照',
  `sku_specs` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '规格快照',
  `origin_price` decimal(10,2) DEFAULT NULL COMMENT '商品原价',
  `price` decimal(10,2) DEFAULT NULL COMMENT '购买单价',
  `final_price` decimal(10,2) DEFAULT NULL COMMENT '最终单价',
  `quantity` int DEFAULT NULL COMMENT '购买数量',
  `item_origin_amount` decimal(10,2) DEFAULT NULL COMMENT '原价小计',
  `item_final_amount` decimal(10,2) DEFAULT NULL COMMENT '实付小计',
  `promotion_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT 'NORMAL' COMMENT '促销类型',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `fk_items_order` (`order_id`) USING BTREE,
  KEY `fk_items_sku` (`sku_id`) USING BTREE,
  CONSTRAINT `fk_items_order` FOREIGN KEY (`order_id`) REFERENCES `order` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_items_sku` FOREIGN KEY (`sku_id`) REFERENCES `sku` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=159 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='订单明细表';

INSERT INTO `order_item` VALUES
(91,51,6001,8001,'三只松鼠每日坚果30包礼盒','/static/product/6001.jpg','{\"规格\":\"30包装\",\"净重\":\"600g-750g\"}',77.00,77.00,77.00,1,77.00,77.00,'NORMAL'),
(92,52,6005,8005,'卫龙大面筋68g*10包','/static/product/6005.jpg','{\"规格\":\"68g*10包\",\"口味\":\"香辣味\"}',19.90,19.90,19.90,2,39.80,39.80,'NORMAL'),
(93,53,6009,8009,'阿克苏冰糖心苹果5斤','/static/product/6009.jpg','{\"规格\":\"5斤装\",\"果径\":\"80-85mm\"}',36.90,36.90,36.90,1,36.90,36.90,'NORMAL'),
(94,54,6002,8002,'三只松鼠虎皮风爪袋装','/static/product/6002.jpg','{\"规格\":\"袋装\",\"净重\":\"200g\"}',26.00,26.00,26.00,1,26.00,26.00,'NORMAL'),
(95,54,6004,8004,'旺旺雪饼520g','/static/product/6004.jpg','{\"规格\":\"520g\",\"包装\":\"家庭装\"}',22.90,22.90,22.90,1,22.90,22.90,'NORMAL'),
(96,55,6011,8011,'阳光金果奇异果12粒礼盒','/static/product/6011.jpg','{\"规格\":\"12粒礼盒装\",\"单果\":\"90-110g\"}',118.00,118.00,118.00,1,118.00,118.00,'COUPON'),
(97,56,6006,8006,'良品铺子蛋黄酥6枚','/static/product/6006.jpg','{\"规格\":\"6枚装\",\"净重\":\"330g\"}',35.00,35.00,35.00,1,35.00,35.00,'NORMAL'),
(98,56,6008,8008,'良品铺子雪花酥300g','/static/product/6008.jpg','{\"规格\":\"300g\",\"口味\":\"蔓越莓味\"}',27.90,27.90,27.90,1,27.90,27.90,'NORMAL'),
(99,57,6013,8013,'金龙鱼稻花香大米5kg','/static/product/6013.jpg','{\"规格\":\"5kg\",\"产地\":\"五常\"}',68.00,68.00,68.00,1,68.00,68.00,'NORMAL'),
(100,57,6015,8015,'涪陵清爽榨菜80g*20袋','/static/product/6015.jpg','{\"规格\":\"80g*20袋\",\"口味\":\"清爽\"}',16.90,16.90,16.90,1,16.90,16.90,'NORMAL'),
(101,58,6001,8001,'三只松鼠每日坚果30包礼盒','/static/product/6001.jpg','{\"规格\":\"30包装\",\"净重\":\"600g-750g\"}',77.00,77.00,77.00,1,77.00,77.00,'NORMAL'),
(102,58,6003,8003,'良品铺子芒果干500g','/static/product/6003.jpg','{\"规格\":\"500g\",\"口味\":\"原味\"}',35.90,35.90,35.90,1,35.90,35.90,'COUPON'),
(103,59,6017,8017,'有友泡椒凤爪210g','/static/product/6017.jpg','{\"规格\":\"210g\",\"口味\":\"泡椒味\"}',18.90,18.90,18.90,2,37.80,37.80,'NORMAL'),
(104,60,6021,8021,'元气森林白桃气泡水480ml*15瓶','/static/product/6021.jpg','{\"规格\":\"480ml*15瓶\",\"口味\":\"白桃味\"}',65.00,65.00,65.00,1,65.00,65.00,'NORMAL'),
(105,61,6007,8007,'良品铺子手工黑芝麻软糕400g','/static/product/6007.jpg','{\"规格\":\"400g\",\"口味\":\"黑芝麻味\"}',24.90,24.90,24.90,1,24.90,24.90,'NORMAL'),
(106,62,6010,8010,'奉节脐橙8斤','/static/product/6010.jpg','{\"规格\":\"8斤装\",\"果径\":\"75-80mm\"}',49.90,49.90,49.90,1,49.90,49.90,'NORMAL'),
(107,63,6014,8014,'海天金标生抽1.9L','/static/product/6014.jpg','{\"规格\":\"1.9L\",\"类型\":\"生抽\"}',22.90,22.90,22.90,1,22.90,22.90,'NORMAL'),
(108,63,6016,8016,'农家红薯宽粉1000g','/static/product/6016.jpg','{\"规格\":\"1000g\",\"类型\":\"红薯粉\"}',22.00,22.00,22.00,1,22.00,22.00,'NORMAL'),
(109,64,6018,8018,'绝味香辣鸭脖200g','/static/product/6018.jpg','{\"规格\":\"200g\",\"口味\":\"香辣味\"}',24.90,24.90,24.90,1,24.90,24.90,'NORMAL'),
(110,65,6001,8001,'三只松鼠每日坚果30包礼盒','/static/product/6001.jpg','{\"规格\":\"30包装\",\"净重\":\"600g-750g\"}',77.00,77.00,77.00,1,77.00,77.00,'COUPON'),
(111,66,6023,8023,'元气森林酸奶200g*12盒','/static/product/6023.jpg','{\"规格\":\"200g*12盒\",\"口味\":\"原味\"}',42.90,42.90,42.90,1,42.90,42.90,'NORMAL'),
(112,66,6024,8024,'农夫山泉鲜榨芒果复合果汁1L','/static/product/6024.jpg','{\"规格\":\"1L\",\"口味\":\"芒果味\"}',22.90,22.90,22.90,1,22.90,22.90,'NORMAL'),
(113,67,6005,8005,'卫龙大面筋68g*10包','/static/product/6005.jpg','{\"规格\":\"68g*10包\",\"口味\":\"香辣味\"}',19.90,19.90,19.90,2,39.80,39.80,'NORMAL'),
(114,67,6007,8007,'良品铺子手工黑芝麻软糕400g','/static/product/6007.jpg','{\"规格\":\"400g\",\"口味\":\"黑芝麻味\"}',24.90,24.90,24.90,1,24.90,24.90,'NORMAL'),
(115,68,6013,8013,'金龙鱼稻花香大米5kg','/static/product/6013.jpg','{\"规格\":\"5kg\",\"产地\":\"五常\"}',68.00,68.00,68.00,1,68.00,68.00,'NORMAL'),
(116,68,6015,8015,'涪陵清爽榨菜80g*20袋','/static/product/6015.jpg','{\"规格\":\"80g*20袋\",\"口味\":\"清爽\"}',16.90,16.90,16.90,2,33.80,33.80,'NORMAL'),
(117,69,6013,8013,'金龙鱼稻花香大米5kg','/static/product/6013.jpg','{\"规格\":\"5kg\",\"产地\":\"五常\"}',68.00,68.00,68.00,1,68.00,68.00,'NORMAL'),
(118,70,6005,8005,'卫龙大面筋68g*10包','/static/product/6005.jpg','{\"规格\":\"68g*10包\",\"口味\":\"香辣味\"}',19.90,19.90,19.90,1,19.90,19.90,'NORMAL'),
(119,70,6006,8006,'良品铺子蛋黄酥6枚','/static/product/6006.jpg','{\"规格\":\"6枚装\",\"净重\":\"330g\"}',35.00,35.00,35.00,1,35.00,35.00,'NORMAL'),
(120,70,6008,8008,'良品铺子雪花酥300g','/static/product/6008.jpg','{\"规格\":\"300g\",\"口味\":\"蔓越莓味\"}',27.90,27.90,27.90,1,27.90,27.90,'NORMAL'),
(121,71,6003,8003,'良品铺子芒果干500g','/static/product/6003.jpg','{\"规格\":\"500g\",\"口味\":\"原味\"}',35.90,35.90,35.90,1,35.90,35.90,'NORMAL'),
(122,71,6004,8004,'旺旺雪饼520g','/static/product/6004.jpg','{\"规格\":\"520g\",\"包装\":\"家庭装\"}',22.90,22.90,22.90,1,22.90,22.90,'NORMAL'),
(123,72,6012,8012,'沃隆每日坚果750g30袋','/static/product/6012.jpg','{\"规格\":\"750g 30袋\",\"品种\":\"混合坚果\"}',85.00,85.00,85.00,1,85.00,85.00,'NORMAL'),
(124,73,6019,8019,'绝味原切牛肉脯150g','/static/product/6019.jpg','{\"规格\":\"150g\",\"口味\":\"原味\"}',29.90,29.90,29.90,1,29.90,29.90,'NORMAL'),
(125,74,6022,8022,'农夫山泉100%鲜榨橙汁900ml','/static/product/6022.jpg','{\"规格\":\"900ml\",\"类型\":\"NFC鲜榨\"}',19.90,19.90,19.90,2,39.80,39.80,'NORMAL'),
(126,75,6002,8002,'三只松鼠虎皮风爪袋装','/static/product/6002.jpg','{\"规格\":\"袋装\",\"净重\":\"200g\"}',26.00,26.00,26.00,2,52.00,52.00,'NORMAL'),
(127,75,6004,8004,'旺旺雪饼520g','/static/product/6004.jpg','{\"规格\":\"520g\",\"包装\":\"家庭装\"}',22.90,22.90,22.90,1,22.90,22.90,'COUPON'),
(128,76,6014,8014,'海天金标生抽1.9L','/static/product/6014.jpg','{\"规格\":\"1.9L\",\"类型\":\"生抽\"}',22.90,22.90,22.90,1,22.90,22.90,'NORMAL'),
(129,76,6015,8015,'涪陵清爽榨菜80g*20袋','/static/product/6015.jpg','{\"规格\":\"80g*20袋\",\"口味\":\"清爽\"}',16.90,16.90,16.90,1,16.90,16.90,'NORMAL'),
(130,77,6010,8010,'奉节脐橙8斤','/static/product/6010.jpg','{\"规格\":\"8斤装\",\"果径\":\"75-80mm\"}',49.90,49.90,49.90,1,49.90,49.90,'NORMAL'),
(131,78,6020,8020,'有友现卤五香鹌鹑蛋300g','/static/product/6020.jpg','{\"规格\":\"300g\",\"口味\":\"五香味\"}',16.90,16.90,16.90,2,33.80,33.80,'NORMAL'),
(132,79,6017,8017,'有友泡椒凤爪210g','/static/product/6017.jpg','{\"规格\":\"210g\",\"口味\":\"泡椒味\"}',18.90,18.90,18.90,1,18.90,18.90,'NORMAL'),
(133,79,6020,8020,'有友现卤五香鹌鹑蛋300g','/static/product/6020.jpg','{\"规格\":\"300g\",\"口味\":\"五香味\"}',16.90,16.90,16.90,1,16.90,16.90,'NORMAL'),
(134,80,6005,8005,'卫龙大面筋68g*10包','/static/product/6005.jpg','{\"规格\":\"68g*10包\",\"口味\":\"香辣味\"}',19.90,19.90,19.90,3,59.70,59.70,'NORMAL'),
(135,81,6003,8003,'良品铺子芒果干500g','/static/product/6003.jpg','{\"规格\":\"500g\",\"口味\":\"原味\"}',35.90,35.90,35.90,2,71.80,71.80,'COUPON'),
(136,82,6021,8021,'元气森林白桃气泡水480ml*15瓶','/static/product/6021.jpg','{\"规格\":\"480ml*15瓶\",\"口味\":\"白桃味\"}',65.00,65.00,65.00,1,65.00,65.00,'NORMAL'),
(137,82,6022,8022,'农夫山泉100%鲜榨橙汁900ml','/static/product/6022.jpg','{\"规格\":\"900ml\",\"类型\":\"NFC鲜榨\"}',19.90,19.90,19.90,1,19.90,19.90,'NORMAL'),
(138,83,6016,8016,'农家红薯宽粉1000g','/static/product/6016.jpg','{\"规格\":\"1000g\",\"类型\":\"红薯粉\"}',22.00,22.00,22.00,2,44.00,44.00,'NORMAL'),
(139,84,6008,8008,'良品铺子雪花酥300g','/static/product/6008.jpg','{\"规格\":\"300g\",\"口味\":\"蔓越莓味\"}',27.90,27.90,27.90,2,55.80,55.80,'NORMAL'),
(140,85,6018,8018,'绝味香辣鸭脖200g','/static/product/6018.jpg','{\"规格\":\"200g\",\"口味\":\"香辣味\"}',24.90,24.90,24.90,1,24.90,24.90,'NORMAL'),
(141,85,6019,8019,'绝味原切牛肉脯150g','/static/product/6019.jpg','{\"规格\":\"150g\",\"口味\":\"原味\"}',29.90,29.90,29.90,1,29.90,29.90,'COUPON'),
(142,86,6011,8011,'阳光金果奇异果12粒礼盒','/static/product/6011.jpg','{\"规格\":\"12粒礼盒装\",\"单果\":\"90-110g\"}',118.00,118.00,118.00,1,118.00,118.00,'COUPON'),
(143,87,6013,8013,'金龙鱼稻花香大米5kg','/static/product/6013.jpg','{\"规格\":\"5kg\",\"产地\":\"五常\"}',68.00,68.00,68.00,1,68.00,68.00,'NORMAL'),
(144,88,6007,8007,'良品铺子手工黑芝麻软糕400g','/static/product/6007.jpg','{\"规格\":\"400g\",\"口味\":\"黑芝麻味\"}',24.90,24.90,24.90,2,49.80,49.80,'NORMAL'),
(145,89,6001,8001,'三只松鼠每日坚果30包礼盒','/static/product/6001.jpg','{\"规格\":\"30包装\",\"净重\":\"600g-750g\"}',77.00,77.00,77.00,1,77.00,77.00,'NORMAL'),
(146,89,6002,8002,'三只松鼠虎皮风爪袋装','/static/product/6002.jpg','{\"规格\":\"袋装\",\"净重\":\"200g\"}',26.00,26.00,26.00,1,26.00,26.00,'NORMAL'),
(147,90,6023,8023,'元气森林酸奶200g*12盒','/static/product/6023.jpg','{\"规格\":\"200g*12盒\",\"口味\":\"原味\"}',42.90,42.90,42.90,1,42.90,42.90,'NORMAL'),
(148,91,6017,8017,'有友泡椒凤爪210g','/static/product/6017.jpg','{\"规格\":\"210g\",\"口味\":\"泡椒味\"}',18.90,18.90,18.90,3,56.70,56.70,'NORMAL'),
(149,92,6009,8009,'阿克苏冰糖心苹果5斤','/static/product/6009.jpg','{\"规格\":\"5斤装\",\"果径\":\"80-85mm\"}',36.90,36.90,36.90,1,36.90,36.90,'NORMAL'),
(150,92,6012,8012,'沃隆每日坚果750g30袋','/static/product/6012.jpg','{\"规格\":\"750g 30袋\",\"品种\":\"混合坚果\"}',85.00,85.00,85.00,1,85.00,85.00,'SECKILL'),
(151,93,6024,8024,'农夫山泉鲜榨芒果复合果汁1L','/static/product/6024.jpg','{\"规格\":\"1L\",\"口味\":\"芒果味\"}',22.90,22.90,22.90,3,68.70,68.70,'NORMAL'),
(152,94,6013,8013,'金龙鱼稻花香大米5kg','/static/product/6013.jpg','{\"规格\":\"5kg\",\"产地\":\"五常\"}',68.00,68.00,68.00,1,68.00,68.00,'NORMAL'),
(153,94,6016,8016,'农家红薯宽粉1000g','/static/product/6016.jpg','{\"规格\":\"1000g\",\"类型\":\"红薯粉\"}',22.00,22.00,22.00,1,22.00,22.00,'NORMAL'),
(154,95,6004,8004,'旺旺雪饼520g','/static/product/6004.jpg','{\"规格\":\"520g\",\"包装\":\"家庭装\"}',22.90,22.90,22.90,2,45.80,45.80,'NORMAL'),
(155,96,6006,8006,'良品铺子蛋黄酥6枚','/static/product/6006.jpg','{\"规格\":\"6枚装\",\"净重\":\"330g\"}',35.00,35.00,35.00,1,35.00,35.00,'NORMAL'),
(156,96,6007,8007,'良品铺子手工黑芝麻软糕400g','/static/product/6007.jpg','{\"规格\":\"400g\",\"口味\":\"黑芝麻味\"}',24.90,24.90,24.90,1,24.90,24.90,'NORMAL'),
(157,97,6018,8018,'绝味香辣鸭脖200g','/static/product/6018.jpg','{\"规格\":\"200g\",\"口味\":\"香辣味\"}',24.90,24.90,24.90,2,49.80,49.80,'NORMAL'),
(158,97,6020,8020,'有友现卤五香鹌鹑蛋300g','/static/product/6020.jpg','{\"规格\":\"300g\",\"口味\":\"五香味\"}',16.90,16.90,16.90,1,16.90,16.90,'NORMAL');

-- ============================================================
-- 22. payment
-- ============================================================
DROP TABLE IF EXISTS `payment`;
CREATE TABLE `payment` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '支付ID（主键）',
  `order_id` bigint DEFAULT NULL COMMENT '订单ID',
  `pay_sn` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '支付流水号',
  `pay_platform` tinyint DEFAULT NULL COMMENT '支付通道',
  `amount` decimal(10,2) DEFAULT NULL COMMENT '实际支付金额',
  `status` tinyint DEFAULT NULL COMMENT '支付状态',
  `pay_time` datetime DEFAULT NULL COMMENT '支付成功时间',
  `refund_status` tinyint DEFAULT '0' COMMENT '退款状态',
  `refund_amount` decimal(10,2) DEFAULT '0.00' COMMENT '退款金额',
  `refund_time` datetime DEFAULT NULL COMMENT '退款时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `fk_payment_order` (`order_id`) USING BTREE,
  CONSTRAINT `fk_payment_order` FOREIGN KEY (`order_id`) REFERENCES `order` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=85 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='支付记录表';

INSERT INTO `payment` VALUES
(41,51,'PAY202605051031250001',1,82.00,1,'2026-05-05 10:31:25',0,0.00,NULL),
(42,52,'PAY202605061422300001',2,44.80,1,'2026-05-06 14:22:30',0,0.00,NULL),
(43,53,'PAY202605070916400001',1,36.90,1,'2026-05-07 09:16:40',0,0.00,NULL),
(44,54,'PAY202605081646100001',2,48.90,1,'2026-05-08 16:46:10',0,0.00,NULL),
(45,55,'PAY202605091131500001',1,118.00,1,'2026-05-09 11:31:50',0,0.00,NULL),
(46,56,'PAY202605100852150001',2,62.90,1,'2026-05-10 08:52:15',0,0.00,NULL),
(47,57,'PAY202605121311300001',1,89.90,1,'2026-05-12 13:11:30',0,0.00,NULL),
(48,58,'PAY202605141027050001',1,107.90,1,'2026-05-14 10:27:05',0,0.00,NULL),
(49,59,'PAY202605170941200001',2,42.80,1,'2026-05-17 09:41:20',0,0.00,NULL),
(50,60,'PAY202605181521450001',1,70.00,1,'2026-05-18 15:21:45',0,0.00,NULL),
(51,61,'PAY202605201106300001',2,24.90,1,'2026-05-20 11:06:30',0,0.00,NULL),
(52,62,'PAY202605211431500001',1,54.90,1,'2026-05-21 14:31:50',0,0.00,NULL),
(53,63,'PAY202605221716300001',2,49.90,1,'2026-05-22 17:16:30',1,49.90,'2026-05-22 17:40:00'),
(54,64,'PAY202605241001400001',1,29.90,1,'2026-05-24 10:01:40',0,0.00,NULL),
(55,65,'PAY202605251651300001',1,72.00,1,'2026-05-25 16:51:30',0,0.00,NULL),
(56,66,'PAY202605270931250001',2,70.80,1,'2026-05-27 09:31:25',0,0.00,NULL),
(57,67,'PAY202605291346100001',1,69.70,1,'2026-05-29 13:46:10',0,0.00,NULL),
(58,68,'PAY202605301122000001',2,106.80,1,'2026-05-30 11:22:00',0,0.00,NULL),
(59,69,'PAY202606011031300001',1,73.00,1,'2026-06-01 10:31:30',0,0.00,NULL),
(60,70,'PAY202606031401200001',2,82.80,1,'2026-06-03 14:01:20',0,0.00,NULL),
(61,71,'PAY202606050916100001',1,63.80,1,'2026-06-05 09:16:10',0,0.00,NULL),
(62,72,'PAY202606071632000001',1,85.00,1,'2026-06-07 16:32:00',0,0.00,NULL),
(63,73,'PAY202606091146400001',2,34.90,1,'2026-06-09 11:46:40',0,0.00,NULL),
(64,74,'PAY202606100852000001',1,44.80,1,'2026-06-10 08:52:00',1,44.80,'2026-06-10 09:10:00'),
(65,75,'PAY202606121511300001',2,64.90,1,'2026-06-12 15:11:30',0,0.00,NULL),
(66,76,'PAY202606131026300001',1,44.80,1,'2026-06-13 10:26:30',0,0.00,NULL),
(67,77,'PAY202606141431500001',2,49.90,1,'2026-06-14 14:31:50',0,0.00,NULL),
(68,78,'PAY202606151621300001',1,38.80,1,'2026-06-15 16:21:30',0,0.00,NULL),
(69,79,'PAY202606150952000001',2,40.80,1,'2026-06-15 09:52:00',0,0.00,NULL),
(70,80,'PAY202606171131200001',1,64.70,1,'2026-06-17 11:31:20',0,0.00,NULL),
(71,81,'PAY202606181601400001',1,66.80,1,'2026-06-18 16:01:40',0,0.00,NULL),
(72,82,'PAY202606201017000001',2,89.90,1,'2026-06-20 10:17:00',0,0.00,NULL),
(73,83,'PAY202606211446300001',1,49.00,1,'2026-06-21 14:46:30',0,0.00,NULL),
(74,84,'PAY202606221001500001',2,55.80,1,'2026-06-22 10:01:50',0,0.00,NULL),
(75,85,'PAY202606230931400001',1,54.80,1,'2026-06-23 09:31:40',0,0.00,NULL),
(76,86,'PAY202606241721300001',1,113.00,1,'2026-06-24 17:21:30',0,0.00,NULL),
(77,87,'PAY202606261102000001',2,73.00,1,'2026-06-26 11:02:00',1,73.00,'2026-06-26 11:20:00'),
(78,88,'PAY202606271531200001',2,49.80,1,'2026-06-27 15:31:20',0,0.00,NULL),
(79,89,'PAY202606291006300001',1,108.00,1,'2026-06-29 10:06:30',0,0.00,NULL),
(80,90,'PAY202606301341200001',1,47.90,1,'2026-06-30 13:41:20',0,0.00,NULL),
(81,91,'PAY202607010922000001',2,61.70,1,'2026-07-01 09:22:00',0,0.00,NULL),
(82,92,'PAY202607021116300001',1,121.90,1,'2026-07-02 11:16:30',0,0.00,NULL),
(83,94,'PAY202607031002000001',2,95.00,1,'2026-07-03 10:02:00',0,0.00,NULL),
(84,96,'PAY202607040931500001',1,64.90,1,'2026-07-04 09:31:50',0,0.00,NULL);

-- ============================================================
-- 23. delivery
-- ============================================================
DROP TABLE IF EXISTS `delivery`;
CREATE TABLE `delivery` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '配送单ID（主键）',
  `order_id` bigint DEFAULT NULL COMMENT '订单ID',
  `delivery_sn` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '物流运单号',
  `dispatcher_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '配送员/骑手姓名',
  `dispatcher_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '配送员电话',
  `status` tinyint DEFAULT NULL COMMENT '配送状态',
  `start_time` datetime DEFAULT NULL COMMENT '出发时间',
  `end_time` datetime DEFAULT NULL COMMENT '送达时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `fk_delivery_order` (`order_id`) USING BTREE,
  CONSTRAINT `fk_delivery_order` FOREIGN KEY (`order_id`) REFERENCES `order` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=45 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='配送单表';

INSERT INTO `delivery` VALUES
(21,51,'DL202605051035000001','张骑手','13911112201',4,'2026-05-05 10:38:00','2026-05-05 11:18:00'),
(22,52,'DL202605061428000001','李骑手','13911112202',4,'2026-05-06 14:32:00','2026-05-06 14:52:00'),
(23,55,'DL202605091138000001','王骑手','13911112203',4,'2026-05-09 11:42:00','2026-05-09 12:08:00'),
(24,57,'DL202605121320000001','赵骑手','13911112204',4,'2026-05-12 13:24:00','2026-05-12 13:48:00'),
(25,58,'DL202605141033000001','刘骑手','13911112205',4,'2026-05-14 10:36:00','2026-05-14 10:58:00'),
(26,59,'DL202605170948000001','陈骑手','13911112206',4,'2026-05-17 09:52:00','2026-05-17 10:18:00'),
(27,60,'DL202605181530000001','张骑手','13911112201',4,'2026-05-18 15:34:00','2026-05-18 16:03:00'),
(28,62,'DL202605211440000001','李骑手','13911112202',4,'2026-05-21 14:44:00','2026-05-21 15:13:00'),
(29,64,'DL202605241010000001','王骑手','13911112203',4,'2026-05-24 10:15:00','2026-05-24 10:43:00'),
(30,66,'DL202605270938000001','赵骑手','13911112204',3,'2026-05-27 09:55:00',NULL),
(31,67,'DL202605291354000001','刘骑手','13911112205',4,'2026-05-29 13:56:00','2026-05-29 14:28:00'),
(32,68,'DL202605301130000001','陈骑手','13911112206',4,'2026-05-30 11:34:00','2026-05-30 12:03:00'),
(33,69,'DL202606011038000001','张骑手','13911112201',4,'2026-06-01 10:42:00','2026-06-01 11:08:00'),
(34,71,'DL202606050922000001','李骑手','13911112202',4,'2026-06-05 09:26:00','2026-06-05 09:53:00'),
(35,73,'DL202606091155000001','王骑手','13911112203',4,'2026-06-09 11:59:00','2026-06-09 12:28:00'),
(36,76,'DL202606131038000001','赵骑手','13911112204',3,'2026-06-13 11:02:00',NULL),
(37,78,'DL202606151630000001','刘骑手','13911112205',4,'2026-06-15 16:32:00','2026-06-15 16:58:00'),
(38,79,'DL202606151002000001','陈骑手','13911112206',4,'2026-06-15 10:04:00','2026-06-15 10:33:00'),
(39,80,'DL202606171140000001','张骑手','13911112201',4,'2026-06-17 11:44:00','2026-06-17 12:13:00'),
(40,82,'DL202606201025000001','李骑手','13911112202',4,'2026-06-20 10:28:00','2026-06-20 10:53:00'),
(41,83,'DL202606211455000001','王骑手','13911112203',4,'2026-06-21 14:59:00','2026-06-21 15:28:00'),
(42,85,'DL202606230940000001','赵骑手','13911112204',4,'2026-06-23 09:44:00','2026-06-23 10:13:00'),
(43,89,'DL202606291015000001','刘骑手','13911112205',4,'2026-06-29 10:19:00','2026-06-29 10:48:00'),
(44,90,'DL202606301350000001','陈骑手','13911112206',3,'2026-06-30 14:06:00',NULL);

-- ============================================================
-- 24. after_sale
-- ============================================================
DROP TABLE IF EXISTS `after_sale`;
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

INSERT INTO `after_sale` VALUES
(1,51,91,'202605051030010001',2,77.00,77.00,'商品与描述不符','','三只松鼠每日坚果30包礼盒','{\"规格\":\"30包装\",\"净重\":\"600g-750g\"}',4,'已审核通过，退款成功','2026-05-07 14:00:00',1,'2026-05-09 10:00:00','2026-05-10 09:00:00','退款已到账，处理满意','','2026-05-07 10:00:00'),
(2,65,110,'202605251650020015',1,77.00,NULL,'不想要了','','三只松鼠每日坚果30包礼盒','{\"规格\":\"30包装\",\"净重\":\"600g-750g\"}',1,NULL,NULL,NULL,NULL,NULL,NULL,'','2026-07-03 16:00:00'),
(3,72,123,'202606071630020022',2,85.00,NULL,'尺码不合适','','沃隆每日坚果750g30袋','{\"规格\":\"750g 30袋\",\"品种\":\"混合坚果\"}',2,'同意退货，请寄回商品','2026-06-10 10:00:00',NULL,NULL,NULL,NULL,'','2026-06-10 09:00:00'),
(4,58,102,'202605141025010008',1,35.90,NULL,'买错了','','良品铺子芒果干500g','{\"规格\":\"500g\",\"口味\":\"原味\"}',5,'抱歉，已超过售后时效','2026-05-16 09:00:00',NULL,NULL,NULL,'售后被拒，理由不合理','','2026-05-16 08:00:00'),
(5,80,134,'202606171130010030',2,59.70,NULL,'收到商品破损','','卫龙大面筋68g*10包','{\"规格\":\"68g*10包\",\"口味\":\"香辣味\"}',3,'同意退货，请尽快寄回','2026-06-20 14:00:00',0,'2026-06-21 16:00:00',NULL,NULL,'','2026-06-20 10:00:00'),
(6,89,146,'202606291005010039',1,26.00,26.00,'效果不好','','三只松鼠虎皮风爪袋装','{\"规格\":\"袋装\",\"净重\":\"200g\"}',4,'已审核通过，退款成功','2026-07-01 15:00:00',NULL,NULL,'2026-07-02 09:00:00','处理速度很快','','2026-07-01 10:00:00'),
(7,52,92,'202605061420010002',2,39.80,39.80,'七天无理由退货','','卫龙大面筋68g*10包','{\"规格\":\"68g*10包\",\"口味\":\"香辣味\"}',4,'已审核通过，退款成功','2026-05-08 16:00:00',1,'2026-05-10 09:00:00','2026-05-11 10:00:00','收到退款','','2026-05-08 10:00:00'),
(8,60,104,'202605181520010010',1,65.00,NULL,'不想要了','','元气森林白桃气泡水480ml*15瓶','{\"规格\":\"480ml*15瓶\",\"口味\":\"白桃味\"}',5,'订单已完成超7天，不支持退款','2026-05-26 10:00:00',NULL,NULL,NULL,NULL,'','2026-05-26 08:00:00');

-- ============================================================
-- 25. coupon
-- ============================================================
DROP TABLE IF EXISTS `coupon`;
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
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='优惠券主表';

INSERT INTO `coupon` VALUES
(1,'新人大礼包 满50减10',1,50.00,10.00,500,180,1,0,0,'2026-05-01 00:00:00','2026-07-31 23:59:59',1,'2026-05-01 00:00:00',NULL),
(2,'5月狂欢 满100减20',1,100.00,20.00,300,95,1,100,0,'2026-05-05 00:00:00','2026-05-31 23:59:59',1,'2026-05-01 00:00:00',NULL),
(3,'端午特惠 满80减15',1,80.00,15.00,200,130,2,0,0,'2026-05-25 00:00:00','2026-06-10 23:59:59',1,'2026-05-20 00:00:00',NULL),
(4,'618年中大促 满150减30',1,150.00,30.00,400,210,2,200,1,'2026-06-12 00:00:00','2026-06-22 23:59:59',1,'2026-06-10 00:00:00',NULL),
(5,'夏日清凉季 满60减12',1,60.00,12.00,300,160,2,50,0,'2026-06-20 00:00:00','2026-07-20 23:59:59',1,'2026-06-18 00:00:00',NULL),
(6,'银卡专项 满40减8',1,40.00,8.00,200,75,3,0,2,'2026-07-01 00:00:00','2026-07-31 23:59:59',1,'2026-07-01 00:00:00',NULL);

-- ============================================================
-- 26. coupon_user
-- ============================================================
DROP TABLE IF EXISTS `coupon_user`;
CREATE TABLE `coupon_user` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '领用记录ID（主键）',
  `coupon_id` bigint DEFAULT NULL COMMENT '优惠券模版ID',
  `user_id` bigint DEFAULT NULL COMMENT '持有用户ID',
  `order_id` bigint DEFAULT NULL COMMENT '核销抵扣订单ID',
  `status` tinyint DEFAULT NULL COMMENT '状态（0未使用 1已使用 2已过期）',
  `receive_time` datetime DEFAULT NULL COMMENT '领取时间',
  `use_time` datetime DEFAULT NULL COMMENT '使用核销时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `fk_coupon_template` (`coupon_id`) USING BTREE,
  KEY `fk_coupon_user` (`user_id`) USING BTREE,
  KEY `fk_coupon_order` (`order_id`) USING BTREE,
  CONSTRAINT `fk_coupon_order` FOREIGN KEY (`order_id`) REFERENCES `order` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_coupon_template` FOREIGN KEY (`coupon_id`) REFERENCES `coupon` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_coupon_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=114 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='优惠券领用记录表';

INSERT INTO `coupon_user` VALUES
(51,1,1007,53,1,'2026-05-03 10:00:00','2026-05-07 09:22:00'),
(52,1,1008,54,1,'2026-05-04 09:30:00','2026-05-08 16:52:00'),
(53,1,1009,66,1,'2026-05-02 14:00:00','2026-05-27 09:35:00'),
(54,1,1010,57,1,'2026-05-03 11:00:00','2026-05-12 13:20:00'),
(55,1,1011,59,1,'2026-05-05 08:30:00','2026-05-17 09:48:00'),
(56,1,1012,60,1,'2026-05-03 15:00:00','2026-05-18 15:30:00'),
(57,1,1013,NULL,0,'2026-05-04 10:30:00',NULL),
(58,1,1014,65,1,'2026-05-05 16:00:00','2026-05-25 16:58:00'),
(59,1,1015,NULL,0,'2026-05-02 09:00:00',NULL),
(60,1,1016,NULL,0,'2026-05-05 14:30:00',NULL),
(61,1,1017,NULL,0,'2026-05-03 08:00:00',NULL),
(62,1,1018,NULL,0,'2026-05-06 11:00:00',NULL),
(63,1,1019,NULL,0,'2026-05-04 16:30:00',NULL),
(64,1,1020,88,1,'2026-05-03 13:00:00','2026-06-27 15:38:00'),
(65,1,1021,NULL,0,'2026-05-02 10:00:00',NULL),
(66,1,1022,NULL,0,'2026-05-03 09:30:00',NULL),
(67,1,1023,NULL,0,'2026-05-05 11:30:00',NULL),
(68,1,1024,NULL,0,'2026-05-04 14:00:00',NULL),
(69,1,1025,NULL,0,'2026-05-06 08:30:00',NULL),
(70,2,1007,64,1,'2026-05-06 10:00:00','2026-05-24 10:10:00'),
(71,2,1008,63,1,'2026-05-07 09:00:00','2026-05-22 17:22:00'),
(72,2,1009,56,1,'2026-05-08 14:00:00','2026-05-10 08:58:00'),
(73,2,1010,NULL,0,'2026-05-06 15:00:00',NULL),
(74,2,1011,NULL,0,'2026-05-07 11:00:00',NULL),
(75,2,1012,NULL,0,'2026-05-08 08:30:00',NULL),
(76,2,1013,NULL,0,'2026-05-09 10:00:00',NULL),
(77,2,1014,65,1,'2026-05-10 14:30:00','2026-05-25 16:58:00'),
(78,2,1015,68,1,'2026-05-08 16:00:00','2026-05-30 11:30:00'),
(79,2,1016,NULL,0,'2026-05-09 09:00:00',NULL),
(80,3,1007,70,1,'2026-05-26 10:00:00','2026-06-03 14:08:00'),
(81,3,1008,73,1,'2026-05-27 09:00:00','2026-06-09 11:55:00'),
(82,3,1009,66,1,'2026-05-26 08:00:00','2026-05-27 09:35:00'),
(83,3,1010,71,1,'2026-05-28 11:00:00','2026-06-05 09:22:00'),
(84,3,1011,72,1,'2026-05-29 14:00:00','2026-06-07 16:40:00'),
(85,3,1012,NULL,0,'2026-05-30 09:00:00',NULL),
(86,3,1013,NULL,0,'2026-05-26 15:00:00',NULL),
(87,3,1014,NULL,0,'2026-05-27 10:00:00',NULL),
(88,4,1007,NULL,0,'2026-06-13 10:00:00',NULL),
(89,4,1008,NULL,0,'2026-06-14 09:00:00',NULL),
(90,4,1009,77,1,'2026-06-13 08:00:00','2026-06-14 14:38:00'),
(91,4,1010,82,1,'2026-06-14 11:00:00','2026-06-20 10:25:00'),
(92,4,1011,NULL,0,'2026-06-15 14:00:00',NULL),
(93,4,1012,81,1,'2026-06-13 15:00:00','2026-06-18 16:08:00'),
(94,4,1013,83,1,'2026-06-14 10:00:00','2026-06-21 14:55:00'),
(95,4,1014,NULL,0,'2026-06-15 09:00:00',NULL),
(96,4,1015,NULL,0,'2026-06-13 16:00:00',NULL),
(97,4,1016,NULL,0,'2026-06-16 08:30:00',NULL),
(98,4,1017,76,1,'2026-06-13 08:30:00','2026-06-13 10:32:00'),
(99,4,1018,79,1,'2026-06-14 14:00:00','2026-06-15 10:00:00'),
(100,5,1009,91,1,'2026-06-28 10:00:00','2026-07-01 09:28:00'),
(101,5,1010,84,1,'2026-06-22 08:00:00','2026-06-22 10:08:00'),
(102,5,1011,90,1,'2026-06-25 14:00:00','2026-06-30 13:48:00'),
(103,5,1012,NULL,0,'2026-06-23 09:00:00',NULL),
(104,5,1013,83,1,'2026-06-21 08:30:00','2026-06-21 14:55:00'),
(105,5,1014,NULL,0,'2026-06-24 10:00:00',NULL),
(106,5,1015,NULL,0,'2026-06-25 15:00:00',NULL),
(107,5,1016,NULL,0,'2026-06-22 11:00:00',NULL),
(108,6,1001,NULL,0,'2026-07-01 09:00:00',NULL),
(109,6,1002,NULL,0,'2026-07-01 10:00:00',NULL),
(110,6,1003,NULL,0,'2026-07-01 11:00:00',NULL),
(111,6,1004,NULL,0,'2026-07-02 08:30:00',NULL),
(112,6,1005,NULL,0,'2026-07-02 09:30:00',NULL),
(113,6,1006,NULL,0,'2026-07-02 14:00:00',NULL);

-- ============================================================
-- 27. seckill_activity
-- ============================================================
DROP TABLE IF EXISTS `seckill_activity`;
CREATE TABLE `seckill_activity` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '活动ID（主键）',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '活动名称',
  `start_time` datetime DEFAULT NULL COMMENT '开始时间',
  `end_time` datetime DEFAULT NULL COMMENT '结束时间',
  `status` tinyint DEFAULT NULL COMMENT '活动状态',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='秒杀活动表';

INSERT INTO `seckill_activity` VALUES
(1,'5月生鲜秒杀节','2026-05-15 10:00:00','2026-05-17 23:59:59',1),
(2,'618超级秒杀','2026-06-16 10:00:00','2026-06-19 23:59:59',1),
(3,'7月清凉秒杀','2026-07-04 10:00:00','2026-07-06 23:59:59',1);

-- ============================================================
-- 28. seckill_product
-- ============================================================
DROP TABLE IF EXISTS `seckill_product`;
CREATE TABLE `seckill_product` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '秒杀关联ID（主键）',
  `seckill_activity_id` bigint DEFAULT NULL COMMENT '秒杀活动ID',
  `product_id` bigint DEFAULT NULL COMMENT '商品SpuID',
  `sku_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '商品SKU编码',
  `seckill_price` decimal(10,2) DEFAULT NULL COMMENT '秒杀专享价',
  `seckill_stock` int DEFAULT NULL COMMENT '秒杀专享库存',
  `sold_count` int DEFAULT '0' COMMENT '已售数量',
  `limit_quantity` tinyint DEFAULT NULL COMMENT '每人限购数量',
  `status` tinyint DEFAULT NULL COMMENT '状态（1启用）',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `fk_seckill_act` (`seckill_activity_id`) USING BTREE,
  KEY `fk_seckill_product` (`product_id`) USING BTREE,
  CONSTRAINT `fk_seckill_act` FOREIGN KEY (`seckill_activity_id`) REFERENCES `seckill_activity` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_seckill_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='秒杀商品表';

INSERT INTO `seckill_product` VALUES
(1,1,6009,'AKS-APPLE-10J-85',29.90,50,48,3,1),
(2,1,6010,'FJ-ORANGE-8J-75',39.90,40,35,3,1),
(3,1,6012,'WL-NUT-30B-750',69.00,30,25,3,1),
(4,1,6016,'HS-FOOD-1B-1000',16.90,40,20,3,1),
(5,2,6001,'AKS-NUT-30B-750',59.00,60,55,3,1),
(6,2,6008,'BWW-SNOW-1B-300',19.90,30,28,3,1),
(7,2,6017,'YY-CHICK-1B-210',13.90,80,75,3,1),
(8,2,6021,'YQSL-DRINK-15B-7200',49.00,40,32,3,1),
(9,2,6014,'HT-SAUCE-1T-1900',17.90,50,22,3,1),
(10,3,6018,'JW-DUCK-1H-200',18.90,50,10,3,1),
(11,3,6022,'NFSQ-JUICE-1B-900',14.90,60,8,3,1),
(12,3,6024,'XC-MANGOJUICE-1B-1000',16.90,50,5,3,1),
(13,3,6003,'BWW-MANGO-1B-500',28.90,40,3,3,1);

-- ============================================================
-- 29. bargain_activity
-- ============================================================
DROP TABLE IF EXISTS `bargain_activity`;
CREATE TABLE `bargain_activity` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '砍价活动ID（主键）',
  `user_id` bigint DEFAULT NULL COMMENT '发起用户ID',
  `product_id` bigint DEFAULT NULL COMMENT '商品SpuID',
  `sku_id` bigint DEFAULT NULL COMMENT '商品SkuID',
  `target_price` decimal(10,2) DEFAULT NULL COMMENT '砍价目标底价',
  `current_price` decimal(10,2) DEFAULT NULL COMMENT '当前砍后金额',
  `end_time` datetime DEFAULT NULL COMMENT '结束时限',
  `status` tinyint DEFAULT NULL COMMENT '砍价状态',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `fk_bargain_user` (`user_id`) USING BTREE,
  KEY `fk_bargain_product` (`product_id`) USING BTREE,
  KEY `fk_bargain_sku` (`sku_id`) USING BTREE,
  CONSTRAINT `fk_bargain_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_bargain_sku` FOREIGN KEY (`sku_id`) REFERENCES `sku` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_bargain_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='砍价活动表';

-- ============================================================
-- 30. points_log
-- ============================================================
DROP TABLE IF EXISTS `points_log`;
CREATE TABLE `points_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志ID（主键）',
  `user_id` bigint DEFAULT NULL COMMENT '用户ID',
  `type` tinyint DEFAULT NULL COMMENT '变更动作类型',
  `change_points` int DEFAULT NULL COMMENT '变动积分值',
  `current_points` int DEFAULT NULL COMMENT '变动后余额',
  `remark` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '事务场景备注',
  `create_time` datetime DEFAULT NULL COMMENT '记录生成时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `fk_points_log_user` (`user_id`) USING BTREE,
  CONSTRAINT `fk_points_log_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='积分变更日志表';

INSERT INTO `points_log` VALUES
(1,1007,2,10,10,'每日签到','2026-05-05 08:00:00'),
(2,1008,2,15,15,'每日签到','2026-05-05 08:10:00'),
(3,1009,2,8,8,'每日签到','2026-05-05 08:30:00'),
(4,1010,2,12,12,'每日签到','2026-05-06 09:00:00'),
(5,1007,1,36,46,'购物获得-订单202605070915020003','2026-05-07 17:00:00'),
(6,1007,2,5,51,'每日签到','2026-05-08 07:30:00'),
(7,1008,1,48,63,'购物获得-订单202605081645010004','2026-05-09 11:00:00'),
(8,1008,2,18,81,'每日签到','2026-05-09 08:00:00'),
(9,1009,1,62,70,'购物获得-订单202605100850020006','2026-05-10 18:00:00'),
(10,1009,2,7,77,'每日签到','2026-05-10 07:45:00'),
(11,1010,2,20,20,'每日签到','2026-05-11 08:30:00'),
(12,1010,1,89,109,'购物获得-订单202605121310010007','2026-05-13 08:00:00'),
(13,1011,2,13,13,'每日签到','2026-05-14 08:00:00'),
(14,1012,2,6,6,'每日签到','2026-05-15 08:15:00'),
(15,1011,1,42,55,'购物获得-订单202605170940010009','2026-05-18 08:30:00'),
(16,1012,1,70,76,'购物获得-订单202605181520010010','2026-05-19 10:00:00'),
(17,1013,2,9,9,'每日签到','2026-05-19 08:00:00'),
(18,1007,2,11,62,'每日签到','2026-05-20 08:00:00'),
(19,1008,3,-50,31,'兑换优惠券消耗','2026-05-20 12:00:00'),
(20,1013,1,54,63,'购物获得-订单202605211430010012','2026-05-22 09:00:00'),
(21,1014,2,16,16,'每日签到','2026-05-22 08:30:00'),
(22,1009,3,-80,-3,'兑换优惠券消耗','2026-05-23 10:00:00'),
(23,1007,1,29,91,'购物获得-订单202605241000010014','2026-05-25 08:30:00'),
(24,1014,1,72,88,'购物获得-订单202605251650020015','2026-05-26 09:00:00'),
(25,1010,2,14,123,'每日签到','2026-05-26 08:00:00'),
(26,1007,2,8,99,'每日签到','2026-05-27 08:15:00'),
(27,1015,2,17,17,'每日签到','2026-05-28 08:00:00'),
(28,1011,3,-30,25,'兑换优惠券消耗','2026-05-28 15:00:00'),
(29,1008,2,5,36,'每日签到','2026-05-30 09:00:00'),
(30,1015,1,106,123,'购物获得-订单202605301120010018','2026-05-31 09:00:00'),
(31,1009,2,12,9,'每日签到','2026-06-01 08:00:00'),
(32,1017,2,18,18,'每日签到','2026-06-02 08:30:00'),
(33,1007,1,82,181,'购物获得-订单202606031400020020','2026-06-04 10:00:00'),
(34,1010,1,63,186,'购物获得-订单202606050915010021','2026-06-06 08:30:00'),
(35,1011,1,85,110,'购物获得-订单202606071630020022','2026-06-08 09:00:00'),
(36,1008,1,34,70,'购物获得-订单202606091145010023','2026-06-10 08:00:00'),
(37,1009,2,15,24,'每日签到','2026-06-10 08:00:00'),
(38,1007,4,77,258,'退款退回-售后订单1','2026-06-10 12:00:00'),
(39,1010,2,11,197,'每日签到','2026-06-11 08:00:00'),
(40,1009,1,49,73,'购物获得-订单202606141430020027','2026-06-14 18:00:00'),
(41,1009,1,38,111,'购物获得-订单202606151620010028','2026-06-16 08:30:00'),
(42,1018,1,40,40,'购物获得-订单202606150950010029','2026-06-16 09:00:00'),
(43,1018,2,10,50,'每日签到','2026-06-17 08:00:00'),
(44,1012,1,66,142,'购物获得-订单202606181600020031','2026-06-19 09:00:00'),
(45,1010,1,89,286,'购物获得-订单202606201015010032','2026-06-21 08:30:00'),
(46,1013,1,49,112,'购物获得-订单202606211445010033','2026-06-22 09:00:00'),
(47,1010,1,55,341,'购物获得-订单202606221000020034','2026-06-23 08:00:00'),
(48,1007,1,54,312,'购物获得-订单202606230930010035','2026-06-24 09:00:00'),
(49,1019,1,113,113,'购物获得-订单202606241720020036','2026-06-25 09:30:00'),
(50,1010,3,-100,241,'兑换优惠券消耗','2026-06-26 10:00:00'),
(51,1007,2,7,319,'每日签到','2026-06-27 08:00:00'),
(52,1020,1,49,49,'购物获得-订单202606271530020038','2026-06-28 09:00:00'),
(53,1008,1,108,178,'购物获得-订单202606291005010039','2026-06-30 08:30:00'),
(54,1008,4,77,255,'退款退回-售后订单2','2026-07-02 09:00:00'),
(55,1020,2,19,68,'每日签到','2026-07-02 08:00:00'),
(56,1007,3,-50,269,'兑换优惠券消耗','2026-07-03 14:00:00'),
(57,1019,2,13,126,'每日签到','2026-07-03 08:00:00'),
(58,1015,2,8,131,'每日签到','2026-07-04 08:00:00'),
(59,1009,2,14,125,'每日签到','2026-07-04 08:30:00'),
(60,1013,2,6,118,'每日签到','2026-07-05 08:00:00');

-- ============================================================
-- 31. growth_log
-- ============================================================
DROP TABLE IF EXISTS `growth_log`;
CREATE TABLE `growth_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志ID（主键）',
  `user_id` bigint DEFAULT NULL COMMENT '用户ID',
  `type` tinyint DEFAULT NULL COMMENT '来源渠道类型',
  `change_growth` int DEFAULT NULL COMMENT '变更成长值数额',
  `current_growth` int DEFAULT NULL COMMENT '最新累计总成长值',
  `remark` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '行为场景备注',
  `create_time` datetime DEFAULT NULL COMMENT '变动记录时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `fk_growth_log_user` (`user_id`) USING BTREE,
  CONSTRAINT `fk_growth_log_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='成长值变更日志表';

INSERT INTO `growth_log` VALUES
(1,1007,2,3,3,'每日签到','2026-05-05 08:00:00'),
(2,1008,2,2,2,'每日签到','2026-05-05 08:10:00'),
(3,1009,2,5,5,'每日签到','2026-05-06 08:00:00'),
(4,1010,2,1,1,'每日签到','2026-05-06 09:00:00'),
(5,1007,1,36,39,'消费获得-订单202605070915020003','2026-05-07 17:00:00'),
(6,1008,1,48,50,'消费获得-订单202605081645010004','2026-05-09 11:00:00'),
(7,1009,1,62,67,'消费获得-订单202605100850020006','2026-05-10 18:00:00'),
(8,1010,2,4,5,'每日签到','2026-05-11 08:00:00'),
(9,1010,1,89,94,'消费获得-订单202605121310010007','2026-05-13 08:00:00'),
(10,1011,2,3,3,'每日签到','2026-05-14 08:00:00'),
(11,1007,2,2,41,'每日签到','2026-05-16 08:00:00'),
(12,1011,1,42,45,'消费获得-订单202605170940010009','2026-05-18 08:30:00'),
(13,1012,1,70,70,'消费获得-订单202605181520010010','2026-05-19 10:00:00'),
(14,1013,2,1,1,'每日签到','2026-05-19 08:30:00'),
(15,1013,1,54,55,'消费获得-订单202605211430010012','2026-05-22 09:00:00'),
(16,1009,2,3,70,'每日签到','2026-05-23 08:00:00'),
(17,1007,1,29,70,'消费获得-订单202605241000010014','2026-05-25 08:30:00'),
(18,1014,1,72,72,'消费获得-订单202605251650020015','2026-05-26 09:00:00'),
(19,1015,2,2,2,'每日签到','2026-05-28 09:00:00'),
(20,1015,1,106,108,'消费获得-订单202605301120010018','2026-05-31 09:00:00'),
(21,1010,2,5,99,'每日签到','2026-06-01 08:00:00'),
(22,1007,1,82,152,'消费获得-订单202606031400020020','2026-06-04 10:00:00'),
(23,1010,1,63,162,'消费获得-订单202606050915010021','2026-06-06 08:30:00'),
(24,1011,1,85,130,'消费获得-订单202606071630020022','2026-06-08 09:00:00'),
(25,1008,1,34,84,'消费获得-订单202606091145010023','2026-06-10 08:00:00'),
(26,1009,1,49,119,'消费获得-订单202606141430020027','2026-06-14 18:00:00'),
(27,1009,1,38,157,'消费获得-订单202606151620010028','2026-06-16 08:30:00'),
(28,1018,1,40,40,'消费获得-订单202606150950010029','2026-06-16 09:00:00'),
(29,1012,1,66,136,'消费获得-订单202606181600020031','2026-06-19 09:00:00'),
(30,1010,1,89,251,'消费获得-订单202606201015010032','2026-06-21 08:30:00'),
(31,1007,3,10,162,'评价获得','2026-06-21 10:00:00'),
(32,1013,1,49,104,'消费获得-订单202606211445010033','2026-06-22 09:00:00'),
(33,1010,1,55,306,'消费获得-订单202606221000020034','2026-06-23 08:00:00'),
(34,1007,1,54,216,'消费获得-订单202606230930010035','2026-06-24 09:00:00'),
(35,1019,1,113,113,'消费获得-订单202606241720020036','2026-06-25 09:30:00'),
(36,1007,2,4,220,'每日签到','2026-06-27 08:00:00'),
(37,1020,1,49,49,'消费获得-订单202606271530020038','2026-06-28 09:00:00'),
(38,1008,1,108,192,'消费获得-订单202606291005010039','2026-06-30 08:30:00'),
(39,1010,3,10,316,'评价获得','2026-07-01 14:00:00'),
(40,1007,2,3,223,'每日签到','2026-07-03 08:00:00');

-- ============================================================
-- 32. poster
-- ============================================================
DROP TABLE IF EXISTS `poster`;
CREATE TABLE `poster` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '海报ID（主键）',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '海报主题模板名称',
  `bg_image` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '背景原图素材URL',
  `qr_code_config` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '二维码动态图层配置参数',
  `status` tinyint DEFAULT NULL COMMENT '使用状态',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='裂变海报配置表';

INSERT INTO `poster` VALUES
(1,'618年中大促海报','/static/poster/poster_01.jpg','{\"width\":200,\"height\":200,\"x\":150,\"y\":400}',1),
(2,'新用户邀请海报','/static/poster/poster_02.jpg','{\"width\":180,\"height\":180,\"x\":160,\"y\":380}',1),
(3,'每日特价海报','/static/poster/poster_03.jpg','{\"width\":220,\"height\":220,\"x\":140,\"y\":420}',0);

-- ============================================================
-- 33. share_log
-- ============================================================
DROP TABLE IF EXISTS `share_log`;
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

INSERT INTO `share_log` VALUES
(1,1004,1,201,'wechat','2026-05-10 08:30:00'),
(2,1007,1,301,'timeline','2026-05-12 10:15:00'),
(3,1008,2,1,'wechat','2026-05-15 14:20:00'),
(4,1009,1,401,'qq','2026-05-18 09:45:00'),
(5,1010,2,2,'wechat','2026-05-22 16:30:00'),
(6,1011,1,101,'timeline','2026-06-01 11:00:00'),
(7,1012,2,1,'qq','2026-06-05 07:50:00'),
(8,1013,1,501,'wechat','2026-06-10 13:25:00'),
(9,1014,1,601,'timeline','2026-06-15 18:40:00'),
(10,1004,1,102,'wechat','2026-06-20 10:10:00'),
(11,1015,2,3,'qq','2026-06-22 15:55:00'),
(12,1016,1,701,'wechat','2026-06-25 09:20:00'),
(13,1017,1,801,'timeline','2026-06-28 12:35:00'),
(14,1018,2,2,'wechat','2026-07-01 08:15:00'),
(15,1019,1,901,'qq','2026-07-03 10:50:00');

-- ============================================================
-- 34. commission_log
-- ============================================================
DROP TABLE IF EXISTS `commission_log`;
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

INSERT INTO `commission_log` VALUES
(1,1,54,48.90,4.89,1,'2026-05-15 10:00:00'),
(2,1,89,103.00,10.30,1,'2026-07-01 10:00:00'),
(3,2,57,84.90,8.49,1,'2026-05-20 10:00:00'),
(4,2,82,84.90,8.49,0,NULL),
(5,1,73,29.90,2.99,0,NULL),
(6,2,71,58.80,5.88,0,NULL);

-- ============================================================
-- 35. product_comment
-- ============================================================
DROP TABLE IF EXISTS `product_comment`;
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

-- ============================================================
-- 36. message_template
-- ============================================================
DROP TABLE IF EXISTS `message_template`;
CREATE TABLE `message_template` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '模板ID（主键）',
  `template_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '模板编码',
  `template_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '模板名称',
  `message_type` tinyint DEFAULT NULL COMMENT '消息类型（1站内信、2短信、3邮件）',
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '消息标题',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '消息模板内容',
  `status` tinyint DEFAULT NULL COMMENT '启用状态',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='消息通知模板表';

-- ============================================================
-- 37. operation_admin
-- ============================================================
DROP TABLE IF EXISTS `operation_admin`;
CREATE TABLE `operation_admin` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '运营管理员ID（主键）',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '登录账号',
  `password` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '登录密码（加密）',
  `real_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '真实姓名',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '联系电话',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '邮箱',
  `role` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '运营角色',
  `status` tinyint DEFAULT NULL COMMENT '账号状态',
  `last_login_time` datetime DEFAULT NULL COMMENT '最后登录时间',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='运营管理员信息表';

INSERT INTO `operation_admin` VALUES
(1,'operator01','56ed087f4411c193dbbb1421745bae12','运营张三','13900001001','zhangsan@example.com','商品运营',1,'2026-07-03 09:00:00','2026-01-01 00:00:00'),
(2,'operator02','56ed087f4411c193dbbb1421745bae12','运营李四','13900001002','lisi@example.com','内容运营',1,'2026-07-03 10:00:00','2026-02-01 00:00:00'),
(3,'operator03','56ed087f4411c193dbbb1421745bae12','运营王五','13900001003','wangwu@example.com','活动运营',1,'2026-07-02 14:00:00','2026-03-01 00:00:00'),
(4,'operator04','56ed087f4411c193dbbb1421745bae12','运营小美','13900001004','xiaomei@example.com','用户运营',1,'2026-07-03 08:30:00','2026-04-01 00:00:00');

-- ============================================================
-- 38. system_admin
-- ============================================================
DROP TABLE IF EXISTS `system_admin`;
CREATE TABLE `system_admin` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '系统管理员ID（主键）',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '登录账号',
  `password` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '登录密码（加密）',
  `real_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '管理员姓名',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '联系电话',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '邮箱',
  `role` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '系统角色',
  `status` tinyint DEFAULT NULL COMMENT '账号状态',
  `last_login_time` datetime DEFAULT NULL COMMENT '最后登录时间',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='系统管理员信息表';

INSERT INTO `system_admin` VALUES
(1,'superadmin','56ed087f4411c193dbbb1421745bae12','超级管理员','13800000000','admin@socialretail.com','SUPER_ADMIN',1,'2026-07-03 08:00:00','2026-01-01 00:00:00'),
(2,'sysadmin01','56ed087f4411c193dbbb1421745bae12','系统管理员A','13800000001','sysadmin01@socialretail.com','ADMIN',1,'2026-07-02 09:00:00','2026-03-01 00:00:00');

-- ============================================================
-- 39. system_config
-- ============================================================
DROP TABLE IF EXISTS `system_config`;
CREATE TABLE `system_config` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '参数ID（主键）',
  `config_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '参数键（唯一）',
  `config_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '参数名称',
  `config_value` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '参数值',
  `value_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '参数类型',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '参数说明',
  `is_system` tinyint DEFAULT NULL COMMENT '是否系统内置（0否，1是）',
  `status` tinyint DEFAULT NULL COMMENT '参数状态（0禁用，1启用）',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='系统参数配置表';

INSERT INTO `system_config` VALUES
(1,'site_name','站点名称','SOCIAL零售','STRING','系统站点名称',1,1,'2026-01-01 00:00:00','2026-01-01 00:00:00'),
(2,'site_logo','站点Logo','/static/system/logo.png','IMAGE','站点Logo图片URL',1,1,'2026-01-01 00:00:00','2026-01-01 00:00:00'),
(3,'delivery_fee','配送费','5.00','DECIMAL','默认配送费金额（元）',1,1,'2026-01-01 00:00:00','2026-01-01 00:00:00'),
(4,'free_delivery_threshold','免运费门槛','99.00','DECIMAL','满多少金额免运费',1,1,'2026-01-01 00:00:00','2026-01-01 00:00:00'),
(5,'points_exchange_rate','积分兑换比例','100','INTEGER','100积分=1元',1,1,'2026-01-01 00:00:00','2026-01-01 00:00:00'),
(6,'max_refund_days','最大退款天数','7','INTEGER','订单完成后多久可申请退款',1,1,'2026-01-01 00:00:00','2026-01-01 00:00:00'),
(7,'auto_confirm_days','自动确认收货天数','15','INTEGER','发货后多少天自动确认收货',1,1,'2026-01-01 00:00:00','2026-01-01 00:00:00'),
(8,'seckill_refresh_interval','秒杀库存刷新间隔','5','INTEGER','秒杀活动前台库存刷新间隔（秒）',0,1,'2026-05-01 00:00:00','2026-05-10 00:00:00');

-- ============================================================
-- 40. recommendation_log
-- ============================================================
DROP TABLE IF EXISTS `recommendation_log`;
CREATE TABLE `recommendation_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '推荐流水ID（主键）',
  `user_id` bigint DEFAULT NULL COMMENT '推荐目标触达用户ID',
  `scene` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '算法展示前台场景栏位',
  `recommended_product_ids` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '下发推荐Spu集快照串',
  `feedback_type` tinyint DEFAULT NULL COMMENT '实际漏斗闭环反馈效果',
  `log_time` datetime DEFAULT NULL COMMENT '推荐曝光展示时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `fk_recomm_user` (`user_id`) USING BTREE,
  CONSTRAINT `fk_recomm_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='个性化算法推荐结果记录表';

-- ============================================================
-- 41. withdrawal_apply
-- ============================================================
DROP TABLE IF EXISTS `withdrawal_apply`;
CREATE TABLE `withdrawal_apply` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '提现申请ID（主键）',
  `wallet_id` bigint DEFAULT NULL COMMENT '钱包ID',
  `user_id` bigint DEFAULT NULL COMMENT '提现用户ID',
  `apply_amount` decimal(10,2) DEFAULT NULL COMMENT '提现金额',
  `account_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '收款人姓名',
  `account_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '收款账号',
  `bank_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '开户银行',
  `audit_status` tinyint DEFAULT NULL COMMENT '审核状态',
  `audit_time` datetime DEFAULT NULL COMMENT '审核时间',
  `remark` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '审核备注',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `fk_withdrawal_wallet` (`wallet_id`) USING BTREE,
  KEY `fk_withdrawal_user` (`user_id`) USING BTREE,
  CONSTRAINT `fk_withdrawal_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_withdrawal_wallet` FOREIGN KEY (`wallet_id`) REFERENCES `user_wallet` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='提现申请审批表';

SET FOREIGN_KEY_CHECKS = 1;