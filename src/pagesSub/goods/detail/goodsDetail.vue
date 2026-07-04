<template>
  <view class="page-container">
    <view v-if="loading" class="loading-page">
      <view class="loading-spinner"></view>
      <text class="loading-text">加载中...</text>
    </view>

    <view v-else-if="isProductNotFound" class="not-found-page">
      <view class="not-found-icon">📦</view>
      <text class="not-found-title">商品已下架</text>
      <text class="not-found-desc">该商品不存在或已下架</text>
      <view class="not-found-btn" @click="goHome">
        <text class="not-found-btn-text">返回首页</text>
      </view>
    </view>

    <template v-else>
      <view class="nav-bar" :class="{ 'nav-bar-scrolled': isNavBarScrolled }">
        <view class="nav-back" @click="goBack">
          <text class="back-icon">‹</text>
        </view>
        <view class="nav-actions">
          <view class="action-item" @click="handleCompare">
            <text class="action-icon-text">☰</text>
          </view>
          <view class="action-item" @click="handleShare">
            <image src="/static/fonts/share.svg" class="action-icon" mode="aspectFit" />
          </view>
          <view class="action-item" @click="handleFavorite">
            <text class="action-icon-text" :class="{ 'favorite-active': isFavorite }">{{ isFavorite ? '♥' : '♡' }}</text>
          </view>
        </view>
      </view>

      <scroll-view scroll-y class="detail-scroll" @scroll="onScroll">
        <swiper
          class="image-swiper"
          :indicator-dots="true"
          :autoplay="true"
          :interval="4000"
          :duration="500"
          indicator-color="rgba(255,255,255,0.4)"
          indicator-active-color="#FFFFFF"
          @click="handleImageClick"
        >
          <swiper-item v-for="(image, index) in bannerImages" :key="index">
            <image :src="image" mode="aspectFill" class="swiper-image" lazy-load />
          </swiper-item>
        </swiper>

        <view class="price-section">
          <view class="price-left">
            <text class="price-symbol">¥</text>
            <text class="price-value">{{ selectedSku?.price || productDetail.price || 0 }}</text>
            <text class="original-price">¥{{ selectedSku?.originalPrice || productDetail.originalPrice || 0 }}</text>
          </view>
          <view class="tags-wrap">
            <text
              v-for="(tag, index) in tags"
              :key="index"
              class="tag-item"
            >{{ tag }}</text>
          </view>
          <view class="stats-row">
            <view class="stat-item">
              <text class="stat-value">{{ productDetail.soldCount || 0 }}</text>
              <text class="stat-label">已售</text>
            </view>
            <view class="stat-divider"></view>
            <view class="stat-item">
              <text class="stat-value rating">{{ productDetail.rating || 4.9 }}</text>
              <text class="stat-label">评分</text>
            </view>
            <view class="stat-divider"></view>
            <view class="stat-item">
              <text class="stat-value">{{ selectedSku?.stock || productDetail.stock || 0 }}</text>
              <text class="stat-label">库存</text>
            </view>
          </view>
        </view>

        <view class="title-section">
          <text class="product-title">{{ productDetail.productName || '' }}</text>
          <text class="product-desc">{{ productDetail.description || '' }}</text>
        </view>

        <view class="merchant-card" @click="goMerchant">
          <view class="merchant-logo-wrap">
            <image
              :src="getValidImageUrl(productDetail.merchantLogo, 'merchant%20logo%20icon')"
              mode="aspectFill"
              class="merchant-logo"
            />
            <view v-if="!productDetail.merchantLogo" class="merchant-logo-placeholder">
              <text class="logo-placeholder-text">商</text>
            </view>
          </view>
          <view class="merchant-info">
            <view class="merchant-header">
              <text class="merchant-name">{{ productDetail.merchantName || '' }}</text>
              <view class="merchant-rating">
                <text class="star-icon">★</text>
                <text class="rating-value">{{ productDetail.merchantInfo?.rating || 4.8 }}</text>
              </view>
            </view>
            <view class="merchant-stats">
              <text class="merchant-stat">月销{{ productDetail.merchantInfo?.monthSales || 0 }}+</text>
              <text class="merchant-delivery">{{ productDetail.merchantInfo?.deliveryRange || '全国配送' }}</text>
            </view>
          </view>
          <text class="merchant-arrow">›</text>
        </view>

        <view v-if="skuList.length > 0" class="sku-section">
          <view class="sku-header">
            <text class="sku-title">规格选择</text>
            <text class="sku-selected">{{ selectedSku?.skuName || '请选择规格' }}</text>
          </view>
          <view class="sku-grid">
            <view
              v-for="sku in skuList"
              :key="sku.skuId"
              class="sku-card"
              :class="{ 'sku-card-active': selectedSku?.skuId === sku.skuId, 'sku-card-disabled': sku.stock === 0 }"
              @click="selectSku(sku)"
            >
              <view class="sku-card-header">
                <text class="sku-name">{{ sku.skuName }}</text>
                <text class="sku-price">¥{{ sku.price }}</text>
              </view>
              <view class="sku-card-specs">
                <text
                v-for="(value, key) in sku.specs"
                :key="key"
                class="sku-spec-item"
              >{{ key }}: {{ value }}</text>
              </view>
              <view class="sku-card-footer">
                <text class="sku-stock-info">{{ sku.stock > 0 ? `库存: ${sku.stock}件` : '缺货' }}</text>
              </view>
            </view>
          </view>
        </view>

        <view class="detail-images-section">
          <view class="detail-header">
            <text class="detail-title">商品详情</text>
          </view>
          <view v-if="detailImages.length > 0" class="detail-images-list">
            <image
              v-for="(img, index) in detailImages"
              :key="index"
              :src="img"
              mode="widthFix"
              class="detail-image"
              lazy-load
            />
          </view>
          <rich-text v-else :nodes="productDetail.detailContent || ''" class="detail-content" />
        </view>
      </scroll-view>

      <view class="bottom-bar">
        <view class="bottom-left">
          <view class="bottom-item" @click="goMerchant">
            <text class="bottom-icon-text">🏪</text>
            <text class="bottom-text">店铺</text>
          </view>
          <view class="bottom-item" @click="goCart">
            <view class="cart-icon-wrap">
              <text class="bottom-icon-text">🛒</text>
              <view v-if="cartStore.totalQuantity > 0" class="cart-badge">
                <text class="cart-badge-text">{{ cartStore.totalQuantity > 99 ? '99+' : cartStore.totalQuantity }}</text>
              </view>
            </view>
            <text class="bottom-text">购物车</text>
          </view>
        </view>
        <view class="bottom-right">
          <view class="btn-cart" @click="handleAddCart">
            <text class="btn-text">加入购物车</text>
          </view>
          <view class="btn-buy" @click="handleBuy">
            <text class="btn-text">立即购买</text>
          </view>
        </view>
      </view>
    </template>

    <view class="sku-popup" :class="{ show: showSkuPopup }" @click="showSkuPopup = false">
      <view class="popup-mask"></view>
      <view class="popup-content" @click.stop>
        <view class="popup-header">
          <image
            :src="selectedSkuImage"
            mode="aspectFill"
            class="popup-image"
          />
          <view class="popup-info">
            <text class="popup-price">¥{{ selectedSku?.price || productDetail.price || 0 }}</text>
            <text class="popup-stock">库存: {{ selectedSku?.stock || productDetail.stock || 0 }}</text>
            <text class="popup-selected">已选: {{ selectedSku?.skuName || '未选择规格' }}</text>
          </view>
          <view class="popup-close" @click="showSkuPopup = false">
            <text class="close-icon">×</text>
          </view>
        </view>

        <view class="popup-body">
          <view v-for="(spec, specName) in specOptions" :key="specName" class="spec-group">
            <text class="spec-name">{{ specName }}</text>
            <view class="spec-values">
              <view
                v-for="value in spec"
                :key="value"
                class="spec-value"
                :class="{ 'spec-value-active': selectedSpecs[specName] === value }"
                @click="selectSpec(specName, value)"
              >
                <text>{{ value }}</text>
              </view>
            </view>
          </view>
        </view>

        <view class="popup-footer">
          <view class="quantity-control">
            <text class="quantity-btn" @click="decreaseQuantity">-</text>
            <text class="quantity-value">{{ quantity }}</text>
            <text class="quantity-btn" @click="increaseQuantity">+</text>
          </view>
          <view class="popup-btns">
            <view class="btn-add-cart" @click="confirmAddCart">
              <text>加入购物车</text>
            </view>
            <view class="btn-confirm" @click="confirmBuy">
              <text>立即购买</text>
            </view>
          </view>
        </view>
      </view>
    </view>
  </view>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { onShow } from '@dcloudio/uni-app'
