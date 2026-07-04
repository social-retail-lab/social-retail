<template>
  <view class="page-container">
    <!-- 1. 顶部固定导航栏 -->
    <view class="order-header">
      <view class="header-left" @click="handleBack">
        <text class="back-icon">‹</text>
      </view>
      <text class="header-title">售后详情</text>
      <view class="header-right"></view>
    </view>

    <scroll-view
      scroll-y
      class="page-content"
      :refresher-enabled="true"
      :refresher-triggered="refreshing"
      @refresherrefresh="onRefresh"
    >
      <view v-if="detail" class="detail-wrap">
        <!-- 2. 顶部售后状态大标题区 -->
        <view class="status-banner" :class="getStatusClass(detail.status)">
          <text class="status-text">{{ detail.statusText || '售后详情' }}</text>
          <view class="status-meta">
            <text class="meta-row">售后编号：{{ detail.afterSaleSn || '-' }}</text>
            <text class="meta-row">申请时间：{{ detail.applyTime || '-' }}</text>
            <text v-if="detail.handleTime" class="meta-row">处理时间：{{ detail.handleTime }}</text>
          </view>
          <view v-if="detail.auditRemark" class="audit-remark">
            <text class="remark-label">审核驳回理由</text>
            <text class="remark-text">{{ detail.auditRemark }}</text>
          </view>
        </view>

        <!-- 3. 售后商品信息卡片 -->
        <view class="card-container">
          <view class="card-header">
            <text class="card-title">售后商品</text>
          </view>
          <view class="goods-item">
            <image :src="getValidImageUrl(detail.productImage)" class="goods-image" mode="aspectFill" />
            <view class="goods-content">
              <text class="goods-name">{{ detail.productName }}</text>
              <text v-if="detail.skuSpecs" class="goods-spec">{{ detail.skuSpecs }}</text>
              <view class="goods-tag-row">
                <view class="goods-tag">
                  <text>{{ detail.typeText }}</text>
                </view>
              </view>
              <view class="goods-price-row">
                <text class="price-label">退款金额</text>
                <text class="price-value">¥{{ formatPrice(detail.refundAmount) }}</text>
              </view>
            </view>
          </view>
        </view>

        <!-- 4. 售后申请信息模块 -->
        <view class="card-container">
          <view class="card-header">
            <text class="card-title">申请信息</text>
          </view>
          <view class="info-list">
            <view class="info-row">
              <text class="info-label">申请原因</text>
              <text class="info-value">{{ detail.reason || '-' }}</text>
            </view>
            <view v-if="detail.reasonDesc" class="info-row info-row-column">
              <text class="info-label">补充说明</text>
              <text class="info-desc">{{ detail.reasonDesc }}</text>
            </view>
            <view
              v-if="detail.evidenceImages && detail.evidenceImages.length"
              class="info-row info-row-column"
            >
              <text class="info-label">举证凭证</text>
              <view class="image-grid">
                <view
                  v-for="(img, index) in detail.evidenceImages"
                  :key="index"
                  class="image-cell"
                  @click="previewImage(index)"
                >
                  <image :src="getValidImageUrl(img)" class="grid-image" mode="aspectFill" />
                </view>
              </view>
            </view>
          </view>
        </view>

        <view class="bottom-space"></view>
      </view>

      <!-- 加载占位 -->
      <view v-else-if="loading" class="loading-wrap">
        <text class="loading-text">加载中...</text>
      </view>
    </scroll-view>

    <!-- 5. 底部动态操作按钮 -->
    <view v-if="detail && (canCancel || canSupplyEvidence)" class="bottom-bar">
      <view v-if="canSupplyEvidence" class="action-btn primary" @click="handleSupplyEvidence">
        <text>补充凭证</text>
      </view>
      <view v-if="canCancel" class="action-btn" @click="handleCancel">
        <text>取消售后</text>
      </view>
    </view>
  </view>
