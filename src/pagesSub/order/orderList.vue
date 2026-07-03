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
            v-for="tab in statusTabs"
            :key="tab.value"
            class="tab-item"
            :class="{ 'tab-active': activeTab === tab.value }"
            @click="switchTab(tab.value)"
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
        <view
          v-for="order in orderList"
          :key="order.orderId"
          class="order-card"
          @click="goToDetail(order.orderId)"
        >
          <view class="order-header-info">
            <view class="order-header-left">
              <text class="order-sn">订单号：{{ order.orderSn }}</text>
              <text class="order-time">下单时间：{{ order.createTime }}</text>
            </view>
            <text class="order-status" :class="getStatusClass(order.status)">{{ order.statusText }}</text>
          </view>

          <view class="order-goods">
            <view class="goods-thumbnails">
              <view
                v-for="(item, index) in order.itemList.slice(0, 3)"
                :key="index"
                class="thumbnail-item"
              >
                <image
                  :src="getValidImageUrl(item.productImage)"
                  class="thumbnail-image"
                  mode="aspectFill"
                />
                <view v-if="index === 2 && order.itemList.length > 3" class="thumbnail-more">
                  <text>+{{ order.itemList.length - 3 }}</text>
                </view>
              </view>
            </view>
            <view class="goods-summary">
              <text class="summary-text">共计 {{ getTotalQuantity(order) }} 件商品</text>
            </view>
          </view>

          <view class="order-footer">
            <view class="order-total">
              <text class="total-label">实付：</text>
              <text class="total-price">¥{{ formatPrice(order.payAmount) }}</text>
            </view>
            <view class="order-actions">
              <view
                v-if="order.status === 'WAIT_PAY'"
                class="action-btn primary-btn"
                @click.stop="handlePay(order)"
              >
                <text>去支付</text>
              </view>
              <view
                v-if="order.status === 'WAIT_PAY'"
                class="action-btn"
                @click.stop="handleCancel"
              >
                <text>取消订单</text>
              </view>
              <view
                v-if="order.status === 'IN_PROGRESS'"
                class="action-btn primary-btn"
                @click.stop="handleConfirm(order)"
              >
                <text>确认收货</text>
              </view>
              <view
                v-if="['COMPLETED', 'CANCELLED', 'CLOSED'].includes(order.status)"
                class="action-btn"
                @click.stop="handleDelete(order)"
              >
                <text>删除订单</text>
              </view>
            </view>
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
import { ref, onMounted } from 'vue'
import { onShow } from '@dcloudio/uni-app'
import { getValidImageUrl, formatPrice } from '@/utils/common'
import { useOrder } from '@/hooks/useOrder'
import CustomTabBar from '@/components/global/CustomTabBar.vue'

const orderHook = useOrder()

const activeTab = ref('ALL')
const orderList = ref([])
const loading = ref(false)
const refreshing = ref(false)
const page = ref(1)
const pageSize = ref(10)
const hasMore = ref(true)

const statusTabs = ref([
  { label: '全部', value: 'ALL', badge: 0 },
  { label: '待支付', value: 'WAIT_PAY', badge: 0 },
  { label: '待发货', value: 'WAIT_ACCEPT', badge: 0 },
  { label: '待收货', value: 'IN_PROGRESS', badge: 0 },
  { label: '已完成', value: 'COMPLETED', badge: 0 },
  { label: '已取消', value: 'CANCELLED', badge: 0 }  // 包含 CANCELLED 和 CLOSED
])

const getStatusClass = (status) => {
  const classMap = {
    'WAIT_PAY': 'status-wait-pay',
    'WAIT_ACCEPT': 'status-wait-accept',
    'IN_PROGRESS': 'status-in-progress',
    'COMPLETED': 'status-completed',
    'CANCELLED': 'status-cancelled',
    'CLOSED': 'status-closed'
  }
  return classMap[status] || ''
}

