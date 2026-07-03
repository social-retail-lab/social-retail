import { defineStore } from 'pinia'
import { ref } from 'vue'
import {
  getBannerList,
  getCurrentSeckillActivityApi,
  getCurrentSeckillProductsApi,
  checkSeckillQualificationApi,
  getCouponList,
  receiveCoupon,
  getMyCouponList,
  getPromotionRule,
  getRecommendGoods
} from '@/api/promotion'

export const usePromotionStore = defineStore('promotion', () => {
  const bannerList = ref([])
  // 当前秒杀活动信息（预热中/进行中），null 表示暂无活动
  const seckillActivity = ref(null)
  // 当前秒杀活动商品列表
  const seckillProductList = ref([])
  const seckillTotal = ref(0)
  const seckillPage = ref(1)
  const seckillPageSize = ref(10)
  const seckillPages = ref(0)
  const couponList = ref([])
  const myCouponList = ref([])
  const promotionRule = ref(null)
  const recommendGoods = ref([])

  const fetchBannerList = async (params) => {
    const res = await getBannerList(params)
    if (res.code === 0 && res.data) {
      bannerList.value = Array.isArray(res.data) ? res.data : (res.data.list || [])
      return bannerList.value
    }
    return []
  }

  // 获取当前秒杀活动详情
  // 返回 null 表示暂无活动
  const fetchCurrentSeckillActivity = async () => {
    const res = await getCurrentSeckillActivityApi()
    if (res.code === 0) {
      seckillActivity.value = res.data || null
      return seckillActivity.value
    }
    return null
  }

  // 获取当前秒杀活动商品列表（分页）
  // 无活动时返回空列表
  const fetchCurrentSeckillProducts = async (params) => {
    const res = await getCurrentSeckillProductsApi(params)
    if (res.code === 0 && res.data) {
      const data = res.data
      seckillProductList.value = Array.isArray(data.list) ? data.list : []
      seckillTotal.value = data.total || 0
      seckillPage.value = data.page || 1
      seckillPageSize.value = data.pageSize || 10
      seckillPages.value = data.pages || 0
      return data
    }
    return null
  }

  // 清空秒杀数据（切换活动或退出时调用）
  const clearSeckillData = () => {
    seckillActivity.value = null
    seckillProductList.value = []
    seckillTotal.value = 0
    seckillPage.value = 1
    seckillPages.value = 0
  }

  // 秒杀资格校验
  // 返回 { canBuy, reason, remainingStock, limitQuantity, alreadyBoughtQuantity }
  // canBuy=false 时 reason 字段说明不可购买原因
  const fetchCheckSeckillQualification = async (seckillProductId) => {
    const res = await checkSeckillQualificationApi(seckillProductId)
    if (res.code === 0 && res.data) {
      return res.data
    }
    return null
  }

  const fetchCouponList = async (params) => {
    const res = await getCouponList(params)
    if (res.code === 0 && res.data) {
      couponList.value = Array.isArray(res.data) ? res.data : (res.data.list || [])
      return couponList.value
    }
    return []
  }

  const fetchReceiveCoupon = async (id) => {
    const res = await receiveCoupon(id)
    if (res.code === 0) {
      return true
    }
    return false
  }

  const fetchMyCouponList = async (params) => {
    const res = await getMyCouponList(params)
    if (res.code === 0 && res.data) {
      myCouponList.value = Array.isArray(res.data) ? res.data : (res.data.list || [])
      return myCouponList.value
    }
    return []
  }

  const fetchPromotionRule = async () => {
    const res = await getPromotionRule()
    if (res.code === 0 && res.data) {
      promotionRule.value = res.data
      return promotionRule.value
    }
    return null
  }

  const fetchRecommendGoods = async (params) => {
    const res = await getRecommendGoods(params)
    if (res.code === 0 && res.data) {
      recommendGoods.value = Array.isArray(res.data) ? res.data : (res.data.list || [])
      return recommendGoods.value
    }
    return []
  }

  return {
    bannerList,
    seckillActivity,
    seckillProductList,
    seckillTotal,
    seckillPage,
    seckillPageSize,
    seckillPages,
    couponList,
    myCouponList,
    promotionRule,
    recommendGoods,
    fetchBannerList,
    fetchCurrentSeckillActivity,
    fetchCurrentSeckillProducts,
    clearSeckillData,
    fetchCheckSeckillQualification,
    fetchCouponList,
    fetchReceiveCoupon,
    fetchMyCouponList,
    fetchPromotionRule,
    fetchRecommendGoods
  }
})