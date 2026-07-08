// 我的优惠券相关常量(4.3.3 - 平台券+商家券统一)

// 优惠券来源
export const COUPON_SOURCE = {
  // 平台券
  PLATFORM: 'PLATFORM',
  // 商家券
  MERCHANT: 'MERCHANT'
}

// 优惠券来源文本
export const COUPON_SOURCE_TEXT = {
  [COUPON_SOURCE.PLATFORM]: '平台券',
  [COUPON_SOURCE.MERCHANT]: '商家券'
}

// 优惠券使用状态
export const COUPON_STATUS = {
  // 未使用
  UNUSED: 0,
  // 已使用
  USED: 1,
  // 已过期
  EXPIRED: 2
}

// 优惠券使用状态文本
export const COUPON_STATUS_TEXT = {
  [COUPON_STATUS.UNUSED]: '未使用',
  [COUPON_STATUS.USED]: '已使用',
  [COUPON_STATUS.EXPIRED]: '已过期'
}

// 优惠券 Tab 选项(我的优惠券页面顶部切换)
export const COUPON_TABS = [
  { label: '未使用', value: COUPON_STATUS.UNUSED },
  { label: '已使用', value: COUPON_STATUS.USED },
  { label: '已过期', value: COUPON_STATUS.EXPIRED }
]

// 优惠券类型
export const COUPON_TYPE = {
  // 满减券
  DISCOUNT: 1
}

// 优惠券类型文本
export const COUPON_TYPE_TEXT = {
  [COUPON_TYPE.DISCOUNT]: '满减券'
}

/**
 * 获取优惠券使用状态文本
 * @param {Number} status 状态码
 * @returns {String}
 */
export const getCouponStatusText = (status) => {
  return COUPON_STATUS_TEXT[Number(status)] || '未知'
}

/**
 * 获取优惠券来源文本
 * @param {String} source 来源
 * @returns {String}
 */
export const getCouponSourceText = (source) => {
  return COUPON_SOURCE_TEXT[source] || '优惠券'
}

/**
 * 获取优惠券使用状态样式类
 * @param {Number} status 状态码
 * @returns {String}
 */
export const getCouponStatusClass = (status) => {
  const code = Number(status)
  if (code === COUPON_STATUS.UNUSED) return 'status-unused'
  if (code === COUPON_STATUS.USED) return 'status-used'
  if (code === COUPON_STATUS.EXPIRED) return 'status-expired'
  return ''
}

/**
 * 判断优惠券是否可使用
 * @param {Object} coupon 优惠券对象
 * @returns {Boolean}
 */
export const isCouponUsable = (coupon) => {
  if (!coupon) return false
  return Number(coupon.status) === COUPON_STATUS.UNUSED
}

// ============ 4.3.4 预览订单可用优惠券 ============

// 优惠券选择来源(用于区分弹窗)
export const COUPON_SELECT_SOURCE = {
  // 平台券
  PLATFORM: 'PLATFORM',
  // 商家券
  MERCHANT: 'MERCHANT'
}

// 默认使用规则(后端未返回时兜底)
export const DEFAULT_COUPON_USE_RULE = {
  maxPlatformCouponCount: 1,
  maxMerchantCouponCount: 1,
  canStack: true,
  description: '同一笔订单最多使用1张平台优惠券和1张商家优惠券，二者可叠加使用。'
}

/**
 * 规范化订单可用优惠券响应数据(4.3.4)
 * 兼容字段:orderAmount / settlementAmount
 */
export const normalizeAvailableCouponsData = (data) => {
  if (!data) {
    return {
      settlementAmount: 0,
      merchantId: null,
      merchantName: '',
      platformCoupons: [],
      merchantCoupons: [],
      useRule: { ...DEFAULT_COUPON_USE_RULE }
    }
  }
  return {
    settlementAmount: Number(data.settlementAmount ?? data.orderAmount ?? 0),
    merchantId: data.merchantId || null,
    merchantName: data.merchantName || '',
    platformCoupons: Array.isArray(data.platformCoupons) ? data.platformCoupons : [],
    merchantCoupons: Array.isArray(data.merchantCoupons) ? data.merchantCoupons : [],
    useRule: data.useRule || { ...DEFAULT_COUPON_USE_RULE }
  }
}

/**
 * 获取可用优惠券数量(平台+商家)
 * @param {Object} data 可用优惠券数据
 * @returns {Number}
 */
export const getAvailableCouponCount = (data) => {
  if (!data) return 0
  const platformCount = Array.isArray(data.platformCoupons)
    ? data.platformCoupons.filter(c => c.available).length
    : 0
  const merchantCount = Array.isArray(data.merchantCoupons)
    ? data.merchantCoupons.filter(c => c.available).length
    : 0
  return platformCount + merchantCount
}

/**
 * 判断优惠券是否可选
 * @param {Object} coupon 优惠券对象(4.3.4 返回)
 * @returns {Boolean}
 */
export const isCouponAvailable = (coupon) => {
  if (!coupon) return false
  return !!coupon.available
}
