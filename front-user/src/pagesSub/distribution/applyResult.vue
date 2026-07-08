<template>
  <view class="page-result">
    <!-- 自定义导航栏 -->
    <view class="nav-bar" :style="{ paddingTop: statusBarHeight + 'px' }">
      <view class="nav-back" @click="handleBack">
        <text class="back-icon">‹</text>
      </view>
      <text class="nav-title">申请结果</text>
      <view class="nav-placeholder-right"></view>
    </view>
    <view class="nav-placeholder" :style="{ height: (statusBarHeight + 44) + 'px' }"></view>

    <!-- 加载中 -->
    <view v-if="distributorStore.statusLoading" class="loading-state">
      <view class="loading-spinner"></view>
      <text class="loading-text">加载中...</text>
    </view>

    <!-- 结果展示 -->
    <view v-else-if="statusInfo" class="result-content">
      <!-- 状态卡片 -->
      <view class="status-card" :style="{ background: statusGradient }">
        <view class="status-icon">{{ statusInfo_icon }}</view>
        <text class="status-title">{{ statusInfo_title }}</text>
        <text class="status-desc">{{ statusInfo_desc }}</text>
      </view>

      <!-- 申请信息 -->
      <view class="info-card">
        <view class="info-header">
          <text class="info-title">申请信息</text>
        </view>

        <view class="info-item">
          <text class="info-label">真实姓名</text>
          <text class="info-value">{{ statusInfo.realName || '-' }}</text>
        </view>

        <view class="info-item">
          <text class="info-label">开户银行</text>
          <text class="info-value">{{ statusInfo.bankName || '-' }}</text>
        </view>

        <view class="info-item" v-if="statusInfo.bankCardTailNo">
          <text class="info-label">银行卡号</text>
          <text class="info-value">**** **** **** {{ statusInfo.bankCardTailNo }}</text>
        </view>

        <view class="info-item">
          <text class="info-label">申请时间</text>
          <text class="info-value">{{ statusInfo.applyTime || '-' }}</text>
        </view>

        <view class="info-item" v-if="statusInfo.auditTime">
          <text class="info-label">审核时间</text>
          <text class="info-value">{{ statusInfo.auditTime }}</text>
        </view>

        <view class="info-item" v-if="statusInfo.auditRemark">
          <text class="info-label">审核备注</text>
          <text class="info-value remark">{{ statusInfo.auditRemark }}</text>
        </view>
      </view>

      <!-- 操作按钮 -->
      <view class="action-buttons">
        <!-- 待审核 -->
        <template v-if="auditStatus === AUDIT_STATUS.PENDING">
          <view class="action-btn btn-primary" @click="goHome">
            <text class="btn-text">回到首页</text>
          </view>
        </template>

        <!-- 审核通过 -->
        <template v-else-if="auditStatus === AUDIT_STATUS.APPROVED">
          <view class="action-btn btn-primary" @click="goDashboard">
            <text class="btn-text">进入分销中心</text>
          </view>
          <view class="action-btn btn-secondary" @click="goHome">
            <text class="btn-text">回到首页</text>
          </view>
        </template>

        <!-- 审核拒绝 -->
        <template v-else-if="auditStatus === AUDIT_STATUS.REJECTED">
          <view class="action-btn btn-primary" @click="reapply">
            <text class="btn-text">重新申请</text>
          </view>
          <view class="action-btn btn-secondary" @click="goHome">
            <text class="btn-text">回到首页</text>
          </view>
        </template>
      </view>
    </view>

    <!-- 空状态 -->
    <view v-else class="empty-state">
      <text class="empty-icon">📭</text>
      <text class="empty-title">暂无申请记录</text>
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
import { AUDIT_STATUS } from '@/constants/distributor'

const statusBarHeight = uni.getSystemInfoSync().statusBarHeight || 20

const {
  distributorStore,
  loadDistributorStatus
} = useDistributor()

const statusInfo = computed(() => distributorStore.statusInfo)
const auditStatus = computed(() => distributorStore.auditStatus)

