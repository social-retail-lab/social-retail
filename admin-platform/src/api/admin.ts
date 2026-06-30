import request from '@/utils/request'

// ========== 管理员登录接口 ==========
/**
 * 统一管理员登录（自动识别运营/系统管理员）
 * POST /api/admin/operation/auth/login
 */
export const adminLogin = (data: { username: string; password: string }) => {
  return request.post('/admin/operation/auth/login', data) as Promise<{
    token: string
    expireTime: number
    adminInfo: {
      adminId: number
      username: string
      realName: string
      phone: string
      email: string
      role: string
      status: number
      lastLoginTime: string
      adminType: string
    }
  }>
}

/**
 * 获取当前管理员信息
 * GET /api/admin/operation/info
 */
export const getAdminInfo = () => {
  return request.get('/admin/operation/info')
}

/**
 * 退出登录
 * POST /api/admin/operation/auth/logout
 */
export const adminLogout = () => {
  return request.post('/admin/operation/auth/logout')
}

// ========== 商家入驻审核接口 ==========
export function getMerchantAuditList(params: {
  auditStatus?: number
  keyword?: string
  startDate?: string
  endDate?: string
  pageNum?: number
  pageSize?: number
}) {
  return request.get('/admin/operation/merchant/applications', { params }) as Promise<{
    list: any[]
    total: number
    pageNum: number
    pageSize: number
  }>
}

export function auditMerchant(applyId: number, data: { auditStatus: number; auditRemark: string }) {
  return request.post(`/admin/operation/merchant/applications/${applyId}/audit`, data) as Promise<{
    applyId: number
    auditStatus: number
    auditStatusText: string
    merchantId: number
  }>
}

// ========== 商家管理接口 ==========
export function getMerchantList(params: {
  keyword?: string
  status?: number
  pageNum?: number
  pageSize?: number
}) {
  return request.get('/admin/operation/merchants', { params }) as Promise<{
    list: any[]
    total: number
    pageNum: number
    pageSize: number
  }>
}

export function getMerchantDetail(merchantId: number) {
  return request.get(`/admin/operation/merchants/${merchantId}`)
}

export function updateMerchantStatus(merchantId: number, data: { status: number; reason?: string }) {
  return request.patch(`/admin/operation/merchants/${merchantId}/status`, data)
}

// ========== 商品审核接口 ==========
export function getProductAuditList(params: {
  auditStatus?: number
  keyword?: string
  merchantId?: number
  pageNum?: number
  pageSize?: number
}) {
  return request.get('/admin/operation/products/audits', { params }) as Promise<{
    list: any[]
    total: number
    pageNum: number
    pageSize: number
  }>
}

export function auditProduct(productId: number, data: { auditStatus: number; auditRemark: string }) {
  return request.post(`/admin/operation/products/${productId}/audit`, data) as Promise<{
    productId: number
    auditStatus: number
    auditStatusText: string
  }>
}

// ========== 商品管理接口 ==========
export function getAllProducts(params: {
  keyword?: string
  categoryId?: number
  status?: number
  auditStatus?: number
  pageNum?: number
  pageSize?: number
}) {
  return request.get('/admin/operation/products', { params }) as Promise<{ list: any[]; total: number; pageNum: number; pageSize: number }>
}

export function getProductDetailForAdmin(productId: number) {
  return request.get(`/admin/operation/products/${productId}`)
}

export function offShelfProduct(productId: number, data: { reason?: string }) {
  return request.patch(`/admin/operation/products/${productId}/off-shelf`, data)
}

export function getAdminCategories() {
  return request.get('/admin/operation/categories')
}

// ========== 商家信息变更审核接口 ==========
export function getInfoChanges(params: {
  auditStatus?: number
  keyword?: string
  pageNum?: number
  pageSize?: number
}) {
  return request.get('/admin/operation/info-changes', { params }) as Promise<{
    list: any[]
    total: number
    pageNum: number
    pageSize: number
  }>
}

export function auditInfoChange(changeId: number, data: { auditStatus: number; remark: string }) {
  return request.post(`/admin/operation/info-changes/${changeId}/audit`, data)
}
