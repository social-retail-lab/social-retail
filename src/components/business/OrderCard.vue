<template>
  <view class="order-card">
    <view class="card-header">
      <view class="header-left">
        <text class="order-sn">{{ order.orderSn }}</text>
      </view>
      <view class="header-right">
        <text class="order-status" :class="statusClass">{{ order.statusText }}</text>
      </view>
    </view>

    <view class="card-body">
      <view
        v-for="item in order.itemList"
        :key="item.productId || item.orderItemId"
        class="order-item"
        @click="goDetail"
      >
        <image :src="item.productImage" mode="aspectFill" class="item-image" lazy-load />
        <view class="item-info">
          <text class="item-name">{{ item.productName }}</text>
          <text class="item-spec">{{ item.skuSpecs }}</text>
          <view class="item-bottom">
            <text class="item-price">¥{{ item.price }}</text>
            <text class="item-quantity">×{{ item.quantity }}</text>
          </view>
        </view>
      </view>
    </view>

    <view class="card-footer">
      <view class="footer-left">
        <text class="footer-label">实付款：</text>
        <text class="footer-amount">¥{{ order.payAmount }}</text>
      </view>
      <view class="footer-right">
        <view
          v-if="canCancel"
          class="action-btn action-btn-outline"
          @click="handleCancel"
        >
          <text>取消订单</text>
        </view>
        <view
          v-if="canPay"
          class="action-btn action-btn-primary"
          @click="handlePay"
        >
          <text>去支付</text>
        </view>
        <view
          v-if="canConfirm"
          class="action-btn action-btn-primary"
          @click="handleConfirm"
        >
          <text>确认收货</text>
        </view>
        <view
          v-if="canDelete"
          class="action-btn action-btn-outline"
          @click="handleDelete"
        >
          <text>删除订单</text>
        </view>
        <view
          v-if="canRebuy"
          class="action-btn action-btn-primary"
          @click="handleRebuy"
        >
          <text>再次购买</text>
        </view>
      </view>
    </view>
  </view>
</template>

<script setup>
import { computed } from 'vue'

const props = defineProps({
  order: {
    type: Object,
    required: true,
    default: () => ({
      orderId: 0,
      orderSn: '',
      status: '',
      statusText: '',
      totalAmount: 0,
      payAmount: 0,
      deliveryType: '',
      createTime: '',
      itemList: []
    })
  }
})

const emit = defineEmits(['cancel', 'pay', 'confirm', 'delete', 'rebuy', 'detail'])

const statusClass = computed(() => {
  const status = props.order.status
  if (status === 'WAIT_PAY') return 'status-wait-pay'
  if (status === 'WAIT_SHIP') return 'status-wait-ship'
  if (status === 'WAIT_RECEIVE') return 'status-wait-receive'
  if (status === 'COMPLETED') return 'status-completed'
  if (status === 'CANCELLED') return 'status-cancelled'
  if (status === 'CLOSED') return 'status-closed'
  return ''
})

const canCancel = computed(() => {
  return ['WAIT_PAY', 'WAIT_SHIP'].includes(props.order.status)
})

const canPay = computed(() => {
  return props.order.status === 'WAIT_PAY'
})

const canConfirm = computed(() => {
  return props.order.status === 'WAIT_RECEIVE'
})

const canDelete = computed(() => {
  return ['COMPLETED', 'CANCELLED', 'CLOSED'].includes(props.order.status)
})

const canRebuy = computed(() => {
  return ['COMPLETED'].includes(props.order.status)
})

const goDetail = () => {
  emit('detail', props.order)
  uni.navigateTo({
    url: `/pagesSub/order/orderDetail?orderId=${props.order.orderId}`
  })
}

const handleCancel = () => {
  emit('cancel', props.order)
}

const handlePay = () => {
  emit('pay', props.order)
}

const handleConfirm = () => {
  emit('confirm', props.order)
}

const handleDelete = () => {
  emit('delete', props.order)
}

const handleRebuy = () => {
  emit('rebuy', props.order)
}
</script>

<style lang="scss" scoped>
.order-card {
  background: $bg-card;
  border-radius: $radius-lg;
  overflow: hidden;
  margin-bottom: 16rpx;
}

.card-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 24rpx;
  border-bottom: 1rpx solid $bg-page-light;
}

.header-left {
  .order-sn {
    font-size: 26rpx;
    color: $text-sub;
  }
}

.header-right {
  .order-status {
    font-size: 28rpx;
    font-weight: 600;
  }

  .status-wait-pay {
    color: $color-primary-danger;
  }

  .status-wait-ship {
    color: $color-primary;
  }

  .status-wait-receive {
    color: $color-secondary;
  }

  .status-completed {
    color: $text-sub;
  }

  .status-cancelled,
  .status-closed {
    color: $text-weak;
  }
}

.card-body {
  padding: 20rpx;
}

.order-item {
  display: flex;
  padding: 16rpx 0;

  &:not(:last-child) {
    border-bottom: 1rpx solid $bg-page-light;
  }

  &:active {
    opacity: 0.8;
  }
}

.item-image {
  width: 160rpx;
  height: 160rpx;
  border-radius: $radius-base;
  flex-shrink: 0;
}

.item-info {
  flex: 1;
  margin-left: 16rpx;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
}

.item-name {
  font-size: 28rpx;
  color: $text-main;
  line-height: 1.4;
  overflow: hidden;
  text-overflow: ellipsis;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  line-clamp: 2;
  -webkit-box-orient: vertical;
}

.item-spec {
  font-size: 24rpx;
  color: $text-sub;
}

.item-bottom {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.item-price {
  font-size: 28rpx;
  font-weight: 600;
  color: $color-primary-danger;
}

.item-quantity {
  font-size: 24rpx;
  color: $text-sub;
}

.card-footer {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 20rpx 24rpx;
  background: $bg-page-light;
}

.footer-left {
  display: flex;
  align-items: baseline;

  .footer-label {
    font-size: 26rpx;
    color: $text-sub;
  }

  .footer-amount {
    font-size: 32rpx;
    font-weight: 700;
    color: $color-primary-danger;
  }
}

.footer-right {
  display: flex;
  gap: 16rpx;
}

.action-btn {
  padding: 12rpx 28rpx;
  border-radius: $radius-full;
  font-size: 26rpx;
  font-weight: 500;

  &:active {
    opacity: 0.8;
  }

  text {
    font-size: inherit;
    font-weight: inherit;
  }
}

.action-btn-outline {
  border: 2rpx solid $text-weak;
  background: transparent;

  text {
    color: $text-sub;
  }
}

.action-btn-primary {
  background: linear-gradient(135deg, $color-primary 0%, $color-primary-danger 100%);

  text {
    color: #FFFFFF;
  }
}
</style>