<template>
  <view class="banner-swiper">
    <!-- 轮播图 -->
    <swiper
      class="swiper"
      :indicator-dots="true"
      :indicator-color="'rgba(255, 255, 255, 0.5)'"
      :indicator-active-color="'#FFFFFF'"
      :autoplay="autoplay"
      :interval="interval"
      :duration="300"
      :circular="true"
      :current="current"
      @change="handleChange"
    >
      <swiper-item
        v-for="(banner, index) in banners"
        :key="banner.id"
        class="swiper-item"
        @click="handleClick(banner, index)"
      >
        <image
          :src="banner.image"
          mode="aspectFill"
          class="banner-image"
          :lazy-load="true"
        />
      </swiper-item>
    </swiper>

    <!-- 骨架屏加载占位 -->
    <view class="skeleton" v-if="loading && banners.length === 0">
      <view class="skeleton-item"></view>
    </view>
  </view>
</template>

<script setup>
/**
 * 轮播图组件
 * 功能：Banner轮播、自动播放、手动滑动、点击跳转
 */
import { ref } from 'vue'

// Props定义
const props = defineProps({
  // Banner列表
  banners: {
    type: Array,
    default: () => []
  },
  // 高度
  height: {
    type: String,
    default: '400rpx'
  },
  // 是否自动播放
  autoplay: {
    type: Boolean,
    default: true
  },
  // 自动播放间隔（毫秒）
  interval: {
    type: Number,
    default: 3000
  },
  // 加载状态
  loading: {
    type: Boolean,
    default: false
  }
})

// Emits定义
const emit = defineEmits(['click', 'change'])

// 当前轮播索引
const current = ref(0)

// 轮播切换事件
const handleChange = (e) => {
  current.value = e.detail.current
  emit('change', e.detail.current)
}

// 点击Banner
const handleClick = (banner, index) => {
  emit('click', banner, index)

  // 根据类型进行跳转
  switch (banner.type) {
    case 'goods':
      // 商品详情
      uni.navigateTo({
        url: `/pagesSub/goods/detail/goodsDetail?id=${banner.target_id}`
      })
      break
    case 'activity':
      // 活动页面
      uni.navigateTo({
        url: `/pagesSub/goods/seckill/seckillDetail?id=${banner.target_id}`
      })
      break
    case 'coupon':
      // 优惠券页面
      uni.navigateTo({
        url: `/pagesSub/promotion/coupon/couponCenter?id=${banner.target_id}`
      })
      break
    case 'url':
      // 外部链接
      if (banner.target_id) {
        // #ifdef H5
        window.location.href = banner.target_id
        // #endif
      }
      break
    default:
      break
  }
}
</script>

<style lang="scss" scoped>
// 轮播图容器
.banner-swiper {
  position: relative;
  width: 100%;
  height: 400rpx;
  overflow: hidden;
}

// 轮播图
.swiper {
  width: 100%;
  height: 100%;

  .swiper-item {
    width: 100%;
    height: 100%;

    .banner-image {
      width: 100%;
      height: 100%;
    }
  }
}

// 骨架屏
.skeleton {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;

  .skeleton-item {
    width: 100%;
    height: 100%;
    background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
    background-size: 200% 100%;
    animation: shimmer 1.5s infinite;
  }
}

@keyframes shimmer {
  0% {
    background-position: 200% 0;
  }
  100% {
    background-position: -200% 0;
  }
}
</style>
