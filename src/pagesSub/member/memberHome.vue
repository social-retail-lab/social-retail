<template>
  <view class="page-member">
    <!-- 自定义导航栏 -->
    <view class="nav-bar" :style="{ paddingTop: statusBarHeight + 'px' }">
      <view class="nav-back" @click="handleBack">
        <text class="back-icon">‹</text>
      </view>
      <text class="nav-title">会员中心</text>
      <view class="nav-right" @click="handleLevelRule">
        <text class="nav-right-text">等级规则</text>
      </view>
    </view>
    <view class="nav-placeholder" :style="{ height: (statusBarHeight + 44) + 'px' }"></view>

    <scroll-view scroll-y class="page-scroll" enhanced :bounces="true">
      <!-- ============ 顶部渐变会员卡 ============ -->
      <view class="member-card" :style="{ background: cardGradient }">
        <!-- 等级头 -->
        <view class="level-header">
          <view class="level-badge">
            <text class="level-icon">👑</text>
          </view>
          <view class="level-info">
            <text class="level-name">{{ levelName }}</text>
            <text class="level-sub">尊享会员专属权益</text>
          </view>
        </view>

        <!-- 成长值进度 -->
        <view class="growth-section">
          <view class="growth-top">
            <text class="growth-label">当前成长值</text>
            <text class="growth-value">{{ growthValue }}</text>
          </view>
          <view v-if="nextLevel" class="growth-progress-wrap">
            <view class="progress-bar">
              <view class="progress-fill" :style="{ width: growthProgress + '%' }"></view>
            </view>
            <text class="progress-tip">还差 {{ growthGap }} 成长值升级 {{ nextLevel.levelName }} 会员</text>
          </view>
          <view v-else class="max-level-tip">
            <text class="max-level-text">🏆 已达最高会员等级，解锁全部权益</text>
          </view>
        </view>

        <!-- 双资产行 -->
        <view class="asset-row">
          <view class="asset-item" @click="handlePointDetail">
            <text class="asset-num">{{ pointsBalance }}</text>
            <text class="asset-label">积分明细 ›</text>
          </view>
          <view class="asset-divider"></view>
          <view class="asset-item" @click="handleGrowthDetail">
            <text class="asset-num">{{ growthValue }}</text>
            <text class="asset-label">成长明细 ›</text>
          </view>
        </view>

        <!-- 当前权益 -->
        <view v-if="benefits.length" class="benefits-section">
          <view class="benefits-header">
            <text class="benefits-title">当前权益</text>
            <text class="benefits-count">{{ benefits.length }} 项权益</text>
          </view>
          <view class="benefits-grid">
            <view
              v-for="(item, index) in benefits"
              :key="item.benefitCode || index"
              class="benefit-item"
            >
              <text class="benefit-icon">{{ getBenefitIcon(item.benefitCode) }}</text>
              <view class="benefit-text">
                <text class="benefit-name">{{ item.benefitName || item.name }}</text>
                <text class="benefit-desc">{{ item.description }}</text>
              </view>
            </view>
          </view>
        </view>
      </view>

      <!-- ============ 每日签到 ============ -->
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
          <text class="signin-btn-text">{{ signedIn ? '今日已签到' : '立即签到' }}</text>
        </view>
      </view>

      <!-- ============ 积分兑换优惠券 ============ -->
      <view class="exchange-section">
        <view class="section-header">
          <view class="section-title-wrap">
            <text class="section-title">积分兑换</text>
            <text class="section-subtitle">用积分兑换专属优惠券</text>
          </view>
          <view class="section-points">
            <text class="points-label">可用积分</text>
            <text class="points-num">{{ pointsBalance }}</text>
          </view>
        </view>

        <view v-if="exchangeCoupons.length" class="coupon-grid">
          <view
            v-for="coupon in exchangeCoupons"
            :key="coupon.id"
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
              <text class="exchange-btn-text">{{ coupon.exchangeStatusText }}</text>
            </view>
          </view>
        </view>

        <view v-else class="empty-state">
          <text class="empty-icon">🎫</text>
          <text class="empty-text">暂无可兑换优惠券</text>
        </view>
      </view>

      <!-- 底部安全区 -->
      <view class="safe-bottom"></view>
    </scroll-view>
  </view>