</template>

<script setup>
import { ref, computed } from 'vue'
import { onShow } from '@dcloudio/uni-app'
import { useAfterSale } from '@/hooks/useAfterSale'
import { uploadFileApi } from '@/api/afterSale'
import { getValidImageUrl, formatPrice } from '@/utils/common'
import {
  AFTER_SALE_STATUS,
  getAfterSaleStatusClass,
  isAfterSaleCancellable
} from '@/constants/afterSale'

const {
  afterSaleStore,
  loading,
  refreshing,
  uploading,
  loadAfterSaleDetail,
  confirmCancelAfterSale,
  supplementEvidence
} = useAfterSale()

const afterSaleId = ref('')

// 详情数据(从 store 获取)
const detail = computed(() => afterSaleStore.afterSaleDetail)

// 是否可取消售后
const canCancel = computed(() => detail.value && isAfterSaleCancellable(detail.value.status))

// 是否可补充凭证(申请中状态)
const canSupplyEvidence = computed(() => detail.value && detail.value.status === AFTER_SALE_STATUS.APPLYING)

const handleBack = () => {
  uni.navigateBack()
}

// 状态对应样式类(使用常量)
const getStatusClass = (status) => getAfterSaleStatusClass(status)

// 拉取售后详情(通过 Hook)
const fetchDetailData = async () => {
  if (!afterSaleId.value) {
    const pages = getCurrentPages()
    const currentPage = pages[pages.length - 1]
    afterSaleId.value = currentPage.options?.afterSaleId || currentPage.options?.id || ''
  }

  if (!afterSaleId.value) {
    return
  }

  await loadAfterSaleDetail(afterSaleId.value)
  refreshing.value = false
}

// 下拉刷新
const onRefresh = () => {
  refreshing.value = true
  fetchDetailData()
}

// 凭证图片全屏预览
const previewImage = (index) => {
  const urls = (detail.value?.evidenceImages || []).map(url => getValidImageUrl(url))
  uni.previewImage({
    current: urls[index],
    urls
  })
}

// 补充凭证：选图 -> 上传 -> 调用 Hook 上传 -> 刷新
const handleSupplyEvidence = () => {
  if (uploading.value) return
  uni.chooseImage({
    count: 9,
    sizeType: ['compressed'],
    sourceType: ['album', 'camera'],
    success: async (chooseRes) => {
      const filePaths = chooseRes.tempFilePaths || []
      if (!filePaths.length) return

      try {
        // 1. 先上传图片文件
        const uploadedUrls = []
        for (const filePath of filePaths) {
          const url = await uploadFileApi(filePath)
          uploadedUrls.push(url)
        }
        // 2. 调用 Hook 保存凭证关联关系
        const success = await supplementEvidence(afterSaleId.value, uploadedUrls)
        if (success) {
          // 3. 刷新详情
          fetchDetailData()
        }
      } catch (error) {
        // 错误已在 Hook 中处理
      }
    }
  })
}

// 取消售后(通过 Hook 弹窗确认)
const handleCancel = async () => {
  const success = await confirmCancelAfterSale(afterSaleId.value)
  if (success) {
    fetchDetailData()
  }
}

