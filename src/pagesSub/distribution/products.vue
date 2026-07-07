<template>
  <view class="page-products">
    <!-- 自定义导航栏 -->
    <view class="nav-bar" :style="{ paddingTop: statusBarHeight + 'px' }">
      <view class="nav-back" @click="handleBack">
        <text class="back-icon">‹</text>
      </view>
      <text class="nav-title">可推广商品</text>
      <view class="nav-placeholder-right"></view>
    </view>
    <view class="nav-placeholder" :style="{ height: (statusBarHeight + 44) + 'px' }"></view>

    <!-- 搜索栏 -->
    <view class="search-bar">
      <view class="search-input-wrap">
        <image class="search-icon" src="/static/fonts/search.svg" mode="aspectFit" />
        <input
          class="search-input"
          v-model="keyword"
          placeholder="搜索商品名称"
          placeholder-class="placeholder"
          confirm-type="search"
          @confirm="handleSearch"
        />
        <view v-if="keyword" class="search-clear" @click="clearKeyword">
          <text class="clear-icon">✕</text>
        </view>
      </view>
    </view>

    <!-- 商品列表 -->
    <scroll-view
      scroll-y
      class="product-scroll"
      :refresher-enabled="true"
      :refresher-triggered="refreshing"
      @refresherrefresh="onRefresh"
      @scrolltolower="onLoadMore"
    >
      <!-- 加载中（首次） -->
      <view v-if="distributorStore.promotionProductsLoading && productList.length === 0" class="loading-state">
        <view class="loading-spinner"></view>
        <text class="loading-text">加载中...</text>
      </view>

      <!-- 空状态 -->
      <view v-else-if="productList.length === 0" class="empty-state">
        <text class="empty-icon">📦</text>
        <text class="empty-title">暂无可推广商品</text>
        <text class="empty-desc">商家尚未开放分销商品</text>
      </view>

      <!-- 商品列表 -->
      <view v-else class="product-list">
        <view
          v-for="item in productList"
          :key="item.distributionProductId"
          class="product-card"
        >
          <!-- 商品图片 -->
          <view class="product-image-wrap">
            <image
              :src="item.mainImage"
              mode="aspectFill"
              class="product-image"
              lazy-load
            />
          </view>

          <!-- 商品信息 -->
          <view class="product-info">
            <view class="info-top">
              <text class="product-name">{{ item.productName }}</text>
              <text class="product-price">¥{{ formatMoney(item.price) }}</text>
            </view>
            <view class="info-bottom">
              <view class="commission-tag">
                <text class="commission-text">佣金 {{ item.commissionRate }}%</text>
              </view>
              <text class="merchant-name">{{ item.merchantName }}</text>
            </view>
            <!-- 操作按钮 -->
            <view class="action-area">
              <view
                v-if="item.alreadyPromoted"
                class="action-btn btn-promoted"
              >
                <text class="btn-text">已推广</text>
              </view>
              <view
                v-else
                class="action-btn btn-promote"
                :class="{ 'btn-loading': promotingId === item.distributionProductId }"
                @click="handlePromote(item)"
              >
                <text class="btn-text">
                  {{ promotingId === item.distributionProductId ? '申请中...' : '申请推广' }}
                </text>
              </view>
            </view>
          </view>
        </view>

        <!-- 加载更多 -->
        <view v-if="productList.length > 0" class="load-more">
          <text v-if="distributorStore.promotionProductsLoading" class="load-more-text">加载中...</text>
          <text v-else-if="hasMore" class="load-more-text">上拉加载更多</text>
          <text v-else class="load-more-text">没有更多了</text>
        </view>
      </view>

      <view class="safe-bottom"></view>
    </scroll-view>
  </view>
</template>

<script setup>
import { ref, computed } from 'vue'
import { onShow, onUnload } from '@dcloudio/uni-app'
import { useDistributor } from '@/hooks/useDistributor'

