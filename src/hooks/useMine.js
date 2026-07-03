import { ref, watch, onMounted, computed } from 'vue'
import { useUserStore } from '@/store/user'
import { useMemberStore } from '@/store/member'
import { showToast } from '@/utils/common'

export function useMine() {
  const userStore = useUserStore()
  const memberStore = useMemberStore()
  const loading = ref(true)
  const refreshing = ref(false)
  
  const userData = computed(() => ({
    userId: userStore.userInfo.userId || '',
    nickname: userStore.userInfo.nickname || '',
    avatar: userStore.userInfo.avatar || '',
    phone: userStore.userInfo.phone || '',
    status: userStore.userInfo.status || 'NORMAL'
  }))
  
  const memberData = computed(() => ({
    memberId: userStore.memberInfo.memberId || '',
    levelId: userStore.memberInfo.levelId || 0,
    levelName: userStore.memberInfo.levelName || '普通用户',
    memberLevel: userStore.memberInfo.levelId || 0,
    points: userStore.memberInfo.points || 0,
    totalGrowth: userStore.memberInfo.totalGrowth || 0,
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
    couponCount: userStore.userInfo.couponCount || 0,
    points: memberStore.pointsBalance || 0,
    growth: memberStore.growthValue || 0
  }))
  
  const unreadCount = computed(() => userStore.userInfo.unreadMessageCount || 0)
  
  const growthProgress = computed(() => memberStore.growthProgress)
  
  const loadUserInfo = async () => {
    if (!userStore.isLogin) {
      return
    }

    try {
      const [res, pointsRes, memberRes] = await Promise.all([
        userStore.fetchUserInfo(),
        memberStore.fetchPointsBalance(),
        memberStore.fetchMemberInfo()
      ])

      if (res) {
        userStore.setUserInfo(res)
        
        if (res.memberInfo) {
          memberStore.memberInfo = res.memberInfo
        }
        
        if (res.distributorInfo !== undefined && res.distributorInfo !== null) {
          userStore.distributorInfo = res.distributorInfo.status === 'APPROVED' ? res.distributorInfo : null
        }
      }
    } catch (error) {
      console.error('获取用户信息失败:', error)
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
