import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { 
  sendSmsCodeApi, 
  userRegisterApi, 
  userLoginApi, 
  userLogoutApi, 
  getUserInfoApi, 
  updateUserInfoApi, 
  updatePhoneApi, 
  updatePasswordApi, 
  wxAuthApi, 
  checkWxBindApi, 
  wxBindPhoneApi,
  normalizeUserInfo
} from '@/api/user'

export const useUserStore = defineStore('user', () => {
  const isLogin = ref(false)
  const token = ref('')
  const openid = ref('')
  const userInfo = ref({
    userId: '',
    phone: '',
    nickname: '',
    avatar: '',
    status: 'NORMAL',
    orderCount: {
      pendingPayment: 0,
      pendingShipment: 0,
      pendingReceipt: 0,
      pendingReview: 0,
      afterSale: 0
    },
    couponCount: 0,
    unreadMessageCount: 0
  })
  const memberInfo = ref({
    memberId: '',
    levelId: 0,
    levelName: '普通会员',
    points: 0,
    totalGrowth: 0,
    nextLevelGrowth: 0,
    discountRate: 1.00,
    freeShipping: false
  })
  const distributorInfo = ref(null)
  
  const isMember = computed(() => memberInfo.value.levelId > 0)
  const isDistributor = computed(() => !!distributorInfo.value)
  
  const setUserInfo = (data) => {
    if (data.token) {
      token.value = data.token
      uni.setStorageSync('token', token.value)
    }
    if (data.userInfo) {
      const normalized = normalizeUserInfo(data.userInfo)
      userInfo.value = { ...userInfo.value, ...normalized }
      if (normalized.memberInfo) {
        memberInfo.value = { ...memberInfo.value, ...normalized.memberInfo }
      }
      if (normalized.distributorInfo !== undefined) {
        distributorInfo.value = normalized.distributorInfo
      }
    } else {
      const normalized = normalizeUserInfo(data)
      if (normalized) {
        userInfo.value = { ...userInfo.value, ...normalized }
      }
    }
    isLogin.value = true
    uni.setStorageSync('userInfo', JSON.stringify(userInfo.value))
    uni.setStorageSync('memberInfo', JSON.stringify(memberInfo.value))
  }
  
  const setOpenid = (id) => {
    openid.value = id
    uni.setStorageSync('openid', id)
  }
  
  const login = (data) => {
    token.value = data.token || ''
    if (data.userInfo) {
      const normalized = normalizeUserInfo(data.userInfo)
      userInfo.value = normalized || userInfo.value
      if (normalized?.memberInfo) {
        memberInfo.value = normalized.memberInfo
      }
    }
    isLogin.value = true
    uni.setStorageSync('token', token.value)
    uni.setStorageSync('userInfo', JSON.stringify(userInfo.value))
    uni.setStorageSync('memberInfo', JSON.stringify(memberInfo.value))
  }
  
  const logout = () => {
    token.value = ''
    openid.value = ''
    userInfo.value = {
      userId: '',
      phone: '',
      nickname: '',
      avatar: '',
      status: 'NORMAL',
      orderCount: {
        pendingPayment: 0,
        pendingShipment: 0,
        pendingReceipt: 0,
        pendingReview: 0,
        afterSale: 0
      },
      couponCount: 0,
      unreadMessageCount: 0
    }
    memberInfo.value = {
      memberId: '',
      levelId: 0,
      levelName: '普通会员',
      points: 0,
      totalGrowth: 0,
      nextLevelGrowth: 0,
      discountRate: 1.00,
      freeShipping: false
    }
    distributorInfo.value = null
    isLogin.value = false
    uni.removeStorageSync('token')
    uni.removeStorageSync('openid')
    uni.removeStorageSync('userInfo')
    uni.removeStorageSync('memberInfo')
  }
  
  const updateUserInfo = (data) => {
    userInfo.value = { ...userInfo.value, ...data }
    uni.setStorageSync('userInfo', JSON.stringify(userInfo.value))
  }
  
  const updatePoint = (newPoint) => {
    memberInfo.value.points = newPoint
    uni.setStorageSync('memberInfo', JSON.stringify(memberInfo.value))
  }
  
  const updateGrowth = (newGrowth) => {
    memberInfo.value.totalGrowth = newGrowth
    uni.setStorageSync('memberInfo', JSON.stringify(memberInfo.value))
  }

  const fetchSendSmsCode = async (data) => {
    const res = await sendSmsCodeApi(data)
    if (res.code === 0) {
      return res.data
    }
    return null
  }

  const fetchUserRegister = async (data) => {
    const res = await userRegisterApi(data)
    if (res.code === 0 && res.data) {
      return res.data
    }
    return null
  }

  const fetchUserLogin = async (data) => {
    const res = await userLoginApi(data)
    if (res.code === 0 && res.data) {
      return res.data
    }
    return null
  }

  const fetchUserLogout = async () => {
    const res = await userLogoutApi()
    if (res.code === 0) {
      return true
    }
    return false
  }

  const fetchUserInfo = async () => {
    const res = await getUserInfoApi()
    if (res.code === 0 && res.data) {
      return normalizeUserInfo(res.data)
    }
    return null
  }

  const fetchUpdateUserInfo = async (data) => {
    const res = await updateUserInfoApi(data)
    if (res.code === 0 && res.data) {
      return res.data
    }
    return null
  }

  const fetchUpdatePhone = async (data) => {
    const res = await updatePhoneApi(data)
    if (res.code === 0 && res.data) {
      return res.data
    }
    return null
  }

  const fetchUpdatePassword = async (data) => {
    const res = await updatePasswordApi(data)
    if (res.code === 0) {
      return true
    }
    return false
  }

  const fetchWxAuth = async (data) => {
    const res = await wxAuthApi(data)
    if (res.code === 0 && res.data) {
      return res.data
    }
    return null
  }

  const fetchCheckWxBind = async (data) => {
    const res = await checkWxBindApi(data)
    if (res.code === 0 && res.data) {
      return res.data
    }
    return null
  }

  const fetchWxBindPhone = async (data) => {
    const res = await wxBindPhoneApi(data)
    if (res.code === 0 && res.data) {
      return res.data
    }
    return null
  }
  
  return {
    isLogin,
    token,
    openid,
    userInfo,
    memberInfo,
    distributorInfo,
    isMember,
    isDistributor,
    setUserInfo,
    setOpenid,
    login,
    logout,
    updateUserInfo,
    updatePoint,
    updateGrowth,
    fetchSendSmsCode,
    fetchUserRegister,
    fetchUserLogin,
    fetchUserLogout,
    fetchUserInfo,
    fetchUpdateUserInfo,
    fetchUpdatePhone,
    fetchUpdatePassword,
    fetchWxAuth,
    fetchCheckWxBind,
    fetchWxBindPhone
  }
})