// 我的优惠券接口(4.3.3)
// 统一查询当前用户拥有的平台券和商家券
// 订单可用优惠券接口(4.3.4)

import request from './base'
import { normalizeAvailableCouponsData } from '@/constants/coupon'

/**
 * 规范化我的优惠券列表项数据(4.3.3)
 */
const normalizeMyCouponItem = (item) => ({
  couponUserId: item.couponUserId || null,
  couponId: item.couponId || null,
  source: item.source || '',
  sourceText: item.sourceText || '',
  merchantId: item.merchantId || null,
  merchantName: item.merchantName || '',
  title: item.title || '',
  type: Number(item.type ?? 0),
  typeText: item.typeText || '',
  minConsume: Number(item.minConsume ?? 0),
  discountAmount: Number(item.discountAmount ?? 0),
  status: Number(item.status ?? 0),
  statusText: item.statusText || '',
  receiveTime: item.receiveTime || '',
  useTime: item.useTime || '',
  validStart: item.validStart || '',
  validEnd: item.validEnd || ''
})

/**
 * 规范化我的优惠券列表响应数据(4.3.3)
 */
const normalizeMyCouponListData = (data) => {
  if (!data) return { list: [], total: 0, pages: 0, page: 1, pageSize: 10 }
  return {
    list: Array.isArray(data.list) ? data.list.map(normalizeMyCouponItem) : [],
    total: Number(data.total) || 0,
    pages: Number(data.pages) || 0,
    page: Number(data.page) || 1,
    pageSize: Number(data.pageSize) || 10
  }
}

/**
 * 4.3.3 我的优惠券(包括商家优惠券和平台优惠券)
 * GET /api/coupons/my
 * 查询当前用户已拥有的优惠券列表,统一展示用户券包
 *
 * @param {Object} params
 *   - source {String} 优惠券来源:PLATFORM 平台券,MERCHANT 商家券;为空表示全部
 *   - status {Number} 状态:0未使用,1已使用,2已过期
 *   - merchantId {Number|String} 商家ID,查询指定商家优惠券时传入
 *   - page {Number} 页码,默认 1
 *   - pageSize {Number} 每页数量,默认 10
 */
export const getMyCouponsApi = (params = {}) => {
  // 仅传递非空参数,避免发送空字符串
  const validatedParams = {
    page: Number(params?.page) || 1,
    pageSize: Number(params?.pageSize) || 10
  }
  if (params?.source) {
    validatedParams.source = params.source
  }
  if (params?.status !== undefined && params?.status !== null && params?.status !== '') {
    validatedParams.status = Number(params.status)
  }
  if (params?.merchantId) {
    validatedParams.merchantId = params.merchantId
  }
  return request({
    url: '/api/coupons/my',
    method: 'get',
    params: validatedParams
  }).then(response => {
    if (response.code === 0) {
      return {
        ...response,
        data: response.data ? normalizeMyCouponListData(response.data) : null
      }
    }
    return response
  }).catch(error => {
    console.error('获取我的优惠券列表失败:', error)
    throw error
  })
}

/**
 * 4.3.4 预览订单可用优惠券
 * POST /api/orders/available-coupons
 * 根据本次结算选择的购物车商品,查询可用于本次结算的平台优惠券和商家优惠券列表
 * 不创建订单、不锁定库存、不核销优惠券
 *
 * @param {Array<Number|String>} cartItemIds 购物车明细ID列表
 */
export const getAvailableCouponsApi = (cartItemIds) => {
  // 参数校验
  if (!Array.isArray(cartItemIds) || cartItemIds.length === 0) {
    return Promise.reject(new Error('购物车明细ID列表不能为空'))
  }
  // 过滤无效值并转为数字
  const validIds = cartItemIds
    .map(id => Number(id))
    .filter(id => !isNaN(id) && id > 0)

  if (validIds.length === 0) {
    return Promise.reject(new Error('购物车明细ID列表不能为空'))
  }

  return request({
    url: '/api/orders/available-coupons',
    method: 'post',
    data: { cartItemIds: validIds }
  }).then(response => {
    if (response.code === 0) {
      return {
        ...response,
        data: normalizeAvailableCouponsData(response.data)
      }
    }
    return response
  }).catch(error => {
    console.error('获取订单可用优惠券失败:', error)
    throw error
  })
}
