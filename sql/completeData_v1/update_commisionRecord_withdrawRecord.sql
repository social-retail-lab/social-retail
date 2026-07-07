CREATE TABLE commission_record (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
    distributor_id BIGINT NOT NULL COMMENT '分销员ID',
    distributor_product_id BIGINT NOT NULL COMMENT '推广商品ID',
    order_id BIGINT NOT NULL COMMENT '订单ID',
    commission_amount DECIMAL(10,2) NOT NULL COMMENT '佣金金额',
    status TINYINT NOT NULL DEFAULT 0 COMMENT '状态：0-待结算，1-已结算',
    settlement_time DATETIME DEFAULT NULL COMMENT '结算时间',
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',

    INDEX idx_distributor(distributor_id),
    INDEX idx_order(order_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='佣金记录';
drop table withdraw_record;

CREATE TABLE withdraw_record (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
    distributor_id BIGINT NOT NULL COMMENT '分销员ID',
    amount DECIMAL(10,2) NOT NULL COMMENT '提现金额',
    bank_name VARCHAR(100) NOT NULL COMMENT '开户银行',
    bank_card_no VARCHAR(50) NOT NULL COMMENT '银行卡号',
    account_name VARCHAR(50) NOT NULL COMMENT '开户人',
    status TINYINT NOT NULL DEFAULT 0 COMMENT '提现状态：0-处理中，1-提现成功，2-提现失败',
    apply_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '申请时间',

    INDEX idx_distributor(distributor_id),
    INDEX idx_status(status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='提现记录';
ALTER TABLE distributor
ADD COLUMN available_commission DECIMAL(10,2) NOT NULL DEFAULT 0.00 COMMENT '可提现佣金'
AFTER total_commission;