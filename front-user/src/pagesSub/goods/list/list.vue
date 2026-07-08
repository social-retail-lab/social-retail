<template>
  <view class="page-container">
    <view class="nav-bar">
      <view class="nav-back" @click="goBack">
        <text class="back-icon">‹</text>
      </view>
      <text class="nav-title">{{ pageTitle }}</text>
      <view class="nav-right"></view>
    </view>

    <view class="filter-bar">
      <view
        v-for="item in sortOptions"
        :key="item.value"
        class="filter-item"
        :class="{ 'filter-item-active': activeSort === item.value }"
        @click="handleSort(item)"
      >
        <text class="filter-text">{{ item.label }}</text>
        <text v-if="activeSort === item.value && item.value !== 'createTime' && item.value !== 'productId'" class="sort-arrow">{{ sortOrder === 'asc' ? '↑' : '↓' }}</text>
      </view>
      <view class="filter-item" @click="showFilterDrawer = true">
        <text class="filter-text">筛选</text>
        <text class="filter-icon">⚙</text>
      </view>
    </view>

    <scroll-view
      scroll-y
      class="goods-scroll"
      :refresher-enabled="true"
      :refresher-triggered="refreshing"
      @refresherrefresh="handleRefresh"
      @scrolltolower="handleScrollToLower"
    >
      <view v-if="loading && goodsList.length === 0" class="loading-state">
        <text class="loading-text">加载中...</text>
      </view>

      <view v-else-if="!loading && goodsList.length === 0" class="empty-state">
        <text class="empty-icon">📦</text>
        <text class="empty-title">暂无相关商品</text>
        <text class="empty-desc">换个关键词试试吧</text>
      </view>

      <view v-else class="goods-grid">
        <view
          v-for="goods in goodsList"
          :key="goods.id"
          class="goods-item"
          @click="handleGoodsClick(goods)"
        >
          <view class="goods-image-wrap">
            <image :src="goods.image" mode="aspectFill" class="goods-image" lazy-load />
            <view v-if="goods.tags && goods.tags.length > 0" class="goods-tags">
              <text class="tag-item">{{ goods.tags[0] }}</text>
            </view>
          </view>
          <view class="goods-info">
            <text class="goods-title">{{ goods.name }}</text>
            <view class="goods-price-wrap">
              <text class="goods-price">¥{{ goods.price }}</text>
              <text v-if="goods.originalPrice" class="goods-original-price">¥{{ goods.originalPrice }}</text>
            </view>
            <text class="goods-sales">已售{{ goods.soldCount }}</text>
          </view>
        </view>
      </view>

      <view v-if="goodsList.length > 0" class="load-more">
        <text v-if="loading && !finished" class="load-more-text">加载中...</text>
        <text v-else-if="finished" class="no-more-text">没有更多商品了</text>
      </view>

      <view class="safe-bottom"></view>
    </scroll-view>

    <view class="filter-drawer" :class="{ show: showFilterDrawer }" @click="showFilterDrawer = false">
      <view class="drawer-mask"></view>
      <view class="drawer-content" @click.stop>
        <view class="drawer-header">
          <text class="drawer-title">筛选</text>
          <view class="drawer-close" @click="showFilterDrawer = false">
            <text class="close-icon">×</text>
          </view>
        </view>

        <view class="drawer-body">
          <view class="filter-section">
            <text class="section-title">价格区间</text>
            <view class="price-input-wrap">
              <input
                v-model="minPrice"
                type="digit"
                class="price-input"
                placeholder="最低价"
              />
              <text class="price-separator">-</text>
              <input
                v-model="maxPrice"
                type="digit"
                class="price-input"
                placeholder="最高价"
              />
            </view>
          </view>
        </view>

        <view class="drawer-footer">
          <view class="btn-reset" @click="handleReset">
            <text class="btn-text">重置</text>
          </view>
          <view class="btn-confirm" @click="handleConfirm">
            <text class="btn-text">确定</text>
          </view>
        </view>
      </view>
    </view>
  </view>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { showToast } from '@/utils/common'
import { useGoods } from '@/hooks/useGoods'

const page = ref(1)
const pageSize = 10
const loading = ref(false)
const refreshing = ref(false)
const finished = ref(false)
const totalPages = ref(0)
const goodsList = ref([])

const activeSort = ref('createTime')
const sortField = ref('createTime')
const sortOrder = ref('desc')

const showFilterDrawer = ref(false)
const minPrice = ref('')
const maxPrice = ref('')

