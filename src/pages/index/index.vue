<template>
  <view class="page-index">
    <!-- 搜索栏 - 始终固定在顶部 -->
    <search-bar
      :fixed="true"
      :unread-count="unreadCount"
      @category="handleCategory"
      @search="handleSearch"
      @message="handleMessage"
    />

    <!-- 页面内容 -->
    <scroll-view
      class="page-content"
      scroll-y
      enable-back-to-top
      :refresher-enabled="true"
      :refresher-triggered="refreshing"
      @scroll="handleScroll"
      @refresherrefresh="handleRefresh"
      @scrolltolower="handleScrollToLower"
    >
      <!-- 轮播图 -->
      <banner-swiper
        :banners="banners"
        :loading="loading"
        @click="handleBannerClick"
      />

      <!-- 分类快捷入口 -->
      <category-entry
        :categories="categories"
        @select="handleCategorySelect"
      />

      <!-- 限时秒杀活动 -->
      <seckill-activity
        v-if="seckillData"
        :seckill-data="seckillData"
        @selectGoods="handleSeckillGoods"
        @more="handleSeckillMore"
      />

      <!-- 商品推荐列表 -->
      <goods-recommend
        :goods-list="recommendGoods"
        :loading="loading"
        :finished="finished"
        @selectGoods="handleGoodsSelect"
        @loadMore="handleLoadMore"
        @more="handleRecommendMore"
      />

      <!-- 底部安全区域 -->
      <view class="safe-bottom"></view>
    </scroll-view>

    <!-- 自定义TabBar -->
    <custom-tab-bar />
  </view>
</template>

<script setup>
/**
 * 首页页面
 * 功能：轮播图展示、分类快捷入口、限时秒杀活动入口、商品推荐列表
 */
import { ref, onMounted } from 'vue'
import { useHome } from '@/hooks/useHome'

// 导入组件
import SearchBar from '@/components/global/SearchBar.vue'
import BannerSwiper from '@/components/global/BannerSwiper.vue'
import CategoryEntry from '@/components/business/CategoryEntry.vue'
import SeckillActivity from '@/components/business/SeckillActivity.vue'
import GoodsRecommend from '@/components/business/GoodsRecommend.vue'
import CustomTabBar from '@/components/global/CustomTabBar.vue'

// 使用首页Hook
const {
  banners,
  categories,
  seckillData,
  recommendGoods,
  loading,
  finished,
  unreadCount,
  fetchHomeData,
  loadMoreGoods,
  refreshHomeData,
  onPageScroll
} = useHome()

// 下拉刷新状态
const refreshing = ref(false)

// ============ 页面生命周期 ============

onMounted(() => {
  // 获取首页数据
  fetchHomeData()
})

// ============ 事件处理 ============

// 页面滚动
const handleScroll = (e) => {
  const scrollTop = e.detail.scrollTop
  onPageScroll(scrollTop)
}

// 下拉刷新
const handleRefresh = async () => {
  refreshing.value = true
  await refreshHomeData()
  refreshing.value = false
}

// 滚动到底部加载更多
const handleScrollToLower = () => {
  loadMoreGoods()
}

// 加载更多商品
const handleLoadMore = () => {
  loadMoreGoods()
}

// 点击分类入口
const handleCategory = () => {
  // SearchBar组件会处理跳转
}

// 点击搜索框
const handleSearch = () => {
  // SearchBar组件会处理跳转
}

// 点击消息入口
const handleMessage = () => {
  // SearchBar组件会处理跳转
}

// 点击Banner
const handleBannerClick = (banner, index) => {
  console.log('点击Banner', banner, index)
  // 跳转逻辑在BannerSwiper组件内处理
}

// 选择分类
const handleCategorySelect = (category) => {
  console.log('选择分类', category)
  // 跳转逻辑在CategoryEntry组件内处理
}

// 选择秒杀商品
const handleSeckillGoods = (goods) => {
  console.log('选择秒杀商品', goods)
  // 跳转逻辑在SeckillActivity组件内处理
}

// 查看更多秒杀
const handleSeckillMore = () => {
  console.log('查看更多秒杀')
  // 跳转逻辑在SeckillActivity组件内处理
}

// 选择商品
const handleGoodsSelect = (goods) => {
  console.log('选择商品', goods)
  // 跳转逻辑在GoodsRecommend组件内处理
}

// 查看更多推荐商品
const handleRecommendMore = () => {
  console.log('查看更多推荐商品')
  // 跳转逻辑在GoodsRecommend组件内处理
}
</script>

<style lang="scss" scoped>
// 页面容器
.page-index {
  min-height: 100vh;
  background-color: $bg-page;
  display: flex;
  flex-direction: column;
}

// 页面内容区域
.page-content {
  flex: 1;
  height: calc(100vh - 112rpx - 110rpx); // 减去搜索栏和TabBar高度
  background-color: $bg-page;
  padding-top: 112rpx; // 防止内容被固定搜索栏遮挡
  // GPU 加速滚动
  transform: translateZ(0);
  -webkit-overflow-scrolling: touch;
}

// 底部安全区域
.safe-bottom {
  height: constant(safe-area-inset-bottom);
  height: env(safe-area-inset-bottom);
  // 增加 TabBar 上方间距
  min-height: 40rpx;
}
</style>
