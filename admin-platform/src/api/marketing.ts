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
  title: string
  startTime: string
  endTime: string
}) => {
  return request.post('/admin/seckill-activities', data)
}

export const updateSeckill = (activityId: number, data: {
  title?: string
  startTime?: string
  endTime?: string
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
  title: string
  type: string
  discountAmount?: number
  minConsume?: number
  totalCount: number
  perUserLimit: number
  exchangePoints?: number
  memberLevelRequired?: number
  validStart: string
  validEnd: string
}) => {
  return request.post('/admin/coupons', data)
}

export const updateCoupon = (couponId: number, data: {
  title?: string
  type?: string
  discountAmount?: number
  minConsume?: number
  totalCount?: number
  perUserLimit?: number
  exchangePoints?: number
  memberLevelRequired?: number
  validStart?: string
  validEnd?: string
}) => {
  return request.put(`/admin/coupons/${couponId}`, data)
}

export const deleteCoupon = (couponId: number) => {
  return request.delete(`/admin/coupons/${couponId}`)
}

export const disableCoupon = (couponId: number) => request.post(`/admin/coupons/${couponId}/disable`)
export const enableCoupon = (couponId: number) => request.post(`/admin/coupons/${couponId}/enable`)

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

// ========== 促销活动 ==========
export const getPromotionList = (params?: any) => request.get('/admin/promotions', { params })
export const createPromotion = (data: { promotion: { title: string; startTime: string; endTime: string }; tiers: { minAmount: number; discountAmount: number }[] }) => request.post('/admin/promotions', data)
export const updatePromotion = (id: number, data: { promotion: { title: string; startTime: string; endTime: string }; tiers: { minAmount: number; discountAmount: number }[] }) => request.put(`/admin/promotions/${id}`, data)
export const publishPromotion = (id: number) => request.post(`/admin/promotions/${id}/publish`)
export const closePromotion = (id: number) => request.post(`/admin/promotions/${id}/close`)
export const deletePromotion = (id: number) => request.delete(`/admin/promotions/${id}`)

// ========== 分销列表 ==========
export const getDistributionList = (params?: any) => request.get('/admin/distribution', { params })