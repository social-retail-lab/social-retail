<template>
  <view class="page-container">
    <view class="order-header">
      <view class="header-left" @click="handleBack">
        <text class="back-icon">‹</text>
      </view>
      <text class="header-title">退款/售后</text>
      <view class="header-right"></view>
    </view>

    <scroll-view 
      scroll-y 
      class="page-content"
      :refresher-enabled="true"
      :refresher-triggered="refreshing"
      @refresherrefresh="onRefresh"
      @scrolltolower="onLoadMore"
    >
      <view v-if="afterSaleList.length === 0 && !loading" class="empty-after-sale">
        <view class="empty-icon">
          <text class="empty-text">🔄</text>
        </view>
        <text class="empty-title">暂无售后订单</text>
        <text class="empty-desc">如有售后需求，请在订单详情页申请</text>
        <view class="empty-btn" @click="goShopping">
          <text>去逛逛</text>
        </view>
      </view>

      <view v-else class="after-sale-list">
        <view v-for="item in afterSaleList" :key="item.id" class="after-sale-card">
          <view class="after-sale-header">
            <text class="after-sale-sn">售后编号：{{ item.sn }}</text>
            <text class="after-sale-status" :class="getStatusClass(item.status)">{{ getStatusText(item.status) }}</text>
          </view>

          <view class="after-sale-goods">
            <image :src="getValidImageUrl(item.productImage)" class="goods-image" mode="aspectFill" />
            <view class="goods-info">
              <text class="goods-name">{{ item.productName }}</text>
              <text class="goods-spec">{{ item.skuSpecs }}</text>
              <text class="goods-price">¥{{ item.finalPrice.toFixed(2) }}</text>
            </view>
          </view>

          <view class="after-sale-detail">
            <view class="detail-row">
              <text class="detail-label">申请类型</text>
              <text class="detail-value">{{ getTypeText(item.type) }}</text>
            </view>
            <view class="detail-row">
              <text class="detail-label">申请金额</text>
              <text class="detail-value amount">¥{{ item.amount.toFixed(2) }}</text>
            </view>
            <view class="detail-row">
              <text class="detail-label">申请原因</text>
              <text class="detail-value">{{ item.reason }}</text>
            </view>
            <view class="detail-row">
              <text class="detail-label">申请时间</text>
              <text class="detail-value">{{ item.createTime }}</text>
            </view>
            <view v-if="item.rejectReason" class="detail-row reject-row">
              <text class="detail-label">驳回原因</text>
              <text class="detail-value reject">{{ item.rejectReason }}</text>
            </view>
          </view>

          <view class="after-sale-actions">
            <view 
              v-if="item.status === 'PENDING'" 
              class="action-btn"
              @click="handleCancel(item)"
            >
              <text>取消申请</text>
            </view>
            <view 
              v-if="item.status === 'AGREED'" 
              class="action-btn primary-btn"
              @click="handleShip(item)"
            >
              <text>确认发货</text>
            </view>
            <view 
              v-if="item.status === 'SHIPPED'" 
              class="action-btn"
              @click="handleTrack(item)"
            >
              <text>查看物流</text>
            </view>
            <view 
              v-if="['COMPLETED', 'REJECTED'].includes(item.status)" 
              class="action-btn"
              @click="handleDetail(item)"
            >
              <text>查看详情</text>
            </view>
          </view>
        </view>

        <view v-if="loading" class="loading-more">
          <text class="loading-text">加载中...</text>
        </view>
        <view v-if="!loading && !hasMore && afterSaleList.length > 0" class="no-more">
          <text class="no-more-text">没有更多了</text>
        </view>
      </view>
    </scroll-view>

    <custom-tab-bar />
  </view>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { onShow } from '@dcloudio/uni-app'
import { showToast, getValidImageUrl } from '@/utils/common'
import CustomTabBar from '@/components/global/CustomTabBar.vue'

const afterSaleList = ref([])
const loading = ref(false)
const refreshing = ref(false)
const page = ref(1)
const pageSize = ref(20)
const hasMore = ref(true)

const statusMap = {
  PENDING: '待审核',
  AGREED: '待发货',
  SHIPPED: '待收货',
  COMPLETED: '已完成',
  REJECTED: '已驳回'
}

const typeMap = {
  REFUND: '仅退款',
  RETURN: '退货退款',
  EXCHANGE: '换货'
}

const handleBack = () => {
  uni.navigateBack()
}

const goShopping = () => {
  uni.switchTab({ url: '/pages/index/index' })
}

const getStatusText = (status) => {
  return statusMap[status] || status
}

const getStatusClass = (status) => {
  const classMap = {
    PENDING: 'status-pending',
    AGREED: 'status-agreed',
    SHIPPED: 'status-shipped',
    COMPLETED: 'status-completed',
    REJECTED: 'status-rejected'
  }
  return classMap[status] || ''
}

const getTypeText = (type) => {
  return typeMap[type] || type
}

