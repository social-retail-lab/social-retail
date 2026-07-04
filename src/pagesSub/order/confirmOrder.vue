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
      <!-- 模块1: 配送方式切换 -->
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
        <view v-if="pickupPointInfo" class="pickup-card" @click="selectPickupPoint">
          <view class="pickup-icon">
            <text>🏪</text>
          </view>
          <view class="pickup-info">
            <text class="pickup-name">{{ pickupPointInfo.name }}</text>
            <text class="pickup-address">{{ pickupPointInfo.address }}</text>
          </view>
          <text class="address-arrow">›</text>
        </view>
        <view v-else class="pickup-empty" @click="selectPickupPoint">
          <text class="empty-icon">+</text>
          <text class="empty-text">选择自提点</text>
        </view>
      </view>

      <!-- 模块2: 商品明细 -->
      <view class="goods-section">
        <view class="section-header">
          <text class="section-title">商品清单</text>
        </view>
        <view class="goods-list">
          <view
            v-for="item in previewData.itemList"
            :key="item.cartItemId || item.skuId"
            class="goods-item"
          >
            <image
              :src="getValidImageUrl(item.productImage)"
              class="goods-image"
              mode="aspectFill"
            />
            <view class="goods-info">
              <text class="goods-name">{{ item.productName }}</text>
              <text v-if="item.skuSpecs" class="goods-sku">{{ item.skuSpecs }}</text>
              <view class="goods-bottom">
                <view class="goods-price-wrap">
                  <text
                    v-if="item.originPrice > item.finalPrice"
                    class="goods-origin-price"
                  >¥{{ formatPrice(item.originPrice) }}</text>
                  <text class="goods-price">¥{{ formatPrice(item.finalPrice) }}</text>
                </view>
                <text class="goods-count">×{{ item.quantity }}</text>
              </view>
            </view>
          </view>
        </view>
      </view>

      <!-- 模块3: 优惠选择 -->
      <view
        class="coupon-section"
        @click="openPlatformCouponPopup"
      >
        <view class="coupon-left">
          <text class="coupon-icon">🎫</text>
          <text class="coupon-label">平台优惠券</text>
        </view>
        <view class="coupon-right">
          <text
            v-if="previewData.couponInfo?.platformCoupon"
            class="coupon-value"
          >-¥{{ formatPrice(previewData.couponInfo.platformCoupon.discountAmount) }}</text>
          <text
            v-else-if="availablePlatformCouponCount > 0"
            class="coupon-available"
          >{{ availablePlatformCouponCount }}张可用</text>
          <text v-else class="coupon-none">暂无可用</text>
          <text class="coupon-arrow">›</text>
        </view>
      </view>

      <view
        class="coupon-section"
        @click="openMerchantCouponPopup"
      >
        <view class="coupon-left">
          <text class="coupon-icon">🎫</text>
          <text class="coupon-label">商家优惠券</text>
        </view>
        <view class="coupon-right">
          <text
            v-if="previewData.couponInfo?.merchantCoupon"
            class="coupon-value"
          >-¥{{ formatPrice(previewData.couponInfo.merchantCoupon.discountAmount) }}</text>
          <text
            v-else-if="availableMerchantCouponCount > 0"
            class="coupon-available"
          >{{ availableMerchantCouponCount }}张可用</text>
          <text v-else class="coupon-none">暂无可用</text>
          <text class="coupon-arrow">›</text>
        </view>
      </view>

      <view class="points-section">
        <view class="points-left">
          <text class="points-icon">⭐</text>
          <view class="points-info">
            <text class="points-label">积分抵扣</text>
            <text class="points-balance">
              可用积分: {{ previewData.pointsInfo?.pointsBalance || 0 }}
            </text>
          </view>
        </view>
        <view class="points-right">
          <switch
            :checked="usePoints"
            @change="togglePoints"
            color="#FF6A00"
            :disabled="!previewData.pointsInfo?.canUsePoints"
          />
          <view v-if="usePoints" class="points-input-wrap">
            <input
              type="digit"
              v-model="usePointsAmount"
              class="points-input"
              :placeholder="`最多${previewData.pointsInfo?.maxUsablePoints || 0}积分`"
              @blur="onPointsAmountChange"
            />
            <text class="points-unit">积分</text>
          </view>
          <view
            v-if="usePoints && previewData.pointsInfo?.deductionAmount > 0"
            class="points-deduction-tip"
          >
            <text>可抵扣 ¥{{ formatPrice(previewData.pointsInfo.deductionAmount) }}</text>
          </view>
        </view>
      </view>

      <view v-if="hasActivity" class="activity-section">
        <view class="activity-left">
          <text class="activity-icon">🎯</text>
          <text class="activity-label">活动信息</text>
        </view>
        <text class="activity-value">{{ activityText }}</text>
      </view>

      <!-- 模块4: 订单备注 -->
      <view class="remark-section">
        <text class="remark-label">订单备注</text>
        <input
          class="remark-input"
          v-model="remark"
          placeholder="选填，可填写您的特殊需求"
          maxlength="500"
          @blur="onRemarkBlur"
        />
      </view>

      <!-- 模块5: 价格汇总 -->
      <view class="price-section">
        <view class="price-header">
          <text class="price-title">费用明细</text>
        </view>
        <view class="price-list">
          <view class="price-row">
            <text class="price-label">商品金额</text>
            <text class="price-value">¥{{ formatPrice(previewData.priceDetail?.totalAmount) }}</text>
          </view>
          <view v-if="previewData.priceDetail?.deliveryFee > 0" class="price-row">
            <text class="price-label">运费</text>
            <text class="price-value">¥{{ formatPrice(previewData.priceDetail.deliveryFee) }}</text>
          </view>
          <view v-else class="price-row">
            <text class="price-label">运费</text>
            <text class="price-value">免运费</text>
          </view>
          <view v-if="previewData.priceDetail?.seckillDiscount > 0" class="price-row discount-row">
            <text class="price-label">秒杀优惠</text>
            <text class="price-discount">-¥{{ formatPrice(previewData.priceDetail.seckillDiscount) }}</text>
          </view>
          <view v-if="previewData.priceDetail?.bargainDiscount > 0" class="price-row discount-row">
            <text class="price-label">砍价优惠</text>
            <text class="price-discount">-¥{{ formatPrice(previewData.priceDetail.bargainDiscount) }}</text>
          </view>
          <view v-if="previewData.priceDetail?.promotionDiscount > 0" class="price-row discount-row">
            <text class="price-label">促销优惠</text>
            <text class="price-discount">-¥{{ formatPrice(previewData.priceDetail.promotionDiscount) }}</text>
          </view>
          <view v-if="previewData.priceDetail?.platformCouponDiscount > 0" class="price-row discount-row">
            <text class="price-label">平台优惠券</text>
            <text class="price-discount">-¥{{ formatPrice(previewData.priceDetail.platformCouponDiscount) }}</text>
          </view>
          <view v-if="previewData.priceDetail?.merchantCouponDiscount > 0" class="price-row discount-row">
            <text class="price-label">商家优惠券</text>
            <text class="price-discount">-¥{{ formatPrice(previewData.priceDetail.merchantCouponDiscount) }}</text>
          </view>
          <view v-if="previewData.priceDetail?.pointsDeduction > 0" class="price-row discount-row">
            <text class="price-label">积分抵扣</text>
            <text class="price-discount">-¥{{ formatPrice(previewData.priceDetail.pointsDeduction) }}</text>
          </view>
        </view>
        <view class="price-divider"></view>
        <view class="price-total">
          <text class="total-label">实付金额</text>
          <text class="total-value">¥{{ formatPrice(previewData.priceDetail?.payAmount) }}</text>
        </view>
      </view>

      <view class="bottom-space"></view>
    </scroll-view>

    <!-- 底部提交栏 -->
    <view class="order-footer">
      <view class="footer-left">
        <text class="footer-label">合计：</text>
        <text class="footer-amount">¥{{ formatPrice(previewData.priceDetail?.payAmount) }}</text>
      </view>
      <view
        class="submit-btn"
        :class="{ 'btn-disabled': !canSubmit }"
        @click="submitOrder"
      >
        <text>提交订单</text>
      </view>
    </view>

    <!-- 平台优惠券弹窗 -->
    <view
      v-if="showPlatformCouponPopup"
      class="popup-mask"
      @click="showPlatformCouponPopup = false"
    >
      <view class="coupon-popup" @click.stop>
        <view class="popup-header">
          <text class="popup-title">选择平台优惠券</text>
          <text class="popup-close" @click="showPlatformCouponPopup = false">✕</text>
        </view>
        <scroll-view scroll-y class="coupon-list">
          <!-- 加载中 -->
          <view v-if="availableCouponsLoading" class="coupon-loading">
            <view class="loading-spinner"></view>
            <text class="loading-text">加载中...</text>
          </view>
          <template v-else>
            <view
              class="coupon-item"
              :class="{ 'coupon-selected': !usePlatformCoupon }"
              @click="selectPlatformCoupon(null)"
            >
              <view class="coupon-check">
                <view v-if="!usePlatformCoupon" class="check-dot"></view>
              </view>
              <view class="coupon-content">
                <text class="coupon-name">不使用平台优惠券</text>
              </view>
            </view>
            <view
              v-for="coupon in availablePlatformCoupons"
              :key="coupon.couponUserId"
              class="coupon-item"
              :class="{
                'coupon-selected': platformCouponUserId === coupon.couponUserId && usePlatformCoupon,
                'coupon-item-disabled': !coupon.available
              }"
              @click="selectPlatformCoupon(coupon)"
            >
              <view class="coupon-check">
                <view
                  v-if="platformCouponUserId === coupon.couponUserId && usePlatformCoupon"
                  class="check-dot"
                ></view>
              </view>
              <view class="coupon-content">
                <view class="coupon-name-row">
                  <text class="coupon-name">{{ coupon.title }}</text>
                  <text v-if="coupon.recommended" class="recommend-tag">推荐</text>
                </view>
                <text class="coupon-desc">{{ coupon.minConsume ? `满${coupon.minConsume}可用` : '无门槛' }}</text>
                <text v-if="!coupon.available && coupon.unavailableReason" class="coupon-reason">
                  {{ coupon.unavailableReason }}
                </text>
              </view>
              <text class="coupon-discount">-¥{{ formatPrice(coupon.discountAmount) }}</text>
            </view>
            <!-- 空状态 -->
            <view v-if="availablePlatformCoupons.length === 0" class="coupon-empty">
              <text class="empty-text">暂无可用平台优惠券</text>
            </view>
          </template>
        </scroll-view>
      </view>
    </view>

    <!-- 商家优惠券弹窗 -->
    <view
      v-if="showMerchantCouponPopup"
      class="popup-mask"
      @click="showMerchantCouponPopup = false"
    >
      <view class="coupon-popup" @click.stop>
        <view class="popup-header">
          <text class="popup-title">选择商家优惠券</text>
          <text class="popup-close" @click="showMerchantCouponPopup = false">✕</text>
        </view>
        <scroll-view scroll-y class="coupon-list">
          <!-- 加载中 -->
          <view v-if="availableCouponsLoading" class="coupon-loading">
            <view class="loading-spinner"></view>
            <text class="loading-text">加载中...</text>
          </view>
          <template v-else>
            <view
              class="coupon-item"
              :class="{ 'coupon-selected': !useMerchantCoupon }"
              @click="selectMerchantCoupon(null)"
            >
              <view class="coupon-check">
                <view v-if="!useMerchantCoupon" class="check-dot"></view>
              </view>
              <view class="coupon-content">
                <text class="coupon-name">不使用商家优惠券</text>
              </view>
            </view>
            <view
              v-for="coupon in availableMerchantCoupons"
              :key="coupon.couponUserId"
              class="coupon-item"
              :class="{
                'coupon-selected': merchantCouponUserId === coupon.couponUserId && useMerchantCoupon,
                'coupon-item-disabled': !coupon.available
              }"
              @click="selectMerchantCoupon(coupon)"
            >
              <view class="coupon-check">
                <view
                  v-if="merchantCouponUserId === coupon.couponUserId && useMerchantCoupon"
                  class="check-dot"
                ></view>
              </view>
              <view class="coupon-content">
                <view class="coupon-name-row">
                  <text class="coupon-name">{{ coupon.title }}</text>
                  <text v-if="coupon.recommended" class="recommend-tag">推荐</text>
                </view>
                <text class="coupon-desc">{{ coupon.minConsume ? `满${coupon.minConsume}可用` : '无门槛' }}</text>
                <text v-if="!coupon.available && coupon.unavailableReason" class="coupon-reason">
                  {{ coupon.unavailableReason }}
                </text>
              </view>
              <text class="coupon-discount">-¥{{ formatPrice(coupon.discountAmount) }}</text>
            </view>
            <!-- 空状态 -->
            <view v-if="availableMerchantCoupons.length === 0" class="coupon-empty">
              <text class="empty-text">暂无可用商家优惠券</text>
            </view>
          </template>
        </scroll-view>
      </view>
    </view>
  </view>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { showToast, getValidImageUrl } from '@/utils/common'