import { getValidImageUrl } from '@/utils/common'
import { useGoods } from '@/hooks/useGoods'
import { useCart } from '@/hooks/useCart'
import { useUserStore } from '@/store/user'

const productDetail = ref({})
const isProductNotFound = ref(false)
const loading = ref(true)
const isFavorite = ref(false)
const isNavBarScrolled = ref(false)

const skuList = ref([])
const selectedSku = ref(null)
const selectedSpecs = ref({})
const showSkuPopup = ref(false)
const quantity = ref(1)

const { loadProductDetail, loadProductSkus } = useGoods()
const { loadAddToCart, cartStore, loadCartData } = useCart()
const userStore = useUserStore()

const bannerImages = computed(() => {
  const images = productDetail.value.bannerImages || productDetail.value.images || []
  const productImage = productDetail.value.productImage || productDetail.value.mainImage || ''
  const validImages = images.map(img => getValidImageUrl(img, 'product%20banner%20image'))
  if (validImages.length === 0 && productImage) {
    return [getValidImageUrl(productImage)]
  }
  return validImages
})

const selectedSkuImage = computed(() => {
  return getValidImageUrl(productDetail.value.productImage || '', 'product%20image')
})

const tags = computed(() => {
  return productDetail.value.tags || []
})

const detailImages = computed(() => {
  const images = productDetail.value.detailImages || []
  return images.map(img => getValidImageUrl(img, 'product%20detail%20image'))
})

