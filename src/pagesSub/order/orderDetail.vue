<template>
  <view class="page-container">
    <view class="order-header">
      <view class="header-left" @click="handleBack">
        <text class="back-icon">‹</text>
      </view>
      <text class="header-title">订单详情</text>
      <view class="header-right"></view>
    </view>

    <scroll-view scroll-y class="page-content">
      <view class="status-bar" :class="getStatusClass(orderDetail.status)">
        <view class="status-icon">
          <text>{{ getStatusIcon(orderDetail.status) }}</text>
        </view>
        <text class="status-text">{{ orderDetail.statusText }}</text>
        <text class="status-desc">{{ getStatusDesc(orderDetail.status) }}</text>
        <view v-if="orderDetail.status === 'WAIT_PAY' && countdownText" class="countdown-wrap">
          <text class="countdown-label">支付剩余时间</text>
          <text class="countdown-text">{{ countdownText }}</text>
        </view>
      </view>

      <view class="card-container">
        <view class="card-header">
          <text class="card-title">收货信息</text>
        </view>
        <view class="address-info" v-if="orderDetail.receiverInfo">
          <view class="address-left">
            <text class="receiver-name">{{ orderDetail.receiverInfo.receiverName }}</text>
            <text class="receiver-phone">{{ orderDetail.receiverInfo.receiverPhone }}</text>
          </view>
          <text class="receiver-address">{{ orderDetail.receiverInfo.fullAddress }}</text>
        </view>
        <view class="pickup-info" v-else-if="orderDetail.pickupPoint">
          <view class="pickup-icon">🏪</view>
          <view class="pickup-content">
            <text class="pickup-name">{{ orderDetail.pickupPoint.name }}</text>
            <text class="pickup-address">{{ orderDetail.pickupPoint.address }}</text>
          </view>
        </view>
      </view>

      <view class="card-container">
        <view class="card-header">
          <text class="card-title">商品信息</text>
        </view>
        <view class="goods-list">
          <view v-for="item in orderDetail.itemList" :key="item.orderItemId" class="goods-item">
            <image :src="getValidImageUrl(item.productImage)" class="goods-image" mode="aspectFill" />
            <view class="goods-content">
              <text class="goods-name">{{ item.productName }}</text>
              <text class="goods-spec">{{ item.skuSpecs }}</text>
              <view class="goods-bottom">
                <text class="goods-price">¥{{ item.price.toFixed(2) }}</text>
                <text class="goods-count">×{{ item.quantity }}</text>
              </view>
            </view>
          </view>
        </view>
      </view>

      <view class="card-container">
        <view class="card-header">
          <text class="card-title">订单信息</text>
        </view>
        <view class="order-info-list">
          <view class="info-row">
            <text class="info-label">订单编号</text>
            <text class="info-value">{{ orderDetail.orderSn }}</text>
          </view>
          <view class="info-row">
            <text class="info-label">下单时间</text>
            <text class="info-value">{{ orderDetail.createTime }}</text>
          </view>
          <view class="info-row">
            <text class="info-label">配送方式</text>
            <text class="info-value">{{ orderDetail.deliveryType === 1 ? '配送到家' : '门店自提' }}</text>
          </view>
          <view class="info-row">
            <text class="info-label">支付方式</text>
            <text class="info-value">{{ orderDetail.paymentType || '未支付' }}</text>
          </view>
          <view class="info-row">
            <text class="info-label">订单备注</text>
            <text class="info-value">{{ orderDetail.remark || '无' }}</text>
          </view>
        </view>
      </view>

      <view class="card-container">
        <view class="card-header">
          <text class="card-title">费用明细</text>
        </view>
        <view class="price-info-list">
          <view class="price-row">
            <text class="price-label">商品总额</text>
            <text class="price-value">¥{{ orderDetail.totalAmount.toFixed(2) }}</text>
          </view>
          <view v-if="orderDetail.seckillDiscount > 0" class="price-row discount-row">
            <text class="price-label">秒杀优惠</text>
            <text class="price-discount">-¥{{ orderDetail.seckillDiscount.toFixed(2) }}</text>
          </view>
          <view v-if="orderDetail.bargainDiscount > 0" class="price-row discount-row">
            <text class="price-label">砍价优惠</text>
            <text class="price-discount">-¥{{ orderDetail.bargainDiscount.toFixed(2) }}</text>
          </view>
          <view v-if="orderDetail.fullReductionDiscount > 0" class="price-row discount-row">
            <text class="price-label">满减优惠</text>
            <text class="price-discount">-¥{{ orderDetail.fullReductionDiscount.toFixed(2) }}</text>
          </view>
          <view v-if="orderDetail.couponDiscount > 0" class="price-row discount-row">
            <text class="price-label">优惠券</text>
            <text class="price-discount">-¥{{ orderDetail.couponDiscount.toFixed(2) }}</text>
          </view>
          <view v-if="orderDetail.pointsDeduction > 0" class="price-row discount-row">
            <text class="price-label">积分抵扣</text>
            <text class="price-discount">-¥{{ orderDetail.pointsDeduction.toFixed(2) }}</text>
          </view>
          <view class="price-row">
            <text class="price-label">运费</text>
            <text class="price-value">{{ orderDetail.deliveryFee > 0 ? `¥${orderDetail.deliveryFee.toFixed(2)}` : '免运费' }}</text>
          </view>
          <view class="price-row total-row">
            <text class="price-label">实付金额</text>
            <text class="price-value total">¥{{ orderDetail.payAmount.toFixed(2) }}</text>
          </view>
        </view>
      </view>

      <view v-if="orderDetail.status === 'IN_PROGRESS' && orderDetail.deliveryInfo" class="card-container">
        <view class="card-header">
          <text class="card-title">物流信息</text>
        </view>
        <view class="logistics-info">
          <view v-for="(item, index) in orderDetail.deliveryInfo.trackingList" :key="index" class="logistics-item">
            <view class="logistics-dot" :class="{ 'dot-active': index === 0 }"></view>
            <view class="logistics-line" v-if="index < orderDetail.deliveryInfo.trackingList.length - 1"></view>
            <view class="logistics-content">
              <text class="logistics-text">{{ item.description }}</text>
              <text class="logistics-time">{{ item.time }}</text>
            </view>
          </view>
        </view>
      </view>

      <view class="bottom-space"></view>
    </scroll-view>

    <view class="bottom-bar">
      <view class="bottom-left">
        <view class="price-row">
          <text class="price-label">实付金额</text>
          <text class="price-value">¥{{ orderDetail.payAmount.toFixed(2) }}</text>
        </view>
      </view>
      <view class="bottom-right">
        <view 
          v-if="orderDetail.status === 'WAIT_PAY'" 
          class="action-btn"
          @click="handleCancel"
        >
          <text>取消订单</text>
        </view>
        <view 
          v-if="orderDetail.status === 'WAIT_PAY'" 
          class="action-btn primary"
          @click="handlePay"
        >
          <text>去支付</text>
        </view>
        <view 
          v-if="orderDetail.status === 'WAIT_ACCEPT'" 
          class="action-btn"
          @click="handleCancel"
        >
          <text>取消订单</text>
        </view>
        <view 
          v-if="orderDetail.status === 'ACCEPTED'" 
          class="action-btn"
          @click="handleRemind"
        >
          <text>催发货</text>
        </view>
        <view 
          v-if="orderDetail.status === 'IN_PROGRESS'" 
          class="action-btn primary"
          @click="handleConfirm"
        >
          <text>确认收货</text>
        </view>
        <view 
          v-if="['COMPLETED', 'CANCELLED', 'CLOSED'].includes(orderDetail.status)" 
          class="action-btn"
          @click="handleDelete"
        >
          <text>删除订单</text>
        </view>
        <view 
          v-if="orderDetail.status === 'COMPLETED'" 
          class="action-btn primary"
          @click="handleBuyAgain"
        >
          <text>再次购买</text>
        </view>
      </view>
    </view>

    <view v-if="showCancelModal" class="modal-mask" @click="showCancelModal = false">
      <view class="cancel-modal" @click.stop>
        <view class="modal-header">
          <text class="modal-title">取消订单</text>
        </view>
        <view class="modal-body">
          <text class="modal-desc">请选择取消原因</text>
          <view class="reason-list">
            <view 
              v-for="reason in cancelReasons" 
              :key="reason.value"
              class="reason-item"
              :class="{ 'reason-selected': cancelReason === reason.value }"
              @click="cancelReason = reason.value"
            >
              <view class="reason-radio">
                <view v-if="cancelReason === reason.value" class="radio-dot"></view>
              </view>
              <text class="reason-text">{{ reason.label }}</text>
            </view>
          </view>
          <input 
            v-model="customReason"
            class="custom-reason-input"
            placeholder="其他原因，请填写..."
            maxlength="100"
          />
        </view>
        <view class="modal-footer">
          <view class="modal-btn" @click="showCancelModal = false">
            <text>取消</text>
          </view>
          <view class="modal-btn primary" @click="confirmCancel">
            <text>确认取消</text>
          </view>
        </view>
      </view>
    </view>
  </view>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from 'vue'
