import request from "./base"

const validatePhone = (phone) => {
  if (!phone || !/^1[3-9]\d{9}$/.test(phone)) {
    throw new Error('请输入正确的11位手机号')
  }
  return phone.trim()
}

const validateSmsCode = (code) => {
  if (!code || code.length !== 6 || !/^\d{6}$/.test(code)) {
    throw new Error('请输入6位数字验证码')
  }
  return code.trim()
}

export const sendSmsCodeApi = (data) => {
  const phone = validatePhone(data.phone)
  const scene = data.scene || 'LOGIN'
  return request({
    url: "/api/auth/code",
    method: "post",
    data: { phone, scene }
  })
}

export const userRegisterApi = (data) => {
  const phone = validatePhone(data.phone)
  const code = validateSmsCode(data.code)
  const password = data.password || ''
  const nickname = data.nickname || ''
  return request({
    url: "/api/auth/register",
    method: "post",
    data: { phone, code, password, nickname }
  })
}

export const userLoginApi = (data) => {
  const phone = validatePhone(data.phone)
  const loginType = data.loginType || 'CODE'
  
  if (loginType !== 'CODE' && loginType !== 'PASSWORD') {
    throw new Error('登录方式不正确')
  }
  
  const requestData = { phone, loginType }
  if (loginType === 'CODE') {
    requestData.code = validateSmsCode(data.code)
  } else if (loginType === 'PASSWORD') {
    if (!data.password || data.password.length < 6) {
      throw new Error('密码至少6位')
    }
    requestData.password = data.password
  }
  
  return request({
    url: "/api/auth/login",
    method: "post",
    data: requestData
  })
}

export const userLogoutApi = () => {
  return request({
    url: "/api/auth/logout",
    method: "post"
  })
}

export const getUserInfoApi = () => {
  return request({
    url: "/api/user/info",
    method: "get"
  })
}

export const updateUserInfoApi = (data) => {
  const requestData = {}
  if (data.nickname !== undefined) {
    requestData.nickname = data.nickname.trim()
  }
  if (data.avatar !== undefined) {
    requestData.avatar = data.avatar.trim()
  }
  return request({
    url: "/api/user/info",
    method: "put",
    data: requestData
  })
}

export const updatePhoneApi = (data) => {
  const newPhone = validatePhone(data.newPhone)
  const code = validateSmsCode(data.code)
  return request({
    url: "/api/user/phone",
    method: "put",
    data: { newPhone, code }
  })
}

export const updatePasswordApi = (data) => {
  if (!data.oldPassword || data.oldPassword.length < 6) {
    throw new Error('原密码至少6位')
  }
  if (!data.newPassword || data.newPassword.length < 6) {
    throw new Error('新密码至少6位')
  }
  if (data.oldPassword === data.newPassword) {
    throw new Error('新旧密码不能相同')
  }
  return request({
    url: "/api/user/password",
    method: "put",
    data: { oldPassword: data.oldPassword, newPassword: data.newPassword }
  })
}

export const wxAuthApi = (data) => {
  if (!data.code) {
    throw new Error('微信code不能为空')
  }
  return request({
    url: "/api/auth/wechat",
    method: "post",
    data: { code: data.code }
  })
}

export const checkWxBindApi = (data) => {
  if (!data.openid) {
    throw new Error('openid不能为空')
  }
  return request({
    url: "/api/auth/wechat/check-bind",
    method: "post",
    data: { openid: data.openid }
  })
}

export const wxBindPhoneApi = (data) => {
  if (!data.openid) {
    throw new Error('openid不能为空')
  }
  const phone = validatePhone(data.phone)
  const code = validateSmsCode(data.code)
  return request({
    url: "/api/auth/wechat/bind",
    method: "post",
    data: { openid: data.openid, phone, code }
  })
}

export const normalizeUserInfo = (data) => {
  if (!data) return null
  return {
    userId: data.userId || '',
    phone: data.phone || '',
    nickname: data.nickname || '',
    avatar: data.avatar || '',
    status: data.status || 'NORMAL',
    memberInfo: data.memberInfo ? {
      memberId: data.memberInfo.memberId || '',
      levelId: data.memberInfo.levelId || 0,
      levelName: data.memberInfo.levelName || '普通会员',
      points: data.memberInfo.points || 0,
      totalGrowth: data.memberInfo.totalGrowth || 0,
      nextLevelGrowth: data.memberInfo.nextLevelGrowth || 0,
      discountRate: data.memberInfo.discountRate || 1.00,
      freeShipping: data.memberInfo.freeShipping || false
    } : null,
    distributorInfo: data.distributorInfo || null,
    orderCount: data.orderCount || {
      pendingPayment: 0,
      pendingShipment: 0,
      pendingReceipt: 0,
      pendingReview: 0,
      afterSale: 0
    },
    couponCount: data.couponCount || 0,
    unreadMessageCount: data.unreadMessageCount || 0
  }
}