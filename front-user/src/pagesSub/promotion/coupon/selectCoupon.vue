<template>
  <view class="page-select-coupon">
    <!-- 自定义导航栏 -->
    <view class="nav-bar" :style="{ paddingTop: statusBarHeight + 'px' }">
      <view class="nav-back" @click="handleBack">
        <text class="back-icon">‹</text>
      </view>
      <text class="nav-title">{{ pageTitle }}</text>
      <view class="nav-placeholder-right"></view>
    </view>
    <view class="nav-placeholder" :style="{ height: (statusBarHeight + 44) + 'px' }"></view>

    <!-- 结算信息 -->
    <view class="settlement-info">
      <view class="settlement-row">
        <text class="settlement-label">结算金额</text>
        <text class="settlement-amount">¥{{ formatPrice(settlementAmount) }}</text>
      </view>
      <view v-if="settlementMerchantName" class="settlement-row">
        <text class="settlement-label">所属商家</text>
        <text class="settlement-merchant">{{ settlementMerchantName }}</text>
      </view>
    </view>

    <!-- 使用规则提示 -->
    <view v-if="useRule.description" class="use-rule">
      <text class="rule-icon">💡</text>
      <text class="rule-text">{{ useRule.description }}</text>
    </view>

    <!-- 加载中 -->
    <view v-if="loading && couponList.length === 0" class="loading-state">
      <view class="loading-spinner"></view>
      <text class="loading-text">加载中...</text>
    </view>

    <!-- 空状态 -->
    <view v-else-if="couponList.length === 0" class="empty-state">
      <text class="empty-icon">🎫</text>
      <text class="empty-title">暂无可用优惠券</text>
      <text class="empty-desc">当前订单暂无可用{{ sourceText }}，去领券中心看看吧</text>
    </view>

    <!-- 优惠券列表 -->
    <scroll-view
      v-else
      scroll-y
      class="coupon-scroll"
    >
      <!-- 不使用优惠券选项 -->
      <view class="coupon-list">
        <view
          class="coupon-card no-use-card"
          :class="{ 'coupon-selected': !selectedCouponUserId }"
          @click="handleSelectNone"
        >
          <view class="no-use-content">
            <text class="no-use-text">不使用优惠券</text>
            <text v-if="selectedCouponUserId === null" class="check-icon">✓</text>
          </view>
        </view>

        <view
          v-for="coupon in couponList"
          :key="coupon.couponUserId"
          class="coupon-card"
          :class="{
            'coupon-available': coupon.available,
            'coupon-unavailable': !coupon.available,
            'coupon-selected': selectedCouponUserId === coupon.couponUserId
          }"
          @click="handleSelectCoupon(coupon)"
        >
          <!-- 左侧金额区 -->
          <view class="coupon-left">
            <view class="coupon-amount">
              <text class="amount-symbol">¥</text>
              <text class="amount-value">{{ coupon.discountAmount }}</text>
            </view>
            <text class="coupon-condition">满{{ coupon.minConsume }}可用</text>
          </view>

          <!-- 分隔线 -->
          <view class="coupon-divider">
            <view class="circle-top"></view>
            <view class="dashed-line"></view>
            <view class="circle-bottom"></view>
          </view>

          <!-- 右侧信息区 -->
          <view class="coupon-right">
            <text class="coupon-title">{{ coupon.title }}</text>
            <text class="coupon-type">{{ coupon.typeText || '满减券' }}</text>
            <text class="coupon-validity">有效期：{{ formatValidity(coupon) }}</text>
            <!-- 不可用原因 -->
            <text v-if="!coupon.available && coupon.unavailableReason" class="coupon-reason">
              {{ coupon.unavailableReason }}
            </text>
            <!-- 推荐/选中标记 -->
            <view v-if="coupon.recommended" class="recommend-tag">
              <text>推荐</text>
            </view>
          </view>

          <!-- 选中标记 -->
          <view v-if="selectedCouponUserId === coupon.couponUserId" class="selected-mark">
            <text class="check-icon-circle">✓</text>
          </view>
        </view>
      </view>

      <!-- 底部安全区 -->
      <view class="safe-bottom"></view>
    </scroll-view>

    <!-- 底部确认按钮 -->
    <view class="bottom-bar">
      <view class="confirm-btn" :class="{ 'confirm-btn-disabled': !canConfirm }" @click="handleConfirm">
        <text class="confirm-btn-text">确认选择</text>
      </view>
    </view>
  </view>
