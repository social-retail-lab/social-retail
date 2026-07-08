-- =====================================================
-- 商品评价系统 + 评价申诉 + 售后率/星级统计
-- update_social_retail_0707_v5_db.sql
-- =====================================================

-- 1. 订单评价表
CREATE TABLE IF NOT EXISTS `order_review` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `order_id` BIGINT COMMENT '订单ID',
    `order_sn` VARCHAR(50) COMMENT '订单编号',
    `user_id` BIGINT COMMENT '用户ID',
    `merchant_id` BIGINT NOT NULL COMMENT '商家ID',
    `product_id` BIGINT COMMENT '商品ID',
    `rating` TINYINT NOT NULL COMMENT '评分 1-5',
    `content` TEXT COMMENT '评价内容',
    `images` VARCHAR(1000) COMMENT '评价图片,逗号分隔',
    `is_anonymous` TINYINT DEFAULT 0 COMMENT '0=实名 1=匿名',
    `appeal_status` TINYINT DEFAULT 0 COMMENT '0=正常展示 1=申诉中 2=已屏蔽 3=申诉驳回',
    `appeal_reason` VARCHAR(500) COMMENT '申诉原因',
    `appeal_evidence` VARCHAR(1000) COMMENT '申诉证明材料',
    `appeal_time` DATETIME COMMENT '申诉时间',
    `audit_result` VARCHAR(200) COMMENT '审核结果说明',
    `audit_time` DATETIME COMMENT '审核时间',
    `create_time` DATETIME COMMENT '评价时间',
    INDEX `idx_merchant_id` (`merchant_id`),
    INDEX `idx_rating` (`merchant_id`, `rating`),
    INDEX `idx_appeal` (`appeal_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='订单评价表';

-- 2. 插入测试评价（60%的已完成订单有评价）
INSERT INTO `order_review` (`order_id`, `order_sn`, `user_id`, `merchant_id`, `rating`, `content`, `is_anonymous`, `appeal_status`, `create_time`)
SELECT o.id, o.order_sn, o.user_id, o.merchant_id,
    CASE 
        WHEN RAND() < 0.40 THEN 5
        WHEN RAND() < 0.70 THEN 4
        WHEN RAND() < 0.85 THEN 3
        WHEN RAND() < 0.95 THEN 2
        ELSE 1
    END,
    CONCAT('商品不错，物流很快。整体满意，',
        CASE WHEN RAND() < 0.5 THEN '下次还会再来购买的。' ELSE '值得推荐给朋友。' END),
    0, 0,
    DATE_ADD(o.create_time, INTERVAL 2 + FLOOR(RAND() * 10) DAY)
FROM `order` o
WHERE o.status = 4
    AND o.id NOT IN (SELECT COALESCE(order_id, 0) FROM `order_review`)
    AND RAND() < 0.6
LIMIT 80;

-- 插入低分评价（用于测试申诉）
INSERT INTO `order_review` (`order_id`, `order_sn`, `user_id`, `merchant_id`, `rating`, `content`, `is_anonymous`, `appeal_status`, `create_time`)
SELECT o.id, o.order_sn, o.user_id, o.merchant_id,
    CASE WHEN RAND() < 0.5 THEN 1 ELSE 2 END,
    CASE WHEN RAND() < 0.33 THEN '商品质量太差了，和描述完全不符，非常失望。'
        WHEN RAND() < 0.66 THEN '快递包装破损，东西有瑕疵，不太满意。'
        ELSE '客服态度不好，处理问题很慢，不会再买了。' END,
    0, 0,
    DATE_ADD(o.create_time, INTERVAL 3 + FLOOR(RAND() * 8) DAY)
FROM `order` o
WHERE o.status = 4
    AND o.id NOT IN (SELECT COALESCE(order_id, 0) FROM `order_review`)
    AND RAND() < 0.3
LIMIT 15;

-- 头部商家补充更多评价
INSERT INTO `order_review` (`order_id`, `order_sn`, `user_id`, `merchant_id`, `rating`, `content`, `is_anonymous`, `appeal_status`, `create_time`)
SELECT o.id, o.order_sn, o.user_id, o.merchant_id,
    CASE WHEN RAND() < 0.50 THEN 5 WHEN RAND() < 0.80 THEN 4 WHEN RAND() < 0.95 THEN 3 ELSE 1 END,
    CONCAT('已经是第', FLOOR(1 + RAND() * 5), '次购买了，质量稳定。'), 0, 0,
    DATE_ADD(o.create_time, INTERVAL 2 + FLOOR(RAND() * 12) DAY)
FROM `order` o
WHERE o.merchant_id IN (2003, 2004, 2007, 2010) AND o.status = 4
    AND o.id NOT IN (SELECT COALESCE(order_id, 0) FROM `order_review`)
    AND RAND() < 0.7
LIMIT 30;

-- 3. 申诉示例（为已有评价添加申诉）
UPDATE `order_review` SET 
    appeal_status = 1, 
    appeal_reason = '该用户存在恶意差评嫌疑，证据已上传', 
    appeal_evidence = '/static/license/1001.jpg',
    appeal_time = '2026-07-05 10:00:00'
WHERE rating <= 2 AND merchant_id = 2003 AND appeal_status = 0
LIMIT 2;

UPDATE `order_review` SET 
    appeal_status = 1, 
    appeal_reason = '竞争对手恶意评价，请求平台核实屏蔽', 
    appeal_evidence = '/static/license/1002.jpg',
    appeal_time = '2026-07-04 15:00:00'
WHERE rating <= 2 AND merchant_id = 2004 AND appeal_status = 0
LIMIT 2;

UPDATE `order_review` SET 
    appeal_status = 2, 
    appeal_reason = '已核实为虚假评价（历史申诉已处理）', 
    appeal_evidence = '/static/license/1001.jpg',
    appeal_time = '2026-07-01 08:00:00',
    audit_result = '经核实该评价为用户恶意差评，予以屏蔽处理',
    audit_time = '2026-07-03 14:00:00'
WHERE rating <= 2 AND merchant_id = 2010 AND appeal_status = 0
LIMIT 1;

UPDATE `order_review` SET 
    appeal_status = 3, 
    appeal_reason = '商家申诉（历史已驳回）', 
    appeal_evidence = '/static/license/1002.jpg',
    appeal_time = '2026-07-02 09:00:00',
    audit_result = '经平台核实，评价内容属实，申诉驳回',
    audit_time = '2026-07-03 16:00:00'
WHERE rating <= 2 AND merchant_id = 2007 AND appeal_status = 0
LIMIT 1;

-- 验证
SELECT '=== 评价统计 ===' AS info;
SELECT rating, COUNT(*) AS cnt FROM `order_review` GROUP BY rating ORDER BY rating DESC;

SELECT '=== 申诉统计 ===' AS info;
SELECT appeal_status, COUNT(*) AS cnt FROM `order_review` WHERE appeal_status > 0 GROUP BY appeal_status;

SELECT '=== 各商家评价概况（含贝叶斯平均） ===' AS info;
SELECT r.merchant_id, m.merchant_name, COUNT(*) AS cnt,
    ROUND(AVG(r.rating), 2) AS avg_rating,
    ROUND((SUM(r.rating) + 4*10) / (COUNT(*) + 10), 2) AS bayesian
FROM `order_review` r LEFT JOIN merchant m ON r.merchant_id = m.id
GROUP BY r.merchant_id, m.merchant_name ORDER BY cnt DESC LIMIT 10;