import { onShow } from '@dcloudio/uni-app'
import { showToast, getValidImageUrl } from '@/utils/common'
import { useOrder } from '@/hooks/useOrder'

const orderId = ref('')
const countdownText = ref('')
const showCancelModal = ref(false)
const cancelReason = ref('')
const customReason = ref('')

let countdownTimer = null
let statusPollingTimer = null

const { loadOrderDetail, loadOrderStatus, cancelOrder, deleteOrder, confirmOrder } = useOrder()

const cancelReasons = [
  { value: '不想买了', label: '不想买了' },
  { value: '信息填写错误', label: '信息填写错误' },
  { value: '重复下单', label: '重复下单' },
  { value: '商品价格过高', label: '商品价格过高' },
  { value: '其他', label: '其他' }
]

const orderDetail = ref({
  orderId: '',
  orderSn: '',
  status: '',
  statusText: '',
  createTime: '',
  payAmount: 0,
  deliveryType: 1,
  remark: '',
  itemList: [],
  receiverInfo: null,
  pickupPoint: null,
  paymentType: '',
  totalAmount: 0,
  discountAmount: 0,
  deliveryFee: 0,
  seckillDiscount: 0,
  bargainDiscount: 0,
  fullReductionDiscount: 0,
  couponDiscount: 0,
  pointsDeduction: 0,
  deliveryInfo: null,
  payExpireTime: ''
})

