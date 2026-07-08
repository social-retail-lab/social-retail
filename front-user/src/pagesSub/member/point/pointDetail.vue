<template>
  <!-- 积分明细页面 -->
  <!-- 功能：积分余额、积分收入/支出明细、分类筛选、分页加载 -->
  <view class="page-container">
    <!-- 自定义导航栏 -->
    <view class="nav-bar">
      <view class="nav-left" @click="handleBack">
        <text class="back-icon">‹</text>
      </view>
      <text class="nav-title">积分明细</text>
      <view class="nav-right"></view>
    </view>

    <!-- 积分余额头部卡片 -->
    <view class="balance-card">
      <text class="balance-value">{{ memberStore.pointsBalance }}</text>
      <text class="balance-label">我的积分</text>
    </view>

    <!-- 横向滚动筛选标签 -->
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
        </view>
      </view>
    </scroll-view>

    <!-- 积分变动列表 -->
    <view v-if="logList.length === 0 && !loading" class="empty-state">
      <view class="empty-icon">
        <text class="empty-emoji">💰</text>
      </view>
      <text class="empty-text">暂无积分变动记录</text>
    </view>

    <view v-else class="log-list">
      <view v-for="(log, index) in logList" :key="index" class="log-card">
        <view class="log-top">
          <text class="log-type">{{ log.typeText }}</text>
          <text class="log-points" :class="isIncome(log) ? 'points-in' : 'points-out'">
            {{ formatChangePoints(log) }}
          </text>
        </view>
        <view class="log-bottom">
          <text v-if="log.remark" class="log-remark">{{ log.remark }}</text>
          <view class="log-meta">
            <text class="log-balance">变动后余额: {{ log.currentPoints }}</text>
            <text class="log-time">{{ formatTime(log.createTime) }}</text>
          </view>
        </view>
      </view>

      <view v-if="loading" class="loading-more">
        <text class="loading-text">加载中...</text>
      </view>
      <view v-if="!loading && !hasMore && logList.length > 0" class="no-more">
        <text class="no-more-text">没有更多记录</text>
      </view>
    </view>
  </view>
</template>

<script setup>
import { useMember } from '@/hooks/useMember'
import { ref, computed } from 'vue'
import { onShow, onReachBottom, onPullDownRefresh } from '@dcloudio/uni-app'
import { formatTime } from '@/utils/format'

const { memberStore, loadPointsLogs } = useMember()

const activeTab = ref('')
const page = ref(1)
const pageSize = 10
const logList = ref([])
const total = ref(0)
const loading = ref(false)
const hasMore = computed(() => logList.value.length < total.value)

const tabs = [
  { key: '', label: '全部' },
  { key: 1, label: '消费获得' },
  { key: 2, label: '积分抵扣' },
  { key: 3, label: '签到获得' },
  { key: 4, label: '兑换优惠券' },
  { key: 5, label: '售后退回' },
  { key: 6, label: '系统调整' }
]

const handleBack = () => {
  uni.navigateBack()
}

const isIncome = (log) => {
  return Number(log.changePoints) > 0
}

const formatChangePoints = (log) => {
  const points = Number(log.changePoints) || 0
  return points > 0 ? `+${points}` : `${points}`
}

const switchTab = (key) => {
  activeTab.value = key
  resetAndLoad()
}

const resetAndLoad = async () => {
  page.value = 1
  logList.value = []
  await loadList()
}

const loadList = async () => {
  if (loading.value) return
  loading.value = true
  const res = await loadPointsLogs({ page: page.value, pageSize, type: activeTab.value || undefined })
  let list = res.list || []
  // 客户端过滤兜底：如果后端未按type过滤，前端再过滤一次
  if (activeTab.value) {
    list = list.filter(item => Number(item.type) === Number(activeTab.value))
  }
  if (page.value === 1) {
    logList.value = list
  } else {
    logList.value = [...logList.value, ...list]
  }
  total.value = activeTab.value ? logList.value.length : res.total
  loading.value = false
}

