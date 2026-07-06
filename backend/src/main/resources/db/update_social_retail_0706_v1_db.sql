-- ==========================================
-- 商家银行卡绑定表
-- ==========================================
DROP TABLE IF EXISTS `merchant_bank_card`;
CREATE TABLE `merchant_bank_card` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `merchant_id` bigint NOT NULL COMMENT '商家ID',
  `bank_name` varchar(100) NOT NULL COMMENT '开户银行名称',
  `bank_card_number` varchar(30) NOT NULL COMMENT '银行卡号',
  `account_name` varchar(50) NOT NULL COMMENT '开户人姓名',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '绑定时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_merchant_id` (`merchant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商家银行卡绑定表';
