<template>
  <scroll-view 
    scroll-y 
    class="category-nav"
    :scroll-top="scrollTop"
    :scroll-with-animation="true"
  >
    <view 
      v-for="(item, index) in categories" 
      :key="item.categoryId"
      class="nav-item"
      :class="{ 'nav-item-active': activeId === item.categoryId }"
      @click="handleSelect(item, index)"
    >
      <text class="nav-text">{{ item.categoryName }}</text>
      <view v-if="activeId === item.categoryId" class="active-indicator"></view>
    </view>
  </scroll-view>
</template>

<script setup>
import { ref } from 'vue'

const props = defineProps({
  categories: { type: Array, default: () => [] },
  activeId: { type: Number, default: 0 }
})

const emit = defineEmits(['select'])

const scrollTop = ref(0)

const handleSelect = (item, index) => {
  emit('select', item)
  scrollTop.value = index * 100
}
</script>

<style lang="scss" scoped>
.category-nav {
  width: $category-left-width;
  height: 100%;
  flex-shrink: 0;
  background: $category-bg;
  padding: 16rpx 8rpx;
  overflow-y: auto;
  overscroll-behavior: contain;
}

.category-nav::-webkit-scrollbar {
  display: none;
}

.nav-item {
  position: relative;
  display: flex;
  align-items: center;
  justify-content: center;
  height: $category-item-height;
  margin-bottom: 8rpx;
  padding: 0 16rpx;
  border-radius: 16rpx;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  overflow: hidden;
  box-sizing: border-box;

  &:active {
    transform: scale(0.98);
  }

  .nav-text {
    font-size: 26rpx;
    color: $text-sub;
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    font-weight: 400;
    text-align: center;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }
}

.nav-item-active {
  background: $bg-card;
  box-shadow: $category-shadow-sm;

  .nav-text {
    color: $color-primary;
    font-weight: 600;
  }

  .active-indicator {
    position: absolute;
    left: 0;
    top: 50%;
    transform: translateY(-50%);
    width: 6rpx;
    height: 40rpx;
    background: linear-gradient(180deg, $color-primary 0%, $color-primary-danger 100%);
    border-radius: 0 3rpx 3rpx 0;
  }
}
</style>