const specOptions = computed(() => {
  const specs = {}
  skuList.value.forEach(sku => {
    if (sku.specs) {
      Object.keys(sku.specs).forEach(key => {
        if (!specs[key]) {
          specs[key] = []
        }
        if (!specs[key].includes(sku.specs[key])) {
          specs[key].push(sku.specs[key])
        }
      })
    }
  })
  return specs
})

const goBack = () => {
  uni.navigateBack()
}

const goHome = () => {
  uni.switchTab({ url: '/pages/index/index' })
}

const goMerchant = () => {
  const merchantId = productDetail.value?.merchantId
  if (!merchantId) {
    uni.showToast({ title: '商家信息不存在', icon: 'none' })
    return
  }
  uni.navigateTo({
    url: `/pagesSub/shop/shopHome?merchantId=${merchantId}`,
    animationType: 'slide-in-right',
    animationDuration: 200
  })
}

const goCart = () => {
  uni.switchTab({ url: '/pages/cart/cart' })
}

const handleShare = () => {
  uni.showToast({ title: '分享功能开发中', icon: 'none' })
}

const handleCompare = () => {
  uni.showToast({ title: '已添加到对比列表', icon: 'success' })
}

const onScroll = (e) => {
  isNavBarScrolled.value = e.detail.scrollTop > 100
}

const handleFavorite = () => {
  isFavorite.value = !isFavorite.value
  uni.showToast({ title: isFavorite.value ? '收藏成功' : '已取消收藏', icon: 'success' })
}

