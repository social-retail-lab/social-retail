<template>
  <view class="page-container">
    <view class="header-bar">
      <view class="header-left">
        <view class="back-btn" @click="goBack">
          <text class="back-icon">‹</text>
        </view>
        <view class="search-input-wrap">
          <text class="search-icon">🔍</text>
          <input
            class="search-input"
            type="text"
            v-model="keyword"
            placeholder="搜索商品"
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

    <view class="filter-bar">
      <view
        v-for="item in filterOptions"
        :key="item.key"
        class="filter-item"
        :class="{ active: activeFilter === item.key }"
        @click="handleFilter(item.key)"
      >
        <text class="filter-text">{{ item.label }}</text>
        <text v-if="item.key === 'price' && priceOrder" class="filter-arrow">
          {{ priceOrder === 'asc' ? '↑' : '↓' }}
        </text>
        <view v-if="hasFilterDot(item.key)" class="filter-dot"></view>
      </view>
    </view>

    <scroll-view
      class="goods-scroll"
      scroll-y
      :refresher-enabled="true"
      :refresher-triggered="refreshing"
      @refresherrefresh="handleRefresh"
      @scrolltolower="handleScrollToLower"
    >
      <view v-if="loading && goodsList.length === 0" class="loading-state">
        <text class="loading-text">加载中...</text>
      </view>

      <view v-else-if="goodsList.length === 0" class="empty-state">
        <text class="empty-icon">📦</text>
        <text class="empty-title">暂无相关商品</text>
        <text class="empty-desc">换个关键词试试吧</text>
        <view class="go-shopping-btn" @click="goShopping">
          <text class="go-shopping-text">去逛逛</text>
        </view>
      </view>

      <view v-else class="goods-grid">
        <view
          v-for="item in goodsList"
          :key="item.productId"
          class="goods-card"
          @click="goDetail(item.productId)"
        >
          <view class="goods-image-wrap">
            <image
              :src="item.productImage"
              mode="aspectFill"
              class="goods-image"
              lazy-load
            />
            <view v-if="item.tags && item.tags.length > 0" class="goods-tags">
              <text
                v-for="(tag, index) in item.tags.slice(0, 2)"
                :key="index"
                class="tag-item"
                :class="{ 'tag-hot': tag === '热卖' }"
              >{{ tag }}</text>
            </view>
          </view>
          <view class="goods-info">
            <text class="goods-title">{{ item.productName || '' }}</text>
            <view class="goods-price-row">
              <text class="goods-price">¥{{ item.price?.toFixed(2) || '0.00' }}</text>
              <text v-if="item.originalPrice" class="goods-original-price">¥{{ item.originalPrice?.toFixed(2) || '0.00' }}</text>
            </view>
            <view class="goods-sales-row">
              <text class="goods-sales">已售{{ item.soldCount || 0 }}</text>
            </view>
          </view>
        </view>
      </view>

      <view v-if="!loading && goodsList.length > 0" class="load-more">
        <text v-if="hasMore" class="load-more-text">加载中...</text>
        <text v-else class="no-more-text">没有更多商品了</text>
      </view>

      <view class="safe-bottom"></view>
    </scroll-view>

    <view class="filter-drawer" :class="{ show: showFilterDrawer }" @click="closeFilterDrawer">
      <view class="drawer-mask"></view>
      <view class="drawer-content" @click.stop>
        <view class="drawer-header">
          <text class="drawer-title">{{ drawerTitle }}</text>
          <view class="drawer-close" @click="closeFilterDrawer">
            <text>×</text>
          </view>
        </view>
        <view class="drawer-body">
          <view v-if="currentDrawer === 'category'" class="category-section">
            <view
              class="category-option"
              :class="{ 'category-option-active': !selectedCategoryId }"
              @click="selectCategory(null)"
            >
              <text>不限</text>
            </view>
            <view
              v-for="category in categoryTree"
              :key="category.categoryId"
              class="category-group"
            >
              <text class="category-group-title">{{ category.categoryName }}</text>
              <view
                v-for="sub in category.children"
                :key="sub.categoryId"
                class="category-option"
                :class="{ 'category-option-active': selectedCategoryId === sub.categoryId }"
                @click="selectCategory(sub.categoryId)"
              >
                <text>{{ sub.categoryName }}</text>
              </view>
            </view>
          </view>

          <view v-if="currentDrawer === 'brand'" class="brand-section">
            <view
              class="brand-option"
              :class="{ 'brand-option-active': !selectedBrandId }"
              @click="selectBrand(null)"
            >
              <text>不限</text>
            </view>
            <view
              v-for="brand in brandList"
              :key="brand.brandId"
              class="brand-option"
              :class="{ 'brand-option-active': selectedBrandId === brand.brandId }"
              @click="selectBrand(brand.brandId)"
            >
              <text>{{ brand.brandName }}</text>
            </view>
          </view>

          <view v-if="currentDrawer === 'price'" class="price-section">
            <view class="price-input-row">
              <view class="price-input-wrap">
                <text class="price-label">¥</text>
                <input
                  class="price-input"
                  type="digit"
                  v-model="minPrice"
                  placeholder="最低"
                  @blur="validatePrice"
                />
              </view>
              <text class="price-separator">-</text>
              <view class="price-input-wrap">
                <text class="price-label">¥</text>
                <input
                  class="price-input"
                  type="digit"
                  v-model="maxPrice"
                  placeholder="最高"
                  @blur="validatePrice"
                />
              </view>
            </view>
            <view class="price-tips" v-if="priceError">
              <text class="price-error-text">{{ priceError }}</text>
            </view>
          </view>

          <view v-if="currentDrawer === 'sort'" class="sort-section">
            <view
              v-for="item in sortOptions"
              :key="item.key"
              class="sort-option"
              :class="{ 'sort-option-active': activeFilter === item.key }"
              @click="selectSort(item.key)"
            >
              <text>{{ item.label }}</text>
              <text v-if="activeFilter === item.key" class="sort-check">✓</text>
            </view>
          </view>
        </view>
        <view class="drawer-footer">
          <view v-if="currentDrawer !== 'sort'" class="btn-reset" @click="resetCurrentFilter">
            <text>重置</text>
          </view>
          <view class="btn-confirm" @click="confirmFilter">
            <text>确定</text>
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
const priceOrder = ref('')
const selectedCategoryId = ref(null)
const selectedBrandId = ref(null)

