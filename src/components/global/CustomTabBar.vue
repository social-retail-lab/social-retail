<template>
  <view class="custom-tabbar">
    <view 
      class="tab-item" 
      :class="{ 'tab-item-active': tabBarStore.currentIndex === index, 'tab-item-click': clickIndex === index }"
      v-for="(tab, index) in tabBarStore.tabs" 
      :key="tab.path"
      @click="handleTabClick(index)"
    >
      <view class="tab-icon-wrap">
        <text class="tab-icon">{{ tab.icon }}</text>
        <view class="badge" v-if="cartBadge > 0 && index === 2">
          {{ cartBadge > 99 ? '99+' : cartBadge }}
        </view>
      </view>
      <text class="tab-text">{{ tab.text }}</text>
    </view>
    <view class="safe-bottom"></view>
  </view>
</template>

<script setup>
import { ref, onMounted, onUnmounted, computed, watch } from 'vue'
import { useTabBarStore } from '@/store/tabBar'
import { useCartStore } from '@/store/cart'

const tabBarStore = useTabBarStore()
const cartStore = useCartStore()

const cartBadge = computed(() => cartStore.totalQuantity || 0)
const clickIndex = ref(-1)
let clickTimer = null
const isClicking = ref(false)

const updateTabIndex = () => {
  setTimeout(() => {
    tabBarStore.updateCurrentIndex()
  }, 100)
}

const handleTabClick = (index) => {
  if (isClicking.value) return
  
  isClicking.value = true
  clickIndex.value = index
  
  tabBarStore.switchTab(index)
  
  setTimeout(() => {
    clickIndex.value = -1
    isClicking.value = false
  }, 300)
}

onMounted(() => {
  updateTabIndex()
})

watch(() => tabBarStore.currentIndex, () => {
  updateTabIndex()
})

onUnmounted(() => {
  if (clickTimer) {
    clearTimeout(clickTimer)
  }
})
</script>

<style lang="scss" scoped>
.custom-tabbar {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  height: 110rpx;
  // 玻璃拟态背景(2026 流行元素)
  background: rgba(255, 255, 255, 0.88);
  backdrop-filter: blur(40rpx) saturate(180%);
  -webkit-backdrop-filter: blur(40rpx) saturate(180%);
  display: flex;
  align-items: center;
  justify-content: space-around;
  box-shadow: 0 -8rpx 32rpx rgba(0, 0, 0, 0.06);
  border-top: 2rpx solid rgba(255, 255, 255, 0.6);
  z-index: 999;
  padding-bottom: constant(safe-area-inset-bottom);
  padding-bottom: env(safe-area-inset-bottom);
  pointer-events: auto;
  // GPU 加速避免滑动卡顿
  transform: translateZ(0);
  will-change: transform;
}

.tab-item {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 100%;
  transition: all $duration-base $ease-out-quart;
  cursor: pointer;
  user-select: none;
  -webkit-user-select: none;

  &:active {
    opacity: 0.7;
    transform: scale(0.92);
  }

  &-click {
    .tab-icon-wrap {
      animation: tabClick 200ms $ease-out-back;
    }
  }

  &-active {
    .tab-icon {
      color: $color-primary;
      filter: drop-shadow(0 4rpx 8rpx rgba(255, 106, 0, 0.35));
    }

    .tab-text {
      color: $color-primary;
      font-weight: 600;
    }
  }
}

@keyframes tabClick {
  0% {
    transform: scale(1);
  }
  50% {
    transform: scale(0.85);
  }
  100% {
    transform: scale(1.1);
  }
}

.tab-icon-wrap {
  position: relative;
  margin-bottom: 4rpx;
  transition: all $duration-base $ease-out-back;
}

.tab-icon {
  font-size: 48rpx;
  color: $text-weak;
  transition: all $duration-base $ease-out-back;
  line-height: 1;

  .tab-item-active & {
    transform: translateY(-6rpx) scale(1.08);
  }
}

.tab-text {
  font-size: 22rpx;
  color: $text-weak;
  transition: all $duration-base $ease-out-quart;
  line-height: 1;
  letter-spacing: 0.5rpx;

  .tab-item-active & {
    transform: translateY(-2rpx);
  }
}

.badge {
  position: absolute;
  top: -10rpx;
  right: -22rpx;
  min-width: 32rpx;
  height: 32rpx;
  padding: 0 8rpx;
  background: $gradient-warm;
  border-radius: $radius-full;
  font-size: 20rpx;
  color: #FFFFFF;
  text-align: center;
  line-height: 32rpx;
  font-weight: 600;
  box-shadow: 0 4rpx 12rpx rgba(255, 77, 79, 0.4);
  border: 2rpx solid #FFFFFF;
  animation: badgePop 300ms $ease-out-back;
}

@keyframes badgePop {
  0% {
    transform: scale(0);
  }
  60% {
    transform: scale(1.2);
  }
  100% {
    transform: scale(1);
  }
}

.safe-bottom {
  height: constant(safe-area-inset-bottom);
  height: env(safe-area-inset-bottom);
}
</style>
