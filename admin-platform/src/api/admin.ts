import request from '@/utils/request'

export const adminLogin = (data: { username: string; password: string }) => {
  return request.post('/admin/auth/login', data)
}

export const getAdminInfo = () => {
  return request.get('/admin/info')
}

export const adminLogout = () => {
  return request.post('/admin/auth/logout')
}