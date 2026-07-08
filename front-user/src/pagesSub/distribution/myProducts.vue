<template>
  <view class="page-my-products">
    <!-- 自定义导航栏 -->
    <view class="nav-bar" :style="{ paddingTop: statusBarHeight + 'px' }">
      <view class="nav-back" @click="handleBack">
        <text class="back-icon">‹</text>
      </view>
      <text class="nav-title">我的推广</text>
      <view class="nav-placeholder-right"></view>
    </view>
    <view class="nav-placeholder" :style="{ height: (statusBarHeight + 44) + 'px' }"></view>

    <!-- 搜索栏 -->
    <view class="search-bar">
      <view class="search-input-wrap">
        <image class="search-icon" src="/static/fonts/search.svg" mode="aspectFit" />
        <input
          class="search-input"
          v-model="keyword"
          placeholder="搜索商品名称"
          placeholder-class="placeholder"
          confirm-type="search"
          @confirm="handleSearch"
        />
        <view v-if="keyword" class="search-clear" @click="clearKeyword">
          <text class="clear-icon">✕</text>
        </view>
      </view>
    </view>

    <!-- 状态筛选 Tab -->
    <view class="status-tabs">
      <view
        v-for="tab in statusTabs"
        :key="tab.value"
        class="tab-item"
        :class="{ 'tab-active': currentStatus === tab.value }"
        @click="handleTabChange(tab.value)"
      >
        <text class="tab-text">{{ tab.label }}</text>
      </view>
    </view>

    <!-- 推广商品列表 -->
    <scroll-view
      scroll-y
      class="product-scroll"
      :refresher-enabled="true"
      :refresher-triggered="refreshing"
      @refresherrefresh="onRefresh"
      @scrolltolower="onLoadMore"
    >
      <!-- 加载中（首次） -->
      <view v-if="distributorStore.myPromotionProductsLoading && productList.length === 0" class="loading-state">
        <view class="loading-spinner"></view>
        <text class="loading-text">加载中...</text>
      </view>

      <!-- 空状态 -->
      <view v-else-if="productList.length === 0" class="empty-state">
        <text class="empty-icon">📋</text>
        <text class="empty-title">{{ emptyTitle }}</text>
        <text class="empty-desc">{{ emptyDesc }}</text>
        <view class="empty-btn" @click="goToPromotionProducts">
          <text class="empty-btn-text">去推广商品</text>
        </view>
      </view>

      <!-- 商品列表 -->
      <view v-else class="product-list">
        <view
          v-for="item in productList"
          :key="item.distributorProductId"
          class="product-card"
          :class="{ 'card-disabled': item.status === PROMOTION_STATUS.DISABLED }"
        >
          <!-- 商品主体（点击进入详情） -->
          <view class="card-main" @click="handleViewDetail(item)">
            <!-- 商品图片 -->
            <view class="product-image-wrap">
              <image
                :src="item.mainImage"
                mode="aspectFill"
                class="product-image"
                lazy-load
              />
              <view
                v-if="item.status === PROMOTION_STATUS.DISABLED"
                class="image-mask"
              >
                <text class="mask-text">已停用</text>
              </view>
            </view>

            <!-- 商品信息 -->
            <view class="product-info">
              <view class="info-top">
                <text class="product-name">{{ item.productName }}</text>
              </view>
              <view class="info-mid">
                <text class="product-price">¥{{ formatMoney(item.price) }}</text>
                <view class="commission-tag">
                  <text class="commission-text">佣金 {{ item.commissionRate }}%</text>
                </view>
              </view>
              <view class="info-bottom">
                <view
                  class="status-tag"
                  :style="getStatusStyle(item.status)"
                >
                  <text class="status-text">{{ getStatusLabel(item.status) }}</text>
                </view>
                <view v-if="item.promotionCode" class="code-tag">
                  <text class="code-label">推广码:</text>
                  <text class="code-text">{{ item.promotionCode }}</text>
                </view>
              </view>
            </view>
          </view>

          <!-- 操作按钮组 -->
          <view class="action-row">
            <view class="action-btn btn-detail" @click="handleViewDetail(item)">
              <text class="btn-text">查看详情</text>
            </view>
            <view class="action-btn btn-share" @click="handleShare(item)">
              <text class="btn-text">分享</text>
            </view>
            <view
              v-if="item.status === PROMOTION_STATUS.ENABLED"
              class="action-btn btn-disable"
              :class="{ 'btn-loading': togglingId === item.distributorProductId }"
              @click="handleDisable(item)"
            >
              <text class="btn-text">
                {{ togglingId === item.distributorProductId ? '处理中...' : '取消推广' }}
              </text>
            </view>
            <view
              v-else
              class="action-btn btn-enable"
              :class="{ 'btn-loading': togglingId === item.distributorProductId }"
              @click="handleEnable(item)"
            >
              <text class="btn-text">
                {{ togglingId === item.distributorProductId ? '处理中...' : '恢复推广' }}
              </text>
            </view>
          </view>
        </view>

        <!-- 加载更多 -->
        <view v-if="productList.length > 0" class="load-more">
          <text v-if="distributorStore.myPromotionProductsLoading" class="load-more-text">加载中...</text>
          <text v-else-if="hasMore" class="load-more-text">上拉加载更多</text>
          <text v-else class="load-more-text">没有更多了</text>
        </view>
      </view>

      <view class="safe-bottom"></view>
    </scroll-view>

    <!-- 分享弹窗 -->
    <SharePromotionPopup
      :visible="sharePopupVisible"
      :product-info="currentShareProduct"
      :distributor-product-id="currentShareId"
      @close="closeSharePopup"
    />
  </view>
