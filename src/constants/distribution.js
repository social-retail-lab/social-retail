// 分销状态常量
// 分销体系相关常量定义

// 分销员状态
export const DISTRIBUTOR_STATUS = {
  // 未申请
  NOT_APPLIED: 0,
  // 审核中
  PENDING: 1,
  // 已通过
  APPROVED: 2,
  // 已拒绝
  REJECTED: 3,
  // 已冻结
  FROZEN: 4
}

// 分销员状态映射
export const DISTRIBUTOR_STATUS_MAP = {
  [DISTRIBUTOR_STATUS.NOT_APPLIED]: { label: '未申请', color: '#999999' },
  [DISTRIBUTOR_STATUS.PENDING]: { label: '审核中', color: '#FAAD14' },
  [DISTRIBUTOR_STATUS.APPROVED]: { label: '已通过', color: '#52C41A' },
  [DISTRIBUTOR_STATUS.REJECTED]: { label: '已拒绝', color: '#FF4D4F' },
  [DISTRIBUTOR_STATUS.FROZEN]: { label: '已冻结', color: '#999999' }
}

// 佣金类型
export const COMMISSION_TYPE = {
  // 一级佣金
  LEVEL_1: 1,
  // 二级佣金
  LEVEL_2: 2,
  // 团队佣金
  TEAM: 3,
  // 活动奖励
  ACTIVITY: 4
}

// 佣金类型映射
export const COMMISSION_TYPE_MAP = {
  [COMMISSION_TYPE.LEVEL_1]: { label: '一级佣金' },
  [COMMISSION_TYPE.LEVEL_2]: { label: '二级佣金' },
  [COMMISSION_TYPE.TEAM]: { label: '团队佣金' },
  [COMMISSION_TYPE.ACTIVITY]: { label: '活动奖励' }
}

// 佣金状态
export const COMMISSION_STATUS = {
  // 待结算
  PENDING: 1,
  // 已结算
  SETTLED: 2,
  // 已提现
  WITHDRAWN: 3
}

// 佣金状态映射
export const COMMISSION_STATUS_MAP = {
  [COMMISSION_STATUS.PENDING]: { label: '待结算', color: '#FAAD14' },
  [COMMISSION_STATUS.SETTLED]: { label: '已结算', color: '#1890FF' },
  [COMMISSION_STATUS.WITHDRAWN]: { label: '已提现', color: '#52C41A' }
}

// 提现方式
export const WITHDRAW_METHOD = {
  // 微信零钱
  WECHAT: 1,
  // 支付宝
  ALIPAY: 2,
  // 银行卡
  BANK_CARD: 3
}

// 提现方式映射
export const WITHDRAW_METHOD_MAP = {
  [WITHDRAW_METHOD.WECHAT]: { label: '微信零钱' },
  [WITHDRAW_METHOD.ALIPAY]: { label: '支付宝' },
  [WITHDRAW_METHOD.BANK_CARD]: { label: '银行卡' }
}

// 提现状态
export const WITHDRAW_STATUS = {
  // 待审核
  PENDING: 1,
  // 审核通过/处理中
  APPROVED: 2,
  // 已打款
  PAID: 3,
  // 已拒绝
  REJECTED: 4
}

// 提现状态映射
export const WITHDRAW_STATUS_MAP = {
  [WITHDRAW_STATUS.PENDING]: { label: '待审核', color: '#FAAD14' },
  [WITHDRAW_STATUS.APPROVED]: { label: '处理中', color: '#1890FF' },
  [WITHDRAW_STATUS.PAID]: { label: '已打款', color: '#52C41A' },
  [WITHDRAW_STATUS.REJECTED]: { label: '已拒绝', color: '#FF4D4F' }
}

// 分销层级
export const DISTRIBUTION_LEVEL = {
  // 一级分销
  LEVEL_1: 1,
  // 二级分销
  LEVEL_2: 2
}

// 最低提现金额（元）
export const MIN_WITHDRAW_AMOUNT = 10

// 提现手续费率
export const WITHDRAW_FEE_RATE = 0.01

// 分享奖励类型
export const SHARE_REWARD_TYPE = {
  // 分享返券
  COUPON: 1,
  // 拉新奖励
  INVITE: 2,
  // 成长值奖励
  GROWTH: 3
}
