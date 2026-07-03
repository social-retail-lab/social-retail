import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import {
  getMemberInfoApi,
  getMemberLevelsApi,
  getPointsBalanceApi,
  getPointsLogsApi,
  getSignInStatusApi,
  signInApi,
  getExchangeCouponsApi,
  exchangeCouponApi,
  calculateDeductionApi,
  getGrowthLogsApi
} from '@/api/member'
import { getNextLevelInfo, getLevelByGrowth, MEMBER_LEVEL_LIST } from '@/constants/member'

export const useMemberStore = defineStore('member', () => {
  // ============ State ============
  const memberInfo = ref(null)
  const memberLevels = ref([])
  const signInStatus = ref(null)
  const exchangeCoupons = ref([])
  const pointsBalance = ref(0)

  // ============ 等级主题色映射 ============
  const levelThemeMap = {
    '普通': { gradient: 'linear-gradient(135deg, #8E8E93, #636366)', bg: '#F5F5F5', text: '#8E8E93' },
    '银卡': { gradient: 'linear-gradient(135deg, #C0C0C0, #A0A0A0)', bg: '#F0F0F2', text: '#888888' },
    '金卡': { gradient: 'linear-gradient(135deg, #F5C842, #E0A800)', bg: '#FFF9E6', text: '#B8860B' },
    '钻石': { gradient: 'linear-gradient(135deg, #2C2C2C, #1A1A1A)', bg: '#1A1A1A', text: '#CCCCCC' }
  }

  const getLevelTheme = (levelName) => {
    if (!levelName) return levelThemeMap['普通']
    if (levelName.includes('钻石')) return levelThemeMap['钻石']
    if (levelName.includes('金')) return levelThemeMap['金卡']
    if (levelName.includes('银')) return levelThemeMap['银卡']
    return levelThemeMap['普通']
  }

  // ============ 成长值进度计算 ============
  const growthValue = computed(() => {
    return Number(memberInfo.value?.growthValue || memberInfo.value?.totalGrowth || 0)
  })

  const currentLevel = computed(() => {
    return getLevelByGrowth(growthValue.value)
  })

  const currentLevelInfo = computed(() => {
    const level = currentLevel.value
    return MEMBER_LEVEL_LIST.find(item => item.level === level) || MEMBER_LEVEL_LIST[0]
  })

  const nextLevelInfo = computed(() => {
    return getNextLevelInfo(growthValue.value)
  })

  const nextLevelGrowth = computed(() => {
    return nextLevelInfo.value?.threshold || 0
  })

  const growthProgress = computed(() => {
    const current = growthValue.value
    const next = nextLevelGrowth.value
    if (next <= 0) return 100
    return Math.min(100, Math.round((current / next) * 100))
  })

  // ============ Actions ============
  
  // 获取会员信息
  const fetchMemberInfo = async () => {
    const res = await getMemberInfoApi()
    if (res.code === 0 && res.data) {
      memberInfo.value = res.data
      pointsBalance.value = Number(res.data.pointsBalance ?? res.data.balance ?? res.data.points ?? 0)
      return res.data
    }
    return null
  }

  // 获取会员等级列表
  const fetchMemberLevels = async () => {
    const res = await getMemberLevelsApi()
    if (res.code === 0 && res.data) {
      const rawList = Array.isArray(res.data) ? res.data : (res.data.list || [])
      // 规范化字段名，确保 levelName 和 benefits 都有值
      memberLevels.value = rawList.map((level, index) => {
        const name = level.memberLevelName || level.levelName || getFallbackLevelName(index)
        return {
          ...level,
          levelName: name,
          memberLevelName: name,
          requiredGrowthValue: level.requiredGrowthValue || 0,
          description: level.description || getFallbackDescription(name),
          benefits: (level.benefits && level.benefits.length > 0) ? level.benefits : getFallbackBenefits(name)
        }
      })
      return memberLevels.value
    }
    return []
  }

  // fallback 等级名称
  const getFallbackLevelName = (index) => {
    const names = ['普通会员', '银卡会员', '金卡会员', '钻石会员']
    return names[index] || '普通会员'
  }

  // fallback 等级描述
  const getFallbackDescription = (name) => {
    const descMap = {
      '普通': '注册后默认成为普通会员',
      '银卡': '成长值达到1000后自动升级',
      '金卡': '成长值达到5000后自动升级',
      '钻石': '成长值达到10000后自动升级'
    }
    if (!name) return descMap['普通']
    if (name.includes('钻石')) return descMap['钻石']
    if (name.includes('金')) return descMap['金卡']
    if (name.includes('银')) return descMap['银卡']
    return descMap['普通']
  }

  // fallback 权益数据
  const getFallbackBenefits = (name) => {
    if (!name) return [{ name: '基础积分', description: '消费后可按规则获得积分' }]
    if (name.includes('钻石')) {
      return [
        { name: '2倍积分累计', description: '消费积分按2倍累计' },
        { name: '会员专属折扣', description: '部分商品享受更高等级会员折扣' },
        { name: '部分订单包邮', description: '部分订单享受会员包邮权益' },
        { name: '生日礼包', description: '生日当月可领取专属礼包' }
      ]
    }
    if (name.includes('金')) {
      return [
        { name: '1.5倍积分累计', description: '消费积分按1.5倍累计' },
        { name: '会员专属折扣', description: '部分商品享受会员专属折扣' },
        { name: '金卡专属优惠券', description: '每月可领取金卡会员专属优惠券' }
      ]
    }
    if (name.includes('银')) {
      return [
        { name: '1.2倍积分累计', description: '消费积分按1.2倍累计' },
        { name: '会员专属优惠券', description: '每月可领取会员专属优惠券' }
      ]
    }
    return [{ name: '基础积分', description: '消费后可按规则获得积分' }]
  }

  // 获取积分余额
  const fetchPointsBalance = async () => {
    const res = await getPointsBalanceApi()
    if (res.code === 0 && res.data) {
      pointsBalance.value = Number(res.data.pointsBalance ?? res.data.balance ?? res.data ?? 0)
      return pointsBalance.value
    }
    return 0
  }

  // 获取积分明细列表
  const fetchPointsLogs = async (params) => {
    const res = await getPointsLogsApi(params)
    if (res.code === 0 && res.data) {
      return {
        list: res.data.list || res.data || [],
        total: res.data.total || 0
      }
    }
    return { list: [], total: 0 }
  }

  // 获取签到状态
  const fetchSignInStatus = async () => {
    const res = await getSignInStatusApi()
    if (res.code === 0 && res.data) {
      signInStatus.value = res.data
      return res.data
    }
    return null
  }

  // 执行签到
  const fetchSignIn = async () => {
    const res = await signInApi()
    if (res.code === 0 && res.data) {
      return res.data
    }
    return null
  }

  // 获取可兑换优惠券列表
  const fetchExchangeCoupons = async () => {
    const res = await getExchangeCouponsApi()
    if (res.code === 0 && res.data) {
      exchangeCoupons.value = Array.isArray(res.data) ? res.data : (res.data.list || [])
      return exchangeCoupons.value
    }
    return []
  }

  // 兑换优惠券
  const fetchExchangeCoupon = async (data) => {
    const res = await exchangeCouponApi(data)
    if (res.code === 0 && res.data) {
      return res.data
    }
    return null
  }

  // 积分抵扣试算
  const fetchCalculateDeduction = async (data) => {
    const res = await calculateDeductionApi(data)
    if (res.code === 0 && res.data) {
      return res.data
    }
    return null
  }

  // 获取成长值明细列表
  const fetchGrowthLogs = async (params) => {
    const res = await getGrowthLogsApi(params)
    if (res.code === 0 && res.data) {
      return {
        list: res.data.list || res.data || [],
        total: res.data.total || 0
      }
    }
    return { list: [], total: 0 }
  }

  return {
    memberInfo,
    memberLevels,
    signInStatus,
    exchangeCoupons,
    pointsBalance,
    growthValue,
    currentLevel,
    currentLevelInfo,
    nextLevelInfo,
    nextLevelGrowth,
    growthProgress,
    getLevelTheme,
    fetchMemberInfo,
    fetchMemberLevels,
    fetchPointsBalance,
    fetchPointsLogs,
    fetchSignInStatus,
    fetchSignIn,
    fetchExchangeCoupons,
    fetchExchangeCoupon,
    fetchCalculateDeduction,
    fetchGrowthLogs
  }
})