</template>

<script setup>
import { ref, computed } from 'vue'
import { onLoad, onUnload } from '@dcloudio/uni-app'
import { useCoupon, getSelectCouponParams, clearSelectCouponParams } from '@/hooks/useCoupon'
import {
  COUPON_SELECT_SOURCE,
  COUPON_SOURCE_TEXT,
  isCouponAvailable
} from '@/constants/coupon'
import { formatPrice } from '@/utils/common'

const {
  couponStore,
  loading,
  loadAvailableCoupons,
  resetAvailableCoupons
} = useCoupon()

const statusBarHeight = uni.getSystemInfoSync().statusBarHeight || 20

// 页面参数
const params = ref(null)
const source = ref('')              // 选择来源 PLATFORM/MERCHANT
const selectedCouponUserId = ref(null)  // 当前选中的 couponUserId(null 表示不使用)

// 结算信息(从 store 读取)
const settlementAmount = computed(() => couponStore.settlementAmount)
const settlementMerchantName = computed(() => couponStore.settlementMerchantName)
const useRule = computed(() => couponStore.couponUseRule || {})

// 当前来源的优惠券列表
const couponList = computed(() => {
  if (source.value === COUPON_SELECT_SOURCE.PLATFORM) {
    return couponStore.availablePlatformCoupons
  }
  if (source.value === COUPON_SELECT_SOURCE.MERCHANT) {
    return couponStore.availableMerchantCoupons
  }
  return []
})

// 来源文本
const sourceText = computed(() => {
  return COUPON_SOURCE_TEXT[source.value] || '优惠券'
})

// 页面标题
const pageTitle = computed(() => {
  return `选择${sourceText.value}`
})

// 是否可确认
const canConfirm = computed(() => {
  // 任何时候都可以确认(包括"不使用")
  return true
})

// 格式化有效期
const formatValidity = (coupon) => {
  if (!coupon) return ''
  const start = coupon.validStart ? coupon.validStart.substring(0, 10) : ''
  const end = coupon.validEnd ? coupon.validEnd.substring(0, 10) : ''
  if (start && end) return `${start} 至 ${end}`
  if (end) return `至 ${end}`
  return '见券面说明'
}

// 返回上一页
const handleBack = () => {
  clearSelectCouponParams()
  resetAvailableCoupons()
  uni.navigateBack({
    delta: 1,
    animationType: 'slide-out-right',
    animationDuration: 200
  })
}

// 选择"不使用优惠券"
const handleSelectNone = () => {
  selectedCouponUserId.value = null
}

// 选择优惠券
const handleSelectCoupon = (coupon) => {
  // 不可用优惠券不允许选择
  if (!isCouponAvailable(coupon)) return
  selectedCouponUserId.value = coupon.couponUserId
}

// 确认选择(通过 eventChannel 回传给调用页)
const handleConfirm = () => {
  // 找到选中的优惠券对象(null 表示不使用)
  let selectedCoupon = null
  if (selectedCouponUserId.value !== null) {
    selectedCoupon = couponList.value.find(
      c => c.couponUserId === selectedCouponUserId.value
    ) || null
  }

  // 1. 通过上一页方法回传(主方案)
  const pages = getCurrentPages()
  const prevPage = pages[pages.length - 2]
  if (prevPage && typeof prevPage.$vm?.onCouponSelected === 'function') {
    prevPage.$vm.onCouponSelected({
      source: source.value,
      coupon: selectedCoupon,
      couponUserId: selectedCouponUserId.value
    })
  }

  // 2. 通过全局事件通知(备用方案,跨页面/弹窗)
  uni.$emit('couponSelected', {
    source: source.value,
    coupon: selectedCoupon,
    couponUserId: selectedCouponUserId.value
  })

  clearSelectCouponParams()
  resetAvailableCoupons()
  uni.navigateBack({
    delta: 1,
    animationType: 'slide-out-right',
    animationDuration: 200
  })
}

// 页面加载
onLoad(() => {
  // 读取暂存的参数
  const pageParams = getSelectCouponParams()
  if (!pageParams) {
    uni.showToast({ title: '参数错误', icon: 'none' })
    setTimeout(handleBack, 1500)
    return
  }
  params.value = pageParams
  source.value = pageParams.source || ''
  selectedCouponUserId.value = pageParams.selectedCouponUserId ?? null

  // 加载可用优惠券
  loadCoupons()
})

