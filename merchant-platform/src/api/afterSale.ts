import request from '@/utils/request'

export const getAfterSaleList = (params: {
  status?: string
  page?: number
  pageSize?: number
  keyword?: string
}) => {
  return request.get('/merchant/after-sales', { params })
}

export const getAfterSaleDetail = (afterSaleId: number) => {
  return request.get(`/merchant/after-sales/${afterSaleId}`)
}

export const handleAfterSale = (afterSaleId: number, data: {
  status: string
  reason?: string
  refundAmount?: number
}) => {
  return request.post(`/merchant/after-sales/${afterSaleId}/handle`, data)
}