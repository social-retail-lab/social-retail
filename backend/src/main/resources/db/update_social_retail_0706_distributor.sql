CREATE TABLE IF NOT EXISTS distributor_apply (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    real_name VARCHAR(50) NOT NULL,
    id_card_no VARCHAR(30) NOT NULL,
    id_card_front VARCHAR(255) NOT NULL,
    id_card_back VARCHAR(255) NOT NULL,
    bank_name VARCHAR(100) NOT NULL,
    bank_card_no VARCHAR(50) NOT NULL,
    bank_account_name VARCHAR(50) NOT NULL,
    audit_status TINYINT NOT NULL DEFAULT 0,
    audit_remark VARCHAR(255) DEFAULT NULL,
    audit_time DATETIME DEFAULT NULL,
    apply_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    pending_user_id BIGINT GENERATED ALWAYS AS
        (CASE WHEN audit_status = 0 THEN user_id ELSE NULL END) STORED,
    UNIQUE KEY uk_pending_user (pending_user_id),
    INDEX idx_user_id (user_id),
    INDEX idx_audit_status (audit_status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='分销员申请表';

CREATE TABLE IF NOT EXISTS distributor (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    apply_id BIGINT NOT NULL,
    total_commission DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    available_commission DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    frozen_commission DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    status TINYINT NOT NULL DEFAULT 1,
    apply_time DATETIME NOT NULL,
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uk_user_id (user_id), UNIQUE KEY uk_apply_id (apply_id), INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='分销员表';

CREATE TABLE IF NOT EXISTS merchant_distribution_product (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    merchant_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    commission_rate DECIMAL(5,2) NOT NULL,
    status TINYINT NOT NULL DEFAULT 1,
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uk_product (product_id), INDEX idx_merchant (merchant_id), INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商家开放分销商品表';

CREATE TABLE IF NOT EXISTS distributor_product (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    distributor_id BIGINT NOT NULL,
    distribution_product_id BIGINT NOT NULL,
    promotion_code VARCHAR(50) NOT NULL,
    promotion_url VARCHAR(500) NOT NULL,
    qr_code VARCHAR(500) DEFAULT NULL,
    status TINYINT NOT NULL DEFAULT 1,
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uk_promotion_code (promotion_code),
    UNIQUE KEY uk_distributor_product (distributor_id, distribution_product_id),
    INDEX idx_distributor (distributor_id), INDEX idx_distribution_product (distribution_product_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='分销员推广商品';

CREATE TABLE IF NOT EXISTS commission_record (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    distributor_id BIGINT NOT NULL,
    distributor_product_id BIGINT NOT NULL,
    order_id BIGINT NOT NULL,
    commission_amount DECIMAL(10,2) NOT NULL,
    status TINYINT NOT NULL DEFAULT 0,
    settlement_time DATETIME DEFAULT NULL,
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uk_order_promotion (order_id, distributor_product_id),
    INDEX idx_distributor (distributor_id), INDEX idx_order (order_id),
    INDEX idx_settle (status, create_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='佣金记录';

CREATE TABLE IF NOT EXISTS withdraw_record (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    distributor_id BIGINT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    bank_name VARCHAR(100) NOT NULL,
    bank_card_no VARCHAR(50) NOT NULL,
    account_name VARCHAR(50) NOT NULL,
    status TINYINT NOT NULL DEFAULT 0,
    apply_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_distributor (distributor_id), INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='提现记录';

-- Upgrade databases where the original tables from the interface draft already exist.
DELIMITER $$
DROP PROCEDURE IF EXISTS upgrade_distributor_schema$$
CREATE PROCEDURE upgrade_distributor_schema()
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema = DATABASE() AND table_name = 'distributor'
          AND column_name = 'available_commission'
    ) THEN
        ALTER TABLE distributor ADD COLUMN available_commission DECIMAL(10,2) NOT NULL DEFAULT 0.00
            AFTER total_commission;
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema = DATABASE() AND table_name = 'distributor_apply'
          AND column_name = 'pending_user_id'
    ) THEN
        ALTER TABLE distributor_apply ADD COLUMN pending_user_id BIGINT
            GENERATED ALWAYS AS (CASE WHEN audit_status = 0 THEN user_id ELSE NULL END) STORED;
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM information_schema.statistics
        WHERE table_schema = DATABASE() AND table_name = 'distributor_apply'
          AND index_name = 'uk_pending_user'
    ) THEN
        ALTER TABLE distributor_apply ADD UNIQUE KEY uk_pending_user (pending_user_id);
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM information_schema.statistics
        WHERE table_schema = DATABASE() AND table_name = 'commission_record'
          AND index_name = 'uk_order_promotion'
    ) THEN
        ALTER TABLE commission_record
            ADD UNIQUE KEY uk_order_promotion (order_id, distributor_product_id);
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema = DATABASE() AND table_name = 'cart'
          AND column_name = 'distributor_product_id'
    ) THEN
        ALTER TABLE cart ADD COLUMN distributor_product_id BIGINT NULL AFTER quantity;
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema = DATABASE() AND table_name = 'cart'
          AND column_name = 'attribution_expires_at'
    ) THEN
        ALTER TABLE cart ADD COLUMN attribution_expires_at DATETIME NULL
            AFTER distributor_product_id;
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM information_schema.statistics
        WHERE table_schema = DATABASE() AND table_name = 'cart'
          AND index_name = 'idx_cart_distribution'
    ) THEN
        ALTER TABLE cart ADD INDEX idx_cart_distribution
            (distributor_product_id, attribution_expires_at);
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema = DATABASE() AND table_name = 'order_item'
          AND column_name = 'distributor_product_id'
    ) THEN
        ALTER TABLE order_item ADD COLUMN distributor_product_id BIGINT NULL
            AFTER promotion_type;
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema = DATABASE() AND table_name = 'order_item'
          AND column_name = 'commission_rate'
    ) THEN
        ALTER TABLE order_item ADD COLUMN commission_rate DECIMAL(5,2) NULL
            AFTER distributor_product_id;
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema = DATABASE() AND table_name = 'order_item'
          AND column_name = 'attribution_expires_at'
    ) THEN
        ALTER TABLE order_item ADD COLUMN attribution_expires_at DATETIME NULL
            AFTER commission_rate;
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM information_schema.statistics
        WHERE table_schema = DATABASE() AND table_name = 'order_item'
          AND index_name = 'idx_order_item_distribution'
    ) THEN
        ALTER TABLE order_item ADD INDEX idx_order_item_distribution
            (distributor_product_id);
    END IF;
END$$
CALL upgrade_distributor_schema()$$
DROP PROCEDURE upgrade_distributor_schema$$
DELIMITER ;
