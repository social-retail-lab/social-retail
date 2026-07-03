<template>
  <view class="page-container">
    <view class="order-header">
      <view class="header-left" @click="handleBack">
        <text class="back-icon">‹</text>
      </view>
      <text class="header-title">确认订单</text>
      <view class="header-right"></view>
    </view>

    <scroll-view 
      scroll-y 
      class="page-content"
      :refresher-enabled="false"
      :scroll-with-animation="true"
    >
      <view class="delivery-tabs">
        <view 
          class="delivery-tab" 
          :class="{ 'tab-active': deliveryType === 1 }"
          @click="changeDeliveryType(1)"
        >
          <text>配送到家</text>
        </view>
        <view 
          class="delivery-tab" 
          :class="{ 'tab-active': deliveryType === 2 }"
          @click="changeDeliveryType(2)"
        >
          <text>门店自提</text>
        </view>
      </view>

      <view v-if="deliveryType === 1" class="address-section">
        <view v-if="addressInfo" class="address-card" @click="selectAddress">
          <view class="address-icon">
            <text>📍</text>
          </view>
          <view class="address-info">
            <view class="address-top">
              <text class="receiver-name">{{ addressInfo.receiverName }}</text>
              <text class="receiver-phone">{{ addressInfo.receiverPhone }}</text>
            </view>
            <text class="address-detail">{{ addressInfo.fullAddress }}</text>
          </view>
          <text class="address-arrow">›</text>
        </view>
        <view v-else class="address-empty" @click="selectAddress">
          <text class="empty-icon">+</text>
          <text class="empty-text">添加收货地址</text>
        </view>
      </view>

      <view v-if="deliveryType === 2" class="pickup-section">
        <view v-if="pickupPoint" class="pickup-card" @click="selectPickupPoint">
          <view class="pickup-icon">
            <text>🏪</text>
          </view>
          <view class="pickup-info">
            <text class="pickup-name">{{ pickupPoint.name }}</text>
            <text class="pickup-address">{{ pickupPoint.address }}</text>
          </view>
          <text class="address-arrow">›</text>
        </view>
        <view v-else class="pickup-empty" @click="selectPickupPoint">
          <text class="empty-icon">+</text>
          <text class="empty-text">选择自提点</text>
        </view>
      </view>

      <view class="goods-section">
        <view class="section-header">
          <text class="section-title">商品清单</text>
        </view>
        <view class="goods-list">
          <view v-for="item in orderData.itemList" :key="item.orderItemId || item.cartItemId" class="goods-item">
            <image :src="getValidImageUrl(item.productImage)" class="goods-image" mode="aspectFill" />
            <view class="goods-info">
              <text class="goods-name">{{ item.productName }}</text>
              <text class="goods-sku">{{ item.skuSpecs }}</text>
              <view class="goods-bottom">
                <text class="goods-price">¥{{ item.finalPrice?.toFixed(2) || item.price?.toFixed(2) }}</text>
                <text class="goods-count">×{{ item.quantity }}</text>
              </view>
            </view>
          </view>
        </view>
      </view>

      <view class="coupon-section" @click="showCouponPopup = true">
        <view class="coupon-left">
          <text class="coupon-icon">🎫</text>
          <text class="coupon-label">优惠券</text>
        </view>
        <view class="coupon-right">
          <text v-if="selectedCoupon" class="coupon-value">-¥{{ selectedCoupon.discountAmount?.toFixed(2) }}</text>
          <text v-else-if="orderData.availableCoupons?.length > 0" class="coupon-available">{{ orderData.availableCoupons.length }}张可用</text>
          <text v-else class="coupon-none">暂无可用</text>
          <text class="coupon-arrow">›</text>
        </view>
      </view>

      <view class="points-section">
        <view class="points-left">
          <text class="points-icon">⭐</text>
          <text class="points-label">积分抵扣</text>
        </view>
        <view class="points-right">
          <switch 
            :checked="usePoints" 
            @change="togglePoints" 
            color="#FF6B35"
          />
          <view v-if="usePoints" class="points-input-wrap">
            <input 
              type="digit" 
              v-model="usePointsAmount" 
              class="points-input"
              :placeholder="`最多抵扣${orderData.maxUsablePoints || 0}积分`"
              @blur="onPointsAmountChange"
            />
            <text class="points-unit">积分</text>
          </view>
        </view>
      </view>

      <view v-if="orderData.activityInfo" class="activity-section">
        <view class="activity-left">
          <text class="activity-icon">🎯</text>
          <text class="activity-label">活动信息</text>
        </view>
        <text class="activity-value">{{ orderData.activityInfo.activityName || '活动商品' }}</text>
      </view>

      <view class="price-section">
        <view class="price-header">
          <text class="price-title">费用明细</text>
        </view>
        <view class="price-list">
          <view class="price-row">
            <text class="price-label">商品金额</text>
            <text class="price-value">¥{{ orderData.priceDetail?.totalAmount?.toFixed(2) || '0.00' }}</text>
          </view>
          <view v-if="orderData.priceDetail?.deliveryFee > 0" class="price-row">
            <text class="price-label">运费</text>
            <text class="price-value">¥{{ orderData.priceDetail.deliveryFee.toFixed(2) }}</text>
          </view>
          <view v-if="orderData.priceDetail?.deliveryFee === 0" class="price-row">
            <text class="price-label">运费</text>
            <text class="price-value">免运费</text>
          </view>
          <view v-if="orderData.priceDetail?.seckillDiscount > 0" class="price-row discount-row">
            <text class="price-label">秒杀优惠</text>
            <text class="price-discount">-¥{{ orderData.priceDetail.seckillDiscount.toFixed(2) }}</text>
          </view>
          <view v-if="orderData.priceDetail?.bargainDiscount > 0" class="price-row discount-row">
            <text class="price-label">砍价优惠</text>
            <text class="price-discount">-¥{{ orderData.priceDetail.bargainDiscount.toFixed(2) }}</text>
          </view>
          <view v-if="orderData.priceDetail?.couponDiscount > 0" class="price-row discount-row">
            <text class="price-label">优惠券</text>
            <text class="price-discount">-¥{{ orderData.priceDetail.couponDiscount.toFixed(2) }}</text>
          </view>
          <view v-if="orderData.priceDetail?.pointsDeduction > 0" class="price-row discount-row">
            <text class="price-label">积分抵扣</text>
            <text class="price-discount">-¥{{ orderData.priceDetail.pointsDeduction.toFixed(2) }}</text>
          </view>
          <view v-if="orderData.priceDetail?.fullReductionDiscount > 0" class="price-row discount-row">
            <text class="price-label">满减优惠</text>
            <text class="price-discount">-¥{{ orderData.priceDetail.fullReductionDiscount.toFixed(2) }}</text>
          </view>
        </view>
        <view class="price-divider"></view>
        <view class="price-total">
          <text class="total-label">实付金额</text>
          <text class="total-value">¥{{ orderData.priceDetail?.payAmount?.toFixed(2) || '0.00' }}</text>
        </view>
      </view>

      <view class="remark-section">
        <text class="remark-label">订单备注</text>
        <input 
          class="remark-input" 
          v-model="remark" 
          placeholder="选填，可填写您的特殊需求"
          maxlength="100"
        />
      </view>

      <view class="bottom-space"></view>
    </scroll-view>

    <view class="order-footer">
      <view class="footer-left">
        <text class="footer-label">合计：</text>
        <text class="footer-amount">¥{{ orderData.priceDetail?.payAmount?.toFixed(2) || '0.00' }}</text>
      </view>
      <view 
        class="submit-btn" 
        :class="{ 'btn-disabled': !canSubmit }"
        @click="submitOrder"
      >
        <text>提交订单</text>
      </view>
    </view>

    <view v-if="showCouponPopup" class="popup-mask" @click="showCouponPopup = false">
      <view class="coupon-popup" @click.stop>
        <view class="popup-header">
          <text class="popup-title">选择优惠券</text>
          <text class="popup-close" @click="showCouponPopup = false">✕</text>
        </view>
        <scroll-view scroll-y class="coupon-list">
          <view 
            class="coupon-item"
            :class="{ 'coupon-selected': !selectedCoupon }"
            @click="selectCoupon(null)"
          >
            <view class="coupon-check">
              <view v-if="!selectedCoupon" class="check-dot"></view>
            </view>
            <view class="coupon-content">
              <text class="coupon-name">不使用优惠券</text>
            </view>
          </view>
          <view 
            v-for="coupon in orderData.availableCoupons" 
            :key="coupon.couponUserId"
            class="coupon-item"
            :class="{ 'coupon-selected': selectedCoupon?.couponUserId === coupon.couponUserId }"
            @click="selectCoupon(coupon)"
          >
            <view class="coupon-check">
              <view v-if="selectedCoupon?.couponUserId === coupon.couponUserId" class="check-dot"></view>
            </view>
            <view class="coupon-content">
              <text class="coupon-name">{{ coupon.couponTitle }}</text>
              <text class="coupon-desc">{{ coupon.minAmount ? `满${coupon.minAmount}可用` : '无门槛' }}</text>
            </view>
            <text class="coupon-discount">-¥{{ coupon.discountAmount?.toFixed(2) }}</text>
          </view>
        </scroll-view>
      </view>
    </view>
  </view>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue'