const getTotalQuantity = (order) => {
  if (order.totalQuantity) return order.totalQuantity
  return (order.itemList || []).reduce((sum, item) => sum + (item.quantity || 0), 0)
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

const switchTab = (value) => {
  if (activeTab.value === value) return
  activeTab.value = value
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

  const data = await orderHook.loadOrderList(params)

  if (data) {
    let list = data.list || []
    // 不做客户端过滤，信任后端按status筛选返回的数据

    if (isRefresh || page.value === 1) {
      orderList.value = list
    } else {
      orderList.value = [...orderList.value, ...list]
    }

    const total = data.total || 0
    hasMore.value = list.length > 0 && orderList.value.length < total

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
  statusTabs.value.forEach(tab => {
    if (tab.value === 'ALL') {
      tab.badge = Object.values(badgeCounts).reduce((sum, count) => sum + count, 0) || 0
    } else if (tab.value === 'CANCELLED') {
      tab.badge = (badgeCounts['CANCELLED'] || 0) + (badgeCounts['CLOSED'] || 0)
    } else {
      tab.badge = badgeCounts[tab.value] || 0
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
  const expireTime = order.expireTime || ''
  uni.navigateTo({
    url: `/pagesSub/order/pay/payOrder?orderId=${order.orderId}&payAmount=${order.payAmount}&expireTime=${expireTime}`
  })
}

const handleCancel = async (order) => {
  const success = await orderHook.cancelOrder(order.orderId)
  if (success) {
    fetchOrders(true)
  }
}

const handleConfirm = async (order) => {
  const success = await orderHook.confirmOrder(order.orderId)
  if (success) {
    fetchOrders(true)
  }
}

const handleDelete = async (order) => {
  const success = await orderHook.deleteOrder(order.orderId)
  if (success) {
    fetchOrders(true)
  }
}

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
    const validStatuses = ['WAIT_PAY', 'WAIT_ACCEPT', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED', 'CLOSED']
    if (validStatuses.includes(status)) {
      // CLOSED 归入已取消tab
      activeTab.value = status === 'CLOSED' ? 'CANCELLED' : status
    }
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

  &:active {
    opacity: 0.95;
  }
}

.order-header-info {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  padding: 24rpx;
  border-bottom: 1rpx solid $bg-page-light;

  .order-header-left {
    display: flex;
    flex-direction: column;
    gap: 8rpx;
    flex: 1;
    min-width: 0;
  }

  .order-sn {
    font-size: 26rpx;
    color: $text-sub;
    font-family: monospace;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }

  .order-time {
    font-size: 24rpx;
    color: $text-weak;
  }

  .order-status {
    font-size: 28rpx;
    font-weight: 500;
    flex-shrink: 0;
    margin-left: 16rpx;

    &.status-wait-pay {
      color: $color-primary-danger;
    }

    &.status-wait-accept {
      color: $color-primary;
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
  padding: 24rpx;

  .goods-thumbnails {
    display: flex;
    gap: 16rpx;
  }

  .thumbnail-item {
    position: relative;
    width: 160rpx;
    height: 160rpx;
    flex-shrink: 0;

    .thumbnail-image {
      width: 100%;
      height: 100%;
      border-radius: 16rpx;
      background: $bg-page-light;
    }

    .thumbnail-more {
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;
      background: rgba(0, 0, 0, 0.5);
      border-radius: 16rpx;
      display: flex;
      align-items: center;
      justify-content: center;

      text {
        color: #FFFFFF;
        font-size: 32rpx;
        font-weight: 600;
      }
    }
  }

  .goods-summary {
    margin-top: 20rpx;

    .summary-text {
      font-size: 26rpx;
      color: $text-sub;
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

.loading-more, .no-more {
  padding: 32rpx;
  text-align: center;

  .loading-text, .no-more-text {
    font-size: 26rpx;
    color: $text-weak;
  }
}
</style>
