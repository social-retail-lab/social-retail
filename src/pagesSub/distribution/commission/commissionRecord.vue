<template>
  <view class="page-record">
    <!-- 自定义导航栏 -->
    <view class="nav-bar" :style="{ paddingTop: statusBarHeight + 'px' }">
      <view class="nav-back" @click="handleBack">
        <text class="back-icon">‹</text>
      </view>
      <text class="nav-title">佣金明细</text>
      <view class="nav-placeholder-right"></view>
    </view>
    <view class="nav-placeholder" :style="{ height: (statusBarHeight + 44) + 'px' }"></view>

    <!-- 佣金概览卡片 -->
    <view class="overview-card" v-if="dashboardData">
      <view class="overview-bg"></view>
      <view class="overview-content">
        <view class="overview-item">
          <text class="overview-label">累计佣金</text>
          <text class="overview-value">¥{{ formatMoney(dashboardData.totalCommission) }}</text>
        </view>
        <view class="overview-divider"></view>
        <view class="overview-item">
          <text class="overview-label">可提现</text>
          <text class="overview-value green">¥{{ formatMoney(dashboardData.availableCommission) }}</text>
        </view>
        <view class="overview-divider"></view>
        <view class="overview-item">
          <text class="overview-label">冻结中</text>
          <text class="overview-value orange">¥{{ formatMoney(dashboardData.frozenCommission) }}</text>
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

    <!-- 佣金记录列表 -->
    <scroll-view
      scroll-y
      class="record-scroll"
      :refresher-enabled="true"
      :refresher-triggered="refreshing"
      @refresherrefresh="onRefresh"
      @scrolltolower="onLoadMore"
    >
      <!-- 加载中（首次） -->
      <view v-if="distributorStore.commissionRecordsLoading && recordList.length === 0" class="loading-state">
        <view class="loading-spinner"></view>
        <text class="loading-text">加载中...</text>
      </view>

      <!-- 空状态 -->
      <view v-else-if="recordList.length === 0" class="empty-state">
        <text class="empty-icon">💰</text>
        <text class="empty-title">暂无佣金记录</text>
        <text class="empty-desc">推广商品产生订单后会产生佣金</text>
      </view>

      <!-- 记录列表 -->
      <view v-else class="record-list">
        <view
          v-for="item in recordList"
          :key="item.recordId"
          class="record-card"
        >
          <view class="record-header">
            <view class="record-id">
              <text class="id-label">订单号</text>
              <text class="id-value">{{ item.orderId }}</text>
            </view>
            <view
              class="status-badge"
              :style="getStatusStyle(item.status)"
            >
              <text class="status-text">{{ getStatusText(item.status) }}</text>
            </view>
          </view>

          <view class="record-body">
            <view class="amount-row">
              <text class="amount-label">佣金金额</text>
              <text class="amount-value" :class="{ 'amount-settled': item.status === 1 }">
                +¥{{ formatMoney(item.commissionAmount) }}
              </text>
            </view>
            <view class="time-row">
              <view class="time-block">
                <text class="time-label">创建时间</text>
                <text class="time-value">{{ item.createTime || '-' }}</text>
              </view>
              <view class="time-block" v-if="item.settlementTime">
                <text class="time-label">结算时间</text>
                <text class="time-value">{{ item.settlementTime }}</text>
              </view>
            </view>
          </view>
        </view>

        <!-- 加载更多 -->
        <view v-if="recordList.length > 0" class="load-more">
          <text v-if="distributorStore.commissionRecordsLoading" class="load-more-text">加载中...</text>
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
import { onShow } from '@dcloudio/uni-app'
import { useDistributor } from '@/hooks/useDistributor'

const statusBarHeight = uni.getSystemInfoSync().statusBarHeight || 20

const {
  distributorStore,
  loadCommissionDetail,
  switchCommissionRecordStatus,
  loadDashboard,
  COMMISSION_STATUS_TABS,
  COMMISSION_STATUS_MAP,
  formatMoney
} = useDistributor()

// 本地状态
const refreshing = ref(false)
const currentStatus = ref('')

// 工作台数据（用于顶部概览）
const dashboardData = computed(() => distributorStore.dashboardData)

// 记录列表
const recordList = computed(() => distributorStore.commissionRecords)
const hasMore = computed(() => distributorStore.commissionRecordsPage < distributorStore.commissionRecordsPages)

