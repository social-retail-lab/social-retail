<template>
  <!-- 成长值明细页面 -->
  <!-- 功能：成长值余额、升级进度、变动记录分页 -->
  <view class="page-growth-detail">
    <!-- 自定义导航栏 -->
    <view class="navbar" :style="{ paddingTop: statusBarHeight + 'px' }">
      <view class="navbar-content">
        <view class="navbar-left" @click="goBack">
          <text class="back-icon">‹</text>
        </view>
        <view class="navbar-title">成长值明细</view>
        <view class="navbar-right"></view>
      </view>
    </view>

    <!-- 页面内容 -->
    <view class="page-content" :style="{ paddingTop: navBarHeight + 'px' }">
      <!-- 成长值头部卡片 -->
      <view class="header-card">
        <view class="growth-value">
          <text class="value-num">{{ currentGrowthValue }}</text>
        </view>
        <text class="value-label">我的成长值</text>
        <view v-if="nextLevelInfo" class="progress-info">
          <text class="progress-text">距{{ nextLevelInfo.name }}还需 {{ nextLevelNeed }} 成长值</text>
        </view>
        <view v-else class="progress-info">
          <text class="progress-text">已达最高等级</text>
        </view>
        <view class="progress-bar">
          <view class="progress-fill" :style="{ width: growthProgress + '%' }"></view>
        </view>
      </view>

      <!-- 类型筛选 -->
      <view class="type-tabs">
        <view 
          v-for="tab in typeTabs" 
          :key="tab.value"
          class="type-tab"
          :class="{ 'tab-active': currentType === tab.value }"
          @click="switchType(tab.value)"
        >
          <text>{{ tab.label }}</text>
        </view>
      </view>

      <!-- 加载中 -->
      <view v-if="loading && logList.length === 0" class="loading-tip">
        <text>加载中...</text>
      </view>

      <!-- 成长值变动记录列表 -->
      <view v-else-if="logList.length > 0" class="log-list">
        <view
          v-for="(item, index) in logList"
          :key="item.logId || index"
          class="log-card"
        >
          <view class="log-left">
            <view class="log-icon" :class="getTypeClass(item.type)">
              <text>{{ getTypeIcon(item.type) }}</text>
            </view>
          </view>
          <view class="log-right">
            <view class="log-header">
              <text class="log-type">{{ item.typeText }}</text>
              <text
                class="log-value"
                :class="Number(item.changeGrowth) >= 0 ? 'value-income' : 'value-deduct'"
              >
                {{ Number(item.changeGrowth) > 0 ? '+' + item.changeGrowth : item.changeGrowth }}
              </text>
            </view>
            <view class="log-info-row">
              <text class="log-current">当前成长值: {{ item.currentGrowth }}</text>
            </view>
            <view v-if="item.remark" class="log-remark">
              <text>{{ item.remark }}</text>
            </view>
            <view class="log-time">
              <text>{{ item.createTime }}</text>
            </view>
          </view>
        </view>

        <!-- 加载更多 -->
        <view v-if="loading && logList.length > 0" class="loading-more">
          <text>加载中...</text>
        </view>

        <!-- 没有更多 -->
        <view v-if="!hasMore && logList.length > 0" class="no-more">
          <text>没有更多记录</text>
        </view>
      </view>

      <!-- 空状态 -->
      <view v-else class="empty-state">
        <text class="empty-icon">📊</text>
        <text class="empty-text">暂无成长值变动记录</text>
      </view>
    </view>
  </view>
</template>

<script setup>
import { useMember } from '@/hooks/useMember'
import { ref, computed } from 'vue'
import { onShow, onReachBottom, onPullDownRefresh } from '@dcloudio/uni-app'

const { memberStore, loadGrowthLogs, loadMemberInfo } = useMember()

// 分页状态
const page = ref(1)
const pageSize = 10
const logList = ref([])
const total = ref(0)
const loading = ref(false)
const hasMore = computed(() => logList.value.length < total.value)
const currentType = ref(0)