const handleImageClick = () => {
  uni.previewImage({
    urls: bannerImages.value.filter(img => img)
  })
}

const selectSku = (sku) => {
  if (sku.stock === 0) {
    uni.showToast({ title: '该规格已缺货', icon: 'none' })
    return
  }
  selectedSku.value = sku
  if (sku.specs) {
    selectedSpecs.value = { ...sku.specs }
  }
}

const selectSpec = (specName, value) => {
  selectedSpecs.value = {
    ...selectedSpecs.value,
    [specName]: value
  }
  
  const matchedSku = skuList.value.find(sku => {
    if (!sku.specs) return false
    return Object.keys(selectedSpecs.value).every(key => {
      return sku.specs[key] === selectedSpecs.value[key]
    })
  })
  
  if (matchedSku) {
    selectedSku.value = matchedSku
  }
}

const increaseQuantity = () => {
  const maxStock = selectedSku.value?.stock || productDetail.value.stock || 999
  if (quantity.value < maxStock) {
    quantity.value++
  }
}

const decreaseQuantity = () => {
  if (quantity.value > 1) {
    quantity.value--
  }
}

const handleAddCart = () => {
  if (skuList.value.length > 0 && !selectedSku.value) {
    showSkuPopup.value = true
    return
  }
  confirmAddCart()
}

const handleBuy = () => {
  if (skuList.value.length > 0 && !selectedSku.value) {
    showSkuPopup.value = true
    return
  }
  confirmBuy()
}

const confirmAddCart = async () => {
  if (!selectedSku.value && skuList.value.length > 0) {
    uni.showToast({ title: '请选择规格', icon: 'none' })
    return
  }
  
  const skuId = selectedSku.value?.skuId || null
  
  if (!skuId) {
    uni.showToast({ title: '商品信息异常', icon: 'none' })
    return
  }
  
  await loadAddToCart(skuId, quantity.value)
  showSkuPopup.value = false
}

const confirmBuy = async () => {
  if (!userStore.isLogin) {
    uni.showToast({ title: '请先登录', icon: 'none' })
    setTimeout(() => {
      uni.navigateTo({ url: '/pages/login/login' })
    }, 1000)
    return
  }

  if (!selectedSku.value && skuList.value.length > 0) {
    uni.showToast({ title: '请选择规格', icon: 'none' })
    return
  }

  const productId = productDetail.value.productId
  // 优先使用已选 SKU；无规格商品尝试从 skuList 取第一个；都没有则提示
  const skuId = selectedSku.value?.skuId || skuList.value[0]?.skuId || null
  if (!skuId) {
    uni.showToast({ title: '商品规格信息异常', icon: 'none' })
    return
  }
  const buyQuantity = quantity.value

  const maxStock = selectedSku.value?.stock || productDetail.value.stock || 0
  if (buyQuantity > maxStock) {
    uni.showToast({ title: '库存不足', icon: 'none' })
    return
  }

  showSkuPopup.value = false

  // 直接跳转到订单确认页，由 confirmOrder 自动调用 addCartItem 生成临时 cartItemId
  // 避免在此处重复加入购物车（confirmOrder 的 handleBuyNow 会处理）
  uni.navigateTo({
    url: `/pagesSub/order/confirmOrder?source=buyNow&productId=${productId}&skuId=${skuId}&quantity=${buyQuantity}`
  })
}

