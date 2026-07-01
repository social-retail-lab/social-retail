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

// 通过订单详情获取pickupCode后调用
export const confirmPickup = (orderId: number) => {
  return request.post(`/merchant/pickup/confirm/${orderId}`)
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
