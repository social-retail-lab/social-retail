<template>
  <view class="page-container">
    <view class="pay-header">
      <view class="header-left" @click="handleBack">
        <text class="back-icon">‹</text>
      </view>
      <text class="header-title">订单支付</text>
      <view class="header-right"></view>
    </view>

    <scroll-view scroll-y class="page-content">
      <view class="order-info-card">
        <view class="order-info-top">
          <text class="order-label">订单编号</text>
          <text class="order-sn">{{ orderSn || '-' }}</text>
        </view>
        <view class="order-info-bottom">
          <text class="order-label">下单时间</text>
          <text class="order-time">{{ createTime || '-' }}</text>
        </view>
      </view>

      <view class="amount-card">
        <view class="amount-label">支付金额</view>
        <view class="amount-value-wrap">
          <text class="amount-symbol">¥</text>
          <text class="amount-value">{{ displayPayAmount }}</text>
        </view>
        <view v-if="expireTime" class="expire-info">
          <text class="expire-icon">⏱</text>
          <text v-if="isExpired" class="expire-text">支付已过期</text>
          <text v-else class="expire-text">剩余支付时间 <text class="expire-time">{{ countdownText }}</text></text>
        </view>
      </view>

      <view class="payment-section">
        <view class="section-header">
          <text class="section-title">支付方式</text>
        </view>
        <view class="payment-options">
          <view
            class="payment-option"
            :class="{ 'payment-active': paymentType === 'ALIPAY' }"
            @click="paymentType = 'ALIPAY'"
          >
            <view class="option-icon-wrap">
              <text class="option-icon">🔷</text>
            </view>
            <view class="option-info">
              <text class="option-text">支付宝支付</text>
              <text class="option-desc">沙箱环境</text>
            </view>
            <view class="option-check">
              <view v-if="paymentType === 'ALIPAY'" class="check-dot"></view>
            </view>
          </view>
          <view
            class="payment-option"
            :class="{ 'payment-active': paymentType === 'MOCK' }"
            @click="paymentType = 'MOCK'"
          >
            <view class="option-icon-wrap">
              <text class="option-icon">🧪</text>
            </view>
            <view class="option-info">
              <text class="option-text">模拟支付</text>
              <text class="option-desc">测试快速完成支付</text>
            </view>
            <view class="option-check">
              <view v-if="paymentType === 'MOCK'" class="check-dot"></view>
            </view>
          </view>
        </view>
      </view>

      <view class="goods-section">
        <view class="section-header">
          <text class="section-title">商品信息</text>
        </view>
        <view class="goods-list">
          <view
            v-for="item in orderItems"
            :key="item.orderItemId || item.cartItemId"
            class="goods-item"
          >
            <image :src="getValidImageUrl(item.productImage)" class="goods-image" mode="aspectFill" />
            <view class="goods-info">
              <text class="goods-name">{{ item.productName }}</text>
              <text class="goods-sku">{{ item.skuSpecs }}</text>
              <view class="goods-bottom">
                <text class="goods-price">¥{{ formatItemPrice(item.finalPrice) }}</text>
                <text class="goods-count">×{{ item.quantity }}</text>
              </view>
            </view>
          </view>
        </view>
      </view>
    </scroll-view>

    <view class="pay-footer">
      <view class="footer-left">
        <text class="footer-label">合计：</text>
        <text class="footer-amount">¥{{ displayPayAmount }}</text>
      </view>
      <view
        class="pay-btn"
        :class="{ 'btn-disabled': isPaying, 'btn-expired': isExpired }"
        @click="handlePay"
      >
        <text>{{ buttonText }}</text>
      </view>
    </view>
  </view>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { onHide, onShow, onBackPress } from '@dcloudio/uni-app'
import { showToast, getValidImageUrl } from '@/utils/common'
import { useOrder } from '@/hooks/useOrder'

const orderHook = useOrder()

const orderId = ref('')
const orderSn = ref('')
const payAmount = ref(0)
const expireTime = ref('')
const createTime = ref('')

const paymentType = ref('ALIPAY')
const isPaying = ref(false)
const remainSeconds = ref(0)

const orderItems = ref([])
const paymentId = ref(null)

// 标记是否已跳转到支付宝，用于检测返回
const hasRedirectedToAlipay = ref(false)

// 用于保存 H5 事件监听器的清理函数
const _cleanupListeners = ref(null)

let pollTimer = null
let countdownTimer = null

const isExpired = computed(() => remainSeconds.value <= 0)

