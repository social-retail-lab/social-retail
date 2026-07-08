<template>
  <!-- 积分商城页面 -->
  <!-- 功能：积分余额展示、每日签到、积分兑换优惠券、赚取积分攻略 -->
  <view class="page-container">
    <!-- ============ 顶部渐变头部 ============ -->
    <view class="header">
      <!-- 自定义导航栏 -->
      <view class="nav-bar">
        <view class="nav-left" @click="handleBack">
          <text class="back-icon">‹</text>
        </view>
        <text class="nav-title">积分商城</text>
        <view class="nav-right" @click="goPointDetail">
          <text class="nav-right-text">积分明细</text>
        </view>
      </view>

      <!-- 积分余额展示 -->
      <view class="balance-section">
        <view class="balance-info">
          <text class="balance-label">我的积分</text>
          <view class="balance-row">
            <text class="balance-value">{{ pointsBalance }}</text>
            <text class="balance-unit">积分</text>
          </view>
          <text class="balance-tip">签到赚积分，兑换好福利</text>
        </view>
        <view class="balance-decoration">
          <text class="decoration-icon">💰</text>
        </view>
      </view>
    </view>

    <!-- ============ 每日签到卡片 ============ -->
    <view class="signin-card">
      <view class="signin-left">
        <view class="signin-icon-wrap">
          <text class="signin-icon">📅</text>
        </view>
        <view class="signin-info">
          <text class="signin-title">每日签到</text>
          <text class="signin-desc">{{ signedIn ? '今日已签到，明天再来吧' : `签到可获得 ${signInRewardPoints} 积分` }}</text>
        </view>
      </view>
      <view
        class="signin-btn"
        :class="{ 'signin-btn-done': signedIn }"
        @click="handleSignIn"
      >
        <text class="signin-btn-text">{{ signedIn ? '已签到' : '签到' }}</text>
      </view>
    </view>

    <!-- ============ 积分兑换优惠券 ============ -->
    <view class="exchange-section">
      <view class="section-header">
        <view class="section-title-wrap">
          <text class="section-bar"></text>
          <text class="section-title">积分兑换</text>
          <text class="section-subtitle">用积分兑换专属优惠券</text>
        </view>
      </view>

      <view v-if="couponList.length" class="coupon-list">
        <view
          v-for="coupon in couponList"
          :key="coupon.couponId || coupon.id"
          class="coupon-card"
          :class="{ 'coupon-disabled': !coupon.canExchange }"
        >
          <!-- 金额区 -->
          <view class="coupon-amount-area">
            <view class="amount-row">
              <text class="amount-symbol">¥</text>
              <text class="amount-value">{{ coupon.discountAmount }}</text>
            </view>
            <text class="amount-threshold">满{{ coupon.minConsume }}元可用</text>
          </view>

          <!-- 分割线（带半圆缺口） -->
          <view class="coupon-divider">
            <view class="divider-circle top"></view>
            <view class="divider-line"></view>
            <view class="divider-circle bottom"></view>
          </view>

          <!-- 信息区 -->
          <view class="coupon-info-area">
            <text class="coupon-title">{{ coupon.title || coupon.couponTitle }}</text>
            <text class="coupon-validity">有效期：{{ formatCouponValidity(coupon) }}</text>
            <view class="coupon-cost">
              <text class="cost-icon">💰</text>
              <text class="cost-text">{{ coupon.exchangePoints }} 积分</text>
            </view>
          </view>

          <!-- 兑换按钮 -->
          <view
            class="exchange-btn"
            :class="{ 'exchange-btn-disabled': !coupon.canExchange }"
            @click="handleExchange(coupon)"
          >
            <text class="exchange-btn-text">{{ coupon.exchangeStatusText || (coupon.canExchange ? '立即兑换' : '暂不可兑') }}</text>
          </view>
        </view>
      </view>

      <view v-else class="empty-state">
        <view class="empty-icon-wrap">
          <text class="empty-icon">🎫</text>
        </view>
        <text class="empty-text">暂无可兑换优惠券</text>
        <text class="empty-desc">敬请期待更多好券</text>
      </view>
    </view>

    <!-- ============ 赚取积分攻略 ============ -->
    <view class="guide-section">
      <view class="section-header">
        <view class="section-title-wrap">
          <text class="section-bar"></text>
          <text class="section-title">赚取积分</text>
          <text class="section-subtitle">多种方式攒积分</text>
        </view>
      </view>

      <view class="guide-grid">
        <view class="guide-item">
          <view class="guide-icon-wrap guide-icon-orange">
            <text class="guide-icon">🛒</text>
          </view>
          <view class="guide-info">
            <text class="guide-title">消费购物</text>
            <text class="guide-desc">下单支付即可获积分</text>
          </view>
        </view>
        <view class="guide-item">
          <view class="guide-icon-wrap guide-icon-yellow">
            <text class="guide-icon">📅</text>
          </view>
          <view class="guide-info">
            <text class="guide-title">每日签到</text>
            <text class="guide-desc">坚持签到赚积分</text>
          </view>
        </view>
        <view class="guide-item">
          <view class="guide-icon-wrap guide-icon-blue">
            <text class="guide-icon">↩️</text>
          </view>
          <view class="guide-info">
            <text class="guide-title">售后退回</text>
            <text class="guide-desc">订单退款积分返还</text>
          </view>
        </view>
        <view class="guide-item">
          <view class="guide-icon-wrap guide-icon-green">
            <text class="guide-icon">🎁</text>
          </view>
          <view class="guide-info">
            <text class="guide-title">活动奖励</text>
            <text class="guide-desc">参与活动领积分</text>
          </view>
        </view>
      </view>
    </view>

    <!-- ============ 积分说明 ============ -->
    <view class="rules-section">
      <view class="section-header">
        <view class="section-title-wrap">
          <text class="section-bar"></text>
          <text class="section-title">积分说明</text>
        </view>
      </view>
      <view class="rules-card">
        <view class="rule-item">
          <text class="rule-dot"></text>
          <text class="rule-text">积分可通过购物消费、每日签到等活动获取</text>
        </view>
        <view class="rule-item">
          <text class="rule-dot"></text>
          <text class="rule-text">积分可用于兑换优惠券，下单时抵扣现金</text>
        </view>
        <view class="rule-item">
          <text class="rule-dot"></text>
          <text class="rule-text">积分有效期以账户规则为准，请注意使用</text>
        </view>
        <view class="rule-item">
          <text class="rule-dot"></text>
          <text class="rule-text">订单退款时，使用积分抵扣的部分将返还</text>
        </view>
      </view>
    </view>

    <view class="safe-bottom"></view>
  </view>