const getStatusIcon = (status) => {
  const iconMap = {
    'WAIT_PAY': '⏳',
    'WAIT_ACCEPT': '🤝',
    'ACCEPTED': '📦',
    'IN_PROGRESS': '🚚',
    'COMPLETED': '✅',
    'CANCELLED': '❌',
    'CLOSED': '🔒'
  }
  return iconMap[status] || '📋'
}

const getStatusClass = (status) => {
  const classMap = {
    'WAIT_PAY': 'status-wait-pay',
    'WAIT_ACCEPT': 'status-wait-accept',
    'ACCEPTED': 'status-accepted',
    'IN_PROGRESS': 'status-in-progress',
    'COMPLETED': 'status-completed',
    'CANCELLED': 'status-cancelled',
    'CLOSED': 'status-closed'
  }
  return classMap[status] || ''
}

const getStatusDesc = (status) => {
  const descMap = {
    'WAIT_PAY': '请尽快完成支付',
    'WAIT_ACCEPT': '等待商家接单',
    'ACCEPTED': '商家已接单，正在备货',
    'IN_PROGRESS': orderDetail.value.deliveryType === 2 ? '待自提，请注意查看取货通知' : '配送中，请注意查收',
    'COMPLETED': '感谢您的购买',
    'CANCELLED': '订单已取消',
    'CLOSED': '订单已关闭'
  }
  return descMap[status] || ''
}

const formatCountdown = (seconds) => {
  if (seconds <= 0) return '已超时'
  const h = Math.floor(seconds / 3600)
  const m = Math.floor((seconds % 3600) / 60)
  const s = seconds % 60
  return `${h.toString().padStart(2, '0')}:${m.toString().padStart(2, '0')}:${s.toString().padStart(2, '0')}`
}

const startCountdown = () => {
  if (!orderDetail.value.payExpireTime) return
  
  const expireTime = new Date(orderDetail.value.payExpireTime).getTime()
  
  const updateCountdown = () => {
    const now = Date.now()
    const diff = Math.floor((expireTime - now) / 1000)
    
    if (diff <= 0) {
      countdownText.value = '已超时'
      stopCountdown()
      return
    }
    
    countdownText.value = formatCountdown(diff)
  }
  
  updateCountdown()
  countdownTimer = setInterval(updateCountdown, 1000)
}

const stopCountdown = () => {
  if (countdownTimer) {
    clearInterval(countdownTimer)
    countdownTimer = null
  }
}