const loadProductData = async (productId) => {
  loading.value = true
  try {
    const detailData = await loadProductDetail(productId)
    
    if (detailData) {
      productDetail.value = {
        ...detailData,
        merchantId: detailData.merchantInfo?.merchantId || detailData.merchantId || null,
        merchantName: detailData.merchantInfo?.merchantName || '',
        merchantLogo: detailData.merchantInfo?.merchantLogo || ''
      }
      isProductNotFound.value = false
    } else {
      isProductNotFound.value = true
      return
    }
    
    if (detailData.skuList && detailData.skuList.length > 0) {
      skuList.value = detailData.skuList
      const availableSku = detailData.skuList.find(s => s.stock > 0)
      if (availableSku) {
        selectSku(availableSku)
      }
    }
  } catch (error) {
    console.error('加载商品数据失败', error)
    if (error?.code === 40402) {
      uni.showToast({ title: '商品已下架', icon: 'none' })
      isProductNotFound.value = true
      setTimeout(() => {
        uni.navigateBack()
      }, 1500)
    } else {
      isProductNotFound.value = true
    }
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  const pages = getCurrentPages()
  const currentPage = pages[pages.length - 1]
  const options = currentPage.options || {}
  const productId = options.id || options.productId

  if (productId) {
    loadProductData(productId)
  }
})

// 页面显示时刷新购物车数量（从购物车页返回后同步徽标）
onShow(() => {
  if (userStore.isLogin) {
    loadCartData()
  }
})
</script>

<style lang="scss" scoped>
.page-container {
  min-height: 100vh;
  background-color: $bg-page;
}

.loading-page {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  background: $bg-card;
}

.loading-spinner {
  width: 64rpx;
  height: 64rpx;
  border: 4rpx solid $bg-page-light;
  border-top-color: $color-primary;
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

.loading-text {
  margin-top: 24rpx;
  font-size: 28rpx;
  color: $text-weak;
}

.sku-section {
  background: $bg-card;
  padding: 24rpx;
  margin-top: 16rpx;
}

.sku-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 20rpx;
}

.sku-title {
  font-size: 28rpx;
  color: $text-main;
  font-weight: 500;
}

.sku-selected {
  font-size: 26rpx;
  color: $color-primary;
}

.sku-grid {
  display: flex;
  flex-direction: column;
  gap: 16rpx;
}

.sku-card {
  padding: 20rpx;
  background: $bg-page-light;
  border-radius: $radius-lg;
  border: 2rpx solid transparent;
  transition: all 0.2s;

  &:active {
    opacity: 0.8;
  }
}

.sku-card-active {
  background: rgba($color-primary, 0.05);
  border-color: $color-primary;
}

.sku-card-disabled {
  opacity: 0.5;
}

.sku-card-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 12rpx;
}

.sku-name {
  font-size: 30rpx;
  font-weight: 600;
  color: $text-main;
}

.sku-price {
  font-size: 32rpx;
  font-weight: 700;
  color: $color-primary-danger;
}

.sku-card-specs {
  display: flex;
  flex-wrap: wrap;
  gap: 12rpx;
  margin-bottom: 12rpx;
}

.sku-spec-item {
  padding: 8rpx 16rpx;
  background: rgba($color-primary, 0.1);
  border-radius: 8rpx;
  font-size: 24rpx;
  color: $color-primary;
}

.sku-card-footer {
  display: flex;
  align-items: center;
  justify-content: flex-end;
}

.sku-stock-info {
  font-size: 24rpx;
  color: $text-weak;
}

.sku-popup {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  z-index: 300;
  pointer-events: none;
}

.sku-popup.show {
  pointer-events: auto;
}

.popup-mask {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.5);
  opacity: 0;
  transition: opacity 0.3s;
}

.sku-popup.show .popup-mask {
  opacity: 1;
}

.popup-content {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  background: $bg-card;
  border-radius: 24rpx 24rpx 0 0;
  transform: translateY(100%);
  transition: transform 0.3s;
  max-height: 80vh;
  display: flex;
  flex-direction: column;
}

.sku-popup.show .popup-content {
  transform: translateY(0);
}

.popup-header {
  display: flex;
  padding: 24rpx;
  border-bottom: 1rpx solid $bg-page-light;
  position: relative;
}

.popup-image {
  width: 180rpx;
  height: 180rpx;
  border-radius: $radius-base;
  flex-shrink: 0;
}

