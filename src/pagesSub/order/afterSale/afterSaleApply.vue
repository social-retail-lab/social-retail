<template>
  <view class="page-container">
    <!-- 顶部固定导航栏 -->
    <view class="nav-header">
      <view class="nav-left" @click="handleBack">
        <text class="back-icon">‹</text>
      </view>
      <text class="nav-title">申请售后</text>
      <view class="nav-right"></view>
    </view>

    <scroll-view scroll-y class="page-content">
      <!-- 1. 申请商品预览卡片 -->
      <view class="card-container">
        <view class="goods-preview">
          <image :src="getValidImageUrl(productImage)" class="goods-image" mode="aspectFill" />
          <view class="goods-info">
            <text class="goods-name">{{ productName }}</text>
            <text v-if="skuSpecs" class="goods-spec">{{ skuSpecs }}</text>
            <text class="goods-price">¥{{ formatPrice(originPrice) }}</text>
          </view>
        </view>
      </view>

      <!-- 2. 售后类型单选模块 -->
      <view class="card-container">
        <view class="card-header">
          <text class="card-title">售后类型</text>
          <text class="required-mark">*</text>
        </view>
        <view class="type-list">
          <view
            v-for="item in typeOptions"
            :key="item.value"
            class="type-item"
            :class="{ 'type-selected': selectedType === item.value }"
            @click="selectedType = item.value"
          >
            <view class="type-radio">
              <view v-if="selectedType === item.value" class="radio-dot"></view>
            </view>
            <view class="type-content">
              <text class="type-label">{{ item.label }}</text>
              <text class="type-desc">{{ item.desc }}</text>
            </view>
          </view>
        </view>
      </view>

      <!-- 3. 退款金额输入框 -->
      <view class="card-container">
        <view class="card-header">
          <text class="card-title">退款金额</text>
          <text class="required-mark">*</text>
        </view>
        <view class="amount-wrap">
          <text class="amount-symbol">¥</text>
          <input
            class="amount-input"
            v-model="refundAmount"
            type="digit"
            placeholder="请输入退款金额"
            placeholder-class="input-placeholder"
            @blur="handleAmountBlur"
          />
          <text class="amount-max">最多可退¥{{ formatPrice(originPrice) }}</text>
        </view>
      </view>

      <!-- 4. 售后原因选择 -->
      <view class="card-container">
        <view class="card-header">
          <text class="card-title">售后原因</text>
          <text class="required-mark">*</text>
        </view>
        <view class="reason-trigger" @click="showReasonPicker = true">
          <text :class="['reason-text', { 'reason-placeholder': !selectedReason }]">
            {{ selectedReason || '请选择售后原因' }}
          </text>
          <text class="reason-arrow">›</text>
        </view>
        <view v-if="isOtherReason" class="reason-desc-wrap">
          <textarea
            class="reason-desc-input"
            v-model="reasonDesc"
            placeholder="请详细描述您遇到的问题（选填）"
            placeholder-class="input-placeholder"
            maxlength="200"
            :auto-height="true"
          />
          <text class="reason-desc-count">{{ reasonDesc.length }}/200</text>
        </view>
      </view>

      <!-- 5. 凭证图片上传区 -->
      <view class="card-container">
        <view class="card-header">
          <text class="card-title">上传凭证</text>
          <text class="card-tip">最多9张，非必填</text>
        </view>
        <view class="image-list">
          <view
            v-for="(img, index) in evidenceImages"
            :key="index"
            class="image-item"
          >
            <image :src="img" class="image-thumb" mode="aspectFill" @click="handlePreviewImage(index)" />
            <view class="image-delete" @click.stop="handleDeleteImage(index)">
              <text class="delete-icon">×</text>
            </view>
          </view>
          <view
            v-if="evidenceImages.length < 9"
            class="image-add"
            @click="handleChooseImage"
          >
            <text class="add-icon">+</text>
            <text class="add-text">添加图片</text>
          </view>
        </view>
      </view>

      <view class="bottom-space"></view>
    </scroll-view>

    <!-- 底部吸底提交按钮 -->
    <view class="bottom-bar">
      <view
        class="submit-btn"
        :class="{ disabled: submitting }"
        @click="handleSubmit"
      >
        <text>提交售后申请</text>
      </view>
    </view>

    <!-- 售后原因底部弹窗 -->
    <view v-if="showReasonPicker" class="picker-mask" @click="showReasonPicker = false">
      <view class="picker-sheet" @click.stop>
        <view class="picker-header">
          <text class="picker-title">选择售后原因</text>
          <view class="picker-close" @click="showReasonPicker = false">
            <text class="close-icon">×</text>
          </view>
        </view>
        <view class="picker-options">
          <view
            v-for="reason in reasonOptions"
            :key="reason"
            class="picker-option"
            :class="{ 'option-selected': selectedReason === reason }"
            @click="handleSelectReason(reason)"
          >
            <text class="option-text">{{ reason }}</text>
            <view class="option-radio">
              <view v-if="selectedReason === reason" class="radio-dot"></view>
            </view>
          </view>
        </view>
        <view class="picker-footer">
          <view class="picker-confirm" @click="showReasonPicker = false">
            <text>确定</text>
          </view>
        </view>
      </view>
    </view>
  </view>
