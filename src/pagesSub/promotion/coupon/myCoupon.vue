<template>
  <view class="page-my-coupon">
    <!-- 自定义导航栏 -->
    <view class="nav-bar" :style="{ paddingTop: statusBarHeight + 'px' }">
      <view class="nav-back" @click="handleBack">
        <text class="back-icon">‹</text>
      </view>
      <text class="nav-title">我的优惠券</text>
      <view class="nav-placeholder-right"></view>
    </view>
    <view class="nav-placeholder" :style="{ height: (statusBarHeight + 44) + 'px' }"></view>

    <!-- 状态 Tab 栏 -->
    <view class="tabs-bar">
      <view class="tabs-inner">
        <view
          v-for="tab in statusTabs"
          :key="tab.value"
          class="tab-item"
          :class="{ 'tab-active': activeStatus === tab.value }"
          @click="switchTab(tab.value)"
        >
          <text class="tab-text">{{ tab.label }}</text>
          <view v-if="activeStatus === tab.value" class="tab-indicator"></view>
        </view>
      </view>
    </view>

    <!-- 优惠券列表 -->
    <scroll-view
      scroll-y
      class="coupon-scroll"
      :refresher-enabled="true"
      :refresher-triggered="refreshing"
      @refresherrefresh="onRefresh"
      @scrolltolower="onLoadMore"
    >
      <!-- 加载中(首次) -->
      <view v-if="loading && couponList.length === 0" class="loading-state">
        <view class="loading-spinner"></view>
        <text class="loading-text">加载中...</text>
      </view>

      <!-- 空状态 -->
      <view v-else-if="couponList.length === 0" class="empty-state">
        <text class="empty-icon">🎫</text>
        <text class="empty-title">暂无优惠券</text>
        <text class="empty-desc">{{ emptyDesc }}</text>
        <view class="empty-btn" @click="goGetCoupon">
          <text>去领券</text>
        </view>
      </view>

      <!-- 优惠券列表 -->
      <view v-else class="coupon-list">
        <view
          v-for="coupon in couponList"
          :key="coupon.couponUserId"
          class="coupon-card"
          :class="[
            getCouponStatusClass(coupon.status),
            { 'coupon-disabled': !isCouponUsable(coupon) }
          ]"
          @click="handleCouponClick(coupon)"
        >
          <!-- 左侧金额区 -->
          <view class="coupon-left">
            <view class="coupon-amount">
              <text class="amount-symbol">¥</text>
              <text class="amount-value">{{ coupon.discountAmount }}</text>
            </view>
            <text class="coupon-condition">满{{ coupon.minConsume }}可用</text>
            <!-- 已使用/已过期标记 -->
            <view v-if="!isCouponUsable(coupon)" class="coupon-stamp">
              <text class="stamp-text">{{ coupon.statusText }}</text>
            </view>
          </view>

          <!-- 分隔线(带剪角) -->
          <view class="coupon-divider">
            <view class="circle-top"></view>
            <view class="dashed-line"></view>
            <view class="circle-bottom"></view>
          </view>

          <!-- 右侧信息区 -->
          <view class="coupon-right">
            <view class="coupon-source-row">
              <text class="coupon-source-tag" :class="coupon.source === 'PLATFORM' ? 'source-platform' : 'source-merchant'">
                {{ coupon.sourceText }}
              </text>
              <text v-if="coupon.merchantName" class="coupon-merchant">{{ coupon.merchantName }}</text>
            </view>
            <text class="coupon-title">{{ coupon.title }}</text>
            <text class="coupon-type">{{ coupon.typeText || '满减券' }}</text>
            <view class="coupon-validity">
              <text class="validity-text">有效期：{{ formatValidity(coupon) }}</text>
            </view>
            <view v-if="isCouponUsable(coupon)" class="coupon-use-btn" @click.stop="goUseCoupon(coupon)">
              <text class="use-btn-text">去使用</text>
            </view>
          </view>
        </view>

        <!-- 加载更多 -->
        <view v-if="couponList.length > 0" class="load-more">
          <text v-if="loading" class="load-more-text">加载中...</text>
          <text v-else-if="hasMore" class="load-more-text">上拉加载更多</text>
          <text v-else class="load-more-text">没有更多了</text>
        </view>
      </view>

      <!-- 底部安全区 -->
      <view class="safe-bottom"></view>
    </scroll-view>
  </view>
</template>

<script setup>
import { ref, computed } from 'vue'
import { onLoad, onShow, onUnload } from '@dcloudio/uni-app'
import { useCoupon } from '@/hooks/useCoupon'
import {
  COUPON_TABS,
  COUPON_STATUS,
  getCouponStatusClass,
  isCouponUsable
} from '@/constants/coupon'

const {
  couponStore,
  loading,
  refreshing,
  loadMyCoupons,
  goUseCoupon,
  resetCouponData
} = useCoupon()

const statusBarHeight = uni.getSystemInfoSync().statusBarHeight || 20

// 状态 Tab
const statusTabs = COUPON_TABS
const activeStatus = ref(COUPON_STATUS.UNUSED)

