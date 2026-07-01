import request from '@/utils/request'

export const merchantLogin = (data: { phone: string; password: string }) => {
  return request.post('/merchant/auth/login', data)
}

export const getMerchantInfo = () => {
  return request.get('/merchant/info')
}

export const getEarningsInfo = () => {
  return request.get('/merchant/earnings')
}

export const getEarningsList = (params: {
  status?: string
  page?: number
  pageSize?: number
}) => {
  return request.get('/merchant/earnings/list', { params })
}

export const applyWithdraw = (data: {
  amount: number
  bankName: string
  bankCardNumber: string
  accountName: string
}) => {
  return request.post('/merchant/earnings/withdraw', data)
}

export const getWithdrawRecords = (params: {
  page?: number
  pageSize?: number
}) => {
  return request.get('/merchant/earnings/withdraw-records', { params })
}

export const getOrderList = (params: {
  status?: string
  page?: number
  pageSize?: number
  keyword?: string
}) => {
  return request.get('/merchant/orders', { params })
}

export const getOrderDetail = (orderId: number) => {
  return request.get(`/merchant/orders/${orderId}`)
}

export const acceptOrder = (orderId: number) => {
  return request.post(`/merchant/orders/${orderId}/accept`)
}

export const prepareOrder = (orderId: number) => {
  return request.post(`/merchant/orders/${orderId}/prepare`)
}

export const confirmDelivery = (orderId: number, data: {
  logisticsCompany?: string
  trackingNumber?: string
}) => {
  return request.post(`/merchant/orders/${orderId}/delivery`, data)
}

export const confirmPickup = (orderId: number) => {
  return request.post(`/merchant/orders/${orderId}/pickup`)
}

export const cancelOrder = (orderId: number, data: { reason?: string }) => {
  return request.post(`/merchant/orders/${orderId}/cancel`, data)
}