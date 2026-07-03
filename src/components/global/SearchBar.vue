<template>
  <view class="search-bar" :class="{ 'search-bar-fixed': fixed }">
    <!-- 左侧分类入口 -->
    <view class="category-btn" @click="handleCategory">
      <text class="icon-menu">☰</text>
      <text class="category-text">分类</text>
    </view>

    <!-- 中间搜索框 -->
    <view class="search-input" @click="handleSearch">
      <image src="/static/fonts/search.svg" class="icon-search" mode="aspectFit" />
      <text class="placeholder">搜索商品/品牌</text>
    </view>

    <!-- 右侧消息入口 -->
    <view class="message-btn" @click="handleMessage">
      <image src="/static/fonts/bell.svg" class="icon-bell" mode="aspectFit" />
      <view class="badge" v-if="unreadCount > 0">
        {{ unreadCount > 99 ? '99+' : unreadCount }}
      </view>
    </view>
  </view>
</template>

<script setup>
/**
 * 搜索栏组件
 * 功能：分类入口、搜索框、消息入口
 */
import { ref } from 'vue'

// Props定义
const props = defineProps({
  // 是否吸顶固定
  fixed: {
    type: Boolean,
    default: false
  },
  // 未读消息数量
  unreadCount: {
    type: Number,
    default: 0
  }
})

// Emits定义
const emit = defineEmits(['category', 'search', 'message'])

// 点击分类入口
const handleCategory = () => {
  emit('category')
  // 跳转到分类页面
  uni.navigateTo({
    url: '/pagesSub/goods/category/categoryHome'
  })
}

// 点击搜索框
const handleSearch = () => {
  emit('search')
  // 跳转到搜索页面
  uni.navigateTo({
    url: '/pagesSub/goods/search/searchHome'
  })
}

// 点击消息入口
const handleMessage = () => {
  emit('message')
  // 跳转到消息页面
  uni.navigateTo({
    url: '/pages/message/message'
  })
}
</script>

<style lang="scss" scoped>
// 搜索栏容器
.search-bar {
  display: flex;
  align-items: center;
  padding: 20rpx 24rpx;
  // 玻璃拟态背景(高级感)
  background: rgba(255, 255, 255, 0.92);
  backdrop-filter: blur(40rpx) saturate(180%);
  -webkit-backdrop-filter: blur(40rpx) saturate(180%);
  box-shadow: $shadow-sm;
  transition: all $duration-base $ease-out-quart;
  // GPU 加速避免滑动卡顿
  transform: translateZ(0);
  will-change: transform;
  padding-top: calc(20rpx + env(safe-area-inset-top));

  // 吸顶样式
  &.search-bar-fixed {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    z-index: 999;
    box-shadow: $shadow-md;
  }
}

// 分类入口按钮
.category-btn {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  width: 84rpx;
  height: 72rpx;
  background: linear-gradient(135deg, rgba(255, 106, 0, 0.08) 0%, rgba(255, 77, 79, 0.05) 100%);
  border-radius: $radius-md;
  transition: all $duration-fast $ease-out-quart;

  &:active {
    transform: scale(0.92);
    opacity: 0.85;
    background: linear-gradient(135deg, rgba(255, 106, 0, 0.16) 0%, rgba(255, 77, 79, 0.10) 100%);
  }

  .icon-menu {
    font-size: 30rpx;
    color: $color-primary;
    margin-bottom: 4rpx;
  }

  .category-text {
    font-size: 20rpx;
    color: $text-sub;
    font-weight: 500;
  }
}

// 搜索输入框
.search-input {
  flex: 1;
  display: flex;
  align-items: center;
  height: 72rpx;
  margin: 0 20rpx;
  padding: 0 24rpx;
  background: $neutral-100;
  border: 2rpx solid transparent;
  border-radius: $radius-full;
  transition: all $duration-fast $ease-out-quart;

  &:active {
    border-color: rgba(255, 106, 0, 0.3);
    background: #FFFFFF;
    box-shadow: 0 4rpx 16rpx rgba(255, 106, 0, 0.12);
  }

  .icon-search {
    width: 44rpx;
    height: 44rpx;
    margin-right: 12rpx;
    opacity: 0.6;
  }

  .placeholder {
    font-size: 28rpx;
    color: $text-weak;
    letter-spacing: 0.5rpx;
  }
}

// 消息入口按钮
.message-btn {
  position: relative;
  display: flex;
  align-items: center;
  justify-content: center;
  width: 80rpx;
  height: 72rpx;
  border-radius: $radius-md;
  transition: all $duration-fast $ease-out-quart;

  &:active {
    transform: scale(0.92);
    background: $neutral-100;
  }

  .icon-bell {
    width: 52rpx;
    height: 52rpx;
  }

  // 消息数量徽章
  .badge {
    position: absolute;
    top: 6rpx;
    right: 6rpx;
    min-width: 30rpx;
    height: 30rpx;
    padding: 0 8rpx;
    background: $gradient-warm;
    border-radius: $radius-full;
    font-size: 20rpx;
    color: #FFFFFF;
    text-align: center;
    line-height: 30rpx;
    font-weight: 600;
    box-shadow: 0 4rpx 10rpx rgba(255, 77, 79, 0.35);
    border: 2rpx solid #FFFFFF;
  }
}
</style>
