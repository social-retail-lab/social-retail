<template>
  <view v-if="visible" class="share-popup">
    <!-- 遮罩 -->
    <view class="mask" @click="handleClose"></view>

    <!-- 弹窗主体 -->
    <view class="popup-content">
      <!-- 顶部标题 -->
      <view class="popup-header">
        <text class="popup-title">推广分享</text>
        <view class="close-btn" @click="handleClose">
          <text class="close-icon">✕</text>
        </view>
      </view>

      <!-- 加载中 -->
      <view v-if="loading" class="loading-state">
        <view class="loading-spinner"></view>
        <text class="loading-text">生成推广链接中...</text>
      </view>

      <!-- 内容区 -->
      <view v-else-if="shareData" class="share-body">
        <!-- 商品预览 -->
        <view class="product-preview">
          <image
            :src="shareData.mainImage || productInfo.mainImage"
            mode="aspectFill"
            class="product-img"
          />
          <view class="product-info">
            <text class="product-name">{{ productInfo.productName }}</text>
            <text class="product-price">¥{{ formatMoney(productInfo.price) }}</text>
          </view>
        </view>

        <!-- 二维码大图 -->
        <view class="qrcode-section">
          <view class="qrcode-wrap">
            <image
              v-if="shareData.qrCode"
              :src="shareData.qrCode"
              mode="aspectFit"
              class="qrcode-img"
              @longpress="onQrCodeLongPress"
            />
            <view v-else class="qrcode-placeholder">
              <text class="placeholder-icon">📋</text>
              <text class="placeholder-text">二维码生成中</text>
            </view>
          </view>
          <text class="qrcode-tip">长按二维码可保存到相册</text>
        </view>

        <!-- 推广码 -->
        <view class="info-row">
          <view class="info-label">
            <text class="label-text">推广码</text>
          </view>
          <view class="info-value">
            <text class="value-text">{{ shareData.promotionCode || '-' }}</text>
          </view>
          <view class="copy-btn" @click="handleCopyCode">
            <text class="copy-text">复制</text>
          </view>
        </view>

        <!-- 推广链接 -->
        <view class="info-row">
          <view class="info-label">
            <text class="label-text">推广链接</text>
          </view>
          <view class="info-value">
            <text class="value-text link-text">{{ shareData.promotionUrl || '-' }}</text>
          </view>
          <view class="copy-btn" @click="handleCopyLink">
            <text class="copy-text">复制</text>
          </view>
        </view>

        <!-- 操作按钮 -->
        <view class="action-row">
          <view class="action-btn btn-save" @click="handleSaveImage">
            <text class="action-icon">💾</text>
            <text class="action-text">保存图片</text>
          </view>
          <view class="action-btn btn-share" @click="handleShare">
            <text class="action-icon">📤</text>
            <text class="action-text">分享给好友</text>
          </view>
        </view>
      </view>

      <!-- 生成失败 -->
      <view v-else class="error-state">
        <text class="error-icon">⚠</text>
        <text class="error-text">推广链接生成失败</text>
        <view class="retry-btn" @click="handleRetry">
          <text class="retry-text">重新生成</text>
        </view>
      </view>
    </view>
  </view>
</template>

<script setup>
import { ref, watch } from 'vue'
import { useDistributor } from '@/hooks/useDistributor'

const props = defineProps({
  // 是否显示
  visible: {
    type: Boolean,
    default: false
  },
  // 商品信息（用于显示预览）
  productInfo: {
    type: Object,
    default: () => ({})
  },
  // 推广记录ID
  distributorProductId: {
    type: [Number, String],
    default: null
  }
})

const emit = defineEmits(['close', 'success'])

const {
  generateShareLink,
  copyPromotionUrl,
  copyPromotionCode,
  saveQrCode
} = useDistributor()

// 内部状态
const loading = ref(false)
const shareData = ref(null)

const formatMoney = (value) => {
  return (Number(value) || 0).toFixed(2)
}

