<template>
  <view class="page-orders">
    <!-- 自定义导航栏 -->
    <view class="nav-bar" :style="{ paddingTop: statusBarHeight + 'px' }">
      <view class="nav-back" @click="handleBack">
        <text class="back-icon">‹</text>
      </view>
      <text class="nav-title">推广订单</text>
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

    <!-- 状态筛选 Tab -->
    <view class="status-tabs">
      <view
        v-for="tab in COMMISSION_STATUS_TABS"
        :key="tab.value"
        class="status-tab"
        :class="{ 'status-tab-active': currentStatus === tab.value }"
        @click="handleTabChange(tab.value)"
      >
        <text class="tab-text">{{ tab.label }}</text>
      </view>
    </view>

    <!-- 订单列表 -->
    <scroll-view
      scroll-y
      class="order-scroll"
      :refresher-enabled="true"
      :refresher-triggered="refreshing"
      @refresherrefresh="onRefresh"
      @scrolltolower="onLoadMore"
    >
      <!-- 加载中（首次） -->
      <view v-if="distributorStore.distributorOrdersLoading && orderList.length === 0" class="loading-state">
        <view class="loading-spinner"></view>
        <text class="loading-text">加载中...</text>
      </view>

      <!-- 空状态 -->
      <view v-else-if="orderList.length === 0" class="empty-state">
        <text class="empty-icon">🧾</text>
        <text class="empty-title">暂无推广订单</text>
        <text class="empty-desc">推广的商品产生订单后会显示在这里</text>
      </view>

      <!-- 订单列表 -->
      <view v-else class="order-list">
        <view
          v-for="item in orderList"
          :key="item.commissionId"
          class="order-card"
        >
          <!-- 卡片头部：商品信息 -->
          <view class="card-header">
            <view class="product-image-wrap">
              <image
                :src="item.mainImage"
                mode="aspectFill"
                class="product-image"
                lazy-load
              />
            </view>
            <view class="product-info">
              <text class="product-name">{{ item.productName }}</text>
              <text class="merchant-name">{{ item.merchantName }}</text>
              <text class="order-sn">订单号：{{ item.orderSn }}</text>
            </view>
            <view
              class="status-badge"
              :style="getStatusStyle(item.status)"
            >
              <text class="status-text">{{ item.statusText }}</text>
            </view>
          </view>

          <!-- 卡片数据区 -->
          <view class="card-body">
            <view class="data-item">
              <text class="data-label">订单金额</text>
              <text class="data-value">¥{{ formatMoney(item.orderAmount) }}</text>
            </view>
            <view class="data-divider"></view>
            <view class="data-item">
              <text class="data-label">佣金比例</text>
              <text class="data-value">{{ item.commissionRate }}%</text>
            </view>
            <view class="data-divider"></view>
            <view class="data-item data-item-highlight">
              <text class="data-label">佣金金额</text>
              <text class="data-value highlight">¥{{ formatMoney(item.commissionAmount) }}</text>
            </view>
          </view>

          <!-- 卡片底部：时间 -->
          <view class="card-footer">
            <view class="time-item">
              <text class="time-label">完成时间</text>
              <text class="time-value">{{ item.orderFinishTime || '-' }}</text>
            </view>
            <view class="time-item" v-if="item.settleTime">
              <text class="time-label">预计结算</text>
              <text class="time-value">{{ item.settleTime }}</text>
            </view>
          </view>
        </view>

        <!-- 加载更多 -->
        <view v-if="orderList.length > 0" class="load-more">
          <text v-if="distributorStore.distributorOrdersLoading" class="load-more-text">加载中...</text>
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
  loadDistributorOrders,
  searchDistributorOrders,
  switchDistributorOrderStatus,
  COMMISSION_STATUS_TABS,
  COMMISSION_STATUS_MAP,
  formatMoney
} = useDistributor()

// 本地状态
const keyword = ref('')
const refreshing = ref(false)
const currentStatus = ref('')

// 订单列表
const orderList = computed(() => distributorStore.distributorOrders)
const hasMore = computed(() => distributorStore.distributorOrdersPage < distributorStore.distributorOrdersPages)

// 状态样式
const getStatusStyle = (status) => {
  const info = COMMISSION_STATUS_MAP[status]
  if (!info) return {}
  return {
    color: info.color,
    backgroundColor: info.bgColor
  }
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
  searchDistributorOrders(keyword.value)
}

// 清空搜索
const clearKeyword = () => {
  keyword.value = ''
  searchDistributorOrders('')
}

// 状态筛选切换
const handleTabChange = (status) => {
  currentStatus.value = status
  switchDistributorOrderStatus(status)
}

// 下拉刷新
const onRefresh = async () => {
  refreshing.value = true
  await loadDistributorOrders(false)
  refreshing.value = false
}

// 上拉加载更多
const onLoadMore = () => {
  if (hasMore.value && !distributorStore.distributorOrdersLoading) {
    loadDistributorOrders(true)
  }
}

onShow(() => {
  loadDistributorOrders(false)
})

onUnload(() => {
  // 保留数据，不重置，便于返回时保持状态
})
</script>

<style lang="scss" scoped>
.page-orders {
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
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(20rpx);
  z-index: 100;
  border-bottom: 1rpx solid rgba(0, 0, 0, 0.04);

  .nav-back {
    width: 64rpx;
    height: 64rpx;
    display: flex;
    align-items: center;
    justify-content: center;

    .back-icon {
      font-size: 48rpx;
      color: $text-main;
      line-height: 1;
    }
  }

  .nav-title {
    font-size: 32rpx;
    font-weight: 600;
    color: $text-main;
  }

  .nav-placeholder-right {
    width: 64rpx;
  }
}