// 加载可用优惠券
const loadCoupons = async () => {
  if (!params.value?.cartItemIds?.length) return
  await loadAvailableCoupons(params.value.cartItemIds)
}

// 页面卸载
onUnload(() => {
  clearSelectCouponParams()
  resetAvailableCoupons()
})
</script>

<style lang="scss" scoped>
.page-select-coupon {
  min-height: 100vh;
  background: $bg-page;
  display: flex;
  flex-direction: column;
  padding-bottom: 140rpx;
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
    transition: all $duration-fast $ease-out-quart;

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
    letter-spacing: 0.5rpx;
  }

  .nav-placeholder-right {
    width: 64rpx;
  }
}

.nav-placeholder {
  width: 100%;
  flex-shrink: 0;
}

// ============ 结算信息 ============
.settlement-info {
  margin: 20rpx 24rpx 0;
  padding: 24rpx 28rpx;
  background: $bg-card;
  border-radius: $radius-lg;
  box-shadow: $shadow-xs;

  .settlement-row {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 8rpx 0;

    .settlement-label {
      font-size: 26rpx;
      color: $text-sub;
    }

    .settlement-amount {
      font-size: 32rpx;
      font-weight: 700;
      color: $color-primary-danger;
    }

    .settlement-merchant {
      font-size: 26rpx;
      color: $ink-900;
      font-weight: 500;
    }
  }
}

// ============ 使用规则 ============
.use-rule {
  margin: 16rpx 24rpx 0;
  padding: 16rpx 24rpx;
  background: rgba(255, 106, 0, 0.08);
  border-radius: $radius-md;
  display: flex;
  align-items: flex-start;

  .rule-icon {
    font-size: 24rpx;
    margin-right: 12rpx;
    flex-shrink: 0;
  }

  .rule-text {
    flex: 1;
    font-size: 22rpx;
    color: $color-primary;
    line-height: 1.5;
  }
}

// ============ 加载/空状态 ============
.loading-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 120rpx 0;
}

.loading-spinner {
  width: 56rpx;
  height: 56rpx;
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

.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 160rpx 32rpx;

  .empty-icon {
    font-size: 120rpx;
    margin-bottom: 32rpx;
    opacity: 0.5;
  }

  .empty-title {
    font-size: 32rpx;
    font-weight: 600;
    color: $ink-800;
    margin-bottom: 12rpx;
  }

  .empty-desc {
    font-size: 24rpx;
    color: $text-weak;
    text-align: center;
  }
}

// ============ 优惠券列表 ============
.coupon-scroll {
  flex: 1;
  height: 0;
  transform: translateZ(0);
  -webkit-overflow-scrolling: touch;
  margin-top: 20rpx;
}

.coupon-list {
  padding: 0 24rpx 20rpx;
}

// 不使用优惠券卡片
.no-use-card {
  display: flex;
  align-items: center;
  background: $bg-card;
  border-radius: $radius-lg;
  padding: 28rpx 24rpx;
  margin-bottom: 20rpx;
  border: 2rpx solid transparent;
  box-shadow: $shadow-xs;
  transition: all $duration-fast $ease-out-quart;

  &.coupon-selected {
    border-color: $color-primary;
    background: rgba(255, 106, 0, 0.04);
  }

  .no-use-content {
    flex: 1;
    display: flex;
    align-items: center;
    justify-content: space-between;

    .no-use-text {
      font-size: 28rpx;
      color: $ink-800;
      font-weight: 500;
    }

    .check-icon {
      font-size: 32rpx;
      color: $color-primary;
      font-weight: 700;
    }
  }
}

