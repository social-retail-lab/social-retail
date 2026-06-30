import axios from 'axios'
import type { AxiosResponse } from 'axios'

// 后端统一响应格式
interface ApiResult<T = any> {
  code: number
  message: string
  data: T
  timestamp: number
  requestId: string
}

const service = axios.create({
  baseURL: '/api',
  timeout: 15000
})

// 请求拦截器自动携带token
service.interceptors.request.use(config => {
  const token = localStorage.getItem('adminToken')
  if (token) {
    config.headers.Authorization = `Bearer ${token}`
  }
  return config
})

// 响应拦截器
service.interceptors.response.use(
  (res: AxiosResponse<ApiResult>) => {
    const body = res.data
    if (body.code !== 0) {
      alert(body.message || '请求失败')
      return Promise.reject(new Error(body.message))
    }
    // 直接返回 data 字段
    return body.data as any
  },
  err => {
    if (err.response?.status === 401) {
      localStorage.removeItem('adminToken')
      window.location.href = '/login'
      return Promise.reject(err)
    }
    const msg = err.response?.data?.message || err.message || '网络错误'
    alert('接口请求失败：' + msg)
    return Promise.reject(err)
  }
)

export default service
