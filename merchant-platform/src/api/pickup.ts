import request from '@/utils/request'

export const getPickupPoints = (params: {
  page?: number
  pageSize?: number
}) => {
  return request.get('/merchant/pickup-points', { params })
}

export const getPickupPointDetail = (pickupPointId: number) => {
  return request.get(`/merchant/pickup-points/${pickupPointId}`)
}

export const createPickupPoint = (data: {
  name: string
  address: string
  phone: string
  startTime?: string
  endTime?: string
}) => {
  return request.post('/merchant/pickup-points', data)
}

export const updatePickupPoint = (pickupPointId: number, data: {
  name?: string
  address?: string
  phone?: string
  startTime?: string
  endTime?: string
}) => {
  return request.put(`/merchant/pickup-points/${pickupPointId}`, data)
}

export const deletePickupPoint = (pickupPointId: number) => {
  return request.delete(`/merchant/pickup-points/${pickupPointId}`)
}

export const verifyPickup = (data: {
  orderSn: string
  verifyCode: string
}) => {
  return request.post('/merchant/pickup/verify', data)
}