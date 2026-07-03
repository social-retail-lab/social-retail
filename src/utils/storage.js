// 本地缓存封装
// 包含：localStorage、sessionStorage、uni.setStorage封装

// 获取缓存
export const getStorage = (key) => {
  try {
    const value = uni.getStorageSync(key)
    return value ? JSON.parse(value) : null
  } catch (e) {
    console.error('获取缓存失败:', e)
    return null
  }
}

// 设置缓存
export const setStorage = (key, value) => {
  try {
    uni.setStorageSync(key, JSON.stringify(value))
    return true
  } catch (e) {
    console.error('设置缓存失败:', e)
    return false
  }
}

// 删除缓存
export const removeStorage = (key) => {
  try {
    uni.removeStorageSync(key)
    return true
  } catch (e) {
    console.error('删除缓存失败:', e)
    return false
  }
}

// 清空缓存
export const clearStorage = () => {
  try {
    uni.clearStorageSync()
    return true
  } catch (e) {
    console.error('清空缓存失败:', e)
    return false
  }
}

// 获取Token
export const getToken = () => {
  return getStorage('token')
}

// 设置Token
export const setToken = (token) => {
  return setStorage('token', token)
}

// 删除Token
export const removeToken = () => {
  return removeStorage('token')
}

// 获取用户信息
export const getUserInfo = () => {
  return getStorage('userInfo')
}

// 设置用户信息
export const setUserInfo = (userInfo) => {
  return setStorage('userInfo', userInfo)
}

// 删除用户信息
export const removeUserInfo = () => {
  return removeStorage('userInfo')
}

// 获取购物车
export const getCart = () => {
  return getStorage('cart') || []
}

// 设置购物车
export const setCart = (cart) => {
  return setStorage('cart', cart)
}

// 删除购物车
export const removeCart = () => {
  return removeStorage('cart')
}
