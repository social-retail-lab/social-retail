-- =====================================================
-- 1. 同步 merchant_apply 联系人姓名与 merchant 表
-- =====================================================
UPDATE `merchant_apply` SET `contact_name` = '龙国建' WHERE `id` = 4001;
UPDATE `merchant_apply` SET `contact_name` = '周小雪' WHERE `id` = 4002;
UPDATE `merchant_apply` SET `contact_name` = '林志远' WHERE `id` = 4003;
UPDATE `merchant_apply` SET `contact_name` = '苏婉清' WHERE `id` = 4004;
UPDATE `merchant_apply` SET `contact_name` = '黄德伟' WHERE `id` = 4005;
UPDATE `merchant_apply` SET `contact_name` = '何雅琴' WHERE `id` = 4006;

-- =====================================================
-- 2. 丰富 after_sale 申诉原因、商家拒绝理由
-- =====================================================

-- #1: 三只松鼠每日坚果30包礼盒 → 退货退款(已完成)
UPDATE `after_sale` SET 
  `reason`        = '收到的坚果礼盒包装破损，内部独立小包有多袋漏气，与商品详情页展示的完好包装严重不符',
  `audit_time`    = '2026-05-09 14:30:00'
WHERE `id` = 1;

-- #2: 三只松鼠每日坚果30包礼盒 → 仅退款(待商家审核)
-- 增加一条新的更合情的备注
UPDATE `after_sale` SET 
  `reason`        = '下单后发现同款商品在别的平台有更优惠的价格，商品尚未发货故申请仅退款',
  `audit_time`    = NULL
WHERE `id` = 2;

-- #3: 沃隆每日坚果750g30袋 → 退货退款(商家已同意)
-- 食品类用"尺码不合适"不合理，改为包装问题
UPDATE `after_sale` SET 
  `reason`        = '到货后发现实际为25袋装而非下单时标注的30袋装，包装规格与商品描述不符',
  `audit_time`    = '2026-06-11 11:20:00'
WHERE `id` = 3;

-- #4: 良品铺子芒果干500g → 仅退款(已拒绝)
UPDATE `after_sale` SET 
  `reason`        = '下单时误选了500g大包装规格，原计划购买200g小包装，商品尚未拆封希望退货',
  `audit_time`    = '2026-05-17 10:00:00',
  `reject_reason` = '您的订单已确认收货超过7天，根据平台售后规则暂不支持退款申请。建议下次购买前仔细核对商品规格，给您带来不便深表歉意。'
WHERE `id` = 4;

-- #5: 卫龙大面筋68g*10包 → 退货退款(退货中)
UPDATE `after_sale` SET 
  `reason`        = '快递外箱完好但内部有两包卫龙大面筋包装袋破裂，调味红油渗出污染了其余8包商品，附有开箱视频为证',
  `audit_time`    = '2026-06-21 16:00:00'
WHERE `id` = 5;

-- #6: 三只松鼠虎皮风爪袋装 → 仅退款(已完成)
UPDATE `after_sale` SET 
  `reason`        = '虎皮风爪口感偏硬嚼不动，且部分鸡爪有明显腥味未处理干净，与宣传的"鲜香软糯"品质差距较大',
  `audit_time`    = '2026-07-02 09:00:00'
WHERE `id` = 6;

-- #7: 卫龙大面筋68g*10包 → 退货退款(已完成)
UPDATE `after_sale` SET 
  `reason`        = '商品完全未拆封，仍在七天无理由退货时效范围内，因个人口味偏好原因申请退货退款',
  `audit_time`    = '2026-05-10 09:30:00'
WHERE `id` = 7;

-- #8: 元气森林白桃气泡水480ml*15瓶 → 仅退款(已拒绝)
UPDATE `after_sale` SET 
  `reason`        = '购买后发现家人已从超市购买了同款白桃气泡水两箱，为避免囤积浪费故申请未使用部分的退款',
  `audit_time`    = '2026-05-28 09:00:00',
  `reject_reason` = '您的订单已确认收货且超过七天无理由退货时效，平台暂不支持该笔退款申请。感谢您的理解与支持，祝您生活愉快。'
WHERE `id` = 8;
