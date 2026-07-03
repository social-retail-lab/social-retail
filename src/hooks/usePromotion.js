import { ref } from 'vue'
import { usePromotionStore } from '@/store/promotion'
import { showToast, getValidImageUrl } from '@/utils/common'

export const usePromotion = () => {
  const promotionStore = usePromotionStore()
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

  const loadSeckillActivity = async () => {
    try {
      const res = await promotionStore.fetchSeckillActivity()
      if (res) {
        return {
          ...res,
          goods_list: res.goods_list?.map(item => ({
            ...item,
            image: getValidImageUrl(item.image)
          })) || []
        }
      }
      return null
    } catch (error) {
      console.error('获取秒杀活动失败:', error)
      return null
    }
  }

  const loadSeckillList = async () => {
    try {
      const res = await promotionStore.fetchSeckillList()
      return res
    } catch (error) {
      console.error('获取秒杀列表失败:', error)
      return []
    }
  }

  const loadSeckillGoods = async (params = {}) => {
    try {
      const res = await promotionStore.fetchSeckillGoods(params)
      if (res) {
        return {
          ...res,
          list: res.list?.map(item => ({
            ...item,
            image: getValidImageUrl(item.image)
          })) || []
        }
      }
      return null
    } catch (error) {
      console.error('获取秒杀商品失败:', error)
      return null
    }
  }

  const loadSeckillDetail = async (id) => {
    if (!id) {
      showToast('秒杀ID不能为空')
      return null
    }
    try {
      const res = await promotionStore.fetchSeckillDetail(id)
      if (res) {
        return {
          ...res,
          image: getValidImageUrl(res.image)
        }
      }
      return null
    } catch (error) {
      console.error('获取秒杀详情失败:', error)
      showToast('获取秒杀详情失败')
      return null
    }
  }

  const loadSeckillOrder = async (data) => {
    loading.value = true
    try {
      const res = await promotionStore.fetchSeckillOrder(data)
      if (res) {
        showToast('下单成功')
        return res
      }
      showToast('下单失败')
      return null
    } catch (error) {
      console.error('秒杀下单失败:', error)
      showToast('下单失败')
      return null
    } finally {
      loading.value = false
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
    loadSeckillActivity,
    loadSeckillList,
    loadSeckillGoods,
    loadSeckillDetail,
    loadSeckillOrder,
    loadCouponList,
    loadReceiveCoupon,
    loadMyCouponList,
    loadPromotionRule,
    loadRecommendGoods
  }
}