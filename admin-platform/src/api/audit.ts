import request from '@/utils/request'

export const getMerchantAuditList = (params: {
  status?: string
  page?: number
  pageSize?: number
  keyword?: string
}) => {
  return request.get('/admin/merchant/applications', { params })
}

export const getMerchantDetail = (applyId: number) => {
  return request.get(`/admin/merchant/applications/${applyId}`)
}

export const auditMerchant = (applyId: number, data: {
  auditStatus: number
  auditRemark?: string
}) => {
  return request.post(`/admin/merchant/applications/${applyId}/audit`, data)
}

export const getProductAuditList = (params: {
  status?: string
  page?: number
  pageSize?: number
  keyword?: string
}) => {
  return request.get('/admin/products/audits', { params })
}

export const getProductDetail = (productId: number) => {
  return request.get(`/admin/products/${productId}`)
}

export const auditProduct = (productId: number, data: {
  auditStatus: number
  auditRemark?: string
}) => {
  return request.post(`/admin/products/${productId}/audit`, data)
}