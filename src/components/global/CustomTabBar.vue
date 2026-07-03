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
  height: 100rpx;
  background: $bg-card;
  display: flex;
  align-items: center;
  justify-content: space-around;
  box-shadow: 0 -4rpx 20rpx rgba(0, 0, 0, 0.06);
  z-index: 999;
  padding-bottom: constant(safe-area-inset-bottom);
  padding-bottom: env(safe-area-inset-bottom);
  pointer-events: auto;
}

.tab-item {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 100%;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  cursor: pointer;
  user-select: none;
  -webkit-user-select: none;

  &:active {
    opacity: 0.7;
  }

  &-click {
    .tab-icon-wrap {
      animation: tabClick 0.2s ease;
    }
  }

  &-active {
    .tab-icon {
      color: $color-primary;
      filter: drop-shadow(0 2rpx 4rpx rgba($color-primary, 0.3));
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
    transform: scale(0.9);
  }
  100% {
    transform: scale(1.05);
  }
}

.tab-icon-wrap {
  position: relative;
  margin-bottom: 4rpx;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.tab-icon {
  font-size: 52rpx;
  color: $text-weak;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  line-height: 1;

  .tab-item-active & {
    transform: translateY(-4rpx) scale(1.05);
  }
}

.tab-text {
  font-size: 24rpx;
  color: $text-weak;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  line-height: 1;

  .tab-item-active & {
    transform: translateY(-2rpx);
  }
}

.badge {
  position: absolute;
  top: -12rpx;
  right: -24rpx;
  min-width: 36rpx;
  height: 36rpx;
  padding: 0 10rpx;
  background: linear-gradient(135deg, $color-primary-danger 0%, $color-primary 100%);
  border-radius: $radius-full;
  font-size: 20rpx;
  color: #FFFFFF;
  text-align: center;
  line-height: 36rpx;
  font-weight: 600;
  box-shadow: 0 4rpx 12rpx rgba($color-primary-danger, 0.3);
  animation: badgePop 0.3s ease;
}

@keyframes badgePop {
  0% {
    transform: scale(0);
  }
  50% {
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