</template>

<script setup>
import { ref, computed } from 'vue'
import { onShow, onUnload } from '@dcloudio/uni-app'
import { useDistributor } from '@/hooks/useDistributor'
import SharePromotionPopup from '@/components/business/SharePromotionPopup.vue'

const statusBarHeight = uni.getSystemInfoSync().statusBarHeight || 20

const {
  distributorStore,
  loadMyPromotionProducts,
  searchMyPromotionProducts,
  switchMyPromotionStatus,
  disablePromotionProduct,
  enablePromotionProduct,
  goPromotionDetail,
  PROMOTION_STATUS,
  PROMOTION_STATUS_TABS,
  PROMOTION_STATUS_MAP
} = useDistributor()

// 本地状态
const keyword = ref('')
const refreshing = ref(false)
const togglingId = ref(null) // 当前正在切换状态的 distributorProductId
const currentStatus = ref('') // '' 全部 / 0 停用 / 1 启用

// 分享弹窗状态
const sharePopupVisible = ref(false)
const currentShareProduct = ref(null)
const currentShareId = ref(null)

// 状态筛选 Tab
const statusTabs = PROMOTION_STATUS_TABS

// 商品列表
const productList = computed(() => distributorStore.myPromotionProducts)
const hasMore = computed(() => distributorStore.myPromotionProductsPage < distributorStore.myPromotionProductsPages)

// 空状态文案
const emptyTitle = computed(() => {
  if (currentStatus.value === PROMOTION_STATUS.ENABLED) return '暂无推广中的商品'
  if (currentStatus.value === PROMOTION_STATUS.DISABLED) return '暂无已停用的商品'
  return '暂无推广商品'
})

const emptyDesc = computed(() => {
  if (currentStatus.value === PROMOTION_STATUS.ENABLED) return '去可推广商品列表开启你的推广之旅'
  if (currentStatus.value === PROMOTION_STATUS.DISABLED) return '已停用的推广商品将显示在这里'
  return '从可推广商品列表中申请推广吧'
})

// 工具方法
const formatMoney = (value) => {
  return (Number(value) || 0).toFixed(2)
}

const getStatusLabel = (status) => {
  return PROMOTION_STATUS_MAP[status]?.label || '未知'
}

const getStatusStyle = (status) => {
  const info = PROMOTION_STATUS_MAP[status]
  if (!info) return {}
  return {
    color: info.color,
    backgroundColor: info.bgColor
  }
}

// 事件处理
const handleBack = () => {
  uni.navigateBack({
    delta: 1,
    animationType: 'slide-out-right',
    animationDuration: 200
  })
}

const handleSearch = () => {
  searchMyPromotionProducts(keyword.value)
}

const clearKeyword = () => {
  keyword.value = ''
  searchMyPromotionProducts('')
}

const handleTabChange = (status) => {
  if (currentStatus.value === status) return
  currentStatus.value = status
  switchMyPromotionStatus(status)
}

const onRefresh = async () => {
  refreshing.value = true
  await loadMyPromotionProducts(false)
  refreshing.value = false
}

const onLoadMore = () => {
  if (distributorStore.myPromotionProductsLoading || !hasMore.value) return
  loadMyPromotionProducts(true)
}

// 查看详情
const handleViewDetail = (item) => {
  goPromotionDetail(item.distributorProductId)
}

// 分享
const handleShare = (item) => {
  if (item.status === PROMOTION_STATUS.DISABLED) {
    uni.showToast({ title: '已停用的商品无法分享', icon: 'none' })
    return
  }
  currentShareProduct.value = {
    productName: item.productName,
    mainImage: item.mainImage,
    price: item.price,
    subTitle: item.subTitle || ''
  }
  currentShareId.value = item.distributorProductId
  sharePopupVisible.value = true
}

