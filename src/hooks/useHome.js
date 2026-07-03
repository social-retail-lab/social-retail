import { ref, onUnmounted } from 'vue'
import { useGoods } from '@/hooks/useGoods'
import { usePromotion } from '@/hooks/usePromotion'

export function useHome() {
  const goodsHook = useGoods()
  const promotionHook = usePromotion()
  
  const banners = ref([])
  const categories = ref([])
  const seckillData = ref(null)
  const recommendGoods = ref([])
  const loading = ref(false)
  const finished = ref(false)
  const page = ref(1)
  const seckillTimeLeft = ref('')
  const unreadCount = ref(0)
  const error = ref(null)

  let countdownTimer = null

  const transformProduct = (product) => ({
    id: product.productId,
    title: product.productName,
    image: product.productImage,
    price: product.price,
    original_price: product.originalPrice,
    commission: 0,
    sales: product.soldCount,
    tag: product.tags && product.tags.length > 0 ? product.tags[0] : '',
    stock: product.stock,
    productId: product.productId,
    productName: product.productName,
    productImage: product.productImage,
    originalPrice: product.originalPrice,
    soldCount: product.soldCount
  })

  const transformCategory = (category) => ({
    id: category.categoryId,
    name: category.categoryName,
    icon: category.icon || '📦',
    sort: category.sortOrder,
    type: 'category'
  })

  const fetchHomeData = async () => {
    loading.value = true
    error.value = null
    
    try {
      const [productRes, categoryRes, bannerRes] = await Promise.allSettled([
        goodsHook.loadProductList({ page: 1, pageSize: 10 }),
        goodsHook.loadCategoryTree(),
        promotionHook.loadBannerList()
      ])

      if (productRes.status === 'fulfilled' && productRes.value.list) {
        recommendGoods.value = productRes.value.list.map(transformProduct)
        finished.value = recommendGoods.value.length < productRes.value.pageSize
      } else {
        recommendGoods.value = []
        finished.value = true
        console.error('商品列表接口请求失败')
      }

      if (categoryRes.status === 'fulfilled' && categoryRes.value) {
        categories.value = categoryRes.value.map(transformCategory)
      } else {
        categories.value = []
        console.error('分类树接口请求失败')
      }

      if (bannerRes.status === 'fulfilled') {
        banners.value = bannerRes.value
      } else {
        banners.value = []
        console.error('轮播图接口请求失败')
      }
    } catch (errorInfo) {
      console.error('获取首页数据失败', errorInfo)
      error.value = errorInfo
      recommendGoods.value = []
      categories.value = []
      banners.value = []
      finished.value = true
    }

    try {
      const seckillRes = await promotionHook.loadSeckillActivity()
      if (seckillRes) {
        seckillData.value = seckillRes
        startCountdown()
      } else {
        seckillData.value = null
        console.warn('秒杀接口返回数据为空')
      }
    } catch (seckillError) {
      console.warn('秒杀接口请求失败', seckillError)
      seckillData.value = null
    }

    loading.value = false
  }

  const loadMoreGoods = async () => {
    if (loading.value || finished.value) return

    loading.value = true
    try {
      page.value++

      const res = await goodsHook.loadProductList({
        page: page.value,
        pageSize: 10
      })

      if (res.list) {
        const newGoods = res.list.map(transformProduct)
        recommendGoods.value.push(...newGoods)

        if (newGoods.length < res.pageSize) {
          finished.value = true
        }
      }
    } catch (errorInfo) {
      console.error('加载更多商品失败', errorInfo)
      page.value--
    } finally {
      loading.value = false
    }
  }

  const refreshHomeData = async () => {
    page.value = 1
    finished.value = false
    recommendGoods.value = []
    error.value = null

    if (countdownTimer) {
      clearInterval(countdownTimer)
      countdownTimer = null
    }

    await fetchHomeData()
  }

  const startCountdown = () => {
    if (!seckillData.value || !seckillData.value.end_time) return

    const updateCountdown = () => {
      const now = new Date().getTime()
      const end = new Date(seckillData.value.end_time).getTime()
      const diff = end - now

      if (diff <= 0) {
        seckillTimeLeft.value = '已结束'
        if (countdownTimer) {
          clearInterval(countdownTimer)
          countdownTimer = null
        }
        return
      }

      const hours = Math.floor(diff / (1000 * 60 * 60))
      const minutes = Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60))
      const seconds = Math.floor((diff % (1000 * 60)) / 1000)

      seckillTimeLeft.value = `${String(hours).padStart(2, '0')}:${String(minutes).padStart(2, '0')}:${String(seconds).padStart(2, '0')}`
    }

    updateCountdown()
    countdownTimer = setInterval(updateCountdown, 1000)
  }

  const fetchUnreadCount = async () => {
    try {
      unreadCount.value = 0
    } catch (errorInfo) {
      console.error('获取未读消息数量失败', errorInfo)
    }
  }

  const onPageScroll = () => {
    // console.log('页面滚动')
  }

  onUnmounted(() => {
    if (countdownTimer) {
      clearInterval(countdownTimer)
      countdownTimer = null
    }
  })

  return {
    banners,
    categories,
    seckillData,
    seckillTimeLeft,
    recommendGoods,
    loading,
    finished,
    error,
    unreadCount,
    fetchHomeData,
    loadMoreGoods,
    refreshHomeData,
    fetchUnreadCount,
    onPageScroll
  }
}