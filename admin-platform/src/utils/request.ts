import axios from 'axios'

const service = axios.create({
  baseUrl: '',
  timeout: 10000
})

// 请求拦截器自动携带token
service.interceptors.request.use(config => {
  const token = localStorage.getItem('adminToken')
  if (token) {
    config.headers.Authorization = `Bearer ${token}`
  }
  return config
})

// 响应拦截统一处理错误
service.interceptors.response.use(res => {
  return res.data
}, err => {
  alert('接口请求失败：' + err.message)
  return Promise.reject(err)
})

export default service