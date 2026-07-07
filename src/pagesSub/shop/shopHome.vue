<template>
  <view class="page-shop">
    <!-- 自定义导航栏 -->
    <view class="nav-bar" :style="{ paddingTop: statusBarHeight + 'px' }">
      <view class="nav-back" @click="goBack">
        <text class="back-icon">‹</text>
      </view>
      <view class="nav-title">{{ merchantHome?.merchantName || '商家主页' }}</view>
      <view class="nav-placeholder-right"></view>
    </view>
    <view class="nav-placeholder" :style="{ height: (statusBarHeight + 44) + 'px' }"></view>

    <!-- 搜索栏(2.9.6 商家主页搜索商品) -->
    <view v-if="merchantHome" class="search-bar">
      <view class="search-input-wrap">
        <image class="search-icon" src="/static/fonts/search.svg" mode="aspectFit" />
        <input
          class="search-input"
          type="text"
          :value="keyword"
          placeholder="搜索本店商品"
          placeholder-class="search-placeholder"
          confirm-type="search"
          @input="onSearchInput"
          @confirm="onSearchConfirm"
        />
        <view
          v-if="keyword"
          class="search-clear"
          @click="clearSearch"
        >
          <text class="clear-icon">✕</text>
        </view>
      </view>
      <view
        v-if="isSearching"
        class="search-cancel"
        @click="cancelSearch"
      >
        <text class="cancel-text">取消</text>
      </view>
    </view>

    <!-- 加载中 -->
    <view v-if="loading && !merchantHome" class="loading-page">
      <view class="loading-spinner"></view>
      <text class="loading-text">加载中...</text>
    </view>

    <!-- 商家不存在 -->
    <view v-else-if="!merchantHome && !loading" class="not-found-page">
      <text class="not-found-icon">🏪</text>
      <text class="not-found-title">商家不存在</text>
      <text class="not-found-desc">该商家不存在或已停用</text>
      <view class="not-found-btn" @click="goBack">
        <text class="not-found-btn-text">返回上一页</text>
      </view>
    </view>

    <!-- 商家主页内容 -->
    <scroll-view
      v-else
      scroll-y
      class="shop-scroll"
      @scrolltolower="onLoadMore"
      :refresher-enabled="true"
      :refresher-triggered="refreshing"
      @refresherrefresh="onRefresh"
    >
      <!-- 商家头部卡片 -->
      <view class="shop-header">
        <view class="header-bg"></view>
        <view class="header-content">
          <view class="shop-info">
            <view class="shop-logo-wrap">
              <image
                v-if="merchantHome.logo"
                class="shop-logo"
                :src="merchantHome.logo"
                mode="aspectFill"
              />
              <view v-else class="shop-logo-default">
                <text class="logo-text">{{ merchantHome.merchantName?.charAt(0) || '店' }}</text>
              </view>
            </view>
            <view class="shop-meta">
              <view class="shop-name-row">
                <text class="shop-name">{{ merchantHome.merchantName }}</text>
                <view class="shop-status" :class="merchantHome.status === 1 ? 'status-open' : 'status-closed'">
                  <text class="status-text">{{ merchantHome.statusText || (merchantHome.status === 1 ? '营业中' : '暂停营业') }}</text>
                </view>
              </view>
              <view v-if="merchantHome.businessHours" class="shop-hours">
                <text class="hours-icon">🕐</text>
                <text class="hours-text">{{ merchantHome.businessHours }}</text>
              </view>
              <view v-if="merchantHome.shopAddress" class="shop-address" @click="copyAddress(merchantHome.shopAddress)">
                <text class="address-icon">📍</text>
                <text class="address-text">{{ merchantHome.shopAddress }}</text>
                <text class="address-copy">复制</text>
              </view>
            </view>
          </view>

          <!-- 简介 -->
          <view v-if="merchantHome.introduction" class="shop-intro">
            <text class="intro-text">{{ merchantHome.introduction }}</text>
          </view>

          <!-- 统计数据 -->
          <view class="shop-stats">
            <view class="stats-item">
              <text class="stats-value">{{ merchantHome.statistics?.productCount || 0 }}</text>
              <text class="stats-label">在售商品</text>
            </view>
            <view class="stats-divider"></view>
            <view class="stats-item">
              <text class="stats-value">{{ formatSoldCount(merchantHome.statistics?.totalSoldCount) }}</text>
              <text class="stats-label">累计销量</text>
            </view>
            <view class="stats-divider"></view>
            <view class="stats-item" @click="contactMerchant(merchantHome.contactPhone)">
              <text class="stats-icon">📞</text>
              <text class="stats-label">联系商家</text>
            </view>
          </view>
        </view>
      </view>

      <!-- 优惠券区域 -->
      <view v-if="merchantHome.couponList && merchantHome.couponList.length > 0" class="section coupon-section">
        <view class="section-header">
          <text class="section-title">店铺优惠券</text>
        </view>
        <scroll-view scroll-x class="coupon-scroll" :show-scrollbar="false">
          <view class="coupon-list">
            <view
              v-for="coupon in merchantHome.couponList"
              :key="coupon.couponId"
              class="coupon-card"
              :class="{ 'coupon-received': coupon.alreadyReceived }"
            >
              <view class="coupon-left">
                <text class="coupon-amount">
                  <text class="amount-symbol">¥</text>
                  <text class="amount-value">{{ coupon.discountAmount }}</text>
                </text>
                <text class="coupon-condition">满{{ coupon.minConsume }}可用</text>
              </view>
              <view class="coupon-divider"></view>
              <view class="coupon-right">
                <text class="coupon-type">{{ coupon.typeText || '优惠券' }}</text>
                <text class="coupon-remaining">剩{{ coupon.remainingCount }}张</text>
                <view
                  class="coupon-btn"
                  :class="{ 'coupon-btn-disabled': coupon.alreadyReceived || coupon.remainingCount <= 0 }"
                  @click="handleReceiveCoupon(coupon)"
                >
                  <text class="coupon-btn-text">{{ coupon.alreadyReceived ? '已领取' : (coupon.remainingCount <= 0 ? '已领完' : '立即领取') }}</text>
                </view>
              </view>
            </view>
          </view>
        </scroll-view>
      </view>

      <!-- 推荐商品 -->
      <view v-if="merchantHome.recommendProducts && merchantHome.recommendProducts.length > 0" class="section recommend-section">
        <view class="section-header">
          <text class="section-title">店铺推荐</text>
        </view>
        <scroll-view scroll-x class="recommend-scroll" :show-scrollbar="false">
          <view class="recommend-list">
            <view
              v-for="product in merchantHome.recommendProducts"
              :key="product.productId"
              class="recommend-card"
              @click="goProductDetail(product.productId)"
            >
              <image
                v-if="product.mainImage"
                class="recommend-image"
                :src="product.mainImage"
                mode="aspectFill"
                lazy-load
              />
              <view v-else class="recommend-image-default">
                <text class="default-text">🍎</text>
              </view>
              <view class="recommend-info">
                <text class="recommend-title">{{ product.title }}</text>
                <text class="recommend-sold">已售{{ formatSoldCount(product.soldCount) }}</text>
              </view>
            </view>
          </view>
        </scroll-view>
      </view>

      <!-- 全部商品 -->
      <view class="section product-section">
        <view class="section-header">
          <text class="section-title">全部商品</text>
          <text class="section-count">共{{ merchantStore.productTotal }}件</text>
        </view>

        <!-- 排序栏 -->
        <view class="sort-bar">
          <view
            v-for="item in sortOptions"
            :key="item.value"
            class="sort-item"
            :class="{ 'sort-active': activeSort === item.value }"
            @click="changeSort(item.value)"
          >
            <text class="sort-text">{{ item.label }}</text>
          </view>
        </view>

        <!-- 商品列表 -->
        <view v-if="merchantStore.merchantProducts.length > 0" class="product-list">
          <view
            v-for="product in merchantStore.merchantProducts"
            :key="product.productId"
            class="product-card"
            @click="goProductDetail(product.productId)"
          >
            <image
              v-if="product.mainImage"
              class="product-image"
              :src="product.mainImage"
              mode="aspectFill"
              lazy-load
            />
            <view v-else class="product-image-default">
              <text class="default-text">🍎</text>
            </view>
            <view class="product-info">
              <text class="product-title">{{ product.title }}</text>
              <text v-if="product.subTitle" class="product-subtitle">{{ product.subTitle }}</text>
              <view class="product-bottom">
                <text class="product-sold">已售{{ formatSoldCount(product.soldCount) }}</text>
                <text v-if="product.saleTypeText" class="product-tag">{{ product.saleTypeText }}</text>
              </view>
            </view>
          </view>
        </view>

        <!-- 商品加载中 -->
        <view v-if="productLoading && merchantStore.merchantProducts.length === 0" class="product-loading">
          <view class="loading-spinner small"></view>
          <text class="loading-text">商品加载中...</text>
        </view>

        <!-- 商品为空 -->
        <view v-else-if="!productLoading && merchantStore.merchantProducts.length === 0" class="product-empty">
          <text class="empty-icon">📦</text>
          <text class="empty-text">暂无商品</text>
        </view>

        <!-- 加载更多 -->
        <view v-if="merchantStore.merchantProducts.length > 0" class="load-more">
          <text v-if="productLoading" class="load-more-text">加载中...</text>
          <text v-else-if="hasMore" class="load-more-text">上拉加载更多</text>
          <text v-else class="load-more-text">没有更多了</text>
        </view>
      </view>

      <!-- 底部安全区 -->
      <view class="safe-bottom"></view>
    </scroll-view>
  </view>