// 类型筛选
const typeTabs = [
  { label: '全部', value: 0 },
  { label: '消费获得', value: 1 },
  { label: '售后扣回', value: 2 },
  { label: '系统调整', value: 3 },
  { label: '活动奖励', value: 4 }
]

// 类型图标映射
const typeIconMap = {
  1: '🛒',
  2: '↩️',
  3: '⚙️',
  4: '🎉'
}

// 类型样式映射
const typeClassMap = {
  1: 'type-consume',
  2: 'type-refund',
  3: 'type-system',
  4: 'type-activity'
}

const getTypeIcon = (type) => {
  return typeIconMap[type] || '📊'
}

const getTypeClass = (type) => {
  return typeClassMap[type] || 'type-default'
}

// 自定义导航栏高度（适配状态栏）
const statusBarHeight = ref(0)
const navBarHeight = ref(0)
const systemInfo = uni.getSystemInfoSync()
statusBarHeight.value = systemInfo.statusBarHeight || 0
navBarHeight.value = statusBarHeight.value + 44

// 当前成长值
const currentGrowthValue = computed(() => {
  return memberStore.growthValue || 0
})

// 下一级信息
const nextLevelInfo = computed(() => {
  return memberStore.nextLevelInfo
})

// 距下一级还需成长值
const nextLevelNeed = computed(() => {
  if (!nextLevelInfo.value) return 0
  return nextLevelInfo.value.needGrowth || 0
})

// 成长进度
const growthProgress = computed(() => {
  return memberStore.growthProgress || 0
})

// 返回上一页
const goBack = () => {
  uni.navigateBack()
}

// 切换类型
const switchType = (type) => {
  currentType.value = type
  resetAndLoad()
}

const resetAndLoad = async () => {
  page.value = 1
  logList.value = []
  total.value = 0
  await loadList()
}

const loadList = async () => {
  if (loading.value) return
  loading.value = true
  const params = { page: page.value, pageSize }
  if (currentType.value > 0) {
    params.type = currentType.value
  }
  const res = await loadGrowthLogs(params)
  if (page.value === 1) {
    logList.value = res.list
  } else {
    logList.value = [...logList.value, ...res.list]
  }
  total.value = res.total
  loading.value = false
}

const loadMore = async () => {
  if (!hasMore.value || loading.value) return
  page.value++
  await loadList()
}

onShow(async () => {
  await loadMemberInfo()
  await resetAndLoad()
})

onPullDownRefresh(async () => {
  await loadMemberInfo()
  await resetAndLoad()
  uni.stopPullDownRefresh()
})

onReachBottom(() => {
  loadMore()
})
</script>

<style lang="scss" scoped>
.page-growth-detail {
  min-height: 100vh;
  background-color: #F5F5F5;
}

/* 自定义导航栏 */
.navbar {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  z-index: 100;
  background-color: #FFFFFF;
  box-shadow: 0 2rpx 8rpx rgba(0, 0, 0, 0.04);

  .navbar-content {
    height: 88rpx;
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 0 32rpx;
  }

  .navbar-left {
    width: 80rpx;
    display: flex;
    align-items: center;

    .back-icon {
      font-size: 52rpx;
      color: #333333;
      line-height: 1;
    }
  }

  .navbar-title {
    font-size: 34rpx;
    font-weight: 600;
    color: #333333;
  }

  .navbar-right {
    width: 80rpx;
  }
}

/* 页面内容 */
.page-content {
  padding: 24rpx;
}

