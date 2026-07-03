<template>
  <view class="page-container">
    <view class="order-header">
      <view class="header-left" @click="handleBack">
        <text class="back-icon">‹</text>
      </view>
      <text class="header-title">我的订单</text>
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
      <scroll-view scroll-x class="tabs-bar" :show-scrollbar="false">
        <view class="tabs-inner">
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
          </view>
        </view>
      </scroll-view>

      <view v-if="orderList.length === 0 && !loading" class="empty-order">
        <view class="empty-icon">
          <text class="empty-text">📦</text>
        </view>
        <text class="empty-title">暂无订单</text>
        <text class="empty-desc">快去挑选心仪的商品吧</text>
        <view class="empty-btn" @click="goShopping">
          <text>去逛逛</text>
        </view>
      </view>

      <view v-else class="order-list">
        <view v-for="order in orderList" :key="order.orderId" class="order-card">
          <view class="order-header-info">
            <text class="order-sn">订单号：{{ order.orderSn }}</text>
            <text class="order-status" :class="getStatusClass(order.status)">{{ order.statusText }}</text>
          </view>

          <view class="order-goods" @click="goToDetail(order.orderId)">
            <view v-for="(item, index) in order.itemList" :key="index" class="goods-row">
              <image :src="getValidImageUrl(item.productImage)" class="goods-image" mode="aspectFill" />
              <view class="goods-info">
                <text class="goods-name">{{ item.productName }}</text>
                <text class="goods-sku">{{ item.skuSpecs }}</text>
                <view class="goods-bottom">
                  <text class="goods-price">¥{{ item.price.toFixed(2) }}</text>
                  <text class="goods-count">×{{ item.quantity }}</text>
                </view>
              </view>
            </view>
          </view>

          <view class="order-footer">
            <view class="order-total">
              <text class="total-label">共{{ order.itemList.reduce((sum, item) => sum + item.quantity, 0) }}件商品</text>
              <text class="total-price">合计：¥{{ order.payAmount.toFixed(2) }}</text>
            </view>
            <view class="order-actions">
              <view 
                v-if="order.status === 'WAIT_PAY'" 
                class="action-btn primary-btn"
                @click="handlePay(order)"
              >
                <text>去支付</text>
              </view>
              <view 
                v-if="['WAIT_PAY', 'WAIT_ACCEPT'].includes(order.status)" 
                class="action-btn"
                @click="handleCancel(order)"
              >
                <text>取消订单</text>
              </view>
              <view 
                v-if="order.status === 'ACCEPTED'" 
                class="action-btn"
                @click="handleRemind(order)"
              >
                <text>催发货</text>
              </view>
              <view 
                v-if="order.status === 'IN_PROGRESS'" 
                class="action-btn primary-btn"
                @click="handleConfirm(order)"
              >
                <text>确认收货</text>
              </view>
              <view 
                v-if="['COMPLETED', 'CANCELLED', 'CLOSED'].includes(order.status)" 
                class="action-btn"
                @click="handleDelete(order)"
              >
                <text>删除订单</text>
              </view>
            </view>
          </view>

          <view 
            class="order-detail-btn" 
            @click="goToDetail(order.orderId)"
          >
            <text>查看详情 ›</text>
          </view>
        </view>

        <view v-if="loading" class="loading-more">
          <text class="loading-text">加载中...</text>
        </view>
        <view v-if="!loading && !hasMore && orderList.length > 0" class="no-more">
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
import { useOrder } from '@/hooks/useOrder'
import CustomTabBar from '@/components/global/CustomTabBar.vue'

const activeTab = ref('ALL')
const orderList = ref([])
const loading = ref(false)
const refreshing = ref(false)
const page = ref(1)
const pageSize = ref(20)
const hasMore = ref(true)

const { loadOrderList, cancelOrder, deleteOrder, confirmOrder } = useOrder()