// 状态图标/标题/描述（来自常量映射）
const statusInfo_icon = computed(() => distributorStore.auditStatusInfo?.icon || '📋')
const statusInfo_title = computed(() => distributorStore.auditStatusInfo?.label || '未知状态')
const statusInfo_desc = computed(() => distributorStore.auditStatusInfo?.desc || '')

// 状态卡片渐变背景
const statusGradient = computed(() => {
  switch (auditStatus.value) {
    case AUDIT_STATUS.PENDING:
      return 'linear-gradient(135deg, #FAAD14 0%, #FFC53D 100%)'
    case AUDIT_STATUS.APPROVED:
      return 'linear-gradient(135deg, #52C41A 0%, #73D13D 100%)'
    case AUDIT_STATUS.REJECTED:
      return 'linear-gradient(135deg, #FF4D4F 0%, #FF7875 100%)'
    default:
      return 'linear-gradient(135deg, #1890FF 0%, #69B1FF 100%)'
  }
})

const handleBack = () => {
  uni.navigateBack({
    delta: 1,
    animationType: 'slide-out-right',
    animationDuration: 200
  })
}

const goHome = () => {
  uni.switchTab({ url: '/pages/index/index' })
}

const goDashboard = () => {
  uni.redirectTo({ url: '/pagesSub/distribution/distHome' })
}

const goApply = () => {
  uni.redirectTo({ url: '/pagesSub/distribution/apply' })
}

const reapply = () => {
  uni.redirectTo({ url: '/pagesSub/distribution/apply' })
}

onShow(() => {
  loadDistributorStatus()
})
</script>

<style lang="scss" scoped>
.page-result {
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

// ============ 结果内容 ============
.result-content {
  padding: 24rpx;
}

// ============ 状态卡片 ============
.status-card {
  border-radius: 24rpx;
  padding: 60rpx 32rpx;
  display: flex;
  flex-direction: column;
  align-items: center;
  box-shadow: 0 12rpx 32rpx rgba(0, 0, 0, 0.1);
  margin-bottom: 24rpx;

  .status-icon {
    font-size: 120rpx;
    margin-bottom: 24rpx;
    color: #FFFFFF;
    filter: drop-shadow(0 4rpx 12rpx rgba(0, 0, 0, 0.2));
  }

  .status-title {
    font-size: 40rpx;
    font-weight: 700;
    color: #FFFFFF;
    margin-bottom: 12rpx;
    letter-spacing: 1rpx;
  }

  .status-desc {
    font-size: 26rpx;
    color: rgba(255, 255, 255, 0.9);
    text-align: center;
  }
}

// ============ 信息卡片 ============
.info-card {
  background: $bg-card;
  border-radius: 20rpx;
  padding: 32rpx 24rpx;
  margin-bottom: 32rpx;
  box-shadow: $shadow-sm;
}

.info-header {
  padding-bottom: 20rpx;
  border-bottom: 2rpx solid $bg-page-light;
  margin-bottom: 12rpx;

  .info-title {
    font-size: 30rpx;
    font-weight: 600;
    color: $ink-900;
  }
}

.info-item {
  display: flex;
  align-items: center;
  padding: 20rpx 0;

  .info-label {
    width: 180rpx;
    font-size: 28rpx;
    color: $text-sub;
    flex-shrink: 0;
  }

  .info-value {
    flex: 1;
    font-size: 28rpx;
    color: $ink-900;
    font-weight: 500;

    &.remark {
      color: $color-primary-danger;
      font-weight: 400;
    }
  }
}

// ============ 操作按钮 ============
.action-buttons {
  display: flex;
  flex-direction: column;
  gap: 20rpx;
}

.action-btn {
  height: 96rpx;
  border-radius: 48rpx;
  display: flex;
  align-items: center;
  justify-content: center;

  &:active {
    transform: scale(0.98);
  }

  .btn-text {
    font-size: 30rpx;
    font-weight: 600;
  }
}

.btn-primary {
  background: linear-gradient(135deg, $color-primary 0%, $color-primary-danger 100%);
  box-shadow: 0 12rpx 24rpx rgba(255, 106, 0, 0.3);

  .btn-text {
    color: #FFFFFF;
  }
}

.btn-secondary {
  background: $bg-card;
  border: 2rpx solid $bg-page-light;

  .btn-text {
    color: $text-main;
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