// 状态样式
const getStatusStyle = (status) => {
  const info = COMMISSION_STATUS_MAP[status]
  if (!info) return {}
  return {
    color: info.color,
    backgroundColor: info.bgColor
  }
}

// 状态文案
const getStatusText = (status) => {
  return COMMISSION_STATUS_MAP[status]?.label || '未知'
}

const handleBack = () => {
  uni.navigateBack({
    delta: 1,
    animationType: 'slide-out-right',
    animationDuration: 200
  })
}

// 状态筛选切换
const handleTabChange = (status) => {
  currentStatus.value = status
  switchCommissionRecordStatus(status)
}

// 下拉刷新
const onRefresh = async () => {
  refreshing.value = true
  await Promise.all([
    loadCommissionDetail(false),
    loadDashboard()
  ])
  refreshing.value = false
}

// 上拉加载更多
const onLoadMore = () => {
  if (hasMore.value && !distributorStore.commissionRecordsLoading) {
    loadCommissionDetail(true)
  }
}

onShow(() => {
  loadCommissionDetail(false)
  // 若工作台数据为空，同步加载
  if (!dashboardData.value) {
    loadDashboard()
  }
})
</script>

<style lang="scss" scoped>
.page-record {
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

// ============ 概览卡片 ============
.overview-card {
  position: relative;
  margin: 16rpx 24rpx;
  border-radius: 20rpx;
  overflow: hidden;

  .overview-bg {
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: linear-gradient(135deg, #FF6A00 0%, #FF9248 100%);
  }

  .overview-content {
    position: relative;
    display: flex;
    align-items: center;
    padding: 32rpx 24rpx;
    z-index: 1;
  }

  .overview-item {
    flex: 1;
    display: flex;
    flex-direction: column;
    align-items: center;

    .overview-label {
      font-size: 24rpx;
      color: rgba(255, 255, 255, 0.85);
      margin-bottom: 8rpx;
    }

    .overview-value {
      font-size: 34rpx;
      color: #FFFFFF;
      font-weight: 600;

      &.green { color: #FFFFFF; }
      &.orange { color: #FFFFFF; opacity: 0.9; }
    }
  }

  .overview-divider {
    width: 1rpx;
    height: 56rpx;
    background: rgba(255, 255, 255, 0.3);
  }
}

// ============ 状态筛选 Tab ============
.status-tabs {
  display: flex;
  background: $bg-card;
  padding: 16rpx 24rpx;
  margin: 0 24rpx;
  border-radius: 16rpx;

  .status-tab {
    flex: 1;
    height: 60rpx;
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: 30rpx;
    transition: all 0.2s ease;

    .tab-text {
      font-size: 26rpx;
      color: $text-sub;
    }

    &.status-tab-active {
      background: $color-primary;

      .tab-text {
        color: #FFFFFF;
        font-weight: 600;
      }
    }
  }
}

// ============ 记录列表 ============
.record-scroll {
  flex: 1;
  padding: 16rpx 24rpx;
  box-sizing: border-box;
}

.record-list {
  display: flex;
  flex-direction: column;
  gap: 16rpx;
}

.record-card {
  background: $bg-card;
  border-radius: 20rpx;
  padding: 24rpx;
  box-shadow: 0 4rpx 16rpx rgba(0, 0, 0, 0.04);
}

.record-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-bottom: 16rpx;
  border-bottom: 1rpx solid rgba(0, 0, 0, 0.04);

  .record-id {
    display: flex;
    align-items: center;

    .id-label {
      font-size: 24rpx;
      color: $text-weak;
      margin-right: 8rpx;
    }

    .id-value {
      font-size: 26rpx;
      color: $text-sub;
      font-weight: 500;
    }
  }

  .status-badge {
    padding: 6rpx 16rpx;
    border-radius: 8rpx;

    .status-text {
      font-size: 22rpx;
      font-weight: 500;
    }
  }
}

.record-body {
  padding-top: 16rpx;

  .amount-row {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 16rpx;

    .amount-label {
      font-size: 26rpx;
      color: $text-sub;
    }

    .amount-value {
      font-size: 36rpx;
      color: $color-primary;
      font-weight: 600;

      &.amount-settled {
        color: #52C41A;
      }
    }
  }

  .time-row {
    display: flex;
    justify-content: space-between;

    .time-block {
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
