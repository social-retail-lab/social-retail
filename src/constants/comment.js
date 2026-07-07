// 商品评价模块常量
// 评分等级、评价状态、匿名标识、错误码

// ============ 评分等级 ============
export const COMMENT_SCORE = {
  ONE: 1,
  TWO: 2,
  THREE: 3,
  FOUR: 4,
  FIVE: 5
}

// 评分范围配置（用于筛选标签）
export const SCORE_FILTER_TABS = [
  { label: '全部', value: 0 },
  { label: '5星', value: 5 },
  { label: '4星', value: 4 },
  { label: '3星及以下', value: 3 }
]

// 评分文案映射
export const SCORE_TEXT_MAP = {
  1: '很差',
  2: '较差',
  3: '一般',
  4: '好评',
  5: '极佳'
}

// ============ 匿名标识 ============
export const ANONYMOUS = {
  NO: 0,
  YES: 1
}

// ============ 评价状态 ============
// SHOW-展示 HIDDEN-隐藏 DELETED-已删除
export const COMMENT_STATUS = {
  SHOW: 'SHOW',
  HIDDEN: 'HIDDEN',
  DELETED: 'DELETED'
}

export const COMMENT_STATUS_MAP = {
  [COMMENT_STATUS.SHOW]: { label: '展示中', color: '#36c666' },
  [COMMENT_STATUS.HIDDEN]: { label: '已隐藏', color: '#999999' },
  [COMMENT_STATUS.DELETED]: { label: '已删除', color: '#999999' }
}

// ============ 评价图片限制 ============
export const COMMENT_LIMIT = {
  MAX_SCORE: 5,
  MIN_SCORE: 1,
  MAX_IMAGES: 6,
  CONTENT_MIN_LENGTH: 0,
  CONTENT_MAX_LENGTH: 500
}

// ============ 业务错误码 ============
export const COMMENT_ERROR_CODE = {
  NOT_ALLOW_COMMENT: 40941, // 当前订单状态不允许评价
  COMMENT_NOT_FOUND: 40441, // 评价不存在
  NO_PERMISSION_DELETE: 40304 // 无权限删除该评价
}

// ============ 评价默认头像 ============
// 匿名用户固定展示灰色简约默认头像
export const DEFAULT_AVATAR = '/static/images/common/default-avatar.png'

// 匿名用户昵称
export const ANONYMOUS_NICKNAME = '匿名用户'
