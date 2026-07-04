<template>
  <view class="page-container">
    <!-- 顶部搜索栏 -->
    <view class="header-bar">
      <view class="header-left">
        <view class="back-btn" @click="goBack">
          <text class="back-icon">‹</text>
        </view>
        <view class="search-input-wrap">
          <image src="/static/fonts/search.svg" class="search-icon" mode="aspectFit" />
          <input
            class="search-input"
            type="text"
            v-model="keyword"
            placeholder="搜索商品"
            placeholder-class="placeholder"
            confirm-type="search"
            @confirm="handleSearch"
          />
          <view v-if="keyword" class="clear-icon" @click="clearKeyword">
            <text>×</text>
          </view>
        </view>
      </view>
      <view class="header-right">
        <view class="search-btn" @click="handleSearch">
          <text class="search-btn-text">搜索</text>
        </view>
      </view>
    </view>

    <!-- 筛选栏 -->
    <view class="filter-bar">
      <view
        class="filter-item"
        :class="{ active: activeFilter === 'default' }"
        @click="selectSort('default')"
      >
        <text class="filter-text">综合</text>
      </view>
      <view
        class="filter-item"
        :class="{ active: activeFilter === 'sales' }"
        @click="selectSort('sales')"
      >
        <text class="filter-text">销量</text>
      </view>
      <view
        class="filter-item"
        :class="{ active: ['price_asc', 'price_desc'].includes(activeFilter) }"
        @click="togglePriceSort"
      >
        <text class="filter-text">价格</text>
        <view class="sort-arrows">
          <text class="arrow-up" :class="{ 'arrow-active': activeFilter === 'price_asc' }">▲</text>
          <text class="arrow-down" :class="{ 'arrow-active': activeFilter === 'price_desc' }">▼</text>
        </view>
      </view>
      <view class="filter-item filter-more" @click="handleFilter('filter')">
        <text class="filter-text">筛选</text>
        <text class="filter-icon">⚙</text>
        <view v-if="hasActiveFilter" class="filter-dot"></view>
      </view>
    </view>

    <!-- 商品列表 -->
    <scroll-view
      class="goods-scroll"
      scroll-y
      :refresher-enabled="true"
      :refresher-triggered="refreshing"
      @refresherrefresh="handleRefresh"
      @scrolltolower="handleScrollToLower"
    >
      <!-- 加载中（首次） -->
      <view v-if="loading && goodsList.length === 0" class="loading-state">
        <view class="loading-skeleton">
          <view v-for="i in 4" :key="i" class="skeleton-card">
            <view class="skeleton-image"></view>
            <view class="skeleton-info">
              <view class="skeleton-line long"></view>
              <view class="skeleton-line short"></view>
              <view class="skeleton-line medium"></view>
            </view>
          </view>
        </view>
      </view>

      <!-- 空状态 -->
      <view v-else-if="goodsList.length === 0" class="empty-state">
        <view class="empty-icon">
          <text class="empty-emoji">🔍</text>
        </view>
        <text class="empty-title">未找到相关商品</text>
        <text class="empty-desc">换个关键词试试吧</text>
        <view class="go-shopping-btn" @click="goShopping">
          <text class="go-shopping-text">去逛逛</text>
        </view>
      </view>

      <!-- 商品网格 -->
      <view v-else class="goods-grid">
        <view
          v-for="item in goodsList"
          :key="item.productId"
          class="goods-card"
          @click="goDetail(item.productId)"
        >
          <view class="goods-image-wrap">
            <image
              :src="item.productImage || item.image"
              mode="aspectFill"
              class="goods-image"
              lazy-load
            />
            <!-- 标签 -->
            <view v-if="item.tags && item.tags.length > 0" class="goods-tags">
              <text
                v-for="(tag, index) in item.tags.slice(0, 2)"
                :key="index"
                class="tag-item"
                :class="{ 'tag-hot': tag === '热卖', 'tag-new': tag === '新品' }"
              >{{ tag }}</text>
            </view>
          </view>
          <view class="goods-info">
            <text class="goods-title">{{ item.productName || item.name || '' }}</text>
            <!-- 促销信息 -->
            <view v-if="item.promotionTitle" class="goods-promotion">
              <text class="promotion-tag">促销</text>
              <text class="promotion-text">{{ item.promotionTitle }}</text>
            </view>
            <!-- 店铺名称 -->
            <view v-if="item.merchantName" class="goods-shop">
              <text class="shop-icon">🏪</text>
              <text class="shop-name">{{ item.merchantName }}</text>
            </view>
            <!-- 价格区域 -->
            <view class="goods-price-row">
              <view class="price-left">
                <text class="price-symbol">¥</text>
                <text class="goods-price">{{ formatPrice(item.price) }}</text>
                <text v-if="item.originalPrice && item.originalPrice > item.price" class="goods-original-price">¥{{ formatPrice(item.originalPrice) }}</text>
              </view>
            </view>
            <!-- 销量 -->
            <view class="goods-sales-row">
              <text class="goods-sales">已售{{ item.soldCount || 0 }}件</text>
              <text v-if="item.stock !== undefined && item.stock <= 10 && item.stock > 0" class="goods-stock-low">仅剩{{ item.stock }}件</text>
            </view>
          </view>
        </view>
      </view>

      <!-- 加载更多 -->
      <view v-if="!loading && goodsList.length > 0" class="load-more">
        <text v-if="hasMore" class="load-more-text">上拉加载更多</text>
        <text v-else class="no-more-text">— 已经到底了 —</text>
      </view>

      <view class="safe-bottom"></view>
    </scroll-view>

    <!-- 筛选抽屉 -->
    <view class="filter-drawer" :class="{ show: showFilterDrawer }" @click="closeFilterDrawer">
      <view class="drawer-mask"></view>
      <view class="drawer-content" @click.stop>
        <view class="drawer-header">
          <text class="drawer-title">筛选条件</text>
          <view class="drawer-close" @click="closeFilterDrawer">
            <text>×</text>
          </view>
        </view>
        <view class="drawer-body">
          <!-- 价格区间 -->
          <view class="filter-section">
            <text class="filter-section-title">价格区间</text>
            <view class="price-input-row">
              <view class="price-input-wrap">
                <text class="price-label">¥</text>
                <input
                  class="price-input"
                  type="digit"
                  v-model="minPrice"
                  placeholder="最低价"
                  placeholder-class="price-placeholder"
                  @blur="validatePrice"
                />
              </view>
              <text class="price-separator">—</text>
              <view class="price-input-wrap">
                <text class="price-label">¥</text>
                <input
                  class="price-input"
                  type="digit"
                  v-model="maxPrice"
                  placeholder="最高价"
                  placeholder-class="price-placeholder"
                  @blur="validatePrice"
                />
              </view>
            </view>
            <view class="price-quick">
              <view
                v-for="item in priceRanges"
                :key="item.label"
                class="price-quick-item"
                @click="setPriceRange(item.min, item.max)"
              >
                <text>{{ item.label }}</text>
              </view>
            </view>
            <view v-if="priceError" class="price-tips">
              <text class="price-error-text">{{ priceError }}</text>
            </view>
          </view>

          <!-- 分类筛选 -->
          <view class="filter-section">
            <text class="filter-section-title">分类</text>
            <view class="filter-options">
              <view
                class="filter-option"
                :class="{ 'option-active': !selectedCategoryId }"
                @click="selectCategory(null)"
              >
                <text>不限</text>
              </view>
              <template v-for="category in categoryTree" :key="category.categoryId">
                <view
                  class="filter-option"
                  :class="{ 'option-active': selectedCategoryId === category.categoryId }"
                  @click="selectCategory(category.categoryId)"
                >
                  <text>{{ category.categoryName }}</text>
                </view>
                <view
                  v-for="sub in category.children"
                  :key="sub.categoryId"
                  class="filter-option"
                  :class="{ 'option-active': selectedCategoryId === sub.categoryId }"
                  @click="selectCategory(sub.categoryId)"
                >
                  <text>{{ sub.categoryName }}</text>
                </view>
              </template>
            </view>
          </view>

          <!-- 品牌筛选 -->
          <view class="filter-section">
            <text class="filter-section-title">品牌</text>
            <view class="filter-options">
              <view
                class="filter-option"
                :class="{ 'option-active': !selectedBrandId }"
                @click="selectBrand(null)"
              >
                <text>不限</text>
              </view>
              <view
                v-for="brand in brandList"
                :key="brand.brandId"
                class="filter-option"
                :class="{ 'option-active': selectedBrandId === brand.brandId }"
                @click="selectBrand(brand.brandId)"
              >
                <text>{{ brand.brandName }}</text>
              </view>
            </view>
          </view>
        </view>
        <view class="drawer-footer">
          <view class="btn-reset" @click="resetAllFilter">
            <text>重置</text>
          </view>
          <view class="btn-confirm" @click="confirmFilter">
            <text>确定</text>
            <text v-if="getActiveFilterCount > 0" class="btn-count">{{ getActiveFilterCount }}</text>
          </view>
        </view>
      </view>
    </view>
  </view>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useGoods } from '@/hooks/useGoods'

