<template>
  <view class="sku-popup" :class="{ show: visible }" @click="$emit('close')">
    <view class="popup-mask"></view>
    <view class="popup-content" @click.stop>
      <view class="popup-header">
        <image
          :src="selectedSkuImage"
          mode="aspectFill"
          class="popup-image"
        />
        <view class="popup-info">
          <text class="popup-price">¥{{ selectedSku?.price || productPrice }}</text>
          <text class="popup-stock">库存: {{ selectedSku?.stock || productStock }}</text>
          <text class="popup-selected">已选: {{ selectedSku?.skuName || '未选择规格' }}</text>
        </view>
        <view class="popup-close" @click="$emit('close')">
          <text class="close-icon">×</text>
        </view>
      </view>

      <scroll-view scroll-y class="popup-body">
        <view v-for="(spec, specName) in specOptions" :key="specName" class="spec-group">
          <text class="spec-name">{{ specName }}</text>
          <view class="spec-values">
            <view
              v-for="value in spec"
              :key="value"
              class="spec-value"
              :class="{ 'spec-value-active': selectedSpecs[specName] === value, 'spec-value-disabled': !isSpecAvailable(specName, value) }"
              @click="selectSpec(specName, value)"
            >
              <text>{{ value }}</text>
            </view>
          </view>
        </view>
      </scroll-view>

      <view class="popup-footer">
        <view class="quantity-control">
          <text class="quantity-btn" @click="decreaseQuantity">-</text>
          <text class="quantity-value">{{ quantity }}</text>
          <text class="quantity-btn" @click="increaseQuantity">+</text>
        </view>
        <view class="popup-btns">
          <view class="btn-add-cart" @click="handleAddCart">
            <text>加入购物车</text>
          </view>
          <view class="btn-confirm" @click="handleConfirm">
            <text>立即购买</text>
          </view>
        </view>
      </view>
    </view>
  </view>
</template>

<script setup>
import { ref, computed, watch } from 'vue'

const props = defineProps({
  visible: {
    type: Boolean,
    default: false
  },
  skuList: {
    type: Array,
    default: () => []
  },
  productImage: {
    type: String,
    default: ''
  },
  productPrice: {
    type: Number,
    default: 0
  },
  productStock: {
    type: Number,
    default: 999
  }
})

const emit = defineEmits(['close', 'confirm', 'addCart'])

const selectedSku = ref(null)
const selectedSpecs = ref({})
const quantity = ref(1)

const selectedSkuImage = computed(() => props.productImage)

const specOptions = computed(() => {
  const specs = {}
  props.skuList.forEach(sku => {
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

const isSpecAvailable = (specName, value) => {
  if (!selectedSku.value) return true
  
  const tempSpecs = { ...selectedSpecs.value, [specName]: value }
  const matchedSku = props.skuList.find(sku => {
    if (!sku.specs) return false
    return Object.keys(tempSpecs).every(key => {
      return sku.specs[key] === tempSpecs[key]
    })
  })
  
  return matchedSku && matchedSku.stock > 0
}

const selectSpec = (specName, value) => {
  const tempSpecs = { ...selectedSpecs.value, [specName]: value }
  
  const matchedSku = props.skuList.find(sku => {
    if (!sku.specs) return false
    return Object.keys(tempSpecs).every(key => {
      return sku.specs[key] === tempSpecs[key]
    })
  })
  
  if (matchedSku && matchedSku.stock > 0) {
    selectedSpecs.value = tempSpecs
    selectedSku.value = matchedSku
  }
}

const increaseQuantity = () => {
  const maxStock = selectedSku.value?.stock || props.productStock || 999
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
  if (!selectedSku.value && props.skuList.length > 0) {
    uni.showToast({ title: '请选择规格', icon: 'none' })
    return
  }
  
  emit('addCart', {
    sku: selectedSku.value,
    quantity: quantity.value
  })
}

const handleConfirm = () => {
  if (!selectedSku.value && props.skuList.length > 0) {
    uni.showToast({ title: '请选择规格', icon: 'none' })
    return
  }
  
  emit('confirm', {
    sku: selectedSku.value,
    quantity: quantity.value
  })
}

watch(() => props.visible, (newVal) => {
  if (newVal) {
    quantity.value = 1
    if (props.skuList.length > 0) {
      const availableSku = props.skuList.find(s => s.stock > 0)
      if (availableSku) {
        selectedSku.value = availableSku
        if (availableSku.specs) {
          selectedSpecs.value = { ...availableSku.specs }
        }
      }
    }
  }
})
</script>

<style lang="scss" scoped>
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

.spec-value-disabled {
  opacity: 0.4;

  &:active {
    pointer-events: none;
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
</style>