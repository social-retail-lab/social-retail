<template>
  <view class="page-container">
    <view class="header-fixed">
      <view class="search-bar">
        <view class="search-input" @click="goToSearch">
          <image src="/static/fonts/search.svg" class="search-icon" mode="aspectFit" />
          <text class="search-placeholder">搜索商品/品牌</text>
        </view>
      </view>

      <scroll-view scroll-x class="first-category-scroll" :show-scrollbar="false">
        <view class="first-category-list">
          <view
            v-for="category in firstLevelCategories"
            :key="category.categoryId"
            class="first-category-item"
            :class="{ 'first-category-item-active': activeFirstCategoryId === category.categoryId }"
            @click="handleFirstCategorySelect(category)"
          >
            <view class="category-icon-wrap">
              <text class="category-emoji">{{ category.icon || getCategoryIcon(category.categoryName) }}</text>
            </view>
            <text class="first-category-name">{{ category.categoryName }}</text>
          </view>
        </view>
      </scroll-view>
    </view>

    <view class="main-content">
      <scroll-view scroll-y class="second-category-sidebar" :show-scrollbar="false">
        <view
          v-for="category in currentSecondCategories"
          :key="category.categoryId"
          class="second-category-item"
          :class="{ 'second-category-item-active': activeSecondCategoryId === category.categoryId }"
          @click="handleSecondCategorySelect(category)"
        >
          <text class="second-category-name">{{ category.categoryName }}</text>
          <view v-if="activeSecondCategoryId === category.categoryId" class="second-active-indicator"></view>
        </view>
      </scroll-view>

      <scroll-view scroll-y class="goods-area" :show-scrollbar="false" @scrolltolower="onScrollToLower">
        <view class="sort-bar">
          <view
            class="sort-item"
            :class="{ 'sort-item-active': sortType === 'sales' }"
            @click="setSortType('sales')"
          >
            <text class="sort-icon">🔥</text>
            <text class="sort-text">销量</text>
            <text v-if="sortType === 'sales'" class="sort-active-mark">✓</text>
          </view>
          <view
            class="sort-item"
            :class="{ 'sort-item-active': sortType === 'price' }"
            @click="setSortType('price')"
          >
            <text class="sort-icon">💰</text>
            <text class="sort-text">价格</text>
            <text v-if="sortType === 'price'" class="sort-direction">{{ priceSortDirection === 'asc' ? '↑' : '↓' }}</text>
          </view>
        </view>

        <view class="goods-waterfall">
          <view
            v-for="goods in goodsList"
            :key="goods.productId"
            class="goods-card"
            @click="handleGoodsClick(goods)"
          >
            <view class="goods-image-wrap">
              <image :src="goods.productImage" mode="aspectFill" class="goods-image" lazy-load />
              <view v-if="goods.tags && goods.tags.length > 0" class="goods-tags">
                <text v-for="tag in goods.tags.slice(0, 2)" :key="tag" class="goods-tag">{{ tag }}</text>
              </view>
            </view>
            <view class="goods-info">
              <text class="goods-title">{{ goods.productName }}</text>
              <view class="goods-bottom">
                <view class="goods-price-wrap">
                  <text class="goods-price">¥{{ goods.price }}</text>
                  <text v-if="goods.originalPrice && goods.originalPrice > goods.price" class="goods-original-price">¥{{ goods.originalPrice }}</text>
                </view>
                <text class="goods-sales">已售{{ formatSales(goods.soldCount) }}</text>
              </view>
            </view>
          </view>
        </view>

        <view v-if="loading" class="loading-more">
          <view class="loading-spinner"></view>
          <text class="loading-text">加载中...</text>
        </view>
        <view v-if="finished && goodsList.length > 0" class="no-more">
          <text class="no-more-text">— 已加载全部商品 —</text>
        </view>
        <empty-view v-if="!loading && goodsList.length === 0" text="暂无相关商品" />
      </scroll-view>
    </view>

    <custom-tab-bar />
  </view>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import CustomTabBar from '@/components/global/CustomTabBar.vue'
import EmptyView from '@/components/global/EmptyView.vue'
import { useGoods } from '@/hooks/useGoods'

