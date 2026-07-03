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
          <text class="order-sn">{{ orderSn }}</text>
        </view>
        <view class="order-info-bottom">
          <text class="order-label">下单时间</text>
          <text class="order-time">{{ orderTime }}</text>
        </view>
      </view>

      <view class="amount-card">
        <view class="amount-label">支付金额</view>
        <view class="amount-value-wrap">
          <text class="amount-symbol">¥</text>
          <text class="amount-value">{{ payAmount.toFixed(2) }}</text>
        </view>
        <view v-if="expireTime" class="expire-info">
          <text class="expire-icon">⏱</text>
          <text class="expire-text">请在 <text class="expire-time">{{ expireTime }}</text> 前完成支付</text>
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
          <view v-for="item in orderItems" :key="item.cartItemId" class="goods-item">
            <image :src="getValidImageUrl(item.productImage)" class="goods-image" mode="aspectFill" />
            <view class="goods-info">
              <text class="goods-name">{{ item.productName }}</text>
              <text class="goods-sku">{{ item.skuSpecs }}</text>
              <view class="goods-bottom">
                <text class="goods-price">¥{{ item.finalPrice }}</text>
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
        <text class="footer-amount">¥{{ payAmount.toFixed(2) }}</text>
      </view>
      <view 
        class="pay-btn" 
        :class="{ 'btn-disabled': isPaying }"
        @click="handlePay"
      >
        <text>{{ isPaying ? '支付中...' : '立即支付' }}</text>
      </view>
    </view>
  </view>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from 'vue'
import { showToast, getValidImageUrl } from '@/utils/common'
import { useOrder } from '@/hooks/useOrder'

const orderId = ref('')
const orderSn = ref('')
const payAmount = ref(0)
const expireTime = ref('')
const paymentType = ref('ALIPAY')
const isPaying = ref(false)

const orderItems = ref([])
const orderTime = ref('')

const { fetchOrderDetail, fetchOrderStatus } = useOrder()
let pollTimer = null

const handleBack = () => {
  uni.showModal({
    title: '确认取消',
    content: '支付未完成，确定要离开吗？',
    success: (res) => {
      if (res.confirm) {
        uni.redirectTo({ url: '/pagesSub/order/orderList?status=WAIT_PAY' })
      }
    }
  })
}

const fetchOrderDetailData = async () => {
  if (!orderId.value) return
  
  const data = await fetchOrderDetail(orderId.value)
  
  if (data) {
    orderItems.value = data.itemList || []
    if (!orderSn.value) orderSn.value = data.orderSn || ''
    if (!payAmount.value) payAmount.value = data.payAmount || 0
    if (!expireTime.value) expireTime.value = data.payExpireTime || ''
  }
}

const pollOrderStatus = async () => {
  const statusData = await fetchOrderStatus(orderId.value)
  
  if (statusData && statusData.status !== 'WAIT_PAY') {
    if (pollTimer) {
      clearInterval(pollTimer)
      pollTimer = null
    }
    
    if (statusData.status === 'WAIT_SHIP' || statusData.status === 'WAIT_RECEIVE') {
      showToast('支付成功')
      setTimeout(() => {
        uni.redirectTo({ url: '/pagesSub/order/orderDetail?orderId=' + orderId.value })
      }, 1500)
    }
  }
}

const handlePay = async () => {
  isPaying.value = true
  try {
    await new Promise(resolve => setTimeout(resolve, 1500))
    showToast('支付处理中')
    
    pollTimer = setInterval(pollOrderStatus, 3000)
    
    setTimeout(() => {
      if (pollTimer) {
        clearInterval(pollTimer)
        pollTimer = null
        showToast('支付成功')
        uni.redirectTo({ url: '/pagesSub/order/orderDetail?orderId=' + orderId.value })
      }
    }, 10000)
  } catch (error) {
    console.error('支付失败:', error)
    showToast('支付失败，请重试')
  } finally {
    isPaying.value = false
  }
}

onMounted(async () => {
  const pages = getCurrentPages()
  const currentPage = pages[pages.length - 1]
  const options = currentPage.$page?.options || currentPage.options || {}
  
  if (options.orderId) orderId.value = options.orderId
  if (options.orderSn) orderSn.value = options.orderSn
  if (options.payAmount) payAmount.value = parseFloat(options.payAmount) || 150.00
  if (options.expireTime) expireTime.value = options.expireTime
  
  if (!orderSn.value) {
    orderSn.value = 'ORD' + Date.now().toString().slice(-10)
  }
  
  if (!expireTime.value) {
    const expire = new Date(Date.now() + 30 * 60 * 1000)
    expireTime.value = `${expire.getHours().toString().padStart(2, '0')}:${expire.getMinutes().toString().padStart(2, '0')}:${expire.getSeconds().toString().padStart(2, '0')}`
  }
  
  const now = new Date()
  orderTime.value = `${now.getFullYear()}-${(now.getMonth() + 1).toString().padStart(2, '0')}-${now.getDate().toString().padStart(2, '0')} ${now.getHours().toString().padStart(2, '0')}:${now.getMinutes().toString().padStart(2, '0')}`
  
  await fetchOrderDetailData()
})

onUnmounted(() => {
  if (pollTimer) {
    clearInterval(pollTimer)
    pollTimer = null
  }
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
  }
}
</style>