import { showToast, getValidImageUrl } from '@/utils/common'
import { useOrder } from '@/hooks/useOrder'
import { useAddress } from '@/hooks/useAddress'
import { useCart } from '@/hooks/useCart'

const cartItemIds = ref([])
const deliveryType = ref(1)
const addressId = ref(null)
const pickupPointId = ref(null)
const remark = ref('')
const usePoints = ref(false)
const usePointsAmount = ref('')
const couponUserId = ref(null)
const orderSource = ref('')
const showCouponPopup = ref(false)

const addressInfo = ref(null)
const pickupPoint = ref(null)
const selectedCoupon = ref(null)
const orderHook = useOrder()
const addressHook = useAddress()
const cartHook = useCart()

const orderData = ref({
  priceDetail: {
    totalAmount: 0,
    seckillDiscount: 0,
    bargainDiscount: 0,
    couponDiscount: 0,
    pointsDeduction: 0,
    deliveryFee: 0,
    payAmount: 0,
    fullReductionDiscount: 0
  },
  promotionDetail: [],
  promotionSnapshot: {},
  addressInfo: {},
  itemList: [],
  couponInfo: null,
  activityInfo: {},
  availableCoupons: [],
  maxUsablePoints: 0
})

const canSubmit = computed(() => {
  const hasAddress = deliveryType.value === 1 ? addressId.value : pickupPointId.value
  return hasAddress && orderData.value.itemList.length > 0 && !orderHook.loading.value && !orderHook.previewLoading.value
})

