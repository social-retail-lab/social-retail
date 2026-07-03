-- ==========================================
-- update_social_retail_0704_v2_db.sql
-- 数据看板功能 - 无需新增表结构，所有统计基于已有数据表实时计算
-- 涉及的已有表：
--   order, order_item: 销售额、订单量、商品排行
--   product: 在售商品数
--   merchant_apply: 商家数、入驻趋势
--   user: 用户数
--   platform_revenue_detail: 平台佣金/补贴
--   category, product_category_relation: 类目占比
-- ==========================================
USE `social_retail_db`;

-- 本版本无需DDL变更，数据看板功能完全基于已有表实时统计
