# 分销推广归因

推广归因有效期固定为 7 天，从携带推广码加入购物车时开始计算。

## 1. 进入商品详情

```http
GET /api/products/{productId}?promotionCode={promotionCode}
Authorization: Bearer {token}
```

推广码有效且与商品匹配时，详情响应额外返回：

```json
{
  "distributorProductId": 7,
  "promotionCode": "PR202607061557112EB144D4",
  "promotionExpiresAt": "2026-07-13 16:00:00"
}
```

## 2. 加入购物车

```http
POST /api/cart/items
Authorization: Bearer {token}
Content-Type: application/json
```

```json
{
  "skuId": 8014,
  "quantity": 1,
  "promotionCode": "PR202607061557112EB144D4"
}
```

同一 SKU 再次携带其他有效推广码加入时，以最后一次推广归因为准。未携带推广码时保留尚未过期的已有归因。

## 3. 下单与支付

结算提交时，系统将有效的 `distributorProductId`、佣金比例和到期时间快照到 `order_item`。支付成功后按订单明细实付金额计算佣金；归因已过期、推广已停用或商品不匹配时不产生佣金。

佣金写入由支付成功事务直接调用，不需要客户端调用 `/internal/commission/calc`。
