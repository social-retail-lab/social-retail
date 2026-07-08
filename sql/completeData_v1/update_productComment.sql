-- 1. 增加字段
ALTER TABLE `product_comment`
ADD COLUMN `order_id` BIGINT DEFAULT NULL COMMENT '订单ID' AFTER `id`,
ADD COLUMN `sku_id` BIGINT DEFAULT NULL COMMENT 'SKU ID' AFTER `product_id`,
ADD COLUMN `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态：0-隐藏，1-展示，2-用户删除，3-后台屏蔽' AFTER `anonymous`,
ADD COLUMN `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间' AFTER `create_time`,
ADD COLUMN `delete_time` DATETIME DEFAULT NULL COMMENT '删除时间' AFTER `update_time`;

-- 2. 根据 order_item 补充历史数据
UPDATE `product_comment` pc
LEFT JOIN `order_item` oi ON pc.order_item_id = oi.id
SET 
    pc.order_id = oi.order_id,
    pc.sku_id = oi.sku_id
WHERE pc.order_item_id IS NOT NULL;

-- 3. 增加索引
ALTER TABLE `product_comment`
ADD KEY `idx_product_comment_order_id` (`order_id`) USING BTREE,
ADD KEY `idx_product_comment_sku_id` (`sku_id`) USING BTREE,
ADD KEY `idx_product_comment_status` (`status`) USING BTREE,
ADD KEY `idx_product_comment_create_time` (`create_time`) USING BTREE;

-- 4. 防止重复评价
ALTER TABLE `product_comment`
ADD UNIQUE KEY `uk_order_item_user` (`order_item_id`, `user_id`);

-- 5. 可选：增加外键
ALTER TABLE `product_comment`
ADD CONSTRAINT `fk_product_comment_order`
FOREIGN KEY (`order_id`) REFERENCES `order` (`id`)
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `product_comment`
ADD CONSTRAINT `fk_product_comment_sku`
FOREIGN KEY (`sku_id`) REFERENCES `sku` (`id`)
ON DELETE CASCADE ON UPDATE CASCADE;