const { loadSearchProducts, loadBrandList, loadCategoryTree } = useGoods()

const keyword = ref('')
const goodsList = ref([])
const brandList = ref([])
const categoryTree = ref([])
const loading = ref(false)
const refreshing = ref(false)
const hasMore = ref(true)
const page = ref(1)
const pageSize = 10
const totalPages = ref(1)

const activeFilter = ref('default')
const selectedCategoryId = ref(null)
const selectedBrandId = ref(null)

const showFilterDrawer = ref(false)
const minPrice = ref('')
const maxPrice = ref('')
const priceError = ref('')

const priceRanges = [
  { label: '0-50元', min: 0, max: 50 },
  { label: '50-100元', min: 50, max: 100 },
  { label: '100-300元', min: 100, max: 300 },
  { label: '300-1000元', min: 300, max: 1000 },
  { label: '1000元以上', min: 1000, max: null }
]

const hasActiveFilter = computed(() => {
  return selectedCategoryId.value !== null ||
    selectedBrandId.value !== null ||
    minPrice.value !== '' ||
    maxPrice.value !== ''
})

const getActiveFilterCount = computed(() => {
  let count = 0
  if (selectedCategoryId.value !== null) count++
  if (selectedBrandId.value !== null) count++
  if (minPrice.value !== '' || maxPrice.value !== '') count++
  return count
})

