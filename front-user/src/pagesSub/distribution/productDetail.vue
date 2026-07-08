<template>
  <view class="page-detail">
    <!-- 自定义导航栏 -->
    <view class="nav-bar" :style="{ paddingTop: statusBarHeight + 'px' }">
      <view class="nav-back" @click="handleBack">
        <text class="back-icon">‹</text>
      </view>
      <text class="nav-title">推广详情</text>
      <view class="nav-placeholder-right"></view>
    </view>
    <view class="nav-placeholder" :style="{ height: (statusBarHeight + 44) + 'px' }"></view>

    <!-- 加载中 -->
    <view v-if="loading && !detail" class="loading-state">
      <view class="loading-spinner"></view>
      <text class="loading-text">加载中...</text>
    </view>

    <!-- 内容区 -->
    <scroll-view v-else-if="detail" scroll-y class="content-scroll">
      <!-- 顶部商品信息卡片 -->
      <view class="product-card">
        <view class="product-main">
          <view class="product-image-wrap">
            <image
              :src="detail.mainImage"
              mode="aspectFill"
              class="product-image"
              lazy-load
            />
            <view
              v-if="detail.status === PROMOTION_STATUS.DISABLED"
              class="image-mask"
            >
              <text class="mask-text">已停用</text>
            </view>
          </view>
          <view class="product-info">
            <text class="product-name">{{ detail.productName }}</text>
            <text v-if="detail.subTitle" class="product-sub">{{ detail.subTitle }}</text>
            <view class="price-row">
              <text class="product-price">¥{{ formatMoney(detail.price) }}</text>
              <view
                class="status-tag"
                :style="getStatusStyle(detail.status)"
              >
                <text class="status-text">{{ getStatusLabel(detail.status) }}</text>
              </view>
            </view>
            <view class="meta-row">
              <text class="merchant-name">{{ detail.merchantName || '未知商家' }}</text>
              <view class="commission-tag">
                <text class="commission-text">佣金 {{ detail.commissionRate }}%</text>
              </view>
            </view>
          </view>
        </view>
      </view>

      <!-- 推广信息卡片 -->
      <view class="promotion-card">
        <view class="card-header">
          <view class="header-line"></view>
          <text class="card-title">推广信息</text>
          <view class="header-line"></view>
        </view>

        <!-- 二维码大图 -->
        <view class="qrcode-section">
          <view class="qrcode-wrap">
            <image
              v-if="shareData && shareData.qrCode"
              :src="shareData.qrCode"
              mode="aspectFit"
              class="qrcode-img"
              @longpress="onQrCodeLongPress"
            />
            <view v-else class="qrcode-placeholder">
              <text class="placeholder-icon">📋</text>
              <text class="placeholder-text">
                {{ generatingLink ? '生成中...' : '二维码未生成' }}
              </text>
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
            <text class="value-text">{{ shareData?.promotionCode || detail.promotionCode || '-' }}</text>
          </view>
          <view
            class="copy-btn"
            :class="{ 'btn-disabled': !hasPromotionCode }"
            @click="handleCopyCode"
          >
            <text class="copy-text">复制</text>
          </view>
        </view>

        <!-- 推广链接 -->
        <view class="info-row">
          <view class="info-label">
            <text class="label-text">推广链接</text>
          </view>
          <view class="info-value">
            <text class="value-text link-text">{{ shareData?.promotionUrl || '-' }}</text>
          </view>
          <view
            class="copy-btn"
            :class="{ 'btn-disabled': !hasPromotionUrl }"
            @click="handleCopyLink"
          >
            <text class="copy-text">复制</text>
          </view>
        </view>
      </view>

      <!-- 历史佣金记录 -->
      <view class="commission-card">
        <view class="card-header">
          <view class="header-line"></view>
          <text class="card-title">分销佣金记录</text>
          <view class="header-line"></view>
        </view>

        <!-- 表头 -->
        <view v-if="commissionList.length > 0" class="table-head">
          <text class="th th-time">下单时间</text>
          <text class="th th-order">订单号</text>
          <text class="th th-amount">实付金额</text>
          <text class="th th-commission">佣金</text>
          <text class="th th-status">状态</text>
        </view>

        <!-- 表格内容 -->
        <view v-if="commissionList.length > 0" class="table-body">
          <view
            v-for="(item, idx) in commissionList"
            :key="idx"
            class="table-row"
          >
            <text class="td td-time">{{ formatTime(item.orderTime) }}</text>
            <text class="td td-order">{{ formatOrderNo(item.orderNo) }}</text>
            <text class="td td-amount">¥{{ formatMoney(item.payAmount) }}</text>
            <text class="td td-commission commission-value">¥{{ formatMoney(item.commissionAmount) }}</text>
            <view class="td td-status">
              <view
                class="status-pill"
                :style="getCommissionStyle(item.commissionStatus)"
              >
                <text class="pill-text">{{ getCommissionLabel(item.commissionStatus) }}</text>
              </view>
            </view>
          </view>

          <!-- 加载更多 -->
          <view class="load-more">
            <text v-if="commissionLoading" class="load-more-text">加载中...</text>
            <text v-else-if="hasMoreCommission" class="load-more-text">上拉加载更多</text>
            <text v-else class="load-more-text">没有更多了</text>
          </view>
        </view>

        <!-- 空状态 -->
        <view v-else class="commission-empty">
          <text class="empty-icon">💸</text>
          <text class="empty-text">暂无佣金记录</text>
          <text class="empty-desc">推广商品被购买后将显示在这里</text>
        </view>
      </view>

      <view class="safe-bottom"></view>
    </scroll-view>

    <!-- 加载失败 -->
    <view v-else class="error-state">
      <text class="error-icon">⚠</text>
      <text class="error-text">推广商品信息加载失败</text>
      <view class="retry-btn" @click="handleRetry">
        <text class="retry-text">重新加载</text>
      </view>
    </view>

    <!-- 底部操作栏 -->
    <view v-if="detail" class="bottom-bar">
      <view class="bottom-btn btn-share" @click="handleOpenShare">
        <text class="btn-icon">📤</text>
        <text class="btn-text">分享</text>
      </view>
      <view
        v-if="detail.status === PROMOTION_STATUS.ENABLED"
        class="bottom-btn btn-disable"
        :class="{ 'btn-loading': toggling }"
        @click="handleDisable"
      >
        <text class="btn-text">{{ toggling ? '处理中...' : '取消推广' }}</text>
      </view>
      <view
        v-else
        class="bottom-btn btn-enable"
        :class="{ 'btn-loading': toggling }"
        @click="handleEnable"
      >
        <text class="btn-text">{{ toggling ? '处理中...' : '恢复推广' }}</text>
      </view>
    </view>

    <!-- 分享弹窗 -->
    <SharePromotionPopup
      :visible="sharePopupVisible"
      :product-info="shareProductInfo"
      :distributor-product-id="distributorProductId"
      @close="closeSharePopup"
      @success="onShareLinkSuccess"
    />
  </view>