const handleBack = () => {
  uni.navigateBack()
}

const selectAddress = () => {
  uni.navigateTo({ url: '/pages/address/list?select=1' })
}

const selectPickupPoint = () => {
  showToast('自提点选择功能开发中')
}

const changeDeliveryType = (type) => {
  deliveryType.value = type
  if (type === 1) {
    pickupPointId.value = null
  } else {
    addressId.value = null
  }
  if (cartItemIds.value.length > 0) {
    fetchOrderPreview()
  }
}

const selectCoupon = (coupon) => {
  selectedCoupon.value = coupon
  couponUserId.value = coupon?.couponUserId || null
  showCouponPopup.value = false
  if (cartItemIds.value.length > 0) {
    fetchOrderPreview()
  }
}

const togglePoints = (e) => {
  usePoints.value = e.detail.value
  if (!usePoints.value) {
    usePointsAmount.value = ''
  } else {
    usePointsAmount.value = '0'
  }
  if (cartItemIds.value.length > 0) {
    fetchOrderPreview()
  }
}

const onPointsAmountChange = () => {
  const amount = parseInt(usePointsAmount.value) || 0
  const maxPoints = orderData.value.maxUsablePoints || 0
  if (amount > maxPoints) {
    usePointsAmount.value = maxPoints.toString()
    showToast(`最多抵扣${maxPoints}积分`)
  }
  if (cartItemIds.value.length > 0) {
    fetchOrderPreview()
  }
}

const fetchDefaultAddress = async () => {
  const res = await addressHook.loadDefaultAddress()
  if (res) {
    addressInfo.value = {
      addressId: res.addressId,
      receiverName: res.receiverName,
      receiverPhone: res.receiverPhone,
      fullAddress: `${res.province}${res.city}${res.district}${res.detailAddress}`
    }
    addressId.value = res.addressId
  }
}

