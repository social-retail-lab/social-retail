<template>
  <view class="page-container">
    <view class="order-header">
      <view class="header-left" @click="handleBack">
        <text class="back-icon">‹</text>
      </view>
      <text class="header-title">我的评价</text>
      <view class="header-right"></view>
    </view>

    <view class="tabs-bar">
      <view 
        v-for="tab in tabs" 
        :key="tab.key"
        class="tab-item"
        :class="{ 'tab-active': activeTab === tab.key }"
        @click="switchTab(tab.key)"
      >
        <text class="tab-text">{{ tab.label }}</text>
        <view v-if="tab.badge > 0" class="tab-badge">
          <text>{{ tab.badge > 99 ? '99+' : tab.badge }}</text>
        </view>
        <view v-if="activeTab === tab.key" class="tab-indicator"></view>
      </view>
    </view>

    <scroll-view 
      scroll-y 
      class="page-content"
      :refresher-enabled="true"
      :refresher-triggered="refreshing"
      @refresherrefresh="onRefresh"
      @scrolltolower="onLoadMore"
    >
      <view v-if="reviewList.length === 0 && !loading" class="empty-review">
        <view class="empty-icon">
          <text class="empty-text">📝</text>
        </view>
        <text class="empty-title">{{ activeTab === 'PENDING' ? '暂无待评价订单' : '暂无已评价订单' }}</text>
        <text class="empty-desc">{{ activeTab === 'PENDING' ? '快去购买商品并完成评价吧' : '快去评价商品吧' }}</text>
        <view class="empty-btn" @click="goShopping">
          <text>去逛逛</text>
        </view>
      </view>

      <view v-else class="review-list">
        <view v-for="item in reviewList" :key="item.id" class="review-card">
          <view class="review-header">
            <text class="review-order-sn">订单号：{{ item.orderSn }}</text>
            <text class="review-time">{{ item.orderTime }}</text>
          </view>

          <view class="review-goods">
            <image :src="getValidImageUrl(item.productImage)" class="goods-image" mode="aspectFill" />
            <view class="goods-info">
              <text class="goods-name">{{ item.productName }}</text>
              <text class="goods-spec">{{ item.skuSpecs }}</text>
              <text class="goods-price">¥{{ item.finalPrice.toFixed(2) }}</text>
            </view>
          </view>

          <view v-if="activeTab === 'PENDING'" class="review-actions">
            <view class="action-btn primary-btn" @click="handleWriteReview(item)">
              <text>去评价</text>
            </view>
          </view>

          <view v-else class="review-content">
            <view class="review-stars">
              <text v-for="i in 5" :key="i" class="star">{{ i <= item.star ? '★' : '☆' }}</text>
            </view>
            <text class="review-text">{{ item.content }}</text>
            <view v-if="item.images && item.images.length > 0" class="review-images">
              <image 
                v-for="(img, index) in item.images" 
                :key="index" 
                :src="getValidImageUrl(img)" 
                class="review-image" 
                mode="aspectFill"
              />
            </view>
            <text class="review-time-sm">{{ item.reviewTime }}</text>
          </view>

          <view class="review-detail-btn" @click="goToDetail(item.orderId)">
            <text>查看订单 ›</text>
          </view>
        </view>

        <view v-if="loading" class="loading-more">
          <text class="loading-text">加载中...</text>
        </view>
        <view v-if="!loading && !hasMore && reviewList.length > 0" class="no-more">
          <text class="no-more-text">没有更多了</text>
        </view>
      </view>
    </scroll-view>

    <custom-tab-bar />
  </view>
</template>

<script setup>
import { ref, onMounted, watch } from 'vue'
import { onShow } from '@dcloudio/uni-app'
import { showToast, getValidImageUrl } from '@/utils/common'
import CustomTabBar from '@/components/global/CustomTabBar.vue'
import { useOrder } from '@/hooks/useOrder'

const orderHook = useOrder()

const activeTab = ref('PENDING')
const reviewList = ref([])
const loading = ref(false)
const refreshing = ref(false)
const page = ref(1)
const pageSize = ref(20)
const hasMore = ref(true)
const totalPages = ref(0)

const tabs = [
  { key: 'PENDING', label: '待评价', badge: 0 },
  { key: 'DONE', label: '已评价', badge: 0 }
]

const handleBack = () => {
  uni.navigateBack({
    fail: () => {
      uni.switchTab({ url: '/pages/index/index' })
    }
  })
}

const goShopping = () => {
  uni.switchTab({ url: '/pages/index/index' })
}

const goToDetail = (orderId) => {
  uni.navigateTo({ url: `/pagesSub/order/orderDetail?orderId=${orderId}` })
}

