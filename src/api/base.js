// 请求基础封装（request而不是axios）
// 包含：域名配置、token注入、请求拦截器、响应拦截器、统一报错处理

// 错误码规范：
// 0                    - 成功
// 40001-40099          - 参数错误（参数缺失/格式错误/校验失败）
// 40101-40199          - 认证错误（Token无效/过期/未登录）
// 40301-40399          - 权限错误（角色权限不足/资源不可访问）
// 40401-40499          - 资源不存在（商品/订单/用户不存在）
// 40901-40999          - 业务冲突（库存不足/优惠券已领/重复操作/价格变动）
// 42901-42999          - 限流错误（请求频率超限）
// 50001-50099          - 服务器错误（系统内部异常/服务不可用）

const baseUrl = process.env.NODE_ENV === 'development' ? '' : "http://172.20.10.11:8081"

const request = (options) => {
  const { url, method = "GET", data = {}, params = {}, headers = {}, timeout = 30000 } = options
  const token = uni.getStorageSync('token')
  
  const defaultHeader = {
    "Content-Type": "application/json"
  }
  
  if (token) {
    defaultHeader.Authorization = `Bearer ${token}`
  }
  
  const requestHeader = { ...defaultHeader, ...headers }
  
  return new Promise((resolve, reject) => {
    uni.request({
      url: `${baseUrl}${url}`,
      method,
      data,
      params,
      header: requestHeader,
      timeout,
      success: (res) => {
        const { data: responseData, statusCode } = res
        
        if (statusCode !== 200) {
          reject({ statusCode, message: `HTTP ${statusCode}` })
          return
        }
        
        if (!responseData || typeof responseData !== 'object') {
          uni.showToast({ title: "服务响应格式错误", icon: "none" })
          reject({ message: "Invalid response format" })
          return
        }
        
        if (responseData.code === 0) {
          resolve(responseData)
          return
        }
        
        handleError(responseData, reject)
      },
      fail: (err) => {
        if (err.errMsg && err.errMsg.includes('ERR_ABORTED')) {
          reject({ ...err, aborted: true })
          return
        }
        uni.showToast({ title: "网络异常，请稍后重试", icon: "none" })
        reject(err)
      }
    })
  })
}

const handleError = (responseData, reject) => {
  const { code, message, msg, data } = responseData
  const errorMsg = message || msg || "请求失败"
  
  if (code >= 40101 && code <= 40199) {
    uni.showToast({ title: errorMsg, icon: "none" })
    uni.removeStorageSync('token')
    uni.removeStorageSync('userInfo')
    uni.removeStorageSync('memberInfo')
    setTimeout(() => {
      uni.reLaunch({ url: "/pages/login/login" })
    }, 1500)
  } else if (code >= 40001 && code <= 40099) {
    uni.showToast({ title: errorMsg, icon: "none" })
  } else if (code >= 40301 && code <= 40399) {
    uni.showToast({ title: errorMsg, icon: "none" })
  } else if (code >= 40401 && code <= 40499) {
    uni.showToast({ title: errorMsg, icon: "none" })
  } else if (code >= 40901 && code <= 40999) {
    uni.showToast({ title: errorMsg, icon: "none" })
  } else if (code >= 42901 && code <= 42999) {
    uni.showToast({ title: errorMsg, icon: "none" })
  } else if (code >= 50001 && code <= 50099) {
    uni.showToast({ title: "服务器繁忙，请稍后重试", icon: "none" })
  } else {
    uni.showToast({ title: errorMsg, icon: "none" })
  }
  
  reject(responseData)
}

const http = {
  get: (url, params, headers) => request({ url, method: 'GET', params, headers }),
  post: (url, data, headers) => request({ url, method: 'POST', data, headers }),
  put: (url, data, headers) => request({ url, method: 'PUT', data, headers }),
  delete: (url, headers) => request({ url, method: 'DELETE', headers })
}

export { http }
export default request