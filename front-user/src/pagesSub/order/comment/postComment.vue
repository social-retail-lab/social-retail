<template>
  <view class="page-post">
    <!-- 导航栏 -->
    <view class="nav-bar" :style="{ paddingTop: statusBarHeight + 'px' }">
      <view class="nav-back" @click="handleBack">
        <text class="back-icon">‹</text>
      </view>
      <text class="nav-title">发布评价</text>
      <view class="nav-placeholder-right"></view>
    </view>
    <view class="nav-placeholder" :style="{ height: (statusBarHeight + 44) + 'px' }"></view>

    <!-- 商品信息 + 评分（合并顶部区） -->
    <view class="section product-section">
      <view class="product-row">
        <image
          v-if="productInfo.image"
          :src="productInfo.image"
          mode="aspectFill"
          class="product-thumb"
        />
        <view class="product-info">
          <text class="product-name">{{ productInfo.name }}</text>
          <text v-if="productInfo.skuSpecs" class="product-spec">{{ productInfo.skuSpecs }}</text>
        </view>
      </view>
      <view class="score-row">
        <view
          v-for="star in 5"
          :key="star"
          class="star-item"
          @click="formData.score = star"
        >
          <text
            class="star-icon"
            :class="{ 'star-active': star <= formData.score }"
          >★</text>
        </view>
        <text class="score-text">{{ getScoreText(formData.score) }}</text>
      </view>
    </view>

    <!-- 评价内容 -->
    <view class="section">
      <view class="section-label">
        <text class="label-text">评价内容</text>
        <text class="char-count">{{ formData.content.length }}/500</text>
      </view>
      <textarea
        class="content-textarea"
        v-model="formData.content"
        placeholder="分享真实使用感受"
        placeholder-class="textarea-placeholder"
        :maxlength="500"
        auto-height
      />
    </view>

    <!-- 图片上传 -->
    <view class="section">
      <view class="section-label">
        <text class="label-text">上传图片</text>
        <text class="image-count">{{ imagePreviews.length }}/6</text>
      </view>
      <view class="image-grid">
        <view
          v-for="(img, index) in imagePreviews"
          :key="index"
          class="image-item"
        >
          <image
            :src="img"
            mode="aspectFill"
            class="preview-img"
            @click="previewCommentImage(imagePreviews, img)"
          />
          <view class="image-delete" @click.stop="removeCommentImage(index)">
            <text class="delete-icon">✕</text>
          </view>
        </view>
        <view
          v-if="imagePreviews.length < 6"
          class="image-add"
          @click="addCommentImage"
        >
          <text class="add-icon">+</text>
          <text class="add-text">添加图片</text>
        </view>
      </view>
    </view>

    <!-- 小贴士 -->
    <view class="tip-section">
      <text class="tip-text">完善图文评价，帮助其他用户做出更好的选择</text>
    </view>

    <!-- 匿名评价 -->
    <view class="section section-anonymous" @click="toggleAnonymous">
      <text class="label-text">匿名评价</text>
      <view class="radio-wrap">
        <view
          class="radio"
          :class="{ 'radio-checked': formData.anonymous === ANONYMOUS.YES }"
        >
          <text v-if="formData.anonymous === ANONYMOUS.YES" class="radio-dot"></text>
        </view>
      </view>
    </view>

    <!-- 底部提交 -->
    <view class="bottom-bar">
      <view
        class="submit-btn"
        :class="{ 'btn-disabled': commentStore.postLoading || formData.score === 0 }"
        @click="handleSubmit"
      >
        <text class="submit-text">
          {{ commentStore.postLoading ? '提交中...' : '发布评价' }}
        </text>
      </view>
    </view>
  </view>
</template>

<script setup>
import { reactive } from 'vue'
import { onLoad } from '@dcloudio/uni-app'
import { useComment } from '@/hooks/useComment'
import { getValidImageUrl } from '@/utils/common'

const statusBarHeight = uni.getSystemInfoSync().statusBarHeight || 20

const {
  commentStore,
  formData,
  imagePreviews,
  submitComment,
  addCommentImage,
  removeCommentImage,
  previewCommentImage,
  resetForm,
  getScoreText,
  ANONYMOUS
} = useComment()

// 商品信息（从路由参数获取）
const productInfo = reactive({
  name: '',
  image: '',
  skuSpecs: '',
  finalPrice: 0
})

const handleBack = () => {
  uni.navigateBack({
    delta: 1,
    animationType: 'slide-out-right',
    animationDuration: 200
  })
}

