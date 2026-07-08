// 商家通用常量(状态、错误码)

// ============ 商家状态 ============
export const MERCHANT_STATUS = {
  // 已禁用
  DISABLED: 0,
  // 正常营业
  ENABLED: 1
}

// 商家状态文本
export const MERCHANT_STATUS_TEXT = {
  [MERCHANT_STATUS.DISABLED]: '已禁用',
  [MERCHANT_STATUS.ENABLED]: '正常营业'
}

// 商家状态样式类(用于前端展示)
export const MERCHANT_STATUS_CLASS = {
  [MERCHANT_STATUS.DISABLED]: 'status-closed',
  [MERCHANT_STATUS.ENABLED]: 'status-open'
}

/**
 * 获取商家状态文本
 * @param {Number} status 状态码
 * @returns {String}
 */
export const getMerchantStatusText = (status) => {
  return MERCHANT_STATUS_TEXT[Number(status)] || '未知'
}

/**
 * 获取商家状态样式类
 * @param {Number} status 状态码
 * @returns {String}
 */
export const getMerchantStatusClass = (status) => {
  return MERCHANT_STATUS_CLASS[Number(status)] || ''
}

/**
 * 判断商家是否营业中
 * @param {Number} status 状态码
 * @returns {Boolean}
 */
export const isMerchantOpen = (status) => {
  return Number(status) === MERCHANT_STATUS.ENABLED
}

// ============ 商品状态 ============
export const PRODUCT_STATUS = {
  // 下架
  OFF_SHELF: 0,
  // 上架
  ON_SHELF: 1
}

// 商品审核状态
export const PRODUCT_AUDIT_STATUS = {
  // 待审核
  PENDING: 0,
  // 审核通过
  APPROVED: 1,
  // 审核不通过
  REJECTED: 2
}

// ============ 商家错误码 ============
export const MERCHANT_ERROR_CODE = {
  // 商家不存在
  NOT_FOUND: 40431,
  // 商家当前不可访问(已禁用)
  UNAVAILABLE: 40931,
  // 搜索关键词不能为空(2.9.6)
  KEYWORD_REQUIRED: 40031
}

// 商家错误码 → 提示文案
export const MERCHANT_ERROR_MSG = {
  [MERCHANT_ERROR_CODE.NOT_FOUND]: '商家不存在',
  [MERCHANT_ERROR_CODE.UNAVAILABLE]: '商家当前不可访问',
  [MERCHANT_ERROR_CODE.KEYWORD_REQUIRED]: '搜索关键词不能为空'
}

/**
 * 根据错误码获取商家相关提示文案
 * @param {Number} code 错误码
 * @returns {String}
 */
export const getMerchantErrorMsg = (code) => {
  return MERCHANT_ERROR_MSG[code] || ''
}

// ============ 商品排序选项 ============
export const MERCHANT_PRODUCT_SORT = {
  // 默认排序
  DEFAULT: 'DEFAULT',
  // 销量降序
  SALES_DESC: 'SALES_DESC',
  // 最新上架降序
  NEW_DESC: 'NEW_DESC'
}

// 排序选项列表(供页面使用)
export const MERCHANT_PRODUCT_SORT_OPTIONS = [
  { label: '默认', value: MERCHANT_PRODUCT_SORT.DEFAULT },
  { label: '销量', value: MERCHANT_PRODUCT_SORT.SALES_DESC },
  { label: '最新', value: MERCHANT_PRODUCT_SORT.NEW_DESC }
]
