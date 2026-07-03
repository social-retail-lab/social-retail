// 未登录、分销身份校验拦截
// 路由守卫：登录校验、权限校验、分销身份校验

import { useUserStore } from '@/store/user'
import { useGlobalStore } from '@/store/global'

// 路由白名单（无需登录即可访问的页面）
const WHITE_LIST = [
  '/pages/index/index',
  '/pages/login/login',
  '/pages/login/register',
  '/pagesSub/goods/detail/goodsDetail',
  '/pagesSub/goods/search/searchHome',
  '/pagesSub/goods/search/searchResult',
  '/pagesSub/goods/category/categoryHome'
]

// 分销员专属页面（需要分销员身份）
const DISTRIBUTOR_PAGES = [
  '/pagesSub/distribution/distHome',
  '/pagesSub/distribution/commission/commissionRecord',
  '/pagesSub/distribution/commission/withdrawApply',
  '/pagesSub/distribution/share/sharePoster',
  '/pagesSub/distribution/share/shareData'
]

// 路由守卫
export const authGuard = (to, from, next) => {
  const userStore = useUserStore()
  const globalStore = useGlobalStore()
  
  // 检查是否在白名单中
  if (WHITE_LIST.includes(to.path)) {
    next()
    return
  }
  
  // 检查登录状态
  if (!userStore.isLogin) {
    // 记录跳转来源，登录后返回
    globalStore.openLoginPopup()
    return
  }
  
  // 检查分销员身份
  if (DISTRIBUTOR_PAGES.includes(to.path)) {
    if (!userStore.isDistributor) {
      uni.showToast({ title: '请先申请成为分销员', icon: 'none' })
      uni.navigateTo({ url: '/pagesSub/distribution/apply' })
      return
    }
  }
  
  next()
}

// 页面加载时的登录检查
export const checkLoginOnLoad = (page) => {
  const userStore = useUserStore()
  
  // 检查Token是否存在
  const token = uni.getStorageSync('token')
  if (token) {
    // 恢复登录状态
    // userStore.token = token
    // userStore.isLogin = true
    // 获取用户信息
    // userStore.getUserInfo()
  }
}

// 路由跳转前检查
export const checkBeforeNavigate = (url) => {
  const userStore = useUserStore()
  
  // 如果需要登录且未登录
  if (!userStore.isLogin && !WHITE_LIST.includes(url)) {
    uni.navigateTo({ url: '/pages/login/login' })
    return false
  }
  
  return true
}
