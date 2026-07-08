// 订单状态枚举
// 订单状态常量定义

export const ORDER_STATUS = {
  // 待支付
  WAIT_PAY: 0,
  // 待接单
  WAIT_ACCEPT: 1,
  // 已接单
  ACCEPTED: 2,
  // 配送中/待自提
  IN_PROGRESS: 3,
  // 已完成
  COMPLETED: 4,
  // 已取消
  CANCELLED: 5,
  // 已关闭（超时未支付自动关闭）
  CLOSED: 6
}

// 前端字符串状态 → 后端数字状态映射（用于发送请求）
export const STATUS_TO_CODE = {
  'WAIT_PAY': ORDER_STATUS.WAIT_PAY,         // 0
  'WAIT_ACCEPT': ORDER_STATUS.WAIT_ACCEPT,   // 1
  'IN_PROGRESS': ORDER_STATUS.IN_PROGRESS,   // 3
  'COMPLETED': ORDER_STATUS.COMPLETED,       // 4
  'CANCELLED': ORDER_STATUS.CANCELLED        // 5
}

// 后端数字状态 → 前端字符串状态映射（用于解析响应）
export const CODE_TO_STATUS = {
  [ORDER_STATUS.WAIT_PAY]: 'WAIT_PAY',
  [ORDER_STATUS.WAIT_ACCEPT]: 'WAIT_ACCEPT',
  [ORDER_STATUS.ACCEPTED]: 'WAIT_ACCEPT',
  [ORDER_STATUS.IN_PROGRESS]: 'IN_PROGRESS',
  [ORDER_STATUS.COMPLETED]: 'COMPLETED',
  [ORDER_STATUS.CANCELLED]: 'CANCELLED',
  [ORDER_STATUS.CLOSED]: 'CLOSED'
}

// 订单状态映射
export const ORDER_STATUS_MAP = {
  [ORDER_STATUS.WAIT_PAY]: { label: '待支付', color: '#FAAD14' },
  [ORDER_STATUS.WAIT_ACCEPT]: { label: '待接单', color: '#1890FF' },
  [ORDER_STATUS.ACCEPTED]: { label: '已接单', color: '#1890FF' },
  [ORDER_STATUS.IN_PROGRESS]: { label: '配送中', color: '#1890FF' },
  [ORDER_STATUS.COMPLETED]: { label: '已完成', color: '#52C41A' },
  [ORDER_STATUS.CANCELLED]: { label: '已取消', color: '#999999' },
  [ORDER_STATUS.CLOSED]: { label: '已关闭', color: '#999999' }
}

// 订单类型
export const ORDER_TYPE = {
  // 普通订单
  NORMAL: 1,
  // 秒杀订单
  SECKILL: 2,
  // 团购订单
  GROUP_BUY: 3
}

// 配送方式
export const DELIVERY_TYPE = {
  // 快递配送
  EXPRESS: 1,
  // 同城配送
  LOCAL: 2,
  // 门店自提
  PICKUP: 3
}

// 支付方式
export const PAY_TYPE = {
  // 微信支付
  WECHAT: 1,
  // 支付宝
  ALIPAY: 2,
  // 积分抵扣
  POINT: 3,
  // 余额支付
  BALANCE: 4
}

// 取消订单原因
export const CANCEL_REASON = [
  { value: 1, label: '不想买了' },
  { value: 2, label: '信息填错了' },
  { value: 3, label: '重复下单' },
  { value: 4, label: '价格太贵' },
  { value: 5, label: '其他原因' }
]

// 售后类型
export const AFTER_SALE_TYPE = {
  // 仅退款
  REFUND: 1,
  // 退货退款
  RETURN_REFUND: 2,
  // 换货
  EXCHANGE: 3
}

// 售后状态
export const AFTER_SALE_STATUS = {
  // 待审核
  PENDING: 10,
  // 审核通过
  APPROVED: 20,
  // 审核拒绝
  REJECTED: 30,
  // 待退货
  PENDING_RETURN: 40,
  // 已退货/待退款
  RETURNED: 50,
  // 退款中
  REFUNDING: 60,
  // 已完成
  COMPLETED: 70,
  // 已取消
  CANCELLED: 80
}
