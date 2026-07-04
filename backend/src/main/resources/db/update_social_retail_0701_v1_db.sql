-- ==========================================
-- update_social_retail_0701_v1_db.sql
-- 自提点审核 + 图片存储目录规范化
-- ==========================================

-- ==========================================
-- 1. pickup_point 表增加审核字段
-- ==========================================
ALTER TABLE `pickup_point`
  ADD COLUMN `audit_status` TINYINT DEFAULT 1 COMMENT '审核状态 0-待审核 1-已通过 2-已驳回',
  ADD COLUMN `audit_remark` VARCHAR(500) DEFAULT NULL COMMENT '审核备注',
  ADD COLUMN `audit_time` DATETIME DEFAULT NULL COMMENT '审核时间',
  ADD COLUMN `image` VARCHAR(500) DEFAULT NULL COMMENT '门店图片URL',
  ADD COLUMN `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间';

-- 已有自提点默认为已通过
UPDATE `pickup_point` SET `audit_status` = 1 WHERE `audit_status` IS NULL;

-- ==========================================
-- 2. 图片存储目录规范说明（无需 DDL，仅供参考）
-- ==========================================
-- 图片保存目录结构（项目根目录/static/ 下）：
--   static/
--     ├── id_card/           -- 身份证正反面图片
--     ├── business_license/  -- 营业执照图片
--     ├── food_permit/       -- 食品许可证图片
--     ├── product/           -- 商品主图/详情图
--     ├── avatar/            -- 用户/商家头像
--     └── evidence/          -- 售后凭证图片
-- 每个子目录下按日期分文件夹：{folder}/{yyyyMMdd}/{uuid}.jpg
-- 数据库存储完整URL：http://{host}/static/{folder}/{yyyyMMdd}/{uuid}.jpg