.popup-info {
  flex: 1;
  margin-left: 20rpx;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
}

.popup-price {
  font-size: 40rpx;
  color: $color-primary-danger;
  font-weight: 700;
}

.popup-stock {
  font-size: 26rpx;
  color: $text-sub;
}

.popup-selected {
  font-size: 26rpx;
  color: $text-sub;
}

.popup-close {
  position: absolute;
  top: 20rpx;
  right: 20rpx;
  width: 56rpx;
  height: 56rpx;
  display: flex;
  align-items: center;
  justify-content: center;
}

.close-icon {
  font-size: 40rpx;
  color: $text-weak;
}

.popup-body {
  flex: 1;
  padding: 24rpx;
  overflow-y: auto;
}

.spec-group {
  margin-bottom: 24rpx;
}

.spec-name {
  display: block;
  font-size: 28rpx;
  color: $text-main;
  font-weight: 500;
  margin-bottom: 16rpx;
}

.spec-values {
  display: flex;
  flex-wrap: wrap;
  gap: 16rpx;
}

.spec-value {
  padding: 16rpx 28rpx;
  background: $bg-page-light;
  border-radius: $radius-base;
  border: 2rpx solid transparent;

  &:active {
    opacity: 0.8;
  }

  text {
    font-size: 28rpx;
    color: $text-main;
  }
}

.spec-value-active {
  background: rgba($color-primary, 0.05);
  border-color: $color-primary;

  text {
    color: $color-primary;
  }
}

.popup-footer {
  padding: 20rpx 24rpx;
  padding-bottom: calc(20rpx + env(safe-area-inset-bottom));
  border-top: 1rpx solid $bg-page-light;
  display: flex;
  align-items: center;
  gap: 24rpx;
}

.quantity-control {
  display: flex;
  align-items: center;
  background: $bg-page-light;
  border-radius: $radius-full;
  padding: 8rpx;
}

.quantity-btn {
  width: 72rpx;
  height: 64rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 40rpx;
  color: $text-main;

  &:active {
    opacity: 0.6;
  }
}

.quantity-value {
  width: 80rpx;
  text-align: center;
  font-size: 30rpx;
  color: $text-main;
  font-weight: 500;
}

.popup-btns {
  flex: 1;
  display: flex;
  gap: 16rpx;
}

.btn-add-cart,
.btn-confirm {
  flex: 1;
  height: 88rpx;
  border-radius: $radius-full;
  display: flex;
  align-items: center;
  justify-content: center;

  &:active {
    opacity: 0.8;
  }

  text {
    font-size: 30rpx;
    font-weight: 600;
  }
}

.btn-add-cart {
  background: linear-gradient(135deg, $color-primary 0%, $color-primary-light 100%);

  text {
    color: #FFFFFF;
  }
}