const showFilterDrawer = ref(false)
const currentDrawer = ref('filter')
const minPrice = ref('')
const maxPrice = ref('')
const priceError = ref('')

const filterOptions = [
  { key: 'category', label: '分类' },
  { key: 'brand', label: '品牌' },
  { key: 'price', label: '价格' },
  { key: 'sort', label: '排序' }
]

const sortOptions = [
  { key: 'default', label: '综合排序' },
  { key: 'sales', label: '销量从高到低' },
  { key: 'price_asc', label: '价格从低到高' },
  { key: 'price_desc', label: '价格从高到低' }
]

const drawerTitle = computed(() => {
  const titles = {
    category: '分类筛选',
    brand: '品牌筛选',
    price: '价格区间',
    sort: '排序方式'
  }
  return titles[currentDrawer.value] || '筛选'
})

const goBack = () => {
  uni.navigateBack({
    fail: () => {
      uni.switchTab({ url: '/pages/index/index' })
    }
  })
}

const goShopping = () => {
  uni.switchTab({ url: '/pages/category/categoryHome' })
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
  priceOrder.value = ''
  resetPage()
  loadGoods()
  loadBrandListWithKeyword()
}

const handleFilter = (key) => {
  currentDrawer.value = key
  showFilterDrawer.value = true
}

const selectCategory = (categoryId) => {
  selectedCategoryId.value = categoryId
}

