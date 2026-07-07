<template>
  <view class="page-container">
    <!-- 顶部导航栏 + 活动信息（渐变背景） -->
    <view class="header-section">
      <view class="nav-bar">
        <view class="nav-back" @click="handleBack">
          <text class="back-icon">‹</text>
        </view>
        <text class="nav-title">限时秒杀</text>
        <view class="nav-placeholder"></view>
      </view>

      <!-- 活动信息卡片 -->
      <view v-if="activityInfo" class="activity-info">
        <view class="activity-top">
          <view class="activity-title-wrap">
            <text class="activity-icon">🔥</text>
            <text class="activity-title">{{ activityInfo.title }}</text>
          </view>
          <view class="activity-status-tag" :class="statusTagClass">
            <text>{{ activityInfo.statusText }}</text>
          </view>
        </view>

        <view class="activity-countdown">
          <text class="countdown-label">{{ countdownLabel }}</text>
          <view v-if="activityInfo.countdownSeconds > 0" class="countdown-box">
            <view class="countdown-item">
              <text class="countdown-num">{{ timeLeft.hours }}</text>
            </view>
            <text class="countdown-sep">:</text>
            <view class="countdown-item">
              <text class="countdown-num">{{ timeLeft.minutes }}</text>
            </view>
            <text class="countdown-sep">:</text>
            <view class="countdown-item">
              <text class="countdown-num">{{ timeLeft.seconds }}</text>
            </view>
          </view>
          <text v-else class="countdown-ended">活动已结束</text>
        </view>

        <view v-if="activityInfo.startTime" class="activity-time">
          <text class="time-label">活动时间</text>
          <text class="time-value">{{ activityInfo.startTime }} ~ {{ activityInfo.endTime }}</text>
        </view>
      </view>
    </view>

    <!-- 商品列表区域 -->
    <scroll-view
      scroll-y
      class="page-content"
      :refresher-enabled="true"
      :refresher-triggered="refreshing"
      @refresherrefresh="onRefresh"
      @scrolltolower="onLoadMore"
    >
      <!-- 暂无秒杀活动 -->
      <view v-if="!activityInfo && !loading" class="empty-state">
        <view class="empty-icon">
          <text class="empty-emoji">⏰</text>
        </view>
        <text class="empty-title">暂无秒杀活动</text>
        <text class="empty-desc">敬请期待下一场秒杀</text>
        <view class="empty-btn" @click="handleBack">
          <text>返回首页</text>
        </view>
      </view>

      <!-- 商品列表 -->
      <view v-else class="goods-list">
        <view
          v-for="item in productList"
          :key="item.seckillProductId"
          class="goods-card"
          @click="handleGoodsClick(item)"
        >
          <!-- 商品图片 -->
          <view class="goods-image-wrap">
            <image
              :src="item.productImage"
              mode="aspectFill"
              class="goods-image"
              :lazy-load="true"
            />
            <!-- 售罄遮罩 -->
            <view v-if="item.status === 2" class="goods-mask">
              <text class="mask-text">已售罄</text>
            </view>
            <!-- 预热中遮罩 -->
            <view v-else-if="!item.canBuy && activityInfo && activityInfo.status === 0" class="goods-mask preheat">
              <text class="mask-text">即将开始</text>
            </view>
          </view>

          <!-- 商品信息 -->
          <view class="goods-info">
            <text class="goods-name">{{ item.productName }}</text>
            <text v-if="item.skuSpecs" class="goods-sku">{{ item.skuSpecs }}</text>

            <!-- 库存进度条 -->
            <view class="stock-progress">
              <view class="progress-bar">
                <view
                  class="progress-inner"
                  :style="{ width: getSoldPercent(item) + '%' }"
                ></view>
              </view>
              <text class="progress-text">已抢{{ item.soldCount }}件</text>
            </view>

            <!-- 价格 + 限购 -->
            <view class="goods-limit" v-if="item.limitQuantity > 0">
              <text class="limit-text">限购{{ item.limitQuantity }}件</text>
            </view>

            <!-- 底部价格 + 按钮 -->
            <view class="goods-bottom">
              <view class="price-wrap">
                <text class="seckill-price-symbol">¥</text>
                <text class="seckill-price">{{ formatPrice(item.seckillPrice) }}</text>
                <text class="origin-price">¥{{ formatPrice(item.originPrice) }}</text>
              </view>
              <view
                class="buy-btn"
                :class="getButtonClass(item)"
                @click.stop="handleBuy(item)"
              >
                <text>{{ item.buttonText || getButtonText(item) }}</text>
              </view>
            </view>
          </view>
        </view>

        <!-- 加载中 -->
        <view v-if="loading" class="loading-more">
          <text class="loading-text">加载中...</text>
        </view>

        <!-- 没有更多 -->
        <view v-if="!loading && !hasMore && productList.length > 0" class="no-more">
          <text class="no-more-text">没有更多了</text>
        </view>
      </view>
    </scroll-view>
  </view>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { onShow, onBackPress } from '@dcloudio/uni-app'
