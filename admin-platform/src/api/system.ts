import request from '@/utils/request'

export const getUserList = (params: {
  status?: string
  userType?: string
  page?: number
  pageSize?: number
  keyword?: string
}) => {
  return request.get('/admin/users', { params })
}

export const getUserDetail = (userId: number) => {
  return request.get(`/admin/users/${userId}`)
}

export const updateUserStatus = (userId: number, data: { status: string }) => {
  return request.patch(`/admin/users/${userId}/status`, data)
}

export const getRoleList = () => {
  return request.get('/admin/roles')
}

export const getRoleDetail = (roleId: number) => {
  return request.get(`/admin/roles/${roleId}`)
}

export const createRole = (data: {
  roleName: string
  roleCode: string
  description?: string
  permissionIds?: number[]
}) => {
  return request.post('/admin/roles', data)
}

export const updateRole = (roleId: number, data: {
  roleName?: string
  description?: string
  permissionIds?: number[]
}) => {
  return request.put(`/admin/roles/${roleId}`, data)
}

export const deleteRole = (roleId: number) => {
  return request.delete(`/admin/roles/${roleId}`)
}

export const getPermissionList = () => {
  return request.get('/admin/permissions')
}

export const getOrderList = (params: {
  status?: string
  page?: number
  pageSize?: number
  keyword?: string
}) => {
  return request.get('/admin/orders', { params })
}

export const getOrderDetail = (orderId: number) => {
  return request.get(`/admin/orders/${orderId}`)
}

export const handleRefund = (orderId: number, data: {
  refundAmount: number
  reason?: string
}) => {
  return request.post(`/admin/orders/${orderId}/refund`, data)
}

export const closeOrder = (orderId: number, data: { reason?: string }) => {
  return request.post(`/admin/orders/${orderId}/close`, data)
}