</template>

<script setup>
/**
 * 积分商城页面
 * 功能：积分余额展示、每日签到、积分兑换优惠券、赚取积分攻略
 * 数据来源：useMember hook（loadMemberInfo / loadSignInStatus / doSignIn / loadExchangeCoupons / doExchangeCoupon）
 */
import { computed, onMounted } from 'vue'
import { onShow } from '@dcloudio/uni-app'
import { useMember } from '@/hooks/useMember'

const {
  memberStore,
  signInLoading,
  exchangeLoading,
  loadMemberInfo,
  loadSignInStatus,
  doSignIn,
  loadExchangeCoupons,
  doExchangeCoupon,
  refreshAllMemberData
} = useMember()

// 积分余额
const pointsBalance = computed(() => memberStore.pointsBalance || 0)

// 签到状态
const signInStatus = computed(() => memberStore.signInStatus)
const signedIn = computed(() => signInStatus.value?.signedIn || false)
const signInRewardPoints = computed(() => signInStatus.value?.rewardPoints || 0)

// 可兑换优惠券列表
const couponList = computed(() => memberStore.exchangeCoupons || [])

// 格式化优惠券有效期
const formatCouponValidity = (coupon) => {
  if (coupon.validStart && coupon.validEnd) {
    return `${coupon.validStart} 至 ${coupon.validEnd}`
  }
  if (coupon.validEnd) {
    return `至 ${coupon.validEnd}`
  }
  return coupon.validityPeriod || coupon.validRange || '见券面说明'
}

// 返回上一页
const handleBack = () => {
  const pages = getCurrentPages()
  if (pages.length > 1) {
    uni.navigateBack()
  } else {
    uni.switchTab({ url: '/pages/mine/mine' })
  }
}

// 跳转积分明细
const goPointDetail = () => {
  uni.navigateTo({ url: '/pagesSub/member/point/pointDetail' })
}

// 每日签到
const handleSignIn = () => {
  if (signedIn.value || signInLoading.value) return
  doSignIn()
}