</template>

<script setup>
import { ref, computed } from 'vue'
import { onLoad, onShow, onUnload, onPullDownRefresh } from '@dcloudio/uni-app'
import { useShop } from '@/hooks/useShop'
import { MERCHANT_PRODUCT_SORT_OPTIONS } from '@/constants/merchant'

const {
  merchantStore,
  loading,
  productLoading,
  couponLoading,
  refreshing,
  loadMerchantHome,
  loadMerchantProducts,
  contactMerchant,
  copyAddress,
  goProductDetail,
  receiveCoupon,
  resetShopData
} = useShop()

const statusBarHeight = uni.getSystemInfoSync().statusBarHeight || 20
const merchantId = ref(null)
const activeSort = ref('DEFAULT')
const currentPage = ref(1)
const pageSize = 10

// 搜索相关(2.9.6)
const keyword = ref('')
const isSearching = ref(false)
let searchTimer = null
const SEARCH_DEBOUNCE_MS = 500  // 搜索防抖时间

// 商家主页数据(从 store 获取)
const merchantHome = computed(() => merchantStore.merchantHome)

// 排序选项(来自常量)
const sortOptions = MERCHANT_PRODUCT_SORT_OPTIONS

// 是否还有更多
const hasMore = computed(() => currentPage.value < merchantStore.productPages)