const statusBarHeight = uni.getSystemInfoSync().statusBarHeight || 20

const {
  distributorStore,
  loadPromotionProducts,
  searchPromotionProducts,
  promoteProduct
} = useDistributor()

// 本地状态
const keyword = ref('')
const refreshing = ref(false)
const promotingId = ref(null) // 当前正在申请推广的 distributionProductId

// 商品列表
const productList = computed(() => distributorStore.promotionProducts)
const hasMore = computed(() => distributorStore.promotionProductsPage < distributorStore.promotionProductsPages)

const formatMoney = (value) => {
  return (Number(value) || 0).toFixed(2)
}

const handleBack = () => {
  uni.navigateBack({
    delta: 1,
    animationType: 'slide-out-right',
    animationDuration: 200
  })
}

// 搜索
const handleSearch = () => {
  searchPromotionProducts(keyword.value)
}

// 清空搜索
const clearKeyword = () => {
  keyword.value = ''
  searchPromotionProducts('')
}

// 下拉刷新
const onRefresh = async () => {
  refreshing.value = true
  await loadPromotionProducts(false)
  refreshing.value = false
}

// 上拉加载更多
const onLoadMore = () => {
  if (distributorStore.promotionProductsLoading || !hasMore.value) return
  loadPromotionProducts(true)
}

// 申请推广
const handlePromote = async (item) => {
  if (promotingId.value) return
  promotingId.value = item.distributionProductId
  await promoteProduct(item)
  promotingId.value = null
}

onShow(() => {
  if (productList.value.length === 0) {
    loadPromotionProducts(false)
  }
})

onUnload(() => {
  distributorStore.resetPromotionData()
})
</script>

<style lang="scss" scoped>
.page-products {
  min-height: 100vh;
  background: $bg-page;
  display: flex;
  flex-direction: column;
}

// ============ 导航栏 ============
.nav-bar {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  height: 88rpx;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 24rpx;
  z-index: 999;
  background: rgba(255, 255, 255, 0.92);
  backdrop-filter: blur(40rpx) saturate(180%);
  -webkit-backdrop-filter: blur(40rpx) saturate(180%);
  border-bottom: 2rpx solid rgba(255, 255, 255, 0.6);
  box-shadow: $shadow-sm;

  .nav-back {
    width: 64rpx;
    height: 64rpx;
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: 50%;

    &:active {
      transform: scale(0.92);
      background: $neutral-100;
    }

    .back-icon {
      font-size: 56rpx;
      color: $ink-900;
      line-height: 1;
      font-weight: 300;
    }
  }

  .nav-title {
    font-size: 34rpx;
    font-weight: 600;
    color: $ink-900;
  }

  .nav-placeholder-right {
    width: 64rpx;
  }
}

.nav-placeholder {
  width: 100%;
  flex-shrink: 0;
}

// ============ 搜索栏 ============
.search-bar {
  padding: 16rpx 24rpx;
  background: $bg-card;
  box-shadow: $shadow-xs;
}

.search-input-wrap {
  display: flex;
  align-items: center;
  height: 72rpx;
  padding: 0 24rpx;
  background: $bg-page-light;
  border-radius: 36rpx;

  .search-icon {
    width: 32rpx;
    height: 32rpx;
    margin-right: 12rpx;
    opacity: 0.6;
  }

  .search-input {
    flex: 1;
    font-size: 28rpx;
    color: $ink-900;
  }

  .placeholder {
    color: $text-weak;
  }

  .search-clear {
    width: 36rpx;
    height: 36rpx;
    display: flex;
    align-items: center;
    justify-content: center;
    background: $neutral-300;
    border-radius: 50%;
    margin-left: 12rpx;

    .clear-icon {
      font-size: 20rpx;
      color: #FFFFFF;
    }
  }
}

// ============ 商品列表 ============
.product-scroll {
  flex: 1;
  height: 0;
}