const displayPayAmount = computed(() => (Number(payAmount.value) || 0).toFixed(2))

const countdownText = computed(() => {
  const total = remainSeconds.value
  if (total <= 0) return '00:00'
  const hours = Math.floor(total / 3600)
  const minutes = Math.floor((total % 3600) / 60)
  const seconds = total % 60
  const pad = (n) => n.toString().padStart(2, '0')
  if (hours > 0) return `${pad(hours)}:${pad(minutes)}:${pad(seconds)}`
  return `${pad(minutes)}:${pad(seconds)}`
})

const buttonText = computed(() => {
  if (isExpired.value) return '支付已过期'
  if (isPaying.value) return '支付中...'
  return '立即支付'
})

const formatItemPrice = (price) => (Number(price) || 0).toFixed(2)

const parseExpireDate = (val) => {
  if (!val) return null
  if (/^\d+$/.test(String(val).trim())) {
    return new Date(Number(val))
  }
  return new Date(val)
}

const handleBack = () => {
  uni.showModal({
    title: '确认离开',
    content: '支付未完成，确定要离开吗？',
    confirmText: '离开',
    cancelText: '继续支付',
    success: (res) => {
      if (res.confirm) {
        stopAllTimers()
        // 安全返回:优先 navigateBack,失败则回退到订单详情或首页
        const pages = getCurrentPages()
        if (pages.length > 1) {
          uni.navigateBack({
            fail: () => {
              // 页面栈异常,跳转订单详情页
              if (orderId.value) {
                uni.redirectTo({ url: '/pagesSub/order/orderDetail?orderId=' + orderId.value })
              } else {
                uni.switchTab({ url: '/pages/index/index' })
              }
            }
          })
        } else {
          // 页面栈只有当前页,跳转订单详情或首页
          if (orderId.value) {
            uni.redirectTo({ url: '/pagesSub/order/orderDetail?orderId=' + orderId.value })
          } else {
            uni.switchTab({ url: '/pages/index/index' })
          }
        }
      }
    }
  })
}

// 拦截系统返回键(防止返回键直接跳过弹窗确认)
onBackPress(() => {
  handleBack()
  return true // 阻止默认返回行为
})

const startCountdown = () => {
  if (countdownTimer) {
    clearInterval(countdownTimer)
    countdownTimer = null
  }
  if (!expireTime.value) return
  const expireDate = parseExpireDate(expireTime.value)
  if (!expireDate || isNaN(expireDate.getTime())) return

  const update = () => {
    const remain = Math.floor((expireDate.getTime() - Date.now()) / 1000)
    remainSeconds.value = remain > 0 ? remain : 0
    if (remainSeconds.value <= 0 && countdownTimer) {
      clearInterval(countdownTimer)
      countdownTimer = null
    }
  }
  update()
  countdownTimer = setInterval(update, 1000)
}

const stopPolling = () => {
  if (pollTimer) {
    clearInterval(pollTimer)
    pollTimer = null
  }
}

const stopAllTimers = () => {
  stopPolling()
  if (countdownTimer) {
    clearInterval(countdownTimer)
    countdownTimer = null
  }
}

const startPolling = () => {
  if (pollTimer) return
  if (!orderId.value) return
  // 支付后每3秒轮询支付状态
  pollTimer = setInterval(pollPayStatus, 3000)
}

const redirectToDetail = () => {
  uni.redirectTo({ url: '/pagesSub/order/orderDetail?orderId=' + orderId.value })
}

// 轮询支付状态（使用支付状态查询接口）
const pollPayStatus = async () => {
  if (!orderId.value) return
  const statusData = await orderHook.loadPayStatus(orderId.value)
  if (!statusData) return

  // 支付成功
  if (statusData.payStatus === 'PAID') {
    stopAllTimers()
    showToast('支付成功')
    setTimeout(redirectToDetail, 1500)
    return
  }

  // 支付失败
  if (statusData.payStatus === 'FAILED') {
    stopAllTimers()
    showToast('支付失败，请重试')
    isPaying.value = false
    return
  }

  // 订单状态已离开待支付（兼容旧轮询逻辑）
  if (statusData.orderStatus && statusData.orderStatus !== 'WAIT_PAY') {
    stopAllTimers()
    showToast('支付成功')
    setTimeout(redirectToDetail, 1500)
  }
}