// 格式化销量
const formatSoldCount = (count) => {
  const num = Number(count) || 0
  if (num >= 10000) {
    return (num / 10000).toFixed(1) + '万'
  }
  return num.toString()
}

// 返回上一页
const goBack = () => {
  uni.navigateBack({
    delta: 1,
    animationType: 'slide-out-right',
    animationDuration: 200
  })
}

// ============ 搜索相关(2.9.6) ============

// 搜索输入处理(防抖)
const onSearchInput = (e) => {
  const value = e?.detail?.value ?? ''
  keyword.value = value.trim()
  isSearching.value = true
  // 防抖:500ms 内无新输入则触发搜索
  if (searchTimer) clearTimeout(searchTimer)
  searchTimer = setTimeout(() => {
    doSearch()
  }, SEARCH_DEBOUNCE_MS)
}

// 确认搜索(键盘回车)
const onSearchConfirm = () => {
  if (searchTimer) clearTimeout(searchTimer)
  keyword.value = keyword.value.trim()
  doSearch()
}

// 执行搜索
const doSearch = () => {
  currentPage.value = 1
  loadProductList(false)
}

// 清除搜索
const clearSearch = () => {
  if (searchTimer) clearTimeout(searchTimer)
  keyword.value = ''
  isSearching.value = false
  currentPage.value = 1
  loadProductList(false)
}

// 取消搜索(恢复初始状态)
const cancelSearch = () => {
  if (searchTimer) clearTimeout(searchTimer)
  keyword.value = ''
  isSearching.value = false
  currentPage.value = 1
  loadProductList(false)
}

// 切换排序
const changeSort = (sort) => {
  if (activeSort.value === sort) return
  activeSort.value = sort
  currentPage.value = 1
  loadProductList()
}

