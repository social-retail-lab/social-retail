-- ============================================================
-- 0708 推广链接 IP 回滚为 localhost
-- 背景：之前前后端分机开发时，推广链接使用 http://172.20.10.2:5173
--      现在回到本机开发，需将已有 promotion_url 中的旧 IP 替换为 localhost
-- 同时置空 qr_code，下次调用分享链接接口会按新 URL 重新生成二维码
-- ============================================================

UPDATE distributor_product
SET promotion_url = REPLACE(promotion_url, 'http://172.20.10.2:5173', 'http://localhost:5173'),
    qr_code = NULL
WHERE promotion_url LIKE '%172.20.10.2%';
