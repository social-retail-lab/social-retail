// 会员、积分、成长值接口
// 四层架构：API层只负责HTTP通信，无业务逻辑

import request from './base'

// ============ 会员等级模块 ============

// 获取会员信息（首页核心）
export const getMemberInfoApi = () => {
  return request({
    url: '/api/member/info',
    method: 'get'
  }).then(response => {
    if (response.code === 0 && response.data) {
      return {
        ...response,
        data: normalizeMemberInfoData(response.data)
      }
    }
    return response
  })
}

// 会员信息字段规范化（以接口文档6.1.1为准）
const normalizeMemberInfoData = (data) => {
  if (!data) return null
  // 接口字段：memberLevel, memberLevelName, pointsBalance, growthValue, nextLevel{...}, benefits[]
  const nextLevel = data.nextLevel || null
  return {
    ...data,
    userId: data.userId || null,
    memberLevel: Number(data.memberLevel ?? 0),
    memberLevelName: data.memberLevelName || data.levelName || '普通会员',
    levelName: data.memberLevelName || data.levelName || '普通会员',
    levelId: Number(data.memberLevel ?? 0),
    pointsBalance: Number(data.pointsBalance ?? 0),
    growthValue: Number(data.growthValue ?? 0),
    // 下一等级信息（接口返回 nextLevel 对象）
    nextLevel,
    nextLevelGrowth: nextLevel ? Number(nextLevel.requiredGrowthValue ?? 0) : 0,
    nextLevelNeedGrowth: nextLevel ? Number(nextLevel.needGrowthValue ?? 0) : 0,
    // 当前等级权益
    benefits: Array.isArray(data.benefits) ? data.benefits : []
  }
}

// 获取会员等级列表（等级规则页，接口文档6.1.2）
export const getMemberLevelsApi = () => {
  return request({
    url: '/api/member/levels',
    method: 'get'
  }).then(response => {
    if (response.code === 0 && response.data) {
      return {
        ...response,
        data: normalizeMemberLevelsData(response.data)
      }
    }
    return response
  })
}

// 会员等级列表数据规范化
const normalizeMemberLevelsData = (data) => {
  if (!data) return null
  return {
    currentLevel: Number(data.currentLevel ?? 0),
    currentLevelName: data.currentLevelName || '普通会员',
    growthValue: Number(data.growthValue ?? 0),
    list: Array.isArray(data.list) ? data.list.map(item => ({
      memberLevel: Number(item.memberLevel ?? 0),
      memberLevelName: item.memberLevelName || item.levelName || '普通会员',
      levelName: item.memberLevelName || item.levelName || '普通会员',
      requiredGrowthValue: Number(item.requiredGrowthValue ?? 0),
      description: item.description || '',
      benefits: Array.isArray(item.benefits) ? item.benefits.map(b => ({
        benefitCode: b.benefitCode || '',
        benefitName: b.benefitName || '',
        description: b.description || ''
      })) : []
    })) : []
  }
}

// ============ 积分体系模块 ============

// 获取积分余额（备用）
export const getPointsBalanceApi = () => {
  return request({
    url: '/api/points/balance',
    method: 'get'
  })
}

// 获取积分明细列表（分页）
export const getPointsLogsApi = (params) => {
  return request({
    url: '/api/points/logs',
    method: 'get',
    params
  })
}

// 查询当日签到状态
export const getSignInStatusApi = () => {
  return request({
    url: '/api/points/sign-in/status',
    method: 'get'
  })
}

// 执行每日签到
export const signInApi = () => {
  return request({
    url: '/api/points/sign-in',
    method: 'post'
  })
}

// 获取可兑换优惠券列表
export const getExchangeCouponsApi = (params) => {
  return request({
    url: '/api/points/exchange/coupons',
    method: 'get',
    params: {
      page: Number(params?.page) || 1,
      pageSize: Number(params?.pageSize) || 10
    }
  })
}

// 积分兑换优惠券
export const exchangeCouponApi = (data) => {
  return request({
    url: '/api/points/exchange/coupon',
    method: 'post',
    data
  })
}

// 积分抵扣试算（订单确认页联动）
export const calculateDeductionApi = (data) => {
  return request({
    url: '/api/points/calculate-deduction',
    method: 'post',
    data
  })
}

// ============ 成长值模块 ============

// 获取成长值明细列表（分页）
export const getGrowthLogsApi = (params) => {
  return request({
    url: '/api/growth/logs',
    method: 'get',
    params: {
      page: params?.page || 1,
      pageSize: params?.pageSize || 10,
      type: params?.type || undefined
    }
  })
}