const fetchOrderDetailData = async () => {
  if (!orderId.value) return false
  const data = await orderHook.loadOrderDetail(orderId.value)
  if (!data) return true

  orderItems.value = data.itemList || []
  if (data.orderSn) orderSn.value = data.orderSn
  if (data.payAmount !== undefined) payAmount.value = Number(data.payAmount) || 0
  if (data.payExpireTime) expireTime.value = data.payExpireTime
  createTime.value = data.createTime || ''

  // 订单已脱离待支付状态，直接跳转详情页
  if (data.status && data.status !== 'WAIT_PAY') {
    stopAllTimers()
    redirectToDetail()
    return false
  }
  return true
}

// H5 环境跳转支付宝沙箱支付
const redirectAlipayH5 = (payPayload) => {
  // #ifdef H5
  // 支付宝沙箱返回的是 form HTML，需要写入页面自动提交
  const div = document.createElement('div')
  div.style.display = 'none'
  div.innerHTML = payPayload
  document.body.appendChild(div)
  // 自动提交表单跳转到支付宝
  const form = div.querySelector('form')
  if (form) {
    form.submit()
  } else {
    // 如果不是 form 而是 URL，直接跳转
    window.location.href = payPayload
  }
  // 标记已跳转，用于检测返回
  hasRedirectedToAlipay.value = true
  // 跳转后启动轮询，用户支付完成后回来时检测状态
  startPolling()
  // #endif

  // #ifndef H5
  // 非 H5 环境暂不支持支付宝跳转，提示用户使用模拟支付
  showToast('当前环境暂不支持支付宝跳转，请使用模拟支付')
  // #endif
}

const handlePay = async () => {
  if (isPaying.value || isExpired.value) return
  isPaying.value = true

  if (paymentType.value === 'ALIPAY') {
    // 支付宝沙箱支付
    uni.showLoading({ title: '正在创建支付...', mask: true })

    try {
      const payData = await orderHook.createAlipay(orderId.value, 'WAP')

      uni.hideLoading()

      if (!payData) {
        isPaying.value = false
        return
      }

      // 保存支付流水ID
      paymentId.value = payData.paymentId

      // 跳转支付宝沙箱支付页面
      if (payData.payPayload) {
        redirectAlipayH5(payData.payPayload)
      } else {
        showToast('支付创建异常，请重试')
        isPaying.value = false
      }
    } catch (error) {
      uni.hideLoading()
      isPaying.value = false
    }
  } else if (paymentType.value === 'MOCK') {
    // 模拟支付成功
    uni.showLoading({ title: '模拟支付中...', mask: true })

    try {
      const result = await orderHook.mockPaySuccess(orderId.value, payAmount.value)

      uni.hideLoading()

      if (result && result.payStatus === 'PAID') {
        stopAllTimers()
        showToast('支付成功')
        setTimeout(redirectToDetail, 1500)
      } else {
        isPaying.value = false
      }
    } catch (error) {
      uni.hideLoading()
      isPaying.value = false
    }
  }
}

// 检查支付状态（从支付宝返回时调用）
const checkPayStatusOnReturn = async () => {
  // 只有已跳转到支付宝的情况才需要检查
  if (!hasRedirectedToAlipay.value) return
  if (!orderId.value) return

  // 先调用一次支付状态查询
  const statusData = await orderHook.loadPayStatus(orderId.value)
  if (!statusData) {
    // 查询失败，启动轮询继续尝试
    startPolling()
    return
  }

  // 支付成功
  if (statusData.payStatus === 'PAID') {
    stopAllTimers()
    showToast('支付成功')
    setTimeout(redirectToDetail, 1500)
    return
  }

  // 支付失败
  if (statusData.payStatus === 'FAILED') {
    stopAllTimers()
    showToast('支付失败，请重试')
    isPaying.value = false
    hasRedirectedToAlipay.value = false
    return
  }

  // 订单状态已离开待支付（兼容旧逻辑）
  if (statusData.orderStatus && statusData.orderStatus !== 'WAIT_PAY') {
    stopAllTimers()
    showToast('支付成功')
    setTimeout(redirectToDetail, 1500)
    return
  }

  // 仍未支付，启动轮询等待
  startPolling()
}