import { usePromotion } from '@/hooks/usePromotion'
import { showToast, getValidImageUrl } from '@/utils/common'

const promotionHook = usePromotion()

// 活动信息
const activityInfo = ref(null)
// 商品列表
const productList = ref([])
// 加载状态
const loading = ref(false)
const refreshing = ref(false)
// 分页
const page = ref(1)
const pageSize = ref(10)
const hasMore = ref(true)

// 倒计时
const timeLeft = ref({ hours: '00', minutes: '00', seconds: '00' })
let countdownTimer = null
let remainSeconds = 0

// 倒计时标签
const countdownLabel = computed(() => {
  if (!activityInfo.value) return ''
  if (activityInfo.value.status === 0) return '距开始'
  if (activityInfo.value.status === 1) return '距结束'
  return '已结束'
})

// 状态标签样式
const statusTagClass = computed(() => {
  if (!activityInfo.value) return ''
  const status = activityInfo.value.status
  if (status === 0) return 'tag-preheat'
  if (status === 1) return 'tag-active'
  return 'tag-ended'
})

// 格式化价格
const formatPrice = (price) => {
  return (Number(price) || 0).toFixed(2)
}

// 计算已抢百分比
const getSoldPercent = (item) => {
  if (!item.seckillStock || item.seckillStock === 0) return 100
  const percent = Math.round((item.soldCount / item.seckillStock) * 100)
  return Math.min(percent, 100)
}

// 获取按钮文字
const getButtonText = (item) => {
  if (item.status === 2) return '已售罄'
  if (item.status === 3) return '已结束'
  if (item.canBuy) return '立即抢购'
  return '即将开始'
}

// 获取按钮样式
const getButtonClass = (item) => {
  if (item.canBuy) return 'btn-active'
  return 'btn-disabled'
}

// 更新倒计时
const updateCountdown = () => {
  if (remainSeconds <= 0) {
    timeLeft.value = { hours: '00', minutes: '00', seconds: '00' }
    if (countdownTimer) {
      clearInterval(countdownTimer)
      countdownTimer = null
    }
    return
  }

  const hours = Math.floor(remainSeconds / 3600)
  const minutes = Math.floor((remainSeconds % 3600) / 60)
  const seconds = remainSeconds % 60

  timeLeft.value = {
    hours: String(hours).padStart(2, '0'),
    minutes: String(minutes).padStart(2, '0'),
    seconds: String(seconds).padStart(2, '0')
  }
  remainSeconds--
}

// 启动倒计时
const startCountdown = () => {
  if (countdownTimer) {
    clearInterval(countdownTimer)
    countdownTimer = null
  }
  if (!activityInfo.value || !activityInfo.value.countdownSeconds) return

  remainSeconds = Number(activityInfo.value.countdownSeconds) || 0
  updateCountdown()
  countdownTimer = setInterval(updateCountdown, 1000)
}

// 加载活动信息
const loadActivity = async () => {
  const res = await promotionHook.loadCurrentSeckillActivity()
  if (res) {
    activityInfo.value = res
    startCountdown()
  } else {
    activityInfo.value = null
  }
}