// 领取优惠券(前端预校验 + Hook 调用)
const handleReceiveCoupon = (coupon) => {
  // 防止重复点击 + 状态校验
  if (couponLoading.value) return
  if (coupon.alreadyReceived) {
    uni.showToast({ title: '已领取过该优惠券', icon: 'none' })
    return
  }
  if (Number(coupon.remainingCount) <= 0) {
    uni.showToast({ title: '优惠券已领完', icon: 'none' })
    return
  }
  receiveCoupon(coupon)
}

// 加载商品列表(2.9.3 / 2.9.6 通过 keyword 参数区分)
const loadProductList = async (isLoadMore = false) => {
  if (!merchantId.value) return
  const params = {
    sort: activeSort.value,
    page: currentPage.value,
    pageSize
  }
  // 2.9.6 搜索关键词(非空时传入)
  if (keyword.value) {
    params.keyword = keyword.value
  }
  await loadMerchantProducts(merchantId.value, params, isLoadMore)
}

// 上拉加载更多
const onLoadMore = () => {
  if (productLoading.value || !hasMore.value) return
  currentPage.value++
  loadProductList(true)
}

// 下拉刷新
const onRefresh = async () => {
  refreshing.value = true
  currentPage.value = 1
  await Promise.all([
    loadMerchantHome(merchantId.value),
    loadProductList(false)
  ])
  refreshing.value = false
}

// 原生下拉刷新(uni-app 页面配置)
onPullDownRefresh(async () => {
  await onRefresh()
  uni.stopPullDownRefresh()
})

// 页面加载
onLoad((options) => {
  const id = options?.merchantId || options?.id
  if (!id) {
    uni.showToast({ title: '商家ID不能为空', icon: 'none' })
    setTimeout(goBack, 1500)
    return
  }
  merchantId.value = id
})

// 页面显示
onShow(async () => {
  if (merchantId.value && !merchantStore.merchantHome) {
    loading.value = true
    await loadMerchantHome(merchantId.value)
    loading.value = false
    // 主页加载完成后加载商品列表
    if (merchantStore.merchantHome) {
      await loadProductList(false)
    }
  }
})

// 页面卸载时清理数据
onUnload(() => {
  // 清理搜索防抖定时器
  if (searchTimer) {
    clearTimeout(searchTimer)
    searchTimer = null
  }
  resetShopData()
})
</script>

<style lang="scss" scoped>
.page-shop {
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
  transform: translateZ(0);

  .nav-back {
    width: 64rpx;
    height: 64rpx;
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: 50%;
    transition: all $duration-fast $ease-out-quart;

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
    font-size: 32rpx;
    font-weight: 600;
    color: $ink-900;
    letter-spacing: 0.5rpx;
    max-width: 400rpx;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }

  .nav-placeholder-right {
    width: 64rpx;
  }
}

.nav-placeholder {
  width: 100%;
  flex-shrink: 0;
}

// ============ 搜索栏(2.9.6) ============
.search-bar {
  display: flex;
  align-items: center;
  padding: 16rpx 24rpx;
  background: $bg-card;
  box-shadow: $shadow-xs;
  position: relative;
  z-index: 2;
}

.search-input-wrap {
  flex: 1;
  display: flex;
  align-items: center;
  height: 64rpx;
  padding: 0 20rpx;
  background: $neutral-100;
  border-radius: $radius-full;
  transition: all $duration-fast $ease-out-quart;

  &:focus-within {
    background: $bg-card;
    box-shadow: 0 0 0 2rpx rgba(255, 106, 0, 0.3);
  }

  .search-icon {
    width: 32rpx;
    height: 32rpx;
    margin-right: 12rpx;
    opacity: 0.5;
    flex-shrink: 0;
  }

  .search-input {
    flex: 1;
    font-size: 26rpx;
    color: $ink-900;
    line-height: 1.4;
  }

  .search-clear {
    width: 36rpx;
    height: 36rpx;
    border-radius: 50%;
    background: $neutral-300;
    display: flex;
    align-items: center;
    justify-content: center;
    margin-left: 12rpx;
    flex-shrink: 0;
    transition: all $duration-fast $ease-out-quart;

    &:active {
      transform: scale(0.9);
      background: $neutral-400;
    }

    .clear-icon {
      font-size: 20rpx;
      color: #FFFFFF;
      line-height: 1;
    }
  }
}

