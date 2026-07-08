// 售后相关常量定义
// 对应接口文档 3.4 售后接口

// ============ 售后类型 ============
export const AFTER_SALE_TYPE = {
  // 仅退款
  REFUND_ONLY: 'REFUND_ONLY',
  // 退货退款
  RETURN_REFUND: 'RETURN_REFUND'
}

// 售后类型文本映射
export const AFTER_SALE_TYPE_TEXT = {
  [AFTER_SALE_TYPE.REFUND_ONLY]: '仅退款',
  [AFTER_SALE_TYPE.RETURN_REFUND]: '退货退款'
}

// 售后类型描述
export const AFTER_SALE_TYPE_DESC = {
  [AFTER_SALE_TYPE.REFUND_ONLY]: '未发货/收货破损无需寄回商品',
  [AFTER_SALE_TYPE.RETURN_REFUND]: '需寄回商品等待商家收货退款'
}

// ============ 售后状态 ============
export const AFTER_SALE_STATUS = {
  // 申请中
  APPLYING: 'APPLYING',
  // 已取消
  CANCELLED: 'CANCELLED',
  // 已退款
  REFUNDED: 'REFUNDED'
}

// 售后状态文本映射
export const AFTER_SALE_STATUS_TEXT = {
  [AFTER_SALE_STATUS.APPLYING]: '申请中',
  [AFTER_SALE_STATUS.CANCELLED]: '已取消',
  [AFTER_SALE_STATUS.REFUNDED]: '已退款'
}

// 售后状态样式类映射(用于页面动态 class)
export const AFTER_SALE_STATUS_CLASS = {
  [AFTER_SALE_STATUS.APPLYING]: 'status-applying',
  [AFTER_SALE_STATUS.CANCELLED]: 'status-cancelled',
  [AFTER_SALE_STATUS.REFUNDED]: 'status-refunded'
}

// 售后状态颜色映射
export const AFTER_SALE_STATUS_COLOR = {
  [AFTER_SALE_STATUS.APPLYING]: '#FF6A00',
  [AFTER_SALE_STATUS.CANCELLED]: '#999999',
  [AFTER_SALE_STATUS.REFUNDED]: '#52C41A'
}

// ============ 售后列表 Tab ============
export const AFTER_SALE_TABS = [
  { label: '全部', value: 'ALL' },
  { label: '申请中', value: AFTER_SALE_STATUS.APPLYING },
  { label: '已取消', value: AFTER_SALE_STATUS.CANCELLED },
  { label: '已退款', value: AFTER_SALE_STATUS.REFUNDED }
]

// ============ 售后原因选项 ============
export const AFTER_SALE_REASONS = [
  '商品破损',
  '质量问题',
  '发错货',
  '少件/漏发',
  '与描述不符',
  '不想要了',
  '其他'
]

// ============ 错误码映射 ============
export const AFTER_SALE_ERROR_CODE = {
  // 订单状态不允许申请售后
  ORDER_STATUS_NOT_ALLOWED: 40931,
  // 售后状态不允许取消
  CANCEL_NOT_ALLOWED: 40932,
  // 售后不存在
  NOT_FOUND: 40431
}

export const AFTER_SALE_ERROR_MSG = {
  [AFTER_SALE_ERROR_CODE.ORDER_STATUS_NOT_ALLOWED]: '当前订单状态不允许申请售后',
  [AFTER_SALE_ERROR_CODE.CANCEL_NOT_ALLOWED]: '当前售后状态不允许取消',
  [AFTER_SALE_ERROR_CODE.NOT_FOUND]: '售后申请不存在'
}

// ============ 辅助函数 ============

/**
 * 获取售后状态文本
 */
export const getAfterSaleStatusText = (status) => {
  return AFTER_SALE_STATUS_TEXT[status] || status || ''
}

/**
 * 获取售后状态样式类
 */
export const getAfterSaleStatusClass = (status) => {
  return AFTER_SALE_STATUS_CLASS[status] || ''
}

/**
 * 获取售后类型文本
 */
export const getAfterSaleTypeText = (type) => {
  return AFTER_SALE_TYPE_TEXT[type] || type || ''
}

/**
 * 售后状态是否可取消
 */
export const isAfterSaleCancellable = (status) => {
  return status === AFTER_SALE_STATUS.APPLYING
}