const formatPrice = (price) => {
  return (Number(price) || 0).toFixed(2)
}

const goBack = () => {
  uni.navigateBack({
    fail: () => {
      uni.switchTab({ url: '/pages/index/index' })
    }
  })
}

const goShopping = () => {
  uni.switchTab({ url: '/pagesSub/goods/category/categoryHome' })
}

const clearKeyword = () => {
  keyword.value = ''
}

const handleSearch = () => {
  const searchKeyword = keyword.value.trim()
  if (!searchKeyword) {
    uni.showToast({ title: '请输入搜索关键词', icon: 'none' })
    return
  }
  selectedCategoryId.value = null
  selectedBrandId.value = null
  minPrice.value = ''
  maxPrice.value = ''
  activeFilter.value = 'default'
  resetPage()
  loadGoods()
  loadBrandListWithKeyword()
}

const selectSort = (key) => {
  activeFilter.value = key
  resetPage()
  loadGoods()
}

const togglePriceSort = () => {
  if (activeFilter.value === 'price_asc') {
    activeFilter.value = 'price_desc'
  } else if (activeFilter.value === 'price_desc') {
    activeFilter.value = 'price_asc'
  } else {
    activeFilter.value = 'price_asc'
  }
  resetPage()
  loadGoods()
}

const handleFilter = (key) => {
  showFilterDrawer.value = true
}

const selectCategory = (categoryId) => {
  selectedCategoryId.value = categoryId
}

const selectBrand = (brandId) => {
  selectedBrandId.value = brandId
}

const setPriceRange = (min, max) => {
  minPrice.value = min !== null ? String(min) : ''
  maxPrice.value = max !== null ? String(max) : ''
  priceError.value = ''
}

const validatePrice = () => {
  const min = parseFloat(minPrice.value)
  const max = parseFloat(maxPrice.value)

  if (!isNaN(min) && min < 0) {
    priceError.value = '最低价格不能为负数'
    minPrice.value = ''
    return
  }
  if (!isNaN(max) && max < 0) {
    priceError.value = '最高价格不能为负数'
    maxPrice.value = ''
    return
  }
  if (!isNaN(min) && !isNaN(max) && min > max) {
    priceError.value = '最低价格不能大于最高价格'
    return
  }
  priceError.value = ''
}

