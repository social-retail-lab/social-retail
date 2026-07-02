-- 用户端售后模块增量迁移；先执行 0701 after_sale 扩展脚本。
ALTER TABLE `after_sale`
    ADD COLUMN `audit_status` TINYINT NOT NULL DEFAULT 0
        COMMENT '审核状态：0待审核 1通过 2拒绝' AFTER `status`;

CREATE INDEX `idx_after_sale_user_list`
    ON `after_sale` (`order_id`, `status`, `apply_time`);

CREATE INDEX `idx_after_sale_item_active`
    ON `after_sale` (`order_item_id`, `status`, `is_deleted`);