const tabs = [
  { key: 'ALL', label: '全部', badge: 0 },
  { key: 'WAIT_PAY', label: '待支付', badge: 0 },
  { key: 'WAIT_ACCEPT', label: '待接单', badge: 0 },
  { key: 'ACCEPTED', label: '待发货', badge: 0 },
  { key: 'IN_PROGRESS', label: '待收货', badge: 0 },
  { key: 'COMPLETED', label: '已完成', badge: 0 },
  { key: 'CANCELLED', label: '已取消', badge: 0 }
]

const getStatusClass = (status) => {
  const classMap = {
    'WAIT_PAY': 'status-wait-pay',
    'WAIT_ACCEPT': 'status-wait-accept',
    'ACCEPTED': 'status-accepted',
    'IN_PROGRESS': 'status-in-progress',
    'COMPLETED': 'status-completed',
    'CANCELLED': 'status-cancelled',
    'CLOSED': 'status-closed'
  }
  return classMap[status] || ''
}

const handleBack = () => {
  uni.switchTab({ url: '/pages/mine/mine' })
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
  orderList.value = []
  fetchOrders()
}

const fetchOrders = async (isRefresh = false) => {
  if (loading.value) return
  
  loading.value = true
  
  const params = {
    status: activeTab.value === 'ALL' ? undefined : activeTab.value,
    page: page.value,
    pageSize: pageSize.value
  }
  
  const data = await loadOrderList(params)
  
  if (data) {
    if (isRefresh || page.value === 1) {
      orderList.value = data.list || []
    } else {
      orderList.value = [...orderList.value, ...(data.list || [])]
    }
    
    const total = data.total || 0
    hasMore.value = orderList.value.length < total
    
    if (data.badgeCounts) {
      updateBadgeCounts(data.badgeCounts)
    }
  } else {
    if (isRefresh || page.value === 1) {
      orderList.value = []
    }
    hasMore.value = false
  }
  
  loading.value = false
  refreshing.value = false
}

const updateBadgeCounts = (badgeCounts) => {
  tabs.forEach(tab => {
    if (tab.key === 'ALL') {
      tab.badge = Object.values(badgeCounts).reduce((sum, count) => sum + count, 0) || 0
    } else {
      tab.badge = badgeCounts[tab.key] || 0
    }
  })
}

const onRefresh = () => {
  refreshing.value = true
  page.value = 1
  hasMore.value = true
  fetchOrders(true)
}

const onLoadMore = () => {
  if (loading.value || !hasMore.value) return
  page.value++
  fetchOrders()
}

const handlePay = (order) => {
  uni.navigateTo({ 
    url: `/pagesSub/order/pay/payOrder?orderId=${order.orderId}&orderSn=${order.orderSn}&payAmount=${order.payAmount}` 
  })
}

const handleCancel = async (order) => {
  const success = await cancelOrder(order.orderId)
  if (success) {
    fetchOrders(true)
  }
}

const handleRemind = () => {
  showToast('已提醒商家发货')
}

const handleConfirm = async (order) => {
  const success = await confirmOrder(order.orderId)
  if (success) {
    fetchOrders(true)
  }
}

const handleDelete = async (order) => {
  const success = await deleteOrder(order.orderId)
  if (success) {
    fetchOrders(true)
  }
}

watch(activeTab, () => {
  page.value = 1
  hasMore.value = true
  orderList.value = []
  fetchOrders()
})

let isFirstShow = true

onShow(() => {
  if (isFirstShow) {
    isFirstShow = false
    return
  }
  fetchOrders(true)
})