</template>

<script setup>
import { computed } from 'vue'
import { useMember } from '@/hooks/useMember'
import { onShow, onPullDownRefresh } from '@dcloudio/uni-app'

const {
  memberStore,
  doSignIn,
  doExchangeCoupon,
  refreshAllMemberData
} = useMember()

// 状态栏高度
const statusBarHeight = uni.getSystemInfoSync().statusBarHeight || 20

// ============ 会员信息计算属性 ============
const memberInfo = computed(() => memberStore.memberInfo)
const levelName = computed(() => memberInfo.value?.memberLevelName || '普通会员')
const growthValue = computed(() => Number(memberInfo.value?.growthValue) || 0)
const nextLevel = computed(() => memberInfo.value?.nextLevel || null)
const benefits = computed(() => memberInfo.value?.benefits || [])
const pointsBalance = computed(() => memberStore.pointsBalance || 0)
const growthProgress = computed(() => memberStore.growthProgress)
const exchangeCoupons = computed(() => memberStore.exchangeCoupons || [])

// 签到状态
const signInStatus = computed(() => memberStore.signInStatus)
const signedIn = computed(() => signInStatus.value?.signedIn || false)
const signInRewardPoints = computed(() => signInStatus.value?.rewardPoints || 0)

// 卡片渐变背景
const cardGradient = computed(() => {
  return memberStore.getLevelTheme(levelName.value).gradient
})

// 权益图标映射（接口6.1.1返回的benefitCode映射到emoji图标）
const benefitIconMap = {
  'POINTS_ACCELERATE': '⚡',
  'MEMBER_DISCOUNT': '🏷',
  'COUPON_GIFT': '🎁',
  'FREE_SHIPPING': '🚚',
  'BIRTHDAY_GIFT': '🎂',
  'BASIC_POINTS': '💰'
}
const getBenefitIcon = (code) => benefitIconMap[code] || '✨'

// 升级所需成长值差距
const growthGap = computed(() => {
  if (!nextLevel.value || !nextLevel.value.requiredGrowthValue) return 0
  const required = Number(nextLevel.value.requiredGrowthValue) || 0
  return Math.max(0, required - growthValue.value)
})

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

// ============ 导航方法 ============
const handleBack = () => {
  const pages = getCurrentPages()
  if (pages.length > 1) {
    uni.navigateBack()
  } else {
    uni.switchTab({ url: '/pages/mine/mine' })
  }
}

const handleLevelRule = () => {
  uni.navigateTo({ url: '/pagesSub/member/equity' })
}

const handlePointDetail = () => {
  uni.navigateTo({ url: '/pagesSub/member/point/pointDetail' })
}

const handleGrowthDetail = () => {
  uni.navigateTo({ url: '/pagesSub/member/growth/growthDetail' })
}

// ============ 业务方法 ============
const handleSignIn = () => {
  if (signedIn.value) return
  doSignIn()
}

const handleExchange = (coupon) => {
  if (!coupon.canExchange) return
  uni.showModal({
    title: '兑换确认',
    content: `确认使用 ${coupon.exchangePoints} 积分兑换「${coupon.title}」？`,
    confirmColor: '#FF6A00',
    success: (res) => {
      if (res.confirm) {
        doExchangeCoupon(coupon.couponId || coupon.id, coupon.exchangePoints)
      }
    }
  })
}

// ============ 生命周期 ============
onShow(() => {
  refreshAllMemberData()
})

onPullDownRefresh(async () => {
  await refreshAllMemberData()
  uni.stopPullDownRefresh()
})
</script>

<style lang="scss" scoped>
.page-member {
  min-height: 100vh;
  background-color: #F5F5F5;
  display: flex;
  flex-direction: column;
}