</template>

<script setup>
import { ref, computed } from 'vue'
import { onLoad } from '@dcloudio/uni-app'
import { useAfterSale } from '@/hooks/useAfterSale'
import { uploadFileApi } from '@/api/afterSale'
import { showToast, getValidImageUrl, formatPrice } from '@/utils/common'
import {
  AFTER_SALE_TYPE,
  AFTER_SALE_TYPE_TEXT,
  AFTER_SALE_TYPE_DESC,
  AFTER_SALE_REASONS
} from '@/constants/afterSale'

const {
  submitting,
  submitAfterSaleApply
} = useAfterSale()

// 路由参数
const orderId = ref('')
const orderItemId = ref('')
const productName = ref('')
const productImage = ref('')
const skuSpecs = ref('')
const originPrice = ref(0)

// 表单数据
const selectedType = ref('')
const refundAmount = ref('')
const selectedReason = ref('')
const reasonDesc = ref('')
const evidenceImages = ref([])

// 弹窗
const showReasonPicker = ref(false)

// 售后类型选项(来自常量)
const typeOptions = [
  { value: AFTER_SALE_TYPE.REFUND_ONLY, label: AFTER_SALE_TYPE_TEXT.REFUND_ONLY, desc: AFTER_SALE_TYPE_DESC.REFUND_ONLY },
  { value: AFTER_SALE_TYPE.RETURN_REFUND, label: AFTER_SALE_TYPE_TEXT.RETURN_REFUND, desc: AFTER_SALE_TYPE_DESC.RETURN_REFUND }
]

// 售后原因选项(来自常量)
const reasonOptions = AFTER_SALE_REASONS

const isOtherReason = computed(() => selectedReason.value === '其他')

onLoad((options) => {
  orderId.value = options.orderId || ''
  orderItemId.value = options.orderItemId || ''
  productName.value = options.productName ? decodeURIComponent(options.productName) : ''
  productImage.value = options.productImage ? decodeURIComponent(options.productImage) : ''
  skuSpecs.value = options.skuSpecs ? decodeURIComponent(options.skuSpecs) : ''
  originPrice.value = options.originPrice ? Number(options.originPrice) : 0
})

const handleBack = () => {
  uni.navigateBack()
}

// 退款金额失焦校验：保留两位小数 + 限制上限
const handleAmountBlur = () => {
  if (refundAmount.value === '') return
  const num = Number(refundAmount.value)
  if (isNaN(num)) {
    refundAmount.value = ''
    return
  }
  if (num > originPrice.value) {
    showToast(`退款金额不能超过¥${formatPrice(originPrice.value)}`)
    refundAmount.value = formatPrice(originPrice.value)
    return
  }
  refundAmount.value = formatPrice(num)
}

// 选择售后原因
const handleSelectReason = (reason) => {
  selectedReason.value = reason
  if (reason !== '其他') {
    reasonDesc.value = ''
  }
}

// 选择并上传凭证图片
const handleChooseImage = () => {
  const remaining = 9 - evidenceImages.value.length
  if (remaining <= 0) {
    showToast('最多上传9张图片')
    return
  }
  uni.chooseImage({
    count: remaining,
    sourceType: ['album', 'camera'],
    success: async (res) => {
      const filePaths = res.tempFilePaths || []
      uni.showLoading({ title: '上传中...', mask: true })
      try {
        for (const filePath of filePaths) {
          const url = await uploadFileApi(filePath)
          if (url) {
            evidenceImages.value.push(url)
          }
        }
      } catch (e) {
        showToast('图片上传失败')
      } finally {
        uni.hideLoading()
      }
    }
  })
}

// 全屏预览图片
const handlePreviewImage = (index) => {
  uni.previewImage({
    urls: evidenceImages.value,
    current: evidenceImages.value[index]
  })
}

// 删除单张凭证
const handleDeleteImage = (index) => {
  evidenceImages.value.splice(index, 1)
}

// 表单校验
const validateForm = () => {
  if (!selectedType.value) {
    showToast('请选择售后类型')
    return false
  }
  const amount = Number(refundAmount.value)
  if (!refundAmount.value || isNaN(amount) || amount <= 0) {
    showToast('请输入退款金额')
    return false
  }
  if (amount > originPrice.value) {
    showToast(`退款金额不能超过¥${formatPrice(originPrice.value)}`)
    return false
  }
  if (!selectedReason.value) {
    showToast('请选择售后原因')
    return false
  }
  return true
}

