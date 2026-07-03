<template>
  <view class="page-container">
    <view class="order-header">
      <view class="header-left" @click="handleBack">
        <text class="back-icon">‹</text>
      </view>
      <text class="header-title">退款/售后</text>
      <view class="header-right"></view>
    </view>

    <view class="tabs-bar">
      <view class="tabs-inner">
        <view
          v-for="tab in statusTabs"
          :key="tab.value"
          class="tab-item"
          :class="{ 'tab-active': activeTab === tab.value }"
          @click="switchTab(tab.value)"
        >
          <text class="tab-text">{{ tab.label }}</text>
        </view>
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
      <view v-if="afterSaleList.length === 0 && !loading" class="empty-after-sale">
        <view class="empty-icon">
          <text class="empty-text">🔄</text>
        </view>
        <text class="empty-title">暂无售后申请</text>
        <text class="empty-desc">暂无售后申请，有问题可去订单页发起售后</text>
        <view class="empty-btn" @click="goOrderList">
          <text>查看订单</text>
        </view>
      </view>

      <view v-else class="after-sale-list">
        <view
          v-for="item in afterSaleList"
          :key="item.afterSaleId"
          class="after-sale-card"
          @click="goToDetail(item.afterSaleId)"
        >
          <view class="after-sale-header">
            <view class="after-sale-header-left">
              <text class="after-sale-sn">售后编号：{{ item.afterSaleId }}</text>
              <text class="order-sn">订单编号：{{ item.orderSn }}</text>
            </view>
            <text class="after-sale-status" :class="getStatusClass(item.status)">{{ item.statusText }}</text>
          </view>

          <view class="after-sale-goods">
            <image
              :src="getValidImageUrl(item.productImage)"
              class="goods-image"
              mode="aspectFill"
            />
            <view class="goods-info">
              <text class="goods-name">{{ item.productName }}</text>
              <view class="goods-meta">
                <text class="goods-type">{{ item.typeText }}</text>
                <view class="goods-amount">
                  <text class="amount-label">退款：</text>
                  <text class="amount-value">¥{{ formatPrice(item.refundAmount) }}</text>
                </view>
              </view>
            </view>
          </view>

          <view class="after-sale-footer">
            <text class="apply-time">{{ item.applyTime }}</text>
            <view class="after-sale-actions">
              <view class="action-btn" @click.stop="goToDetail(item.afterSaleId)">
                <text>查看详情</text>
              </view>
              <view
                v-if="item.status === 'APPLYING'"
                class="action-btn cancel-btn"
                @click.stop="handleCancel(item)"
              >
                <text>取消售后</text>
              </view>
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
  </view>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { onShow } from '@dcloudio/uni-app'
import { showToast, getValidImageUrl, formatPrice } from '@/utils/common'
import { getAfterSaleListApi, cancelAfterSaleApi } from '@/api/afterSale'

const activeTab = ref('ALL')
const afterSaleList = ref([])
const loading = ref(false)
const refreshing = ref(false)
const page = ref(1)
const pageSize = ref(10)
const hasMore = ref(true)

const statusTabs = ref([
  { label: '全部', value: 'ALL' },
  { label: '申请中', value: 'APPLYING' },
  { label: '已取消', value: 'CANCELLED' },
  { label: '已退款', value: 'REFUNDED' }
])

const getStatusClass = (status) => {
  const classMap = {
    APPLYING: 'status-applying',
    CANCELLED: 'status-cancelled',
    REFUNDED: 'status-refunded'
  }
  return classMap[status] || ''
}

const handleBack = () => {
  uni.navigateBack()
}

const goOrderList = () => {
  uni.navigateTo({ url: '/pagesSub/order/orderList' })
}

const goToDetail = (afterSaleId) => {
  if (!afterSaleId) {
    showToast('售后ID缺失')
    return
  }
  uni.navigateTo({ url: `/pagesSub/order/afterSale/afterSaleDetail?afterSaleId=${afterSaleId}` })
}

const switchTab = (value) => {
  if (activeTab.value === value) return
  activeTab.value = value
  page.value = 1
  hasMore.value = true
  afterSaleList.value = []
  fetchAfterSales()
}

