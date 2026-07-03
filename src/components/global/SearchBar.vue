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
  background: $bg-card;
  box-shadow: 0 2rpx 8rpx rgba(0, 0, 0, 0.06);
  transition: all 0.3s ease;

  // 吸顶样式
  &.search-bar-fixed {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    z-index: 999;
    box-shadow: 0 4rpx 12rpx rgba(0, 0, 0, 0.08);
  }
}

// 分类入口按钮
.category-btn {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  width: 80rpx;
  height: 72rpx;
  background: $bg-page-light;
  border-radius: $radius-base;
  transition: all 0.2s ease;

  &:active {
    transform: scale(0.95);
    opacity: 0.8;
  }

  .icon-menu {
    font-size: 32rpx;
    color: $color-primary;
    margin-bottom: 4rpx;
  }

  .category-text {
    font-size: 20rpx;
    color: $text-sub;
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
  background: $bg-card;
  border: 2rpx solid $color-primary;
  border-radius: $radius-full;
  transition: all 0.2s ease;

  &:active {
    border-color: $color-primary-danger;
    background: rgba($color-primary, 0.05);
  }

  .icon-search {
    width: 48rpx;
    height: 48rpx;
    margin-right: 12rpx;
  }

  .placeholder {
    font-size: 28rpx;
    color: $text-weak;
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
  transition: all 0.2s ease;

  &:active {
    transform: scale(0.95);
  }

  .icon-bell {
    width: 56rpx;
    height: 56rpx;
  }

  // 消息数量徽章
  .badge {
    position: absolute;
    top: 8rpx;
    right: 8rpx;
    min-width: 32rpx;
    height: 32rpx;
    padding: 0 8rpx;
    background: $color-primary-danger;
    border-radius: $radius-full;
    font-size: 20rpx;
    color: #FFFFFF;
    text-align: center;
    line-height: 32rpx;
    font-weight: 600;
  }
}
</style>