// 提交售后申请(通过 Hook)
const handleSubmit = async () => {
  if (submitting.value) return
  if (!validateForm()) return

  const data = {
    orderId: orderId.value,
    orderItemId: orderItemId.value,
    type: selectedType.value,
    refundAmount: Number(refundAmount.value),
    reason: selectedReason.value,
    reasonDesc: selectedReason.value === '其他' ? reasonDesc.value.trim() : '',
    evidenceImages: evidenceImages.value
  }

  const result = await submitAfterSaleApply(data)
  if (result) {
    // 提交成功,跳转售后列表
    setTimeout(() => {
      uni.redirectTo({ url: '/pagesSub/order/afterSaleList' })
    }, 1500)
  }
}
</script>

<style lang="scss" scoped>
.page-container {
  min-height: 100vh;
  background: $bg-page;
  display: flex;
  flex-direction: column;
}

.nav-header {
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

  .nav-left, .nav-right {
    width: 80rpx;
    display: flex;
    align-items: center;
    justify-content: center;
  }

  .back-icon {
    font-size: 56rpx;
    color: $text-main;
    line-height: 1;
  }

  .nav-title {
    font-size: 36rpx;
    font-weight: 600;
    color: $text-main;
  }
}

.page-content {
  flex: 1;
  padding-top: calc(88rpx + env(safe-area-inset-top));
}

.card-container {
  background: $bg-card;
  margin: 24rpx;
  border-radius: 24rpx;
  overflow: hidden;
  box-shadow: $category-shadow-sm;
}

.card-header {
  display: flex;
  align-items: center;
  padding: 28rpx 32rpx 0;

  .card-title {
    font-size: 30rpx;
    font-weight: 600;
    color: $text-main;
  }

  .required-mark {
    font-size: 30rpx;
    color: $color-primary-danger;
    margin-left: 4rpx;
  }

  .card-tip {
    font-size: 24rpx;
    color: $text-weak;
    margin-left: auto;
  }
}

// 商品预览
.goods-preview {
  display: flex;
  padding: 24rpx 32rpx;

  .goods-image {
    width: 160rpx;
    height: 160rpx;
    border-radius: 16rpx;
    margin-right: 20rpx;
    background: $bg-page-light;
    flex-shrink: 0;
  }

  .goods-info {
    flex: 1;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    overflow: hidden;

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

    .goods-price {
      font-size: 30rpx;
      color: $color-primary-danger;
      font-weight: 600;
      margin-top: 12rpx;
    }
  }
}

// 售后类型
.type-list {
  padding: 20rpx 32rpx 28rpx;

  .type-item {
    display: flex;
    align-items: flex-start;
    padding: 24rpx;
    border: 2rpx solid $border-color;
    border-radius: 16rpx;
    margin-top: 20rpx;
    transition: all 0.2s ease;

    &:first-child {
      margin-top: 0;
    }

    &.type-selected {
      border-color: $color-primary;
      background: rgba($color-primary, 0.04);
    }

    .type-radio {
      width: 36rpx;
      height: 36rpx;
      border: 2rpx solid $gray-300;
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      margin-right: 20rpx;
      flex-shrink: 0;
      margin-top: 4rpx;

      .radio-dot {
        width: 20rpx;
        height: 20rpx;
        border-radius: 50%;
        background: $color-primary;
      }
    }

    &.type-selected .type-radio {
      border-color: $color-primary;
    }

    .type-content {
      flex: 1;
      display: flex;
      flex-direction: column;

      .type-label {
        font-size: 30rpx;
        color: $text-main;
        font-weight: 500;
      }

      .type-desc {
        font-size: 24rpx;
        color: $text-weak;
        margin-top: 8rpx;
        line-height: 1.4;
      }
    }
  }
}

// 退款金额
.amount-wrap {
  display: flex;
  align-items: center;
  flex-wrap: wrap;
  padding: 24rpx 32rpx 28rpx;

  .amount-symbol {
    font-size: 36rpx;
    color: $text-main;
    font-weight: 600;
    margin-right: 8rpx;
  }

  .amount-input {
    flex: 1;
    min-width: 200rpx;
    font-size: 36rpx;
    color: $text-main;
    font-weight: 600;
    padding: 0;
    height: 56rpx;
  }

  .input-placeholder {
    color: $gray-400;
    font-size: 28rpx;
    font-weight: 400;
  }

  .amount-max {
    flex: 1 0 100%;
    font-size: 24rpx;
    color: $text-weak;
    margin-top: 16rpx;
  }
}

// 售后原因
.reason-trigger {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 28rpx 32rpx;

  .reason-text {
    font-size: 30rpx;
    color: $text-main;
    flex: 1;

    &.reason-placeholder {
      color: $gray-400;
    }
  }

  .reason-arrow {
    font-size: 36rpx;
    color: $text-weak;
    margin-left: 16rpx;
  }
}

