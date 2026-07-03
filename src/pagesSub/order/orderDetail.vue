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
      <!-- 1. 顶部订单状态区 -->
      <view class="status-bar" :class="getStatusClass(orderDetail.status)">
        <view class="status-icon">
          <text>{{ getStatusIcon(orderDetail.status) }}</text>
        </view>
        <text class="status-text">{{ orderDetail.statusText || '订单详情' }}</text>
        <text class="status-desc">{{ getStatusDesc(orderDetail.status) }}</text>
        <view v-if="orderDetail.status === 'WAIT_PAY' && countdownText" class="countdown-wrap">
          <text class="countdown-label">支付剩余时间</text>
          <text class="countdown-text">{{ countdownText }}</text>
        </view>
      </view>

      <!-- 2. 收货/自提信息模块 -->
      <view class="card-container">
        <view class="card-header">
          <text class="card-title">{{ orderDetail.deliveryType === 2 ? '自提信息' : '收货信息' }}</text>
        </view>
        <!-- 配送方式：收货信息 -->
        <view v-if="orderDetail.deliveryType !== 2 && orderDetail.receiverInfo" class="address-info">
          <view class="address-left">
            <text class="receiver-name">{{ orderDetail.receiverInfo.receiverName }}</text>
            <text class="receiver-phone">{{ maskPhone(orderDetail.receiverInfo.receiverPhone) }}</text>
          </view>
          <text class="receiver-address">{{ orderDetail.receiverInfo.fullAddress }}</text>
        </view>
        <!-- 自提方式：自提点信息 -->
        <view v-else-if="orderDetail.deliveryType === 2 && orderDetail.pickupPointInfo" class="pickup-info">
          <view class="pickup-icon">🏪</view>
          <view class="pickup-content">
            <text class="pickup-name">{{ orderDetail.pickupPointInfo.name }}</text>
            <text class="pickup-address">{{ orderDetail.pickupPointInfo.address }}</text>
            <view v-if="orderDetail.pickupPointInfo.phone" class="pickup-row">
              <text class="pickup-label">联系电话：</text>
              <text class="pickup-value">{{ orderDetail.pickupPointInfo.phone }}</text>
            </view>
            <view v-if="orderDetail.pickupPointInfo.businessHours" class="pickup-row">
              <text class="pickup-label">营业时间：</text>
              <text class="pickup-value">{{ orderDetail.pickupPointInfo.businessHours }}</text>
            </view>
          </view>
        </view>
      </view>

      <!-- 3. 商品明细列表 -->
      <view class="card-container">
        <view class="card-header">
          <text class="card-title">商品信息</text>
        </view>
        <view class="goods-list">
          <view v-for="item in orderDetail.itemList" :key="item.orderItemId" class="goods-item">
            <image :src="getValidImageUrl(item.productImage)" class="goods-image" mode="aspectFill" />
            <view class="goods-content">
              <view class="goods-top">
                <text class="goods-name">{{ item.productName }}</text>
                <text v-if="item.skuSpecs" class="goods-spec">{{ item.skuSpecs }}</text>
                <view v-if="item.promotionType" class="goods-tag">
                  <text>{{ item.promotionType }}</text>
                </view>
              </view>
              <view class="goods-bottom">
                <view class="goods-price-wrap">
                  <text class="goods-price">¥{{ formatPrice(item.finalPrice) }}</text>
                  <text
                    v-if="item.originPrice && Number(item.originPrice) > Number(item.finalPrice)"
                    class="goods-origin-price"
                  >¥{{ formatPrice(item.originPrice) }}</text>
                </view>
                <text class="goods-count">×{{ item.quantity }}</text>
              </view>
              <view class="goods-subtotal">
                <text class="subtotal-label">小计</text>
                <text class="subtotal-value">¥{{ formatPrice(item.itemAmount) }}</text>
              </view>
            </view>
          </view>
        </view>
      </view>

      <!-- 4. 价格优惠明细模块 -->
      <view class="card-container">
        <view class="card-header">
          <text class="card-title">价格明细</text>
        </view>
        <view class="price-info-list">
          <view class="price-row">
            <text class="price-label">商品总价</text>
            <text class="price-value">¥{{ formatPrice(priceDetail.totalAmount) }}</text>
          </view>
          <view v-if="Number(priceDetail.seckillDiscount) > 0" class="price-row discount-row">
            <text class="price-label">秒杀优惠</text>
            <text class="price-discount">-¥{{ formatPrice(priceDetail.seckillDiscount) }}</text>
          </view>
          <view v-if="Number(priceDetail.bargainDiscount) > 0" class="price-row discount-row">
            <text class="price-label">砍价优惠</text>
            <text class="price-discount">-¥{{ formatPrice(priceDetail.bargainDiscount) }}</text>
          </view>
          <view v-if="Number(priceDetail.promotionDiscount) > 0" class="price-row discount-row">
            <text class="price-label">满减优惠</text>
            <text class="price-discount">-¥{{ formatPrice(priceDetail.promotionDiscount) }}</text>
          </view>
          <view v-if="Number(priceDetail.platformCouponDiscount) > 0" class="price-row discount-row">
            <text class="price-label">平台券</text>
            <text class="price-discount">-¥{{ formatPrice(priceDetail.platformCouponDiscount) }}</text>
          </view>
          <view v-if="Number(priceDetail.merchantCouponDiscount) > 0" class="price-row discount-row">
            <text class="price-label">商家券</text>
            <text class="price-discount">-¥{{ formatPrice(priceDetail.merchantCouponDiscount) }}</text>
          </view>
          <view v-if="Number(priceDetail.pointsDeduction) > 0" class="price-row discount-row">
            <text class="price-label">积分抵扣</text>
            <text class="price-discount">-¥{{ formatPrice(priceDetail.pointsDeduction) }}</text>
          </view>
          <view class="price-row">
            <text class="price-label">运费</text>
            <text class="price-value">{{ Number(priceDetail.deliveryFee) > 0 ? `¥${formatPrice(priceDetail.deliveryFee)}` : '免运费' }}</text>
          </view>
          <view class="price-row total-row">
            <text class="price-label">实付金额</text>
            <text class="price-value total">¥{{ formatPrice(priceDetail.payAmount) }}</text>
          </view>
        </view>

        <!-- 折叠面板：促销优惠明细 -->
        <view
          v-if="orderDetail.promotionDetail && orderDetail.promotionDetail.length"
          class="promotion-collapse"
        >
          <view class="collapse-header" @click="promotionExpanded = !promotionExpanded">
            <text class="collapse-title">优惠明细（{{ orderDetail.promotionDetail.length }}笔）</text>
            <text class="collapse-arrow" :class="{ 'arrow-up': promotionExpanded }">›</text>
          </view>
          <view v-if="promotionExpanded" class="collapse-body">
            <view
              v-for="(promo, idx) in orderDetail.promotionDetail"
              :key="idx"
              class="promotion-item"
            >
              <view class="promo-left">
                <text class="promo-title">{{ promo.title }}</text>
                <text v-if="promo.type" class="promo-type">{{ promo.type }}</text>
                <text v-if="promo.usedPoints" class="promo-points">使用{{ promo.usedPoints }}积分</text>
              </view>
              <text class="promo-discount">-¥{{ formatPrice(promo.discount) }}</text>
            </view>
          </view>
        </view>
      </view>

      <!-- 5. 优惠券&积分信息 -->
      <view
        v-if="hasCouponOrPoints"
        class="card-container"
      >
        <view class="card-header">
          <text class="card-title">优惠券与积分</text>
        </view>
        <view class="coupon-points-list">
          <!-- 平台券 -->
          <view v-if="orderDetail.couponInfo && orderDetail.couponInfo.platformCoupon" class="coupon-row">
            <view class="coupon-left">
              <text class="coupon-tag platform-tag">平台券</text>
              <view class="coupon-detail">
                <text class="coupon-name">{{ orderDetail.couponInfo.platformCoupon.couponName }}</text>
                <text v-if="orderDetail.couponInfo.platformCoupon.thresholdAmount" class="coupon-desc">
                  满{{ formatPrice(orderDetail.couponInfo.platformCoupon.thresholdAmount) }}可用
                </text>
              </view>
            </view>
            <text class="coupon-amount">-¥{{ formatPrice(orderDetail.couponInfo.platformCoupon.discountAmount) }}</text>
          </view>
          <!-- 商家券 -->
          <view v-if="orderDetail.couponInfo && orderDetail.couponInfo.merchantCoupon" class="coupon-row">
            <view class="coupon-left">
              <text class="coupon-tag merchant-tag">商家券</text>
              <view class="coupon-detail">
                <text class="coupon-name">{{ orderDetail.couponInfo.merchantCoupon.couponName }}</text>
                <text v-if="orderDetail.couponInfo.merchantCoupon.thresholdAmount" class="coupon-desc">
                  满{{ formatPrice(orderDetail.couponInfo.merchantCoupon.thresholdAmount) }}可用
                </text>
              </view>
            </view>
            <text class="coupon-amount">-¥{{ formatPrice(orderDetail.couponInfo.merchantCoupon.discountAmount) }}</text>
          </view>
          <!-- 积分抵扣 -->
          <view v-if="orderDetail.pointsInfo && Number(orderDetail.pointsInfo.usedPoints) > 0" class="coupon-row">
            <view class="coupon-left">
              <text class="coupon-tag points-tag">积分</text>
              <view class="coupon-detail">
                <text class="coupon-name">使用 {{ orderDetail.pointsInfo.usedPoints }} 积分</text>
                <text v-if="orderDetail.pointsInfo.deductionRule" class="coupon-desc">{{ orderDetail.pointsInfo.deductionRule }}</text>
              </view>
            </view>
            <text class="coupon-amount">-¥{{ formatPrice(orderDetail.pointsInfo.deductionAmount) }}</text>
          </view>
        </view>
      </view>

      <!-- 6. 订单基础信息 -->
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
            <text class="info-value">{{ orderDetail.createTime || '-' }}</text>
          </view>
          <view class="info-row">
            <text class="info-label">配送方式</text>
            <text class="info-value">{{ orderDetail.deliveryTypeText || (orderDetail.deliveryType === 2 ? '门店自提' : '配送到家') }}</text>
          </view>
          <view v-if="orderDetail.paymentInfo && orderDetail.paymentInfo.payPlatform" class="info-row">
            <text class="info-label">支付方式</text>
            <text class="info-value">{{ orderDetail.paymentInfo.payPlatform }}</text>
          </view>
          <view v-if="orderDetail.paymentInfo && orderDetail.paymentInfo.paySn" class="info-row">
            <text class="info-label">支付单号</text>
            <text class="info-value">{{ orderDetail.paymentInfo.paySn }}</text>
          </view>
          <view v-if="orderDetail.paymentInfo && orderDetail.paymentInfo.payTime" class="info-row">
            <text class="info-label">支付时间</text>
            <text class="info-value">{{ orderDetail.paymentInfo.payTime }}</text>
          </view>
          <view v-if="orderDetail.payTime" class="info-row">
            <text class="info-label">付款时间</text>
            <text class="info-value">{{ orderDetail.payTime }}</text>
          </view>
          <view v-if="orderDetail.completeTime" class="info-row">
            <text class="info-label">完成时间</text>
            <text class="info-value">{{ orderDetail.completeTime }}</text>
          </view>
          <view class="info-row">
            <text class="info-label">订单备注</text>
            <text class="info-value">{{ orderDetail.remark || '无' }}</text>
          </view>
        </view>
      </view>

      <!-- 物流信息 -->
      <view
        v-if="orderDetail.deliveryInfo && orderDetail.deliveryInfo.trackingList && orderDetail.deliveryInfo.trackingList.length"
        class="card-container"
      >
        <view class="card-header">
          <text class="card-title">物流信息</text>
        </view>
        <view class="logistics-info">
          <view
            v-for="(item, index) in orderDetail.deliveryInfo.trackingList"
            :key="index"
            class="logistics-item"
          >
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

    <!-- 7. 底部动态操作按钮 -->
    <view class="bottom-bar">
      <view class="bottom-left">
        <view class="price-row">
          <text class="price-label">实付金额</text>
          <text class="price-value">¥{{ formatPrice(orderDetail.payAmount) }}</text>
        </view>
      </view>
      <view class="bottom-right">
        <!-- WAIT_PAY：【去支付】【取消订单】 -->
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
        <!-- WAIT_ACCEPT：【取消订单】 -->
        <view
          v-if="orderDetail.status === 'WAIT_ACCEPT'"
          class="action-btn"
          @click="handleCancel"
        >
          <text>取消订单</text>
        </view>
        <!-- ACCEPTED：【催发货】（与订单列表一致） -->
        <view
          v-if="orderDetail.status === 'ACCEPTED'"
          class="action-btn"
          @click="handleRemind"
        >
          <text>催发货</text>
        </view>
        <!-- IN_PROGRESS：【确认收货】 -->
        <view
          v-if="orderDetail.status === 'IN_PROGRESS'"
          class="action-btn primary"
          @click="handleConfirm"
        >
          <text>确认收货</text>
        </view>
        <!-- COMPLETED / CANCELLED / CLOSED：【删除订单】 -->
        <view
          v-if="['COMPLETED', 'CANCELLED', 'CLOSED'].includes(orderDetail.status)"
          class="action-btn"
          @click="handleDelete"
        >
          <text>删除订单</text>
        </view>
      </view>
    </view>

    <!-- 取消订单弹窗 -->
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
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { onShow } from '@dcloudio/uni-app'
import { showToast, getValidImageUrl } from '@/utils/common'
import { useOrder } from '@/hooks/useOrder'

