<template>
  <view class="page-cart">
    <view class="cart-header">
      <text class="header-title">购物车</text>
      <view class="header-right" @click="toggleManageMode">
        <text class="manage-text">{{ cartStore.isManageMode ? '完成' : '管理' }}</text>
      </view>
    </view>

    <scroll-view 
      scroll-y 
      class="page-content"
      @scrolltolower="onScrollToLower"
      @refresherrefresh="onRefresh"
      :refresher-enabled="true"
      :refresher-triggered="refreshing"
    >
      <view v-if="cartStore.groupedCartList.length === 0 && cartStore.invalidList.length === 0" class="empty-cart">
        <view class="empty-icon">
          <text class="empty-emoji">🛒</text>
        </view>
        <text class="empty-title">购物车空空如也</text>
        <text class="empty-desc">快去挑选心仪的商品吧</text>
        <view class="empty-btn" @click="goShopping">
          <text>去逛逛</text>
        </view>
      </view>

      <view v-else>
        <view v-if="cartStore.groupedCartList.length > 0" class="cart-list">
          <view
            v-for="group in cartStore.groupedCartList"
            :key="group.merchantId"
            class="merchant-group"
          >
            <view class="merchant-header">
              <view class="merchant-checkbox" @click="handleToggleGroupSelect(group)">
                <view class="checkbox" :class="{ 'checkbox-active': group.isGroupSelected }">
                  <text v-if="group.isGroupSelected" class="check-icon">✓</text>
                </view>
              </view>
              <view class="merchant-logo-wrap">
                <text class="merchant-logo-text">{{ (group.merchantName || '商').charAt(0) }}</text>
              </view>
              <text class="merchant-name">{{ group.merchantName }}</text>
            </view>

            <view class="merchant-goods-list">
              <view
                v-for="item in group.items"
                :key="item.cartItemId"
                class="goods-item"
              >
                <view class="goods-checkbox" @click="handleToggleSelect(item.cartItemId)">
                  <view class="checkbox" :class="{ 'checkbox-active': item.checked }">
                    <text v-if="item.checked" class="check-icon">✓</text>
                  </view>
                </view>

                <view class="goods-image-wrap" @click="goToGoodsDetail(item.productId)">
                  <image :src="item.productImage" mode="aspectFill" class="goods-image" lazy-load />
                </view>

                <view class="goods-info">
                  <text class="goods-name">{{ item.productName }}</text>
                  <text class="goods-sku">{{ parseSkuSpec(item.skuSpecs) }}</text>
                  <view class="goods-bottom">
                    <text class="goods-price">¥{{ item.price.toFixed(2) }}</text>
                    <view class="stepper">
                      <view
                        class="stepper-btn stepper-minus"
                        :class="{ 'stepper-disabled': item.quantity <= 1 }"
                        @click="handleMinus(item)"
                      >
                        <text>-</text>
                      </view>
                      <text class="stepper-value" @click="handleEditQuantity(item)">{{ item.quantity }}</text>
                      <view
                        class="stepper-btn stepper-plus"
                        :class="{ 'stepper-disabled': item.quantity >= item.stock }"
                        @click="handlePlus(item)"
                      >
                        <text>+</text>
                      </view>
                    </view>
                  </view>
                </view>
              </view>
            </view>
          </view>
        </view>

        <view v-if="cartStore.invalidList.length > 0" class="invalid-section">
          <view class="invalid-header" @click="toggleInvalidExpand">
            <text class="invalid-title">失效商品({{ cartStore.invalidList.length }})</text>
            <text class="invalid-arrow" :class="{ 'arrow-up': isInvalidExpand }">›</text>
          </view>
          <view v-if="isInvalidExpand" class="invalid-list">
            <view
              v-for="item in cartStore.invalidList"
              :key="item.cartItemId"
              class="invalid-item"
            >
              <view class="invalid-image-wrap">
                <image :src="item.productImage" mode="aspectFill" class="invalid-image" lazy-load />
              </view>
              <view class="invalid-info">
                <text class="invalid-name">{{ item.productName }}</text>
                <text class="invalid-reason">{{ item.invalidReason }}</text>
              </view>
            </view>
            <view class="invalid-clear-btn" @click="handleClearInvalid">
              <text>一键清空失效商品</text>
            </view>
          </view>
        </view>
      </view>
      <!-- 底部占位：避免 fixed footer 遮挡最后商品 -->
      <view class="cart-bottom-spacer"></view>
    </scroll-view>

    <view v-if="cartStore.validCartList.length > 0" class="cart-footer">
      <view class="footer-left" @click="handleToggleAllSelect">
        <view class="checkbox" :class="{ 'checkbox-active': cartStore.isAllSelected }">
          <text v-if="cartStore.isAllSelected" class="check-icon">✓</text>
        </view>
        <text class="footer-checkbox-text">全选</text>
      </view>

      <view v-if="cartStore.isManageMode" class="footer-manage">
        <view 
          class="manage-delete-btn"
          :class="{ 'btn-disabled': !cartStore.hasSelectedItems }"
          @click="handleDeleteSelected"
        >
          <text>删除选中({{ cartStore.selectedCount }})</text>
        </view>
      </view>

      <view v-else class="footer-right">
        <view class="price-info">
          <text class="price-label">合计：</text>
          <text class="price-value">¥{{ cartStore.selectedTotal.toFixed(2) }}</text>
        </view>
        <view 
          class="checkout-btn"
          :class="{ 'btn-disabled': !cartStore.hasSelectedItems }"
          @click="handleCheckout"
        >
          <text>去结算({{ cartStore.selectedCount }})</text>
        </view>
      </view>
    </view>

    <custom-tab-bar />
  </view>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { onShow } from '@dcloudio/uni-app'