import { useOrder } from '@/hooks/useOrder'
import { useAddress } from '@/hooks/useAddress'
import { useCart } from '@/hooks/useCart'
import { useMember } from '@/hooks/useMember'
import { useCoupon } from '@/hooks/useCoupon'
import { isCouponAvailable } from '@/constants/coupon'

// ==================== 基础状态 ====================
const cartItemIds = ref([])
const deliveryType = ref(1)
const addressId = ref(null)
const pickupPointId = ref(null)
const remark = ref('')

// 平台优惠券
const usePlatformCoupon = ref(true)
const platformCouponUserId = ref(null)

// 商家优惠券
const useMerchantCoupon = ref(true)
const merchantCouponUserId = ref(null)

// 积分抵扣
const usePoints = ref(false)
const usePointsAmount = ref('')

// 活动上下文
const activityContext = ref({})

const showPlatformCouponPopup = ref(false)
const showMerchantCouponPopup = ref(false)

// 4.3.4 预览订单可用优惠券
const couponHook = useCoupon()
const availableCouponsLoading = ref(false)
// 平台券/商家券列表(4.3.4 返回,含 available/unavailableReason/recommended 字段)
const availablePlatformCoupons = ref([])
const availableMerchantCoupons = ref([])

// ==================== previewToken 全局管理 ====================
const previewToken = ref('')
const previewExpireSeconds = ref(900)
const tokenExpired = ref(false)
let expireTimer = null

