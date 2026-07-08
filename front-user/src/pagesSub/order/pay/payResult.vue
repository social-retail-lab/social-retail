<template>
  <view class="page-container">
    <view class="result-icon-wrap" :class="{ success: isSuccess, fail: !isSuccess }">
      <text class="result-icon">{{ isSuccess ? '✓' : '✗' }}</text>
    </view>
    
    <text class="result-title">{{ isSuccess ? '支付成功' : '支付失败' }}</text>
    <text class="result-desc">{{ isSuccess ? '订单已提交成功' : '支付未完成，请重试' }}</text>
    
    <view class="order-info-card" v-if="orderId">
      <view class="order-info-row">
        <text class="order-label">订单编号</text>
        <text class="order-value">{{ orderSn || orderId }}</text>
      </view>
      <view class="order-info-row">
        <text class="order-label">支付金额</text>
        <text class="order-value amount">¥{{ payAmount.toFixed(2) }}</text>
      </view>
    </view>
    
    <view class="btn-group">
      <view class="btn-secondary" @click="goToOrderList">
        <text>查看订单</text>
      </view>
      <view class="btn-primary" @click="goHome">
        <text>返回首页</text>
      </view>
    </view>
    
    <view v-if="isSuccess" class="quick-entry">
      <text class="quick-title">快捷入口</text>
      <view class="quick-list">
        <view class="quick-item" @click="goToOrderDetail">
          <text class="quick-icon">📋</text>
          <text class="quick-text">查看详情</text>
        </view>
        <view class="quick-item" @click="goHome">
          <text class="quick-icon">🛒</text>
          <text class="quick-text">继续购物</text>
        </view>
      </view>
    </view>
  </view>
</template>

<script setup>
import { ref, onMounted } from 'vue'

const orderId = ref('')
const orderSn = ref('')
const payAmount = ref(0)
const isSuccess = ref(true)

const goToOrderDetail = () => {
  uni.redirectTo({ 
    url: `/pagesSub/order/orderDetail?orderId=${orderId.value}` 
  })
}

const goToOrderList = () => {
  uni.redirectTo({ 
    url: '/pagesSub/order/orderList' 
  })
}

const goHome = () => {
  uni.switchTab({ 
    url: '/pages/index/index' 
  })
}

onMounted(() => {
  const pages = getCurrentPages()
  const currentPage = pages[pages.length - 1]
  const options = currentPage.options || {}
  
  if (options.orderId) orderId.value = options.orderId
  if (options.orderSn) orderSn.value = options.orderSn
  if (options.payAmount) payAmount.value = parseFloat(options.payAmount) || 0
  if (options.status) isSuccess.value = options.status === 'success'
})
</script>

<style lang="scss" scoped>
.page-container {
  min-height: 100vh;
  background: $bg-page;
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 120rpx 40rpx;
  padding-top: calc(120rpx + env(safe-area-inset-top));
}

.result-icon-wrap {
  width: 160rpx;
  height: 160rpx;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 40rpx;
  
  &.success {
    background: linear-gradient(135deg, #52c41a 0%, #73d13d 100%);
    
    .result-icon {
      color: #FFFFFF;
    }
  }
  
  &.fail {
    background: linear-gradient(135deg, #ff4d4f 0%, #ff7875 100%);
    
    .result-icon {
      color: #FFFFFF;
    }
  }
}

.result-icon {
  font-size: 80rpx;
  font-weight: 700;
}

.result-title {
  font-size: 40rpx;
  font-weight: 600;
  color: $text-main;
  margin-bottom: 16rpx;
}

.result-desc {
  font-size: 28rpx;
  color: $text-sub;
  margin-bottom: 48rpx;
}

.order-info-card {
  width: 100%;
  background: $bg-card;
  border-radius: $radius-lg;
  padding: 32rpx;
  margin-bottom: 48rpx;
}

.order-info-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 16rpx 0;
  
  &:not(:last-child) {
    border-bottom: 1rpx solid $bg-page-light;
  }
}

.order-label {
  font-size: 28rpx;
  color: $text-sub;
}

.order-value {
  font-size: 28rpx;
  color: $text-main;
  font-weight: 500;
  
  &.amount {
    color: $color-primary-danger;
    font-size: 36rpx;
    font-weight: 700;
  }
}

.btn-group {
  width: 100%;
  display: flex;
  gap: 24rpx;
  margin-bottom: 48rpx;
}

.btn-secondary,
.btn-primary {
  flex: 1;
  height: 88rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: $radius-full;
  font-size: 30rpx;
  font-weight: 600;
  
  &:active {
    opacity: 0.8;
  }
}

.btn-secondary {
  background: $bg-card;
  color: $text-main;
  border: 2rpx solid $gray-200;
}

.btn-primary {
  background: linear-gradient(135deg, $color-primary 0%, $color-primary-danger 100%);
  color: #FFFFFF;
}

.quick-entry {
  width: 100%;
}

.quick-title {
  display: block;
  font-size: 28rpx;
  color: $text-sub;
  margin-bottom: 24rpx;
  text-align: center;
}

.quick-list {
  display: flex;
  justify-content: center;
  gap: 80rpx;
}

.quick-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 12rpx;
  
  &:active {
    opacity: 0.6;
  }
}

.quick-icon {
  font-size: 56rpx;
}

.quick-text {
  font-size: 26rpx;
  color: $text-sub;
}
</style>