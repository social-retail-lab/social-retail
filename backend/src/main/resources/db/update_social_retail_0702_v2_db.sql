CREATE TABLE IF NOT EXISTS `file_record` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '文件ID',
    `owner_user_id` BIGINT NOT NULL COMMENT '上传用户ID',
    `upload_type` VARCHAR(30) NOT NULL COMMENT '上传业务类型',
    `business_id` BIGINT DEFAULT NULL COMMENT '关联业务ID',
    `original_name` VARCHAR(255) NOT NULL COMMENT '原文件名',
    `stored_path` VARCHAR(500) NOT NULL COMMENT 'uploads目录下的相对路径',
    `file_size` BIGINT NOT NULL COMMENT '文件大小（字节）',
    `content_type` VARCHAR(100) NOT NULL COMMENT '实际图片类型',
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `is_deleted` TINYINT NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_file_stored_path` (`stored_path`),
    KEY `idx_file_owner` (`owner_user_id`, `is_deleted`),
    KEY `idx_file_business` (`upload_type`, `business_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='本地上传文件元数据';

ALTER TABLE product
ADD COLUMN sold_count BIGINT NOT NULL DEFAULT 0
COMMENT '累计销量';