const closeFilterDrawer = () => {
  showFilterDrawer.value = false
  priceError.value = ''
}

const resetAllFilter = () => {
  selectedCategoryId.value = null
  selectedBrandId.value = null
  minPrice.value = ''
  maxPrice.value = ''
  priceError.value = ''
}

const confirmFilter = () => {
  validatePrice()
  if (priceError.value) return
  closeFilterDrawer()
  resetPage()
  loadGoods()
}

const resetPage = () => {
  page.value = 1
  goodsList.value = []
  hasMore.value = true
}

/**
 * 中文关键词分词(滑动窗口策略)
 * 用于完整关键词无结果时的降级搜索
 * 例如:"新疆阿克苏苹果" → ["新疆", "阿克", "克苏", "苹果", "阿克苏"]
 */
const splitKeyword = (kw) => {
  const len = kw.length
  if (len <= 3) return [kw]

  const words = new Set()
  // 2 字滑动窗口
  for (let i = 0; i < len - 1; i++) {
    words.add(kw.substring(i, i + 2))
  }
  // 3 字滑动窗口(覆盖"阿克苏"这种 3 字地名)
  for (let i = 0; i < len - 2; i++) {
    words.add(kw.substring(i, i + 3))
  }

  // 简单过滤:去掉首尾字符是常见无意义连接字的词
  const invalidChars = ['疆阿', '苏苹', '克苏苹', '疆阿克']
  const filtered = [...words].filter(w => !invalidChars.some(ic => w.includes(ic)))

  // 优先保留 2 字词(产地+产品名),最多取 4 个词避免过多请求
  const twoCharWords = filtered.filter(w => w.length === 2)
  const threeCharWords = filtered.filter(w => w.length === 3)
  return [...twoCharWords.slice(0, 3), ...threeCharWords.slice(0, 2)].slice(0, 4)
}

/**
 * 降级搜索:用拆分后的多个子关键词并发搜索,合并去重
 */
const fallbackSearch = async (baseParams) => {
  const subKeywords = splitKeyword(keyword.value)
  if (subKeywords.length === 0) return { list: [], total: 0, pages: 0 }

  try {
    const subResults = await Promise.all(
      subKeywords.map(kw => loadSearchProducts({ ...baseParams, keyword: kw, page: 1 }))
    )

    // 合并结果,按 productId 去重
    const mergedList = []
    const productIdSet = new Set()
    subResults.forEach(r => {
      if (r && r.list) {
        r.list.forEach(item => {
          // 优先用 productId,其次 id(两者在 transformProductItem 后值相同)
          const id = item.productId !== undefined ? item.productId : item.id
          if (id !== undefined && id !== null && !productIdSet.has(id)) {
            productIdSet.add(id)
            mergedList.push(item)
          }
        })
      }
    })

    return {
      list: mergedList,
      total: mergedList.length,
      pages: 1
    }
  } catch (error) {
    console.error('降级搜索失败:', error)
    return { list: [], total: 0, pages: 0 }
  }
}