const switchTab = (key) => {
  if (activeTab.value === key) return
  activeTab.value = key
  page.value = 1
  hasMore.value = true
  reviewList.value = []
  fetchReviews()
}

// 将订单列表项展开为可评价的商品项
const flattenOrderItems = (orderList) => {
  const items = []
  orderList.forEach(order => {
    if (Array.isArray(order.itemList)) {
      order.itemList.forEach(item => {
        items.push({
          id: `${order.orderId}_${item.productId}`,
          orderId: order.orderId,
          orderSn: order.orderSn,
          orderTime: order.createTime || '',
          productId: item.productId,
          productName: item.productName || '',
          productImage: item.productImage || '',
          skuSpecs: item.skuSpecs || '',
          finalPrice: Number(item.finalPrice || item.price) || 0,
          quantity: Number(item.quantity) || 1
        })
      })
    }
  })
  return items
}

const fetchReviews = async (isRefresh = false) => {
  if (loading.value) return

  // "已评价"标签页:后端暂无评价列表接口,显示空状态
  if (activeTab.value === 'DONE') {
    reviewList.value = []
    hasMore.value = false
    loading.value = false
    refreshing.value = false
    return
  }

  loading.value = true

  try {
    // "待评价":获取已完成(COMPLETED)状态的订单
    const res = await orderHook.loadOrderList({
      status: 'COMPLETED',
      page: page.value,
      pageSize: pageSize.value
    })

    if (res && res.list) {
      const items = flattenOrderItems(res.list)
      if (isRefresh || page.value === 1) {
        reviewList.value = items
      } else {
        // 分页去重
        const existingIds = new Set(reviewList.value.map(item => item.id))
        const newItems = items.filter(item => !existingIds.has(item.id))
        reviewList.value = [...reviewList.value, ...newItems]
      }
      totalPages.value = res.pages || Math.ceil((res.total || 0) / pageSize.value)
      hasMore.value = page.value < totalPages.value
    } else {
      if (isRefresh || page.value === 1) {
        reviewList.value = []
      }
      hasMore.value = false
    }
  } catch (error) {
    console.error('获取评价列表失败:', error)
    if (isRefresh || page.value === 1) {
      reviewList.value = []
    }
    hasMore.value = false
  } finally {
    loading.value = false
    refreshing.value = false
  }
}

const onRefresh = () => {
  refreshing.value = true
  page.value = 1
  hasMore.value = true
  fetchReviews(true)
}

const onLoadMore = () => {
  if (loading.value || !hasMore.value) return
  page.value++
  fetchReviews()
}

const handleWriteReview = (item) => {
  uni.navigateTo({ url: `/pagesSub/goods/detail/reviewPublish?orderId=${item.orderId}&productId=${item.productId}` })
}

watch(activeTab, () => {
  page.value = 1
  hasMore.value = true
  reviewList.value = []
  fetchReviews()
})

let isFirstShow = true

onShow(() => {
  if (isFirstShow) {
    isFirstShow = false
    return
  }
  fetchReviews(true)
})

onMounted(() => {
  fetchReviews()
})
</script>

<style lang="scss" scoped>
.page-container {
  min-height: 100vh;
  background: $bg-page;
  display: flex;
  flex-direction: column;
}

.order-header {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  z-index: 100;
  display: flex;
  align-items: center;
  justify-content: space-between;
  height: 88rpx;
  padding: 0 32rpx;
  padding-top: calc(env(safe-area-inset-top));
  background: $bg-card;
  
  .header-left, .header-right {
    width: 80rpx;
    display: flex;
    align-items: center;
    justify-content: center;
  }
  
  .back-icon {
    font-size: 56rpx;
    color: $text-main;
  }
  
  .header-title {
    font-size: 36rpx;
    font-weight: 600;
    color: $text-main;
  }
}

