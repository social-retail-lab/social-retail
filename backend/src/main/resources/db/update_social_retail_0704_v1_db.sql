-- ==========================================
-- update_social_retail_0704_v1_db.sql
-- 新增消息通知表，支持侧栏小红点提示
-- ==========================================
USE `social_retail_db`;

CREATE TABLE IF NOT EXISTS `notification` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '通知ID',
  `user_id` BIGINT DEFAULT NULL COMMENT '目标用户ID（运营平台管理员）',
  `merchant_id` BIGINT DEFAULT NULL COMMENT '目标商家ID',
  `type` VARCHAR(50) NOT NULL COMMENT '通知类型: AUDIT_RESULT/ORDER_STATUS/AFTERSALE_STATUS等',
  `title` VARCHAR(200) DEFAULT NULL COMMENT '通知标题',
  `content` VARCHAR(500) DEFAULT NULL COMMENT '通知内容',
  `is_read` TINYINT NOT NULL DEFAULT 0 COMMENT '是否已读: 0未读 1已读',
  `related_id` BIGINT DEFAULT NULL COMMENT '关联业务ID',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_user_read` (`user_id`, `is_read`),
  KEY `idx_merchant_read` (`merchant_id`, `is_read`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='消息通知表';
