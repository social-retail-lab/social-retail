import request from '@/utils/request'

// ========== 管理员登录接口 ==========
/**
 * 系统管理员登录
 * POST /api/admin/system/auth/login
 */
export const systemAdminLogin = (data: { username: string; password: string }) => {
  return request.post('/api/admin/system/auth/login', data)
}

/**
 * 运营管理员登录
 * POST /api/admin/operation/auth/login
 */
export const operationAdminLogin = (data: { username: string; password: string }) => {
  return request.post('/api/admin/operation/auth/login', data)
}

/**
 * 获取当前管理员信息
 */
export const getAdminInfo = () => {
  return request.get('/api/admin/info')
}

/**
 * 退出登录
 */
export const logout = () => {
  return request.post('/api/admin/operation/auth/logout')
}

// ========== 商家入驻审核接口 ==========
export function getMerchantAuditList(params: any) {
  return request.get('/api/admin/operation/merchant/applications', { params })
}

export function getMerchantDetail(applyId: number) {
  return request.get(`/api/admin/operation/merchant/applications/${applyId}`)
}

export function auditMerchant(data: { applyId: number; auditStatus: number; auditRemark: string }) {
  return request.post(`/api/admin/operation/merchant/applications/${data.applyId}/audit`, data)
}

// ========== 商品审核接口 ==========
export function getProductAuditList(params: any) {
  return request.get('/api/admin/operation/products/audits', { params })
}

export function getProductDetail(productId: number) {
  return request.get(`/api/admin/operation/products/${productId}`)
}

export function auditProduct(data: { productId: number; auditStatus: number; auditRemark: string }) {
  return request.post(`/api/admin/operation/products/${data.productId}/audit`, data)
}