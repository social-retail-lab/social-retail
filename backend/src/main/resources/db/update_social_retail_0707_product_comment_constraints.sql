-- 防止并发请求对同一订单明细重复评价。
-- 部署前若存在重复历史数据，应先保留最早一条并清理其余记录。
SET @add_comment_unique_key = IF(
    EXISTS(
        SELECT 1
        FROM information_schema.statistics
        WHERE table_schema = DATABASE()
          AND table_name = 'product_comment'
          AND index_name = 'uk_order_item_user'
    ),
    'SELECT 1',
    'ALTER TABLE `product_comment` ADD UNIQUE KEY `uk_order_item_user` (`order_item_id`, `user_id`)'
);
PREPARE add_comment_unique_key_stmt FROM @add_comment_unique_key;
EXECUTE add_comment_unique_key_stmt;
DEALLOCATE PREPARE add_comment_unique_key_stmt;