const keyword = ref('')
const categoryId = ref('')

const { loadProductList, loadSearchProducts, loadCategoryProducts } = useGoods()

const sortOptions = [
  { label: '综合', value: 'createTime' },
  { label: '销量', value: 'soldCount' },
  { label: '价格', value: 'price' },
  { label: '新品', value: 'productId' }
]

const pageTitle = computed(() => {
  if (keyword.value) return keyword.value
  if (categoryId.value) return '分类商品'
  return '商品列表'
})

const goBack = () => {
  uni.navigateBack()
}

const handleSort = (item) => {
  activeSort.value = item.value

  if (item.value === 'soldCount') {
    // 销量：默认降序（从高到低）
    sortField.value = 'soldCount'
    sortOrder.value = 'desc'
  } else if (item.value === 'price') {
    // 价格：切换升序/降序
    if (sortField.value === 'price') {
      sortOrder.value = sortOrder.value === 'asc' ? 'desc' : 'asc'
    } else {
      sortField.value = 'price'
      sortOrder.value = 'asc'
    }
  } else if (item.value === 'productId') {
    // 新品：按 productId 降序（数值越大越新）
    sortField.value = 'productId'
    sortOrder.value = 'desc'
  } else {
    // 综合：默认按创建时间降序
    sortField.value = 'createTime'
    sortOrder.value = 'desc'
  }

  page.value = 1
  finished.value = false
  loadGoods()
}

const handleReset = () => {
  minPrice.value = ''
  maxPrice.value = ''
}

const handleConfirm = () => {
  showFilterDrawer.value = false
  page.value = 1
  finished.value = false
  loadGoods()
}

const handleRefresh = () => {
  page.value = 1
  finished.value = false
  loadGoods()
}

const handleScrollToLower = () => {
  if (loading.value || finished.value) return
  page.value++
  loadGoods()
}

const handleGoodsClick = (goods) => {
  uni.navigateTo({
    url: `/pagesSub/goods/detail/goodsDetail?productId=${goods.id}`
  })
}

onMounted(() => {
  const pages = getCurrentPages()
  const currentPage = pages[pages.length - 1]
  const options = currentPage.options || {}
  
  if (options.keyword) {
    keyword.value = decodeURIComponent(options.keyword)
  }
  if (options.categoryId) {
    categoryId.value = options.categoryId
  }
  
  loadGoods()
})

const loadGoods = async () => {
  loading.value = true
  try {
    const params = {
      page: page.value,
      pageSize: pageSize,
      sortField: sortField.value,
      sortOrder: sortOrder.value
    }

    if (minPrice.value) params.minPrice = parseFloat(minPrice.value)
    if (maxPrice.value) params.maxPrice = parseFloat(maxPrice.value)

    let result
    if (keyword.value) {
      result = await loadSearchProducts({
        ...params,
        keyword: keyword.value,
        categoryId: categoryId.value || undefined
      })
    } else if (categoryId.value) {
      result = await loadCategoryProducts(categoryId.value, params)
    } else {
      result = await loadProductList(params)
    }

    if (result.list) {
      if (page.value === 1) {
        goodsList.value = result.list
      } else {
        goodsList.value = [...goodsList.value, ...result.list]
      }
      totalPages.value = result.pages || Math.ceil((result.total || 0) / pageSize)
      finished.value = page.value >= totalPages.value || result.list.length === 0
    } else {
      finished.value = true
    }
  } catch (error) {
    console.error('加载商品失败', error)
    finished.value = true
  } finally {
    loading.value = false
    refreshing.value = false
  }
}
</script>

<style lang="scss" scoped>
.page-container {
  min-height: 100vh;
  background-color: #F5F5F5;
}

.nav-bar {
  height: 88rpx;
  background-color: #FFFFFF;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 32rpx;
  position: sticky;
  top: 0;
  z-index: 100;
}

.nav-back {
  width: 60rpx;
}

.back-icon {
  font-size: 48rpx;
  color: #333333;
}

.nav-title {
  font-size: 34rpx;
  font-weight: 600;
  color: #333333;
}

.nav-right {
  width: 60rpx;
}

.filter-bar {
  display: flex;
  background-color: #FFFFFF;
  padding: 0 24rpx;
  border-bottom: 1rpx solid #F0F0F0;
}

.filter-item {
  flex: 1;
  height: 88rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  position: relative;
}

.filter-text {
  font-size: 28rpx;
  color: #333333;
}

.filter-item-active {
  .filter-text {
    color: #FF6A00;
  }
}

