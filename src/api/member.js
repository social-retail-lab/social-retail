// 会员、积分、成长值接口
// 四层架构：API层只负责HTTP通信，无业务逻辑

import request from './base'

// ============ 会员等级模块 ============

// 获取会员信息（首页核心）
export const getMemberInfoApi = () => {
  return request({
    url: '/api/member/info',
    method: 'get'
  })
}

// 获取会员等级列表（等级规则页）
export const getMemberLevelsApi = () => {
  return request({
    url: '/api/member/levels',
    method: 'get'
  })
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
export const getExchangeCouponsApi = () => {
  return request({
    url: '/api/points/exchange/coupons',
    method: 'get'
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
