// 价格、时间、手机号格式化工具
// 包含：价格格式化、时间格式化、手机号脱敏、金额单位转换

// 价格格式化
export const formatPrice = (price, decimals = 2) => {
  return Number(price).toFixed(decimals)
}

// 价格格式化（带货币符号）
export const formatPriceWithSymbol = (price, symbol = '¥') => {
  return `${symbol}${formatPrice(price)}`
}

// 时间格式化
export const formatTime = (timestamp, format = 'YYYY-MM-DD HH:mm:ss') => {
  const date = new Date(timestamp)
  const year = date.getFullYear()
  const month = String(date.getMonth() + 1).padStart(2, '0')
  const day = String(date.getDate()).padStart(2, '0')
  const hour = String(date.getHours()).padStart(2, '0')
  const minute = String(date.getMinutes()).padStart(2, '0')
  const second = String(date.getSeconds()).padStart(2, '0')
  
  return format
    .replace('YYYY', year)
    .replace('MM', month)
    .replace('DD', day)
    .replace('HH', hour)
    .replace('mm', minute)
    .replace('ss', second)
}

// 时间格式化（相对时间）
export const formatRelativeTime = (timestamp) => {
  const now = Date.now()
  const diff = now - timestamp
  
  const minute = 60 * 1000
  const hour = 60 * minute
  const day = 24 * hour
  const week = 7 * day
  const month = 30 * day
  const year = 365 * day
  
  if (diff < minute) {
    return '刚刚'
  } else if (diff < hour) {
    return `${Math.floor(diff / minute)}分钟前`
  } else if (diff < day) {
    return `${Math.floor(diff / hour)}小时前`
  } else if (diff < week) {
    return `${Math.floor(diff / day)}天前`
  } else if (diff < month) {
    return `${Math.floor(diff / week)}周前`
  } else if (diff < year) {
    return `${Math.floor(diff / month)}个月前`
  } else {
    return `${Math.floor(diff / year)}年前`
  }
}

// 手机号脱敏
export const formatPhone = (phone) => {
  if (!phone || phone.length !== 11) {
    return phone
  }
  return phone.replace(/(\d{3})\d{4}(\d{4})/, '$1****$2')
}

// 身份证号脱敏
export const formatIdCard = (idCard) => {
  if (!idCard || idCard.length < 18) {
    return idCard
  }
  return idCard.replace(/(\d{6})\d{8}(\d{4})/, '$1********$2')
}

// 金额单位转换（元转分）
export const yuanToCent = (amount) => {
  return Math.round(Number(amount) * 100)
}

// 金额单位转换（分转元）
export const centToYuan = (amount) => {
  return Number(amount) / 100
}

// 数字格式化（千分位）
export const formatNumber = (num) => {
  return Number(num).toLocaleString()
}

// 数量格式化（超过1000显示1k+）
export const formatCount = (count) => {
  if (count >= 10000) {
    return `${(count / 10000).toFixed(1)}万`
  } else if (count >= 1000) {
    return `${(count / 1000).toFixed(1)}k`
  }
  return count
}