// ==================== hooks ====================
const orderHook = useOrder()
const addressHook = useAddress()
const cartHook = useCart()
const memberHook = useMember()

// ==================== 预览数据（与后端 preview 响应结构对齐） ====================
const previewData = ref({
  itemList: [],
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
  pointsInfo: {
    pointsBalance: 0,
    canUsePoints: false,
    maxUsablePoints: 0,
    usedPoints: 0,
    deductionAmount: 0,
    deductionRule: '',
    maxDeductionAmount: 0
  },
  couponInfo: {
    platformCoupon: null,
    merchantCoupon: null
  },
  promotionDetail: [],
  addressInfo: null,
  pickupPointInfo: null,
  activityInfo: {},
  availableCoupons: {
    platformCoupons: [],
    merchantCoupons: []
  }
})

// 本地缓存的地址/自提点信息（用于UI展示）
const addressInfo = ref(null)
const pickupPointInfo = ref(null)

// ==================== 计算属性 ====================
// 可用优惠券数量:优先使用 4.3.4 返回的数据(过滤 available=true),否则用预览接口数据
const availablePlatformCouponCount = computed(() => {
  if (availablePlatformCoupons.value.length > 0) {
    return availablePlatformCoupons.value.filter(c => c.available).length
  }
  return previewData.value.availableCoupons?.platformCoupons?.length || 0
})

