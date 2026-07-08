import request from '@/utils/request'

// 自提点列表
export const getPickupPoints = () => {
  return request.get('/merchant/pickup-points')
}

// 新增自提点（提交后待审核）
export const createPickupPoint = (data: { name: string; address: string; contactPhone: string; image: string }) => {
  return request.post('/merchant/pickup-points', data)
}

// 删除自提点
export const deletePickupPoint = (pointId: number) => {
  return request.delete(`/merchant/pickup-points/${pointId}`)
}

// 核销取货码
export const verifyPickup = (data: { pickupCode: string }) => {
  return request.post('/merchant/pickup/verify', data)
}

// 核销记录
export const getPickupRecords = (params: { startDate?: string; endDate?: string; pageNum?: number; pageSize?: number }) => {
  return request.get('/merchant/pickup/records', { params })
}