.reason-desc-wrap {
  padding: 0 32rpx 28rpx;
  background: $bg-page-light;
  margin: 0 32rpx 28rpx;
  border-radius: 16rpx;
  padding: 24rpx;

  .reason-desc-input {
    width: 100%;
    font-size: 28rpx;
    color: $text-main;
    line-height: 1.6;
    min-height: 120rpx;
    padding: 0;
  }

  .reason-desc-count {
    font-size: 22rpx;
    color: $text-weak;
    text-align: right;
    display: block;
    margin-top: 8rpx;
  }
}

.input-placeholder {
  color: $gray-400;
  font-size: 28rpx;
}

// 凭证图片
.image-list {
  display: flex;
  flex-wrap: wrap;
  gap: 20rpx;
  padding: 20rpx 32rpx 28rpx;

  .image-item {
    position: relative;
    width: 180rpx;
    height: 180rpx;

    .image-thumb {
      width: 100%;
      height: 100%;
      border-radius: 12rpx;
      background: $bg-page-light;
    }

    .image-delete {
      position: absolute;
      top: -12rpx;
      right: -12rpx;
      width: 36rpx;
      height: 36rpx;
      background: rgba(0, 0, 0, 0.55);
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;

      .delete-icon {
        font-size: 28rpx;
        color: #FFFFFF;
        line-height: 1;
      }
    }
  }

  .image-add {
    width: 180rpx;
    height: 180rpx;
    background: $bg-page-light;
    border: 2rpx dashed $gray-300;
    border-radius: 12rpx;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;

    .add-icon {
      font-size: 56rpx;
      color: $gray-400;
      line-height: 1;
    }

    .add-text {
      font-size: 22rpx;
      color: $text-weak;
      margin-top: 8rpx;
    }

    &:active {
      background: $bg-grey;
    }
  }
}

.bottom-space {
  height: calc(140rpx + env(safe-area-inset-bottom));
}

// 底部吸底按钮
.bottom-bar {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  padding: 20rpx 32rpx;
  padding-bottom: calc(20rpx + env(safe-area-inset-bottom));
  background: $bg-card;
  box-shadow: 0 -4rpx 16rpx rgba(0, 0, 0, 0.05);

  .submit-btn {
    height: 88rpx;
    border-radius: 44rpx;
    background: linear-gradient(135deg, $color-primary 0%, $color-primary-danger 100%);
    display: flex;
    align-items: center;
    justify-content: center;

    text {
      font-size: 32rpx;
      color: #FFFFFF;
      font-weight: 600;
    }

    &.disabled {
      opacity: 0.6;
    }

    &:active {
      transform: scale(0.99);
    }
  }
}

// 原因选择弹窗
.picker-mask {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.5);
  z-index: 200;
  display: flex;
  align-items: flex-end;
}

.picker-sheet {
  width: 100%;
  background: $bg-card;
  border-radius: 24rpx 24rpx 0 0;
  padding-bottom: env(safe-area-inset-bottom);

  .picker-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 32rpx;
    border-bottom: 1rpx solid $bg-page-light;

    .picker-title {
      font-size: 32rpx;
      font-weight: 600;
      color: $text-main;
    }

    .picker-close {
      width: 60rpx;
      height: 60rpx;
      display: flex;
      align-items: center;
      justify-content: center;

      .close-icon {
        font-size: 44rpx;
        color: $text-weak;
        line-height: 1;
      }
    }
  }

  .picker-options {
    padding: 8rpx 32rpx;
    max-height: 600rpx;
    overflow-y: auto;

    .picker-option {
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding: 28rpx 0;
      border-bottom: 1rpx solid $bg-page-light;

      &:last-child {
        border-bottom: none;
      }

      .option-text {
        font-size: 30rpx;
        color: $text-main;
      }

      .option-radio {
        width: 36rpx;
        height: 36rpx;
        border: 2rpx solid $gray-300;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;

        .radio-dot {
          width: 20rpx;
          height: 20rpx;
          border-radius: 50%;
          background: $color-primary;
        }
      }

      &.option-selected {
        .option-text {
          color: $color-primary;
          font-weight: 500;
        }

        .option-radio {
          border-color: $color-primary;
        }
      }
    }
  }

  .picker-footer {
    padding: 20rpx 32rpx 32rpx;

    .picker-confirm {
      height: 88rpx;
      border-radius: 44rpx;
      background: linear-gradient(135deg, $color-primary 0%, $color-primary-danger 100%);
      display: flex;
      align-items: center;
      justify-content: center;

      text {
        font-size: 32rpx;
        color: #FFFFFF;
        font-weight: 600;
      }

      &:active {
        transform: scale(0.99);
      }
    }
  }
}
</style>