const categoryTree = ref([])
const goodsList = ref([])
const activeFirstCategoryId = ref(null)
const activeSecondCategoryId = ref(null)
const sortType = ref('sales')
const priceSortDirection = ref('desc')
const page = ref(1)
const finished = ref(false)
const loading = ref(false)

const { loadCategoryTree, loadCategoryProducts } = useGoods()

const firstLevelCategories = computed(() => {
  return categoryTree.value.filter(item => item.level === 1)
})

const currentFirstCategory = computed(() => {
  return categoryTree.value.find(item => item.categoryId === activeFirstCategoryId.value)
})

const currentSecondCategories = computed(() => {
  return currentFirstCategory.value && currentFirstCategory.value.children ? currentFirstCategory.value.children : []
})

const getCategoryIcon = (name) => {
  const iconMap = {
    '生鲜': '🥬',
    '果蔬': '🍎',
    '肉禽': '🥩',
    '食品': '🍪',
    '饮料': '🥤',
    '滋补': '🍵',
    '家居': '🏠',
    '百货': '🛍️',
    '厨具': '🍳',
    '餐具': '🍽️',
    '个护': '🧴',
    '美妆': '💄',
    '清洁': '🧹',
    '母婴': '🍼',
    '孕童': '👶'
  }
  for (const key in iconMap) {
    if (name.includes(key)) {
      return iconMap[key]
    }
  }
  return '📦'
}

const formatSales = (count) => {
  if (count >= 10000) {
    return (count / 10000).toFixed(1) + 'w'
  } else if (count >= 1000) {
    return (count / 1000).toFixed(1) + 'k'
  }
  return count
}

const handleFirstCategorySelect = async (category) => {
  activeFirstCategoryId.value = category.categoryId
  activeSecondCategoryId.value = null
  sortType.value = 'sales'
  priceSortDirection.value = 'desc'
  page.value = 1
  finished.value = false
  goodsList.value = []

  if (category.children && category.children.length > 0) {
    activeSecondCategoryId.value = category.children[0].categoryId
    await loadCategoryGoods(category.children[0].categoryId)
  }
}

const handleSecondCategorySelect = async (category) => {
  activeSecondCategoryId.value = category.categoryId
  page.value = 1
  finished.value = false
  goodsList.value = []
  await loadCategoryGoods(category.categoryId)
}

const setSortType = (type) => {
  if (type === 'sales') {
    sortType.value = 'sales'
  } else {
    sortType.value = 'price'
    priceSortDirection.value = priceSortDirection.value === 'asc' ? 'desc' : 'asc'
  }
  page.value = 1
  finished.value = false
  goodsList.value = []
  loadCategoryGoods(activeSecondCategoryId.value)
}

const handleGoodsClick = (goods) => {
  uni.navigateTo({
    url: `/pagesSub/goods/detail/goodsDetail?productId=${goods.productId}`
  })
}

const goToSearch = () => {
  uni.navigateTo({ url: '/pagesSub/goods/search/searchHome' })
}

const loadCategoryGoods = async (categoryId) => {
  if (!categoryId) return
  
  loading.value = true
  try {
    const params = {
      page: page.value,
      pageSize: 10
    }
    
    if (sortType.value === 'sales') {
      params.sortField = 'soldCount'
      params.sortOrder = 'desc'
    } else {
      params.sortField = 'price'
      params.sortOrder = priceSortDirection.value
    }
    
    const result = await loadCategoryProducts(categoryId, params)
    if (result.list) {
      if (page.value === 1) {
        goodsList.value = result.list
      } else {
        goodsList.value = [...goodsList.value, ...result.list]
      }
      finished.value = result.list.length < result.pageSize
    }
  } catch (error) {
    console.error('加载分类商品失败', error)
  } finally {
    loading.value = false
  }
}

const onScrollToLower = () => {
  if (loading.value || finished.value) return
  page.value++
  loadCategoryGoods(activeSecondCategoryId.value)
}

