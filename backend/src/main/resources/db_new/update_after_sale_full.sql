-- =============================================================
-- after_sale 数据全面补填
-- =============================================================

-- #1: 三只松鼠坚果 → 退货退款(已完成) → merchant 2001
UPDATE `after_sale` SET 
  `merchant_id`       = 2001,
  `evidence_images`   = '["/static/product/6001.jpg"]',
  `feedback_images`   = NULL
WHERE `id` = 1;

-- #2: 三只松鼠坚果 → 仅退款(待审核) → merchant 2001
UPDATE `after_sale` SET 
  `merchant_id`       = 2001,
  `evidence_images`   = NULL
WHERE `id` = 2;

-- #3: 沃隆坚果 → 退货退款(已同意待退货) → merchant 2003
UPDATE `after_sale` SET 
  `merchant_id`             = 2003,
  `evidence_images`         = '["/static/product/6012.jpg"]',
  `return_received_status`  = 0
WHERE `id` = 3;

-- #4: 良品铺子芒果干 → 仅退款(已拒绝) → merchant 2001
UPDATE `after_sale` SET 
  `merchant_id`       = 2001,
  `evidence_images`   = '["/static/product/6003.jpg"]'
WHERE `id` = 4;

-- #5: 卫龙大面筋 → 退货退款(已寄回待确认) → merchant 2002
UPDATE `after_sale` SET 
  `merchant_id`             = 2002,
  `evidence_images`         = '["/static/product/6005.jpg"]',
  `return_received_status`  = 1
WHERE `id` = 5;

-- #6: 三只松鼠虎皮风爪 → 仅退款(已完成) → merchant 2001
UPDATE `after_sale` SET 
  `merchant_id`       = 2001,
  `evidence_images`   = '["/static/product/6002.jpg"]'
WHERE `id` = 6;

-- #7: 卫龙大面筋 → 退货退款(已完成) → merchant 2002
UPDATE `after_sale` SET 
  `merchant_id`       = 2002,
  `evidence_images`   = '["/static/product/6005.jpg"]'
WHERE `id` = 7;

-- #8: 元气森林气泡水 → 仅退款(已拒绝) → merchant 2006
UPDATE `after_sale` SET 
  `merchant_id`       = 2006,
  `evidence_images`   = '["/static/product/6021.jpg"]',
  `feedback_content`  = '商家拒绝理由牵强，商品实际签收仅第4天就申请售后，不应被拒'
WHERE `id` = 8;