onMounted(() => {
  const pages = getCurrentPages()
  const currentPage = pages[pages.length - 1]
  const status = currentPage.options?.status
  
  if (status) {
    const statusMap = {
      'WAIT_PAY': 'WAIT_PAY',
      'WAIT_ACCEPT': 'WAIT_ACCEPT',
      'ACCEPTED': 'ACCEPTED',
      'IN_PROGRESS': 'IN_PROGRESS',
      'COMPLETED': 'COMPLETED',
      'CANCELLED': 'CANCELLED',
      'CLOSED': 'CLOSED'
    }
    activeTab.value = statusMap[status] || 'ALL'
  }
  
  fetchOrders()
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
  width: 100%;
  box-sizing: border-box;
  padding-top: calc(88rpx + env(safe-area-inset-top));
  padding-bottom: calc(100rpx + env(safe-area-inset-bottom));
}

.tabs-bar {
  position: fixed;
  top: calc(88rpx + env(safe-area-inset-top));
  left: 0;
  right: 0;
  z-index: 99;
  background: $bg-card;
  box-shadow: 0 2rpx 8rpx rgba(0, 0, 0, 0.04);
  white-space: nowrap;
  
  .tabs-inner {
    display: inline-flex;
    padding: 0 16rpx;
  }
  
  .tab-item {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    padding: 24rpx 28rpx;
    position: relative;
    flex-shrink: 0;
    
    &.tab-active {
      .tab-text {
        color: $color-primary;
        font-weight: 600;
      }
      
      &::after {
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
    
    .tab-text {
      font-size: 28rpx;
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
      
      text {
        font-size: 20rpx;
      }
    }
  }
}

.empty-order {
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

.order-list {
  padding: calc(88rpx + env(safe-area-inset-top)) 24rpx 24rpx;
}

.order-card {
  background: $bg-card;
  border-radius: 24rpx;
  margin-bottom: 24rpx;
  overflow: hidden;
  box-shadow: $category-shadow-sm;
}

.order-header-info {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 24rpx;
  border-bottom: 1rpx solid $bg-page-light;
  
  .order-sn {
    font-size: 26rpx;
    color: $text-sub;
    font-family: monospace;
  }
  
  .order-status {
    font-size: 28rpx;
    font-weight: 500;
    
    &.status-wait-pay {
      color: $color-primary-danger;
    }
    
    &.status-wait-accept {
      color: $color-primary;
    }
    
    &.status-accepted {
      color: $color-warning;
    }
    
    &.status-in-progress {
      color: $color-success;
    }
    
    &.status-completed {
      color: $text-weak;
    }
    
    &.status-cancelled, &.status-closed {
      color: $text-weak;
      text-decoration: line-through;
    }
  }
}

.order-goods {
  padding: 16rpx 24rpx;
}

.goods-row {
  display: flex;
  padding: 16rpx 0;
  border-bottom: 1rpx solid $bg-page-light;
  
  &:last-child {
    border-bottom: none;
  }
  
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
      font-size: 26rpx;
      color: $text-main;
      line-height: 1.4;
      display: -webkit-box;
      -webkit-line-clamp: 2;
      line-clamp: 2;
      -webkit-box-orient: vertical;
      overflow: hidden;
      text-overflow: ellipsis;
    }
    
    .goods-sku {
      font-size: 22rpx;
      color: $text-weak;
      margin-top: 8rpx;
    }
    
    .goods-bottom {
      display: flex;
      align-items: center;
      justify-content: space-between;
      margin-top: 16rpx;
      
      .goods-price {
        font-size: 28rpx;
        color: $color-primary-danger;
        font-weight: 600;
      }
      
      .goods-count {
        font-size: 24rpx;
        color: $text-sub;
      }
    }
  }
}

.order-footer {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 20rpx 24rpx;
  background: $bg-page-light;
  
  .order-total {
    display: flex;
    align-items: baseline;
    gap: 16rpx;
    
    .total-label {
      font-size: 26rpx;
      color: $text-sub;
    }
    
    .total-price {
      font-size: 32rpx;
      color: $color-primary-danger;
      font-weight: 600;
    }
  }
  
  .order-actions {
    display: flex;
    gap: 16rpx;
    
    .action-btn {
      padding: 12rpx 28rpx;
      border: 1rpx solid $gray-300;
      border-radius: 24rpx;
      
      text {
        font-size: 26rpx;
        color: $text-main;
      }
      
      &.primary-btn {
        background: $color-primary;
        border-color: $color-primary;
        
        text {
          color: #FFFFFF;
        }
      }
    }
  }
}

.order-detail-btn {
  padding: 20rpx 24rpx;
  text-align: center;
  
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