// 优惠券卡片
.coupon-card {
  display: flex;
  align-items: stretch;
  background: $bg-card;
  border-radius: $radius-lg;
  margin-bottom: 20rpx;
  overflow: hidden;
  box-shadow: $shadow-sm;
  border: 2rpx solid transparent;
  position: relative;
  transition: all $duration-fast $ease-out-quart;

  &:active {
    transform: scale(0.98);
  }

  &.coupon-available {
    background: linear-gradient(135deg, #FFF8F2 0%, #FFFFFF 60%);
  }

  &.coupon-unavailable {
    background: $neutral-50;
    opacity: 0.65;
  }

  &.coupon-selected {
    border-color: $color-primary;
    box-shadow: 0 8rpx 20rpx rgba(255, 106, 0, 0.2);
  }
}

.coupon-left {
  width: 200rpx;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 28rpx 16rpx;
  background: linear-gradient(135deg, #FFF3E8 0%, #FFE0C7 100%);
}

.coupon-unavailable .coupon-left {
  background: $neutral-100;
}

.coupon-amount {
  display: flex;
  align-items: baseline;
  color: $color-primary-danger;
  margin-bottom: 8rpx;

  .amount-symbol {
    font-size: 22rpx;
    font-weight: 600;
  }

  .amount-value {
    font-size: 52rpx;
    font-weight: 700;
    line-height: 1;
  }
}

.coupon-condition {
  font-size: 20rpx;
  color: $color-primary-danger;
}

.coupon-unavailable .coupon-amount,
.coupon-unavailable .coupon-condition {
  color: $text-weak;
}

// 分隔线
.coupon-divider {
  width: 2rpx;
  position: relative;

  .circle-top,
  .circle-bottom {
    position: absolute;
    left: 50%;
    transform: translateX(-50%);
    width: 20rpx;
    height: 20rpx;
    border-radius: 50%;
    background: $bg-page;
  }

  .circle-top { top: -10rpx; }
  .circle-bottom { bottom: -10rpx; }

  .dashed-line {
    position: absolute;
    top: 10rpx;
    bottom: 10rpx;
    left: 50%;
    transform: translateX(-50%);
    width: 0;
    border-left: 2rpx dashed rgba(255, 106, 0, 0.25);
  }
}

.coupon-unavailable .coupon-divider .dashed-line {
  border-left-color: $neutral-300;
}

// 右侧信息区
.coupon-right {
  flex: 1;
  padding: 20rpx 24rpx;
  display: flex;
  flex-direction: column;
  justify-content: center;
  min-width: 0;
  position: relative;
}

.coupon-title {
  font-size: 28rpx;
  font-weight: 600;
  color: $ink-900;
  margin-bottom: 6rpx;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.coupon-type {
  font-size: 22rpx;
  color: $text-sub;
  margin-bottom: 6rpx;
}

.coupon-validity {
  font-size: 20rpx;
  color: $text-weak;
}

.coupon-reason {
  font-size: 20rpx;
  color: $color-primary-danger;
  margin-top: 6rpx;
}

// 推荐标签
.recommend-tag {
  position: absolute;
  top: 16rpx;
  right: 16rpx;
  padding: 2rpx 10rpx;
  background: $gradient-warm;
  border-radius: $radius-sm;
  box-shadow: 0 2rpx 6rpx rgba(255, 106, 0, 0.3);

  text {
    font-size: 18rpx;
    color: #FFFFFF;
    font-weight: 600;
  }
}

// 选中标记
.selected-mark {
  position: absolute;
  top: 50%;
  right: 24rpx;
  transform: translateY(-50%);

  .check-icon-circle {
    display: flex;
    align-items: center;
    justify-content: center;
    width: 44rpx;
    height: 44rpx;
    border-radius: 50%;
    background: $gradient-warm;
    color: #FFFFFF;
    font-size: 26rpx;
    font-weight: 700;
    box-shadow: 0 4rpx 10rpx rgba(255, 106, 0, 0.35);
  }
}

// ============ 底部按钮 ============
.bottom-bar {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  padding: 16rpx 24rpx calc(16rpx + env(safe-area-inset-bottom));
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(40rpx);
  -webkit-backdrop-filter: blur(40rpx);
  box-shadow: 0 -4rpx 16rpx rgba(0, 0, 0, 0.04);
  z-index: 100;
}

.confirm-btn {
  height: 88rpx;
  border-radius: $radius-full;
  background: $gradient-warm;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: $shadow-primary;
  transition: all $duration-fast $ease-out-quart;

  &:active {
    transform: scale(0.98);
  }

  &.confirm-btn-disabled {
    background: $neutral-300;
    box-shadow: none;
  }

  .confirm-btn-text {
    color: #FFFFFF;
    font-size: 30rpx;
    font-weight: 600;
    letter-spacing: 1rpx;
  }
}

// ============ 安全区 ============
.safe-bottom {
  height: 40rpx;
}
</style>
