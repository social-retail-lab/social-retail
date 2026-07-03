import { ref } from 'vue'
import { usePromotionStore } from '@/store/promotion'
import { useUserStore } from '@/store/user'
import { showToast, getValidImageUrl } from '@/utils/common'

export const usePromotion = () => {
  const promotionStore = usePromotionStore()
  const userStore = useUserStore()
  const loading = ref(false)

  const loadBannerList = async (params = {}) => {
    try {
      const res = await promotionStore.fetchBannerList(params)
      return res.map(item => ({
        id: item.id,
        image: getValidImageUrl(item.image, 'e-commerce%20banner%20promotion'),
        type: item.type || 'goods',
        target_id: item.targetId || item.target_id || ''
      }))
    } catch (error) {
      console.error('获取轮播图失败:', error)
      return []
    }
  }

  // ============ 秒杀活动 ============

  // 加载当前秒杀活动详情（预热中/进行中）
  // 返回 null 表示暂无活动
  // 返回的活动数据已规范化图片 URL
  const loadCurrentSeckillActivity = async () => {
    try {
      const res = await promotionStore.fetchCurrentSeckillActivity()
      return res
    } catch (error) {
      console.error('获取秒杀活动失败:', error)
      return null
    }
  }

  // 加载当前秒杀活动商品列表（分页）
  // 返回 { activityInfo, list, total, pages, page, pageSize }
  // 无活动时返回空列表
  const loadCurrentSeckillProducts = async (params = {}) => {
    try {
      const res = await promotionStore.fetchCurrentSeckillProducts(params)
      if (res) {
        // 规范化商品图片 URL
        const normalizedList = (res.list || []).map(item => ({
          ...item,
          productImage: getValidImageUrl(item.productImage)
        }))
        return {
          ...res,
          list: normalizedList
        }
      }
      return null
    } catch (error) {
      console.error('获取秒杀商品列表失败:', error)
      return null
    }
  }

  // 清空秒杀数据
  const clearSeckillData = () => {
    promotionStore.clearSeckillData()
  }

  // 秒杀资格校验
  // 在用户点击"立即抢购"前调用，校验是否具备抢购资格
  // 校验项：登录状态、活动状态、商品状态、库存、限购数量
  // 返回 true 表示可以购买，false 表示不可购买（已弹出原因提示）
  const checkSeckillQualification = async (seckillProductId) => {
    // 登录校验
    if (!userStore.isLogin) {
      showToast('请先登录')
      setTimeout(() => {
        uni.navigateTo({ url: '/pages/login/login' })
      }, 1000)
      return false
    }

    if (!seckillProductId) {
      showToast('秒杀商品ID不能为空')
      return false
    }

    try {
      const res = await promotionStore.fetchCheckSeckillQualification(seckillProductId)
      if (!res) {
        showToast('资格校验失败，请重试')
        return false
      }

      // canBuy=true 表示可以购买
      if (res.canBuy) {
        return true
      }

      // canBuy=false 显示不可购买原因
      const reason = res.reason || '不满足抢购条件'
      showToast(reason)
      return false
    } catch (error) {
      console.error('秒杀资格校验失败:', error)
      const errorMessage = error?.message || '资格校验失败，请重试'
      showToast(errorMessage)
      return false
    }
  }

  const loadCouponList = async (params = {}) => {
    try {
      const res = await promotionStore.fetchCouponList(params)
      return res
    } catch (error) {
      console.error('获取优惠券列表失败:', error)
      return []
    }
  }

  const loadReceiveCoupon = async (id) => {
    if (!id) {
      showToast('优惠券ID不能为空')
      return false
    }
    try {
      const success = await promotionStore.fetchReceiveCoupon(id)
      if (success) {
        showToast('领取成功')
        return true
      }
      showToast('领取失败')
      return false
    } catch (error) {
      console.error('领取优惠券失败:', error)
      showToast('领取失败')
      return false
    }
  }

  const loadMyCouponList = async (params = {}) => {
    try {
      const res = await promotionStore.fetchMyCouponList(params)
      return res
    } catch (error) {
      console.error('获取我的优惠券失败:', error)
      return []
    }
  }

  const loadPromotionRule = async () => {
    try {
      const res = await promotionStore.fetchPromotionRule()
      return res
    } catch (error) {
      console.error('获取促销规则失败:', error)
      return null
    }
  }

  const loadRecommendGoods = async (params = {}) => {
    try {
      const res = await promotionStore.fetchRecommendGoods(params)
      return res.map(item => ({
        id: item.id || item.productId,
        title: item.title || item.productName,
        image: getValidImageUrl(item.image || item.productImage),
        price: item.price,
        original_price: item.originalPrice,
        sales: item.sales || item.soldCount,
        tag: item.tag || (item.tags && item.tags.length > 0 ? item.tags[0] : ''),
        stock: item.stock
      }))
    } catch (error) {
      console.error('获取推荐商品失败:', error)
      return []
    }
  }

  return {
    loading,
    loadBannerList,
    loadCurrentSeckillActivity,
    loadCurrentSeckillProducts,
    clearSeckillData,
    checkSeckillQualification,
    loadCouponList,
    loadReceiveCoupon,
    loadMyCouponList,
    loadPromotionRule,
    loadRecommendGoods
  }
}