// ============ 自定义导航栏 ============
.nav-bar {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  z-index: 999;
  height: 88rpx;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 24rpx;
  background: #FFFFFF;
  box-shadow: 0 2rpx 12rpx rgba(0, 0, 0, 0.04);

  .nav-back {
    width: 64rpx;
    height: 64rpx;
    display: flex;
    align-items: center;
    justify-content: center;

    .back-icon {
      font-size: 48rpx;
      color: #333333;
      font-weight: 300;
      line-height: 1;
    }

    &:active {
      opacity: 0.6;
    }
  }

  .nav-title {
    font-size: 34rpx;
    font-weight: 600;
    color: #333333;
  }

  .nav-right {
    padding: 8rpx 16rpx;

    .nav-right-text {
      font-size: 26rpx;
      color: #FF6A00;
      font-weight: 500;
    }

    &:active {
      opacity: 0.6;
    }
  }
}

.nav-placeholder {
  width: 100%;
  flex-shrink: 0;
}

.page-scroll {
  flex: 1;
  height: 0;
}

// ============ 顶部渐变会员卡 ============
.member-card {
  margin: 20rpx 24rpx 0;
  border-radius: 24rpx;
  padding: 36rpx 32rpx 32rpx;
  box-shadow: 0 12rpx 32rpx rgba(0, 0, 0, 0.12);
  overflow: hidden;
  position: relative;

  // 装饰光晕
  &::before {
    content: '';
    position: absolute;
    top: -80rpx;
    right: -60rpx;
    width: 280rpx;
    height: 280rpx;
    border-radius: 50%;
    background: rgba(255, 255, 255, 0.12);
  }

  &::after {
    content: '';
    position: absolute;
    bottom: -100rpx;
    left: -40rpx;
    width: 200rpx;
    height: 200rpx;
    border-radius: 50%;
    background: rgba(255, 255, 255, 0.08);
  }
}

// 等级头
.level-header {
  display: flex;
  align-items: center;
  position: relative;
  z-index: 1;

  .level-badge {
    width: 88rpx;
    height: 88rpx;
    border-radius: 50%;
    background: rgba(255, 255, 255, 0.25);
    display: flex;
    align-items: center;
    justify-content: center;
    margin-right: 24rpx;
    border: 2rpx solid rgba(255, 255, 255, 0.4);

    .level-icon {
      font-size: 44rpx;
    }
  }

  .level-info {
    flex: 1;

    .level-name {
      font-size: 44rpx;
      font-weight: 700;
      color: #FFFFFF;
      display: block;
      margin-bottom: 8rpx;
      letter-spacing: 2rpx;
      text-shadow: 0 2rpx 8rpx rgba(0, 0, 0, 0.15);
    }

    .level-sub {
      font-size: 24rpx;
      color: rgba(255, 255, 255, 0.85);
    }
  }
}

