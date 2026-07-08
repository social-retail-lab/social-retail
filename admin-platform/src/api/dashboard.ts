import request from '@/utils/request'

export const getDashboardData = () => {
  return request.get('/admin/dashboard')
}