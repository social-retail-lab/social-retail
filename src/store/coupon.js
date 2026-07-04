import { defineStore } from 'pinia'
import { ref } from 'vue'
import { getMyCouponsApi, getAvailableCouponsApi } from '@/api/coupon'
import { DEFAULT_COUPON_USE_RULE } from '@/constants/coupon'

export const useCouponStore = defineStore('coupon', () => {
  // ============ State ============
  // 我的优惠券(4.3.3)
  const myCouponList = ref([])      // 我的优惠券列表
  const couponTotal = ref(0)        // 总数
  const couponPages = ref(0)        // 总页数
  const couponPage = ref(1)         // 当前页码
  const couponPageSize = ref(10)    // 每页数量

  // 订单可用优惠券(4.3.4)
  const availablePlatformCoupons = ref([])  // 可用平台券列表
  const availableMerchantCoupons = ref([])  // 可用商家券列表
  const settlementAmount = ref(0)            // 本次结算金额
  const settlementMerchantId = ref(null)     // 本次结算商家ID
  const settlementMerchantName = ref('')     // 本次结算商家名称
  const couponUseRule = ref({ ...DEFAULT_COUPON_USE_RULE })  // 使用规则

  // ============ Actions ============

  /**
   * 获取我的优惠券列表(4.3.3)
   * 支持分页、状态筛选、来源筛选、商家筛选
   * @param {Object} params { source, status, merchantId, page, pageSize }
   * @param {Boolean} isLoadMore 是否加载更多(分页追加)
   */
  const fetchMyCoupons = async (params = {}, isLoadMore = false) => {
    const res = await getMyCouponsApi(params)
    if (res.code === 0 && res.data) {
      // 第一页直接覆盖,后续页追加
      if (isLoadMore) {
        myCouponList.value = [...myCouponList.value, ...res.data.list]
      } else {
        myCouponList.value = res.data.list
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
   * 获取订单可用优惠券(4.3.4)
   * @param {Array<Number|String>} cartItemIds 购物车明细ID列表
   */
  const fetchAvailableCoupons = async (cartItemIds) => {
    const res = await getAvailableCouponsApi(cartItemIds)
    if (res.code === 0 && res.data) {
      availablePlatformCoupons.value = res.data.platformCoupons
      availableMerchantCoupons.value = res.data.merchantCoupons
      settlementAmount.value = res.data.settlementAmount
      settlementMerchantId.value = res.data.merchantId
      settlementMerchantName.value = res.data.merchantName
      couponUseRule.value = res.data.useRule
      return res.data
    }
    return null
  }

  /**
   * 重置我的优惠券数据(离开页面时调用)
   */
  const resetCouponData = () => {
    myCouponList.value = []
    couponTotal.value = 0
    couponPages.value = 0
    couponPage.value = 1
    couponPageSize.value = 10
  }

  /**
   * 重置订单可用优惠券数据
   */
  const resetAvailableCoupons = () => {
    availablePlatformCoupons.value = []
    availableMerchantCoupons.value = []
    settlementAmount.value = 0
    settlementMerchantId.value = null
    settlementMerchantName.value = ''
    couponUseRule.value = { ...DEFAULT_COUPON_USE_RULE }
  }

  return {
    myCouponList,
    couponTotal,
    couponPages,
    couponPage,
    couponPageSize,
    availablePlatformCoupons,
    availableMerchantCoupons,
    settlementAmount,
    settlementMerchantId,
    settlementMerchantName,
    couponUseRule,
    fetchMyCoupons,
    fetchAvailableCoupons,
    resetCouponData,
    resetAvailableCoupons
  }
})
