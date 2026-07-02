-- ==========================================
-- 数据库变更脚本 v3
-- 日期: 2026-06-29
-- 说明: 新增商家信息变更审核表、商家状态增加暂时歇业(5)
-- ==========================================

USE `social_retail_db`;

-- 1. 新增商家信息变更审核表
CREATE TABLE IF NOT EXISTS `merchant_info_change` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '变更ID',
    `merchant_id` BIGINT NOT NULL COMMENT '商家ID',
    `request_type` VARCHAR(30) NOT NULL COMMENT '请求类型: INFO_CHANGE-信息修改, QUALIFICATION_UPGRADE-升级企业资质',
    `old_data` TEXT DEFAULT NULL COMMENT '旧数据(JSON)',
    `new_data` TEXT DEFAULT NULL COMMENT '新数据(JSON)',
    `audit_status` TINYINT NOT NULL DEFAULT 0 COMMENT '审核状态: 0-待审核, 1-通过, 2-驳回',
    `audit_remark` VARCHAR(500) DEFAULT NULL COMMENT '审核备注/理由',
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `audit_time` DATETIME DEFAULT NULL COMMENT '审核时间',
    PRIMARY KEY (`id`),
    INDEX `idx_merchant_id` (`merchant_id`),
    INDEX `idx_audit_status` (`audit_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商家信息变更审核表';