const startStatusPolling = () => {
  if (orderDetail.value.status !== 'WAIT_PAY') return
  
  statusPollingTimer = setInterval(async () => {
    const statusData = await loadOrderStatus(orderId.value)
    if (statusData) {
      orderDetail.value.status = statusData.status
      orderDetail.value.statusText = statusData.statusText
      
      if (statusData.status !== 'WAIT_PAY') {
        stopStatusPolling()
        if (statusData.status === 'COMPLETED') {
          showToast('支付成功')
        }
      }
    }
  }, 5000)
}

const stopStatusPolling = () => {
  if (statusPollingTimer) {
    clearInterval(statusPollingTimer)
    statusPollingTimer = null
  }
}

const handleBack = () => {
  uni.navigateBack()
}

const fetchOrderDetailData = async () => {
  const pages = getCurrentPages()
  const currentPage = pages[pages.length - 1]
  orderId.value = currentPage.options?.orderId
  
  if (!orderId.value) {
    showToast('订单ID不能为空')
    return
  }
  
  const data = await loadOrderDetail(orderId.value)
  
  if (data) {
    orderDetail.value = { ...orderDetail.value, ...data }
    
    if (orderDetail.value.status === 'WAIT_PAY') {
      startCountdown()
      startStatusPolling()
    }
  }
}

const refreshOrderStatus = async () => {
  if (!orderId.value) return
  
  const statusData = await loadOrderStatus(orderId.value)
  
  if (statusData) {
    orderDetail.value.status = statusData.status
    orderDetail.value.statusText = statusData.statusText
  }
}

const handlePay = () => {
  uni.navigateTo({ 
    url: `/pagesSub/order/pay/payOrder?orderId=${orderDetail.value.orderId}&orderSn=${orderDetail.value.orderSn}&payAmount=${orderDetail.value.payAmount}&expireTime=${orderDetail.value.payExpireTime}` 
  })
}

const handleCancel = () => {
  showCancelModal.value = true
}

const confirmCancel = async () => {
  const reason = cancelReason.value || customReason.value || ''
  
  if (!reason) {
    showToast('请选择或填写取消原因')
    return
  }
  
  const success = await cancelOrder(orderDetail.value.orderId, reason)
  if (success) {
    showCancelModal.value = false
    cancelReason.value = ''
    customReason.value = ''
    stopCountdown()
    stopStatusPolling()
    setTimeout(() => {
      uni.navigateBack()
    }, 1500)
  }
}

const handleRemind = () => {
  showToast('已提醒商家发货')
}

const handleConfirm = async () => {
  const success = await confirmOrder(orderDetail.value.orderId)
  if (success) {
    fetchOrderDetailData()
  }
}

const handleDelete = async () => {
  const success = await deleteOrder(orderDetail.value.orderId)
  if (success) {
    setTimeout(() => {
      uni.navigateBack()
    }, 1500)
  }
}

const handleBuyAgain = () => {
  uni.switchTab({ url: '/pages/index/index' })
}

onMounted(() => {
  fetchOrderDetailData()
})

onShow(() => {
  refreshOrderStatus()
})

onUnmounted(() => {
  stopCountdown()
  stopStatusPolling()
})
</script>

<style lang="scss" scoped>
.page-container {
  min-height: 100vh;
  background: $bg-page;
  display: flex;
  flex-direction: column;
}

.order-header {
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
}