</template>

<script setup>
import { ref, computed } from 'vue'
import { onLoad, onUnload, onShow } from '@dcloudio/uni-app'
import { useDistributor } from '@/hooks/useDistributor'
import SharePromotionPopup from '@/components/business/SharePromotionPopup.vue'

const statusBarHeight = uni.getSystemInfoSync().statusBarHeight || 20

const {
  distributorStore,
  loadPromotionProductDetail,
  disablePromotionProduct,
  enablePromotionProduct,
  generateShareLink,
  copyPromotionUrl,
  copyPromotionCode,
  saveQrCode,
  PROMOTION_STATUS,
  PROMOTION_STATUS_MAP,
  COMMISSION_STATUS,
  COMMISSION_STATUS_MAP
} = useDistributor()

// 路由参数
const distributorProductId = ref(null)

// 加载状态
const loading = ref(false)
const toggling = ref(false)
const generatingLink = ref(false)

// 分享弹窗
const sharePopupVisible = ref(false)
const shareData = ref(null) // 推广链接数据（用于二维码展示）

// 佣金记录（来自详情接口的 commissionRecords 字段）
const commissionPage = ref(1)
const commissionPages = ref(0)
const commissionLoading = ref(false)

// ============ 计算属性 ============
const detail = computed(() => distributorStore.currentPromotionProduct)

