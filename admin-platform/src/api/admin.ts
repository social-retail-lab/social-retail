import request from '@/utils/request'

// ========== 管理员登录接口 ==========
/**
 * 运营管理员登录
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