// 加载商品列表
const loadProducts = async (isRefresh = false) => {
  if (loading.value) return
  if (!activityInfo.value) {
    productList.value = []
    hasMore.value = false
    return
  }

  loading.value = true

  const res = await promotionHook.loadCurrentSeckillProducts({
    page: page.value,
    pageSize: pageSize.value
  })

  if (res) {
    const list = (res.list || []).map(item => {
      // 兼容字段映射：接口返回 title/mainImage，页面使用 productName/productImage
      const productName = item.productName || item.title || ''
      const productImage = item.productImage || item.mainImage || ''
      return {
        ...item,
        // 字段映射
        productName,
        productImage: getValidImageUrl(productImage),
        skuSpecs: item.skuSpecs || item.subTitle || '',
        // 秒杀专属字段（接口未返回时给默认值，避免页面显示异常）
        seckillProductId: item.seckillProductId || item.productId,
        seckillPrice: item.seckillPrice || item.price || 0,
        originPrice: item.originPrice || item.originalPrice || item.price || 0,
        seckillStock: item.seckillStock || item.stock || 0,
        limitQuantity: item.limitQuantity || 0,
        // canBuy 优先取商品级，回落到活动级
        canBuy: item.canBuy !== undefined ? item.canBuy : (activityInfo.value ? activityInfo.value.canBuy : false),
        // 按钮文字
        buttonText: item.buttonText || ''
      }
    })

    if (isRefresh || page.value === 1) {
      productList.value = list
    } else {
      productList.value = [...productList.value, ...list]
    }

    const total = res.total || 0
    hasMore.value = list.length > 0 && productList.value.length < total
  } else {
    if (isRefresh || page.value === 1) {
      productList.value = []
    }
    hasMore.value = false
  }

  loading.value = false
  refreshing.value = false
}

// 初始化数据
const initData = async () => {
  await loadActivity()
  page.value = 1
  hasMore.value = true
  await loadProducts(true)
}

// 下拉刷新
const onRefresh = () => {
  refreshing.value = true
  initData()
}

// 加载更多
const onLoadMore = () => {
  if (loading.value || !hasMore.value) return
  page.value++
  loadProducts()
}

// 返回
const handleBack = () => {
  const pages = getCurrentPages()
  if (pages.length > 1) {
    uni.navigateBack({
      fail: () => {
        uni.switchTab({ url: '/pages/index/index' })
      }
    })
  } else {
    uni.switchTab({ url: '/pages/index/index' })
  }
}

// 拦截系统返回键，避免陷入死循环
onBackPress(() => {
  handleBack()
  return true
})

// 点击商品
const handleGoodsClick = (item) => {
  // 预热期和进行期都可查看商品详情
  uni.navigateTo({
    url: `/pagesSub/goods/detail/goodsDetail?productId=${item.productId}`,
    fail: () => {
      uni.showToast({ title: '跳转失败', icon: 'none' })
    }
  })
}

// 抢购中状态（防止重复点击）
const buying = ref(false)

// 立即抢购
const handleBuy = async (item) => {
  if (buying.value) return

  if (!item.canBuy) {
    if (item.status === 2) {
      showToast('已售罄')
    } else if (activityInfo.value && activityInfo.value.status === 0) {
      showToast('活动尚未开始')
    } else {
      showToast('暂不可购买')
    }
    return
  }

  // 调用秒杀资格校验（校验登录、活动状态、库存、限购数量等）
  buying.value = true
  uni.showLoading({ title: '校验中...', mask: true })

  const canBuy = await promotionHook.checkSeckillQualification(item.seckillProductId)

  uni.hideLoading()
  buying.value = false

  if (!canBuy) {
    // 不可购买原因已在 hook 中通过 toast 提示
    return
  }

  // 校验通过，跳转确认订单页面（秒杀商品通过 productId + skuId 加入购物车）
  // 传递 seckillProductId 作为活动上下文，后端据此匹配秒杀价格
  uni.navigateTo({
    url: `/pagesSub/order/confirmOrder?source=buyNow&productId=${item.productId}&skuId=${item.skuId}&quantity=1&seckillProductId=${item.seckillProductId}`
  })
}

onMounted(() => {
  initData()
})

onShow(() => {
  // 页面显示时刷新活动状态（倒计时可能已到期）
  if (activityInfo.value && activityInfo.value.countdownSeconds !== undefined) {
    // 仅在活动状态可能变化时刷新
  }
})

onUnmounted(() => {
  if (countdownTimer) {
    clearInterval(countdownTimer)
    countdownTimer = null
  }
  promotionHook.clearSeckillData()
})
</script>

