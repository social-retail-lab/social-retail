-- ==========================================
-- update_social_retail_0631_v1_db.sql
-- 商家订单处理、自提核销、配送管理、售后管理、收益提现
-- ==========================================

-- ==========================================
-- 1. 订单表扩充字段
-- ==========================================
ALTER TABLE `order`
  ADD COLUMN `discount_amount` DECIMAL(10,2) DEFAULT 0.00 COMMENT '优惠金额',
  ADD COLUMN `pickup_code` VARCHAR(10) DEFAULT NULL COMMENT '自提取货码(6位)',
  ADD COLUMN `remark` VARCHAR(500) DEFAULT NULL COMMENT '商家备注',
  ADD COLUMN `update_time` DATETIME DEFAULT NULL COMMENT '最后更新时间',
  ADD COLUMN `complete_time` DATETIME DEFAULT NULL COMMENT '完成时间',
  ADD COLUMN `accept_time` DATETIME DEFAULT NULL COMMENT '接单时间',
  ADD COLUMN `prepare_time` DATETIME DEFAULT NULL COMMENT '备货完成时间';

-- ==========================================
-- 2. 售后表扩充字段
-- ==========================================
ALTER TABLE `after_sale`
  ADD COLUMN `order_sn` VARCHAR(50) DEFAULT NULL COMMENT '关联订单编号冗余',
  ADD COLUMN `evidence_images` TEXT DEFAULT NULL COMMENT '证据图片JSON数组',
  ADD COLUMN `product_name` VARCHAR(200) DEFAULT NULL COMMENT '商品名称快照',
  ADD COLUMN `sku_specs` VARCHAR(200) DEFAULT NULL COMMENT '规格快照',
  ADD COLUMN `actual_refund_amount` DECIMAL(10,2) DEFAULT NULL COMMENT '实际退款金额',
  ADD COLUMN `audit_remark` VARCHAR(500) DEFAULT NULL COMMENT '商家审核备注',
  ADD COLUMN `audit_time` DATETIME DEFAULT NULL COMMENT '商家审核时间',
  ADD COLUMN `return_received_status` TINYINT DEFAULT NULL COMMENT '退货收货确认状态 1-确认收货 2-收货异常',
  ADD COLUMN `return_received_time` DATETIME DEFAULT NULL COMMENT '退货收货确认时间',
  ADD COLUMN `complete_time` DATETIME DEFAULT NULL COMMENT '售后完成时间',
  ADD COLUMN `feedback_content` TEXT DEFAULT NULL COMMENT '商家反馈内容',
  ADD COLUMN `feedback_images` TEXT DEFAULT NULL COMMENT '商家反馈图片';

-- ==========================================
-- 3. 支付表扩充字段
-- ==========================================
ALTER TABLE `payment`
  ADD COLUMN `refund_status` TINYINT DEFAULT 0 COMMENT '退款状态 0-未退款 1-已退款',
  ADD COLUMN `refund_amount` DECIMAL(10,2) DEFAULT NULL COMMENT '退款金额',
  ADD COLUMN `refund_time` DATETIME DEFAULT NULL COMMENT '退款时间';

-- ==========================================
-- 4. 配送表扩充字段
-- ==========================================
ALTER TABLE `delivery`
  ADD COLUMN `remark` VARCHAR(500) DEFAULT NULL COMMENT '配送备注',
  ADD COLUMN `simulate_complete_time` DATETIME DEFAULT NULL COMMENT '模拟配送完成时间(2分钟后)';

-- ==========================================
-- 5. 商家收益表
-- ==========================================
CREATE TABLE IF NOT EXISTS `merchant_earnings` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '收益ID',
  `merchant_id` BIGINT NOT NULL COMMENT '商家ID',
  `order_id` BIGINT DEFAULT NULL COMMENT '订单ID',
  `order_sn` VARCHAR(50) DEFAULT NULL COMMENT '订单编号',
  `amount` DECIMAL(10,2) NOT NULL COMMENT '收益金额',
  `status` TINYINT NOT NULL DEFAULT 0 COMMENT '状态 0-冻结中 1-可提现 2-已提现',
  `freeze_time` DATETIME DEFAULT NULL COMMENT '冻结时间(订单完成时间)',
  `unfreeze_time` DATETIME DEFAULT NULL COMMENT '解冻时间(冻结后4小时)',
  `withdraw_time` DATETIME DEFAULT NULL COMMENT '提现时间',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  INDEX `idx_merchant_id` (`merchant_id`),
  INDEX `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商家收益表';

-- ==========================================
-- 6. 提现申请表
-- ==========================================
CREATE TABLE IF NOT EXISTS `withdrawal_record` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '提现ID',
  `merchant_id` BIGINT NOT NULL COMMENT '商家ID',
  `amount` DECIMAL(10,2) NOT NULL COMMENT '提现金额',
  `bank_card_number` VARCHAR(50) NOT NULL COMMENT '银行卡号',
  `account_name` VARCHAR(50) NOT NULL COMMENT '开户人姓名',
  `bank_name` VARCHAR(100) DEFAULT NULL COMMENT '银行名称',
  `status` TINYINT NOT NULL DEFAULT 0 COMMENT '状态 0-处理中 1-已汇款 2-失败',
  `remark` VARCHAR(500) DEFAULT NULL COMMENT '处理备注',
  `apply_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '申请时间',
  `process_time` DATETIME DEFAULT NULL COMMENT '处理时间',
  PRIMARY KEY (`id`),
  INDEX `idx_merchant_id` (`merchant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='提现申请表';

-- ==========================================
-- 7. 订单状态流水表
-- ==========================================
CREATE TABLE IF NOT EXISTS `order_status_log` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '日志ID',
  `order_id` BIGINT NOT NULL COMMENT '订单ID',
  `from_status` TINYINT DEFAULT NULL COMMENT '变更前状态',
  `to_status` TINYINT NOT NULL COMMENT '变更后状态',
  `status_text` VARCHAR(50) DEFAULT NULL COMMENT '状态描述',
  `operator_type` VARCHAR(20) DEFAULT NULL COMMENT '操作者类型 merchant/user/system',
  `operator_id` BIGINT DEFAULT NULL COMMENT '操作者ID',
  `remark` VARCHAR(500) DEFAULT NULL COMMENT '备注',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  INDEX `idx_order_id` (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='订单状态流水表';

-- ==========================================
-- 8. 配送状态流水表
-- ==========================================
CREATE TABLE IF NOT EXISTS `delivery_status_log` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '日志ID',
  `delivery_id` BIGINT NOT NULL COMMENT '配送单ID',
  `from_status` TINYINT DEFAULT NULL COMMENT '变更前状态',
  `to_status` TINYINT NOT NULL COMMENT '变更后状态',
  `status_text` VARCHAR(50) DEFAULT NULL COMMENT '状态描述',
  `remark` VARCHAR(500) DEFAULT NULL COMMENT '备注',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  INDEX `idx_delivery_id` (`delivery_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='配送状态流水表';