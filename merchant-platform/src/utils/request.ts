import axios from 'axios'

const service = axios.create({
  baseURL: '/api',
  timeout: 10000
})

service.interceptors.request.use(config => {
  const token = localStorage.getItem('merchantToken')
  if (token) {
    config.headers.Authorization = `Bearer ${token}`
  }
  return config
})

service.interceptors.response.use(res => {
  const data = res.data
  if (data.code === 40101 || data.code === 40102) {
    localStorage.removeItem('merchantToken')
    localStorage.removeItem('merchantName')
    window.location.href = '/login'
    return Promise.reject(new Error('登录已过期'))
  }
  return data
}, err => {
  if (err.response && err.response.status === 401) {
    localStorage.removeItem('merchantToken')
    localStorage.removeItem('merchantName')
    window.location.href = '/login'
  }
  alert('接口请求失败：' + err.message)
  return Promise.reject(err)
})

export default service