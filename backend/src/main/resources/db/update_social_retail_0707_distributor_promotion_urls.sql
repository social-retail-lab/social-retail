-- 历史推广链接/二维码修复脚本。
-- 正式环境执行前，请将该变量替换为 app.frontend-base-url 的实际值。
SET @frontend_base_url = 'http://172.20.10.2:5173';

UPDATE distributor_product dp
JOIN merchant_distribution_product mdp
  ON mdp.id = dp.distribution_product_id
SET dp.promotion_url = CONCAT(
        TRIM(TRAILING '/' FROM @frontend_base_url),
        '/pages/product/detail?id=', mdp.product_id,
        '&promotionCode=', dp.promotion_code
    ),
    -- 置空后，下次调用分享链接/推广商品详情接口会按新 URL 重新生成二维码。
    dp.qr_code = NULL;