const closeSharePopup = () => {
  sharePopupVisible.value = false
}

// 取消推广（弹窗二次确认 + 调用 hook）
const handleDisable = async (item) => {
  if (togglingId.value) return
  togglingId.value = item.distributorProductId
  await disablePromotionProduct(item)
  togglingId.value = null
}

// 恢复推广
const handleEnable = async (item) => {
  if (togglingId.value) return
  togglingId.value = item.distributorProductId
  await enablePromotionProduct(item)
  togglingId.value = null
}

// 跳转到可推广商品页
const goToPromotionProducts = () => {
  uni.navigateTo({ url: '/pagesSub/distribution/products' })
}

onShow(() => {
  if (productList.value.length === 0) {
    loadMyPromotionProducts(false)
  }
})

onUnload(() => {
  distributorStore.resetPromotionData()
})
</script>

<style lang="scss" scoped>
.page-my-products {
  min-height: 100vh;
  background: $bg-page;
  display: flex;
  flex-direction: column;
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
  z-index: 999;
  background: rgba(255, 255, 255, 0.92);
  backdrop-filter: blur(40rpx) saturate(180%);
  -webkit-backdrop-filter: blur(40rpx) saturate(180%);
  border-bottom: 2rpx solid rgba(255, 255, 255, 0.6);
  box-shadow: $shadow-sm;

  .nav-back {
    width: 64rpx;
    height: 64rpx;
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: 50%;

    &:active {
      transform: scale(0.92);
      background: $neutral-100;
    }

    .back-icon {
      font-size: 56rpx;
      color: $ink-900;
      line-height: 1;
      font-weight: 300;
    }
  }

  .nav-title {
    font-size: 34rpx;
    font-weight: 600;
    color: $ink-900;
  }

  .nav-placeholder-right {
    width: 64rpx;
  }
}

.nav-placeholder {
  width: 100%;
  flex-shrink: 0;
}

// ============ 搜索栏 ============
.search-bar {
  padding: 16rpx 24rpx;
  background: $bg-card;
  box-shadow: $shadow-xs;
}

.search-input-wrap {
  display: flex;
  align-items: center;
  height: 72rpx;
  padding: 0 24rpx;
  background: $bg-page-light;
  border-radius: 36rpx;

  .search-icon {
    width: 32rpx;
    height: 32rpx;
    margin-right: 12rpx;
    opacity: 0.6;
  }

  .search-input {
    flex: 1;
    font-size: 28rpx;
    color: $ink-900;
  }

  .placeholder {
    color: $text-weak;
  }

  .search-clear {
    width: 36rpx;
    height: 36rpx;
    display: flex;
    align-items: center;
    justify-content: center;
    background: $neutral-300;
    border-radius: 50%;
    margin-left: 12rpx;

    .clear-icon {
      font-size: 20rpx;
      color: #FFFFFF;
    }
  }
}

// ============ 状态筛选 Tab ============
.status-tabs {
  display: flex;
  align-items: center;
  padding: 16rpx 24rpx;
  background: $bg-card;
  gap: 16rpx;
  box-shadow: $shadow-xs;
}

.tab-item {
  flex: 1;
  height: 64rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 32rpx;
  background: $bg-page-light;
  transition: all 0.25s ease;

  .tab-text {
    font-size: 26rpx;
    color: $text-sub;
    font-weight: 500;
  }

  &.tab-active {
    background: linear-gradient(135deg, $color-primary 0%, $color-primary-danger 100%);
    box-shadow: 0 6rpx 12rpx rgba(255, 106, 0, 0.25);

    .tab-text {
      color: #FFFFFF;
    }
  }

  &:active {
    transform: scale(0.96);
  }
}

// ============ 商品列表 ============
.product-scroll {
  flex: 1;
  height: 0;
}

.product-list {
  padding: 16rpx 24rpx 24rpx;
}

.product-card {
  background: $bg-card;
  border-radius: 20rpx;
  padding: 20rpx;
  margin-bottom: 16rpx;
  box-shadow: $shadow-sm;
  transition: all 0.2s ease;

  &.card-disabled {
    opacity: 0.85;
  }
}

.card-main {
  display: flex;
}