import CustomTabBar from '@/components/global/CustomTabBar.vue'
import { useCart } from '@/hooks/useCart'

const {
  cartStore,
  loading,
  loadCartData,
  loadUpdateQuantity,
  loadDeleteItem,
  loadDeleteSelectedItems,
  loadDeleteInvalidItems,
  loadCheckout
} = useCart()

const refreshing = ref(false)
const isInvalidExpand = ref(false)

const goShopping = () => {
  uni.switchTab({ url: '/pagesSub/goods/category/categoryHome' })
}

const goToGoodsDetail = (productId) => {
  uni.navigateTo({ url: `/pagesSub/goods/detail/goodsDetail?productId=${productId}` })
}

const parseSkuSpec = (skuSpec) => {
  if (!skuSpec) return ''
  try {
    const parsed = typeof skuSpec === 'string' ? JSON.parse(skuSpec) : skuSpec
    return Object.values(parsed).join(' / ')
  } catch (e) {
    return skuSpec
  }
}

const handleToggleGroupSelect = (group) => {
  const newValue = !group.isGroupSelected
  group.items.forEach(item => {
    item.checked = newValue
  })
  cartStore.updateAllSelectedStatus()
}

const toggleManageMode = () => {
  cartStore.toggleManageMode()
}

const toggleInvalidExpand = () => {
  isInvalidExpand.value = !isInvalidExpand.value
}

const handleToggleSelect = (cartItemId) => {
  cartStore.toggleSelect(cartItemId)
}

const handleToggleAllSelect = () => {
  cartStore.toggleAllSelect()
}

const handlePlus = (item) => {
  if (item.quantity >= item.stock) {
    uni.showToast({ title: '已达到库存上限', icon: 'none' })
    return
  }
  loadUpdateQuantity(item.cartItemId, item.quantity + 1)
}

const handleMinus = (item) => {
  if (item.quantity <= 1) {
    uni.showModal({
      title: '确认删除',
      content: '确定要删除该商品吗？',
      success: (res) => {
        if (res.confirm) {
          loadDeleteItem(item.cartItemId)
        }
      }
    })
    return
  }
  loadUpdateQuantity(item.cartItemId, item.quantity - 1)
}

const handleEditQuantity = (item) => {
  uni.showModal({
    title: '修改数量',
    editable: true,
    placeholderText: `请输入购买数量(1-${item.stock})`,
    content: String(item.quantity),
    success: (res) => {
      if (res.confirm) {
        const num = parseInt(res.content)
        if (isNaN(num) || num < 1) {
          uni.showToast({ title: '数量不能小于1', icon: 'none' })
          return
        }
        if (num > item.stock) {
          uni.showToast({ title: `数量不能超过库存${item.stock}`, icon: 'none' })
          return
        }
        if (num === item.quantity) return
        loadUpdateQuantity(item.cartItemId, num)
      }
    }
  })
}

const handleDelete = (cartItemId) => {
  uni.showModal({
    title: '确认删除',
    content: '确定要删除该商品吗？',
    success: (res) => {
      if (res.confirm) {
        loadDeleteItem(cartItemId)
      }
    }
  })
}

const handleDeleteSelected = () => {
  loadDeleteSelectedItems()
}

const handleClearInvalid = () => {
  loadDeleteInvalidItems()
}

const handleCheckout = () => {
  loadCheckout()
}

const onRefresh = async () => {
  refreshing.value = true
  await loadCartData()
  refreshing.value = false
}