onMounted(async () => {
  const pages = getCurrentPages()
  const currentPage = pages[pages.length - 1]
  const options = currentPage.$page?.options || currentPage.options || {}

  if (options.orderId) orderId.value = options.orderId
  if (options.orderSn) orderSn.value = options.orderSn
  if (options.payAmount) payAmount.value = Number(options.payAmount) || 0
  if (options.expireTime) expireTime.value = decodeURIComponent(options.expireTime)

  const stay = await fetchOrderDetailData()
  if (stay === false) return

  // 只启动倒计时
  startCountdown()

  // #ifdef H5
  // 监听 pageshow 事件（用户从支付宝返回时触发，包括 bfcache 恢复）
  const handlePageShow = (event) => {
    // event.persisted 为 true 表示从 bfcache 恢复（浏览器前进/后退）
    if (event.persisted || hasRedirectedToAlipay.value) {
      checkPayStatusOnReturn()
    }
  }

  // 监听 visibilitychange 事件（页面从隐藏变为可见）
  const handleVisibilityChange = () => {
    if (document.visibilityState === 'visible' && hasRedirectedToAlipay.value) {
      // 延迟一点，确保页面已完全恢复
      setTimeout(checkPayStatusOnReturn, 300)
    }
  }

  window.addEventListener('pageshow', handlePageShow)
  window.addEventListener('visibilitychange', handleVisibilityChange)

  // 保存引用以便卸载时移除
  _cleanupListeners.value = () => {
    window.removeEventListener('pageshow', handlePageShow)
    window.removeEventListener('visibilitychange', handleVisibilityChange)
  }

  // 如果通过浏览器前进/后退返回（非首次加载）
  if (window.performance) {
    const navEntries = performance.getEntriesByType('navigation')
    if (navEntries.length > 0 && navEntries[0].type === 'back_forward') {
      // 从支付宝返回，检查支付状态
      hasRedirectedToAlipay.value = true
      checkPayStatusOnReturn()
    }
  }
  // #endif
})

// uni-app onShow 生命周期（页面从后台到前台时触发）
onShow(() => {
  // #ifdef H5
  if (hasRedirectedToAlipay.value) {
    checkPayStatusOnReturn()
  }
  // #endif
})

// 页面隐藏时停止轮询
onHide(() => {
  stopPolling()
})

onUnmounted(() => {
  stopAllTimers()
  // #ifdef H5
  if (_cleanupListeners.value) {
    _cleanupListeners.value()
  }
  // #endif
})
</script>

<style lang="scss" scoped>
.page-container {
  min-height: 100vh;
  background: $bg-page;
  display: flex;
  flex-direction: column;
}

.pay-header {
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

  .header-left, .header-right {
    width: 80rpx;
    display: flex;
    align-items: center;
    justify-content: center;
  }

  .back-icon {
    font-size: 56rpx;
    color: $text-main;
  }

  .header-title {
    font-size: 36rpx;
    font-weight: 600;
    color: $text-main;
  }
}

.page-content {
  flex: 1;
  padding-top: calc(88rpx + env(safe-area-inset-top));
  padding-bottom: calc(140rpx + env(safe-area-inset-bottom));
}

.order-info-card {
  margin: 24rpx;
  padding: 24rpx;
  background: $bg-card;
  border-radius: 24rpx;

  .order-info-top, .order-info-bottom {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 12rpx 0;

    &:not(:last-child) {
      border-bottom: 1rpx solid $bg-page-light;
    }

    .order-label {
      font-size: 28rpx;
      color: $text-sub;
    }

    .order-sn {
      font-size: 28rpx;
      color: $text-main;
      font-weight: 500;
      font-family: monospace;
    }

    .order-time {
      font-size: 28rpx;
      color: $text-main;
    }
  }
}

.amount-card {
  margin: 24rpx;
  padding: 48rpx 32rpx;
  background: linear-gradient(135deg, $color-primary 0%, $color-primary-danger 100%);
  border-radius: 24rpx;
  text-align: center;

  .amount-label {
    display: block;
    font-size: 28rpx;
    color: rgba(255, 255, 255, 0.8);
    margin-bottom: 16rpx;
  }

  .amount-value-wrap {
    display: flex;
    align-items: baseline;
    justify-content: center;

    .amount-symbol {
      font-size: 40rpx;
      color: #FFFFFF;
      font-weight: 600;
    }

    .amount-value {
      font-size: 72rpx;
      color: #FFFFFF;
      font-weight: 700;
    }
  }

  .expire-info {
    display: flex;
    align-items: center;
    justify-content: center;
    margin-top: 24rpx;

    .expire-icon {
      font-size: 28rpx;
      margin-right: 8rpx;
    }

    .expire-text {
      font-size: 24rpx;
      color: rgba(255, 255, 255, 0.8);

      .expire-time {
        color: #FFFFFF;
        font-weight: 600;
      }
    }
  }
}