.product-image-wrap {
  width: 180rpx;
  height: 180rpx;
  border-radius: 16rpx;
  overflow: hidden;
  background: $bg-page-light;
  flex-shrink: 0;
  margin-right: 20rpx;
  position: relative;

  .product-image {
    width: 100%;
    height: 100%;
  }

  .image-mask {
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: rgba(0, 0, 0, 0.45);
    display: flex;
    align-items: center;
    justify-content: center;

    .mask-text {
      color: #FFFFFF;
      font-size: 24rpx;
      font-weight: 500;
      padding: 6rpx 16rpx;
      border: 2rpx solid rgba(255, 255, 255, 0.6);
      border-radius: 8rpx;
    }
  }
}

.product-info {
  flex: 1;
  display: flex;
  flex-direction: column;
  min-width: 0;

  .info-top {
    margin-bottom: 12rpx;

    .product-name {
      font-size: 28rpx;
      color: $text-main;
      font-weight: 500;
      line-height: 1.4;
      overflow: hidden;
      text-overflow: ellipsis;
      display: -webkit-box;
      -webkit-line-clamp: 2;
      -webkit-box-orient: vertical;
    }
  }

  .info-mid {
    display: flex;
    align-items: center;
    margin-bottom: 12rpx;

    .product-price {
      font-size: 30rpx;
      color: $color-primary-danger;
      font-weight: 600;
      margin-right: 16rpx;
    }

    .commission-tag {
      padding: 4rpx 12rpx;
      background: linear-gradient(135deg, rgba(255, 106, 0, 0.1) 0%, rgba(255, 77, 79, 0.1) 100%);
      border-radius: 8rpx;

      .commission-text {
        font-size: 22rpx;
        color: $color-primary;
        font-weight: 600;
      }
    }
  }

  .info-bottom {
    display: flex;
    align-items: center;
    gap: 12rpx;

    .status-tag {
      padding: 4rpx 12rpx;
      border-radius: 8rpx;

      .status-text {
        font-size: 22rpx;
        font-weight: 500;
      }
    }

    .code-tag {
      flex: 1;
      display: flex;
      align-items: center;
      min-width: 0;

      .code-label {
        font-size: 22rpx;
        color: $text-weak;
        margin-right: 6rpx;
      }

      .code-text {
        font-size: 22rpx;
        color: $text-sub;
        font-weight: 500;
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
      }
    }
  }
}

// ============ 操作按钮组 ============
.action-row {
  display: flex;
  align-items: center;
  gap: 12rpx;
  margin-top: 20rpx;
  padding-top: 20rpx;
  border-top: 2rpx solid $bg-page-light;
}

.action-btn {
  flex: 1;
  height: 64rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 32rpx;
  transition: all 0.2s ease;

  &:active {
    transform: scale(0.96);
  }

  &.btn-loading {
    opacity: 0.6;
    pointer-events: none;
  }

  .btn-text {
    font-size: 24rpx;
    font-weight: 500;
  }
}

.btn-detail {
  background: $bg-page-light;

  .btn-text {
    color: $text-main;
  }
}

.btn-share {
  background: rgba(24, 144, 255, 0.1);

  .btn-text {
    color: #1890FF;
  }
}

.btn-disable {
  background: rgba(255, 77, 79, 0.1);

  .btn-text {
    color: #FF4D4F;
  }
}

.btn-enable {
  background: linear-gradient(135deg, $color-primary 0%, $color-primary-danger 100%);
  box-shadow: 0 4rpx 10rpx rgba(255, 106, 0, 0.25);

  .btn-text {
    color: #FFFFFF;
  }
}

// ============ 加载/空状态 ============
.loading-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding-top: 160rpx;
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

.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding-top: 180rpx;

  .empty-icon {
    font-size: 120rpx;
    opacity: 0.5;
    margin-bottom: 32rpx;
  }

  .empty-title {
    font-size: 32rpx;
    color: $text-main;
    font-weight: 500;
    margin-bottom: 12rpx;
  }

  .empty-desc {
    font-size: 24rpx;
    color: $text-weak;
    margin-bottom: 40rpx;
  }

  .empty-btn {
    padding: 18rpx 56rpx;
    background: linear-gradient(135deg, $color-primary 0%, $color-primary-danger 100%);
    border-radius: 40rpx;
    box-shadow: 0 8rpx 16rpx rgba(255, 106, 0, 0.25);

    &:active {
      transform: scale(0.96);
    }

    .empty-btn-text {
      color: #FFFFFF;
      font-size: 28rpx;
      font-weight: 500;
    }
  }
}

.load-more {
  padding: 32rpx 0;

  .load-more-text {
    font-size: 24rpx;
    color: $text-weak;
    text-align: center;
    display: block;
  }
}

.safe-bottom {
  height: env(safe-area-inset-bottom);
  padding-bottom: 32rpx;
}
</style>