// 筛选参数(支持 onLoad 传入)
const filterSource = ref('')
const filterMerchantId = ref(null)

// 分页
const currentPage = ref(1)
const pageSize = 10

// 优惠券列表(从 store 获取)
const couponList = computed(() => couponStore.myCouponList)

// 是否还有更多
const hasMore = computed(() => currentPage.value < couponStore.couponPages)

// 空状态文案
const emptyDesc = computed(() => {
  if (activeStatus.value === COUPON_STATUS.UNUSED) return '暂无可用优惠券，快去领取吧'
  if (activeStatus.value === COUPON_STATUS.USED) return '暂无已使用的优惠券'
  if (activeStatus.value === COUPON_STATUS.EXPIRED) return '暂无已过期的优惠券'
  return '暂无优惠券'
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
  uni.navigateBack({
    delta: 1,
    animationType: 'slide-out-right',
    animationDuration: 200
  })
}

// 切换状态 Tab
const switchTab = (status) => {
  if (activeStatus.value === status) return
  activeStatus.value = status
  currentPage.value = 1
  fetchCoupons(false)
}

// 拉取优惠券列表
const fetchCoupons = async (isLoadMore = false) => {
  if (loading.value && !isLoadMore) return
  const params = {
    status: activeStatus.value,
    page: currentPage.value,
    pageSize
  }
  if (filterSource.value) {
    params.source = filterSource.value
  }
  if (filterMerchantId.value) {
    params.merchantId = filterMerchantId.value
  }
  await loadMyCoupons(params, isLoadMore)
}

// 下拉刷新
const onRefresh = async () => {
  refreshing.value = true
  currentPage.value = 1
  await fetchCoupons(false)
  refreshing.value = false
}

// 上拉加载更多
const onLoadMore = () => {
  if (loading.value || !hasMore.value) return
  currentPage.value++
  fetchCoupons(true)
}

// 点击优惠券(查看详情)
const handleCouponClick = (coupon) => {
  if (!coupon) return
  const lines = [
    `优惠券：${coupon.title || ''}`,
    `来源：${coupon.sourceText || ''}`,
    coupon.merchantName ? `商家：${coupon.merchantName}` : '',
    `门槛：满 ${coupon.minConsume || 0} 元可用`,
    `优惠：减 ${coupon.discountAmount || 0} 元`,
    `有效期：${formatValidity(coupon)}`,
    `状态：${coupon.statusText || ''}`,
    coupon.receiveTime ? `领取时间：${coupon.receiveTime}` : '',
    coupon.useTime ? `使用时间：${coupon.useTime}` : ''
  ].filter(Boolean)
  uni.showModal({
    title: '优惠券详情',
    content: lines.join('\n'),
    showCancel: false,
    confirmText: '我知道了'
  })
}

// 去领券(跳转优惠券中心)
const goGetCoupon = () => {
  uni.navigateTo({
    url: '/pagesSub/promotion/coupon/couponCenter',
    animationType: 'slide-in-right',
    animationDuration: 200
  })
}

// 页面加载(解析参数)
onLoad((options) => {
  if (options?.status !== undefined && options?.status !== '') {
    activeStatus.value = Number(options.status)
  }
  if (options?.source) {
    filterSource.value = options.source
  }
  if (options?.merchantId) {
    filterMerchantId.value = options.merchantId
  }
})

// 页面显示(首次加载数据)
onShow(() => {
  if (couponStore.myCouponList.length === 0 || refreshing.value) {
    currentPage.value = 1
    fetchCoupons(false)
  }
})

// 页面卸载时清理数据
onUnload(() => {
  resetCouponData()
})
</script>

<style lang="scss" scoped>
.page-my-coupon {
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

// ============ Tab 栏 ============
.tabs-bar {
  background: $bg-card;
  box-shadow: $shadow-xs;
  position: relative;
  z-index: 2;
}

.tabs-inner {
  display: flex;
  align-items: center;
  height: 88rpx;
  padding: 0 24rpx;
}

.tab-item {
  flex: 1;
  height: 100%;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  position: relative;
  transition: all $duration-fast $ease-out-quart;

  .tab-text {
    font-size: 28rpx;
    color: $text-sub;
    font-weight: 500;
    transition: all $duration-fast $ease-out-quart;
  }

  &.tab-active {
    .tab-text {
      color: $color-primary;
      font-weight: 700;
      font-size: 30rpx;
    }
  }

  .tab-indicator {
    position: absolute;
    bottom: 8rpx;
    width: 48rpx;
    height: 6rpx;
    border-radius: $radius-full;
    background: $gradient-warm;
    box-shadow: 0 2rpx 6rpx rgba(255, 106, 0, 0.4);
  }
}

// ============ 滚动容器 ============
.coupon-scroll {
  flex: 1;
  height: 0;
  transform: translateZ(0);
  -webkit-overflow-scrolling: touch;
}

// ============ 加载状态 ============
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

// ============ 空状态 ============
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
    margin-bottom: 48rpx;
  }

  .empty-btn {
    padding: 18rpx 56rpx;
    background: $gradient-warm;
    border-radius: $radius-full;
    box-shadow: $shadow-primary;
    transition: all $duration-fast $ease-out-quart;

    &:active {
      transform: scale(0.96);
      box-shadow: $shadow-sm;
    }

    text {
      color: #FFFFFF;
      font-size: 26rpx;
      font-weight: 600;
    }
  }
}

