import request from '@/utils/request'

export const getAfterSaleList = (params: { type?: number; status?: number; orderSn?: string; pageNum?: number; pageSize?: number }) => {
  return request.get('/merchant/after-sales', { params })
}

export const getAfterSaleDetail = (afterSaleId: number) => {
  return request.get(`/merchant/after-sales/${afterSaleId}`)
}

// action: 1-同意 2-拒绝
export const auditAfterSale = (afterSaleId: number, data: { action: number; remark?: string; actualRefundAmount?: number }) => {
  return request.post(`/merchant/after-sales/${afterSaleId}/audit`, data)
}

// 退货收货确认: receivedStatus: 1-确认收货 2-收货异常
export const confirmReturn = (afterSaleId: number, data: { receivedStatus: number; remark?: string }) => {
  return request.post(`/merchant/after-sales/${afterSaleId}/return-confirm`, data)
}

// 补充反馈
export const submitFeedback = (afterSaleId: number, data: { content: string; images?: string[] }) => {
  return request.post(`/merchant/after-sales/${afterSaleId}/feedback`, data)
}