const loadGoods = async () => {
  if (loading.value && page.value > 1) return
  loading.value = true

  try {
    const params = {
      keyword: keyword.value,
      page: page.value,
      pageSize: pageSize
    }

    if (activeFilter.value === 'sales') {
      params.sortField = 'soldCount'
      params.sortOrder = 'desc'
    } else if (activeFilter.value === 'price_asc') {
      params.sortField = 'price'
      params.sortOrder = 'asc'
    } else if (activeFilter.value === 'price_desc') {
      params.sortField = 'price'
      params.sortOrder = 'desc'
    } else {
      params.sortField = 'createTime'
      params.sortOrder = 'desc'
    }

    if (selectedCategoryId.value) {
      params.categoryId = selectedCategoryId.value
    }
    if (minPrice.value) {
      params.minPrice = parseFloat(minPrice.value)
    }
    if (maxPrice.value) {
      params.maxPrice = parseFloat(maxPrice.value)
    }
    if (selectedBrandId.value) {
      params.brandId = selectedBrandId.value
    }

    let result = await loadSearchProducts(params)

    // 智能降级搜索:完整关键词无结果且关键词长度 >= 4 时,分词并发搜索
    if (page.value === 1 && result.list && result.list.length === 0 && keyword.value.length >= 4) {
      const fallbackResult = await fallbackSearch(params)
      if (fallbackResult.list.length > 0) {
        result = fallbackResult
      }
    }

    if (result.list) {
      if (page.value === 1) {
        // 首页直接赋值,并对当前页内做一次去重(防止后端返回重复)
        const seen = new Set()
        goodsList.value = result.list.filter(item => {
          const id = item.productId
          if (id && seen.has(id)) return false
          seen.add(id)
          return true
        })
      } else {
        // 分页去重:过滤掉已存在的商品(后端分页可能返回重复数据)
        const existingIds = new Set(goodsList.value.map(item => item.productId))
        const newItems = result.list.filter(item => !existingIds.has(item.productId))
        goodsList.value = [...goodsList.value, ...newItems]
      }
      totalPages.value = result.pages || Math.ceil((result.total || 0) / pageSize)
      hasMore.value = page.value < totalPages.value
    }
  } catch (error) {
    console.error('搜索商品失败', error)
    uni.showToast({ title: '搜索失败，请重试', icon: 'none' })
  } finally {
    loading.value = false
    refreshing.value = false
  }
}

const loadBrandListWithKeyword = async () => {
  try {
    const params = keyword.value ? { keyword: keyword.value } : {}
    const result = await loadBrandList(params)
    if (result.list) {
      brandList.value = result.list
    }
  } catch (error) {
    console.error('加载品牌列表失败', error)
  }
}

const loadCategoryTreeData = async () => {
  try {
    const result = await loadCategoryTree()
    categoryTree.value = result
  } catch (error) {
    console.error('加载分类数据失败', error)
  }
}

const handleRefresh = () => {
  refreshing.value = true
  resetPage()
  loadGoods()
}

const handleScrollToLower = () => {
  if (hasMore.value && !loading.value) {
    page.value++
    loadGoods()
  }
}

const goDetail = (productId) => {
  uni.navigateTo({ url: `/pagesSub/goods/detail/goodsDetail?productId=${productId}` })
}

onMounted(() => {
  const pages = getCurrentPages()
  const currentPage = pages[pages.length - 1]
  const options = currentPage.options || {}

  // uni-app 路由系统会自动解码 query 参数,不需要手动 decodeURIComponent
  // 如果手动解码会导致双重解码问题(当关键词含 % 等特殊字符时报错)
  const initKeyword = options.keyword || ''
  keyword.value = initKeyword

  loadCategoryTreeData()
  loadGoods()
  loadBrandListWithKeyword()
})
</script>

<style lang="scss" scoped>
.page-container {
  min-height: 100vh;
  background-color: $bg-page;
}

/* ============ 顶部搜索栏 ============ */
.header-bar {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  z-index: 100;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 16rpx 24rpx;
  padding-top: calc(16rpx + env(safe-area-inset-top));
  background: $bg-card;
  box-shadow: 0 2rpx 12rpx rgba(0, 0, 0, 0.04);
}

.header-left {
  flex: 1;
  display: flex;
  align-items: center;
  gap: 16rpx;
}

.back-btn {
  width: 64rpx;
  height: 64rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  background: $bg-page-light;
  border-radius: 50%;

  &:active {
    opacity: 0.6;
  }

  .back-icon {
    font-size: 48rpx;
    color: $text-main;
    font-weight: 300;
    line-height: 1;
    margin-top: -4rpx;
  }
}

.search-input-wrap {
  flex: 1;
  display: flex;
  align-items: center;
  background: $bg-page-light;
  border-radius: $radius-full;
  padding: 12rpx 24rpx;
  height: 64rpx;

  .search-icon {
    width: 32rpx;
    height: 32rpx;
    margin-right: 12rpx;
    opacity: 0.5;
  }

  .search-input {
    flex: 1;
    font-size: 28rpx;
    color: $text-main;
  }

  .placeholder {
    color: $text-weak;
    font-size: 28rpx;
  }

  .clear-icon {
    width: 36rpx;
    height: 36rpx;
    display: flex;
    align-items: center;
    justify-content: center;
    color: $text-weak;
    font-size: 32rpx;
    background: rgba($text-weak, 0.2);
    border-radius: 50%;

    &:active {
      opacity: 0.6;
    }
  }
}