// 切换匿名
const toggleAnonymous = () => {
  formData.value.anonymous = formData.value.anonymous === ANONYMOUS.YES ? ANONYMOUS.NO : ANONYMOUS.YES
}

// 提交评价
const handleSubmit = async () => {
  if (commentStore.postLoading) return
  if (formData.value.score === 0) {
    uni.showToast({ title: '请选择评分', icon: 'none' })
    return
  }
  const success = await submitComment()
  if (success) {
    setTimeout(() => {
      uni.navigateBack()
    }, 1500)
  }
}

// 解析 skuSpecs JSON 为可读格式
const parseSkuSpecs = (specsStr) => {
  if (!specsStr) return ''
  try {
    const specs = JSON.parse(specsStr)
    return Object.entries(specs).map(([key, value]) => `${key} / ${value}`).join(' ')
  } catch {
    return specsStr
  }
}

// 从 storage 读取参数（兼容 URL 参数作为 fallback）
const loadParams = (options) => {
  let params = null

  try {
    const stored = uni.getStorageSync('tempCommentParams')
    if (stored) {
      params = JSON.parse(stored)
      uni.removeStorageSync('tempCommentParams')
    }
  } catch (e) {
    console.error('读取评价参数失败:', e)
  }

  // 如果 storage 没有，尝试从 URL 参数读取（兼容其他入口）
  if (!params) {
    const opts = options || {}
    params = {
      orderId: opts.orderId ? Number(opts.orderId) : null,
      orderItemId: opts.orderItemId ? Number(opts.orderItemId) : null,
      productId: opts.productId ? Number(opts.productId) : null,
      skuId: opts.skuId ? Number(opts.skuId) : null,
      productName: opts.productName || '',
      productImage: opts.productImage || '',
      skuSpecs: opts.skuSpecs || '',
      finalPrice: opts.finalPrice ? Number(opts.finalPrice) : 0
    }
  }

  // 统一转换为 Number 类型（后端要求 Long 数字类型）
  params.orderId = params.orderId != null ? Number(params.orderId) : null
  params.orderItemId = params.orderItemId != null ? Number(params.orderItemId) : null
  params.productId = params.productId != null ? Number(params.productId) : null
  params.skuId = params.skuId ? Number(params.skuId) : null
  params.finalPrice = params.finalPrice ? Number(params.finalPrice) : 0

  console.log('postComment params:', params)

  // 设置表单数据（确保数字类型）
  formData.value.orderId = params.orderId
  formData.value.orderItemId = params.orderItemId
  formData.value.productId = params.productId
  formData.value.skuId = params.skuId

  // 设置商品展示信息
  productInfo.name = params.productName || ''
  productInfo.skuSpecs = parseSkuSpecs(params.skuSpecs || '')
  productInfo.finalPrice = params.finalPrice || 0
  productInfo.image = params.productImage ? getValidImageUrl(params.productImage) : ''

  // 参数校验：orderId、orderItemId、productId 均为必填
  if (!params.orderId || !params.orderItemId || !params.productId) {
    console.error('评价参数缺失:', { orderId: params.orderId, orderItemId: params.orderItemId, productId: params.productId })
    uni.showToast({ title: '参数缺失，请返回重试', icon: 'none' })
    setTimeout(() => uni.navigateBack(), 1500)
    return false
  }

  return true
}

// 使用 onLoad（uni-app 页面生命周期，H5 和 APP 均可靠触发）
onLoad((options) => {
  loadParams(options)
})
</script>

<style lang="scss" scoped>
.page-post {
  min-height: 100vh;
  background: #FFFFFF;
  padding-bottom: 160rpx;
}

// ============ 导航栏 ============
.nav-bar {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  height: 88rpx;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 24rpx;
  background: #FFFFFF;
  border-bottom: 1rpx solid #EEEEEE;
  z-index: 100;

  .nav-back {
    width: 64rpx;
    height: 64rpx;
    display: flex;
    align-items: center;
    justify-content: center;

    .back-icon {
      font-size: 48rpx;
      color: #333333;
      line-height: 1;
    }
  }

  .nav-title {
    font-size: 32rpx;
    font-weight: 500;
    color: #333333;
  }

  .nav-placeholder-right {
    width: 64rpx;
  }
}

.nav-placeholder {
  width: 100%;
}

// ============ 通用 section ============
.section {
  padding: 24rpx;
  border-bottom: 1rpx solid #F5F5F5;

  .section-label {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-bottom: 20rpx;

    .label-text {
      font-size: 28rpx;
      color: #333333;
      font-weight: 500;
    }

    .char-count,
    .image-count {
      font-size: 24rpx;
      color: #999999;
    }
  }
}

