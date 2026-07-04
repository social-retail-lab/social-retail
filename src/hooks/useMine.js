import { ref, watch, onMounted, computed } from 'vue'
import { onShow } from '@dcloudio/uni-app'
import { useUserStore } from '@/store/user'
import { useMemberStore } from '@/store/member'
import { useCouponStore } from '@/store/coupon'
import { showToast } from '@/utils/common'

export function useMine() {
  const userStore = useUserStore()
  const memberStore = useMemberStore()
  const couponStore = useCouponStore()
  const loading = ref(true)
  const refreshing = ref(false)

  // 未使用优惠券数量(4.3.3 接口获取)
  const couponCount = ref(0)
  
  const userData = computed(() => ({
    userId: userStore.userInfo.userId || '',
    nickname: userStore.userInfo.nickname || '',
    avatar: userStore.userInfo.avatar || '',
    phone: userStore.userInfo.phone || '',
    status: userStore.userInfo.status || 'NORMAL'
  }))
  
  const memberData = computed(() => ({
    memberId: userStore.memberInfo.memberId || '',
    levelId: userStore.memberInfo.memberLevel || 0,
    levelName: userStore.memberInfo.memberLevelName || userStore.memberInfo.levelName || '普通用户',
    memberLevel: userStore.memberInfo.memberLevel || 0,
    memberLevelName: userStore.memberInfo.memberLevelName || userStore.memberInfo.levelName || '普通会员',
    pointsBalance: userStore.memberInfo.pointsBalance || 0,
    growthValue: userStore.memberInfo.growthValue || 0,
    nextLevelGrowth: memberStore.nextLevelGrowth || 0
  }))
  
  const distributorData = computed(() => userStore.distributorInfo || {})
  
  const orderStats = computed(() => ({
    pendingPayment: userStore.userInfo.orderCount?.pendingPayment || 0,
    pendingShipment: userStore.userInfo.orderCount?.pendingShipment || 0,
    pendingReceipt: userStore.userInfo.orderCount?.pendingReceipt || 0,
    pendingReview: userStore.userInfo.orderCount?.pendingReview || 0,
    afterSale: userStore.userInfo.orderCount?.afterSale || 0
  }))
  
  const assetStats = computed(() => ({
    couponCount: couponCount.value || 0,
    points: memberStore.pointsBalance || 0,
    growth: memberStore.growthValue || 0
  }))
  
  const unreadCount = computed(() => userStore.userInfo.unreadMessageCount || 0)
  
  const growthProgress = computed(() => memberStore.growthProgress)
  
  const loadUserInfo = async () => {
    if (!userStore.isLogin) {
      return
    }

    // 使用 Promise.allSettled 隔离错误:任一接口失败不影响其他接口
    // 后端某些接口可能 500(服务异常),前端不应让一个接口拖垮整个页面加载
    const results = await Promise.allSettled([
      userStore.fetchUserInfo(),
      memberStore.fetchPointsBalance(),
      memberStore.fetchMemberInfo(),
      // 4.3.3 获取未使用优惠券总数(只取 total,pageSize=1 减少传输)
      couponStore.fetchMyCoupons({ status: 0, page: 1, pageSize: 1 }, false)
    ])

    const [userInfoResult, pointsResult, memberResult, couponResult] = results
    const res = userInfoResult.status === 'fulfilled' ? userInfoResult.value : null
    const memberRes = memberResult.status === 'fulfilled' ? memberResult.value : null

    // 优惠券数量(4.3.3 接口返回的 total)
    if (couponResult.status === 'fulfilled' && couponResult.value) {
      couponCount.value = Number(couponResult.value.total) || 0
    } else if (couponResult.status === 'rejected') {
      console.warn('优惠券数量接口失败:', couponResult.reason?.statusCode || couponResult.reason?.message || 'unknown')
    }

    // 记录失败接口(便于调试,不影响功能)
    if (userInfoResult.status === 'rejected') {
      console.warn('用户信息接口失败:', userInfoResult.reason?.statusCode || userInfoResult.reason?.message || 'unknown')
    }
    if (pointsResult.status === 'rejected') {
      console.warn('积分余额接口失败:', pointsResult.reason?.statusCode || pointsResult.reason?.message || 'unknown')
    }
    if (memberResult.status === 'rejected') {
      console.warn('会员信息接口失败:', memberResult.reason?.statusCode || memberResult.reason?.message || 'unknown')
    }

    try {
      if (res) {
        userStore.setUserInfo(res)

        // 成长值数据合并：fetchMemberInfo 失败或成长值为 0 时，从 userInfo 接口的 memberInfo 补充
        const userMemberInfo = res.memberInfo || null
        const userGrowth = Number(userMemberInfo?.growthValue ?? 0)

        if (memberRes && memberStore.memberInfo) {
          // fetchMemberInfo 成功，但成长值为 0 时从 userInfo 接口补充
          if (memberStore.growthValue === 0 && userGrowth > 0) {
            memberStore.memberInfo = {
              ...memberStore.memberInfo,
              growthValue: userGrowth
            }
          }
        } else if (userMemberInfo) {
          // fetchMemberInfo 失败，使用 userInfo 接口的 memberInfo 作为兜底
          memberStore.memberInfo = {
            ...userMemberInfo,
            growthValue: userGrowth,
            pointsBalance: Number(userMemberInfo.pointsBalance ?? 0),
            memberLevel: Number(userMemberInfo.memberLevel ?? 0),
            levelName: userMemberInfo.levelName || '普通会员'
          }
        }

        if (res.distributorInfo !== undefined && res.distributorInfo !== null) {
          userStore.distributorInfo = res.distributorInfo.status === 'APPROVED' ? res.distributorInfo : null
        }
      }
    } catch (error) {
      console.error('处理用户信息失败:', error)
    }
  }
  
  const loadAllData = async () => {
    loading.value = true
    await loadUserInfo()
    loading.value = false
  }
  
  const handleRefresh = async () => {
    refreshing.value = true
    await loadUserInfo()
    refreshing.value = false
  }
  
  watch(() => userStore.isLogin, (newVal) => {
    if (newVal) {
      loadUserInfo()
    }
  })
  
  onMounted(() => {
    loadAllData()
  })

  // 页面显示时刷新数据（从订单/购物车等页面返回后同步成长值、积分等）
  onShow(() => {
    if (userStore.isLogin) {
      loadUserInfo()
    }
  })
  
  return {
    loading,
    refreshing,
    userData,
    memberData,
    distributorData,
    orderStats,
    assetStats,
    unreadCount,
    growthProgress,
    loadAllData,
    handleRefresh
  }
}