const initPage = async () => {
  try {
    const list = await loadCategoryTree()
    if (list.length > 0) {
      categoryTree.value = list
      const firstCategory = list.find(item => item.level === 1)
      if (firstCategory) {
        activeFirstCategoryId.value = firstCategory.categoryId
        if (firstCategory.children && firstCategory.children.length > 0) {
          activeSecondCategoryId.value = firstCategory.children[0].categoryId
          await loadCategoryGoods(firstCategory.children[0].categoryId)
        }
      }
    }
  } catch (error) {
    console.error('获取分类树失败', error)
  }
}

onMounted(() => {
  initPage()
})
</script>

<style lang="scss" scoped>
.page-container {
  height: 100vh;
  background-color: $bg-page;
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

.header-fixed {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  z-index: 100;
  background: $bg-card;
}

.search-bar {
  padding: 16rpx 20rpx;
  padding-top: calc(16rpx + env(safe-area-inset-top));
}

.search-input {
  width: 100%;
  display: flex;
  align-items: center;
  height: 72rpx;
  padding: 0 28rpx;
  background: $bg-page;
  border-radius: $radius-full;
  transition: all 0.2s ease;

  &:active {
    background: rgba($color-primary, 0.05);
  }
}

.search-icon {
  width: 40rpx;
  height: 40rpx;
  margin-right: 12rpx;
}

.search-placeholder {
  font-size: 26rpx;
  color: $text-weak;
}

.first-category-scroll {
  white-space: nowrap;
  padding: 16rpx 20rpx;
  border-top: 1rpx solid $border-color;
}

.first-category-list {
  display: inline-flex;
  gap: 20rpx;
}

.first-category-item {
  flex-shrink: 0;
  width: 140rpx;
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 16rpx 12rpx;
  background: $bg-page-light;
  border-radius: $radius-lg;
  transition: all 0.25s ease;

  &:active {
    transform: scale(0.96);
  }
}

.first-category-item-active {
  background: linear-gradient(135deg, rgba($color-primary, 0.1) 0%, rgba($color-primary-danger, 0.1) 100%);

  .category-icon-wrap {
    background: linear-gradient(135deg, $color-primary 0%, $color-primary-danger 100%);
    box-shadow: 0 4rpx 16rpx rgba($color-primary, 0.3);
  }

  .first-category-name {
    color: $color-primary;
    font-weight: 600;
  }
}

.category-icon-wrap {
  width: 64rpx;
  height: 64rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba($color-primary, 0.08);
  border-radius: 50%;
  margin-bottom: 10rpx;
  transition: all 0.25s ease;
}

.category-emoji {
  font-size: 32rpx;
}

.first-category-name {
  font-size: 22rpx;
  color: $text-sub;
  text-align: center;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  max-width: 100%;
}

.main-content {
  flex: 1;
  display: flex;
  margin-top: calc(104rpx + 160rpx + env(safe-area-inset-top));
  overflow: hidden;
}

.second-category-sidebar {
  width: 180rpx;
  height: 100%;
  flex-shrink: 0;
  background: rgba($color-primary, 0.02);
  padding-top: 16rpx;
}

.second-category-item {
  position: relative;
  display: flex;
  align-items: center;
  justify-content: center;
  height: 96rpx;
  padding: 0 16rpx;
  box-sizing: border-box;
  transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);

  &:active {
    background: rgba($color-primary, 0.06);
  }
}

.second-category-item-active {
  background: $bg-card;
  margin: 0 8rpx;
  border-radius: 12rpx;
  box-shadow: 0 4rpx 16rpx rgba(0, 0, 0, 0.06);

  .second-category-name {
    color: $color-primary;
    font-weight: 600;
  }
}