.header-right {
  margin-left: 16rpx;
}

.search-btn {
  padding: 0 32rpx;
  height: 64rpx;
  background: linear-gradient(135deg, $color-primary 0%, $color-primary-danger 100%);
  border-radius: $radius-full;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 4rpx 12rpx rgba($color-primary-danger, 0.2);

  &:active {
    opacity: 0.85;
    transform: scale(0.97);
  }

  .search-btn-text {
    font-size: 28rpx;
    color: #FFFFFF;
    font-weight: 600;
  }
}

/* ============ 筛选栏 ============ */
.filter-bar {
  position: fixed;
  top: calc(96rpx + env(safe-area-inset-top));
  left: 0;
  right: 0;
  z-index: 99;
  display: flex;
  background: $bg-card;
  padding: 20rpx 0;
  border-bottom: 2rpx solid $bg-page-light;
}

.filter-item {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 6rpx;
  position: relative;

  &:active {
    opacity: 0.6;
  }

  .filter-text {
    font-size: 28rpx;
    color: $text-sub;
  }

  .filter-icon {
    font-size: 24rpx;
    color: $text-sub;
  }

  &.active {
    .filter-text {
      color: $color-primary;
      font-weight: 600;
    }
  }
}

.filter-more {
  position: relative;
}

.sort-arrows {
  display: flex;
  flex-direction: column;
  align-items: center;
  margin-left: 4rpx;

  .arrow-up,
  .arrow-down {
    font-size: 14rpx;
    color: $text-weak;
    line-height: 1;
  }

  .arrow-active {
    color: $color-primary;
  }
}

.filter-dot {
  position: absolute;
  top: 0;
  right: 20%;
  width: 14rpx;
  height: 14rpx;
  background: $color-primary-danger;
  border-radius: 50%;
  border: 2rpx solid $bg-card;
}

/* ============ 商品列表 ============ */
.goods-scroll {
  height: calc(100vh - 168rpx - env(safe-area-inset-top));
  padding-top: calc(168rpx + env(safe-area-inset-top));
}

/* 骨架屏 */
.loading-skeleton {
  padding: 20rpx;
}

.skeleton-card {
  display: flex;
  background: $bg-card;
  border-radius: $radius-lg;
  overflow: hidden;
  margin-bottom: 16rpx;
  padding: 20rpx;

  .skeleton-image {
    width: 200rpx;
    height: 200rpx;
    background: linear-gradient(90deg, $bg-page-light 25%, $bg-page 37%, $bg-page-light 63%);
    background-size: 400% 100%;
    animation: skeleton-loading 1.4s ease infinite;
    border-radius: $radius-base;
    flex-shrink: 0;
  }

  .skeleton-info {
    flex: 1;
    margin-left: 20rpx;
    display: flex;
    flex-direction: column;
    justify-content: center;
  }

  .skeleton-line {
    height: 24rpx;
    background: linear-gradient(90deg, $bg-page-light 25%, $bg-page 37%, $bg-page-light 63%);
    background-size: 400% 100%;
    animation: skeleton-loading 1.4s ease infinite;
    border-radius: 8rpx;
    margin-bottom: 16rpx;

    &.long { width: 100%; }
    &.medium { width: 70%; }
    &.short { width: 40%; }
  }
}

@keyframes skeleton-loading {
  0% { background-position: 100% 50%; }
  100% { background-position: 0 50%; }
}

/* 空状态 */
.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 120rpx 0;

  .empty-icon {
    width: 160rpx;
    height: 160rpx;
    border-radius: 50%;
    background: rgba($text-weak, 0.06);
    display: flex;
    align-items: center;
    justify-content: center;
    margin-bottom: 32rpx;

    .empty-emoji {
      font-size: 72rpx;
    }
  }

  .empty-title {
    font-size: 32rpx;
    color: $text-main;
    font-weight: 600;
    margin-bottom: 12rpx;
  }

  .empty-desc {
    font-size: 26rpx;
    color: $text-weak;
    margin-bottom: 40rpx;
  }

  .go-shopping-btn {
    padding: 20rpx 60rpx;
    background: linear-gradient(135deg, $color-primary 0%, $color-primary-danger 100%);
    border-radius: $radius-full;
    box-shadow: 0 4rpx 12rpx rgba($color-primary-danger, 0.2);

    &:active {
      opacity: 0.85;
      transform: scale(0.97);
    }

    .go-shopping-text {
      font-size: 28rpx;
      color: #FFFFFF;
      font-weight: 600;
    }
  }
}