const fetchOrderPreview = async () => {
  const data = {
    cartItemIds: cartItemIds.value,
    deliveryType: deliveryType.value,
    addressId: deliveryType.value === 1 ? addressId.value : null,
    pickupPointId: deliveryType.value === 2 ? pickupPointId.value : null,
    couponUserId: couponUserId.value,
    usePoints: usePoints.value,
    usePointsAmount: usePoints.value ? (parseInt(usePointsAmount.value) || 0) : 0,
    activityContext: {
      seckillId: null,
      bargainId: null
    },
    remark: remark.value
  }
  
  const previewData = await orderHook.loadOrderPreview(data)
  
  if (previewData) {
    orderData.value = {
      priceDetail: previewData.priceDetail || {
        totalAmount: 0,
        seckillDiscount: 0,
        bargainDiscount: 0,
        couponDiscount: 0,
        pointsDeduction: 0,
        deliveryFee: 0,
        payAmount: 0,
        fullReductionDiscount: 0
      },
      promotionDetail: previewData.promotionDetail || [],
      promotionSnapshot: previewData.promotionSnapshot || {},
      addressInfo: previewData.addressInfo || {},
      itemList: previewData.itemList || [],
      couponInfo: previewData.couponInfo || null,
      activityInfo: previewData.activityInfo || {},
      availableCoupons: previewData.availableCoupons || [],
      maxUsablePoints: previewData.maxUsablePoints || 0
    }
    
    if (previewData.couponInfo && previewData.couponInfo.couponUserId) {
      selectedCoupon.value = previewData.couponInfo
      couponUserId.value = previewData.couponInfo.couponUserId
    }
  }
}

const submitOrder = async () => {
  if (!canSubmit.value) {
    showToast(deliveryType.value === 1 ? '请选择收货地址' : '请选择自提点')
    return
  }
  
  if (orderHook.loading.value) {
    return
  }

  const idempotentKey = `order-${Date.now()}-${Math.random().toString(36).substr(2, 9)}`
  
  const data = {
    cartItemIds: cartItemIds.value,
    deliveryType: deliveryType.value,
    addressId: deliveryType.value === 1 ? addressId.value : null,
    pickupPointId: deliveryType.value === 2 ? pickupPointId.value : null,
    couponUserId: couponUserId.value,
    usePoints: usePoints.value,
    usePointsAmount: usePoints.value ? (parseInt(usePointsAmount.value) || 0) : 0,
    activityContext: {
      seckillId: orderData.value.activityInfo?.seckillActivityId || null,
      bargainId: orderData.value.activityInfo?.bargainActivityId || null,
      groupId: null,
      promotionIds: []
    },
    remark: remark.value,
    idempotentKey
  }
  
  const orderInfo = await orderHook.createOrder(data)
  
  if (orderInfo) {
    setTimeout(() => {
      uni.redirectTo({ 
        url: `/pagesSub/order/pay/payOrder?orderId=${orderInfo.orderId}&orderSn=${orderInfo.orderSn}&payAmount=${orderInfo.payAmount}&expireTime=${orderInfo.expireTime}` 
      })
    }, 800)
  }
}

const handleBuyNow = async (skuId, quantity) => {
  try {
    const result = await cartHook.addCart({ skuId, quantity })
    if (result && result.cartItemId) {
      return result.cartItemId
    } else {
      showToast('添加购物车失败')
      return null
    }
  } catch (error) {
    console.error('添加购物车失败:', error)
    showToast('添加购物车失败')
    return null
  }
}

const initOrderData = async () => {
  const pages = getCurrentPages()
  const currentPage = pages[pages.length - 1]
  const options = currentPage.$page?.options || currentPage.options || {}
  
  orderSource.value = options.source || 'cart'
  
  if (orderSource.value === 'buyNow') {
    const skuId = parseInt(options.skuId)
    const quantity = parseInt(options.quantity) || 1
    
    if (skuId) {
      const cartItemId = await handleBuyNow(skuId, quantity)
      if (cartItemId) {
        cartItemIds.value = [cartItemId]
      }
    }
  } else {
    if (options.cartItemId) {
      cartItemIds.value = [parseInt(options.cartItemId)]
    } else if (options.cartItemIds) {
      cartItemIds.value = options.cartItemIds.split(',').map(id => parseInt(id))
    } else if (options.ids) {
      cartItemIds.value = options.ids.split(',').map(id => parseInt(id))
    }
  }
  
  await fetchDefaultAddress()
  
  if (cartItemIds.value.length > 0) {
    fetchOrderPreview()
  }
}

onMounted(() => {
  initOrderData()
})

watch(addressId, (newId) => {
  if (newId && deliveryType.value === 1 && cartItemIds.value.length > 0) {
    fetchOrderPreview()
  }
})

