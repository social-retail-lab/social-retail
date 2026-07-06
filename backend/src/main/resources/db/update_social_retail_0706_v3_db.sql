DROP TABLE IF EXISTS distributor_product;
DROP TABLE IF EXISTS distributor_apply;
ALTER TABLE `commission_log` DROP FOREIGN KEY `fk_comm_distributor`;
DROP TABLE IF EXISTS distributor;
CREATE TABLE distributor (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
    user_id BIGINT NOT NULL COMMENT '用户ID',
    apply_id BIGINT NOT NULL COMMENT '对应申请记录ID',
    total_commission DECIMAL(10,2) NOT NULL DEFAULT 0.00 COMMENT '累计佣金',
    frozen_commission DECIMAL(10,2) NOT NULL DEFAULT 0.00 COMMENT '冻结佣金',
    status TINYINT NOT NULL DEFAULT 1 COMMENT '状态：0-禁用，1-正常',
    apply_time DATETIME NOT NULL COMMENT '申请通过时间',
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',

    UNIQUE KEY uk_user_id (user_id),
    UNIQUE KEY uk_apply_id (apply_id),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='分销员表';
CREATE TABLE merchant_distribution_product (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
    merchant_id BIGINT NOT NULL COMMENT '商家ID',
    product_id BIGINT NOT NULL COMMENT '商品ID',
    commission_rate DECIMAL(5,2) NOT NULL COMMENT '佣金比例(%)',
    status TINYINT NOT NULL DEFAULT 1 COMMENT '状态：0-关闭分销，1-开启分销',
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',

    UNIQUE KEY uk_product (product_id),
    INDEX idx_merchant (merchant_id),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商家开放分销商品表';
CREATE TABLE distributor_apply (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
    user_id BIGINT NOT NULL COMMENT '申请用户ID',
    real_name VARCHAR(50) NOT NULL COMMENT '真实姓名',
    id_card_no VARCHAR(30) NOT NULL COMMENT '身份证号',
    id_card_front VARCHAR(255) NOT NULL COMMENT '身份证正面图片',
    id_card_back VARCHAR(255) NOT NULL COMMENT '身份证反面图片',
    bank_name VARCHAR(100) NOT NULL COMMENT '开户银行',
    bank_card_no VARCHAR(50) NOT NULL COMMENT '银行卡号',
    bank_account_name VARCHAR(50) NOT NULL COMMENT '开户人姓名',
    audit_status TINYINT NOT NULL DEFAULT 0 COMMENT '审核状态：0-待审核，1-审核通过，2-审核拒绝',
    audit_remark VARCHAR(255) DEFAULT NULL COMMENT '审核备注',
    audit_time DATETIME DEFAULT NULL COMMENT '审核时间',
    apply_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '申请时间',

    INDEX idx_user_id (user_id),
    INDEX idx_audit_status (audit_status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='分销员申请表';
CREATE TABLE distributor_product (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',

    distributor_id BIGINT NOT NULL COMMENT '分销员ID',

    distribution_product_id BIGINT NOT NULL COMMENT '商家开放分销商品ID',

    promotion_code VARCHAR(50) NOT NULL COMMENT '推广码',

    promotion_url VARCHAR(500) NOT NULL COMMENT '推广链接',

    qr_code VARCHAR(500) DEFAULT NULL COMMENT '二维码',

    status TINYINT NOT NULL DEFAULT 1 COMMENT '状态',

    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',

    UNIQUE KEY uk_promotion_code (promotion_code),
    UNIQUE KEY uk_distributor_product (distributor_id, distribution_product_id),

    INDEX idx_distributor(distributor_id),
    INDEX idx_distribution_product(distribution_product_id)

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='分销员推广商品';

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
CREATE TABLE withdraw_record (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
    distributor_id BIGINT NOT NULL COMMENT '分销员ID',
    amount DECIMAL(10,2) NOT NULL COMMENT '提现金额',
    bank_name VARCHAR(100) NOT NULL COMMENT '开户银行',
    bank_card_no VARCHAR(50) NOT NULL COMMENT '银行卡号',
    account_name VARCHAR(50) NOT NULL COMMENT '开户人',
    status TINYINT NOT NULL DEFAULT 0 COMMENT '状态：0-待审核，1-已打款，2-已拒绝',
    audit_remark VARCHAR(255) DEFAULT NULL COMMENT '审核备注',
    apply_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '申请时间',
    audit_time DATETIME DEFAULT NULL COMMENT '审核时间',

    INDEX idx_distributor(distributor_id),
    INDEX idx_status(status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='提现记录';
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