// 兑换优惠券
const handleExchange = (coupon) => {
  if (!coupon.canExchange || exchangeLoading.value) return
  uni.showModal({
    title: '兑换确认',
    content: `确认使用 ${coupon.exchangePoints} 积分兑换「${coupon.title || coupon.couponTitle}」？`,
    confirmColor: '#FF6A00',
    success: (res) => {
      if (res.confirm) {
        doExchangeCoupon(coupon.couponId || coupon.id, coupon.exchangePoints)
      }
    }
  })
}

// 初始化加载数据
const initData = async () => {
  await refreshAllMemberData()
}

onMounted(() => {
  initData()
})

onShow(() => {
  // 页面显示时刷新签到状态和积分余额
  loadMemberInfo()
  loadSignInStatus()
})
</script>

<style lang="scss" scoped>
.page-container {
  min-height: 100vh;
  background: $bg-page;
}

/* ============ 顶部渐变头部 ============ */
.header {
  position: relative;
  background: linear-gradient(180deg, #FF6A00 0%, #FF4D4F 100%);
  padding-bottom: 60rpx;
  overflow: hidden;

  // 装饰光效
  &::before {
    content: '';
    position: absolute;
    top: -60rpx;
    right: -40rpx;
    width: 300rpx;
    height: 300rpx;
    background: radial-gradient(circle, rgba(255, 255, 255, 0.15) 0%, transparent 70%);
    border-radius: 50%;
    pointer-events: none;
  }

  &::after {
    content: '';
    position: absolute;
    bottom: -80rpx;
    left: -60rpx;
    width: 240rpx;
    height: 240rpx;
    background: radial-gradient(circle, rgba(255, 255, 255, 0.1) 0%, transparent 70%);
    border-radius: 50%;
    pointer-events: none;
  }
}

.nav-bar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 24rpx;
  padding-top: calc(20rpx + env(safe-area-inset-top));
  height: 88rpx;
  position: relative;
  z-index: 2;

  .nav-left {
    width: 64rpx;
    height: 64rpx;
    display: flex;
    align-items: center;
    justify-content: center;

    &:active { opacity: 0.6; }

    .back-icon {
      font-size: 52rpx;
      color: #FFFFFF;
      font-weight: 300;
      line-height: 1;
      margin-top: -4rpx;
    }
  }

  .nav-title {
    font-size: 34rpx;
    font-weight: 700;
    color: #FFFFFF;
    letter-spacing: 2rpx;
  }

  .nav-right {
    padding: 8rpx 20rpx;
    background: rgba(255, 255, 255, 0.2);
    border-radius: $radius-full;

    &:active { background: rgba(255, 255, 255, 0.35); }

    .nav-right-text {
      font-size: 24rpx;
      color: #FFFFFF;
    }
  }
}

.balance-section {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 40rpx 48rpx 0;
  position: relative;
  z-index: 2;

  .balance-info {
    flex: 1;

    .balance-label {
      font-size: 26rpx;
      color: rgba(255, 255, 255, 0.85);
      margin-bottom: 12rpx;
    }

    .balance-row {
      display: flex;
      align-items: baseline;
      margin-bottom: 12rpx;
    }

    .balance-value {
      font-size: 72rpx;
      font-weight: 800;
      color: #FFFFFF;
      line-height: 1;
      text-shadow: 0 2rpx 8rpx rgba(0, 0, 0, 0.1);
    }

    .balance-unit {
      font-size: 28rpx;
      color: rgba(255, 255, 255, 0.9);
      margin-left: 8rpx;
      font-weight: 500;
    }

    .balance-tip {
      font-size: 22rpx;
      color: rgba(255, 255, 255, 0.7);
    }
  }

  .balance-decoration {
    width: 120rpx;
    height: 120rpx;
    display: flex;
    align-items: center;
    justify-content: center;
    background: rgba(255, 255, 255, 0.15);
    border-radius: 50%;
    backdrop-filter: blur(4rpx);

    .decoration-icon {
      font-size: 56rpx;
    }
  }
}

