# 订单预览与提交

订单提交采用 Redis 预览令牌。前端先调用订单预览，后端保存用户最终选择 15 分钟；提交订单时只需要传 `previewToken`，不再重复提交商品、地址、优惠券、积分和活动参数。

## 1. 订单预览

```http
POST /api/orders/preview
Authorization: Bearer <token>
Content-Type: application/json
```

预览请求仍用于调整用户选择：

```json
{
  "cartItemIds": [1001, 1002],
  "deliveryType": 1,
  "addressId": 4001,
  "pickupPointId": null,
  "usePlatformCoupon": true,
  "platformCouponUserId": null,
  "useMerchantCoupon": true,
  "merchantCouponUserId": null,
  "usePoints": true,
  "usePointsAmount": null,
  "activityContext": {
    "seckillProductId": null,
    "bargainRecordId": null,
    "groupId": null,
    "promotionIds": []
  },
  "remark": "请尽快配送"
}
```

响应新增：

```json
{
  "code": 0,
  "data": {
    "previewToken": "f84de3a249e24763a39df29b2819ec32",
    "previewExpireSeconds": 900,
    "priceDetail": {
      "totalAmount": 139.80,
      "seckillDiscount": 20.00,
      "merchantCouponDiscount": 15.00,
      "platformCouponDiscount": 5.00,
      "pointsDeduction": 9.98,
      "payAmount": 89.82
    },
    "activityInfo": {
      "seckillProductId": 9001,
      "bargainRecordId": null,
      "groupId": null,
      "promotionIds": []
    }
  }
}
```

Redis 中保存的是服务端实际采用的最终选择，包括购物车明细、配送方式、地址、自提点、平台券、商家券、积分、秒杀/砍价/促销活动和备注。金额只用于展示，不作为提交订单的可信输入。

每次重新预览都会生成新的独立令牌，因此多个页面或设备不会因“最后一次选择”互相覆盖。

## 2. 提交订单

```http
POST /api/orders
Authorization: Bearer <token>
Content-Type: application/json
X-Idempotent-Key: order-10007-20260703-001
```

请求体只有一个字段：

```json
{
  "previewToken": "f84de3a249e24763a39df29b2819ec32"
}
```

| 参数 | 必填 | 说明 |
| --- | --- | --- |
| `previewToken` | 是 | 当前用户订单预览返回的令牌，有效期 900 秒 |
| `X-Idempotent-Key` | 是 | 本次创建订单的唯一幂等键，最长 100 字符 |

提交时后端从 Redis 读取最终选择，并重新校验：

- 购物车归属、商品状态和 SKU 库存；
- 秒杀、砍价和满减活动有效性；
- 平台券和商家券归属、有效期、门槛与商家；
- 积分余额及优惠后金额 10% 的抵扣上限；
- 地址、自提点和配送方式；
- 最终应付金额。

客户端不提交任何金额，不能通过修改预览金额影响订单价格。

## 3. 成功响应

```json
{
  "code": 0,
  "message": "订单创建成功",
  "data": {
    "orderId": 5001,
    "orderSn": "ORD202607010001",
    "status": 0,
    "statusText": "WAIT_PAY",
    "totalAmount": 139.80,
    "seckillDiscount": 20.00,
    "bargainDiscount": 0.00,
    "promotionDiscount": 0.00,
    "merchantCouponDiscount": 15.00,
    "platformCouponDiscount": 5.00,
    "pointsDeduction": 9.98,
    "deliveryFee": 0.00,
    "payAmount": 89.82,
    "expireTime": "2026-07-01 16:05:27"
  }
}
```

相同用户使用同一个 `X-Idempotent-Key` 重复提交时，直接返回第一次创建的订单，并增加：

```json
"idempotent": true
```

## 4. 主要错误

| code | 说明 |
| --- | --- |
| `40912` | 库存不足 |
| `40913` | 平台优惠券不可用或不满足条件 |
| `40914` | 商家优惠券不可用或不满足条件 |
| `40917` | 砍价记录不可用 |
| `40951` | 积分余额不足 |
| `40952` | 积分超过本单抵扣上限 |
| `40961` | 预览令牌不存在、已过期或不属于当前用户 |
| `50301` | Redis 暂时不可用，无法保存或读取预览状态 |
