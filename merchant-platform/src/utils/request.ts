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

let toastFn: any = null

// 请求前由 App.vue 注入 toast 方法
export function setToast(shower: (msg: string, type: 'success' | 'error' | 'info') => void) {
  toastFn = shower
}

const service = axios.create({
  baseURL: '/api',
  timeout: 15000
})

service.interceptors.request.use(config => {
  const token = localStorage.getItem('merchantToken')
  if (token) {
    config.headers.Authorization = `Bearer ${token}`
  }
  return config
})

service.interceptors.response.use(
  (res: AxiosResponse<ApiResult>) => {
    const body = res.data
    if (body.code !== 0) {
      if (toastFn) toastFn(body.message || '请求失败', 'error')
      return Promise.reject(new Error(body.message))
    }
    return body.data as any
  },
  err => {
    if (err.response?.status === 401) {
      localStorage.removeItem('merchantToken')
      window.location.href = '/login'
      return Promise.reject(err)
    }
    const msg = err.response?.data?.message || err.message || '网络错误'
    if (toastFn) toastFn(msg, 'error')
    return Promise.reject(err)
  }
)

export default service
