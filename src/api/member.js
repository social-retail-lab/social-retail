// 会员、积分、成长值接口
// 包含：会员等级、积分明细、积分商城、成长值明细

import request from './base'

// 获取会员信息
export const getMemberInfo = () => {
  return request({
    url: '/api/member/info',
    method: 'get'
  })
}

// 获取会员等级列表
export const getMemberLevelList = () => {
  return request({
    url: '/api/member/level-list',
    method: 'get'
  })
}

// 获取会员权益
export const getMemberEquity = () => {
  return request({
    url: '/api/member/equity',
    method: 'get'
  })
}

// 获取积分明细
export const getPointDetail = (params) => {
  return request({
    url: '/api/point/detail',
    method: 'get',
    params
  })
}

// 获取积分商城商品
export const getPointMallGoods = (params) => {
  return request({
    url: '/api/point/mall',
    method: 'get',
    params
  })
}

// 积分兑换
export const pointExchange = (data) => {
  return request({
    url: '/api/point/exchange',
    method: 'post',
    data
  })
}

// 获取成长值明细
export const getGrowthDetail = (params) => {
  return request({
    url: '/api/growth/detail',
    method: 'get',
    params
  })
}

// 获取成长值规则
export const getGrowthRule = () => {
  return request({
    url: '/api/growth/rule',
    method: 'get'
  })
}

// 签到
export const signIn = () => {
  return request({
    url: '/api/member/sign-in',
    method: 'post'
  })
}
