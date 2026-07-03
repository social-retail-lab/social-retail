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
            <text class="option-text">支付宝支付</text>
            <view class="option-check">
              <view v-if="paymentType === 'ALIPAY'" class="check-dot"></view>
            </view>
          </view>
          <view
            class="payment-option"
            :class="{ 'payment-active': paymentType === 'WECHAT' }"
            @click="paymentType = 'WECHAT'"
          >
            <view class="option-icon-wrap">
              <text class="option-icon">💚</text>
            </view>
            <text class="option-text">微信支付</text>
            <view class="option-check">
              <view v-if="paymentType === 'WECHAT'" class="check-dot"></view>
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
        uni.navigateBack()
      }
    }
  })
}

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
  pollTimer = setInterval(pollOrderStatus, 3000)
}

const redirectToDetail = () => {
  uni.navigateTo({ url: '/pagesSub/order/orderDetail?orderId=' + orderId.value })
}

const pollOrderStatus = async () => {
  if (!orderId.value) return
  const statusData = await orderHook.loadOrderStatus(orderId.value)
  if (!statusData) return
  if (statusData.status && statusData.status !== 'WAIT_PAY') {
    stopAllTimers()
    const successStatuses = ['WAIT_SHIP', 'WAIT_RECEIVE', 'IN_PROGRESS', 'COMPLETED']
    if (successStatuses.includes(statusData.status)) {
      showToast('支付成功', 'success')
    } else {
      showToast(statusData.statusText || '订单状态已变更')
    }
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

const handlePay = () => {
  if (isPaying.value || isExpired.value) return
  isPaying.value = true
  uni.showLoading({ title: '正在跳转支付...', mask: true })
  // 实际项目中这里应该调用后端支付下单接口获取支付参数
  uni.hideLoading()
  showToast('支付功能对接中，请稍后')
  // 继续轮询订单状态，轮询到状态变化后自动跳转订单详情
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

  startCountdown()
  startPolling()
})

onUnmounted(() => {
  stopAllTimers()
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
      
      .option-text {
        flex: 1;
        font-size: 32rpx;
        color: $text-main;
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