// 生成推广链接
const fetchShareLink = async () => {
  if (!props.distributorProductId) {
    uni.showToast({ title: '推广记录ID缺失', icon: 'none' })
    return
  }
  loading.value = true
  shareData.value = null
  const data = await generateShareLink(props.distributorProductId)
  loading.value = false
  if (data) {
    shareData.value = data
    emit('success', data)
  }
}

// 复制推广码
const handleCopyCode = () => {
  copyPromotionCode(shareData.value?.promotionCode)
}

// 复制推广链接
const handleCopyLink = () => {
  copyPromotionUrl(shareData.value?.promotionUrl)
}

// 保存二维码图片
const handleSaveImage = () => {
  saveQrCode(shareData.value?.qrCode)
}

// 长按二维码保存
const onQrCodeLongPress = () => {
  saveQrCode(shareData.value?.qrCode)
}

// 分享给好友（调用系统分享）
const handleShare = () => {
  const url = shareData.value?.promotionUrl
  const title = props.productInfo?.productName || '推荐好物'
  if (!url) {
    uni.showToast({ title: '链接未生成', icon: 'none' })
    return
  }
  // #ifdef H5
  // H5 端使用 navigator.share（如果支持）
  if (navigator.share) {
    navigator.share({ title, url }).catch(() => {
      copyPromotionUrl(url)
    })
  } else {
    copyPromotionUrl(url)
  }
  // #endif
  // #ifdef APP-PLUS
  uni.share({
    provider: 'weixin',
    scene: 'WXSceneSession',
    type: 0,
    title,
    summary: props.productInfo?.subTitle || '',
    href: url,
    imageUrl: props.productInfo?.mainImage || '',
    fail: () => {
      copyPromotionUrl(url)
    }
  })
  // #endif
}

// 重试
const handleRetry = () => {
  fetchShareLink()
}

// 关闭弹窗
const handleClose = () => {
  emit('close')
}

// 监听弹窗打开 → 自动生成推广链接
watch(() => props.visible, (val) => {
  if (val && props.distributorProductId) {
    fetchShareLink()
  } else if (!val) {
    // 关闭时重置
    shareData.value = null
    loading.value = false
  }
})
</script>

<style lang="scss" scoped>
.share-popup {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  z-index: 9999;
  display: flex;
  align-items: center;
  justify-content: center;
}

.mask {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.55);
  backdrop-filter: blur(8rpx);
}

.popup-content {
  position: relative;
  width: 86%;
  max-width: 640rpx;
  background: $bg-card;
  border-radius: 32rpx;
  overflow: hidden;
  box-shadow: 0 24rpx 64rpx rgba(0, 0, 0, 0.2);
  animation: popIn 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

@keyframes popIn {
  from {
    opacity: 0;
    transform: scale(0.85);
  }
  to {
    opacity: 1;
    transform: scale(1);
  }
}

.popup-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 32rpx 32rpx 20rpx;
  border-bottom: 2rpx solid $bg-page-light;

  .popup-title {
    font-size: 32rpx;
    font-weight: 600;
    color: $ink-900;
  }

  .close-btn {
    width: 56rpx;
    height: 56rpx;
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: 50%;
    background: $bg-page-light;

    &:active {
      transform: scale(0.92);
    }

    .close-icon {
      font-size: 28rpx;
      color: $text-sub;
    }
  }
}

// ============ 加载状态 ============
.loading-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 80rpx 0;
}