.search-cancel {
  padding: 0 20rpx;
  height: 64rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
  transition: all $duration-fast $ease-out-quart;

  &:active {
    opacity: 0.6;
  }

  .cancel-text {
    font-size: 28rpx;
    color: $text-sub;
  }
}

// placeholder 样式(uni-app 通过 placeholder-class 指定,需与 input 同级)
.search-placeholder {
  font-size: 26rpx;
  color: $text-weak;
}

// ============ 加载/空状态 ============
.loading-page, .not-found-page {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 80rpx 32rpx;
}

.loading-spinner {
  width: 64rpx;
  height: 64rpx;
  border: 6rpx solid $neutral-200;
  border-top-color: $color-primary;
  border-radius: 50%;
  animation: spin 0.8s linear infinite;
  margin-bottom: 24rpx;

  &.small {
    width: 40rpx;
    height: 40rpx;
    border-width: 4rpx;
    margin-bottom: 16rpx;
  }
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

.loading-text {
  font-size: 26rpx;
  color: $text-weak;
}

.not-found-icon {
  font-size: 120rpx;
  margin-bottom: 32rpx;
}

.not-found-title {
  font-size: 36rpx;
  font-weight: 600;
  color: $ink-900;
  margin-bottom: 12rpx;
}

.not-found-desc {
  font-size: 26rpx;
  color: $text-weak;
  margin-bottom: 48rpx;
}

.not-found-btn {
  padding: 20rpx 56rpx;
  background: $gradient-warm;
  border-radius: $radius-full;
  box-shadow: $shadow-primary;
  transition: all $duration-fast $ease-out-quart;

  &:active {
    transform: scale(0.96);
    box-shadow: $shadow-sm;
  }

  .not-found-btn-text {
    color: #FFFFFF;
    font-size: 28rpx;
    font-weight: 600;
  }
}

// ============ 商家头部 ============
.shop-header {
  position: relative;
  overflow: hidden;

  .header-bg {
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    height: 240rpx;
    background: $gradient-warm;
    &::after {
      content: '';
      position: absolute;
      bottom: -1rpx;
      left: 0;
      right: 0;
      height: 60rpx;
      background: linear-gradient(180deg, transparent, $bg-page);
    }
  }

  .header-content {
    position: relative;
    margin: 100rpx 24rpx 0;
    background: $bg-card;
    border-radius: $radius-xl;
    padding: 32rpx 28rpx;
    box-shadow: $shadow-md;
    @include gpu-accelerate;
  }
}

.shop-info {
  display: flex;
  align-items: flex-start;
}

.shop-logo-wrap {
  width: 140rpx;
  height: 140rpx;
  border-radius: $radius-lg;
  overflow: hidden;
  margin-right: 24rpx;
  flex-shrink: 0;
  border: 4rpx solid #FFFFFF;
  box-shadow: $shadow-sm;
  background: $neutral-100;
}

.shop-logo {
  width: 100%;
  height: 100%;
}

.shop-logo-default {
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  background: $gradient-warm;

  .logo-text {
    font-size: 56rpx;
    font-weight: 700;
    color: #FFFFFF;
  }
}

.shop-meta {
  flex: 1;
  min-width: 0;
}

.shop-name-row {
  display: flex;
  align-items: center;
  margin-bottom: 12rpx;

  .shop-name {
    font-size: 34rpx;
    font-weight: 700;
    color: $ink-900;
    margin-right: 16rpx;
    letter-spacing: 0.5rpx;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
    max-width: 320rpx;
  }

  .shop-status {
    padding: 4rpx 14rpx;
    border-radius: $radius-full;
    font-size: 20rpx;
    font-weight: 500;

    &.status-open {
      background: rgba(46, 196, 105, 0.12);
      color: #2EC469;
    }

    &.status-closed {
      background: rgba(255, 77, 79, 0.12);
      color: $color-primary-danger;
    }

    .status-text {
      color: inherit;
    }
  }
}

.shop-hours, .shop-address {
  display: flex;
  align-items: center;
  margin-bottom: 8rpx;
  font-size: 24rpx;
  color: $text-sub;

  .hours-icon, .address-icon {
    margin-right: 8rpx;
    font-size: 24rpx;
  }

  .hours-text, .address-text {
    flex: 1;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }
}

.shop-address {
  .address-copy {
    color: $color-primary;
    font-size: 22rpx;
    padding: 4rpx 12rpx;
    background: rgba(255, 106, 0, 0.08);
    border-radius: $radius-full;
    margin-left: 12rpx;
  }
}

.shop-intro {
  margin-top: 24rpx;
  padding-top: 24rpx;
  border-top: 2rpx solid $neutral-100;

  .intro-text {
    font-size: 26rpx;
    color: $text-sub;
    line-height: 1.6;
  }
}

.shop-stats {
  display: flex;
  align-items: center;
  justify-content: space-around;
  margin-top: 24rpx;
  padding-top: 24rpx;
  border-top: 2rpx solid $neutral-100;

  .stats-item {
    flex: 1;
    display: flex;
    flex-direction: column;
    align-items: center;

    .stats-value {
      font-size: 36rpx;
      font-weight: 700;
      color: $ink-900;
      line-height: 1;
      margin-bottom: 8rpx;
    }

    .stats-icon {
      font-size: 36rpx;
      margin-bottom: 4rpx;
    }

    .stats-label {
      font-size: 22rpx;
      color: $text-weak;
    }
  }

  .stats-divider {
    width: 2rpx;
    height: 60rpx;
    background: $neutral-200;
  }
}

// ============ 通用 Section ============
.section {
  margin: 24rpx;
  background: $bg-card;
  border-radius: $radius-xl;
  padding: 28rpx 24rpx;
  box-shadow: $shadow-sm;
}

.section-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 24rpx;

  .section-title {
    font-size: 30rpx;
    font-weight: 700;
    color: $ink-900;
    letter-spacing: 0.5rpx;
  }

  .section-more {
    font-size: 24rpx;
    color: $color-primary;
  }

  .section-count {
    font-size: 24rpx;
    color: $text-weak;
  }
}