onShow(() => {
  fetchDetailData()
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

.detail-wrap {
  padding-bottom: env(safe-area-inset-bottom);
}

// 状态大标题区
.status-banner {
  padding: 48rpx 32rpx;
  background: $bg-card;
  margin-bottom: 24rpx;

  &.status-applying {
    .status-text {
      color: $color-primary;
    }
  }

  &.status-cancelled {
    .status-text {
      color: $text-weak;
    }
  }

  &.status-refunded {
    .status-text {
      color: $color-success;
    }
  }

  .status-text {
    display: block;
    font-size: 52rpx;
    font-weight: 700;
    margin-bottom: 24rpx;
  }

  .status-meta {
    display: flex;
    flex-direction: column;
    gap: 12rpx;

    .meta-row {
      font-size: 26rpx;
      color: $text-sub;
    }
  }

  .audit-remark {
    margin-top: 24rpx;
    padding: 20rpx 24rpx;
    background: rgba($color-primary-danger, 0.06);
    border-radius: 12rpx;
    border-left: 6rpx solid $color-primary-danger;

    .remark-label {
      font-size: 26rpx;
      color: $color-primary-danger;
      font-weight: 500;
      display: block;
      margin-bottom: 8rpx;
    }

    .remark-text {
      font-size: 26rpx;
      color: $color-primary-danger;
      line-height: 1.5;
      display: block;
    }
  }
}

// 卡片通用
.card-container {
  background: $bg-card;
  margin: 0 24rpx 24rpx;
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

// 商品信息
.goods-item {
  display: flex;
  padding: 24rpx 32rpx;

  .goods-image {
    width: 180rpx;
    height: 180rpx;
    border-radius: 16rpx;
    margin-right: 20rpx;
    background: $bg-page-light;
    flex-shrink: 0;
  }

  .goods-content {
    flex: 1;
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
    }

    .goods-spec {
      font-size: 24rpx;
      color: $text-weak;
      margin-top: 8rpx;
    }

    .goods-tag-row {
      margin-top: 12rpx;

      .goods-tag {
        display: inline-block;
        padding: 4rpx 16rpx;
        background: rgba($color-primary, 0.1);
        border-radius: 8rpx;

        text {
          font-size: 22rpx;
          color: $color-primary;
        }
      }
    }

    .goods-price-row {
      margin-top: 16rpx;
      display: flex;
      align-items: baseline;
      justify-content: space-between;

      .price-label {
        font-size: 26rpx;
        color: $text-sub;
      }

      .price-value {
        font-size: 34rpx;
        color: $color-primary-danger;
        font-weight: 600;
      }
    }
  }
}

// 申请信息
.info-list {
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

  &.info-row-column {
    flex-direction: column;
    align-items: flex-start;

    .info-label {
      margin-bottom: 16rpx;
    }
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

  .info-desc {
    font-size: 28rpx;
    color: $text-main;
    line-height: 1.5;
    width: 100%;
  }
}

// 凭证图片网格 3 列
.image-grid {
  display: flex;
  flex-wrap: wrap;

  .image-cell {
    width: 32%;
    margin-right: 2%;
    margin-bottom: 16rpx;
    border-radius: 12rpx;
    overflow: hidden;
    background: $bg-page-light;

    &:nth-child(3n) {
      margin-right: 0;
    }

    .grid-image {
      width: 100%;
      height: 200rpx;
      display: block;
    }
  }
}

// 加载占位
.loading-wrap {
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 200rpx 0;

  .loading-text {
    font-size: 28rpx;
    color: $text-weak;
  }
}

// 底部留白
.bottom-space {
  height: calc(140rpx + env(safe-area-inset-bottom));
}

// 底部动态操作按钮
.bottom-bar {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  display: flex;
  align-items: center;
  gap: 24rpx;
  padding: 20rpx 32rpx;
  padding-bottom: calc(20rpx + env(safe-area-inset-bottom));
  background: $bg-card;
  box-shadow: 0 -4rpx 16rpx rgba(0, 0, 0, 0.05);
  z-index: 99;

  .action-btn {
    flex: 1;
    padding: 24rpx 0;
    border-radius: 40rpx;
    text-align: center;
    background: $bg-page-light;
    border: 1rpx solid $gray-300;

    text {
      font-size: 30rpx;
      color: $text-sub;
    }

    &.primary {
      background: linear-gradient(135deg, $color-primary 0%, $color-primary-danger 100%);
      border-color: transparent;

      text {
        color: #FFFFFF;
        font-weight: 500;
      }
    }

    &:active {
      transform: scale(0.97);
    }
  }
}
</style>