// 成长值进度
.growth-section {
  margin-top: 36rpx;
  position: relative;
  z-index: 1;

  .growth-top {
    display: flex;
    align-items: baseline;
    margin-bottom: 20rpx;

    .growth-label {
      font-size: 24rpx;
      color: rgba(255, 255, 255, 0.85);
      margin-right: 16rpx;
    }

    .growth-value {
      font-size: 48rpx;
      font-weight: 700;
      color: #FFFFFF;
      line-height: 1;
    }
  }

  .growth-progress-wrap {
    .progress-bar {
      width: 100%;
      height: 16rpx;
      background: rgba(255, 255, 255, 0.3);
      border-radius: 8rpx;
      overflow: hidden;
      margin-bottom: 16rpx;

      .progress-fill {
        height: 100%;
        background: linear-gradient(90deg, #FFFFFF, #FFE0B2);
        border-radius: 8rpx;
        transition: width 0.6s ease;
        box-shadow: 0 0 12rpx rgba(255, 255, 255, 0.6);
      }
    }

    .progress-tip {
      font-size: 22rpx;
      color: rgba(255, 255, 255, 0.9);
    }
  }

  .max-level-tip {
    .max-level-text {
      font-size: 26rpx;
      color: #FFFFFF;
      font-weight: 500;
    }
  }
}

// 双资产行
.asset-row {
  display: flex;
  margin-top: 32rpx;
  padding: 24rpx 0;
  border-top: 2rpx solid rgba(255, 255, 255, 0.2);
  border-bottom: 2rpx solid rgba(255, 255, 255, 0.2);
  position: relative;
  z-index: 1;

  .asset-item {
    flex: 1;
    display: flex;
    flex-direction: column;
    align-items: center;

    .asset-num {
      font-size: 48rpx;
      font-weight: 700;
      color: #FFFFFF;
      line-height: 1.2;
      margin-bottom: 8rpx;
    }

    .asset-label {
      font-size: 24rpx;
      color: rgba(255, 255, 255, 0.9);
    }

    &:active {
      opacity: 0.7;
    }
  }

  .asset-divider {
    width: 2rpx;
    background: rgba(255, 255, 255, 0.25);
  }
}

// 当前权益
.benefits-section {
  margin-top: 32rpx;
  position: relative;
  z-index: 1;

  .benefits-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-bottom: 20rpx;

    .benefits-title {
      font-size: 28rpx;
      font-weight: 600;
      color: #FFFFFF;
    }

    .benefits-count {
      font-size: 22rpx;
      color: rgba(255, 255, 255, 0.8);
    }
  }

  .benefits-grid {
    display: flex;
    flex-wrap: wrap;

    .benefit-item {
      width: 50%;
      display: flex;
      align-items: center;
      margin-bottom: 20rpx;
      padding-right: 16rpx;
      box-sizing: border-box;

      .benefit-icon {
        width: 56rpx;
        height: 56rpx;
        border-radius: 50%;
        background: rgba(255, 255, 255, 0.2);
        display: flex;
        align-items: center;
        justify-content: center;
        margin-right: 16rpx;
        flex-shrink: 0;
        font-size: 28rpx;
      }

      .benefit-text {
        flex: 1;
        min-width: 0;

        .benefit-name {
          font-size: 26rpx;
          font-weight: 500;
          color: #FFFFFF;
          display: block;
          margin-bottom: 4rpx;
          overflow: hidden;
          text-overflow: ellipsis;
          white-space: nowrap;
        }

        .benefit-desc {
          font-size: 20rpx;
          color: rgba(255, 255, 255, 0.75);
          overflow: hidden;
          text-overflow: ellipsis;
          white-space: nowrap;
        }
      }
    }
  }
}

