<template>
  <view class="page-dist">
    <!-- 自定义导航栏 -->
    <view class="nav-bar" :style="{ paddingTop: statusBarHeight + 'px' }">
      <view class="nav-back" @click="handleBack">
        <text class="back-icon">‹</text>
      </view>
      <text class="nav-title">分销中心</text>
      <view class="nav-placeholder-right"></view>
    </view>
    <view class="nav-placeholder" :style="{ height: (statusBarHeight + 44) + 'px' }"></view>

    <!-- 加载中 -->
    <view v-if="distributorStore.dashboardLoading && !dashboardData" class="loading-state">
      <view class="loading-spinner"></view>
      <text class="loading-text">加载中...</text>
    </view>

    <!-- 工作台内容 -->
    <view v-else-if="dashboardData" class="dist-content">
      <!-- 顶部数据卡片 -->
      <view class="hero-card">
        <view class="hero-bg"></view>
        <view class="hero-content">
          <view class="hero-header">
            <view class="distributor-badge">
              <text class="badge-icon">🎖️</text>
              <text class="badge-text">分销员</text>
            </view>
            <text class="distributor-id">NO.{{ dashboardData.distributorId }}</text>
          </view>

          <view class="commission-block">
            <text class="commission-label">累计佣金（元）</text>
            <view class="commission-row">
              <text class="commission-value">{{ formatMoney(dashboardData.totalCommission) }}</text>
              <view class="withdraw-btn" @click="goWithdraw">
                <text>提现</text>
              </view>
            </view>
            <view class="commission-sub">
              <view class="sub-item">
                <text class="sub-label">冻结佣金</text>
                <text class="sub-value">¥{{ formatMoney(dashboardData.frozenCommission) }}</text>
              </view>
              <view class="sub-divider"></view>
              <view class="sub-item">
                <text class="sub-label">今日新增</text>
                <text class="sub-value highlight">+¥{{ formatMoney(dashboardData.todayCommission) }}</text>
              </view>
            </view>
          </view>
        </view>
      </view>

      <!-- 数据统计 -->
      <view class="stats-card">
        <view class="stats-item" @click="goProducts">
          <text class="stats-icon">📦</text>
          <text class="stats-value">{{ dashboardData.promotionProductCount }}</text>
          <text class="stats-label">推广商品</text>
        </view>
        <view class="stats-divider"></view>
        <view class="stats-item" @click="goOrders">
          <text class="stats-icon">📋</text>
          <text class="stats-value">{{ dashboardData.promotionOrderCount }}</text>
          <text class="stats-label">推广订单</text>
        </view>
      </view>

      <!-- 快捷菜单 -->
      <view class="menu-card">
        <view class="card-header">
          <text class="card-title">常用功能</text>
        </view>
        <view class="menu-grid">
          <view
            v-for="menu in quickMenus"
            :key="menu.name"
            class="menu-item"
            @click="goMenuPage(menu.path)"
          >
            <view class="menu-icon-wrap" :style="{ background: menu.color + '1A' }">
              <text class="menu-icon">{{ menu.icon }}</text>
            </view>
            <text class="menu-name">{{ menu.name }}</text>
          </view>
        </view>
      </view>

      <!-- 推广指南 -->
      <view class="guide-card">
        <view class="card-header">
          <text class="card-title">分销指南</text>
        </view>
        <view class="guide-list">
          <view class="guide-item" @click="goGuide('rule')">
            <text class="guide-icon">📖</text>
            <text class="guide-text">分销规则说明</text>
            <text class="guide-arrow">›</text>
          </view>
          <view class="guide-item" @click="goGuide('share')">
            <text class="guide-icon">🔗</text>
            <text class="guide-text">如何分享商品</text>
            <text class="guide-arrow">›</text>
          </view>
          <view class="guide-item" @click="goGuide('withdraw')">
            <text class="guide-icon">💵</text>
            <text class="guide-text">佣金提现说明</text>
            <text class="guide-arrow">›</text>
          </view>
        </view>
      </view>
    </view>

    <!-- 加载失败/非分销员 -->
    <view v-else class="empty-state">
      <text class="empty-icon">🔐</text>
      <text class="empty-title">暂无分销员权限</text>
      <text class="empty-desc">成为分销员后可查看分销数据</text>
      <view class="empty-btn" @click="goApply">
        <text>去申请</text>
      </view>
    </view>
  </view>
</template>

<script setup>
import { computed } from 'vue'
import { onShow } from '@dcloudio/uni-app'
import { useDistributor } from '@/hooks/useDistributor'