const onScrollToLower = () => {
}

onMounted(() => {
  loadCartData()
})

onShow(() => {
  loadCartData()
})
</script>

<style lang="scss" scoped>
.page-cart {
  height: 100vh;
  background-color: $bg-page;
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

.cart-header {
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
}

.header-title {
  font-size: 36rpx;
  font-weight: 600;
  color: $text-main;
}

.header-right {
  width: 80rpx;
  display: flex;
  justify-content: flex-end;

  .manage-text {
    font-size: 28rpx;
    color: $color-primary;
  }
}

.page-content {
  flex: 1;
  margin-top: calc(88rpx + env(safe-area-inset-top));
}

// 底部占位：fixed footer 高度(120rpx) + tab bar 高度(120rpx) + safe-area
.cart-bottom-spacer {
  width: 100%;
  height: calc(120rpx + 120rpx + env(safe-area-inset-bottom));
}

.empty-cart {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding-top: 200rpx;

  .empty-icon {
    width: 200rpx;
    height: 200rpx;
    display: flex;
    align-items: center;
    justify-content: center;
    margin-bottom: 32rpx;

    .empty-emoji {
      font-size: 120rpx;
    }
  }

  .empty-title {
    font-size: 36rpx;
    color: $text-main;
    font-weight: 500;
    margin-bottom: 16rpx;
  }

  .empty-desc {
    font-size: 26rpx;
    color: $text-weak;
    margin-bottom: 64rpx;
  }

  .empty-btn {
    padding: 24rpx 80rpx;
    background: linear-gradient(135deg, $color-primary 0%, $color-primary-danger 100%);
    border-radius: 48rpx;

    text {
      font-size: 30rpx;
      color: #FFFFFF;
      font-weight: 500;
    }
  }
}

.cart-list {
  padding: 20rpx;
}

.merchant-group {
  background: $bg-card;
  border-radius: 20rpx;
  margin-bottom: 16rpx;
  overflow: hidden;
}

.merchant-header {
  display: flex;
  align-items: center;
  padding: 20rpx 24rpx;
  padding-bottom: 16rpx;
  border-bottom: 1rpx solid $bg-page-light;
}

.merchant-checkbox {
  margin-right: 16rpx;
}

.merchant-logo-wrap {
  width: 56rpx;
  height: 56rpx;
  border-radius: 12rpx;
  overflow: hidden;
  margin-right: 16rpx;
  background: linear-gradient(135deg, rgba($color-primary, 0.1) 0%, rgba($color-primary-danger, 0.1) 100%);
  flex-shrink: 0;
  display: flex;
  align-items: center;
  justify-content: center;
}

.merchant-logo-text {
  font-size: 28rpx;
  font-weight: 600;
  color: $color-primary;
}

.merchant-name {
  font-size: 28rpx;
  color: $text-main;
  font-weight: 500;
  flex: 1;
}

.merchant-goods-list {
  padding: 0 24rpx;
}

.goods-item {
  display: flex;
  align-items: center;
  padding: 20rpx 0;
  border-bottom: 1rpx solid $bg-page-light;
  position: relative;

  &:last-child {
    border-bottom: none;
  }
}

.goods-checkbox {
  margin-right: 20rpx;
}

.checkbox {
  width: 44rpx;
  height: 44rpx;
  border: 2rpx solid #CCCCCC;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.2s ease;

  &.checkbox-active {
    background: linear-gradient(135deg, $color-primary 0%, $color-primary-danger 100%);
    border-color: transparent;

    .check-icon {
      color: #FFFFFF;
      font-size: 24rpx;
      font-weight: bold;
    }
  }
}

.goods-image-wrap {
  width: 180rpx;
  height: 180rpx;
  border-radius: 16rpx;
  overflow: hidden;
  margin-right: 20rpx;
  background: $bg-page-light;
  flex-shrink: 0;

  .goods-image {
    width: 100%;
    height: 100%;
  }
}

.goods-info {
  flex: 1;
  display: flex;
  flex-direction: column;
  min-width: 0;

  .goods-name {
    font-size: 28rpx;
    color: $text-main;
    font-weight: 400;
    line-height: 1.4;
    height: 78rpx;
    overflow: hidden;
    text-overflow: ellipsis;
    display: -webkit-box;
    -webkit-line-clamp: 2;
    line-clamp: 2;
    -webkit-box-orient: vertical;
    margin-bottom: 12rpx;
  }

  .goods-sku {
    font-size: 24rpx;
    color: $text-weak;
    margin-bottom: 16rpx;
  }

  .goods-bottom {
    display: flex;
    align-items: center;
    justify-content: space-between;

    .goods-price {
      font-size: 32rpx;
      color: $color-primary-danger;
      font-weight: 600;
    }
  }
}

.stepper {
  display: flex;
  align-items: center;
  background: $bg-page-light;
  border-radius: 16rpx;
  overflow: hidden;

  .stepper-btn {
    width: 60rpx;
    height: 56rpx;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: all 0.2s ease;

    text {
      font-size: 32rpx;
      color: $text-sub;
      font-weight: 400;
    }

    &:active:not(.stepper-disabled) {
      background: rgba($color-primary, 0.1);

      text {
        color: $color-primary;
      }
    }

    &.stepper-disabled {
      opacity: 0.4;
    }
  }

  .stepper-value {
    min-width: 60rpx;
    height: 56rpx;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 28rpx;
    color: $text-main;
    border-left: 2rpx solid #E5E5E5;
    border-right: 2rpx solid #E5E5E5;
    padding: 0 16rpx;
    transition: background 0.2s;

    &:active {
      background: rgba(255, 106, 0, 0.08);
    }
    font-weight: 500;
  }
}

.invalid-section {
  padding: 0 20rpx;
  margin-top: 16rpx;
}

.invalid-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 20rpx;
  background: $bg-card;
  border-radius: 20rpx 20rpx 0 0;

  .invalid-title {
    font-size: 26rpx;
    color: $text-sub;
  }

  .invalid-arrow {
    font-size: 28rpx;
    color: $text-weak;
    transition: transform 0.3s ease;

    &.arrow-up {
      transform: rotate(90deg);
    }
  }
}

