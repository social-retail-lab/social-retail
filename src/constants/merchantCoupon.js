// 商家优惠券相关常量

// 商家优惠券类型
export const MERCHANT_COUPON_TYPE = {
  // 满减券(当前系统仅支持此类型)
  DISCOUNT: 1
}

// 商家优惠券类型文本
export const MERCHANT_COUPON_TYPE_TEXT = {
  [MERCHANT_COUPON_TYPE.DISCOUNT]: '满减券'
}

// 商家优惠券领取状态(用户视角)
export const MERCHANT_COUPON_RECEIVE_STATUS = {
  // 可领取
  RECEIVABLE: 'RECEIVABLE',
  // 已领取
  RECEIVED: 'RECEIVED',
  // 已领完
  SOLD_OUT: 'SOLD_OUT'
}

// 商家优惠券错误码
export const MERCHANT_COUPON_ERROR_CODE = {
  // 商家优惠券不存在
  NOT_FOUND: 40481,
  // 已领完
  SOLD_OUT: 40981,
  // 已达每人限领数量
  LIMIT_REACHED: 40982,
  // 当前不可领取
  UNAVAILABLE: 40983,
  // 已过期
  EXPIRED: 40984
}

// 商家优惠券错误码 → 提示文案
export const MERCHANT_COUPON_ERROR_MSG = {
  [MERCHANT_COUPON_ERROR_CODE.NOT_FOUND]: '商家优惠券不存在',
  [MERCHANT_COUPON_ERROR_CODE.SOLD_OUT]: '商家优惠券已领完',
  [MERCHANT_COUPON_ERROR_CODE.LIMIT_REACHED]: '已达到每人限领数量',
  [MERCHANT_COUPON_ERROR_CODE.UNAVAILABLE]: '商家优惠券当前不可领取',
  [MERCHANT_COUPON_ERROR_CODE.EXPIRED]: '商家优惠券已过期'
}

/**
 * 根据优惠券状态获取领取按钮文案
 * @param {Object} coupon 优惠券对象
 * @returns {String} 按钮文案
 */
export const getReceiveBtnText = (coupon) => {
  if (!coupon) return '立即领取'
  if (coupon.alreadyReceived) return '已领取'
  if (Number(coupon.remainingCount) <= 0) return '已领完'
  return '立即领取'
}

/**
 * 判断优惠券是否可领取
 * @param {Object} coupon 优惠券对象
 * @returns {Boolean}
 */
export const isCouponReceivable = (coupon) => {
  if (!coupon) return false
  if (coupon.alreadyReceived) return false
  if (Number(coupon.remainingCount) <= 0) return false
  return true
}

/**
 * 根据错误码获取提示文案
 * @param {Number} code 错误码
 * @returns {String} 提示文案
 */
export const getMerchantCouponErrorMsg = (code) => {
  return MERCHANT_COUPON_ERROR_MSG[code] || '领取失败，请稍后重试'
}