const shareProductInfo = computed(() => {
  if (!detail.value) return {}
  return {
    productName: detail.value.productName,
    mainImage: detail.value.mainImage,
    price: detail.value.price,
    subTitle: detail.value.subTitle || ''
  }
})

const commissionList = computed(() => {
  return detail.value?.commissionRecords || []
})

const hasMoreCommission = computed(() => commissionPage.value < commissionPages.value)

const hasPromotionCode = computed(() => {
  return !!(shareData.value?.promotionCode || detail.value?.promotionCode)
})

const hasPromotionUrl = computed(() => {
  return !!shareData.value?.promotionUrl
})

// ============ 工具方法 ============
const formatMoney = (value) => {
  return (Number(value) || 0).toFixed(2)
}

const formatTime = (time) => {
  if (!time) return '-'
  // 兼容 YYYY-MM-DD HH:mm:ss / ISO 字符串
  const str = String(time)
  // 截取到分钟
  return str.length >= 16 ? str.slice(5, 16) : str
}

const formatOrderNo = (no) => {
  if (!no) return '-'
  const str = String(no)
  if (str.length <= 8) return str
  return str.slice(0, 4) + '...' + str.slice(-4)
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

const getCommissionLabel = (status) => {
  return COMMISSION_STATUS_MAP[status]?.label || '未知'
}

const getCommissionStyle = (status) => {
  const info = COMMISSION_STATUS_MAP[status]
  if (!info) return {}
  return {
    color: info.color,
    backgroundColor: info.bgColor
  }
}

// ============ 事件处理 ============
const handleBack = () => {
  uni.navigateBack({
    delta: 1,
    animationType: 'slide-out-right',
    animationDuration: 200
  })
}

const handleRetry = () => {
  loadDetail()
}

// 加载详情
const loadDetail = async () => {
  if (!distributorProductId.value) return
  loading.value = true
  await loadPromotionProductDetail(distributorProductId.value)
  loading.value = false
  // 详情加载完成后自动生成推广链接（用于显示二维码）
  if (detail.value && detail.value.status === PROMOTION_STATUS.ENABLED) {
    fetchShareLink()
  }
}

// 生成推广链接（用于二维码展示，不弹窗）
const fetchShareLink = async () => {
  if (!distributorProductId.value) return
  generatingLink.value = true
  const data = await generateShareLink(distributorProductId.value)
  generatingLink.value = false
  if (data) {
    shareData.value = data
  }
}

// 复制推广码
const handleCopyCode = () => {
  const code = shareData.value?.promotionCode || detail.value?.promotionCode
  if (!code) {
    uni.showToast({ title: '推广码不存在', icon: 'none' })
    return
  }
  copyPromotionCode(code)
}

// 复制推广链接
const handleCopyLink = () => {
  if (!shareData.value?.promotionUrl) {
    uni.showToast({ title: '链接生成中', icon: 'none' })
    return
  }
  copyPromotionUrl(shareData.value.promotionUrl)
}

// 长按二维码保存
const onQrCodeLongPress = () => {
  if (shareData.value?.qrCode) {
    saveQrCode(shareData.value.qrCode)
  }
}

// 打开分享弹窗
const handleOpenShare = () => {
  if (detail.value?.status === PROMOTION_STATUS.DISABLED) {
    uni.showToast({ title: '已停用的商品无法分享', icon: 'none' })
    return
  }
  sharePopupVisible.value = true
}

const closeSharePopup = () => {
  sharePopupVisible.value = false
}

// 分享弹窗生成链接成功 → 同步本地状态
const onShareLinkSuccess = (data) => {
  if (data) {
    shareData.value = data
  }
}

// 取消推广
const handleDisable = async () => {
  if (toggling.value || !detail.value) return
  toggling.value = true
  const ok = await disablePromotionProduct(detail.value)
  toggling.value = false
  if (ok) {
    // 重新加载详情以同步状态
    loadDetail()
  }
}

// 恢复推广
const handleEnable = async () => {
  if (toggling.value || !detail.value) return
  toggling.value = true
  const ok = await enablePromotionProduct(detail.value)
  toggling.value = false
  if (ok) {
    loadDetail()
  }
}

onLoad((options) => {
  if (options?.distributorProductId) {
    distributorProductId.value = options.distributorProductId
    loadDetail()
  } else {
    uni.showToast({ title: '参数缺失', icon: 'none' })
    setTimeout(() => uni.navigateBack(), 1500)
  }
})

onShow(() => {
  // 从分享弹窗或外部返回时，如果详情已加载则不重复请求
  if (detail.value) return
  if (distributorProductId.value) {
    loadDetail()
  }
})

onUnload(() => {
  distributorStore.resetPromotionData()
})
</script>

<style lang="scss" scoped>
.page-detail {
  min-height: 100vh;
  background: $bg-page;
  display: flex;
  flex-direction: column;
  padding-bottom: 140rpx;
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

// ============ 内容区 ============
.content-scroll {
  flex: 1;
  height: 0;
}

// ============ 商品信息卡片 ============
.product-card {
  margin: 16rpx 24rpx;
  background: $bg-card;
  border-radius: 24rpx;
  padding: 24rpx;
  box-shadow: $shadow-sm;
}

.product-main {
  display: flex;
}

.product-image-wrap {
  width: 200rpx;
  height: 200rpx;
  border-radius: 16rpx;
  overflow: hidden;
  background: $bg-page-light;
  flex-shrink: 0;
  margin-right: 24rpx;
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
    background: rgba(0, 0, 0, 0.5);
    display: flex;
    align-items: center;
    justify-content: center;

    .mask-text {
      color: #FFFFFF;
      font-size: 24rpx;
      font-weight: 500;
      padding: 6rpx 16rpx;
      border: 2rpx solid rgba(255, 255, 255, 0.7);
      border-radius: 8rpx;
    }
  }
}

.product-info {
  flex: 1;
  display: flex;
  flex-direction: column;
  min-width: 0;

  .product-name {
    font-size: 30rpx;
    color: $text-main;
    font-weight: 600;
    line-height: 1.4;
    margin-bottom: 8rpx;
    overflow: hidden;
    text-overflow: ellipsis;
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
  }

  .product-sub {
    font-size: 24rpx;
    color: $text-weak;
    margin-bottom: 12rpx;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }

  .price-row {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-bottom: 12rpx;

    .product-price {
      font-size: 36rpx;
      color: $color-primary-danger;
      font-weight: 700;
    }

    .status-tag {
      padding: 6rpx 16rpx;
      border-radius: 10rpx;

      .status-text {
        font-size: 22rpx;
        font-weight: 600;
      }
    }
  }

  .meta-row {
    display: flex;
    align-items: center;
    justify-content: space-between;

    .merchant-name {
      font-size: 24rpx;
      color: $text-sub;
      flex: 1;
      overflow: hidden;
      text-overflow: ellipsis;
      white-space: nowrap;
      margin-right: 12rpx;
    }

    .commission-tag {
      padding: 6rpx 14rpx;
      background: linear-gradient(135deg, rgba(255, 106, 0, 0.12) 0%, rgba(255, 77, 79, 0.12) 100%);
      border-radius: 10rpx;

      .commission-text {
        font-size: 22rpx;
        color: $color-primary;
        font-weight: 600;
      }
    }
  }
}

// ============ 推广信息卡片 ============
.promotion-card {
  margin: 16rpx 24rpx;
  background: $bg-card;
  border-radius: 24rpx;
  padding: 32rpx 24rpx;
  box-shadow: $shadow-sm;
}

.card-header {
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 32rpx;

  .header-line {
    flex: 1;
    height: 2rpx;
    background: linear-gradient(90deg, transparent, $bg-page-light, transparent);
  }

  .card-title {
    font-size: 28rpx;
    color: $text-main;
    font-weight: 600;
    margin: 0 24rpx;
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

// 推广码 / 推广链接 行
.info-row {
  display: flex;
  align-items: center;
  padding: 24rpx 0;
  border-bottom: 2rpx solid $bg-page-light;

  &:last-of-type {
    border-bottom: none;
  }

  .info-label {
    width: 140rpx;
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
    padding: 12rpx 28rpx;
    background: rgba(255, 106, 0, 0.1);
    border-radius: 28rpx;
    flex-shrink: 0;

    &:active {
      opacity: 0.7;
    }

    &.btn-disabled {
      opacity: 0.5;
      pointer-events: none;
    }

    .copy-text {
      font-size: 24rpx;
      color: $color-primary;
      font-weight: 500;
    }
  }
}

// ============ 佣金记录卡片 ============
.commission-card {
  margin: 16rpx 24rpx;
  background: $bg-card;
  border-radius: 24rpx;
  padding: 32rpx 24rpx;
  box-shadow: $shadow-sm;
}

// 表头
.table-head {
  display: flex;
  align-items: center;
  padding: 16rpx 0;
  background: $bg-page-light;
  border-radius: 12rpx;
  margin-bottom: 8rpx;

  .th {
    font-size: 22rpx;
    color: $text-sub;
    font-weight: 500;
    text-align: center;
  }

  .th-time { flex: 1.6; }
  .th-order { flex: 1.4; }
  .th-amount { flex: 1; }
  .th-commission { flex: 1; }
  .th-status { flex: 1; }
}

.table-body {
  display: flex;
  flex-direction: column;
}

.table-row {
  display: flex;
  align-items: center;
  padding: 20rpx 0;
  border-bottom: 2rpx solid $bg-page-light;

  &:last-of-type {
    border-bottom: none;
  }

  .td {
    font-size: 22rpx;
    color: $text-main;
    text-align: center;
  }

  .td-time { flex: 1.6; color: $text-sub; }
  .td-order { flex: 1.4; color: $text-sub; }
  .td-amount { flex: 1; }
  .td-commission {
    flex: 1;
    &.commission-value {
      color: $color-primary-danger;
      font-weight: 600;
    }
  }
  .td-status {
    flex: 1;
    display: flex;
    justify-content: center;

    .status-pill {
      padding: 4rpx 12rpx;
      border-radius: 8rpx;

      .pill-text {
        font-size: 20rpx;
        font-weight: 500;
      }
    }
  }
}

// 佣金空状态
.commission-empty {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 40rpx 0;

  .empty-icon {
    font-size: 80rpx;
    opacity: 0.5;
    margin-bottom: 16rpx;
  }

  .empty-text {
    font-size: 26rpx;
    color: $text-main;
    font-weight: 500;
    margin-bottom: 8rpx;
  }

  .empty-desc {
    font-size: 22rpx;
    color: $text-weak;
  }
}

.load-more {
  padding: 24rpx 0;

  .load-more-text {
    font-size: 22rpx;
    color: $text-weak;
    text-align: center;
    display: block;
  }
}

// ============ 底部操作栏 ============
.bottom-bar {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  display: flex;
  align-items: center;
  padding: 16rpx 24rpx;
  padding-bottom: calc(16rpx + env(safe-area-inset-bottom));
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(40rpx);
  -webkit-backdrop-filter: blur(40rpx);
  box-shadow: 0 -4rpx 24rpx rgba(0, 0, 0, 0.06);
  z-index: 100;
  gap: 16rpx;
}

.bottom-btn {
  flex: 1;
  height: 88rpx;
  border-radius: 44rpx;
  display: flex;
  align-items: center;
  justify-content: center;

  &:active {
    transform: scale(0.96);
  }

  &.btn-loading {
    opacity: 0.6;
    pointer-events: none;
  }

  .btn-icon {
    font-size: 28rpx;
    margin-right: 10rpx;
  }

  .btn-text {
    font-size: 28rpx;
    font-weight: 500;
  }
}

.btn-share {
  background: rgba(24, 144, 255, 0.1);

  .btn-icon,
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
  box-shadow: 0 8rpx 16rpx rgba(255, 106, 0, 0.3);

  .btn-text {
    color: #FFFFFF;
  }
}

// ============ 加载/错误状态 ============
.loading-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding-top: 200rpx;
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

.error-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding-top: 200rpx;

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
    box-shadow: 0 8rpx 16rpx rgba(255, 106, 0, 0.25);

    .retry-text {
      color: #FFFFFF;
      font-size: 26rpx;
      font-weight: 500;
    }
  }
}

.safe-bottom {
  height: env(safe-area-inset-bottom);
  padding-bottom: 32rpx;
}
</style>
