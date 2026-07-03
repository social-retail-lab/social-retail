<template>
  <view class="category-entry">
    <scroll-view
      class="category-scroll"
      scroll-x
      enable-flex
      :show-scrollbar="false"
    >
      <view
        class="category-item"
        v-for="category in categories"
        :key="category.categoryId"
        @click="handleSelect(category)"
      >
        <view class="category-icon-wrap">
          <text class="category-icon-emoji">{{ category.icon || '📦' }}</text>
        </view>
        <text class="category-name">{{ category.categoryName }}</text>
      </view>
    </scroll-view>
  </view>
</template>

<script setup>
import { ref } from 'vue'

const props = defineProps({
  categories: {
    type: Array,
    default: () => []
  }
})

const emit = defineEmits(['select'])

const handleSelect = (category) => {
  emit('select', category)

  uni.navigateTo({
    url: `/pagesSub/goods/list/list?categoryId=${category.categoryId}`
  })
}
</script>

<style lang="scss" scoped>
.category-entry {
  width: 100%;
  background: $bg-card;
  border-bottom: 1rpx solid rgba($text-weak, 0.1);
}

.category-scroll {
  width: 100%;
  white-space: nowrap;
  padding: 24rpx 0;
}

.category-item {
  display: inline-flex;
  flex-direction: column;
  align-items: center;
  width: 150rpx;
  margin-right: 16rpx;
  transition: all 0.2s ease;

  &:active {
    transform: scale(0.95);
    opacity: 0.8;
  }
}

.category-icon-wrap {
  width: 80rpx;
  height: 80rpx;
  padding: 16rpx;
  background: $bg-page-light;
  border-radius: $radius-lg;
  margin-bottom: 12rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.2s ease;

  &:active {
    background: $bg-page;
  }
}

.category-icon-emoji {
  font-size: 40rpx;
}

.category-name {
  font-size: 24rpx;
  color: $text-sub;
  text-align: center;
  max-width: 130rpx;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}
</style>