.nav-placeholder {
  width: 100%;
}

// ============ 搜索栏 ============
.search-bar {
  padding: 16rpx 24rpx;
  background: $bg-card;

  .search-input-wrap {
    display: flex;
    align-items: center;
    height: 72rpx;
    padding: 0 24rpx;
    background: $bg-page;
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
      color: $text-main;
    }

    .placeholder {
      color: $text-weak;
      font-size: 28rpx;
    }

    .search-clear {
      width: 40rpx;
      height: 40rpx;
      display: flex;
      align-items: center;
      justify-content: center;
      margin-left: 8rpx;

      .clear-icon {
        font-size: 24rpx;
        color: $text-weak;
      }
    }
  }
}

// ============ 状态筛选 Tab ============
.status-tabs {
  display: flex;
  background: $bg-card;
  padding: 0 24rpx 16rpx;
  border-bottom: 1rpx solid rgba(0, 0, 0, 0.04);

  .status-tab {
    flex: 1;
    height: 64rpx;
    display: flex;
    align-items: center;
    justify-content: center;
    position: relative;

    .tab-text {
      font-size: 26rpx;
      color: $text-sub;
    }

    &.status-tab-active .tab-text {
      color: $color-primary;
      font-weight: 600;
    }

    &.status-tab-active::after {
      content: '';
      position: absolute;
      bottom: 0;
      left: 50%;
      transform: translateX(-50%);
      width: 48rpx;
      height: 4rpx;
      background: $color-primary;
      border-radius: 2rpx;
    }
  }
}

// ============ 订单列表 ============
.order-scroll {
  flex: 1;
  padding: 16rpx 24rpx;
  box-sizing: border-box;
}

.order-list {
  display: flex;
  flex-direction: column;
  gap: 16rpx;
}

.order-card {
  background: $bg-card;
  border-radius: 20rpx;
  padding: 24rpx;
  box-shadow: 0 4rpx 16rpx rgba(0, 0, 0, 0.04);
}

// 卡片头部
.card-header {
  display: flex;
  align-items: flex-start;

  .product-image-wrap {
    width: 120rpx;
    height: 120rpx;
    border-radius: 12rpx;
    overflow: hidden;
    flex-shrink: 0;
    background: $bg-page;

    .product-image {
      width: 100%;
      height: 100%;
    }
  }

  .product-info {
    flex: 1;
    margin-left: 20rpx;
    display: flex;
    flex-direction: column;
    overflow: hidden;

    .product-name {
      font-size: 28rpx;
      color: $text-main;
      font-weight: 500;
      line-height: 1.4;
      display: -webkit-box;
      -webkit-line-clamp: 2;
      -webkit-box-orient: vertical;
      overflow: hidden;
    }

    .merchant-name {
      font-size: 22rpx;
      color: $text-weak;
      margin-top: 8rpx;
    }

    .order-sn {
      font-size: 22rpx;
      color: $text-weak;
      margin-top: 4rpx;
      word-break: break-all;
    }
  }

  .status-badge {
    flex-shrink: 0;
    padding: 6rpx 16rpx;
    border-radius: 8rpx;
    margin-left: 16rpx;

    .status-text {
      font-size: 22rpx;
      font-weight: 500;
    }
  }
}

// 卡片数据区
.card-body {
  display: flex;
  align-items: center;
  margin-top: 20rpx;
  padding: 20rpx;
  background: $bg-page;
  border-radius: 12rpx;

  .data-item {
    flex: 1;
    display: flex;
    flex-direction: column;
    align-items: center;

    .data-label {
      font-size: 22rpx;
      color: $text-weak;
      margin-bottom: 6rpx;
    }

    .data-value {
      font-size: 28rpx;
      color: $text-main;
      font-weight: 600;

      &.highlight {
        color: $color-primary;
      }
    }
  }

  .data-divider {
    width: 1rpx;
    height: 48rpx;
    background: rgba(0, 0, 0, 0.06);
  }
}

// 卡片底部时间
.card-footer {
  display: flex;
  justify-content: space-between;
  margin-top: 16rpx;
  padding-top: 16rpx;
  border-top: 1rpx solid rgba(0, 0, 0, 0.04);

  .time-item {
    display: flex;
    flex-direction: column;

    .time-label {
      font-size: 22rpx;
      color: $text-weak;
      margin-bottom: 4rpx;
    }

    .time-value {
      font-size: 24rpx;
      color: $text-sub;
    }
  }
}

// ============ 加载状态 ============
.loading-state,
.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 120rpx 0;

  .loading-spinner {
    width: 64rpx;
    height: 64rpx;
    border: 4rpx solid rgba($color-primary, 0.1);
    border-top-color: $color-primary;
    border-radius: 50%;
    animation: spin 0.8s linear infinite;
    margin-bottom: 20rpx;
  }

  .loading-text {
    font-size: 26rpx;
    color: $text-weak;
  }

  .empty-icon {
    font-size: 96rpx;
    margin-bottom: 24rpx;
    opacity: 0.6;
  }

  .empty-title {
    font-size: 30rpx;
    color: $text-sub;
    margin-bottom: 8rpx;
  }

  .empty-desc {
    font-size: 24rpx;
    color: $text-weak;
  }
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

// ============ 加载更多 ============
.load-more {
  padding: 24rpx 0;
  text-align: center;

  .load-more-text {
    font-size: 24rpx;
    color: $text-weak;
  }
}

.safe-bottom {
  height: 32rpx;
}
</style>