/* 成长值头部卡片 */
.header-card {
  background: linear-gradient(135deg, #FF6A00, #FF4D4F);
  border-radius: 24rpx;
  padding: 48rpx 32rpx;
  margin-bottom: 24rpx;
  display: flex;
  flex-direction: column;
  align-items: center;

  .growth-value {
    .value-num {
      font-size: 72rpx;
      font-weight: 700;
      color: #FFFFFF;
      line-height: 1.2;
    }
  }

  .value-label {
    font-size: 28rpx;
    color: rgba(255, 255, 255, 0.85);
    margin-top: 12rpx;
  }

  .progress-info {
    margin-top: 24rpx;
    padding: 12rpx 24rpx;
    background: rgba(255, 255, 255, 0.18);
    border-radius: 28rpx;

    .progress-text {
      font-size: 24rpx;
      color: #FFFFFF;
    }
  }

  .progress-bar {
    width: 100%;
    height: 12rpx;
    background: rgba(255, 255, 255, 0.25);
    border-radius: 6rpx;
    overflow: hidden;
    margin-top: 20rpx;

    .progress-fill {
      height: 100%;
      background: linear-gradient(90deg, #FFFFFF, #FFE0B2);
      border-radius: 6rpx;
      transition: width 0.5s ease;
    }
  }
}

/* 类型筛选 */
.type-tabs {
  display: flex;
  background: #FFFFFF;
  border-radius: 16rpx;
  padding: 8rpx;
  margin-bottom: 24rpx;

  .type-tab {
    flex: 1;
    padding: 20rpx 0;
    text-align: center;
    border-radius: 12rpx;
    transition: all 0.2s ease;

    text {
      font-size: 26rpx;
      color: #666666;
    }

    &.tab-active {
      background: linear-gradient(135deg, #FF6A00, #FF4D4F);

      text {
        color: #FFFFFF;
        font-weight: 500;
      }
    }
  }
}

/* 加载提示 */
.loading-tip {
  display: flex;
  justify-content: center;
  padding-top: 200rpx;

  text {
    font-size: 28rpx;
    color: #999999;
  }
}

.loading-more {
  display: flex;
  justify-content: center;
  padding: 24rpx;

  text {
    font-size: 24rpx;
    color: #999999;
  }
}

/* 记录列表 */
.log-list {
  padding-bottom: 24rpx;
}

.log-card {
  background-color: #FFFFFF;
  border-radius: 20rpx;
  padding: 28rpx;
  margin-bottom: 16rpx;
  display: flex;

  .log-left {
    margin-right: 24rpx;

    .log-icon {
      width: 80rpx;
      height: 80rpx;
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 36rpx;

      &.type-consume {
        background: rgba(255, 106, 0, 0.1);
      }

      &.type-refund {
        background: rgba(255, 77, 79, 0.1);
      }

      &.type-system {
        background: rgba(24, 144, 255, 0.1);
      }

      &.type-activity {
        background: rgba(82, 196, 26, 0.1);
      }

      &.type-default {
        background: rgba(0, 0, 0, 0.05);
      }
    }
  }

  .log-right {
    flex: 1;

    .log-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 12rpx;

      .log-type {
        font-size: 30rpx;
        font-weight: 600;
        color: #333333;
      }

      .log-value {
        font-size: 34rpx;
        font-weight: 600;

        &.value-income {
          color: #52C41A;
        }

        &.value-deduct {
          color: #FF4D4F;
        }
      }
    }

    .log-info-row {
      margin-bottom: 8rpx;

      .log-current {
        font-size: 24rpx;
        color: #999999;
      }
    }

    .log-remark {
      margin-bottom: 12rpx;

      text {
        font-size: 26rpx;
        color: #666666;
      }
    }

    .log-time {
      text {
        font-size: 24rpx;
        color: #999999;
      }
    }
  }
}

/* 没有更多 */
.no-more {
  display: flex;
  justify-content: center;
  padding: 24rpx;

  text {
    font-size: 24rpx;
    color: #CCCCCC;
  }
}

/* 空状态 */
.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding-top: 200rpx;

  .empty-icon {
    font-size: 96rpx;
    margin-bottom: 24rpx;
  }

  .empty-text {
    font-size: 28rpx;
    color: #999999;
  }
}
</style>