const selectBrand = (brandId) => {
  selectedBrandId.value = brandId
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

const selectSort = (key) => {
  activeFilter.value = key
  if (key === 'default') {
    priceOrder.value = ''
  } else if (key === 'sales') {
    priceOrder.value = ''
  } else if (key === 'price_asc') {
    priceOrder.value = 'asc'
  } else if (key === 'price_desc') {
    priceOrder.value = 'desc'
  }
  closeFilterDrawer()
  resetPage()
  loadGoods()
}

const hasFilterDot = (key) => {
  if (key === 'category') return selectedCategoryId.value !== null
  if (key === 'brand') return selectedBrandId.value !== null
  if (key === 'price') return minPrice.value || maxPrice.value
  return false
}

const closeFilterDrawer = () => {
  showFilterDrawer.value = false
  priceError.value = ''
}

const resetCurrentFilter = () => {
  if (currentDrawer.value === 'category') {
    selectedCategoryId.value = null
  } else if (currentDrawer.value === 'brand') {
    selectedBrandId.value = null
  } else if (currentDrawer.value === 'price') {
    minPrice.value = ''
    maxPrice.value = ''
    priceError.value = ''
  }
}

const confirmFilter = () => {
  if (currentDrawer.value === 'price') {
    validatePrice()
    if (priceError.value) return
  }
  closeFilterDrawer()
  resetPage()
  loadGoods()
}

const resetPage = () => {
  page.value = 1
  goodsList.value = []
  hasMore.value = true
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
    } else if (activeFilter.value === 'price') {
      params.sortField = 'price'
      params.sortOrder = priceOrder.value || 'asc'
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

    const result = await loadSearchProducts(params)

    if (result.list) {
      if (page.value === 1) {
        goodsList.value = result.list
      } else {
        goodsList.value = [...goodsList.value, ...result.list]
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
  selectedCategoryId.value = null
  selectedBrandId.value = null
  minPrice.value = ''
  maxPrice.value = ''
  activeFilter.value = 'default'
  priceOrder.value = ''
  resetPage()
  loadGoods()
  loadBrandListWithKeyword()
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
  
  const initKeyword = options.keyword || ''
  keyword.value = decodeURIComponent(initKeyword)
  
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

.header-bar {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  z-index: 100;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 20rpx 24rpx;
  padding-top: calc(20rpx + env(safe-area-inset-top));
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
}

.back-icon {
  font-size: 48rpx;
  color: $text-main;
  font-weight: 300;
}

.search-input-wrap {
  flex: 1;
  display: flex;
  align-items: center;
  background: $bg-page-light;
  border-radius: $radius-full;
  padding: 16rpx 24rpx;
}

.search-icon {
  font-size: 32rpx;
  margin-right: 12rpx;
}

.search-input {
  flex: 1;
  font-size: 28rpx;
  color: $text-main;
}

.clear-icon {
  width: 40rpx;
  height: 40rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  color: $text-weak;
  font-size: 36rpx;

  &:active {
    opacity: 0.6;
  }
}

.header-right {
  margin-left: 16rpx;
}

.search-btn {
  padding: 0 32rpx;
  height: 88rpx;
  background: linear-gradient(135deg, $color-primary 0%, $color-primary-danger 100%);
  border-radius: $radius-full;
  display: flex;
  align-items: center;
  justify-content: center;

  &:active {
    opacity: 0.8;
  }
}

.search-btn-text {
  font-size: 30rpx;
  color: #FFFFFF;
  font-weight: 600;
}

.filter-bar {
  position: fixed;
  top: calc(88rpx + env(safe-area-inset-top));
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
  gap: 8rpx;

  &:active {
    opacity: 0.6;
  }
}

.filter-text {
  font-size: 28rpx;
  color: $text-sub;
}

.filter-arrow {
  font-size: 24rpx;
  color: $text-sub;
}

.filter-dot {
  width: 12rpx;
  height: 12rpx;
  background: $color-primary-danger;
  border-radius: 50%;
}

.filter-item.active {
  .filter-text,
  .filter-arrow {
    color: $color-primary;
    font-weight: 600;
  }
}

.goods-scroll {
  height: calc(100vh - 168rpx - env(safe-area-inset-top));
  padding-top: calc(168rpx + env(safe-area-inset-top));
}

.loading-state,
.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 120rpx 0;
}

.loading-text {
  font-size: 28rpx;
  color: $text-weak;
}

.empty-icon {
  font-size: 100rpx;
  margin-bottom: 24rpx;
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

  &:active {
    opacity: 0.8;
  }
}

.go-shopping-text {
  font-size: 30rpx;
  color: #FFFFFF;
  font-weight: 600;
}

.goods-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 16rpx;
  padding: 0 20rpx;
}

.goods-card {
  background: $bg-card;
  border-radius: $radius-lg;
  overflow: hidden;
  padding-bottom: 20rpx;

  &:active {
    opacity: 0.8;
    transform: scale(0.98);
  }
}

.goods-image-wrap {
  position: relative;
  width: 100%;
  padding-top: 100%;
}

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
  gap: 8rpx;
}

.tag-item {
  padding: 6rpx 16rpx;
  background: rgba(0, 0, 0, 0.5);
  color: #FFFFFF;
  font-size: 22rpx;
  border-radius: 8rpx;
}

.tag-hot {
  background: $color-primary-danger;
}

.goods-info {
  padding: 16rpx;
}

.goods-title {
  display: -webkit-box;
  -webkit-box-orient: vertical;
  -webkit-line-clamp: 2;
  line-clamp: 2;
  overflow: hidden;
  font-size: 26rpx;
  color: $text-main;
  line-height: 1.4;
  margin-bottom: 12rpx;
}

.goods-price-row {
  display: flex;
  align-items: baseline;
  gap: 12rpx;
  margin-bottom: 8rpx;
}

.goods-price {
  font-size: 32rpx;
  color: $color-primary-danger;
  font-weight: 700;
}

.goods-original-price {
  font-size: 22rpx;
  color: $text-weak;
  text-decoration: line-through;
}

.goods-sales-row {
  display: flex;
  align-items: center;
  gap: 8rpx;
}

.goods-sales {
  font-size: 22rpx;
  color: $text-weak;
}

.load-more {
  padding: 24rpx 0;
  text-align: center;
}

.load-more-text,
.no-more-text {
  font-size: 26rpx;
  color: $text-weak;
}

.safe-bottom {
  height: env(safe-area-inset-bottom);
}

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
  max-height: 70vh;
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
}

