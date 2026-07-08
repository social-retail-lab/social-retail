<template>
  <view class="page-records">
    <!-- 自定义导航栏 -->
    <view class="nav-bar" :style="{ paddingTop: statusBarHeight + 'px' }">
      <view class="nav-back" @click="handleBack">
        <text class="back-icon">‹</text>
      </view>
      <text class="nav-title">提现记录</text>
      <view class="nav-right" @click="goWithdraw">
        <text class="right-text">申请提现</text>
      </view>
    </view>
    <view class="nav-placeholder" :style="{ height: (statusBarHeight + 44) + 'px' }"></view>

    <!-- 状态筛选 Tab -->
    <view class="status-tabs">
      <view
        v-for="tab in WITHDRAW_STATUS_TABS"
        :key="tab.value"
        class="status-tab"
        :class="{ 'status-tab-active': currentStatus === tab.value }"
        @click="handleTabChange(tab.value)"
      >
        <text class="tab-text">{{ tab.label }}</text>
      </view>
    </view>

    <!-- 提现记录列表 -->
    <scroll-view
      scroll-y
      class="record-scroll"
      :refresher-enabled="true"
      :refresher-triggered="refreshing"
      @refresherrefresh="onRefresh"
      @scrolltolower="onLoadMore"
    >
      <!-- 加载中（首次） -->
      <view v-if="distributorStore.withdrawRecordsLoading && recordList.length === 0" class="loading-state">
        <view class="loading-spinner"></view>
        <text class="loading-text">加载中...</text>
      </view>

      <!-- 空状态 -->
      <view v-else-if="recordList.length === 0" class="empty-state">
        <text class="empty-icon">📊</text>
        <text class="empty-title">暂无提现记录</text>
        <text class="empty-desc">您的提现申请记录会显示在这里</text>
        <view class="empty-btn" @click="goWithdraw">
          <text>立即提现</text>
        </view>
      </view>

      <!-- 记录列表 -->
      <view v-else class="record-list">
        <view
          v-for="item in recordList"
          :key="item.withdrawId"
          class="record-card"
        >
          <!-- 卡片头部 -->
          <view class="card-header">
            <view class="header-left">
              <text class="amount-value">-¥{{ formatMoney(item.amount) }}</text>
              <view
                class="status-badge"
                :style="getStatusStyle(item.status)"
              >
                <text class="status-text">{{ getStatusText(item.status) }}</text>
              </view>
            </view>
            <text class="apply-time">{{ item.applyTime }}</text>
          </view>

          <!-- 卡片信息 -->
          <view class="card-body">
            <view class="info-row">
              <text class="info-label">收款银行</text>
              <text class="info-value">{{ item.bankName }}</text>
            </view>
            <view class="info-row">
              <text class="info-label">收款卡号</text>
              <text class="info-value">{{ formatBankCard(item.bankCardNo) }}</text>
            </view>
            <view class="info-row">
              <text class="info-label">开户姓名</text>
              <text class="info-value">{{ item.accountName }}</text>
            </view>
            <view class="info-row" v-if="item.status === 2 && item.failReason">
              <text class="info-label">失败原因</text>
              <text class="info-value error">{{ item.failReason }}</text>
            </view>
          </view>
        </view>

        <!-- 加载更多 -->
        <view v-if="recordList.length > 0" class="load-more">
          <text v-if="distributorStore.withdrawRecordsLoading" class="load-more-text">加载中...</text>
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
  loadWithdrawRecords,
  switchWithdrawRecordStatus,
  WITHDRAW_STATUS_TABS,
  WITHDRAW_STATUS_MAP,
  formatMoney,
  formatBankCard
} = useDistributor()

// 本地状态
const refreshing = ref(false)
const currentStatus = ref('')

// 记录列表
const recordList = computed(() => distributorStore.withdrawRecords)
const hasMore = computed(() => distributorStore.withdrawRecordsPage < distributorStore.withdrawRecordsPages)

// 状态样式
const getStatusStyle = (status) => {
  const info = WITHDRAW_STATUS_MAP[status]
  if (!info) return {}
  return {
    color: info.color,
    backgroundColor: info.bgColor
  }
}

// 状态文案
const getStatusText = (status) => {
  return WITHDRAW_STATUS_MAP[status]?.label || '未知'
}

const handleBack = () => {
  uni.navigateBack({
    delta: 1,
    animationType: 'slide-out-right',
    animationDuration: 200
  })
}

// 跳转提现申请页
const goWithdraw = () => {
  uni.navigateTo({ url: '/pagesSub/distribution/commission/withdrawApply' })
}

// 状态筛选切换
const handleTabChange = (status) => {
  currentStatus.value = status
  switchWithdrawRecordStatus(status)
}

// 下拉刷新
const onRefresh = async () => {
  refreshing.value = true
  await loadWithdrawRecords(false)
  refreshing.value = false
}

// 上拉加载更多
const onLoadMore = () => {
  if (hasMore.value && !distributorStore.withdrawRecordsLoading) {
    loadWithdrawRecords(true)
  }
}

onShow(() => {
  loadWithdrawRecords(false)
})
</script>

<style lang="scss" scoped>
.page-records {
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

  .nav-right {
    padding: 8rpx 16rpx;

    .right-text {
      font-size: 26rpx;
      color: $color-primary;
    }
  }
}

.nav-placeholder {
  width: 100%;
}

// ============ 状态筛选 Tab ============
.status-tabs {
  display: flex;
  background: $bg-card;
  padding: 16rpx 24rpx;
  margin: 16rpx 24rpx;
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
  padding: 0 24rpx 16rpx;
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

// 卡片头部
.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-bottom: 16rpx;
  border-bottom: 1rpx solid rgba(0, 0, 0, 0.04);

  .header-left {
    display: flex;
    align-items: center;
  }

  .amount-value {
    font-size: 36rpx;
    color: $text-main;
    font-weight: 600;
    margin-right: 16rpx;
  }

  .status-badge {
    padding: 6rpx 16rpx;
    border-radius: 8rpx;

    .status-text {
      font-size: 22rpx;
      font-weight: 500;
    }
  }

  .apply-time {
    font-size: 24rpx;
    color: $text-weak;
  }
}

// 卡片信息
.card-body {
  padding-top: 16rpx;

  .info-row {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 8rpx 0;

    .info-label {
      font-size: 26rpx;
      color: $text-weak;
    }

    .info-value {
      font-size: 26rpx;
      color: $text-sub;

      &.error {
        color: #FF4D4F;
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
    margin-bottom: 32rpx;
  }

  .empty-btn {
    padding: 16rpx 48rpx;
    background: linear-gradient(135deg, #FF6A00 0%, #FF9248 100%);
    border-radius: 40rpx;

    .text, text {
      font-size: 28rpx;
      color: #FFFFFF;
      font-weight: 500;
    }
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