/* 商品网格 */
.goods-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 16rpx;
  padding: 20rpx;
}

.goods-card {
  background: $bg-card;
  border-radius: $radius-lg;
  overflow: hidden;
  box-shadow: 0 2rpx 12rpx rgba(0, 0, 0, 0.04);

  &:active {
    transform: scale(0.98);
  }
}

.goods-image-wrap {
  position: relative;
  width: 100%;
  padding-top: 100%;

  .goods-image {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
  }

  .goods-tags {
    position: absolute;
    top: 12rpx;
    left: 12rpx;
    display: flex;
    flex-direction: column;
    gap: 6rpx;
  }

  .tag-item {
    padding: 4rpx 14rpx;
    background: rgba(0, 0, 0, 0.5);
    color: #FFFFFF;
    font-size: 20rpx;
    border-radius: 8rpx;
    backdrop-filter: blur(4rpx);
  }

  .tag-hot {
    background: linear-gradient(135deg, $color-primary, $color-primary-danger);
  }

  .tag-new {
    background: linear-gradient(135deg, #1890FF, #36CFC9);
  }
}

.goods-info {
  padding: 16rpx;

  .goods-title {
    display: -webkit-box;
    -webkit-box-orient: vertical;
    -webkit-line-clamp: 2;
    line-clamp: 2;
    overflow: hidden;
    font-size: 26rpx;
    color: $text-main;
    line-height: 1.4;
    margin-bottom: 8rpx;
    min-height: 72rpx;
  }
}

/* 促销信息 */
.goods-promotion {
  display: flex;
  align-items: center;
  margin-bottom: 8rpx;
  overflow: hidden;

  .promotion-tag {
    font-size: 18rpx;
    color: #FFFFFF;
    background: linear-gradient(135deg, $color-primary, $color-primary-danger);
    padding: 2rpx 8rpx;
    border-radius: 4rpx;
    margin-right: 8rpx;
    flex-shrink: 0;
  }

  .promotion-text {
    font-size: 20rpx;
    color: $color-primary-danger;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }
}

/* 店铺名称 */
.goods-shop {
  display: flex;
  align-items: center;
  margin-bottom: 8rpx;
  overflow: hidden;

  .shop-icon {
    font-size: 20rpx;
    margin-right: 4rpx;
  }

  .shop-name {
    font-size: 20rpx;
    color: $text-sub;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }
}

/* 价格区域 */
.goods-price-row {
  display: flex;
  align-items: baseline;
  margin-bottom: 8rpx;

  .price-left {
    display: flex;
    align-items: baseline;
    gap: 8rpx;
  }

  .price-symbol {
    font-size: 22rpx;
    font-weight: 700;
    color: $color-primary-danger;
  }

  .goods-price {
    font-size: 36rpx;
    color: $color-primary-danger;
    font-weight: 700;
    font-family: 'Helvetica Neue', Arial, sans-serif;
  }

  .goods-original-price {
    font-size: 22rpx;
    color: $text-weak;
    text-decoration: line-through;
  }
}

.goods-sales-row {
  display: flex;
  align-items: center;
  justify-content: space-between;

  .goods-sales {
    font-size: 20rpx;
    color: $text-weak;
  }

  .goods-stock-low {
    font-size: 20rpx;
    color: $color-primary-danger;
    font-weight: 500;
  }
}

/* 加载更多 */
.load-more {
  padding: 24rpx 0;
  text-align: center;

  .load-more-text,
  .no-more-text {
    font-size: 24rpx;
    color: $text-weak;
  }
}

.safe-bottom {
  height: env(safe-area-inset-bottom);
}

/* ============ 筛选抽屉 ============ */
.filter-drawer {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  z-index: 200;
  pointer-events: none;
  opacity: 0;
  transition: opacity 0.3s ease;

  &.show {
    pointer-events: auto;
    opacity: 1;
  }
}

.drawer-mask {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.5);
}

