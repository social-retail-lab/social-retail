-- ==========================================
-- 新增字段变更脚本
-- ==========================================

USE `social_retail_db`;

-- 1. merchant 商家表
ALTER TABLE `merchant`
    ADD COLUMN `business_hours` VARCHAR(50) DEFAULT NULL COMMENT '营业时间' AFTER `shop_address`;

ALTER TABLE `merchant`
    ADD COLUMN `introduction` VARCHAR(500) DEFAULT NULL COMMENT '店铺简介' AFTER `business_hours`;

ALTER TABLE `merchant`
    ADD COLUMN `create_time` DATETIME DEFAULT NULL COMMENT '创建时间' AFTER `introduction`;

-- 2. merchant_apply 入驻申请表
ALTER TABLE `merchant_apply`
    ADD COLUMN `license_number` VARCHAR(50) DEFAULT NULL COMMENT '营业执照注册号' AFTER `id_card_back`;

ALTER TABLE `merchant_apply`
    ADD COLUMN `license_image` VARCHAR(200) DEFAULT NULL COMMENT '营业执照图片URL' AFTER `license_number`;

ALTER TABLE `merchant_apply`
    ADD COLUMN `food_permit_number` VARCHAR(50) DEFAULT NULL COMMENT '食品经营许可证号' AFTER `license_image`;

ALTER TABLE `merchant_apply`
    ADD COLUMN `food_permit_image` VARCHAR(200) DEFAULT NULL COMMENT '食品许可证图片URL' AFTER `food_permit_number`;

ALTER TABLE `merchant_apply`
    ADD COLUMN `contact_name` VARCHAR(50) DEFAULT NULL COMMENT '联系人姓名' AFTER `food_permit_image`;

ALTER TABLE `merchant_apply`
    ADD COLUMN `contact_phone` VARCHAR(20) DEFAULT NULL COMMENT '联系电话' AFTER `contact_name`;

ALTER TABLE `merchant_apply`
    ADD COLUMN `shop_address` VARCHAR(200) DEFAULT NULL COMMENT '店铺地址' AFTER `contact_phone`;

ALTER TABLE `merchant_apply`
    ADD COLUMN `shop_name` VARCHAR(100) DEFAULT NULL COMMENT '店铺名称' AFTER `shop_address`;

ALTER TABLE `merchant_apply`
    ADD COLUMN `audit_time` DATETIME DEFAULT NULL COMMENT '审核时间' AFTER `audit_remark`;

-- 3. brand 品牌表
ALTER TABLE `brand`
    ADD COLUMN `create_time` DATETIME DEFAULT NULL COMMENT '创建时间' AFTER `description`;

-- 4. product 商品表
ALTER TABLE `product`
    ADD COLUMN `detail_images` TEXT DEFAULT NULL COMMENT '详情图片(JSON数组)' AFTER `detail_desc`;

ALTER TABLE `product`
    ADD COLUMN `audit_status` TINYINT DEFAULT NULL COMMENT '审核状态(0待审/1通过/2拒绝)' AFTER `status`;

ALTER TABLE `product`
    ADD COLUMN `audit_remark` VARCHAR(200) DEFAULT NULL COMMENT '审核备注' AFTER `audit_status`;

ALTER TABLE `product`
    ADD COLUMN `audit_time` DATETIME DEFAULT NULL COMMENT '审核时间' AFTER `audit_remark`;

ALTER TABLE `product`
    ADD COLUMN `create_time` DATETIME DEFAULT NULL COMMENT '创建时间' AFTER `audit_time`;

ALTER TABLE `product`
    ADD COLUMN `update_time` DATETIME DEFAULT NULL COMMENT '更新时间' AFTER `create_time`;

-- 5. pickup_point 自提点表
ALTER TABLE `pickup_point`
    ADD COLUMN `business_hours` VARCHAR(50) DEFAULT NULL COMMENT '营业时间' AFTER `contact_phone`;

-- 6. operation_admin 运营管理员表
ALTER TABLE `operation_admin`
    ADD COLUMN `role` VARCHAR(50) DEFAULT NULL COMMENT '角色' AFTER `email`;
    
ALTER TABLE `user_message`
ADD COLUMN `business_id` VARCHAR(64) DEFAULT NULL COMMENT '业务ID（订单/售后/审核等关联ID）' AFTER `template_id`;

CREATE TABLE IF NOT EXISTS `notice` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '公告ID（主键）',

  `title` VARCHAR(200) NOT NULL COMMENT '公告标题',
  `summary` VARCHAR(500) DEFAULT NULL COMMENT '公告摘要',

  `content` TEXT NOT NULL COMMENT '公告内容',

  `target_type` VARCHAR(20) DEFAULT 'ALL' COMMENT '接收范围（USER=用户端，MERCHANT=商家端，ALL=全平台）',

  `status` TINYINT DEFAULT 1 COMMENT '状态（0草稿，1已发布，2已下线）',

  `publish_time` DATETIME DEFAULT NULL COMMENT '发布时间',
  `expire_time` DATETIME DEFAULT NULL COMMENT '过期时间',

  `is_top` TINYINT DEFAULT 0 COMMENT '是否置顶（0否 1是）',

  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',

  PRIMARY KEY (`id`),

  KEY `idx_target_type` (`target_type`),
  KEY `idx_publish_time` (`publish_time`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统公告表';