import { ref } from 'vue'
import { useMemberStore } from '@/store/member'
import { showToast, showLoading, hideLoading } from '@/utils/common'

export const useMember = () => {
  const memberStore = useMemberStore()
  const loading = ref(false)
  const signInLoading = ref(false)
  const exchangeLoading = ref(false)

  // 加载会员信息
  const loadMemberInfo = async () => {
    try {
      const res = await memberStore.fetchMemberInfo()
      return res
    } catch (error) {
      console.error('获取会员信息失败:', error)
      return null
    }
  }

  // 加载会员等级列表
  const loadMemberLevels = async () => {
    loading.value = true
    try {
      const res = await memberStore.fetchMemberLevels()
      return res
    } catch (error) {
      console.error('获取会员等级失败:', error)
      showToast('数据加载失败，请稍后重试')
      return []
    } finally {
      loading.value = false
    }
  }

  // 加载签到状态
  const loadSignInStatus = async () => {
    try {
      const res = await memberStore.fetchSignInStatus()
      return res
    } catch (error) {
      console.error('获取签到状态失败:', error)
      return null
    }
  }

  // 执行签到
  const doSignIn = async () => {
    if (signInLoading.value) return null
    signInLoading.value = true
    showLoading('签到中...')
    try {
      const res = await memberStore.fetchSignIn()
      if (res) {
        const reward = res.rewardPoints || 0
        showToast(`签到成功，获得 ${reward} 积分`, 'success')
        await loadMemberInfo()
        await loadSignInStatus()
        return res
      }
      return null
    } catch (error) {
      console.error('签到失败:', error)
      if (error && (error.code === 40954 || error.code === 409)) {
        showToast('今日已签到')
      } else {
        showToast('签到失败，请稍后重试')
      }
      return null
    } finally {
      hideLoading()
      signInLoading.value = false
    }
  }

  // 加载可兑换优惠券列表
  const loadExchangeCoupons = async () => {
    try {
      const res = await memberStore.fetchExchangeCoupons()
      return res
    } catch (error) {
      console.error('获取优惠券列表失败:', error)
      return []
    }
  }

  // 兑换优惠券
  const doExchangeCoupon = async (couponId, usePoints) => {
    if (exchangeLoading.value) return null
    exchangeLoading.value = true
    showLoading('兑换中...')
    try {
      const res = await memberStore.fetchExchangeCoupon({ couponId, usePoints })
      if (res) {
        showToast('兑换成功', 'success')
        await loadMemberInfo()
        await loadExchangeCoupons()
        return res
      }
      return null
    } catch (error) {
      console.error('兑换优惠券失败:', error)
      if (error) {
        if (error.code === 40951) {
          showToast('积分不足')
        } else if (error.code === 40451) {
          showToast('优惠券不存在')
        } else if (error.code === 40953) {
          showToast('库存不足')
        } else {
          showToast('兑换失败，请稍后重试')
        }
      }
      return null
    } finally {
      hideLoading()
      exchangeLoading.value = false
    }
  }

  // 加载积分明细（分页）
  const loadPointsLogs = async (params) => {
    try {
      const res = await memberStore.fetchPointsLogs(params)
      return res
    } catch (error) {
      console.error('获取积分明细失败:', error)
      showToast('数据加载失败，请稍后重试')
      return { list: [], total: 0 }
    }
  }

  // 加载成长值明细（分页）
  const loadGrowthLogs = async (params) => {
    try {
      const res = await memberStore.fetchGrowthLogs(params)
      return res
    } catch (error) {
      console.error('获取成长值明细失败:', error)
      showToast('数据加载失败，请稍后重试')
      return { list: [], total: 0 }
    }
  }

  // 积分抵扣试算（订单确认页联动）
  const calculateDeduction = async (data) => {
    try {
      const res = await memberStore.fetchCalculateDeduction(data)
      return res
    } catch (error) {
      console.error('积分抵扣试算失败:', error)
      if (error) {
        showToast(error.message || '试算失败')
      }
      return null
    }
  }

  // 是否已加载过（首次加载完成后置为 true，避免后续 onShow 闪现）
  const loaded = ref(false)

  // 刷新全部会员数据（onShow / 下拉刷新调用）
  const refreshAllMemberData = async () => {
    // 仅首次加载时显示 loading（已加载过则保留旧数据，避免闪现）
    if (!loaded.value) {
      loading.value = true
    }
    try {
      await Promise.all([
        loadMemberInfo(),
        loadSignInStatus(),
        loadExchangeCoupons()
      ])
      loaded.value = true
    } finally {
      loading.value = false
    }
  }

  return {
    memberStore,
    loading,
    loaded,
    signInLoading,
    exchangeLoading,
    loadMemberInfo,
    loadMemberLevels,
    loadSignInStatus,
    doSignIn,
    loadExchangeCoupons,
    doExchangeCoupon,
    loadPointsLogs,
    loadGrowthLogs,
    calculateDeduction,
    refreshAllMemberData
  }
}