const orderId = ref('')
const countdownText = ref('')
const showCancelModal = ref(false)
const cancelReason = ref('')
const customReason = ref('')
const promotionExpanded = ref(false)

let countdownTimer = null
let statusPollingTimer = null

const { loadOrderDetail, loadOrderStatus, cancelOrder, confirmOrder, deleteOrder } = useOrder()

// 取消订单预设原因（5个 + 自定义）
const cancelReasons = [
  { value: '不想买了', label: '不想买了' },
  { value: '信息填写错误', label: '信息填写错误' },
  { value: '重复下单', label: '重复下单' },
  { value: '商品价格过高', label: '商品价格过高' },
  { value: '其他', label: '其他' }
]

// 订单详情数据结构
const orderDetail = ref({
  orderId: '',
  orderSn: '',
  status: '',
  statusText: '',
  totalAmount: 0,
  discountAmount: 0,
  deliveryFee: 0,
  payAmount: 0,
  deliveryType: 1,
  deliveryTypeText: '',
  remark: '',
  receiverInfo: null,
  pickupPointInfo: null,
  paymentInfo: null,
  deliveryInfo: null,
  priceDetail: {
    totalAmount: 0,
    seckillDiscount: 0,
    bargainDiscount: 0,
    promotionDiscount: 0,
    merchantCouponDiscount: 0,
    platformCouponDiscount: 0,
    pointsDeduction: 0,
    deliveryFee: 0,
    payAmount: 0
  },
  promotionDetail: [],
  couponInfo: null,
  pointsInfo: null,
  itemList: [],
  createTime: '',
  payExpireTime: '',
  payTime: '',
  completeTime: ''
})