const fetchAfterSales = async (isRefresh = false) => {
  if (loading.value) return
  
  loading.value = true
  
  const mockData = [
    {
      id: 1,
      sn: 'AFS202607031530001',
      orderId: 13,
      status: 'PENDING',
      type: 'REFUND',
      productId: 6001,
      productName: '新疆阿克苏冰糖心苹果 5斤装',
      productImage: 'http://172.20.10.11:8081/uploads/temp/upload/E8C8E3A43B7AA5723A3DFF4BA8FE9D70.jpg',
      skuSpecs: '规格：5斤装，果径：80-85mm',
      finalPrice: 39.90,
      amount: 39.90,
      reason: '商品质量问题',
      createTime: '2026-07-03 15:30'
    },
    {
      id: 2,
      sn: 'AFS202607021120002',
      orderId: 10,
      status: 'AGREED',
      type: 'RETURN',
      productId: 6003,
      productName: '智利车厘子 2斤装',
      productImage: 'https://cdn.example.com/product/cherry.jpg',
      skuSpecs: '规格：2斤装，果径：JJ级',
      finalPrice: 128.00,
      amount: 128.00,
      reason: '商品与描述不符',
      createTime: '2026-07-02 11:20'
    },
    {
      id: 3,
      sn: 'AFS202606300910003',
      orderId: 8,
      status: 'COMPLETED',
      type: 'REFUND',
      productId: 6002,
      productName: '云南褚橙 10斤装',
      productImage: 'https://cdn.example.com/product/main_02.jpg',
      skuSpecs: '规格：10斤装，等级：特级果',
      finalPrice: 85.00,
      amount: 85.00,
      reason: '拍多了',
      createTime: '2026-06-30 09:10'
    },
    {
      id: 4,
      sn: 'AFS202606281400004',
      orderId: 6,
      status: 'REJECTED',
      type: 'RETURN',
      productId: 6004,
      productName: '泰国金枕头榴莲 3斤装',
      productImage: 'https://cdn.example.com/product/durian.jpg',
      skuSpecs: '规格：3斤装，成熟度：8成熟',
      finalPrice: 199.00,
      amount: 199.00,
      reason: '商品不好吃',
      rejectReason: '口感问题不属于售后范围',
      createTime: '2026-06-28 14:00'
    }
  ]
  
  setTimeout(() => {
    if (isRefresh || page.value === 1) {
      afterSaleList.value = mockData
    } else {
      afterSaleList.value = [...afterSaleList.value, ...mockData]
    }
    
    hasMore.value = afterSaleList.value.length < 10
    loading.value = false
    refreshing.value = false
  }, 800)
}

const onRefresh = () => {
  refreshing.value = true
  page.value = 1
  hasMore.value = true
  fetchAfterSales(true)
}

const onLoadMore = () => {
  if (loading.value || !hasMore.value) return
  page.value++
  fetchAfterSales()
}

const handleCancel = (item) => {
  uni.showModal({
    title: '确认取消',
    content: '确定要取消此售后申请吗？',
    success: (res) => {
      if (res.confirm) {
        showToast('已取消')
        fetchAfterSales(true)
      }
    }
  })
}

const handleShip = (item) => {
  uni.showModal({
    title: '确认发货',
    content: '请确认已将商品寄回商家',
    success: (res) => {
      if (res.confirm) {
        showToast('已确认发货')
        fetchAfterSales(true)
      }
    }
  })
}

const handleTrack = (item) => {
  showToast('物流跟踪功能开发中')
}

const handleDetail = (item) => {
  uni.navigateTo({ url: `/pagesSub/order/afterSale/afterSaleDetail?id=${item.id}` })
}

let isFirstShow = true

onShow(() => {
  if (isFirstShow) {
    isFirstShow = false
    return
  }
  fetchAfterSales(true)
})

onMounted(() => {
  fetchAfterSales()
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

.page-content {
  flex: 1;
  padding-top: calc(88rpx + env(safe-area-inset-top));
  padding-bottom: calc(100rpx + env(safe-area-inset-bottom));
}

.empty-after-sale {
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

.after-sale-list {
  padding: 24rpx;
}

.after-sale-card {
  background: $bg-card;
  border-radius: 24rpx;
  margin-bottom: 24rpx;
  overflow: hidden;
  box-shadow: $category-shadow-sm;
}

.after-sale-header {
  display: flex;
  justify-content: space-between;
  padding: 24rpx;
  border-bottom: 1rpx solid $bg-page-light;
  
  .after-sale-sn {
    font-size: 26rpx;
    color: $text-sub;
    font-family: monospace;
  }
  
  .after-sale-status {
    font-size: 28rpx;
    font-weight: 500;
    
    &.status-pending {
      color: $color-primary;
    }
    
    &.status-agreed {
      color: $color-success;
    }
    
    &.status-shipped {
      color: $color-warning;
    }
    
    &.status-completed {
      color: $text-weak;
    }
    
    &.status-rejected {
      color: $color-primary-danger;
    }
  }
}

.after-sale-goods {
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

.after-sale-detail {
  padding: 0 24rpx;
  
  .detail-row {
    display: flex;
    justify-content: space-between;
    padding: 16rpx 0;
    
    &:not(:last-child) {
      border-bottom: 1rpx solid $bg-page-light;
    }
    
    &.reject-row {
      background: rgba(255, 77, 79, 0.05);
      margin: 0 -24rpx;
      padding: 16rpx 24rpx;
      
      .detail-value.reject {
        color: $color-primary-danger;
      }
    }
    
    .detail-label {
      font-size: 26rpx;
      color: $text-sub;
    }
    
    .detail-value {
      font-size: 26rpx;
      color: $text-main;
      
      &.amount {
        color: $color-primary-danger;
        font-weight: 600;
      }
    }
  }
}

.after-sale-actions {
  display: flex;
  justify-content: flex-end;
  gap: 16rpx;
  padding: 20rpx 24rpx;
  background: $bg-page-light;
  
  .action-btn {
    padding: 16rpx 36rpx;
    border: 1rpx solid $gray-300;
    border-radius: 32rpx;
    
    text {
      font-size: 26rpx;
      color: $text-main;
    }
    
    &.primary-btn {
      background: linear-gradient(135deg, $color-primary 0%, $color-primary-danger 100%);
      border-color: transparent;
      
      text {
        color: #FFFFFF;
        font-weight: 500;
      }
    }
    
    &:active {
      transform: scale(0.96);
    }
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