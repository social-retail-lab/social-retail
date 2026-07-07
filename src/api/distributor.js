// 分销员管理接口（5.1 分销员管理）
// 包含：5.1.1 分销员申请、5.1.2 申请结果、5.1.3 分销中心首页

import request from './base'

// ============ 5.1.1 分销员申请 ============
// POST /api/distributor/apply
// 提交分销员申请，上传实名认证信息及银行卡信息
export const applyDistributorApi = (data) => {
  return request({
    url: '/api/distributor/apply',
    method: 'post',
    data
  })
}

// ============ 5.1.2 分销员申请结果 ============
// GET /api/distributor/status
// 查询当前用户分销员申请状态及审核结果
export const getDistributorStatusApi = () => {
  return request({
    url: '/api/distributor/status',
    method: 'get'
  })
}

// ============ 5.1.3 分销中心首页 ============
// GET /api/distributor/dashboard
// 查询分销员首页统计信息（佣金、推广商品数量、推广订单数据）
export const getDistributorDashboardApi = () => {
  return request({
    url: '/api/distributor/dashboard',
    method: 'get'
  })
}

// ============================================================
// 5.2 推广管理
// ============================================================

// ============ 5.2.1 可推广商品列表 ============
// GET /api/distributor/products
// 查询所有商家已开启分销的商品，供分销员选择推广
export const getPromotionProductsApi = (params) => {
  return request({
    url: '/api/distributor/products',
    method: 'get',
    params
  })
}

// ============ 5.2.2 申请推广商品分销 ============
// POST /api/distributor/products/{distributionProductId}/promote
// 分销员申请推广指定商品，系统生成推广记录
export const promoteProductApi = (distributionProductId) => {
  return request({
    url: `/api/distributor/products/${distributionProductId}/promote`,
    method: 'post'
  })
}

// ============ 5.2.3 生成推广链接 ============
// POST /api/distributor/share-link
// 根据推广商品生成推广链接及二维码
export const generateShareLinkApi = (data) => {
  return request({
    url: '/api/distributor/share-link',
    method: 'post',
    data
  })
}

// ============ 5.2.4 我的推广商品列表 ============
// GET /api/distributor/my-products
// 分页查询当前分销员已推广的商品列表
export const getMyPromotionProductsApi = (params) => {
  return request({
    url: '/api/distributor/my-products',
    method: 'get',
    params
  })
}

// ============ 5.2.5 我的推广商品详情 ============
// GET /api/distributor/my-products/{distributorProductId}
// 查询当前分销员某个已推广商品的详情（含推广码、链接、二维码、佣金记录）
export const getMyPromotionProductDetailApi = (distributorProductId) => {
  return request({
    url: `/api/distributor/my-products/${distributorProductId}`,
    method: 'get'
  })
}

// ============ 5.2.6 取消推广商品 ============
// PATCH /api/distributor/my-products/{distributorProductId}/disable
// 当前分销员取消推广某个已推广商品（状态变为停用）
export const disablePromotionProductApi = (distributorProductId) => {
  return request({
    url: `/api/distributor/my-products/${distributorProductId}/disable`,
    method: 'patch'
  })
}

// ============ 5.2.7 恢复推广商品 ============
// PATCH /api/distributor/my-products/{distributorProductId}/enable
// 当前分销员恢复推广某个已停用的推广商品（推广链接和二维码重新有效）
export const enablePromotionProductApi = (distributorProductId) => {
  return request({
    url: `/api/distributor/my-products/${distributorProductId}/enable`,
    method: 'patch'
  })
}

// ============================================================
// 5.3 佣金管理
// ============================================================

// ============ 5.3.1 推广订单列表 ============
// GET /api/distributor/orders
// 分页查询当前分销员推广产生的订单列表（含佣金金额、结算状态）
// params: { status, keyword, page, pageSize }
export const getDistributorOrdersApi = (params) => {
  return request({
    url: '/api/distributor/orders',
    method: 'get',
    params
  })
}

// ============ 5.3.2 佣金明细 ============
// GET /api/distributor/commission/detail
// 查询当前分销员的佣金明细（订单维度），包含待结算与已结算佣金记录
// params: { page, size, status }
export const getCommissionDetailApi = (params) => {
  return request({
    url: '/api/distributor/commission/detail',
    method: 'get',
    params
  })
}

// ============ 5.3.3 佣金提现申请 ============
// POST /api/distributor/withdraw/apply
// 分销员申请提现，将可提现佣金转入提现申请记录
// data: { amount, bankName, bankCardNo, accountName }
export const applyWithdrawApi = (data) => {
  return request({
    url: '/api/distributor/withdraw/apply',
    method: 'post',
    data
  })
}

// ============ 5.3.4 提现记录 ============
// GET /api/distributor/withdraw/records
// 查询当前分销员提现记录列表
// params: { page, size, status }
export const getWithdrawRecordsApi = (params) => {
  return request({
    url: '/api/distributor/withdraw/records',
    method: 'get',
    params
  })
}