const statusBarHeight = uni.getSystemInfoSync().statusBarHeight || 20

const {
  distributorStore,
  loadDashboard,
  quickMenus
} = useDistributor()

const dashboardData = computed(() => distributorStore.dashboardData)

const formatMoney = (value) => {
  return (Number(value) || 0).toFixed(2)
}

const handleBack = () => {
  uni.navigateBack({
    delta: 1,
    animationType: 'slide-out-right',
    animationDuration: 200
  })
}

const goWithdraw = () => {
  uni.navigateTo({ url: '/pagesSub/distribution/commission/withdrawApply' })
}

const goProducts = () => {
  uni.navigateTo({ url: '/pagesSub/distribution/products' })
}

const goOrders = () => {
  uni.navigateTo({ url: '/pagesSub/distribution/commission/orders' })
}

const goMenuPage = (path) => {
  uni.navigateTo({ url: path })
}

const goApply = () => {
  uni.redirectTo({ url: '/pagesSub/distribution/apply' })
}

const goGuide = (type) => {
  uni.showToast({ title: '指南待完善', icon: 'none' })
}

onShow(() => {
  loadDashboard()
})
</script>

<style lang="scss" scoped>
.page-dist {
  min-height: 100vh;
  background: $bg-page;
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
  z-index: 999;
  background: rgba(255, 255, 255, 0.92);
  backdrop-filter: blur(40rpx) saturate(180%);
  -webkit-backdrop-filter: blur(40rpx) saturate(180%);
  border-bottom: 2rpx solid rgba(255, 255, 255, 0.6);
  box-shadow: $shadow-sm;

  .nav-back {
    width: 64rpx;
    height: 64rpx;
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: 50%;

    &:active {
      transform: scale(0.92);
      background: $neutral-100;
    }

    .back-icon {
      font-size: 56rpx;
      color: $ink-900;
      line-height: 1;
      font-weight: 300;
    }
  }

  .nav-title {
    font-size: 34rpx;
    font-weight: 600;
    color: $ink-900;
  }

  .nav-placeholder-right {
    width: 64rpx;
  }
}

.nav-placeholder {
  width: 100%;
  flex-shrink: 0;
}

// ============ 加载状态 ============
.loading-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding-top: 200rpx;
}

