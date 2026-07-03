// 用户行为埋点工具
// 包含：页面浏览、点击事件、曝光事件、转化事件
//作用：用户在 APP 里每一次浏览、点击、加购、下单、分享等操作，
// 都会通过这个文件统一上报行为日志给后端数据分析平台，用来统计运营数据、分析用户习惯。

// 页面浏览埋点
export const trackPageView = (pageName, params = {}) => {
  // 调用埋点SDK
  // console.log('trackPageView:', pageName, params)
}

// 点击事件埋点
export const trackClick = (eventName, params = {}) => {
  // 调用埋点SDK
  // console.log('trackClick:', eventName, params)
}

// 曝光事件埋点
export const trackExpose = (eventName, params = {}) => {
  // 调用埋点SDK
  // console.log('trackExpose:', eventName, params)
}

// 转化事件埋点
export const trackConversion = (eventName, params = {}) => {
  // 调用埋点SDK
  // console.log('trackConversion:', eventName, params)
}

// 搜索事件埋点
export const trackSearch = (keyword, resultCount) => {
  trackClick('search', {
    keyword,
    resultCount
  })
}

// 商品点击埋点
export const trackGoodsClick = (goodsId, goodsName, position) => {
  trackClick('goods_click', {
    goodsId,
    goodsName,
    position
  })
}

// 商品加购埋点
export const trackAddToCart = (goodsId, goodsName, price, count) => {
  trackClick('add_to_cart', {
    goodsId,
    goodsName,
    price,
    count
  })
}

// 订单创建埋点
export const trackOrderCreate = (orderId, amount, goodsCount) => {
  trackConversion('order_create', {
    orderId,
    amount,
    goodsCount
  })
}

// 订单支付埋点
export const trackOrderPay = (orderId, amount, payType) => {
  trackConversion('order_pay', {
    orderId,
    amount,
    payType
  })
}

// 优惠券领取埋点
export const trackCouponReceive = (couponId, couponName) => {
  trackClick('coupon_receive', {
    couponId,
    couponName
  })
}

// 分享事件埋点
export const trackShare = (shareType, goodsId) => {
  trackClick('share', {
    shareType,
    goodsId
  })
}

// 分销申请埋点
export const trackDistApply = () => {
  trackClick('dist_apply')
}

// 提现申请埋点
export const trackWithdraw = (amount) => {
  trackClick('withdraw', {
    amount
  })
}
