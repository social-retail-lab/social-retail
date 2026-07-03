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

// 获取秒杀活动列表
export const getSeckillList = () => {
  return request({
    url: '/api/seckill/list',
    method: 'get'
  })
}

// 获取秒杀活动详情（包含商品列表）
export const getSeckillActivity = () => {
  return request({
    url: '/api/seckill/activity',
    method: 'get'
  })
}

// 获取秒杀商品列表
export const getSeckillGoods = (params) => {
  return request({
    url: '/api/seckill/goods',
    method: 'get',
    params
  })
}

// 获取秒杀商品详情
export const getSeckillDetail = (id) => {
  return request({
    url: `/api/seckill/detail/${id}`,
    method: 'get'
  })
}

// 秒杀下单
export const seckillOrder = (data) => {
  return request({
    url: '/api/seckill/order',
    method: 'post',
    data
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
