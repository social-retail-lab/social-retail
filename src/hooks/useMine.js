import { ref, watch, onMounted } from 'vue'
import { useUserStore } from '@/store/user'
import { showToast } from '@/utils/common'

export function useMine() {
  const userStore = useUserStore()
  const loading = ref(true)
  const refreshing = ref(false)
  
  const userData = ref({})
  const memberData = ref({})
  const distributorData = ref({})
  const orderStats = ref({})
  const assetStats = ref({})
  const unreadCount = ref(0)
  
  const growthProgress = ref(0)
  
  const calculateGrowthProgress = () => {
    const totalGrowth = Number(memberData.value.totalGrowth) || 0
    const nextLevelGrowth = Number(memberData.value.nextLevelGrowth) || 0
    if (nextLevelGrowth > 0) {
      growthProgress.value = Math.min((totalGrowth / nextLevelGrowth) * 100, 100)
    } else {
      growthProgress.value = 100
    }
  }
  
  const loadUserInfo = async () => {
    if (!userStore.isLogin) {
      userData.value = {}
      memberData.value = {}
      distributorData.value = {}
      orderStats.value = {}
      assetStats.value = {}
      unreadCount.value = 0
      growthProgress.value = 0
      return
    }
    
    try {
      const res = await userStore.fetchUserInfo()
      
      if (res && res.userInfo) {
        const info = res.userInfo
        
        userData.value = {
          userId: info.userId || '',
          nickname: info.nickname || '',
          avatar: info.avatar || '',
          phone: info.phone || '',
          status: info.status || 'NORMAL'
        }
        
        if (info.memberInfo) {
          memberData.value = {
            memberId: info.memberInfo.memberId || '',
            levelId: info.memberInfo.levelId || 0,
            levelName: info.memberInfo.levelName || '普通用户',
            points: info.memberInfo.points || 0,
            totalGrowth: info.memberInfo.totalGrowth || 0,
            nextLevelGrowth: info.memberInfo.nextLevelGrowth || 2000
          }
          
          userStore.memberInfo = { ...userStore.memberInfo, ...info.memberInfo }
        } else {
          memberData.value = {
            memberId: '',
            levelId: 0,
            levelName: '普通用户',
            points: 0,
            totalGrowth: 0,
            nextLevelGrowth: 2000
          }
        }
        
        if (info.distributorInfo !== undefined) {
          distributorData.value = info.distributorInfo
          
          if (info.distributorInfo && info.distributorInfo.status === 'APPROVED') {
            userStore.distributorInfo = info.distributorInfo
          } else {
            userStore.distributorInfo = null
          }
        } else {
          distributorData.value = {}
        }
        
        if (info.orderCount) {
          orderStats.value = {
            pendingPayment: info.orderCount.pendingPayment || 0,
            pendingShipment: info.orderCount.pendingShipment || 0,
            pendingReceipt: info.orderCount.pendingReceipt || 0,
            pendingReview: info.orderCount.pendingReview || 0,
            afterSale: info.orderCount.afterSale || 0
          }
        } else {
          orderStats.value = {
            pendingPayment: 0,
            pendingShipment: 0,
            pendingReceipt: 0,
            pendingReview: 0,
            afterSale: 0
          }
        }
        
        const points = memberData.value.points || 0
        const growth = memberData.value.totalGrowth || 0
        
        assetStats.value = {
          couponCount: info.couponCount || 0,
          points,
          growth
        }
        
        unreadCount.value = info.unreadMessageCount || 0
        
        calculateGrowthProgress()
      } else {
        userData.value = {}
        memberData.value = {}
        distributorData.value = {}
        orderStats.value = {}
        assetStats.value = {}
        unreadCount.value = 0
        growthProgress.value = 0
      }
    } catch (error) {
      console.error('获取用户信息失败:', error)
      showToast('获取用户信息失败')
      userData.value = {}
      memberData.value = {}
      distributorData.value = {}
      orderStats.value = {}
      assetStats.value = {}
      unreadCount.value = 0
      growthProgress.value = 0
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