const availableMerchantCouponCount = computed(() => {
  if (availableMerchantCoupons.value.length > 0) {
    return availableMerchantCoupons.value.filter(c => c.available).length
  }
  return previewData.value.availableCoupons?.merchantCoupons?.length || 0
})

const hasActivity = computed(() => {
  const info = previewData.value.activityInfo || {}
  return !!(info.seckillProductId || info.bargainRecordId || info.groupId || (info.promotionIds && info.promotionIds.length))
})

const activityText = computed(() => {
  const info = previewData.value.activityInfo || {}
  if (info.seckillProductId) return '秒杀活动'
  if (info.bargainRecordId) return '砍价活动'
  if (info.groupId) return '拼团活动'
  if (info.promotionIds && info.promotionIds.length) return '促销活动'
  return '活动商品'
})

// 提交按钮置灰条件：无地址/自提点、previewToken过期、加载中、商品为空
const canSubmit = computed(() => {
  const hasAddressOrPickup = deliveryType.value === 1
    ? (addressId.value || previewData.value.addressInfo?.addressId)
    : (pickupPointId.value || previewData.value.pickupPointInfo?.pickupPointId)
  if (!hasAddressOrPickup) return false
  if (!previewToken.value || tokenExpired.value) return false
  if (orderHook.loading.value || orderHook.previewLoading.value) return false
  if (!previewData.value.itemList || previewData.value.itemList.length === 0) return false
  return true
})