.sort-arrow {
  font-size: 20rpx;
  color: #FF6A00;
  margin-left: 8rpx;
}

.filter-icon {
  margin-left: 8rpx;
  font-size: 24rpx;
}

.goods-scroll {
  height: calc(100vh - 176rpx);
}

.loading-state,
.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 100rpx 0;
}

.loading-text {
  font-size: 28rpx;
  color: #999999;
}

.empty-icon {
  font-size: 120rpx;
  margin-bottom: 24rpx;
}

.empty-title {
  font-size: 32rpx;
  color: #333333;
  margin-bottom: 12rpx;
}

.empty-desc {
  font-size: 26rpx;
  color: #999999;
}

.goods-grid {
  display: flex;
  flex-wrap: wrap;
  padding: 24rpx;
  gap: 24rpx;
}

.goods-item {
  width: calc(50% - 12rpx);
  background-color: #FFFFFF;
  border-radius: 16rpx;
  overflow: hidden;
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
}

.tag-item {
  padding: 6rpx 16rpx;
  background-color: #FF6A00;
  color: #FFFFFF;
  font-size: 22rpx;
  border-radius: 8rpx;
}

.goods-info {
  padding: 16rpx;
}

.goods-title {
  font-size: 28rpx;
  color: #333333;
  line-height: 1.4;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
  margin-bottom: 12rpx;
}

.goods-price-wrap {
  display: flex;
  align-items: baseline;
  margin-bottom: 8rpx;
}

.goods-price {
  font-size: 32rpx;
  color: #FF6A00;
  font-weight: 600;
}

.goods-original-price {
  font-size: 22rpx;
  color: #999999;
  text-decoration: line-through;
  margin-left: 12rpx;
}

.goods-sales {
  font-size: 22rpx;
  color: #999999;
}

.load-more {
  padding: 24rpx 0;
  text-align: center;
}

.load-more-text {
  font-size: 26rpx;
  color: #999999;
}

.no-more-text {
  font-size: 26rpx;
  color: #CCCCCC;
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
}

.filter-drawer.show {
  pointer-events: auto;
}

.drawer-mask {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, 0.5);
  opacity: 0;
  transition: opacity 0.3s;
}

.filter-drawer.show .drawer-mask {
  opacity: 1;
}

.drawer-content {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  background-color: #FFFFFF;
  border-radius: 24rpx 24rpx 0 0;
  transform: translateY(100%);
  transition: transform 0.3s;
}

.filter-drawer.show .drawer-content {
  transform: translateY(0);
}

.drawer-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 32rpx;
  border-bottom: 1rpx solid #F0F0F0;
}

.drawer-title {
  font-size: 32rpx;
  font-weight: 600;
  color: #333333;
}

.drawer-close {
  width: 48rpx;
  height: 48rpx;
  display: flex;
  align-items: center;
  justify-content: center;
}

.close-icon {
  font-size: 36rpx;
  color: #999999;
}

.drawer-body {
  padding: 32rpx;
  max-height: 60vh;
  overflow-y: auto;
}

.filter-section {
  margin-bottom: 32rpx;
}

.section-title {
  font-size: 28rpx;
  color: #333333;
  font-weight: 500;
  margin-bottom: 20rpx;
  display: block;
}

.price-input-wrap {
  display: flex;
  align-items: center;
  gap: 16rpx;
}

.price-input {
  flex: 1;
  height: 80rpx;
  background-color: #F5F5F5;
  border-radius: 12rpx;
  padding: 0 24rpx;
  font-size: 28rpx;
  color: #333333;
}

.price-separator {
  font-size: 28rpx;
  color: #999999;
}

.drawer-footer {
  display: flex;
  padding: 24rpx 32rpx;
  padding-bottom: calc(24rpx + env(safe-area-inset-bottom));
  gap: 24rpx;
  border-top: 1rpx solid #F0F0F0;
}

.btn-reset,
.btn-confirm {
  flex: 1;
  height: 88rpx;
  border-radius: 44rpx;
  display: flex;
  align-items: center;
  justify-content: center;
}

.btn-reset {
  background-color: #F5F5F5;
  
  .btn-text {
    font-size: 30rpx;
    color: #333333;
  }
}

.btn-confirm {
  background: linear-gradient(135deg, #FF6A00 0%, #FF8C40 100%);
  
  .btn-text {
    font-size: 30rpx;
    color: #FFFFFF;
    font-weight: 600;
  }
}
</style>