.drawer-title {
  font-size: 34rpx;
  font-weight: 600;
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

.drawer-body {
  flex: 1;
  overflow-y: auto;
  padding: 32rpx 24rpx;
}

.category-section {
  display: flex;
  flex-wrap: wrap;
  gap: 16rpx;
}

.category-group {
  width: 100%;
  margin-bottom: 20rpx;

  &:last-child {
    margin-bottom: 0;
  }
}

.category-group-title {
  display: block;
  font-size: 28rpx;
  font-weight: 600;
  color: $text-main;
  margin-bottom: 16rpx;
  padding-left: 8rpx;
}

.category-option {
  padding: 16rpx 28rpx;
  background: $bg-page-light;
  border-radius: $radius-full;
  border: 2rpx solid transparent;

  &:active {
    opacity: 0.8;
  }

  text {
    font-size: 28rpx;
    color: $text-main;
  }
}

.category-option-active {
  background: rgba($color-primary, 0.05);
  border-color: $color-primary;

  text {
    color: $color-primary;
    font-weight: 500;
  }
}

.brand-section {
  display: flex;
  flex-wrap: wrap;
  gap: 16rpx;
}

.brand-option {
  padding: 16rpx 28rpx;
  background: $bg-page-light;
  border-radius: $radius-full;
  border: 2rpx solid transparent;

  &:active {
    opacity: 0.8;
  }

  text {
    font-size: 28rpx;
    color: $text-main;
  }
}

.brand-option-active {
  background: rgba($color-primary, 0.05);
  border-color: $color-primary;

  text {
    color: $color-primary;
    font-weight: 500;
  }
}

.price-section {
  padding-top: 8rpx;
}

.price-input-row {
  display: flex;
  align-items: center;
  gap: 16rpx;
}

.price-input-wrap {
  flex: 1;
  display: flex;
  align-items: center;
  background: $bg-page-light;
  border-radius: $radius-base;
  padding: 16rpx;
}

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

.price-separator {
  font-size: 28rpx;
  color: $text-sub;
}

.price-tips {
  margin-top: 16rpx;
  padding-left: 8rpx;
}

.price-error-text {
  font-size: 24rpx;
  color: $color-primary-danger;
}

.sort-section {
  padding-top: 8rpx;
}

.sort-option {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 24rpx 16rpx;
  border-bottom: 2rpx solid $bg-page-light;

  &:last-child {
    border-bottom: none;
  }

  &:active {
    background: $bg-page-light;
  }

  text {
    font-size: 30rpx;
    color: $text-main;
  }
}

.sort-option-active {
  text:first-child {
    color: $color-primary;
    font-weight: 600;
  }

  .sort-check {
    color: $color-primary;
    font-weight: 600;
  }
}

.sort-check {
  color: transparent;
}

.drawer-footer {
  display: flex;
  gap: 16rpx;
  padding: 20rpx 24rpx;
  padding-bottom: calc(20rpx + env(safe-area-inset-bottom));
  border-top: 2rpx solid $bg-page-light;
}

.btn-reset,
.btn-confirm {
  flex: 1;
  height: 88rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: $radius-full;
  font-size: 30rpx;
  font-weight: 600;

  &:active {
    opacity: 0.8;
  }
}

.btn-reset {
  background: $bg-page-light;
  color: $text-sub;
}

.btn-confirm {
  background: linear-gradient(135deg, $color-primary 0%, $color-primary-danger 100%);
  color: #FFFFFF;
}
</style>