// ============ 优惠券 ============
.coupon-scroll {
  width: 100%;
  white-space: nowrap;
}

.coupon-list {
  display: inline-flex;
  padding: 4rpx;
}

.coupon-card {
  display: inline-flex;
  align-items: stretch;
  width: 440rpx;
  margin-right: 20rpx;
  background: linear-gradient(135deg, #FFF3E8 0%, #FFE0C7 100%);
  border-radius: $radius-lg;
  overflow: hidden;
  transition: all $duration-base $ease-out-quart;

  &:active {
    transform: scale(0.98);
  }

  &.coupon-received {
    background: $neutral-100;
    opacity: 0.7;
  }
}

.coupon-left {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 24rpx 16rpx;

  .coupon-amount {
    display: flex;
    align-items: baseline;
    color: $color-primary-danger;
    margin-bottom: 8rpx;

    .amount-symbol {
      font-size: 22rpx;
      font-weight: 600;
    }

    .amount-value {
      font-size: 48rpx;
      font-weight: 700;
      line-height: 1;
    }
  }

  .coupon-condition {
    font-size: 20rpx;
    color: $color-primary-danger;
  }
}

.coupon-divider {
  width: 2rpx;
  background: rgba(255, 106, 0, 0.2);
  margin: 16rpx 0;
  border-left: 2rpx dashed rgba(255, 106, 0, 0.3);
}

.coupon-right {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 24rpx 16rpx;

  .coupon-type {
    font-size: 24rpx;
    font-weight: 600;
    color: $ink-900;
    margin-bottom: 4rpx;
  }

  .coupon-remaining {
    font-size: 20rpx;
    color: $text-weak;
    margin-bottom: 12rpx;
  }
}

.coupon-btn {
  padding: 8rpx 24rpx;
  background: $gradient-warm;
  border-radius: $radius-full;
  box-shadow: 0 4rpx 10rpx rgba(255, 106, 0, 0.25);
  transition: all $duration-fast $ease-out-quart;

  &:active {
    transform: scale(0.94);
  }

  &.coupon-btn-disabled {
    background: $neutral-300;
    box-shadow: none;
  }

  .coupon-btn-text {
    font-size: 22rpx;
    color: #FFFFFF;
    font-weight: 600;
  }
}

// ============ 推荐商品 ============
.recommend-scroll {
  width: 100%;
  white-space: nowrap;
}

.recommend-list {
  display: inline-flex;
  padding: 4rpx;
}

.recommend-card {
  display: inline-flex;
  flex-direction: column;
  width: 220rpx;
  margin-right: 20rpx;
  background: $bg-card;
  border-radius: $radius-lg;
  overflow: hidden;
  box-shadow: $shadow-xs;
  transition: all $duration-base $ease-out-quart;

  &:active {
    transform: scale(0.97);
    box-shadow: $shadow-md;
  }
}

.recommend-image, .recommend-image-default {
  width: 220rpx;
  height: 220rpx;
  background: $neutral-100;
}

.recommend-image-default {
  display: flex;
  align-items: center;
  justify-content: center;

  .default-text {
    font-size: 80rpx;
  }
}

.recommend-info {
  padding: 12rpx 14rpx;

  .recommend-title {
    display: block;
    font-size: 24rpx;
    color: $ink-800;
    line-height: 1.4;
    margin-bottom: 8rpx;
    overflow: hidden;
    text-overflow: ellipsis;
    display: -webkit-box;
    -webkit-line-clamp: 2;
    line-clamp: 2;
    -webkit-box-orient: vertical;
    white-space: normal;
  }

  .recommend-sold {
    font-size: 20rpx;
    color: $text-weak;
  }
}

// ============ 全部商品 ============
.sort-bar {
  display: flex;
  align-items: center;
  background: $neutral-50;
  border-radius: $radius-lg;
  padding: 8rpx;
  margin-bottom: 24rpx;

  .sort-item {
    flex: 1;
    text-align: center;
    padding: 14rpx 0;
    border-radius: $radius-md;
    transition: all $duration-fast $ease-out-quart;

    .sort-text {
      font-size: 26rpx;
      color: $text-sub;
      font-weight: 500;
    }

    &.sort-active {
      background: #FFFFFF;
      box-shadow: $shadow-xs;

      .sort-text {
        color: $color-primary;
        font-weight: 600;
      }
    }
  }
}

.product-list {
  display: flex;
  flex-wrap: wrap;
  gap: 20rpx;
}

.product-card {
  width: calc((100% - 20rpx) / 2);
  background: $bg-card;
  border-radius: $radius-lg;
  overflow: hidden;
  box-shadow: $shadow-xs;
  transition: all $duration-base $ease-out-quart;
  @include gpu-accelerate;

  &:active {
    transform: scale(0.97);
    box-shadow: $shadow-md;
  }
}

.product-image, .product-image-default {
  width: 100%;
  aspect-ratio: 1 / 1;
  background: $neutral-100;
}

.product-image-default {
  display: flex;
  align-items: center;
  justify-content: center;

  .default-text {
    font-size: 80rpx;
  }
}

.product-info {
  padding: 16rpx 18rpx;

  .product-title {
    display: block;
    font-size: 26rpx;
    color: $ink-800;
    line-height: 1.4;
    margin-bottom: 6rpx;
    overflow: hidden;
    text-overflow: ellipsis;
    display: -webkit-box;
    -webkit-line-clamp: 2;
    line-clamp: 2;
    -webkit-box-orient: vertical;
  }

  .product-subtitle {
    display: block;
    font-size: 22rpx;
    color: $text-weak;
    margin-bottom: 8rpx;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }

  .product-bottom {
    display: flex;
    align-items: center;
    justify-content: space-between;

    .product-sold {
      font-size: 22rpx;
      color: $text-weak;
    }

    .product-tag {
      font-size: 20rpx;
      color: $color-primary;
      padding: 2rpx 10rpx;
      background: rgba(255, 106, 0, 0.08);
      border-radius: $radius-sm;
    }
  }
}

// ============ 加载/空状态 ============
.product-loading, .product-empty {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 80rpx 0;

  .empty-icon {
    font-size: 100rpx;
    margin-bottom: 16rpx;
  }

  .empty-text {
    font-size: 26rpx;
    color: $text-weak;
  }
}

.load-more {
  text-align: center;
  padding: 32rpx 0;

  .load-more-text {
    font-size: 24rpx;
    color: $text-weak;
  }
}

// ============ 安全区 ============
.safe-bottom {
  height: constant(safe-area-inset-bottom);
  height: env(safe-area-inset-bottom);
  min-height: 40rpx;
}

// ============ 滚动容器 ============
.shop-scroll {
  flex: 1;
  height: calc(100vh - 88rpx);
  // GPU 加速
  transform: translateZ(0);
  -webkit-overflow-scrolling: touch;
}
</style>