const loadMore = async () => {
  if (!hasMore.value || loading.value) return
  page.value++
  await loadList()
}

onShow(() => {
  resetAndLoad()
})

onPullDownRefresh(async () => {
  await resetAndLoad()
  uni.stopPullDownRefresh()
})

onReachBottom(() => {
  loadMore()
})
</script>

<style lang="scss" scoped>
.page-container {
  min-height: 100vh;
  background: $bg-page;
  display: flex;
  flex-direction: column;
}

/* 自定义导航栏 */
.nav-bar {
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

  .nav-left,
  .nav-right {
    width: 80rpx;
    display: flex;
    align-items: center;
    justify-content: center;
  }

  .back-icon {
    font-size: 56rpx;
    color: $text-main;
    line-height: 1;
  }

  .nav-title {
    font-size: 36rpx;
    font-weight: 600;
    color: $text-main;
  }
}

/* 积分余额头部卡片 */
.balance-card {
  margin: calc(88rpx + env(safe-area-inset-top) + 24rpx) 24rpx 24rpx;
  padding: 56rpx 32rpx;
  border-radius: 24rpx;
  background: linear-gradient(135deg, $color-primary 0%, $color-primary-light 100%);
  display: flex;
  flex-direction: column;
  align-items: center;
  box-shadow: 0 8rpx 24rpx rgba(255, 106, 0, 0.24);

  .balance-value {
    font-size: 72rpx;
    font-weight: 700;
    color: #FFFFFF;
    line-height: 1.2;
  }

  .balance-label {
    font-size: 26rpx;
    color: rgba(255, 255, 255, 0.9);
    margin-top: 12rpx;
  }
}

/* 横向滚动筛选标签 */
.tabs-bar {
  white-space: nowrap;
  background: $bg-card;
  border-radius: 20rpx;
  margin: 0 24rpx 24rpx;

  .tabs-inner {
    display: inline-flex;
    padding: 0 8rpx;
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
  }
}

/* 积分变动列表 */
.log-list {
  padding: 0 24rpx 24rpx;
}

.log-card {
  background: $bg-card;
  border-radius: 20rpx;
  padding: 28rpx;
  margin-bottom: 16rpx;
  box-shadow: $category-shadow-sm;

  .log-top {
    display: flex;
    align-items: center;
    justify-content: space-between;

    .log-type {
      font-size: 30rpx;
      font-weight: 600;
      color: $text-main;
    }

    .log-points {
      font-size: 34rpx;
      font-weight: 700;

      &.points-in {
        color: $color-success;
      }

      &.points-out {
        color: $color-primary-danger;
      }
    }
  }

  .log-bottom {
    margin-top: 16rpx;

    .log-remark {
      display: block;
      font-size: 26rpx;
      color: $text-sub;
      line-height: 1.5;
      margin-bottom: 12rpx;
    }

    .log-meta {
      display: flex;
      align-items: center;
      justify-content: space-between;

      .log-balance {
        font-size: 24rpx;
        color: $text-weak;
      }

      .log-time {
        font-size: 24rpx;
        color: $text-weak;
      }
    }
  }
}

/* 空状态 */
.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding-top: 200rpx;

  .empty-icon {
    width: 160rpx;
    height: 160rpx;
    display: flex;
    align-items: center;
    justify-content: center;
    margin-bottom: 24rpx;

    .empty-emoji {
      font-size: 96rpx;
    }
  }

  .empty-text {
    font-size: 28rpx;
    color: $text-weak;
  }
}

/* 加载更多 / 没有更多 */
.loading-more {
  padding: 24rpx;
  text-align: center;

  .loading-text {
    font-size: 26rpx;
    color: $text-weak;
  }
}

.no-more {
  padding: 24rpx;
  text-align: center;

  .no-more-text {
    font-size: 26rpx;
    color: #CCCCCC;
  }
}
</style>