.payment-section {
  margin: 24rpx;
  background: $bg-card;
  border-radius: 24rpx;
  overflow: hidden;

  .section-header {
    padding: 24rpx;
    border-bottom: 1rpx solid $bg-page-light;

    .section-title {
      font-size: 30rpx;
      font-weight: 600;
      color: $text-main;
    }
  }

  .payment-options {
    padding: 16rpx 24rpx;

    .payment-option {
      display: flex;
      align-items: center;
      padding: 24rpx 0;
      border-bottom: 1rpx solid $bg-page-light;

      &:last-child {
        border-bottom: none;
      }

      &.payment-active {
        .option-icon-wrap {
          background: rgba($color-primary, 0.1);
        }

        .option-check {
          border-color: $color-primary;

          .check-dot {
            background: $color-primary;
          }
        }
      }

      .option-icon-wrap {
        width: 72rpx;
        height: 72rpx;
        border-radius: 16rpx;
        background: $bg-page-light;
        display: flex;
        align-items: center;
        justify-content: center;
        margin-right: 20rpx;

        .option-icon {
          font-size: 40rpx;
        }
      }

      .option-info {
        flex: 1;
        display: flex;
        flex-direction: column;

        .option-text {
          font-size: 32rpx;
          color: $text-main;
        }

        .option-desc {
          font-size: 22rpx;
          color: $text-weak;
          margin-top: 4rpx;
        }
      }

      .option-check {
        width: 40rpx;
        height: 40rpx;
        border: 2rpx solid #CCCCCC;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;

        .check-dot {
          width: 24rpx;
          height: 24rpx;
          border-radius: 50%;
          background: #CCCCCC;
        }
      }
    }
  }
}

.goods-section {
  margin: 24rpx;
  background: $bg-card;
  border-radius: 24rpx;
  overflow: hidden;

  .section-header {
    padding: 24rpx;
    border-bottom: 1rpx solid $bg-page-light;

    .section-title {
      font-size: 30rpx;
      font-weight: 600;
      color: $text-main;
    }
  }

  .goods-list {
    padding: 16rpx;
  }

  .goods-item {
    display: flex;
    padding: 16rpx 0;
    border-bottom: 1rpx solid $bg-page-light;

    &:last-child {
      border-bottom: none;
    }

    .goods-image {
      width: 160rpx;
      height: 160rpx;
      border-radius: 16rpx;
      margin-right: 20rpx;
      background: $bg-page-light;
    }

    .goods-info {
      flex: 1;
      display: flex;
      flex-direction: column;
      justify-content: space-between;

      .goods-name {
        font-size: 26rpx;
        color: $text-main;
        line-height: 1.4;
        display: -webkit-box;
        -webkit-line-clamp: 2;
        line-clamp: 2;
        -webkit-box-orient: vertical;
        overflow: hidden;
        text-overflow: ellipsis;
      }

      .goods-sku {
        font-size: 22rpx;
        color: $text-weak;
        margin-top: 8rpx;
      }

      .goods-bottom {
        display: flex;
        align-items: center;
        justify-content: space-between;
        margin-top: 16rpx;

        .goods-price {
          font-size: 28rpx;
          color: $color-primary-danger;
          font-weight: 600;
        }

        .goods-count {
          font-size: 24rpx;
          color: $text-sub;
        }
      }
    }
  }
}

.pay-footer {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  z-index: 100;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 24rpx 32rpx;
  padding-bottom: calc(24rpx + env(safe-area-inset-bottom));
  background: $bg-card;
  box-shadow: 0 -2rpx 12rpx rgba(0, 0, 0, 0.06);

  .footer-left {
    display: flex;
    align-items: baseline;

    .footer-label {
      font-size: 28rpx;
      color: $text-sub;
    }

    .footer-amount {
      font-size: 44rpx;
      color: $color-primary-danger;
      font-weight: 700;
      margin-left: 8rpx;
    }
  }

  .pay-btn {
    padding: 28rpx 80rpx;
    background: linear-gradient(135deg, $color-primary 0%, $color-primary-danger 100%);
    border-radius: 48rpx;

    text {
      font-size: 34rpx;
      color: #FFFFFF;
      font-weight: 600;
    }

    &.btn-disabled {
      opacity: 0.6;
    }

    &.btn-expired {
      background: #CCCCCC;
      opacity: 0.7;
    }
  }
}
</style>
