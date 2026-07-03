// 秒杀、优惠券、满减接口
// 包含：秒杀活动、优惠券领取、优惠券查询、满减规则

import request from './base'

// ============ 轮播图接口 ============

// 获取轮播图列表
export const getBannerList = (params) => {
  return request({
    url: '/api/promotion/banner-list',
    method: 'get',
    params
  })
}

// ============ 秒杀接口 ============

// 获取当前可展示的秒杀活动详情（预热中/进行中）
// 用户端同一时间仅展示一个秒杀活动，无需传 activityId
// 返回 data: null 表示暂无秒杀活动
export const getCurrentSeckillActivityApi = () => {
  return request({
    url: '/api/seckill/activities/current',
    method: 'get'
  })
}

// 获取当前秒杀活动下的商品列表（分页）
// 预热期和进行期均可查看商品列表；预热期 canBuy=false
// 无活动时返回空列表，不返回 404
export const getCurrentSeckillProductsApi = (params) => {
  const data = {
    page: Number(params?.page) || 1,
    pageSize: Number(params?.pageSize) || 10
  }
  return request({
    url: '/api/seckill/activities/current/products',
    method: 'get',
    data
  })
}

// 秒杀资格校验
// 判断当前用户是否具备指定秒杀商品的抢购资格
// 校验项：活动是否存在/进行中、商品是否启用、库存是否充足、是否超过限购数量
// 返回 { canBuy, reason, remainingStock, limitQuantity, alreadyBoughtQuantity }
export const checkSeckillQualificationApi = (seckillProductId) => {
  return request({
    url: `/api/seckill/products/${seckillProductId}/check`,
    method: 'get'
  })
}

// ============ 优惠券接口 ============

// 获取优惠券列表
export const getCouponList = (params) => {
  return request({
    url: '/api/coupon/list',
    method: 'get',
    params
  })
}

// 领取优惠券
export const receiveCoupon = (id) => {
  return request({
    url: `/api/coupon/receive/${id}`,
    method: 'post'
  })
}

// 获取我的优惠券
export const getMyCouponList = (params) => {
  return request({
    url: '/api/coupon/my-list',
    method: 'get',
    params
  })
}

// 使用优惠券
export const useCoupon = (data) => {
  return request({
    url: '/api/coupon/use',
    method: 'put',
    data
  })
}

// ============ 满减满折接口 ============

// 获取满减满折规则
export const getPromotionRule = () => {
  return request({
    url: '/api/promotion/rule',
    method: 'get'
  })
}

// ============ 推荐商品接口 ============

// 获取推荐商品列表
export const getRecommendGoods = (params) => {
  return request({
    url: '/api/goods/recommend',
    method: 'get',
    params
  })
}