.second-category-name {
  font-size: 26rpx;
  color: $text-sub;
  text-align: center;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.second-active-indicator {
  position: absolute;
  left: 0;
  top: 50%;
  transform: translateY(-50%);
  width: 6rpx;
  height: 40rpx;
  background: linear-gradient(180deg, $color-primary 0%, $color-primary-danger 100%);
  border-radius: 0 3rpx 3rpx 0;
}

.goods-area {
  flex: 1;
  height: 100%;
  background: $bg-page;
  display: flex;
  flex-direction: column;
  min-width: 0;
  overflow: hidden;
}

.sort-bar {
  position: sticky;
  top: 0;
  z-index: 10;
  display: flex;
  align-items: center;
  justify-content: flex-start;
  padding: 0 20rpx;
  height: 80rpx;
  background: $bg-card;
  border-bottom: 1rpx solid rgba($color-primary, 0.06);
  gap: 12rpx;
}

.sort-item {
  display: flex;
  align-items: center;
  gap: 8rpx;
  padding: 12rpx 28rpx;
  border-radius: $radius-full;
  background: rgba($color-primary, 0.04);
  transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);

  &:active {
    transform: scale(0.96);
    background: rgba($color-primary, 0.08);
  }
}

.sort-item-active {
  background: linear-gradient(135deg, $color-primary 0%, $color-primary-danger 100%);
  box-shadow: 0 4rpx 16rpx rgba($color-primary, 0.3);

  .sort-icon,
  .sort-text,
  .sort-active-mark,
  .sort-direction {
    color: #fff;
  }
}

.sort-icon {
  font-size: 26rpx;
}

.sort-text {
  font-size: 26rpx;
  color: $text-sub;
  font-weight: 500;
}

.sort-active-mark {
  font-size: 20rpx;
  color: $color-primary;
  font-weight: 600;
}

.sort-direction {
  font-size: 22rpx;
  color: $color-primary;
  font-weight: 600;
}

.goods-waterfall {
  flex: 1;
  display: flex;
  flex-wrap: wrap;
  gap: 12rpx;
  padding: 12rpx;
  padding-bottom: calc(12rpx + 120rpx);
  box-sizing: border-box;
  overflow: hidden;
}

.goods-card {
  width: calc(50% - 8rpx);
  flex-shrink: 0;
  background: $bg-card;
  border-radius: 16rpx;
  overflow: hidden;
  transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
  box-shadow: 0 2rpx 16rpx rgba(0, 0, 0, 0.04);

  &:active {
    transform: scale(0.97);
    box-shadow: 0 6rpx 24rpx rgba(0, 0, 0, 0.12);
  }
}

.goods-image-wrap {
  width: 100%;
  padding-top: 100%;
  position: relative;
  background: $bg-page-light;
  overflow: hidden;
}

.goods-image {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  transition: transform 0.3s ease;

  .goods-card:active & {
    transform: scale(1.05);
  }
}

.goods-tags {
  position: absolute;
  top: 12rpx;
  left: 12rpx;
  display: flex;
  gap: 8rpx;
}

.goods-tag {
  padding: 4rpx 12rpx;
  font-size: 20rpx;
  color: #fff;
  background: rgba($color-primary-danger, 0.9);
  border-radius: 6rpx;
  font-weight: 500;
}

.goods-info {
  padding: 16rpx;
}

.goods-title {
  display: block;
  font-size: 24rpx;
  color: $text-main;
  line-height: 1.45;
  height: 68rpx;
  overflow: hidden;
  text-overflow: ellipsis;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  line-clamp: 2;
  -webkit-box-orient: vertical;
  margin-bottom: 12rpx;
}

.goods-bottom {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
}

.goods-price-wrap {
  display: flex;
  align-items: baseline;
  gap: 8rpx;
}

.goods-price {
  font-size: 32rpx;
  font-weight: 700;
  color: $color-primary-danger;
}

.goods-original-price {
  font-size: 20rpx;
  color: $text-weak;
  text-decoration: line-through;
}

.goods-sales {
  font-size: 20rpx;
  color: $text-weak;
}

.loading-more {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 12rpx;
  padding: 24rpx;
}

.loading-spinner {
  width: 32rpx;
  height: 32rpx;
  border: 3rpx solid $border-color;
  border-top-color: $color-primary;
  border-radius: 50%;
  animation: spin 0.8s linear infinite;
}

@keyframes spin {
  to {
    transform: rotate(360deg);
  }
}

.loading-text {
  font-size: 24rpx;
  color: $text-weak;
}

.no-more {
  padding: 24rpx;
  text-align: center;
}

.no-more-text {
  font-size: 22rpx;
  color: $text-weak;
}
</style>