.product-list {
  padding: 16rpx 24rpx 24rpx;
}

.product-card {
  display: flex;
  background: $bg-card;
  border-radius: 20rpx;
  padding: 20rpx;
  margin-bottom: 16rpx;
  box-shadow: $shadow-sm;

  &:active {
    transform: scale(0.99);
  }
}

.product-image-wrap {
  width: 180rpx;
  height: 180rpx;
  border-radius: 16rpx;
  overflow: hidden;
  background: $bg-page-light;
  flex-shrink: 0;
  margin-right: 20rpx;

  .product-image {
    width: 100%;
    height: 100%;
  }
}

.product-info {
  flex: 1;
  display: flex;
  flex-direction: column;
  min-width: 0;

  .info-top {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    margin-bottom: 12rpx;

    .product-name {
      flex: 1;
      font-size: 28rpx;
      color: $text-main;
      font-weight: 500;
      line-height: 1.4;
      overflow: hidden;
      text-overflow: ellipsis;
      display: -webkit-box;
      -webkit-line-clamp: 2;
      -webkit-box-orient: vertical;
      margin-right: 16rpx;
    }

    .product-price {
      font-size: 30rpx;
      color: $color-primary-danger;
      font-weight: 600;
      flex-shrink: 0;
    }
  }

  .info-bottom {
    display: flex;
    align-items: center;
    margin-bottom: 16rpx;

    .commission-tag {
      padding: 4rpx 12rpx;
      background: linear-gradient(135deg, rgba(255, 106, 0, 0.1) 0%, rgba(255, 77, 79, 0.1) 100%);
      border-radius: 8rpx;
      margin-right: 12rpx;

      .commission-text {
        font-size: 22rpx;
        color: $color-primary;
        font-weight: 600;
      }
    }

    .merchant-name {
      font-size: 22rpx;
      color: $text-weak;
      flex: 1;
      overflow: hidden;
      text-overflow: ellipsis;
      white-space: nowrap;
    }
  }
}

.action-area {
  display: flex;
  justify-content: flex-end;
  margin-top: auto;
}

.action-btn {
  padding: 12rpx 32rpx;
  border-radius: 28rpx;

  &:active {
    transform: scale(0.96);
  }

  &.btn-loading {
    opacity: 0.7;
    pointer-events: none;
  }

  .btn-text {
    font-size: 24rpx;
    font-weight: 500;
  }
}

.btn-promoted {
  background: $bg-page-light;

  .btn-text {
    color: $text-weak;
  }
}

.btn-promote {
  background: linear-gradient(135deg, $color-primary 0%, $color-primary-danger 100%);
  box-shadow: 0 6rpx 12rpx rgba(255, 106, 0, 0.25);

  .btn-text {
    color: #FFFFFF;
  }
}

// ============ 加载/空状态 ============
.loading-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding-top: 160rpx;
}

.loading-spinner {
  width: 56rpx;
  height: 56rpx;
  border: 5rpx solid $neutral-200;
  border-top-color: $color-primary;
  border-radius: 50%;
  animation: spin 0.8s linear infinite;
  margin-bottom: 20rpx;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

.loading-text {
  font-size: 26rpx;
  color: $text-weak;
}

.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding-top: 200rpx;

  .empty-icon {
    font-size: 120rpx;
    opacity: 0.5;
    margin-bottom: 32rpx;
  }

  .empty-title {
    font-size: 32rpx;
    color: $text-main;
    font-weight: 500;
    margin-bottom: 12rpx;
  }

  .empty-desc {
    font-size: 24rpx;
    color: $text-weak;
  }
}

.load-more {
  padding: 32rpx 0;

  .load-more-text {
    font-size: 24rpx;
    color: $text-weak;
    text-align: center;
    display: block;
  }
}

.safe-bottom {
  height: env(safe-area-inset-bottom);
  padding-bottom: 32rpx;
}
</style>