const fetchAfterSales = async (isRefresh = false) => {
  if (loading.value) return

  loading.value = true

  try {
    const params = {
      status: activeTab.value,
      page: page.value,
      pageSize: pageSize.value
    }

    const response = await getAfterSaleListApi(params)

    if (response.code === 0) {
      const data = response.data || {}
      const list = Array.isArray(data.list) ? data.list : []

      if (isRefresh || page.value === 1) {
        afterSaleList.value = list
      } else {
        afterSaleList.value = [...afterSaleList.value, ...list]
      }

      const total = Number(data.total) || 0
      hasMore.value = list.length > 0 && afterSaleList.value.length < total
    } else {
      if (isRefresh || page.value === 1) {
        afterSaleList.value = []
      }
      hasMore.value = false
      showToast(response.message || '获取售后列表失败')
    }
  } catch (error) {
    if (isRefresh || page.value === 1) {
      afterSaleList.value = []
    }
    hasMore.value = false
    showToast(error?.message || '获取售后列表失败')
  } finally {
    loading.value = false
    refreshing.value = false
  }
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
    title: '取消售后',
    editable: true,
    placeholderText: '请输入取消原因',
    confirmText: '确认取消',
    cancelText: '再想想',
    success: async (res) => {
      if (!res.confirm) return

      const cancelReason = (res.content || '').trim()
      if (!cancelReason) {
        showToast('请输入取消原因')
        return
      }

      try {
        const response = await cancelAfterSaleApi(item.afterSaleId, { cancelReason })
        if (response.code === 0) {
          showToast('已取消售后', 'success')
          onRefresh()
        } else {
          showToast(response.message || '取消失败')
        }
      } catch (error) {
        if (error?.code === 40932) {
          uni.showModal({
            title: '提示',
            content: '当前状态不允许取消',
            showCancel: false,
            confirmText: '我知道了'
          })
        } else {
          showToast(error?.message || '取消失败')
        }
      }
    }
  })
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

.tabs-bar {
  position: fixed;
  top: calc(88rpx + env(safe-area-inset-top));
  left: 0;
  right: 0;
  z-index: 99;
  background: $bg-card;
  box-shadow: 0 2rpx 8rpx rgba(0, 0, 0, 0.04);

  .tabs-inner {
    display: flex;
    padding: 0 16rpx;
  }

  .tab-item {
    flex: 1;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 24rpx 0;
    position: relative;

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
  }
}

.page-content {
  flex: 1;
  width: 100%;
  box-sizing: border-box;
  padding-top: calc(176rpx + env(safe-area-inset-top));
  padding-bottom: calc(40rpx + env(safe-area-inset-bottom));
}

.empty-after-sale {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding-top: 240rpx;

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
    padding: 0 60rpx;
    text-align: center;
    line-height: 1.5;
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

    &:active {
      opacity: 0.9;
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

  &:active {
    opacity: 0.95;
  }
}

.after-sale-header {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  padding: 24rpx;
  border-bottom: 1rpx solid $bg-page-light;

  .after-sale-header-left {
    display: flex;
    flex-direction: column;
    gap: 8rpx;
    flex: 1;
    min-width: 0;
  }

  .after-sale-sn {
    font-size: 26rpx;
    color: $text-sub;
    font-family: monospace;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }

  .order-sn {
    font-size: 24rpx;
    color: $text-weak;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }

  .after-sale-status {
    font-size: 28rpx;
    font-weight: 500;
    flex-shrink: 0;
    margin-left: 16rpx;

    &.status-applying {
      color: $color-primary;
    }

    &.status-cancelled {
      color: $text-weak;
    }

    &.status-refunded {
      color: $color-success;
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
    flex-shrink: 0;
  }

  .goods-info {
    flex: 1;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    min-width: 0;

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

    .goods-meta {
      display: flex;
      align-items: center;
      justify-content: space-between;
      margin-top: 12rpx;

      .goods-type {
        font-size: 24rpx;
        color: $text-weak;
        padding: 4rpx 16rpx;
        background: $bg-page-light;
        border-radius: 8rpx;
      }

      .goods-amount {
        display: flex;
        align-items: baseline;

        .amount-label {
          font-size: 24rpx;
          color: $text-sub;
        }

        .amount-value {
          font-size: 32rpx;
          color: $color-primary-danger;
          font-weight: 600;
        }
      }
    }
  }
}

.after-sale-footer {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 20rpx 24rpx;
  background: $bg-page-light;

  .apply-time {
    font-size: 24rpx;
    color: $text-weak;
    flex: 1;
    min-width: 0;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }

  .after-sale-actions {
    display: flex;
    gap: 16rpx;
    flex-shrink: 0;

    .action-btn {
      padding: 12rpx 28rpx;
      border: 1rpx solid $gray-300;
      border-radius: 24rpx;
      background: $bg-card;

      text {
        font-size: 26rpx;
        color: $text-main;
      }

      &.cancel-btn {
        border-color: $gray-300;
        background: $bg-card;

        text {
          color: $text-weak;
        }
      }

      &:active {
        transform: scale(0.96);
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