.btn-confirm {
  background: linear-gradient(135deg, $color-primary-danger 0%, #FF7875 100%);

  text {
    color: #FFFFFF;
  }
}

.not-found-page {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 40rpx;
}

.not-found-icon {
  font-size: 120rpx;
  margin-bottom: 32rpx;
}

.not-found-title {
  font-size: 36rpx;
  font-weight: 600;
  color: $text-main;
  margin-bottom: 16rpx;
}

.not-found-desc {
  font-size: 28rpx;
  color: $text-weak;
  margin-bottom: 48rpx;
}

.not-found-btn {
  padding: 24rpx 80rpx;
  background: linear-gradient(135deg, $color-primary 0%, $color-primary-danger 100%);
  border-radius: $radius-full;

  &:active {
    opacity: 0.8;
  }
}

.not-found-btn-text {
  font-size: 30rpx;
  color: #FFFFFF;
  font-weight: 600;
}

.nav-bar {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  z-index: 100;
  display: flex;
  align-items: center;
  justify-content: space-between;
  height: 88rpx;
  padding: 0 24rpx;
  padding-top: env(safe-area-inset-top);
  background: rgba(0, 0, 0, 0.3);
  transition: background 0.3s;

  &.nav-bar-scrolled {
    background: rgba(255, 255, 255, 0.95);
    box-shadow: 0 2rpx 12rpx rgba(0, 0, 0, 0.1);

    .back-icon,
    .action-icon-text {
      color: $text-main;
    }

    .nav-back,
    .action-item {
      background: $bg-page-light;
    }
  }
}

.nav-back {
  width: 64rpx;
  height: 64rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(255, 255, 255, 0.9);
  border-radius: 50%;

  &:active {
    opacity: 0.6;
  }
}

.back-icon {
  font-size: 48rpx;
  color: $text-main;
  font-weight: 300;
}

.nav-actions {
  display: flex;
  gap: 16rpx;
}

.action-item {
  width: 64rpx;
  height: 64rpx;
  background: rgba(255, 255, 255, 0.9);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;

  &:active {
    opacity: 0.6;
  }
}

.action-icon {
  width: 40rpx;
  height: 40rpx;
}

.action-icon-text {
  font-size: 36rpx;
  color: #FFFFFF;

  &.favorite-active {
    color: $color-primary-danger;
  }
}

.detail-scroll {
  height: 100vh;
  padding-top: calc(88rpx + env(safe-area-inset-top));
  padding-bottom: calc(140rpx + env(safe-area-inset-bottom));
}

.image-swiper {
  width: 100%;
  height: 750rpx;
}

.swiper-image {
  width: 100%;
  height: 100%;
}

.price-section {
  background: $bg-card;
  padding: 24rpx;
}

.price-left {
  display: flex;
  align-items: baseline;
  margin-bottom: 16rpx;
}

.price-symbol {
  font-size: 28rpx;
  color: $color-primary-danger;
  font-weight: 600;
}

.price-value {
  font-size: 56rpx;
  color: $color-primary-danger;
  font-weight: 700;
}

.original-price {
  font-size: 26rpx;
  color: $text-weak;
  text-decoration: line-through;
  margin-left: 16rpx;
}

.tags-wrap {
  display: flex;
  flex-wrap: wrap;
  gap: 12rpx;
  margin-bottom: 16rpx;
}

.tag-item {
  padding: 8rpx 20rpx;
  background: rgba($color-primary-danger, 0.1);
  color: $color-primary-danger;
  font-size: 24rpx;
  border-radius: 8rpx;
}

.stats-row {
  display: flex;
  align-items: center;
  justify-content: space-around;
  margin-top: 20rpx;
  padding-top: 20rpx;
  border-top: 1rpx solid $bg-page-light;
}

.stat-item {
  display: flex;
  flex-direction: column;
  align-items: center;
}

.stat-value {
  font-size: 32rpx;
  font-weight: 600;
  color: $text-main;

  &.rating {
    color: $color-primary-danger;
  }
}

.stat-label {
  font-size: 24rpx;
  color: $text-weak;
  margin-top: 8rpx;
}

.stat-divider {
  width: 1rpx;
  height: 48rpx;
  background: $bg-page-light;
}

.title-section {
  background: $bg-card;
  padding: 24rpx;
  margin-top: 16rpx;
}

.product-title {
  display: block;
  font-size: 34rpx;
  font-weight: 600;
  color: $text-main;
  line-height: 1.4;
  margin-bottom: 16rpx;
}

.product-desc {
  display: block;
  font-size: 28rpx;
  color: $text-weak;
  line-height: 1.6;
}

.merchant-card {
  display: flex;
  align-items: center;
  background: $bg-card;
  padding: 24rpx;
  margin-top: 16rpx;
  border-radius: $radius-lg;
  margin-left: 20rpx;
  margin-right: 20rpx;

  &:active {
    background: $bg-page-light;
  }
}

.merchant-logo-wrap {
  width: 80rpx;
  height: 80rpx;
  border-radius: $radius-base;
  overflow: hidden;
  flex-shrink: 0;
}

.merchant-logo {
  width: 100%;
  height: 100%;
}

.merchant-logo-placeholder {
  width: 100%;
  height: 100%;
  background: $bg-page-light;
  display: flex;
  align-items: center;
  justify-content: center;
}

.logo-placeholder-text {
  font-size: 32rpx;
  color: $text-weak;
}

.merchant-info {
  flex: 1;
  margin-left: 20rpx;
}

.merchant-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.merchant-name {
  font-size: 30rpx;
  color: $text-main;
  font-weight: 500;
}

.merchant-rating {
  display: flex;
  align-items: center;
}

.star-icon {
  font-size: 24rpx;
  color: #FFB800;
  margin-right: 4rpx;
}

.rating-value {
  font-size: 26rpx;
  color: #FFB800;
  font-weight: 500;
}

.merchant-stats {
  display: flex;
  align-items: center;
  gap: 24rpx;
  margin-top: 12rpx;
}

.merchant-stat {
  font-size: 24rpx;
  color: $text-weak;
}

.merchant-delivery {
  font-size: 24rpx;
  color: $text-weak;
}

.merchant-arrow {
  font-size: 36rpx;
  color: $text-weak;
}

.detail-images-section {
  background: $bg-card;
  padding: 24rpx;
  margin-top: 16rpx;
}

.detail-header {
  margin-bottom: 20rpx;
}

.detail-title {
  font-size: 32rpx;
  font-weight: 600;
  color: $text-main;
}

.detail-images-list {
  width: 100%;
}

.detail-image {
  width: 100%;
  margin-bottom: 8rpx;
}

.detail-content {
  font-size: 28rpx;
  color: $text-sub;
  line-height: 1.8;
}

.bottom-bar {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  display: flex;
  align-items: center;
  height: 140rpx;
  padding: 0 24rpx;
  padding-bottom: env(safe-area-inset-bottom);
  background: $bg-card;
  box-shadow: 0 -2rpx 12rpx rgba(0, 0, 0, 0.06);
}

.bottom-left {
  display: flex;
  gap: 32rpx;
}

.bottom-item {
  display: flex;
  flex-direction: column;
  align-items: center;

  &:active {
    opacity: 0.6;
  }
}

.cart-icon-wrap {
  position: relative;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 4rpx;
}

.cart-badge {
  position: absolute;
  top: -8rpx;
  right: -16rpx;
  min-width: 28rpx;
  height: 28rpx;
  padding: 0 6rpx;
  background: $color-primary-danger;
  border-radius: $radius-full;
  display: flex;
  align-items: center;
  justify-content: center;
  border: 2rpx solid #fff;

  .cart-badge-text {
    font-size: 18rpx;
    color: #fff;
    font-weight: 600;
    line-height: 1;
  }
}

.bottom-icon-text {
  font-size: 44rpx;
  margin-bottom: 4rpx;
}

.bottom-text {
  font-size: 22rpx;
  color: $text-sub;
}

.bottom-right {
  flex: 1;
  display: flex;
  margin-left: 32rpx;
}

.btn-cart {
  flex: 1;
  height: 88rpx;
  margin-right: 16rpx;
  background: linear-gradient(135deg, $color-primary 0%, $color-primary-light 100%);
  border-radius: $radius-full;
  display: flex;
  align-items: center;
  justify-content: center;

  &:active {
    opacity: 0.8;
  }

  .btn-text {
    font-size: 30rpx;
    color: #FFFFFF;
    font-weight: 600;
  }
}

.btn-buy {
  flex: 1;
  height: 88rpx;
  background: linear-gradient(135deg, $color-primary-danger 0%, #FF7875 100%);
  border-radius: $radius-full;
  display: flex;
  align-items: center;
  justify-content: center;

  &:active {
    opacity: 0.8;
  }

  .btn-text {
    font-size: 30rpx;
    color: #FFFFFF;
    font-weight: 600;
  }
}
</style>