.tabs-bar {
  position: fixed;
  top: calc(88rpx + env(safe-area-inset-top));
  left: 0;
  right: 0;
  z-index: 99;
  background: $bg-card;
  display: flex;
  padding: 0 32rpx;
  box-shadow: 0 2rpx 8rpx rgba(0, 0, 0, 0.04);
  
  .tab-item {
    flex: 1;
    display: flex;
    flex-direction: column;
    align-items: center;
    padding: 24rpx 0;
    position: relative;
    
    &.tab-active {
      .tab-text {
        color: $color-primary;
        font-weight: 600;
      }
    }
    
    .tab-text {
      font-size: 30rpx;
      color: $text-sub;
      transition: all 0.2s ease;
    }
    
    .tab-badge {
      min-width: 32rpx;
      height: 32rpx;
      padding: 0 8rpx;
      background: $color-primary-danger;
      border-radius: 16rpx;
      font-size: 20rpx;
      color: #FFFFFF;
      text-align: center;
      line-height: 32rpx;
      margin-left: 8rpx;
      margin-top: 4rpx;
      
      text {
        font-size: 20rpx;
      }
    }
    
    .tab-indicator {
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

.page-content {
  flex: 1;
  padding-top: calc(176rpx + env(safe-area-inset-top));
  padding-bottom: calc(100rpx + env(safe-area-inset-bottom));
}

.empty-review {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding-top: 300rpx;
  
  .empty-icon {
    width: 200rpx;
    height: 200rpx;
    display: flex;
    align-items: center;
    justify-content: center;
    margin-bottom: 32rpx;
    
    .empty-text {
      font-size: 120rpx;
    }
  }
  
  .empty-title {
    font-size: 36rpx;
    color: $text-main;
    font-weight: 500;
    margin-bottom: 16rpx;
  }
  
  .empty-desc {
    font-size: 26rpx;
    color: $text-weak;
    margin-bottom: 64rpx;
  }
  
  .empty-btn {
    padding: 24rpx 80rpx;
    background: linear-gradient(135deg, $color-primary 0%, $color-primary-danger 100%);
    border-radius: 48rpx;
    
    text {
      font-size: 30rpx;
      color: #FFFFFF;
      font-weight: 500;
    }
  }
}

.review-list {
  padding: 24rpx;
}

.review-card {
  background: $bg-card;
  border-radius: 24rpx;
  margin-bottom: 24rpx;
  overflow: hidden;
  box-shadow: $category-shadow-sm;
}

.review-header {
  display: flex;
  justify-content: space-between;
  padding: 24rpx;
  border-bottom: 1rpx solid $bg-page-light;
  
  .review-order-sn {
    font-size: 26rpx;
    color: $text-sub;
    font-family: monospace;
  }
  
  .review-time {
    font-size: 24rpx;
    color: $text-weak;
  }
}

.review-goods {
  display: flex;
  padding: 24rpx;
  
  .goods-image {
    width: 160rpx;
    height: 160rpx;
    border-radius: 16rpx;
    margin-right: 20rpx;
    background: $bg-page-light;
  }
  
  .goods-info {
    flex: 1;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    
    .goods-name {
      font-size: 28rpx;
      color: $text-main;
      line-height: 1.4;
      display: -webkit-box;
      -webkit-line-clamp: 2;
      line-clamp: 2;
      -webkit-box-orient: vertical;
      overflow: hidden;
      text-overflow: ellipsis;
    }
    
    .goods-spec {
      font-size: 24rpx;
      color: $text-weak;
      margin-top: 8rpx;
    }
    
    .goods-price {
      font-size: 30rpx;
      color: $color-primary-danger;
      font-weight: 600;
      margin-top: 12rpx;
    }
  }
}

.review-actions {
  display: flex;
  justify-content: flex-end;
  padding: 20rpx 24rpx;
  background: $bg-page-light;
  
  .action-btn {
    padding: 16rpx 48rpx;
    border-radius: 32rpx;
    
    &.primary-btn {
      background: linear-gradient(135deg, $color-primary 0%, $color-primary-danger 100%);
      
      text {
        font-size: 28rpx;
        color: #FFFFFF;
        font-weight: 500;
      }
    }
    
    &:active {
      transform: scale(0.96);
    }
  }
}

.review-content {
  padding: 24rpx;
  background: $bg-page-light;
  
  .review-stars {
    margin-bottom: 16rpx;
    
    .star {
      font-size: 36rpx;
      color: $color-warning;
    }
  }
  
  .review-text {
    font-size: 28rpx;
    color: $text-main;
    line-height: 1.6;
    display: block;
    margin-bottom: 16rpx;
  }
  
  .review-images {
    display: flex;
    gap: 12rpx;
    margin-bottom: 16rpx;
    
    .review-image {
      width: 160rpx;
      height: 160rpx;
      border-radius: 12rpx;
      background: $bg-page;
    }
  }
  
  .review-time-sm {
    font-size: 24rpx;
    color: $text-weak;
  }
}

.review-detail-btn {
  padding: 20rpx 24rpx;
  text-align: center;
  border-top: 1rpx solid $bg-page-light;
  
  text {
    font-size: 26rpx;
    color: $text-weak;
  }
}

.loading-more, .no-more {
  padding: 32rpx;
  text-align: center;
  
  .loading-text, .no-more-text {
    font-size: 26rpx;
    color: $text-weak;
  }
}
</style>