// ============ 优惠券卡片 ============
.coupon-list {
  padding: 20rpx 24rpx;
}

.coupon-card {
  display: flex;
  align-items: stretch;
  background: $bg-card;
  border-radius: $radius-lg;
  margin-bottom: 20rpx;
  overflow: hidden;
  box-shadow: $shadow-sm;
  transition: all $duration-base $ease-out-quart;
  position: relative;

  &:active {
    transform: scale(0.98);
    box-shadow: $shadow-md;
  }

  // 状态样式
  &.status-unused {
    background: linear-gradient(135deg, #FFF8F2 0%, #FFFFFF 60%);
  }

  &.status-used,
  &.status-expired {
    background: $neutral-50;
    opacity: 0.85;
  }

  &.coupon-disabled {
    .coupon-left .coupon-amount,
    .coupon-left .coupon-condition {
      color: $text-weak;
    }
  }
}

// 左侧金额区
.coupon-left {
  width: 220rpx;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 32rpx 16rpx;
  position: relative;
  background: linear-gradient(135deg, #FFF3E8 0%, #FFE0C7 100%);
}

.status-used .coupon-left,
.status-expired .coupon-left {
  background: $neutral-100;
}

.coupon-amount {
  display: flex;
  align-items: baseline;
  color: $color-primary-danger;
  margin-bottom: 8rpx;

  .amount-symbol {
    font-size: 24rpx;
    font-weight: 600;
  }

  .amount-value {
    font-size: 60rpx;
    font-weight: 700;
    line-height: 1;
    letter-spacing: -1rpx;
  }
}

.coupon-condition {
  font-size: 22rpx;
  color: $color-primary-danger;
}

// 已使用/已过期印章
.coupon-stamp {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%) rotate(-15deg);
  border: 4rpx solid $text-weak;
  border-radius: $radius-md;
  padding: 4rpx 16rpx;
  opacity: 0.7;

  .stamp-text {
    font-size: 24rpx;
    color: $text-weak;
    font-weight: 700;
  }
}

// 分隔线
.coupon-divider {
  width: 2rpx;
  position: relative;
  background: transparent;

  .circle-top,
  .circle-bottom {
    position: absolute;
    left: 50%;
    transform: translateX(-50%);
    width: 24rpx;
    height: 24rpx;
    border-radius: 50%;
    background: $bg-page;
  }

  .circle-top {
    top: -12rpx;
  }

  .circle-bottom {
    bottom: -12rpx;
  }

  .dashed-line {
    position: absolute;
    top: 12rpx;
    bottom: 12rpx;
    left: 50%;
    transform: translateX(-50%);
    width: 0;
    border-left: 2rpx dashed rgba(255, 106, 0, 0.25);
  }
}

.status-used .coupon-divider .dashed-line,
.status-expired .coupon-divider .dashed-line {
  border-left-color: $neutral-300;
}

// 右侧信息区
.coupon-right {
  flex: 1;
  padding: 24rpx 24rpx;
  display: flex;
  flex-direction: column;
  justify-content: center;
  min-width: 0;
}

.coupon-source-row {
  display: flex;
  align-items: center;
  margin-bottom: 10rpx;

  .coupon-source-tag {
    font-size: 20rpx;
    padding: 2rpx 12rpx;
    border-radius: $radius-sm;
    font-weight: 500;
    margin-right: 12rpx;

    &.source-platform {
      background: rgba(255, 106, 0, 0.12);
      color: $color-primary;
    }

    &.source-merchant {
      background: rgba(46, 196, 105, 0.12);
      color: #2EC469;
    }
  }

  .coupon-merchant {
    font-size: 22rpx;
    color: $text-sub;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
    max-width: 280rpx;
  }
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
  margin-bottom: 8rpx;
}

.coupon-validity {
  .validity-text {
    font-size: 20rpx;
    color: $text-weak;
  }
}

// 去使用按钮
.coupon-use-btn {
  align-self: flex-end;
  margin-top: 8rpx;
  padding: 8rpx 24rpx;
  background: $gradient-warm;
  border-radius: $radius-full;
  box-shadow: 0 4rpx 10rpx rgba(255, 106, 0, 0.25);
  transition: all $duration-fast $ease-out-quart;

  &:active {
    transform: scale(0.94);
  }

  .use-btn-text {
    font-size: 22rpx;
    color: #FFFFFF;
    font-weight: 600;
  }
}

// ============ 加载更多 ============
.load-more {
  text-align: center;
  padding: 32rpx 0;

  .load-more-text {
    font-size: 24rpx;
    color: $text-weak;
  }
}

// ============ 安全区 ============
.safe-bottom {
  height: constant(safe-area-inset-bottom);
  height: env(safe-area-inset-bottom);
  min-height: 40rpx;
}
</style>