watch(pickupPointId, (newId) => {
  if (newId && deliveryType.value === 2 && cartItemIds.value.length > 0) {
    fetchOrderPreview()
  }
})

watch(deliveryType, () => {
  if (cartItemIds.value.length > 0) {
    fetchOrderPreview()
  }
})

watch(couponUserId, () => {
  if (cartItemIds.value.length > 0) {
    fetchOrderPreview()
  }
})

watch(usePoints, () => {
  if (cartItemIds.value.length > 0) {
    fetchOrderPreview()
  }
})

watch(usePointsAmount, () => {
  if (cartItemIds.value.length > 0 && usePoints.value) {
    fetchOrderPreview()
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

.delivery-tabs {
  display: flex;
  margin: 24rpx;
  background: $bg-card;
  border-radius: 16rpx;
  padding: 8rpx;
  
  .delivery-tab {
    flex: 1;
    padding: 20rpx;
    text-align: center;
    border-radius: 12rpx;
    transition: all 0.2s ease;
    
    text {
      font-size: 28rpx;
      color: $text-sub;
    }
    
    &.tab-active {
      background: linear-gradient(135deg, $color-primary 0%, $color-primary-danger 100%);
      
      text {
        color: #FFFFFF;
        font-weight: 500;
      }
    }
  }
}

.address-section, .pickup-section {
  margin: 0 24rpx;
}

.address-card, .pickup-card {
  padding: 32rpx;
  background: $bg-card;
  border-radius: 24rpx;
  display: flex;
  align-items: center;
  
  .address-icon, .pickup-icon {
    font-size: 48rpx;
    margin-right: 20rpx;
  }
  
  .address-info, .pickup-info {
    flex: 1;
    
    .address-top {
      display: flex;
      align-items: center;
      margin-bottom: 12rpx;
      
      .receiver-name {
        font-size: 32rpx;
        font-weight: 600;
        color: $text-main;
        margin-right: 20rpx;
      }
      
      .receiver-phone {
        font-size: 28rpx;
        color: $text-sub;
      }
    }
    
    .address-detail, .pickup-address {
      font-size: 28rpx;
      color: $text-sub;
      line-height: 1.4;
    }
    
    .pickup-name {
      font-size: 30rpx;
      font-weight: 500;
      color: $text-main;
      display: block;
      margin-bottom: 8rpx;
    }
  }
  
  .address-arrow {
    font-size: 36rpx;
    color: $text-weak;
    margin-left: 16rpx;
  }
}

.address-empty, .pickup-empty {
  padding: 48rpx;
  background: $bg-card;
  border-radius: 24rpx;
  border: 2rpx dashed $gray-300;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  
  .empty-icon {
    width: 80rpx;
    height: 80rpx;
    border-radius: 50%;
    background: rgba($color-primary, 0.1);
    color: $color-primary;
    font-size: 48rpx;
    display: flex;
    align-items: center;
    justify-content: center;
    margin-bottom: 16rpx;
  }
  
  .empty-text {
    font-size: 28rpx;
    color: $text-sub;
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
      width: 180rpx;
      height: 180rpx;
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
      
      .goods-sku {
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
          font-size: 32rpx;
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
}

.coupon-section, .points-section, .activity-section {
  margin: 24rpx;
  padding: 28rpx;
  background: $bg-card;
  border-radius: 24rpx;
  display: flex;
  align-items: center;
  justify-content: space-between;
  
  .coupon-left, .points-left, .activity-left {
    display: flex;
    align-items: center;
    
    .coupon-icon, .points-icon, .activity-icon {
      font-size: 36rpx;
      margin-right: 16rpx;
    }
    
    .coupon-label, .points-label, .activity-label {
      font-size: 28rpx;
      color: $text-main;
    }
  }
  
  .coupon-right {
    display: flex;
    align-items: center;
    
    .coupon-value {
      font-size: 28rpx;
      color: $color-primary-danger;
      font-weight: 500;
      margin-right: 12rpx;
    }
    
    .coupon-available {
      font-size: 26rpx;
      color: $color-primary;
      margin-right: 12rpx;
    }
    
    .coupon-none {
      font-size: 26rpx;
      color: $text-weak;
      margin-right: 12rpx;
    }
    
    .coupon-arrow {
      font-size: 32rpx;
      color: $text-weak;
    }
  }
  
  .points-right {
    display: flex;
    align-items: center;
    
    .points-input-wrap {
      display: flex;
      align-items: center;
      margin-left: 16rpx;
      
      .points-input {
        width: 120rpx;
        height: 56rpx;
        background: $bg-page-light;
        border-radius: 8rpx;
        text-align: center;
        font-size: 26rpx;
        color: $text-main;
      }
      
      .points-unit {
        font-size: 24rpx;
        color: $text-sub;
        margin-left: 8rpx;
      }
    }
  }
  
  .activity-value {
    font-size: 26rpx;
    color: $color-primary;
  }
}

.price-section {
  margin: 24rpx;
  background: $bg-card;
  border-radius: 24rpx;
  padding: 24rpx;
  
  .price-header {
    margin-bottom: 20rpx;
    
    .price-title {
      font-size: 30rpx;
      font-weight: 600;
      color: $text-main;
    }
  }
  
  .price-list {
    .price-row {
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding: 12rpx 0;
      
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
  }
  
  .price-divider {
    height: 1rpx;
    background: $bg-page-light;
    margin: 20rpx 0;
  }
  
  .price-total {
    display: flex;
    align-items: center;
    justify-content: space-between;
    
    .total-label {
      font-size: 30rpx;
      color: $text-main;
      font-weight: 500;
    }
    
    .total-value {
      font-size: 40rpx;
      color: $color-primary-danger;
      font-weight: 600;
    }
  }
}

.remark-section {
  margin: 24rpx;
  background: $bg-card;
  border-radius: 24rpx;
  padding: 24rpx;
  display: flex;
  align-items: center;
  
  .remark-label {
    font-size: 28rpx;
    color: $text-main;
    margin-right: 20rpx;
  }
  
  .remark-input {
    flex: 1;
    font-size: 28rpx;
    color: $text-main;
  }
}

.bottom-space {
  height: calc(140rpx + env(safe-area-inset-bottom));
}

.order-footer {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  z-index: 100;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 20rpx 32rpx;
  padding-bottom: calc(20rpx + env(safe-area-inset-bottom));
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
      font-size: 40rpx;
      color: $color-primary-danger;
      font-weight: 600;
      margin-left: 8rpx;
    }
  }
  
  .submit-btn {
    padding: 24rpx 64rpx;
    background: linear-gradient(135deg, $color-primary 0%, $color-primary-danger 100%);
    border-radius: 48rpx;
    
    text {
      font-size: 32rpx;
      color: #FFFFFF;
      font-weight: 600;
    }
    
    &.btn-disabled {
      opacity: 0.4;
      background: #CCCCCC;
    }
  }
}

.popup-mask {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.5);
  z-index: 200;
  display: flex;
  align-items: flex-end;
  justify-content: center;
}

.coupon-popup {
  width: 100%;
  max-height: 70vh;
  background: $bg-card;
  border-radius: 32rpx 32rpx 0 0;
  overflow: hidden;
  
  .popup-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 32rpx;
    border-bottom: 1rpx solid $bg-page-light;
    
    .popup-title {
      font-size: 32rpx;
      font-weight: 600;
      color: $text-main;
    }
    
    .popup-close {
      font-size: 36rpx;
      color: $text-weak;
      padding: 16rpx;
    }
  }
  
  .coupon-list {
    max-height: calc(70vh - 96rpx);
    padding: 16rpx 24rpx;
  }
  
  .coupon-item {
    display: flex;
    align-items: center;
    padding: 24rpx;
    background: $bg-page-light;
    border-radius: 16rpx;
    margin-bottom: 16rpx;
    transition: all 0.2s ease;
    
    &.coupon-selected {
      background: rgba($color-primary, 0.1);
      border: 1rpx solid $color-primary;
    }
    
    .coupon-check {
      width: 40rpx;
      height: 40rpx;
      border: 2rpx solid $gray-300;
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      margin-right: 20rpx;
      
      .check-dot {
        width: 24rpx;
        height: 24rpx;
        background: $color-primary;
        border-radius: 50%;
      }
    }
    
    .coupon-content {
      flex: 1;
      
      .coupon-name {
        font-size: 28rpx;
        color: $text-main;
        display: block;
        margin-bottom: 8rpx;
      }
      
      .coupon-desc {
        font-size: 24rpx;
        color: $text-weak;
      }
    }
    
    .coupon-discount {
      font-size: 32rpx;
      color: $color-primary-danger;
      font-weight: 600;
    }
  }
}
</style>