// ============ 商品信息 + 评分 ============
.product-section {
  .product-row {
    display: flex;
    align-items: center;

    .product-thumb {
      width: 120rpx;
      height: 120rpx;
      border-radius: 8rpx;
      flex-shrink: 0;
      background: #F5F5F5;
    }

    .product-info {
      flex: 1;
      margin-left: 20rpx;
      overflow: hidden;

      .product-name {
        font-size: 28rpx;
        color: #333333;
        line-height: 1.4;
        display: -webkit-box;
        -webkit-line-clamp: 2;
        -webkit-box-orient: vertical;
        overflow: hidden;
      }

      .product-spec {
        font-size: 24rpx;
        color: #999999;
        margin-top: 8rpx;
      }
    }
  }

  .score-row {
    display: flex;
    align-items: center;
    padding: 20rpx 0 4rpx;
    margin-top: 16rpx;
    border-top: 1rpx solid #F5F5F5;

    .star-item {
      padding: 8rpx;

      .star-icon {
        font-size: 48rpx;
        color: #DDDDDD;
        transition: color 200ms ease;
      }

      .star-active {
        color: #FF9500;
      }
    }

    .score-text {
      font-size: 26rpx;
      color: #999999;
      margin-left: 16rpx;
    }
  }
}

// ============ 评价内容 ============
.content-textarea {
  width: 100%;
  min-height: 200rpx;
  padding: 20rpx;
  font-size: 28rpx;
  color: #333333;
  background: #F9F9F9;
  border-radius: 6rpx;
  box-sizing: border-box;
  line-height: 1.6;
}

.textarea-placeholder {
  color: #999999;
  font-size: 28rpx;
}

// ============ 图片上传 ============
.image-grid {
  display: flex;
  flex-wrap: wrap;
  gap: 16rpx;
}

.image-item {
  position: relative;
  width: 180rpx;
  height: 180rpx;
  border-radius: 6rpx;
  overflow: hidden;

  .preview-img {
    width: 100%;
    height: 100%;
  }

  .image-delete {
    position: absolute;
    top: 0;
    right: 0;
    width: 40rpx;
    height: 40rpx;
    background: rgba(0, 0, 0, 0.5);
    border-radius: 0 6rpx 0 6rpx;
    display: flex;
    align-items: center;
    justify-content: center;

    .delete-icon {
      font-size: 24rpx;
      color: #FFFFFF;
    }
  }
}

.image-add {
  width: 180rpx;
  height: 180rpx;
  background: #F9F9F9;
  border: 1rpx dashed #CCCCCC;
  border-radius: 6rpx;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;

  .add-icon {
    font-size: 48rpx;
    color: #CCCCCC;
    line-height: 1;
  }

  .add-text {
    font-size: 22rpx;
    color: #999999;
    margin-top: 8rpx;
  }
}

// ============ 小贴士 ============
.tip-section {
  padding: 16rpx 24rpx;
  background: #FFFBE6;
  border-bottom: 1rpx solid #F5F5F5;

  .tip-text {
    font-size: 24rpx;
    color: #999999;
    line-height: 1.5;
  }
}

// ============ 匿名评价 ============
.section-anonymous {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 0;

  .label-text {
    font-size: 28rpx;
    color: #333333;
  }

  .radio-wrap {
    padding: 8rpx;
  }

  .radio {
    width: 36rpx;
    height: 36rpx;
    border: 1rpx solid #CCCCCC;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: all 200ms ease;

    &.radio-checked {
      border-color: #FF9500;
      background: #FF9500;
    }

    .radio-dot {
      width: 16rpx;
      height: 16rpx;
      background: #FFFFFF;
      border-radius: 50%;
    }
  }
}

// ============ 底部提交 ============
.bottom-bar {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  padding: 16rpx 24rpx;
  padding-bottom: calc(16rpx + env(safe-area-inset-bottom));
  background: #FFFFFF;
  border-top: 1rpx solid #EEEEEE;
  z-index: 100;

  .submit-btn {
    height: 88rpx;
    background: #FF9500;
    border-radius: 6rpx;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: opacity 200ms ease;

    &:active {
      opacity: 0.8;
    }

    &.btn-disabled {
      background: #CCCCCC;
      pointer-events: none;
    }

    .submit-text {
      font-size: 30rpx;
      color: #FFFFFF;
      font-weight: 500;
    }
  }
}
</style>