// 价格明细（兼容数据可能为空）
const priceDetail = computed(() => orderDetail.value.priceDetail || {})

// 是否展示优惠券&积分卡片
const hasCouponOrPoints = computed(() => {
  const coupon = orderDetail.value.couponInfo
  const points = orderDetail.value.pointsInfo
  const hasPlatform = coupon && coupon.platformCoupon
  const hasMerchant = coupon && coupon.merchantCoupon
  const hasPoints = points && Number(points.usedPoints) > 0
  return hasPlatform || hasMerchant || hasPoints
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

// 金额格式化
const formatPrice = (price) => {
  return (Number(price) || 0).toFixed(2)
}

// 手机号脱敏
const maskPhone = (phone) => {
  if (!phone) return ''
  const str = String(phone)
  if (str.length < 7) return str
  return str.slice(0, 3) + '****' + str.slice(-4)
}

const formatCountdown = (seconds) => {
  if (seconds <= 0) return '已超时'
  const h = Math.floor(seconds / 3600)
  const m = Math.floor((seconds % 3600) / 60)
  const s = seconds % 60
  return `${h.toString().padStart(2, '0')}:${m.toString().padStart(2, '0')}:${s.toString().padStart(2, '0')}`
}

// 支付倒计时
const startCountdown = () => {
  if (!orderDetail.value.payExpireTime) return
  stopCountdown()

  const expireTime = new Date(orderDetail.value.payExpireTime).getTime()
  if (isNaN(expireTime)) return

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

// 8. 配套轮询逻辑：待支付状态每3秒刷新订单状态
const startStatusPolling = () => {
  if (orderDetail.value.status !== 'WAIT_PAY') return
  stopStatusPolling()

  statusPollingTimer = setInterval(async () => {
    if (!orderId.value) return
    const statusData = await loadOrderStatus(orderId.value)
    if (!statusData) return

    // 状态发生变化
    if (statusData.status !== orderDetail.value.status) {
      orderDetail.value.status = statusData.status
      orderDetail.value.statusText = statusData.statusText

      // 支付成功或状态离开待支付，停止轮询并刷新整页
      if (statusData.status !== 'WAIT_PAY') {
        stopStatusPolling()
        stopCountdown()
        showToast('订单状态已更新')
        fetchOrderDetailData()
      }
    }
  }, 3000)
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

// 拉取订单详情
const fetchOrderDetailData = async () => {
  const pages = getCurrentPages()
  const currentPage = pages[pages.length - 1]
  if (!orderId.value) {
    orderId.value = currentPage.options?.orderId
  }

  if (!orderId.value) {
    showToast('订单ID不能为空')
    return
  }

  const data = await loadOrderDetail(orderId.value)

  if (data) {
    // 浅合并，保留默认嵌套结构
    orderDetail.value = {
      ...orderDetail.value,
      ...data,
      priceDetail: { ...orderDetail.value.priceDetail, ...(data.priceDetail || {}) }
    }

    if (orderDetail.value.status === 'WAIT_PAY') {
      startCountdown()
      startStatusPolling()
    } else {
      stopCountdown()
      stopStatusPolling()
    }
  }
}

// 轻量刷新订单状态（onShow 时调用）
const refreshOrderStatus = async () => {
  if (!orderId.value) return

  const statusData = await loadOrderStatus(orderId.value)

  if (statusData) {
    const oldStatus = orderDetail.value.status
    orderDetail.value.status = statusData.status
    orderDetail.value.statusText = statusData.statusText

    if (oldStatus !== statusData.status) {
      if (statusData.status === 'WAIT_PAY') {
        startCountdown()
        startStatusPolling()
      } else {
        stopCountdown()
        stopStatusPolling()
      }
    }
  }
}

// 去支付
const handlePay = () => {
  uni.navigateTo({
    url: `/pagesSub/order/pay/payOrder?orderId=${orderDetail.value.orderId}&orderSn=${orderDetail.value.orderSn}&payAmount=${orderDetail.value.payAmount}&expireTime=${orderDetail.value.payExpireTime}`
  })
}

// 取消订单（打开弹窗）
const handleCancel = () => {
  cancelReason.value = ''
  customReason.value = ''
  showCancelModal.value = true
}

// 确认取消订单
const confirmCancel = async () => {
  let reason = cancelReason.value
  // 选择“其他”时使用自定义原因
  if (reason === '其他') {
    reason = customReason.value.trim()
  }

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

// 催发货
const handleRemind = () => {
  showToast('已提醒商家发货')
}

// 确认收货
const handleConfirm = async () => {
  const success = await confirmOrder(orderDetail.value.orderId)
  if (success) {
    fetchOrderDetailData()
  }
}

// 删除订单
const handleDelete = async () => {
  const success = await deleteOrder(orderDetail.value.orderId)
  if (success) {
    setTimeout(() => {
      uni.navigateBack()
    }, 1500)
  }
}

onMounted(() => {
  fetchOrderDetailData()
})

onShow(() => {
  if (orderId.value) {
    refreshOrderStatus()
  }
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
    font-size: 48rpx;
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
  align-items: flex-start;

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
      display: block;
      margin-bottom: 8rpx;
    }

    .pickup-row {
      display: flex;
      align-items: center;
      margin-top: 8rpx;

      .pickup-label {
        font-size: 26rpx;
        color: $text-weak;
      }

      .pickup-value {
        font-size: 26rpx;
        color: $text-sub;
      }
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

    .goods-top {
      display: flex;
      flex-direction: column;

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

      .goods-tag {
        align-self: flex-start;
        margin-top: 8rpx;
        padding: 4rpx 12rpx;
        background: rgba($color-primary, 0.1);
        border-radius: 8rpx;

        text {
          font-size: 22rpx;
          color: $color-primary;
        }
      }
    }

    .goods-bottom {
      display: flex;
      align-items: center;
      justify-content: space-between;
      margin-top: 16rpx;

      .goods-price-wrap {
        display: flex;
        align-items: baseline;
        gap: 12rpx;

        .goods-price {
          font-size: 30rpx;
          color: $color-primary-danger;
          font-weight: 600;
        }

        .goods-origin-price {
          font-size: 24rpx;
          color: $text-weak;
          text-decoration: line-through;
        }
      }

      .goods-count {
        font-size: 26rpx;
        color: $text-sub;
      }
    }

    .goods-subtotal {
      display: flex;
      align-items: center;
      justify-content: flex-end;
      gap: 12rpx;
      margin-top: 12rpx;

      .subtotal-label {
        font-size: 24rpx;
        color: $text-weak;
      }

      .subtotal-value {
        font-size: 28rpx;
        color: $text-main;
        font-weight: 600;
      }
    }
  }
}

.order-info-list, .price-info-list, .coupon-points-list {
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
    flex-shrink: 0;
  }

  .info-value {
    font-size: 28rpx;
    color: $text-main;
    text-align: right;
    margin-left: 24rpx;
    word-break: break-all;
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

.promotion-collapse {
  margin: 0 32rpx 24rpx;
  border-top: 1rpx solid $bg-page-light;

  .collapse-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 24rpx 0;

    .collapse-title {
      font-size: 28rpx;
      color: $text-main;
      font-weight: 500;
    }

    .collapse-arrow {
      font-size: 32rpx;
      color: $text-weak;
      transition: transform 0.2s ease;

      &.arrow-up {
        transform: rotate(90deg);
      }
    }
  }

  .collapse-body {
    padding-bottom: 8rpx;
  }

  .promotion-item {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 16rpx 0;

    .promo-left {
      display: flex;
      flex-direction: column;
      flex: 1;
      margin-right: 24rpx;

      .promo-title {
        font-size: 26rpx;
        color: $text-main;
      }

      .promo-type {
        font-size: 22rpx;
        color: $text-weak;
        margin-top: 4rpx;
      }

      .promo-points {
        font-size: 22rpx;
        color: $color-primary;
        margin-top: 4rpx;
      }
    }

    .promo-discount {
      font-size: 28rpx;
      color: $color-primary-danger;
      font-weight: 500;
    }
  }
}

.coupon-points-list {
  padding: 8rpx 32rpx 24rpx;
}

.coupon-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 24rpx 0;
  border-bottom: 1rpx solid $bg-page-light;

  &:last-child {
    border-bottom: none;
  }

  .coupon-left {
    display: flex;
    align-items: center;
    flex: 1;
    margin-right: 24rpx;

    .coupon-tag {
      flex-shrink: 0;
      padding: 4rpx 12rpx;
      border-radius: 8rpx;
      margin-right: 16rpx;
      font-size: 22rpx;

      &.platform-tag {
        background: rgba($color-primary, 0.1);
        color: $color-primary;
      }

      &.merchant-tag {
        background: rgba($color-warning, 0.12);
        color: $color-warning;
      }

      &.points-tag {
        background: rgba($color-primary-danger, 0.1);
        color: $color-primary-danger;
      }
    }

    .coupon-detail {
      display: flex;
      flex-direction: column;
      flex: 1;

      .coupon-name {
        font-size: 28rpx;
        color: $text-main;
      }

      .coupon-desc {
        font-size: 22rpx;
        color: $text-weak;
        margin-top: 4rpx;
      }
    }
  }

  .coupon-amount {
    font-size: 30rpx;
    color: $color-primary-danger;
    font-weight: 600;
    flex-shrink: 0;
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