// ==================== 工具函数 ====================
const formatPrice = (price) => {
  return (Number(price) || 0).toFixed(2)
}

const handleBack = () => {
  uni.navigateBack()
}

// ==================== previewToken 过期管理 ====================
const setupTokenExpireTimer = (expireSeconds) => {
  if (expireTimer) {
    clearTimeout(expireTimer)
    expireTimer = null
  }
  tokenExpired.value = false
  expireTimer = setTimeout(() => {
    tokenExpired.value = true
    showToast('预览已过期，正在重新预览')
    fetchOrderPreview()
  }, expireSeconds * 1000)
}

const clearTokenExpireTimer = () => {
  if (expireTimer) {
    clearTimeout(expireTimer)
    expireTimer = null
  }
}

// ==================== 地址选择 ====================
const selectAddress = () => {
  uni.navigateTo({
    url: `/pages/address/list?select=1&addressId=${addressId.value || ''}`,
    events: {
      selectAddress: (data) => {
        onAddressSelected(data)
      }
    }
  })
}

const onAddressSelected = (data) => {
  addressId.value = data.addressId
  addressInfo.value = {
    addressId: data.addressId,
    receiverName: data.receiverName,
    receiverPhone: data.receiverPhone,
    fullAddress: data.fullAddress ||
      `${data.province || ''}${data.city || ''}${data.district || ''}${data.detailAddress || ''}`
  }
  if (cartItemIds.value.length > 0) {
    fetchOrderPreview()
  }
}

defineExpose({
  onSelectAddress: onAddressSelected
})

const selectPickupPoint = () => {
  showToast('自提点选择功能开发中')
}

// ==================== 配送方式切换 ====================
const changeDeliveryType = (type) => {
  if (deliveryType.value === type) return
  deliveryType.value = type
  if (type === 1) {
    pickupPointId.value = null
    pickupPointInfo.value = null
  } else {
    addressId.value = null
    addressInfo.value = null
  }
  if (cartItemIds.value.length > 0) {
    fetchOrderPreview()
  }
}

// ==================== 优惠券选择 ====================

/**
 * 打开平台优惠券弹窗(4.3.4 接口获取可用列表)
 */
const openPlatformCouponPopup = async () => {
  showPlatformCouponPopup.value = true
  if (cartItemIds.value.length === 0) return
  availableCouponsLoading.value = true
  try {
    const data = await couponHook.loadAvailableCoupons(cartItemIds.value)
    if (data) {
      availablePlatformCoupons.value = data.platformCoupons || []
      availableMerchantCoupons.value = data.merchantCoupons || []
    }
  } finally {
    availableCouponsLoading.value = false
  }
}

/**
 * 打开商家优惠券弹窗(4.3.4 接口获取可用列表)
 */
const openMerchantCouponPopup = async () => {
  showMerchantCouponPopup.value = true
  if (cartItemIds.value.length === 0) return
  // 平台券和商家券一起返回,若已加载过则直接复用
  if (availablePlatformCoupons.value.length === 0 && availableMerchantCoupons.value.length === 0) {
    availableCouponsLoading.value = true
    try {
      const data = await couponHook.loadAvailableCoupons(cartItemIds.value)
      if (data) {
        availablePlatformCoupons.value = data.platformCoupons || []
        availableMerchantCoupons.value = data.merchantCoupons || []
      }
    } finally {
      availableCouponsLoading.value = false
    }
  }
}

const selectPlatformCoupon = (coupon) => {
  // 不可用优惠券不允许选择
  if (coupon && !isCouponAvailable(coupon)) {
    showToast(coupon.unavailableReason || '该优惠券不可用')
    return
  }
  if (coupon) {
    usePlatformCoupon.value = true
    platformCouponUserId.value = coupon.couponUserId
  } else {
    usePlatformCoupon.value = false
    platformCouponUserId.value = null
  }
  showPlatformCouponPopup.value = false
  if (cartItemIds.value.length > 0) {
    fetchOrderPreview()
  }
}

