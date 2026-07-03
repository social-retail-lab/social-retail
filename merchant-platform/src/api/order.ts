import request from '@/utils/request'

// ========== 登录/商家信息 ==========
export const merchantLogin = (data: { phone: string; password: string }) => {
  return request.post('/merchant/auth/login', data)
}

export const getMerchantInfo = () => {
  return request.get('/merchant/info')
}

// ========== 订单 ==========
export const getOrderList = (params: {
  status?: number
  deliveryType?: number
  orderSn?: string
  startDate?: string
  endDate?: string
  pageNum?: number
  pageSize?: number
}) => {
  return request.get('/merchant/orders', { params })
}

export const getOrderDetail = (orderId: number) => {
  return request.get(`/merchant/orders/${orderId}`)
}

export const acceptOrder = (orderId: number, remark?: string) => {
  return request.post(`/merchant/orders/${orderId}/accept`, { remark })
}

export const prepareOrder = (orderId: number, remark?: string) => {
  return request.post(`/merchant/orders/${orderId}/prepare`, { remark })
}

export const shipOrder = (orderId: number, data?: { dispatcherName?: string; dispatcherPhone?: string; remark?: string }) => {
  return request.post(`/merchant/orders/${orderId}/ship`, data || {})
}

export const cancelOrder = (orderId: number, reason?: string) => {
  return request.post(`/merchant/orders/${orderId}/cancel`, { reason })
}

// 配送详情
export const getDeliveryDetail = (deliveryId: number) => {
  return request.get(`/merchant/deliveries/${deliveryId}`)
}

export const updateDeliveryStatus = (deliveryId: number, status: number) => {
  return request.patch(`/merchant/deliveries/${deliveryId}/status`, { status })
}

// ========== 商家信息变更 ==========
export const requestInfoChange = (data: {
  merchantName?: string
  contactName?: string
  contactPhone?: string
  shopAddress?: string
  businessHours?: string
  introduction?: string
}) => {
  return request.post('/merchant/info/change', data)
}

export const requestQualificationUpgrade = (data: any) => {
  return request.post('/merchant/qualification/upgrade', data)
}

export const togglePause = () => {
  return request.patch('/merchant/pause')
}

// ========== 审核请求 ==========
export const getAuditRequests = (params: { pageNum?: number; pageSize?: number }) => {
  return request.get('/merchant/audit-requests', { params })
}

export const getAuditRequestDetail = (id: number, requestType: string) => {
  return request.get(`/merchant/audit-requests/${id}/detail`, { params: { requestType } })
}

export const withdrawAuditRequest = (id: number, requestType: string) => {
  return request.post(`/merchant/audit-requests/${id}/withdraw`, { requestType })
}

// ========== 收益 ==========
export const getEarningsInfo = () => {
  return request.get('/merchant/earnings')
}

export const getEarningsList = (params: { status?: number; pageNum?: number; pageSize?: number }) => {
  return request.get('/merchant/earnings', { params })
}

export const applyWithdraw = (data: { bankCardNumber: string; accountName: string; bankName: string }) => {
  return request.post('/merchant/earnings/withdraw', data)
}

// ========== 自提核销 ==========
// 核销码验证
export const pickupVerify = (pickupCode: string) => {
  return request.post('/merchant/pickup/verify', { pickupCode })
}

// 订单管理内确认自提（传自提码，支持万能码111111）
export const confirmPickupCode = (orderId: number, pickupCode: string) => {
  return request.post(`/merchant/pickup/confirm/${orderId}`, { pickupCode })
}

// ========== 自提点管理 ==========
export const getPickupPoints = () => {
  return request.get('/merchant/pickup-points')
}

export const addPickupPoint = (data: { name: string; address: string; contactPhone?: string; image?: string }) => {
  return request.post('/merchant/pickup-points', data)
}

export const deletePickupPoint = (pointId: number) => {
  return request.delete(`/merchant/pickup-points/${pointId}`)
}

export const getWithdrawRecords = (params: { pageNum?: number; pageSize?: number }) => {
  return request.get('/merchant/earnings/withdraw-records', { params })
}

// ========== 促销 ==========
export const getPlatformPromotions = () => request.get('/merchant/promotions/platform')
export const joinPromotion = (promotionId: number) => request.post(`/merchant/promotions/platform/${promotionId}/join`)
export const quitPromotion = (promotionId: number) => request.post(`/merchant/promotions/platform/${promotionId}/quit`)
export const getMerchantCoupons = () => request.get('/merchant/promotions/coupons')
export const createMerchantCoupon = (data: any) => request.post('/merchant/promotions/coupons', data)
export const updateMerchantCoupon = (id: number, data: any) => request.put(`/merchant/promotions/coupons/${id}`, data)
export const disableMerchantCoupon = (id: number) => request.post(`/merchant/promotions/coupons/${id}/disable`)
export const enableMerchantCoupon = (id: number) => request.post(`/merchant/promotions/coupons/${id}/enable`)

// ========== 秒杀 ==========
// 秒杀活动列表（已发布）
export const getSeckillActivities = () => request.get('/merchant/seckill/activities')
// 活动下的我的商品
export const getSeckillProducts = (activityId: number) => request.get(`/merchant/seckill/activities/${activityId}/products`)
// 添加秒杀商品
export const addSeckillProduct = (activityId: number, data: { productId: number; skuId: number; seckillPrice: number; seckillStock: number; limitQuantity?: number }) => request.post(`/merchant/seckill/activities/${activityId}/products`, data)
// 更新秒杀商品
export const updateSeckillProduct = (productId: number, data: { seckillPrice?: number; seckillStock?: number; limitQuantity?: number }) => request.put(`/merchant/seckill/products/${productId}`, data)
// 删除秒杀商品
export const deleteSeckillProduct = (productId: number) => request.delete(`/merchant/seckill/products/${productId}`)
