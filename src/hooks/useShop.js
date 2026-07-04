import { ref } from 'vue'
import { useMerchantStore } from '@/store/merchant'
import { showToast, showLoading, hideLoading } from '@/utils/common'
import {
  MERCHANT_COUPON_ERROR_CODE,
  isCouponReceivable
} from '@/constants/merchantCoupon'
import {
  MERCHANT_ERROR_MSG
} from '@/constants/merchant'

/**
 * 商家相关业务 Hook
 * 封装商家主页、商家信息、商家商品列表、商家优惠券的异步逻辑、loading、try-catch、toast
 */
export const useShop = () => {
  const merchantStore = useMerchantStore()
  const loading = ref(false)
  const productLoading = ref(false)
  const couponLoading = ref(false)
  const refreshing = ref(false)

  // ============ 商家错误码映射(来自常量) ============
  const merchantErrorCodeMap = MERCHANT_ERROR_MSG

  /**
   * 加载商家主页详情(2.9.1)
   */
  const loadMerchantHome = async (merchantId) => {
    if (!merchantId) {
      showToast('商家ID不能为空')
      return null
    }
    loading.value = true
    try {
      const res = await merchantStore.fetchMerchantHome(merchantId)
      if (!res) {
        // 商家不存在或不可访问,由调用方处理
        return null
      }
      return res
    } catch (error) {
      console.error('获取商家主页失败:', error)
      const errMsg = merchantErrorCodeMap[error?.code] || error?.message || '获取商家信息失败'
      showToast(errMsg)
      return null
    } finally {
      loading.value = false
    }
  }

  /**
   * 加载商家基础信息(2.9.2)
   */
  const loadMerchantInfo = async (merchantId) => {
    if (!merchantId) {
      showToast('商家ID不能为空')
      return null
    }
    try {
      const res = await merchantStore.fetchMerchantInfo(merchantId)
      return res
    } catch (error) {
      console.error('获取商家信息失败:', error)
      const errMsg = merchantErrorCodeMap[error?.code] || error?.message || '获取商家信息失败'
      showToast(errMsg)
      return null
    }
  }

  /**
   * 加载商家商品列表(2.9.3 / 2.9.6)
   * 2.9.6 商家主页搜索商品复用 2.9.3 接口,通过 keyword 参数实现
   * @param {Number|String} merchantId 商家ID
   * @param {Object} params { keyword, saleType, sort, page, pageSize }
   * @param {Boolean} isLoadMore 是否加载更多(分页)
   */
  const loadMerchantProducts = async (merchantId, params = {}, isLoadMore = false) => {
    if (!merchantId) return { list: [], total: 0, pages: 0 }
    if (!isLoadMore) {
      productLoading.value = true
    }
    try {
      const res = await merchantStore.fetchMerchantProducts(merchantId, params)
      return res
    } catch (error) {
      console.error('获取商家商品列表失败:', error)
      // base.js 已对业务错误码(含 40031 关键词为空)做了 toast,
      // 此处仅在非业务错误(如非 5xx 的 HTTP 错误)且非分页加载时兜底提示
      if (!isLoadMore && !error?.code) {
        showToast('商品加载失败，请稍后重试')
      }
      return { list: [], total: 0, pages: 0 }
    } finally {
      productLoading.value = false
    }
  }

  /**
   * 加载商家优惠券列表(4.3.1)
   * @param {Number|String} merchantId 商家ID
   * @param {Object} params { page, pageSize }
   * @param {Boolean} isLoadMore 是否加载更多(分页)
   */
  const loadMerchantCoupons = async (merchantId, params = {}, isLoadMore = false) => {
    if (!merchantId) return { list: [], total: 0, pages: 0 }
    try {
      const res = await merchantStore.fetchMerchantCoupons(merchantId, params)
      return res
    } catch (error) {
      console.error('获取商家优惠券列表失败:', error)
      if (!isLoadMore) {
        // base.js 已对常见错误码做了 toast,此处仅在非分页加载时静默兜底
      }
      return { list: [], total: 0, pages: 0 }
    }
  }

  /**
   * 领取商家优惠券(4.3.2)
   * 处理幂等响应、错误码映射、本地状态同步
   * @param {Object|Number} coupon 优惠券对象或 couponId
   * @returns {Object|null} 领取结果,null 表示失败
   */
  const receiveCoupon = async (coupon) => {
    // 兼容传入 coupon 对象或 couponId
    const couponObj = typeof coupon === 'object' ? coupon : { couponId: coupon }
    const couponId = couponObj.couponId

    if (!couponId) {
      showToast('优惠券ID不能为空')
      return null
    }

    // 前端预校验:已领取/已领完
    if (!isCouponReceivable(couponObj)) {
      if (couponObj.alreadyReceived) {
        showToast('已领取过该优惠券')
      } else {
        showToast('优惠券已领完')
      }
      return null
    }

    if (couponLoading.value) return null
    couponLoading.value = true
    showLoading('领取中...')
    try {
      const res = await merchantStore.fetchReceiveCoupon(couponId)
      if (res) {
        // 本地同步更新优惠券状态(避免重新拉取列表)
        merchantStore.updateCouponReceiveStatus(couponId)

        // 幂等响应(重复请求)特殊提示
        if (res.idempotent) {
          hideLoading()
          showToast('已领取过该优惠券', 'none')
        } else {
          hideLoading()
          showToast('领取成功', 'success')
        }
        return res
      }
      hideLoading()
      return null
    } catch (error) {
      hideLoading()
      console.error('领取商家优惠券失败:', error)
      // base.js 已对错误做了 toast,这里不再重复 toast
      // 仅根据特定错误码做额外处理
      const code = error?.code
      // 已达限领:本地同步更新 alreadyReceived 状态
      if (code === MERCHANT_COUPON_ERROR_CODE.LIMIT_REACHED) {
        merchantStore.updateCouponReceiveStatus(couponId)
      }
      // 已领完:本地同步更新 remainingCount
      if (code === MERCHANT_COUPON_ERROR_CODE.SOLD_OUT) {
        if (merchantStore.merchantHome?.couponList) {
          merchantStore.merchantHome.couponList.forEach(item => {
            if (Number(item.couponId) === Number(couponId)) {
              item.remainingCount = 0
            }
          })
        }
        merchantStore.merchantCoupons.forEach(item => {
          if (Number(item.couponId) === Number(couponId)) {
            item.remainingCount = 0
          }
        })
      }
      return null
    } finally {
      couponLoading.value = false
    }
  }

  /**
   * 联系商家(拨打电话)
   */
  const contactMerchant = (phone) => {
    if (!phone) {
      showToast('暂无联系电话')
      return
    }
    // 脱敏电话不支持直接拨打,提示用户
    if (phone.includes('*')) {
      showToast('请联系平台客服获取商家电话')
      return
    }
    uni.makePhoneCall({
      phoneNumber: phone,
      fail: () => {
        showToast('拨号取消')
      }
    })
  }

  /**
   * 复制商家地址
   */
  const copyAddress = (address) => {
    if (!address) {
      showToast('暂无地址信息')
      return
    }
    uni.setClipboardData({
      data: address,
      success: () => {
        showToast('地址已复制', 'success')
      }
    })
  }

  /**
   * 跳转商品详情
   */
  const goProductDetail = (productId) => {
    if (!productId) return
    uni.navigateTo({
      url: `/pagesSub/goods/detail/goodsDetail?productId=${productId}`,
      animationType: 'slide-in-right',
      animationDuration: 200
    })
  }

  /**
   * 重置商家数据(离开页面时调用)
   */
  const resetShopData = () => {
    merchantStore.resetMerchantData()
  }

  return {
    merchantStore,
    loading,
    productLoading,
    couponLoading,
    refreshing,
    loadMerchantHome,
    loadMerchantInfo,
    loadMerchantProducts,
    loadMerchantCoupons,
    contactMerchant,
    copyAddress,
    goProductDetail,
    receiveCoupon,
    resetShopData
  }
}