.loading-spinner {
  width: 64rpx;
  height: 64rpx;
  border: 5rpx solid $neutral-200;
  border-top-color: $color-primary;
  border-radius: 50%;
  animation: spin 0.8s linear infinite;
  margin-bottom: 20rpx;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

.loading-text {
  font-size: 26rpx;
  color: $text-weak;
}

// ============ 内容区 ============
.dist-content {
  padding: 24rpx;
}

// ============ 顶部数据卡片 ============
.hero-card {
  position: relative;
  border-radius: 24rpx;
  overflow: hidden;
  margin-bottom: 24rpx;
  box-shadow: 0 12rpx 32rpx rgba(255, 106, 0, 0.2);
}

.hero-bg {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: linear-gradient(135deg, #FF6A00 0%, #FF4D4F 100%);
}

.hero-content {
  position: relative;
  padding: 40rpx 32rpx;
  z-index: 1;
}

.hero-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 40rpx;

  .distributor-badge {
    display: flex;
    align-items: center;
    background: rgba(255, 255, 255, 0.25);
    padding: 8rpx 20rpx;
    border-radius: 24rpx;
    backdrop-filter: blur(10rpx);

    .badge-icon {
      font-size: 24rpx;
      margin-right: 8rpx;
    }

    .badge-text {
      font-size: 24rpx;
      color: #FFFFFF;
      font-weight: 600;
    }
  }

  .distributor-id {
    font-size: 24rpx;
    color: rgba(255, 255, 255, 0.85);
    letter-spacing: 1rpx;
  }
}

.commission-block {
  .commission-label {
    font-size: 24rpx;
    color: rgba(255, 255, 255, 0.85);
    margin-bottom: 12rpx;
  }

  .commission-row {
    display: flex;
    align-items: flex-end;
    justify-content: space-between;
    margin-bottom: 32rpx;
  }

  .commission-value {
    font-size: 72rpx;
    font-weight: 700;
    color: #FFFFFF;
    letter-spacing: 2rpx;
    line-height: 1;
    text-shadow: 0 4rpx 12rpx rgba(0, 0, 0, 0.15);
  }

  .withdraw-btn {
    padding: 16rpx 40rpx;
    background: #FFFFFF;
    border-radius: 32rpx;
    box-shadow: 0 6rpx 16rpx rgba(0, 0, 0, 0.15);

    &:active {
      transform: scale(0.96);
    }

    text {
      font-size: 26rpx;
      color: $color-primary;
      font-weight: 600;
    }
  }
}

.commission-sub {
  display: flex;
  align-items: center;
  background: rgba(255, 255, 255, 0.15);
  border-radius: 16rpx;
  padding: 20rpx 24rpx;
  backdrop-filter: blur(10rpx);

  .sub-item {
    flex: 1;
    display: flex;
    flex-direction: column;
    align-items: center;

    .sub-label {
      font-size: 22rpx;
      color: rgba(255, 255, 255, 0.75);
      margin-bottom: 8rpx;
    }

    .sub-value {
      font-size: 28rpx;
      color: #FFFFFF;
      font-weight: 600;

      &.highlight {
        color: #FFF3B0;
      }
    }
  }

  .sub-divider {
    width: 2rpx;
    height: 48rpx;
    background: rgba(255, 255, 255, 0.25);
  }
}

// ============ 数据统计 ============
.stats-card {
  background: $bg-card;
  border-radius: 20rpx;
  padding: 32rpx 24rpx;
  margin-bottom: 24rpx;
  display: flex;
  align-items: center;
  box-shadow: $shadow-sm;
}

.stats-item {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;

  &:active {
    opacity: 0.7;
  }

  .stats-icon {
    font-size: 48rpx;
    margin-bottom: 12rpx;
  }

  .stats-value {
    font-size: 44rpx;
    font-weight: 700;
    color: $ink-900;
    line-height: 1;
    margin-bottom: 8rpx;
  }

  .stats-label {
    font-size: 24rpx;
    color: $text-sub;
  }
}

.stats-divider {
  width: 2rpx;
  height: 80rpx;
  background: $bg-page-light;
  margin: 0 24rpx;
}

// ============ 通用卡片 ============
.menu-card,
.guide-card {
  background: $bg-card;
  border-radius: 20rpx;
  padding: 32rpx 24rpx;
  margin-bottom: 24rpx;
  box-shadow: $shadow-sm;
}

.card-header {
  display: flex;
  align-items: center;
  margin-bottom: 24rpx;

  .card-title {
    font-size: 30rpx;
    font-weight: 600;
    color: $ink-900;
  }
}

// ============ 快捷菜单 ============
.menu-grid {
  display: flex;
  flex-wrap: wrap;
  gap: 24rpx 0;
}

.menu-item {
  width: 25%;
  display: flex;
  flex-direction: column;
  align-items: center;

  &:active {
    opacity: 0.7;
    transform: scale(0.96);
  }

  .menu-icon-wrap {
    width: 88rpx;
    height: 88rpx;
    border-radius: 24rpx;
    display: flex;
    align-items: center;
    justify-content: center;
    margin-bottom: 12rpx;
  }

  .menu-icon {
    font-size: 40rpx;
  }

  .menu-name {
    font-size: 24rpx;
    color: $text-main;
  }
}

// ============ 分销指南 ============
.guide-list {
  display: flex;
  flex-direction: column;
}

.guide-item {
  display: flex;
  align-items: center;
  padding: 28rpx 0;
  border-bottom: 2rpx solid $bg-page-light;

  &:last-child {
    border-bottom: none;
  }

  &:active {
    background: $bg-page-light;
  }

  .guide-icon {
    font-size: 36rpx;
    margin-right: 20rpx;
  }

  .guide-text {
    flex: 1;
    font-size: 28rpx;
    color: $text-main;
  }

  .guide-arrow {
    font-size: 36rpx;
    color: $text-weak;
    line-height: 1;
  }
}

// ============ 空状态 ============
.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding-top: 200rpx;

  .empty-icon {
    font-size: 120rpx;
    opacity: 0.5;
    margin-bottom: 32rpx;
  }

  .empty-title {
    font-size: 32rpx;
    color: $text-main;
    font-weight: 500;
    margin-bottom: 12rpx;
  }

  .empty-desc {
    font-size: 24rpx;
    color: $text-weak;
    margin-bottom: 48rpx;
  }

  .empty-btn {
    padding: 20rpx 64rpx;
    background: linear-gradient(135deg, $color-primary 0%, $color-primary-danger 100%);
    border-radius: 40rpx;

    text {
      color: #FFFFFF;
      font-size: 28rpx;
      font-weight: 500;
    }
  }
}
</style>
