import request from '@/utils/request'

// ========== 商家入驻审核 ==========
export const getMerchantApplies = (params: { auditStatus?: number; keyword?: string; pageNum?: number; pageSize?: number }) => {
  return request.get('/admin/operation/merchant/applications', { params })
}

export const getMerchantApplyDetail = (applyId: number) => {
  return request.get(`/admin/operation/merchant/applications/${applyId}`)
}

export const auditMerchantApply = (applyId: number, data: { auditStatus: number; auditRemark?: string }) => {
  return request.post(`/admin/operation/merchant/applications/${applyId}/audit`, data)
}

// ========== 商品审核 ==========
export const getProductAuditList = (params: { auditStatus?: number; keyword?: string; pageNum?: number; pageSize?: number }) => {
  return request.get('/admin/operation/products/audits', { params })
}

export const getProductAuditDetail = (productId: number) => {
  return request.get(`/admin/operation/products/${productId}`)
}

export const auditProduct = (productId: number, data: { auditStatus: number; auditRemark?: string }) => {
  return request.post(`/admin/operation/products/${productId}/audit`, data)
}

export const offShelfProduct = (productId: number, data: { reason?: string }) => {
  return request.patch(`/admin/operation/products/${productId}/off-shelf`, data)
}

// ========== 信息变更审核 ==========
export const getInfoChanges = (params: { auditStatus?: number; keyword?: string; pageNum?: number; pageSize?: number }) => {
  return request.get('/admin/operation/info-changes', { params })
}

export const auditInfoChange = (changeId: number, data: { auditStatus: number; auditRemark?: string }) => {
  return request.post(`/admin/operation/info-changes/${changeId}/audit`, data)
}

// ========== 自提点审核 ==========
export const getPendingPickupPoints = (params: { pageNum?: number; pageSize?: number }) => {
  return request.get('/admin/operation/pickup-points', { params })
}

export const auditPickupPoint = (pointId: number, data: { auditStatus: number; auditRemark?: string }) => {
  return request.post(`/admin/operation/pickup-points/${pointId}/audit`, data)
}

// ========== 售后申诉处理 ==========
export const getAppealedAfterSales = (params: { keyword?: string; pageNum?: number; pageSize?: number }) => {
  return request.get('/admin/after-sales/appealed', { params })
}

export const interveneAfterSale = (afterSaleId: number, data: { action: number; remark?: string }) => {
  return request.post(`/admin/after-sales/${afterSaleId}/intervene`, data)
}

// ========== 分销员审核 ==========
export const getDistributorApplications = (params: { keyword?: string; auditStatus?: number; pageNum?: number; pageSize?: number }) => {
  return request.get('/admin/operation/distributors/applications', { params })
}

export const auditDistributor = (applyId: number, data: { auditStatus: number; auditRemark?: string }) => {
  return request.post(`/admin/operation/distributors/${applyId}/audit`, data)
}