const selectMerchantCoupon = (coupon) => {
  // 不可用优惠券不允许选择
  if (coupon && !isCouponAvailable(coupon)) {
    showToast(coupon.unavailableReason || '该优惠券不可用')
    return
  }
  if (coupon) {
    useMerchantCoupon.value = true
    merchantCouponUserId.value = coupon.couponUserId
  } else {
    useMerchantCoupon.value = false
    merchantCouponUserId.value = null
  }
  showMerchantCouponPopup.value = false
  if (cartItemIds.value.length > 0) {
    fetchOrderPreview()
  }
}

// ==================== 积分抵扣 ====================
const togglePoints = (e) => {
  usePoints.value = e.detail.value
  if (!usePoints.value) {
    usePointsAmount.value = ''
  } else {
    // 开启时传 null 让后端自动填充最大可用积分
    usePointsAmount.value = ''
  }
  if (cartItemIds.value.length > 0) {
    fetchOrderPreview()
  }
}

const onPointsAmountChange = () => {
  let amount = parseInt(usePointsAmount.value) || 0
  if (amount < 0) amount = 0

  const maxUsable = previewData.value.pointsInfo?.maxUsablePoints || 0
  const balance = previewData.value.pointsInfo?.pointsBalance || 0
  const maxLimit = Math.min(maxUsable, balance)

  if (amount > maxLimit) {
    amount = maxLimit
    showToast(`最多可使用${amount}积分`)
  }

  usePointsAmount.value = amount > 0 ? amount.toString() : ''
  if (cartItemIds.value.length > 0) {
    fetchOrderPreview()
  }
}

// ==================== 备注 ====================
const onRemarkBlur = () => {
  if (cartItemIds.value.length > 0) {
    fetchOrderPreview()
  }
}

// ==================== 默认地址加载 ====================
const fetchDefaultAddress = async () => {
  const res = await addressHook.loadDefaultAddress()
  // 只有当返回的地址有有效 addressId 时才设置
  if (res && res.addressId) {
    addressInfo.value = {
      addressId: res.addressId,
      receiverName: res.receiverName || '',
      receiverPhone: res.receiverPhone || '',
      fullAddress: `${res.province || ''}${res.city || ''}${res.district || ''}${res.detailAddress || ''}`
    }
    addressId.value = res.addressId
  } else {
    addressInfo.value = null
    addressId.value = null
  }
}

// ==================== 预览数据应用 ====================
const applyPreviewData = (data) => {
  if (!data) return

  previewData.value = {
    itemList: data.itemList || [],
    priceDetail: data.priceDetail || previewData.value.priceDetail,
    pointsInfo: data.pointsInfo || previewData.value.pointsInfo,
    couponInfo: data.couponInfo || { platformCoupon: null, merchantCoupon: null },
    promotionDetail: data.promotionDetail || [],
    addressInfo: data.addressInfo || null,
    pickupPointInfo: data.pickupPointInfo || null,
    activityInfo: data.activityInfo || {},
    availableCoupons: data.availableCoupons || { platformCoupons: [], merchantCoupons: [] }
  }

  // 清空 4.3.4 缓存:预览数据变更后,弹窗下次打开需重新加载可用优惠券
  availablePlatformCoupons.value = []
  availableMerchantCoupons.value = []

  // 同步地址信息：仅在用户未手动选择地址时，使用后端返回的默认地址
  if (data.addressInfo && deliveryType.value === 1 && !addressId.value) {
    addressInfo.value = data.addressInfo
    addressId.value = data.addressInfo.addressId
  }

  // 同步自提点信息
  if (data.pickupPointInfo && deliveryType.value === 2) {
    pickupPointInfo.value = data.pickupPointInfo
    pickupPointId.value = data.pickupPointInfo.pickupPointId
  }

  // 同步优惠券选中状态（后端自动选最优时回填）
  if (data.couponInfo) {
    if (data.couponInfo.platformCoupon && data.couponInfo.platformCoupon.selected) {
      usePlatformCoupon.value = true
      platformCouponUserId.value = data.couponInfo.platformCoupon.couponUserId
    }
    if (data.couponInfo.merchantCoupon && data.couponInfo.merchantCoupon.selected) {
      useMerchantCoupon.value = true
      merchantCouponUserId.value = data.couponInfo.merchantCoupon.couponUserId
    }
  }

  // 同步积分使用状态（后端自动填充最大值时回填）
  if (data.pointsInfo && data.pointsInfo.usedPoints > 0) {
    usePoints.value = true
    usePointsAmount.value = (data.pointsInfo.usedPoints || 0).toString()
  }

  // 同步活动上下文
  if (data.activityInfo) {
    activityContext.value = {
      seckillId: data.activityInfo.seckillProductId || activityContext.value.seckillId || null,
      bargainId: data.activityInfo.bargainRecordId || activityContext.value.bargainId || null,
      groupId: data.activityInfo.groupId || activityContext.value.groupId || null,
      promotionIds: data.activityInfo.promotionIds || activityContext.value.promotionIds || []
    }
  }
}

