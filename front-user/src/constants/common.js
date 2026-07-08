// 通用分页、状态码常量
// 通用常量定义

// HTTP状态码
export const HTTP_STATUS = {
  SUCCESS: 200,
  CREATED: 201,
  BAD_REQUEST: 400,
  UNAUTHORIZED: 401,
  FORBIDDEN: 403,
  NOT_FOUND: 404,
  SERVER_ERROR: 500
}

// 业务状态码
export const BUSINESS_CODE = {
  SUCCESS: 0,
  FAIL: -1,
  NOT_LOGIN: 1001,
  TOKEN_EXPIRED: 1002,
  PERMISSION_DENIED: 1003,
  PARAM_ERROR: 2001,
  DATA_NOT_FOUND: 2002
}

// 业务状态码映射
export const BUSINESS_CODE_MAP = {
  [BUSINESS_CODE.SUCCESS]: '操作成功',
  [BUSINESS_CODE.FAIL]: '操作失败',
  [BUSINESS_CODE.NOT_LOGIN]: '请先登录',
  [BUSINESS_CODE.TOKEN_EXPIRED]: '登录已过期，请重新登录',
  [BUSINESS_CODE.PERMISSION_DENIED]: '权限不足',
  [BUSINESS_CODE.PARAM_ERROR]: '参数错误',
  [BUSINESS_CODE.DATA_NOT_FOUND]: '数据不存在'
}

// 分页默认参数
export const PAGE_DEFAULT = {
  PAGE_NUM: 1,
  PAGE_SIZE: 10
}

// 分页最大数量
export const PAGE_MAX_SIZE = 100

// 商品状态
export const GOODS_STATUS = {
  // 上架
  ON_SHELF: 1,
  // 下架
  OFF_SHELF: 0
}

// 商品标签
export const GOODS_TAG = {
  // 新品
  NEW: 'new',
  // 热卖
  HOT: 'hot',
  // 秒杀
  SECKILL: 'seckill',
  // 团购
  GROUP_BUY: 'group_buy'
}

// 商品标签映射
export const GOODS_TAG_MAP = {
  [GOODS_TAG.NEW]: { label: '新品', color: '#52C41A' },
  [GOODS_TAG.HOT]: { label: '热卖', color: '#FF4D4F' },
  [GOODS_TAG.SECKILL]: { label: '秒杀', color: '#FF6B35' },
  [GOODS_TAG.GROUP_BUY]: { label: '团购', color: '#1890FF' }
}

// 评价星级
export const REVIEW_STAR = {
  ONE: 1,
  TWO: 2,
  THREE: 3,
  FOUR: 4,
  FIVE: 5
}

// 评价星级映射
export const REVIEW_STAR_MAP = {
  [REVIEW_STAR.ONE]: { label: '非常差' },
  [REVIEW_STAR.TWO]: { label: '差' },
  [REVIEW_STAR.THREE]: { label: '一般' },
  [REVIEW_STAR.FOUR]: { label: '好' },
  [REVIEW_STAR.FIVE]: { label: '非常好' }
}

// 消息类型
export const MESSAGE_TYPE = {
  // 订单通知
  ORDER: 1,
  // 审核通知
  AUDIT: 2,
  // 售后通知
  AFTER_SALE: 3,
  // 系统公告
  SYSTEM: 4
}

// 消息类型映射
export const MESSAGE_TYPE_MAP = {
  [MESSAGE_TYPE.ORDER]: { label: '订单通知' },
  [MESSAGE_TYPE.AUDIT]: { label: '审核通知' },
  [MESSAGE_TYPE.AFTER_SALE]: { label: '售后通知' },
  [MESSAGE_TYPE.SYSTEM]: { label: '系统公告' }
}

// 消息状态
export const MESSAGE_STATUS = {
  // 未读
  UNREAD: 0,
  // 已读
  READ: 1
}

// 性别
export const GENDER = {
  // 未知
  UNKNOWN: 0,
  // 男
  MALE: 1,
  // 女
  FEMALE: 2
}

// 性别映射
export const GENDER_MAP = {
  [GENDER.UNKNOWN]: { label: '未知' },
  [GENDER.MALE]: { label: '男' },
  [GENDER.FEMALE]: { label: '女' }
}

// 是否
export const BOOLEAN = {
  NO: 0,
  YES: 1
}

// 是否映射
export const BOOLEAN_MAP = {
  [BOOLEAN.NO]: { label: '否' },
  [BOOLEAN.YES]: { label: '是' }
}
