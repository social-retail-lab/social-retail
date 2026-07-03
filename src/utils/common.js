/**
 * 通用工具函数
 * 包含：Toast提示、页面跳转、数据校验等功能
 */

/**
 * 显示Toast提示
 * @param {string} title - 提示文本
 * @param {string} icon - 图标类型：success, error, none
 * @param {number} duration - 显示时长（毫秒）
 */
export const showToast = (title, icon = 'none', duration = 2000) => {
  uni.showToast({
    title,
    icon,
    duration
  })
}

/**
 * 显示Loading提示
 * @param {string} title - 加载文本
 * @param {boolean} mask - 是否显示遮罩
 */
export const showLoading = (title = '加载中...', mask = true) => {
  uni.showLoading({
    title,
    mask
  })
}

/**
 * 隐藏Loading提示
 */
export const hideLoading = () => {
  uni.hideLoading()
}

/**
 * 显示模态对话框
 * @param {Object} options - 配置项
 */
export const showModal = (options) => {
  return new Promise((resolve, reject) => {
    uni.showModal({
      title: options.title || '提示',
      content: options.content || '',
      confirmText: options.confirmText || '确定',
      cancelText: options.cancelText || '取消',
      success: (res) => {
        if (res.confirm) {
          resolve(res)
        } else {
          reject(res)
        }
      }
    })
  })
}

/**
 * 页面跳转
 * @param {string} url - 页面路径
 * @param {Object} params - 参数
 */
export const navigateTo = (url, params = {}) => {
  // 构建带参数的URL
  if (Object.keys(params).length > 0) {
    const queryString = Object.entries(params)
      .map(([key, value]) => `${key}=${encodeURIComponent(value)}`)
      .join('&')
    url = `${url}?${queryString}`
  }
  uni.navigateTo({ url, animationType: 'slide-in-right', animationDuration: 200 })
}

// 跳转节流锁(防止快速连点产生多页面堆栈)
let _navLock = false
let _navLockTimer = null

/**
 * 节流跳转(防止快速连点)
 * @param {string} url - 页面路径
 * @param {Object} params - 参数
 * @param {number} interval - 节流间隔(ms)
 */
export const throttleNavigate = (url, params = {}, interval = 500) => {
  if (_navLock) return
  _navLock = true
  if (_navLockTimer) clearTimeout(_navLockTimer)
  _navLockTimer = setTimeout(() => {
    _navLock = false
  }, interval)
  navigateTo(url, params)
}

/**
 * 跳转到TabBar页面
 * @param {string} url - 页面路径
 */
export const switchTab = (url) => {
  if (_navLock) return
  _navLock = true
  if (_navLockTimer) clearTimeout(_navLockTimer)
  _navLockTimer = setTimeout(() => {
    _navLock = false
  }, 400)
  uni.switchTab({ url })
}

/**
 * 关闭当前页面并返回上一页
 * @param {number} delta - 返回的页面数
 */
export const navigateBack = (delta = 1) => {
  if (_navLock) return
  _navLock = true
  if (_navLockTimer) clearTimeout(_navLockTimer)
  _navLockTimer = setTimeout(() => {
    _navLock = false
  }, 400)
  uni.navigateBack({ delta, animationType: 'slide-out-right', animationDuration: 200 })
}

/**
 * 重新加载当前页面
 */
export const reLaunch = (url = '/pages/index/index') => {
  uni.reLaunch({ url })
}

/**
 * 获取有效的图片URL
 * @param {string} url - 原始图片URL
 * @param {string} fallbackPrompt - 降级图片的提示词
 * @returns {string} 有效的图片URL
 */
export const getValidImageUrl = (url, fallbackPrompt = 'product%20placeholder%20image') => {
  if (!url) {
    return `https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=${fallbackPrompt}&image_size=square`
  }
  
  const cleanUrl = url.trim()
  
  if (!cleanUrl.startsWith('http')) {
    return `https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=${fallbackPrompt}&image_size=square`
  }
  
  const invalidDomains = ['cdn.example.com', 'xxx.com']
  for (const domain of invalidDomains) {
    if (cleanUrl.includes(domain)) {
      return `https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=${fallbackPrompt}&image_size=square`
    }
  }
  
  return cleanUrl
}

/**
 * 手机号验证
 * @param {string} phone - 手机号
 * @returns {boolean}
 */
export const validatePhone = (phone) => {
  const reg = /^1[3-9]\d{9}$/
  return reg.test(phone)
}

/**
 * 邮箱验证
 * @param {string} email - 邮箱
 * @returns {boolean}
 */
export const validateEmail = (email) => {
  const reg = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$/
  return reg.test(email)
}

/**
 * 验证码验证（6位数字）
 * @param {string} code - 验证码
 * @returns {boolean}
 */
export const validateCode = (code) => {
  const reg = /^\d{6}$/
  return reg.test(code)
}

/**
 * 金额格式化（保留两位小数）
 * @param {number} amount - 金额
 * @returns {string}
 */
export const formatPrice = (amount) => {
  return parseFloat(amount).toFixed(2)
}

/**
 * 深拷贝对象
 * @param {any} obj - 待拷贝对象
 * @returns {any}
 */
export const deepClone = (obj) => {
  if (obj === null || typeof obj !== 'object') return obj
  const clone = Array.isArray(obj) ? [] : {}
  for (const key in obj) {
    if (obj.hasOwnProperty(key)) {
      clone[key] = deepClone(obj[key])
    }
  }
  return clone
}

/**
 * 防抖函数
 * @param {Function} func - 执行函数
 * @param {number} wait - 等待时间
 * @returns {Function}
 */
export const debounce = (func, wait = 500) => {
  let timeout = null
  return function(...args) {
    if (timeout) clearTimeout(timeout)
    timeout = setTimeout(() => {
      func.apply(this, args)
    }, wait)
  }
}

/**
 * 节流函数
 * @param {Function} func - 执行函数
 * @param {number} wait - 间隔时间
 * @returns {Function}
 */
export const throttle = (func, wait = 500) => {
  let timeout = null
  let previous = 0
  return function(...args) {
    const now = Date.now()
    const remaining = wait - (now - previous)
    if (remaining <= 0 || remaining > wait) {
      if (timeout) {
        clearTimeout(timeout)
        timeout = null
      }
      previous = now
      func.apply(this, args)
    } else if (!timeout) {
      timeout = setTimeout(() => {
        previous = Date.now()
        timeout = null
        func.apply(this, args)
      }, remaining)
    }
  }
}

/**
 * 获取平台信息
 * @returns {string} platform - 平台类型
 */
export const getPlatform = () => {
  // #ifdef H5
  return 'h5'
  // #endif

  // #ifdef APP-PLUS
  return 'app'
  // #endif

  // #ifdef MP-WEIXIN
  return 'weixin'
  // #endif

  return 'unknown'
}