.drawer-content {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  max-height: 75vh;
  background: $bg-card;
  border-radius: $radius-xl $radius-xl 0 0;
  transform: translateY(100%);
  transition: transform 0.3s ease;
  display: flex;
  flex-direction: column;

  .filter-drawer.show & {
    transform: translateY(0);
  }
}

.drawer-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 32rpx 24rpx;
  border-bottom: 2rpx solid $bg-page-light;

  .drawer-title {
    font-size: 34rpx;
    font-weight: 700;
    color: $text-main;
  }

  .drawer-close {
    width: 48rpx;
    height: 48rpx;
    display: flex;
    align-items: center;
    justify-content: center;
    color: $text-sub;
    font-size: 40rpx;

    &:active {
      opacity: 0.6;
    }
  }
}

.drawer-body {
  flex: 1;
  overflow-y: auto;
  padding: 24rpx;
}

.filter-section {
  margin-bottom: 32rpx;

  &:last-child {
    margin-bottom: 0;
  }

  .filter-section-title {
    display: block;
    font-size: 28rpx;
    font-weight: 600;
    color: $text-main;
    margin-bottom: 20rpx;
  }
}

/* 价格区间 */
.price-input-row {
  display: flex;
  align-items: center;
  gap: 16rpx;
  margin-bottom: 20rpx;

  .price-input-wrap {
    flex: 1;
    display: flex;
    align-items: center;
    background: $bg-page-light;
    border-radius: $radius-base;
    padding: 16rpx 20rpx;

    .price-label {
      font-size: 28rpx;
      color: $text-sub;
      margin-right: 8rpx;
    }

    .price-input {
      flex: 1;
      font-size: 28rpx;
      color: $text-main;
    }

    .price-placeholder {
      color: $text-weak;
    }
  }

  .price-separator {
    font-size: 28rpx;
    color: $text-sub;
  }
}

.price-quick {
  display: flex;
  flex-wrap: wrap;
  gap: 16rpx;

  .price-quick-item {
    padding: 12rpx 24rpx;
    background: $bg-page-light;
    border-radius: $radius-full;

    &:active {
      background: rgba($color-primary, 0.06);
    }

    text {
      font-size: 24rpx;
      color: $text-sub;
    }
  }
}

.price-tips {
  margin-top: 16rpx;

  .price-error-text {
    font-size: 24rpx;
    color: $color-primary-danger;
  }
}

/* 分类/品牌选项 */
.filter-options {
  display: flex;
  flex-wrap: wrap;
  gap: 16rpx;
}

.filter-option {
  padding: 14rpx 28rpx;
  background: $bg-page-light;
  border-radius: $radius-full;
  border: 2rpx solid transparent;

  &:active {
    opacity: 0.8;
  }

  text {
    font-size: 26rpx;
    color: $text-main;
  }
}

.option-active {
  background: rgba($color-primary, 0.06);
  border-color: $color-primary;

  text {
    color: $color-primary;
    font-weight: 600;
  }
}

/* 底部按钮 */
.drawer-footer {
  display: flex;
  gap: 16rpx;
  padding: 20rpx 24rpx;
  padding-bottom: calc(20rpx + env(safe-area-inset-bottom));
  border-top: 2rpx solid $bg-page-light;

  .btn-reset,
  .btn-confirm {
    flex: 1;
    height: 84rpx;
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: $radius-full;
    font-size: 30rpx;
    font-weight: 600;
    position: relative;

    &:active {
      opacity: 0.85;
      transform: scale(0.97);
    }
  }

  .btn-reset {
    background: $bg-page-light;
    color: $text-sub;
  }

  .btn-confirm {
    background: linear-gradient(135deg, $color-primary 0%, $color-primary-danger 100%);
    color: #FFFFFF;
    box-shadow: 0 4rpx 12rpx rgba($color-primary-danger, 0.2);

    .btn-count {
      position: absolute;
      top: 8rpx;
      right: 24rpx;
      min-width: 32rpx;
      height: 32rpx;
      line-height: 32rpx;
      text-align: center;
      background: #FFFFFF;
      color: $color-primary-danger;
      font-size: 20rpx;
      border-radius: 50%;
      padding: 0 8rpx;
      font-weight: 700;
    }
  }
}
</style>
