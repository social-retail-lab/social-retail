// 会员等级、积分规则常量
// 会员体系相关常量定义

// 会员等级
export const MEMBER_LEVEL = {
  // 普通用户
  NORMAL: 0,
  // 白银会员
  SILVER: 1,
  // 黄金会员
  GOLD: 2,
  // 铂金会员
  PLATINUM: 3,
  // 钻石会员
  DIAMOND: 4,
  // 至尊会员
  SUPREME: 5
}

// 会员等级映射
export const MEMBER_LEVEL_MAP = {
  [MEMBER_LEVEL.NORMAL]: { label: '普通用户', color: '#999999', icon: '' },
  [MEMBER_LEVEL.SILVER]: { label: '白银会员', color: '#C0C0C0', icon: '' },
  [MEMBER_LEVEL.GOLD]: { label: '黄金会员', color: '#FFD700', icon: '' },
  [MEMBER_LEVEL.PLATINUM]: { label: '铂金会员', color: '#E5E4E2', icon: '' },
  [MEMBER_LEVEL.DIAMOND]: { label: '钻石会员', color: '#B9F2FF', icon: '' },
  [MEMBER_LEVEL.SUPREME]: { label: '至尊会员', color: '#FF69B4', icon: '' }
}

// 会员等级成长值门槛
export const MEMBER_LEVEL_THRESHOLD = {
  [MEMBER_LEVEL.NORMAL]: 0,
  [MEMBER_LEVEL.SILVER]: 1000,
  [MEMBER_LEVEL.GOLD]: 5000,
  [MEMBER_LEVEL.DIAMOND]: 10000
}

// 会员等级列表（按顺序）
export const MEMBER_LEVEL_LIST = [
  { level: MEMBER_LEVEL.NORMAL, name: '普通会员', threshold: 0 },
  { level: MEMBER_LEVEL.SILVER, name: '银卡会员', threshold: 1000 },
  { level: MEMBER_LEVEL.GOLD, name: '金卡会员', threshold: 5000 },
  { level: MEMBER_LEVEL.DIAMOND, name: '钻石会员', threshold: 10000 }
]

// 根据成长值获取当前等级
export const getLevelByGrowth = (growthValue) => {
  const growth = Number(growthValue) || 0
  let currentLevel = MEMBER_LEVEL.NORMAL
  for (const item of MEMBER_LEVEL_LIST) {
    if (growth >= item.threshold) {
      currentLevel = item.level
    }
  }
  return currentLevel
}

// 获取下一级信息
export const getNextLevelInfo = (growthValue) => {
  const growth = Number(growthValue) || 0
  const currentLevel = getLevelByGrowth(growth)
  const currentIndex = MEMBER_LEVEL_LIST.findIndex(item => item.level === currentLevel)
  if (currentIndex < MEMBER_LEVEL_LIST.length - 1) {
    const nextLevel = MEMBER_LEVEL_LIST[currentIndex + 1]
    return {
      level: nextLevel.level,
      name: nextLevel.name,
      threshold: nextLevel.threshold,
      needGrowth: Math.max(0, nextLevel.threshold - growth)
    }
  }
  return null
}

// 会员权益
export const MEMBER_EQUITY = {
  // 折扣
  DISCOUNT: 'discount',
  // 包邮
  FREE_SHIPPING: 'free_shipping',
  // 专属客服
  VIP_SERVICE: 'vip_service',
  // 生日礼包
  BIRTHDAY_GIFT: 'birthday_gift',
  // 专属活动
  VIP_ACTIVITY: 'vip_activity'
}

// 会员权益映射
export const MEMBER_EQUITY_MAP = {
  [MEMBER_EQUITY.DISCOUNT]: { label: '会员折扣', description: '享受专属折扣优惠' },
  [MEMBER_EQUITY.FREE_SHIPPING]: { label: '包邮特权', description: '订单满额包邮' },
  [MEMBER_EQUITY.VIP_SERVICE]: { label: '专属客服', description: '一对一专属客服' },
  [MEMBER_EQUITY.BIRTHDAY_GIFT]: { label: '生日礼包', description: '生日专属礼包' },
  [MEMBER_EQUITY.VIP_ACTIVITY]: { label: '专属活动', description: '优先参与会员活动' }
}

// 积分规则
export const POINT_RULE = {
  // 消费1元获得积分
  CONSUME_RATE: 1,
  // 评价获得积分
  REVIEW_POINT: 10,
  // 晒单获得积分
  SHARE_POINT: 20,
  // 签到获得积分
  SIGN_IN_POINT: 5,
  // 分享获得积分
  SHARE_REWARD_POINT: 10,
  // 拉新获得积分
  INVITE_POINT: 50
}

// 积分过期天数
export const POINT_EXPIRE_DAYS = 365

// 成长值规则
export const GROWTH_RULE = {
  // 消费1元获得成长值
  CONSUME_RATE: 1,
  // 评价获得成长值
  REVIEW_GROWTH: 10,
  // 晒单获得成长值
  SHARE_GROWTH: 20,
  // 签到获得成长值
  SIGN_IN_GROWTH: 5,
  // 分享获得成长值
  SHARE_REWARD_GROWTH: 10,
  // 拉新获得成长值
  INVITE_GROWTH: 50
}

// 会员折扣规则
export const MEMBER_DISCOUNT = {
  [MEMBER_LEVEL.NORMAL]: 1,
  [MEMBER_LEVEL.SILVER]: 0.98,
  [MEMBER_LEVEL.GOLD]: 0.95,
  [MEMBER_LEVEL.PLATINUM]: 0.92,
  [MEMBER_LEVEL.DIAMOND]: 0.9,
  [MEMBER_LEVEL.SUPREME]: 0.85
}

// 包邮门槛（元）
export const FREE_SHIPPING_THRESHOLD = {
  [MEMBER_LEVEL.NORMAL]: 99,
  [MEMBER_LEVEL.SILVER]: 89,
  [MEMBER_LEVEL.GOLD]: 79,
  [MEMBER_LEVEL.PLATINUM]: 69,
  [MEMBER_LEVEL.DIAMOND]: 59,
  [MEMBER_LEVEL.SUPREME]: 0
}
