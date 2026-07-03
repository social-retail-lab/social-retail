import { defineStore } from 'pinia'
import { ref } from 'vue'
import { 
  getBannerList, 
  getSeckillActivity, 
  getSeckillList, 
  getSeckillGoods, 
  getSeckillDetail,
  seckillOrder,
  getCouponList,
  receiveCoupon,
  getMyCouponList,
  getPromotionRule,
  getRecommendGoods
} from '@/api/promotion'

export const usePromotionStore = defineStore('promotion', () => {
  const bannerList = ref([])
  const seckillActivity = ref(null)
  const seckillList = ref([])
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

  const fetchSeckillActivity = async () => {
    const res = await getSeckillActivity()
    if (res.code === 0 && res.data) {
      seckillActivity.value = res.data
      return seckillActivity.value
    }
    return null
  }

  const fetchSeckillList = async () => {
    const res = await getSeckillList()
    if (res.code === 0 && res.data) {
      seckillList.value = Array.isArray(res.data) ? res.data : (res.data.list || [])
      return seckillList.value
    }
    return []
  }

  const fetchSeckillGoods = async (params) => {
    const res = await getSeckillGoods(params)
    if (res.code === 0 && res.data) {
      return res.data
    }
    return null
  }

  const fetchSeckillDetail = async (id) => {
    const res = await getSeckillDetail(id)
    if (res.code === 0 && res.data) {
      return res.data
    }
    return null
  }

  const fetchSeckillOrder = async (data) => {
    const res = await seckillOrder(data)
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
    seckillList,
    couponList,
    myCouponList,
    promotionRule,
    recommendGoods,
    fetchBannerList,
    fetchSeckillActivity,
    fetchSeckillList,
    fetchSeckillGoods,
    fetchSeckillDetail,
    fetchSeckillOrder,
    fetchCouponList,
    fetchReceiveCoupon,
    fetchMyCouponList,
    fetchPromotionRule,
    fetchRecommendGoods
  }
})