// ==================== 预览接口调用 ====================
const fetchOrderPreview = async () => {
  if (cartItemIds.value.length === 0) return

  const data = {
    cartItemIds: cartItemIds.value,
    deliveryType: deliveryType.value,
    addressId: deliveryType.value === 1 ? addressId.value : null,
    pickupPointId: deliveryType.value === 2 ? pickupPointId.value : null,
    usePlatformCoupon: usePlatformCoupon.value,
    platformCouponUserId: usePlatformCoupon.value ? platformCouponUserId.value : null,
    useMerchantCoupon: useMerchantCoupon.value,
    merchantCouponUserId: useMerchantCoupon.value ? merchantCouponUserId.value : null,
    usePoints: usePoints.value,
    usePointsAmount: usePoints.value
      ? (parseInt(usePointsAmount.value) > 0 ? parseInt(usePointsAmount.value) : null)
      : null,
    remark: remark.value,
    activityContext: activityContext.value
  }

  const res = await orderHook.loadOrderPreview(data)

  if (res) {
    // 保存 previewToken（全局管理，提交时仅传 token）
    if (res.previewToken) {
      previewToken.value = res.previewToken
      previewExpireSeconds.value = res.previewExpireSeconds || 900
      setupTokenExpireTimer(previewExpireSeconds.value)
    }
    applyPreviewData(res)
  }
}

// ==================== 提交订单 ====================
const submitOrder = async () => {
  if (!canSubmit.value) {
    if (!previewToken.value || tokenExpired.value) {
      showToast('预览已过期，正在重新预览')
      fetchOrderPreview()
      return
    }
    if (deliveryType.value === 1 && !addressId.value && !previewData.value.addressInfo?.addressId) {
      showToast('请选择收货地址')
    } else if (deliveryType.value === 2 && !pickupPointId.value && !previewData.value.pickupPointInfo?.pickupPointId) {
      showToast('请选择自提点')
    }
    return
  }

  // 仅传 previewToken 一个参数
  const result = await orderHook.createOrder(previewToken.value)

  if (result) {
    clearTokenExpireTimer()
    uni.navigateTo({
      url: `/pagesSub/order/pay/payOrder?orderId=${result.orderId}&orderSn=${result.orderSn}&payAmount=${result.payAmount}&expireTime=${result.expireTime}`
    })
  }
}

// ==================== 立即购买处理 ====================
const handleBuyNow = async (skuId, quantity) => {
  try {
    const result = await cartHook.cartStore.addCartItem({ skuId, quantity })
    if (result && (result.cartItemId || result.cartId)) {
      const cartItemId = result.cartItemId || result.cartId
      // 后端可能对相同 SKU 累加数量（如购物车已有2件，立即购买1件→变成3件）
      // 修正为传入的购买数量，确保预览/下单只按用户指定数量计算
      if (result.quantity && result.quantity !== quantity) {
        try {
          await cartHook.cartStore.updateCartItem(cartItemId, { quantity })
        } catch (e) {
          console.error('修正购买数量失败:', e)
        }
      }
      return cartItemId
    }
    console.error('addCartItem 返回数据异常:', result)
    showToast('添加购物车失败')
    return null
  } catch (error) {
    console.error('添加购物车失败:', error)
    showToast(error?.message || '添加购物车失败')
    return null
  }
}

