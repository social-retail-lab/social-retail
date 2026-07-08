import { defineStore } from 'pinia'
import { ref } from 'vue'
import {
  getMerchantHomeApi,
  getMerchantInfoApi,
  getMerchantProductsApi,
  getMerchantCouponsApi,
  receiveMerchantCouponApi
} from '@/api/merchant'

export const useMerchantStore = defineStore('merchantShop', () => {
  // ============ State ============
  const merchantHome = ref(null)       // 商家主页详情(2.9.1)
  const merchantInfo = ref(null)       // 商家基础信息(2.9.2)
  const merchantProducts = ref([])     // 商家商品列表(2.9.3)
  const productTotal = ref(0)          // 商品总数
  const productPages = ref(0)          // 商品总页数
  const productPage = ref(1)           // 当前页码
  const productPageSize = ref(10)      // 每页数量

  // 商家优惠券(4.3.1)
  const merchantCoupons = ref([])      // 商家优惠券列表
  const couponTotal = ref(0)           // 优惠券总数
  const couponPages = ref(0)           // 优惠券总页数
  const couponPage = ref(1)            // 当前页码
  const couponPageSize = ref(10)       // 每页数量

  // ============ Actions ============

  /**
   * 获取商家主页详情(2.9.1)
   */
  const fetchMerchantHome = async (merchantId) => {
    const res = await getMerchantHomeApi(merchantId)
    if (res.code === 0 && res.data) {
      merchantHome.value = res.data
      return res.data
    }
    // 商家不存在(40431)或不可访问(40931)时返回错误信息
    return null
  }

  /**
   * 获取商家基础信息(2.9.2)
   */
  const fetchMerchantInfo = async (merchantId) => {
    const res = await getMerchantInfoApi(merchantId)
    if (res.code === 0 && res.data) {
      merchantInfo.value = res.data
      return res.data
    }
    return null
  }

  /**
   * 获取商家商品列表(2.9.3)
   */
  const fetchMerchantProducts = async (merchantId, params = {}) => {
    const res = await getMerchantProductsApi(merchantId, params)
    if (res.code === 0 && res.data) {
      // 第一页直接覆盖,后续页追加
      const isRefresh = !params.page || Number(params.page) === 1
      if (isRefresh) {
        merchantProducts.value = res.data.list
      } else {
        merchantProducts.value = [...merchantProducts.value, ...res.data.list]
      }
      productTotal.value = res.data.total
      productPages.value = res.data.pages
      productPage.value = res.data.page
      productPageSize.value = res.data.pageSize
      return res.data
    }
    return { list: [], total: 0, pages: 0, page: 1, pageSize: 10 }
  }

  /**
   * 获取商家优惠券列表(4.3.1)
   */
  const fetchMerchantCoupons = async (merchantId, params = {}) => {
    const res = await getMerchantCouponsApi(merchantId, params)
    if (res.code === 0 && res.data) {
      const isRefresh = !params.page || Number(params.page) === 1
      if (isRefresh) {
        merchantCoupons.value = res.data.list
      } else {
        merchantCoupons.value = [...merchantCoupons.value, ...res.data.list]
      }
      couponTotal.value = res.data.total
      couponPages.value = res.data.pages
      couponPage.value = res.data.page
      couponPageSize.value = res.data.pageSize
      return res.data
    }
    return { list: [], total: 0, pages: 0, page: 1, pageSize: 10 }
  }

  /**
   * 领取商家优惠券(4.3.2)
   * 仅调用 API,不处理提示
   */
  const fetchReceiveCoupon = async (couponId) => {
    const res = await receiveMerchantCouponApi(couponId)
    if (res.code === 0) {
      return res.data
    }
    return null
  }

  /**
   * 本地更新优惠券领取状态(领取成功后调用)
   * 同步更新 merchantHome.couponList 和 merchantCoupons 中的对应优惠券
   */
  const updateCouponReceiveStatus = (couponId) => {
    const updateItem = (item) => {
      if (item && Number(item.couponId) === Number(couponId)) {
        item.alreadyReceived = true
        item.receivedCount = Number(item.receivedCount || 0) + 1
        item.remainingCount = Math.max(0, Number(item.remainingCount || 0) - 1)
      }
    }

    // 同步 merchantHome.couponList
    if (merchantHome.value?.couponList) {
      merchantHome.value.couponList.forEach(updateItem)
    }

    // 同步 merchantCoupons
    merchantCoupons.value.forEach(updateItem)
  }

  /**
   * 重置商家数据(离开商家页面时调用)
   */
  const resetMerchantData = () => {
    merchantHome.value = null
    merchantInfo.value = null
    merchantProducts.value = []
    productTotal.value = 0
    productPages.value = 0
    productPage.value = 1
    productPageSize.value = 10
    merchantCoupons.value = []
    couponTotal.value = 0
    couponPages.value = 0
    couponPage.value = 1
    couponPageSize.value = 10
  }

  return {
    merchantHome,
    merchantInfo,
    merchantProducts,
    productTotal,
    productPages,
    productPage,
    productPageSize,
    merchantCoupons,
    couponTotal,
    couponPages,
    couponPage,
    couponPageSize,
    fetchMerchantHome,
    fetchMerchantInfo,
    fetchMerchantProducts,
    fetchMerchantCoupons,
    fetchReceiveCoupon,
    updateCouponReceiveStatus,
    resetMerchantData
  }
})
