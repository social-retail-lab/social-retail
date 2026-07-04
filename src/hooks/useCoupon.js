import { ref } from 'vue'
import { useCouponStore } from '@/store/coupon'
import { showToast } from '@/utils/common'

// 模块级变量:暂存选择优惠券页面的入参(避免污染 store 响应式系统)
let _selectCouponParams = null

/**
 * 获取暂存的选择优惠券入参(供 selectCoupon 页面 onLoad 读取)
 * @returns {Object|null}
 */
export const getSelectCouponParams = () => _selectCouponParams

/**
 * 清除暂存的选择优惠券入参
 */
export const clearSelectCouponParams = () => {
  _selectCouponParams = null
}

/**
 * 我的优惠券业务 Hook
 * 封装"我的优惠券"页面的异步逻辑、loading、try-catch、toast
 */
export const useCoupon = () => {
  const couponStore = useCouponStore()
  const loading = ref(false)
  const refreshing = ref(false)

  /**
   * 加载我的优惠券列表(4.3.3)
   * @param {Object} params { source, status, merchantId, page, pageSize }
   * @param {Boolean} isLoadMore 是否加载更多(分页)
   */
  const loadMyCoupons = async (params = {}, isLoadMore = false) => {
    if (!isLoadMore) {
      loading.value = true
    }
    try {
      const res = await couponStore.fetchMyCoupons(params, isLoadMore)
      return res
    } catch (error) {
      console.error('获取我的优惠券列表失败:', error)
      if (!isLoadMore) {
        // base.js 已对常见错误码做了 toast,此处仅在非分页加载时静默兜底
      }
      return { list: [], total: 0, pages: 0 }
    } finally {
      loading.value = false
    }
  }

  /**
   * 跳转到我的优惠券页面
   * @param {Object} options { status, source, merchantId }
   */
  const goMyCoupon = (options = {}) => {
    const query = []
    if (options.status !== undefined) {
      query.push(`status=${options.status}`)
    }
    if (options.source) {
      query.push(`source=${options.source}`)
    }
    if (options.merchantId) {
      query.push(`merchantId=${options.merchantId}`)
    }
    const queryString = query.length > 0 ? `?${query.join('&')}` : ''
    uni.navigateTo({
      url: `/pagesSub/promotion/coupon/myCoupon${queryString}`,
      animationType: 'slide-in-right',
      animationDuration: 200
    })
  }

  /**
   * 跳转去使用(暂未接入下单流程,提示用户)
   */
  const goUseCoupon = (coupon) => {
    if (!coupon) return
    // 仅未使用状态可使用
    if (Number(coupon.status) !== 0) {
      showToast('该优惠券不可使用')
      return
    }
    // 商家券:跳转商家主页
    if (coupon.source === 'MERCHANT' && coupon.merchantId) {
      uni.navigateTo({
        url: `/pagesSub/shop/shopHome?merchantId=${coupon.merchantId}`,
        animationType: 'slide-in-right',
        animationDuration: 200
      })
      return
    }
    // 平台券:跳转首页挑选商品
    uni.switchTab({ url: '/pages/home/home' })
  }

  /**
   * 查看优惠券使用规则/详情
   */
  const goCouponDetail = (coupon) => {
    if (!coupon) return
    const lines = [
      `优惠券：${coupon.title || ''}`,
      `来源：${coupon.sourceText || ''}`,
      coupon.merchantName ? `商家：${coupon.merchantName}` : '',
      `门槛：满 ${coupon.minConsume || 0} 元可用`,
      `优惠：减 ${coupon.discountAmount || 0} 元`,
      `有效期：${coupon.validStart || '—'} 至 ${coupon.validEnd || '—'}`,
      `状态：${coupon.statusText || ''}`
    ].filter(Boolean)
    uni.showModal({
      title: '优惠券详情',
      content: lines.join('\n'),
      showCancel: false,
      confirmText: '我知道了'
    })
  }

  /**
   * 重置优惠券数据(离开页面时调用)
   */
  const resetCouponData = () => {
    couponStore.resetCouponData()
  }

  /**
   * 加载订单可用优惠券(4.3.4)
   * @param {Array<Number|String>} cartItemIds 购物车明细ID列表
   * @returns {Object|null} 可用优惠券数据
   */
  const loadAvailableCoupons = async (cartItemIds) => {
    if (!Array.isArray(cartItemIds) || cartItemIds.length === 0) {
      showToast('请先选择结算商品')
      return null
    }
    loading.value = true
    try {
      const res = await couponStore.fetchAvailableCoupons(cartItemIds)
      return res
    } catch (error) {
      console.error('获取订单可用优惠券失败:', error)
      // base.js 已对常见错误码做了 toast,此处不再重复
      return null
    } finally {
      loading.value = false
    }
  }

  /**
   * 重置订单可用优惠券数据(离开订单确认页时调用)
   */
  const resetAvailableCoupons = () => {
    couponStore.resetAvailableCoupons()
  }

  /**
   * 跳转到选择优惠券页面
   * 通过 eventChannel 接收选择结果
   * @param {Object} options
   *   - cartItemIds {Array} 购物车明细ID列表
   *   - source {String} 选择来源 PLATFORM/MERCHANT
   *   - selectedCouponUserId {Number} 当前已选中的优惠券用户ID(用于回显)
   */
  const goSelectCoupon = (options = {}) => {
    const { cartItemIds = [], source = '', selectedCouponUserId = null } = options
    if (!cartItemIds.length) {
      showToast('请先选择结算商品')
      return
    }
    // 通过模块级变量暂存参数,避免 URL 编码数组
    _selectCouponParams = { cartItemIds, source, selectedCouponUserId }
    uni.navigateTo({
      url: '/pagesSub/promotion/coupon/selectCoupon',
      animationType: 'slide-in-right',
      animationDuration: 200
    })
  }

  return {
    couponStore,
    loading,
    refreshing,
    loadMyCoupons,
    goMyCoupon,
    goUseCoupon,
    goCouponDetail,
    resetCouponData,
    loadAvailableCoupons,
    resetAvailableCoupons,
    goSelectCoupon
  }
}