.invalid-list {
  background: $bg-card;
  border-radius: 0 0 20rpx 20rpx;
  padding: 0 20rpx 20rpx;
  margin-bottom: 16rpx;
}

.invalid-item {
  display: flex;
  padding: 20rpx 0;
  border-bottom: 1rpx solid $bg-page-light;
  opacity: 0.6;

  &:last-child {
    border-bottom: none;
  }
}

.invalid-image-wrap {
  width: 120rpx;
  height: 120rpx;
  border-radius: 12rpx;
  overflow: hidden;
  margin-right: 16rpx;
  background: $bg-page-light;
  flex-shrink: 0;

  .invalid-image {
    width: 100%;
    height: 100%;
  }
}

.invalid-info {
  flex: 1;
  display: flex;
  flex-direction: column;
  justify-content: center;

  .invalid-name {
    font-size: 26rpx;
    color: $text-main;
    margin-bottom: 8rpx;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }

  .invalid-reason {
    font-size: 22rpx;
    color: $color-error;
  }
}

.invalid-clear-btn {
  padding: 20rpx;
  margin-top: 16rpx;
  background: $bg-page-light;
  border-radius: 12rpx;
  text-align: center;

  text {
    font-size: 26rpx;
    color: $text-sub;
  }
}

.cart-footer {
  position: fixed;
  bottom: 120rpx;
  left: 0;
  right: 0;
  display: flex;
  align-items: center;
  padding: 20rpx 24rpx;
  padding-bottom: calc(20rpx + env(safe-area-inset-bottom));
  background: $bg-card;
  box-shadow: 0 -2rpx 12rpx rgba(0, 0, 0, 0.06);
}

.footer-left {
  display: flex;
  align-items: center;

  .checkbox {
    margin-right: 12rpx;
  }

  .footer-checkbox-text {
    font-size: 28rpx;
    color: $text-main;
  }
}

.footer-manage {
  flex: 1;
  display: flex;
  justify-content: flex-end;
  padding-right: 16rpx;

  .manage-delete-btn {
    padding: 16rpx 32rpx;
    background: $color-primary-danger;
    border-radius: 32rpx;

    text {
      font-size: 28rpx;
      color: #FFFFFF;
    }

    &.btn-disabled {
      opacity: 0.4;
    }
  }
}

.footer-right {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: flex-end;
  padding-left: 32rpx;
  gap: 24rpx;

  .price-info {
    display: flex;
    align-items: baseline;

    .price-label {
      font-size: 26rpx;
      color: $text-sub;
    }

    .price-value {
      font-size: 36rpx;
      color: $color-primary-danger;
      font-weight: 600;
    }
  }

  .checkout-btn {
    padding: 20rpx 40rpx;
    background: linear-gradient(135deg, $color-primary 0%, $color-primary-danger 100%);
    border-radius: 48rpx;

    text {
      font-size: 30rpx;
      color: #FFFFFF;
      font-weight: 500;
    }

    &.btn-disabled {
      opacity: 0.4;
      background: #CCCCCC;
    }
  }
}
</style>