.loading-spinner {
  width: 56rpx;
  height: 56rpx;
  border: 5rpx solid $neutral-200;
  border-top-color: $color-primary;
  border-radius: 50%;
  animation: spin 0.8s linear infinite;
  margin-bottom: 20rpx;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

.loading-text {
  font-size: 26rpx;
  color: $text-weak;
}

// ============ 内容区 ============
.share-body {
  padding: 24rpx 32rpx 32rpx;
}

// 商品预览
.product-preview {
  display: flex;
  align-items: center;
  padding: 20rpx;
  background: $bg-page-light;
  border-radius: 16rpx;
  margin-bottom: 32rpx;

  .product-img {
    width: 96rpx;
    height: 96rpx;
    border-radius: 12rpx;
    margin-right: 20rpx;
    background: $bg-card;
  }

  .product-info {
    flex: 1;
    display: flex;
    flex-direction: column;
    min-width: 0;

    .product-name {
      font-size: 26rpx;
      color: $text-main;
      font-weight: 500;
      line-height: 1.4;
      overflow: hidden;
      text-overflow: ellipsis;
      display: -webkit-box;
      -webkit-line-clamp: 2;
      -webkit-box-orient: vertical;
      margin-bottom: 8rpx;
    }

    .product-price {
      font-size: 30rpx;
      color: $color-primary-danger;
      font-weight: 600;
    }
  }
}

// 二维码
.qrcode-section {
  display: flex;
  flex-direction: column;
  align-items: center;
  margin-bottom: 32rpx;
}

.qrcode-wrap {
  width: 320rpx;
  height: 320rpx;
  background: $bg-card;
  border: 2rpx solid $bg-page-light;
  border-radius: 16rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  overflow: hidden;
  box-shadow: 0 8rpx 24rpx rgba(0, 0, 0, 0.06);

  .qrcode-img {
    width: 100%;
    height: 100%;
  }

  .qrcode-placeholder {
    display: flex;
    flex-direction: column;
    align-items: center;

    .placeholder-icon {
      font-size: 64rpx;
      margin-bottom: 12rpx;
      opacity: 0.4;
    }

    .placeholder-text {
      font-size: 24rpx;
      color: $text-weak;
    }
  }
}

.qrcode-tip {
  font-size: 22rpx;
  color: $text-weak;
  margin-top: 16rpx;
}

// 推广码/链接行
.info-row {
  display: flex;
  align-items: center;
  padding: 20rpx 0;
  border-bottom: 2rpx solid $bg-page-light;

  &:last-of-type {
    border-bottom: none;
  }

  .info-label {
    width: 120rpx;
    flex-shrink: 0;

    .label-text {
      font-size: 26rpx;
      color: $text-sub;
    }
  }

  .info-value {
    flex: 1;
    min-width: 0;
    margin-right: 16rpx;

    .value-text {
      font-size: 26rpx;
      color: $text-main;
      word-break: break-all;

      &.link-text {
        color: $color-primary;
      }
    }
  }

  .copy-btn {
    padding: 10rpx 24rpx;
    background: rgba(255, 106, 0, 0.1);
    border-radius: 24rpx;

    &:active {
      opacity: 0.7;
    }

    .copy-text {
      font-size: 24rpx;
      color: $color-primary;
      font-weight: 500;
    }
  }
}

// 操作按钮
.action-row {
  display: flex;
  gap: 20rpx;
  margin-top: 32rpx;
}

.action-btn {
  flex: 1;
  height: 88rpx;
  border-radius: 44rpx;
  display: flex;
  align-items: center;
  justify-content: center;

  &:active {
    transform: scale(0.96);
  }

  .action-icon {
    font-size: 28rpx;
    margin-right: 10rpx;
  }

  .action-text {
    font-size: 28rpx;
    font-weight: 500;
  }
}

.btn-save {
  background: $bg-page-light;

  .action-icon,
  .action-text {
    color: $text-main;
  }
}

.btn-share {
  background: linear-gradient(135deg, $color-primary 0%, $color-primary-danger 100%);
  box-shadow: 0 8rpx 16rpx rgba(255, 106, 0, 0.3);

  .action-icon,
  .action-text {
    color: #FFFFFF;
  }
}

// ============ 错误状态 ============
.error-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 80rpx 0;

  .error-icon {
    font-size: 80rpx;
    color: $color-primary-danger;
    margin-bottom: 16rpx;
  }

  .error-text {
    font-size: 26rpx;
    color: $text-sub;
    margin-bottom: 32rpx;
  }

  .retry-btn {
    padding: 16rpx 48rpx;
    background: linear-gradient(135deg, $color-primary 0%, $color-primary-danger 100%);
    border-radius: 32rpx;

    .retry-text {
      color: #FFFFFF;
      font-size: 26rpx;
      font-weight: 500;
    }
  }
}
</style>