// ============ 每日签到 ============
.signin-card {
  margin: 20rpx 24rpx 0;
  background: #FFFFFF;
  border-radius: 24rpx;
  padding: 32rpx;
  display: flex;
  align-items: center;
  justify-content: space-between;
  box-shadow: 0 8rpx 24rpx rgba(0, 0, 0, 0.04);

  .signin-left {
    display: flex;
    align-items: center;
    flex: 1;

    .signin-icon-wrap {
      width: 80rpx;
      height: 80rpx;
      border-radius: 50%;
      background: linear-gradient(135deg, #FFF3E8, #FFE0C7);
      display: flex;
      align-items: center;
      justify-content: center;
      margin-right: 24rpx;
      flex-shrink: 0;

      .signin-icon {
        font-size: 40rpx;
      }
    }

    .signin-info {
      flex: 1;

      .signin-title {
        font-size: 32rpx;
        font-weight: 600;
        color: #333333;
        display: block;
        margin-bottom: 8rpx;
      }

      .signin-desc {
        font-size: 24rpx;
        color: #999999;
      }
    }
  }

  .signin-btn {
    padding: 20rpx 40rpx;
    background: linear-gradient(135deg, #FF6A00, #FF8A33);
    border-radius: 44rpx;
    box-shadow: 0 8rpx 20rpx rgba(255, 106, 0, 0.3);
    transition: all 0.2s ease;

    .signin-btn-text {
      font-size: 28rpx;
      font-weight: 600;
      color: #FFFFFF;
    }

    &:active {
      transform: scale(0.96);
      opacity: 0.9;
    }

    &.signin-btn-done {
      background: #F0F0F0;
      box-shadow: none;

      .signin-btn-text {
        color: #999999;
        font-weight: 400;
      }
    }
  }
}

// ============ 积分兑换 ============
.exchange-section {
  margin: 20rpx 24rpx 0;

  .section-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-bottom: 24rpx;

    .section-title-wrap {
      .section-title {
        font-size: 34rpx;
        font-weight: 700;
        color: #333333;
        display: block;
        margin-bottom: 6rpx;
      }

      .section-subtitle {
        font-size: 24rpx;
        color: #999999;
      }
    }

    .section-points {
      display: flex;
      align-items: baseline;
      background: #FFF3E8;
      padding: 12rpx 24rpx;
      border-radius: 24rpx;

      .points-label {
        font-size: 22rpx;
        color: #999999;
        margin-right: 8rpx;
      }

      .points-num {
        font-size: 32rpx;
        font-weight: 700;
        color: #FF6A00;
      }
    }
  }

  .coupon-grid {
    display: flex;
    flex-wrap: wrap;
    justify-content: space-between;
  }

  .coupon-card {
    width: 48.5%;
    background: #FFFFFF;
    border-radius: 24rpx;
    margin-bottom: 20rpx;
    overflow: hidden;
    box-shadow: 0 8rpx 24rpx rgba(0, 0, 0, 0.05);
    display: flex;
    flex-direction: column;
    border: 2rpx solid #FFF0E0;

    &.coupon-disabled {
      opacity: 0.65;
      border-color: #EEEEEE;
    }

    // 金额区
    .coupon-amount-area {
      background: linear-gradient(135deg, #FF6A00, #FF8A33);
      padding: 24rpx 24rpx 20rpx;
      text-align: center;

      .amount-row {
        display: flex;
        align-items: baseline;
        justify-content: center;
        margin-bottom: 8rpx;

        .amount-symbol {
          font-size: 28rpx;
          font-weight: 600;
          color: #FFFFFF;
          margin-right: 4rpx;
        }

        .amount-value {
          font-size: 56rpx;
          font-weight: 700;
          color: #FFFFFF;
          line-height: 1;
        }
      }

      .amount-threshold {
        font-size: 22rpx;
        color: rgba(255, 255, 255, 0.9);
      }
    }

    &.coupon-disabled .coupon-amount-area {
      background: linear-gradient(135deg, #BFBFBF, #A0A0A0);
    }

    // 信息区
    .coupon-info-area {
      padding: 20rpx 24rpx 16rpx;
      flex: 1;

      .coupon-title {
        font-size: 28rpx;
        font-weight: 600;
        color: #333333;
        display: block;
        margin-bottom: 10rpx;
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
      }

      .coupon-validity {
        font-size: 20rpx;
        color: #999999;
        display: block;
        margin-bottom: 12rpx;
      }

      .coupon-cost {
        display: flex;
        align-items: center;

        .cost-icon {
          font-size: 22rpx;
          margin-right: 6rpx;
        }

        .cost-text {
          font-size: 24rpx;
          font-weight: 600;
          color: #FF6A00;
        }
      }
    }

    &.coupon-disabled .coupon-info-area .coupon-cost .cost-text {
      color: #999999;
    }

    // 兑换按钮
    .exchange-btn {
      margin: 0 24rpx 24rpx;
      height: 64rpx;
      background: linear-gradient(135deg, #FF6A00, #FF8A33);
      border-radius: 32rpx;
      display: flex;
      align-items: center;
      justify-content: center;
      transition: all 0.2s ease;

      .exchange-btn-text {
        font-size: 26rpx;
        font-weight: 600;
        color: #FFFFFF;
      }

      &:active {
        transform: scale(0.96);
        opacity: 0.9;
      }

      &.exchange-btn-disabled {
        background: #F0F0F0;

        .exchange-btn-text {
          color: #999999;
          font-weight: 400;
        }
      }
    }
  }

  // 空状态
  .empty-state {
    background: #FFFFFF;
    border-radius: 24rpx;
    padding: 80rpx 0;
    display: flex;
    flex-direction: column;
    align-items: center;
    box-shadow: 0 8rpx 24rpx rgba(0, 0, 0, 0.04);

    .empty-icon {
      font-size: 80rpx;
      margin-bottom: 20rpx;
      opacity: 0.4;
    }

    .empty-text {
      font-size: 28rpx;
      color: #999999;
    }
  }
}

// ============ 底部安全区 ============
.safe-bottom {
  height: calc(40rpx + env(safe-area-inset-bottom));
  width: 100%;
}
</style>
