import request from '@/utils/request'

export const getSeckillList = (params: {
  status?: string
  page?: number
  pageSize?: number
}) => {
  return request.get('/admin/seckill-activities', { params })
}

export const getSeckillDetail = (activityId: number) => {
  return request.get(`/admin/seckill-activities/${activityId}`)
}

export const createSeckill = (data: {
  activityName: string
  startTime: string
  endTime: string
  productId: number
  skuId: number
  seckillPrice: number
  seckillStock: number
}) => {
  return request.post('/admin/seckill-activities', data)
}

export const updateSeckill = (activityId: number, data: {
  activityName?: string
  startTime?: string
  endTime?: string
  seckillPrice?: number
  seckillStock?: number
}) => {
  return request.put(`/admin/seckill-activities/${activityId}`, data)
}

export const deleteSeckill = (activityId: number) => {
  return request.delete(`/admin/seckill-activities/${activityId}`)
}

export const updateSeckillStatus = (activityId: number, data: { status: string }) => {
  return request.patch(`/admin/seckill-activities/${activityId}/status`, data)
}

export const getCouponList = (params: {
  status?: string
  page?: number
  pageSize?: number
}) => {
  return request.get('/admin/coupons', { params })
}

export const getCouponDetail = (couponId: number) => {
  return request.get(`/admin/coupons/${couponId}`)
}

export const createCoupon = (data: {
  couponName: string
  couponType: string
  discountAmount?: number
  discountRate?: number
  minConsume?: number
  totalQuantity: number
  perLimit: number
  startTime: string
  endTime: string
}) => {
  return request.post('/admin/coupons', data)
}

export const updateCoupon = (couponId: number, data: {
  couponName?: string
  discountAmount?: number
  discountRate?: number
  minConsume?: number
  totalQuantity?: number
  perLimit?: number
  startTime?: string
  endTime?: string
}) => {
  return request.put(`/admin/coupons/${couponId}`, data)
}

export const deleteCoupon = (couponId: number) => {
  return request.delete(`/admin/coupons/${couponId}`)
}

export const updateCouponStatus = (couponId: number, data: { status: string }) => {
  return request.patch(`/admin/coupons/${couponId}/status`, data)
}

export const getDistributionConfig = () => {
  return request.get('/admin/distribution/config')
}

export const updateDistributionConfig = (data: {
  enabled: boolean
  firstLevelRate?: number
  secondLevelRate?: number
  minWithdrawAmount?: number
}) => {
  return request.put('/admin/distribution/config', data)
}