.status-bar {
  padding: 60rpx 32rpx;
  display: flex;
  flex-direction: column;
  align-items: center;
  
  &.status-wait-pay {
    background: linear-gradient(135deg, $color-primary-danger 0%, #FF8C69 100%);
  }
  
  &.status-wait-accept {
    background: linear-gradient(135deg, $color-primary 0%, #FFA726 100%);
  }
  
  &.status-accepted {
    background: linear-gradient(135deg, $color-warning 0%, #FFB74D 100%);
  }
  
  &.status-in-progress {
    background: linear-gradient(135deg, $color-success 0%, #66BB6A 100%);
  }
  
  &.status-completed {
    background: linear-gradient(135deg, $gray-400 0%, $gray-300 100%);
  }
  
  &.status-cancelled, &.status-closed {
    background: linear-gradient(135deg, $gray-500 0%, $gray-400 100%);
  }
  
  .status-icon {
    width: 120rpx;
    height: 120rpx;
    background: rgba(255, 255, 255, 0.2);
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    margin-bottom: 24rpx;
    
    text {
      font-size: 60rpx;
    }
  }
  
  .status-text {
    font-size: 36rpx;
    color: #FFFFFF;
    font-weight: 600;
    margin-bottom: 12rpx;
  }
  
  .status-desc {
    font-size: 26rpx;
    color: rgba(255, 255, 255, 0.8);
  }
  
  .countdown-wrap {
    display: flex;
    align-items: center;
    margin-top: 20rpx;
    padding: 16rpx 32rpx;
    background: rgba(255, 255, 255, 0.2);
    border-radius: 32rpx;
    
    .countdown-label {
      font-size: 24rpx;
      color: rgba(255, 255, 255, 0.9);
      margin-right: 12rpx;
    }
    
    .countdown-text {
      font-size: 32rpx;
      color: #FFFFFF;
      font-weight: 600;
      font-family: monospace;
    }
  }
}

.card-container {
  background: $bg-card;
  margin: 24rpx;
  border-radius: 24rpx;
  overflow: hidden;
  box-shadow: $category-shadow-sm;
}

.card-header {
  padding: 28rpx 32rpx;
  border-bottom: 1rpx solid $bg-page-light;
  
  .card-title {
    font-size: 30rpx;
    font-weight: 600;
    color: $text-main;
  }
}

.address-info, .pickup-info {
  padding: 24rpx 32rpx;
}

.address-info {
  .address-left {
    display: flex;
    align-items: center;
    gap: 24rpx;
    margin-bottom: 16rpx;
    
    .receiver-name {
      font-size: 32rpx;
      font-weight: 600;
      color: $text-main;
    }
    
    .receiver-phone {
      font-size: 28rpx;
      color: $text-sub;
    }
  }
  
  .receiver-address {
    font-size: 28rpx;
    color: $text-sub;
    line-height: 1.5;
  }
}

.pickup-info {
  display: flex;
  align-items: center;
  
  .pickup-icon {
    font-size: 48rpx;
    margin-right: 20rpx;
  }
  
  .pickup-content {
    flex: 1;
    
    .pickup-name {
      font-size: 30rpx;
      font-weight: 600;
      color: $text-main;
      display: block;
      margin-bottom: 8rpx;
    }
    
    .pickup-address {
      font-size: 28rpx;
      color: $text-sub;
      line-height: 1.4;
    }
  }
}

.goods-list {
  padding: 16rpx 0;
}

.goods-item {
  display: flex;
  padding: 16rpx 32rpx;
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
  
  .goods-content {
    flex: 1;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    
    .goods-name {
      font-size: 28rpx;
      color: $text-main;
      line-height: 1.4;
      display: -webkit-box;
      -webkit-line-clamp: 2;
      line-clamp: 2;
      -webkit-box-orient: vertical;
      overflow: hidden;
      text-overflow: ellipsis;
    }
    
    .goods-spec {
      font-size: 24rpx;
      color: $text-weak;
      margin-top: 8rpx;
    }
    
    .goods-bottom {
      display: flex;
      align-items: center;
      justify-content: space-between;
      margin-top: 16rpx;
      
      .goods-price {
        font-size: 30rpx;
        color: $color-primary-danger;
        font-weight: 600;
      }
      
      .goods-count {
        font-size: 26rpx;
        color: $text-sub;
      }
    }
  }
}

.order-info-list, .price-info-list {
  padding: 0 32rpx;
}

.info-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 24rpx 0;
  border-bottom: 1rpx solid $bg-page-light;
  
  &:last-child {
    border-bottom: none;
  }
  
  .info-label {
    font-size: 28rpx;
    color: $text-sub;
  }
  
  .info-value {
    font-size: 28rpx;
    color: $text-main;
  }
}

.price-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 20rpx 0;
  
  &.total-row {
    padding-top: 28rpx;
    margin-top: 16rpx;
    border-top: 1rpx solid $bg-page-light;
    
    .price-label {
      font-size: 32rpx;
      font-weight: 600;
    }
    
    .price-value.total {
      font-size: 36rpx;
      color: $color-primary-danger;
      font-weight: 600;
    }
  }
  
  &.discount-row {
    .price-label, .price-discount {
      color: $color-primary;
    }
  }
  
  .price-label {
    font-size: 28rpx;
    color: $text-sub;
  }
  
  .price-value {
    font-size: 28rpx;
    color: $text-main;
  }
  
  .price-discount {
    font-size: 28rpx;
    color: $color-primary-danger;
  }
}

.logistics-info {
  padding: 32rpx;
}

.logistics-item {
  display: flex;
  padding-bottom: 32rpx;
  
  &:last-child {
    padding-bottom: 0;
    
    .logistics-line {
      display: none;
    }
  }
  
  .logistics-dot {
    width: 20rpx;
    height: 20rpx;
    border-radius: 50%;
    background: $gray-300;
    margin-right: 20rpx;
    flex-shrink: 0;
    
    &.dot-active {
      background: $color-primary;
      box-shadow: 0 0 0 6rpx rgba($color-primary, 0.15);
    }
  }
  
  .logistics-line {
    width: 4rpx;
    background: $gray-300;
    margin-left: 8rpx;
    margin-right: 20rpx;
    flex-shrink: 0;
  }
  
  .logistics-content {
    flex: 1;
    
    .logistics-text {
      font-size: 28rpx;
      color: $text-main;
      display: block;
      margin-bottom: 8rpx;
    }
    
    .logistics-time {
      font-size: 24rpx;
      color: $text-weak;
    }
  }
}

.bottom-space {
  height: calc(160rpx + env(safe-area-inset-bottom));
}

.bottom-bar {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 20rpx 32rpx;
  padding-bottom: calc(20rpx + env(safe-area-inset-bottom));
  background: $bg-card;
  box-shadow: 0 -4rpx 16rpx rgba(0, 0, 0, 0.05);
  
  .bottom-left {
    .price-label {
      font-size: 26rpx;
      color: $text-sub;
      margin-right: 8rpx;
    }
    
    .price-value {
      font-size: 36rpx;
      color: $color-primary-danger;
      font-weight: 600;
    }
  }
  
  .bottom-right {
    display: flex;
    gap: 20rpx;
    
    .action-btn {
      padding: 20rpx 36rpx;
      border: 1rpx solid $gray-300;
      border-radius: 40rpx;
      
      text {
        font-size: 28rpx;
        color: $text-main;
      }
      
      &.primary {
        background: linear-gradient(135deg, $color-primary 0%, $color-primary-danger 100%);
        border-color: transparent;
        
        text {
          color: #FFFFFF;
          font-weight: 500;
        }
      }
    }
  }
}

.modal-mask {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.5);
  z-index: 200;
  display: flex;
  align-items: center;
  justify-content: center;
}

.cancel-modal {
  width: 600rpx;
  background: $bg-card;
  border-radius: 24rpx;
  overflow: hidden;
  
  .modal-header {
    padding: 32rpx;
    border-bottom: 1rpx solid $bg-page-light;
    text-align: center;
    
    .modal-title {
      font-size: 32rpx;
      font-weight: 600;
      color: $text-main;
    }
  }
  
  .modal-body {
    padding: 32rpx;
    
    .modal-desc {
      font-size: 28rpx;
      color: $text-sub;
      margin-bottom: 24rpx;
      display: block;
    }
    
    .reason-list {
      margin-bottom: 24rpx;
    }
    
    .reason-item {
      display: flex;
      align-items: center;
      padding: 20rpx 0;
      
      &.reason-selected {
        .reason-radio {
          border-color: $color-primary;
          
          .radio-dot {
            background: $color-primary;
          }
        }
        
        .reason-text {
          color: $color-primary;
        }
      }
      
      .reason-radio {
        width: 36rpx;
        height: 36rpx;
        border: 2rpx solid $gray-300;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        margin-right: 16rpx;
        
        .radio-dot {
          width: 20rpx;
          height: 20rpx;
          border-radius: 50%;
          background: #CCCCCC;
        }
      }
      
      .reason-text {
        font-size: 28rpx;
        color: $text-main;
      }
    }
    
    .custom-reason-input {
      width: 100%;
      height: 80rpx;
      background: $bg-page-light;
      border-radius: 12rpx;
      padding: 0 24rpx;
      font-size: 26rpx;
      color: $text-main;
    }
  }
  
  .modal-footer {
    display: flex;
    border-top: 1rpx solid $bg-page-light;
    
    .modal-btn {
      flex: 1;
      padding: 32rpx;
      text-align: center;
      
      text {
        font-size: 30rpx;
        color: $text-main;
      }
      
      &.primary {
        text {
          color: $color-primary;
          font-weight: 500;
        }
      }
      
      &:first-child {
        border-right: 1rpx solid $bg-page-light;
      }
    }
  }
}
</style>