<style lang="scss" scoped>
.page-container {
  min-height: 100vh;
  background: $bg-page;
  display: flex;
  flex-direction: column;
}

/* ============ 顶部导航 + 活动信息 ============ */
.header-section {
  flex-shrink: 0;
  background: linear-gradient(135deg, $color-primary 0%, $color-primary-danger 100%);
  padding-bottom: 32rpx;
}

.nav-bar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 40rpx 32rpx 20rpx;
}

.nav-back {
  width: 64rpx;
  height: 64rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(255, 255, 255, 0.2);
  border-radius: 50%;

  .back-icon {
    font-size: 48rpx;
    color: #FFFFFF;
    font-weight: 300;
    line-height: 1;
    margin-top: -4rpx;
  }

  &:active {
    background: rgba(255, 255, 255, 0.35);
  }
}

.nav-title {
  font-size: 36rpx;
  font-weight: 700;
  color: #FFFFFF;
  letter-spacing: 2rpx;
}

.nav-placeholder {
  width: 64rpx;
}

/* 活动信息 */
.activity-info {
  padding: 8rpx 32rpx 0;
}

.activity-top {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 24rpx;
}

.activity-title-wrap {
  display: flex;
  align-items: center;
  flex: 1;

  .activity-icon {
    font-size: 40rpx;
    margin-right: 12rpx;
  }

  .activity-title {
    font-size: 38rpx;
    font-weight: 700;
    color: #FFFFFF;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }
}

.activity-status-tag {
  padding: 8rpx 20rpx;
  border-radius: 24rpx;
  flex-shrink: 0;
  margin-left: 16rpx;

  text {
    font-size: 24rpx;
    font-weight: 600;
    color: #FFFFFF;
  }

  &.tag-preheat {
    background: rgba(255, 255, 255, 0.25);
  }

  &.tag-active {
    background: rgba(255, 255, 255, 0.95);
    text {
      color: $color-primary-danger;
    }
  }

  &.tag-ended {
    background: rgba(0, 0, 0, 0.2);
  }
}

/* 倒计时 */
.activity-countdown {
  display: flex;
  align-items: center;
  margin-bottom: 16rpx;

  .countdown-label {
    font-size: 26rpx;
    color: rgba(255, 255, 255, 0.9);
    margin-right: 16rpx;
  }

  .countdown-box {
    display: flex;
    align-items: center;
  }

  .countdown-item {
    min-width: 56rpx;
    height: 56rpx;
    background: rgba(0, 0, 0, 0.3);
    border-radius: 10rpx;
    display: flex;
    align-items: center;
    justify-content: center;

    .countdown-num {
      font-size: 32rpx;
      font-weight: 700;
      color: #FFFFFF;
      font-family: 'Helvetica Neue', Arial, sans-serif;
      font-variant-numeric: tabular-nums;
    }
  }

  .countdown-sep {
    font-size: 32rpx;
    font-weight: 700;
    color: #FFFFFF;
    margin: 0 8rpx;
  }

  .countdown-ended {
    font-size: 28rpx;
    color: rgba(255, 255, 255, 0.8);
  }
}

/* 活动时间 */
.activity-time {
  display: flex;
  align-items: center;

  .time-label {
    font-size: 24rpx;
    color: rgba(255, 255, 255, 0.7);
    margin-right: 12rpx;
  }

  .time-value {
    font-size: 24rpx;
    color: rgba(255, 255, 255, 0.9);
  }
}

/* ============ 商品列表 ============ */
.page-content {
  flex: 1;
  padding: 20rpx 24rpx;
  box-sizing: border-box;
}

.goods-list {
  display: flex;
  flex-direction: column;
}

.goods-card {
  display: flex;
  background: $bg-card;
  border-radius: 20rpx;
  overflow: hidden;
  margin-bottom: 20rpx;
  box-shadow: 0 4rpx 16rpx rgba(0, 0, 0, 0.04);

  &:active {
    transform: scale(0.99);
  }
}

/* 商品图片 */
.goods-image-wrap {
  position: relative;
  width: 240rpx;
  height: 240rpx;
  flex-shrink: 0;

  .goods-image {
    width: 100%;
    height: 100%;
  }

  .goods-mask {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(0, 0, 0, 0.5);
    display: flex;
    align-items: center;
    justify-content: center;

    &.preheat {
      background: rgba(0, 0, 0, 0.4);
    }

    .mask-text {
      font-size: 26rpx;
      color: #FFFFFF;
      font-weight: 600;
      padding: 8rpx 20rpx;
      background: rgba(255, 106, 0, 0.85);
      border-radius: 24rpx;
    }
  }
}

/* 商品信息 */
.goods-info {
  flex: 1;
  padding: 20rpx 24rpx;
  display: flex;
  flex-direction: column;
  min-width: 0;

  .goods-name {
    font-size: 28rpx;
    font-weight: 600;
    color: $text-main;
    line-height: 1.4;
    overflow: hidden;
    text-overflow: ellipsis;
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
  }

  .goods-sku {
    font-size: 22rpx;
    color: $text-weak;
    margin-top: 8rpx;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }
}

/* 库存进度条 */
.stock-progress {
  display: flex;
  align-items: center;
  margin-top: 12rpx;

  .progress-bar {
    flex: 1;
    height: 12rpx;
    background: rgba($color-primary, 0.1);
    border-radius: 6rpx;
    overflow: hidden;
    margin-right: 12rpx;

    .progress-inner {
      height: 100%;
      background: linear-gradient(90deg, $color-primary, $color-primary-danger);
      border-radius: 6rpx;
      transition: width 0.3s ease;
    }
  }

  .progress-text {
    font-size: 20rpx;
    color: $color-primary-danger;
    flex-shrink: 0;
  }
}

/* 限购标签 */
.goods-limit {
  margin-top: 8rpx;

  .limit-text {
    font-size: 20rpx;
    color: $color-primary;
    padding: 2rpx 10rpx;
    background: rgba($color-primary, 0.08);
    border-radius: 6rpx;
  }
}

/* 底部价格 + 按钮 */
.goods-bottom {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  margin-top: auto;
  padding-top: 12rpx;

  .price-wrap {
    display: flex;
    align-items: baseline;

    .seckill-price-symbol {
      font-size: 24rpx;
      font-weight: 700;
      color: $color-primary-danger;
    }

    .seckill-price {
      font-size: 36rpx;
      font-weight: 700;
      color: $color-primary-danger;
      margin-right: 12rpx;
      font-family: 'Helvetica Neue', Arial, sans-serif;
    }

    .origin-price {
      font-size: 22rpx;
      color: $text-weak;
      text-decoration: line-through;
    }
  }

  .buy-btn {
    padding: 12rpx 32rpx;
    border-radius: 28rpx;
    flex-shrink: 0;

    text {
      font-size: 26rpx;
      font-weight: 600;
      color: #FFFFFF;
    }

    &.btn-active {
      background: linear-gradient(135deg, $color-primary, $color-primary-danger);
      box-shadow: 0 4rpx 12rpx rgba($color-primary-danger, 0.25);

      &:active {
        transform: scale(0.96);
      }
    }

    &.btn-disabled {
      background: rgba($text-weak, 0.3);

      text {
        color: rgba(255, 255, 255, 0.9);
      }
    }
  }
}

/* ============ 空状态 ============ */
.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 120rpx 0 80rpx;

  .empty-icon {
    width: 160rpx;
    height: 160rpx;
    border-radius: 50%;
    background: rgba($text-weak, 0.06);
    display: flex;
    align-items: center;
    justify-content: center;
    margin-bottom: 32rpx;

    .empty-emoji {
      font-size: 72rpx;
    }
  }

  .empty-title {
    font-size: 32rpx;
    font-weight: 600;
    color: $text-main;
    margin-bottom: 12rpx;
  }

  .empty-desc {
    font-size: 26rpx;
    color: $text-weak;
    margin-bottom: 40rpx;
  }

  .empty-btn {
    padding: 16rpx 48rpx;
    background: linear-gradient(135deg, $color-primary, $color-primary-danger);
    border-radius: 40rpx;

    text {
      font-size: 28rpx;
      font-weight: 600;
      color: #FFFFFF;
    }

    &:active {
      transform: scale(0.96);
    }
  }
}

/* ============ 加载更多 ============ */
.loading-more,
.no-more {
  display: flex;
  justify-content: center;
  padding: 24rpx 0;

  .loading-text,
  .no-more-text {
    font-size: 24rpx;
    color: $text-weak;
  }
}
</style>
