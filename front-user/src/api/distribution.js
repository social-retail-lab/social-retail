// 一级分销、佣金接口
// 包含：分销员申请、佣金记录、佣金提现、分享海报、分享数据

import request from './base'

// 分销员申请
export const applyDistribution = (data) => {
  return request({
    url: '/api/distribution/apply',
    method: 'post',
    data
  })
}

// 获取分销员状态
export const getDistributionStatus = () => {
  return request({
    url: '/api/distribution/status',
    method: 'get'
  })
}

// 获取佣金记录
export const getCommissionRecord = (params) => {
  return request({
    url: '/api/commission/list',
    method: 'get',
    params
  })
}

// 获取佣金统计
export const getCommissionStats = () => {
  return request({
    url: '/api/commission/stats',
    method: 'get'
  })
}

// 提现申请
export const applyWithdraw = (data) => {
  return request({
    url: '/api/commission/withdraw',
    method: 'post',
    data
  })
}

// 获取提现记录
export const getWithdrawRecord = (params) => {
  return request({
    url: '/api/commission/withdraw-list',
    method: 'get',
    params
  })
}

// 生成推广海报
export const generatePoster = (data) => {
  return request({
    url: '/api/distribution/poster',
    method: 'post',
    data
  })
}

// 获取分享数据
export const getShareData = (params) => {
  return request({
    url: '/api/distribution/share-data',
    method: 'get',
    params
  })
}

// 获取专属推广链接
export const getShareLink = (data) => {
  return request({
    url: '/api/distribution/share-link',
    method: 'post',
    data
  })
}