// ==================== 初始化 ====================
const initOrderData = async () => {
  const pages = getCurrentPages()
  const currentPage = pages[pages.length - 1]
  const options = currentPage.$page?.options || currentPage.options || {}

  const source = options.source || 'cart'

  // 解析活动上下文（从 URL 参数）
  if (options.seckillId) activityContext.value.seckillId = parseInt(options.seckillId)
  if (options.bargainId) activityContext.value.bargainId = parseInt(options.bargainId)
  if (options.groupId) activityContext.value.groupId = parseInt(options.groupId)

  if (source === 'buyNow') {
    const skuId = parseInt(options.skuId)
    const quantity = parseInt(options.quantity) || 1
    if (!skuId || isNaN(skuId)) {
      showToast('商品规格信息异常，请返回重试')
      return
    }
    const cartItemId = await handleBuyNow(skuId, quantity)
    if (cartItemId) {
      cartItemIds.value = [cartItemId]
    } else {
      showToast('创建订单失败，请重试')
      return
    }
  } else {
    if (options.cartItemId) {
      const id = parseInt(options.cartItemId)
      if (!isNaN(id)) {
        cartItemIds.value = [id]
      }
    } else if (options.cartItemIds) {
      cartItemIds.value = options.cartItemIds
        .split(',')
        .map(id => parseInt(id))
        .filter(id => !isNaN(id))
    } else if (options.ids) {
      cartItemIds.value = options.ids
        .split(',')
        .map(id => parseInt(id))
        .filter(id => !isNaN(id))
    }
  }

  // 配送方式下加载默认地址
  if (deliveryType.value === 1) {
    await fetchDefaultAddress()
  }

  if (cartItemIds.value.length > 0) {
    await fetchOrderPreview()
  }
}

onMounted(() => {
  initOrderData()
  memberHook.loadMemberInfo()
})

onUnmounted(() => {
  clearTokenExpireTimer()
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

        .goods-price-wrap {
          display: flex;
          align-items: baseline;

          .goods-origin-price {
            font-size: 24rpx;
            color: $text-weak;
            text-decoration: line-through;
            margin-right: 12rpx;
          }
        }

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
    flex-wrap: wrap;
    justify-content: flex-end;

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

    .points-deduction-tip {
      width: 100%;
      text-align: right;
      margin-top: 8rpx;

      text {
        font-size: 22rpx;
        color: $color-primary;
      }
    }
  }

  .points-info {
    display: flex;
    flex-direction: column;

    .points-balance {
      font-size: 22rpx;
      color: $text-weak;
      margin-top: 4rpx;
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
    border: 1rpx solid transparent;

    &.coupon-selected {
      background: rgba($color-primary, 0.1);
      border: 1rpx solid $color-primary;
    }

    // 不可用优惠券样式
    &.coupon-item-disabled {
      opacity: 0.55;

      .coupon-discount {
        color: $text-weak;
      }
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
      flex-shrink: 0;

      .check-dot {
        width: 24rpx;
        height: 24rpx;
        background: $color-primary;
        border-radius: 50%;
      }
    }

    .coupon-content {
      flex: 1;
      min-width: 0;

      .coupon-name-row {
        display: flex;
        align-items: center;
        margin-bottom: 8rpx;
      }

      .coupon-name {
        font-size: 28rpx;
        color: $text-main;
        margin-right: 12rpx;
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
      }

      .recommend-tag {
        font-size: 18rpx;
        color: #FFFFFF;
        background: $color-primary;
        padding: 2rpx 10rpx;
        border-radius: 6rpx;
        flex-shrink: 0;
      }

      .coupon-desc {
        font-size: 24rpx;
        color: $text-weak;
        display: block;
      }

      .coupon-reason {
        font-size: 22rpx;
        color: $color-primary-danger;
        display: block;
        margin-top: 6rpx;
      }
    }

    .coupon-discount {
      font-size: 32rpx;
      color: $color-primary-danger;
      font-weight: 600;
      flex-shrink: 0;
      margin-left: 16rpx;
    }
  }

  // 加载中
  .coupon-loading {
    display: flex;
    flex-direction: column;
    align-items: center;
    padding: 80rpx 0;

    .loading-spinner {
      width: 48rpx;
      height: 48rpx;
      border: 4rpx solid $gray-200;
      border-top-color: $color-primary;
      border-radius: 50%;
      animation: coupon-spin 0.8s linear infinite;
      margin-bottom: 16rpx;
    }

    .loading-text {
      font-size: 26rpx;
      color: $text-weak;
    }
  }

  @keyframes coupon-spin {
    to { transform: rotate(360deg); }
  }

  // 空状态
  .coupon-empty {
    text-align: center;
    padding: 80rpx 0;

    .empty-text {
      font-size: 26rpx;
      color: $text-weak;
    }
  }
}
</style>