/* ============ 每日签到卡片 ============ */
.signin-card {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin: -40rpx 24rpx 24rpx;
  padding: 28rpx 24rpx;
  background: $bg-card;
  border-radius: $radius-lg;
  box-shadow: 0 4rpx 16rpx rgba(0, 0, 0, 0.08);
  position: relative;
  z-index: 3;

  .signin-left {
    display: flex;
    align-items: center;
    flex: 1;
    min-width: 0;
  }

  .signin-icon-wrap {
    width: 72rpx;
    height: 72rpx;
    display: flex;
    align-items: center;
    justify-content: center;
    background: linear-gradient(135deg, #FFF3E0 0%, #FFE0B2 100%);
    border-radius: $radius-base;
    margin-right: 20rpx;
    flex-shrink: 0;

    .signin-icon {
      font-size: 36rpx;
    }
  }

  .signin-info {
    flex: 1;
    min-width: 0;
    display: flex;
    flex-direction: column;

    .signin-title {
      font-size: 30rpx;
      font-weight: 700;
      color: $text-main;
      margin-bottom: 6rpx;
    }

    .signin-desc {
      font-size: 24rpx;
      color: $text-sub;
      overflow: hidden;
      text-overflow: ellipsis;
      white-space: nowrap;
    }
  }

  .signin-btn {
    padding: 0 32rpx;
    height: 64rpx;
    display: flex;
    align-items: center;
    justify-content: center;
    background: linear-gradient(135deg, #FF6A00 0%, #FF4D4F 100%);
    border-radius: $radius-full;
    box-shadow: 0 4rpx 8rpx rgba(255, 77, 79, 0.25);
    flex-shrink: 0;
    margin-left: 16rpx;

    &:active {
      opacity: 0.85;
      transform: scale(0.97);
    }

    .signin-btn-text {
      font-size: 26rpx;
      color: #FFFFFF;
      font-weight: 600;
    }

    &.signin-btn-done {
      background: $bg-page-light;
      box-shadow: none;

      .signin-btn-text {
        color: $text-weak;
        font-weight: 500;
      }
    }
  }
}

/* ============ 通用 Section Header ============ */
.section-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 24rpx;
  margin-bottom: 20rpx;
}

.section-title-wrap {
  display: flex;
  align-items: baseline;

  .section-bar {
    width: 6rpx;
    height: 28rpx;
    background: linear-gradient(180deg, #FF6A00 0%, #FF4D4F 100%);
    border-radius: 4rpx;
    margin-right: 12rpx;
  }

  .section-title {
    font-size: 32rpx;
    font-weight: 700;
    color: $text-main;
    margin-right: 12rpx;
  }

  .section-subtitle {
    font-size: 24rpx;
    color: $text-weak;
  }
}

/* ============ 积分兑换优惠券 ============ */
.exchange-section {
  margin-bottom: 24rpx;
}

.coupon-list {
  padding: 0 24rpx;
}

.coupon-card {
  display: flex;
  align-items: stretch;
  background: $bg-card;
  border-radius: $radius-lg;
  overflow: hidden;
  margin-bottom: 20rpx;
  box-shadow: 0 2rpx 12rpx rgba(0, 0, 0, 0.05);

  &:active {
    transform: scale(0.99);
  }

  &.coupon-disabled {
    opacity: 0.6;
  }
}

.coupon-amount-area {
  width: 180rpx;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 24rpx 16rpx;
  background: linear-gradient(135deg, #FF6A00 0%, #FF4D4F 100%);
  flex-shrink: 0;

  .amount-row {
    display: flex;
    align-items: baseline;
    margin-bottom: 8rpx;
  }

  .amount-symbol {
    font-size: 28rpx;
    font-weight: 700;
    color: #FFFFFF;
  }

  .amount-value {
    font-size: 52rpx;
    font-weight: 800;
    color: #FFFFFF;
    line-height: 1;
  }

  .amount-threshold {
    font-size: 20rpx;
    color: rgba(255, 255, 255, 0.9);
  }
}

.coupon-divider {
  position: relative;
  width: 2rpx;
  background: rgba(0, 0, 0, 0.06);

  .divider-circle {
    position: absolute;
    left: -8rpx;
    width: 16rpx;
    height: 16rpx;
    background: $bg-page;
    border-radius: 50%;

    &.top { top: -8rpx; }
    &.bottom { bottom: -8rpx; }
  }

  .divider-line {
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    width: 2rpx;
    height: 60rpx;
    border-left: 2rpx dashed rgba(0, 0, 0, 0.12);
  }
}

.coupon-info-area {
  flex: 1;
  display: flex;
  flex-direction: column;
  justify-content: center;
  padding: 20rpx 20rpx;
  min-width: 0;

  .coupon-title {
    font-size: 28rpx;
    font-weight: 600;
    color: $text-main;
    margin-bottom: 8rpx;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }

  .coupon-validity {
    font-size: 22rpx;
    color: $text-weak;
    margin-bottom: 10rpx;
  }

  .coupon-cost {
    display: flex;
    align-items: center;

    .cost-icon {
      font-size: 22rpx;
      margin-right: 4rpx;
    }

    .cost-text {
      font-size: 24rpx;
      color: $color-primary-danger;
      font-weight: 600;
    }
  }
}

.exchange-btn {
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 0 24rpx;
  margin: 20rpx 20rpx 20rpx 0;
  background: linear-gradient(135deg, #FF6A00 0%, #FF4D4F 100%);
  border-radius: $radius-full;
  box-shadow: 0 2rpx 6rpx rgba(255, 77, 79, 0.25);
  flex-shrink: 0;

  &:active {
    opacity: 0.85;
  }

  .exchange-btn-text {
    font-size: 24rpx;
    color: #FFFFFF;
    font-weight: 600;
    white-space: nowrap;
  }

  &.exchange-btn-disabled {
    background: $bg-page-light;
    box-shadow: none;

    .exchange-btn-text {
      color: $text-weak;
      font-weight: 500;
    }
  }
}

/* ============ 空状态 ============ */
.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 80rpx 0;
  margin: 0 24rpx;
  background: $bg-card;
  border-radius: $radius-lg;

  .empty-icon-wrap {
    width: 120rpx;
    height: 120rpx;
    display: flex;
    align-items: center;
    justify-content: center;
    background: $bg-page-light;
    border-radius: 50%;
    margin-bottom: 20rpx;

    .empty-icon {
      font-size: 56rpx;
    }
  }

  .empty-text {
    font-size: 28rpx;
    color: $text-sub;
    margin-bottom: 8rpx;
  }

  .empty-desc {
    font-size: 24rpx;
    color: $text-weak;
  }
}

/* ============ 赚取积分攻略 ============ */
.guide-section {
  margin-bottom: 24rpx;
}

.guide-grid {
  display: flex;
  flex-wrap: wrap;
  padding: 0 24rpx;
  gap: 20rpx;
}

.guide-item {
  display: flex;
  align-items: center;
  width: calc(50% - 10rpx);
  padding: 24rpx 20rpx;
  background: $bg-card;
  border-radius: $radius-lg;
  box-shadow: 0 2rpx 8rpx rgba(0, 0, 0, 0.03);

  &:active {
    transform: scale(0.98);
  }

  .guide-icon-wrap {
    width: 64rpx;
    height: 64rpx;
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: $radius-base;
    margin-right: 16rpx;
    flex-shrink: 0;

    .guide-icon {
      font-size: 32rpx;
    }

    &.guide-icon-orange {
      background: linear-gradient(135deg, #FFF3E0 0%, #FFE0B2 100%);
    }

    &.guide-icon-yellow {
      background: linear-gradient(135deg, #FFFDE7 0%, #FFF59D 100%);
    }

    &.guide-icon-blue {
      background: linear-gradient(135deg, #E3F2FD 0%, #BBDEFB 100%);
    }

    &.guide-icon-green {
      background: linear-gradient(135deg, #E8F5E9 0%, #C8E6C9 100%);
    }
  }

  .guide-info {
    flex: 1;
    min-width: 0;
    display: flex;
    flex-direction: column;

    .guide-title {
      font-size: 28rpx;
      font-weight: 600;
      color: $text-main;
      margin-bottom: 4rpx;
    }

    .guide-desc {
      font-size: 22rpx;
      color: $text-sub;
      overflow: hidden;
      text-overflow: ellipsis;
      white-space: nowrap;
    }
  }
}

/* ============ 积分说明 ============ */
.rules-section {
  margin-bottom: 24rpx;
}

.rules-card {
  margin: 0 24rpx;
  padding: 28rpx 24rpx;
  background: $bg-card;
  border-radius: $radius-lg;
  box-shadow: 0 2rpx 8rpx rgba(0, 0, 0, 0.03);
}

.rule-item {
  display: flex;
  align-items: flex-start;
  margin-bottom: 20rpx;

  &:last-child {
    margin-bottom: 0;
  }

  .rule-dot {
    width: 10rpx;
    height: 10rpx;
    background: $color-primary;
    border-radius: 50%;
    margin-right: 12rpx;
    margin-top: 12rpx;
    flex-shrink: 0;
  }

  .rule-text {
    flex: 1;
    font-size: 26rpx;
    color: $text-sub;
    line-height: 1.6;
  }
}

.safe-bottom {
  height: calc(40rpx + env(safe-area-inset-bottom));
}
</style>
