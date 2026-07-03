<template>
  <view class="seckill-activity" v-if="seckillData">
    <!-- 秒杀标题栏 -->
    <view class="seckill-header">
      <view class="header-left">
        <text class="seckill-icon">🔥</text>
        <text class="seckill-title">限时秒杀</text>
      </view>
      <view class="header-right" @click="handleMore">
        <text class="countdown-label">距结束</text>
        <view class="countdown">
          <text class="countdown-num">{{ timeLeft.hours }}</text>
          <text class="countdown-sep">:</text>
          <text class="countdown-num">{{ timeLeft.minutes }}</text>
          <text class="countdown-sep">:</text>
          <text class="countdown-num">{{ timeLeft.seconds }}</text>
        </view>
        <text class="more-text">更多</text>
        <text class="more-icon">›</text>
      </view>
    </view>

    <!-- 秒杀商品横向滚动 -->
    <scroll-view
      class="seckill-scroll"
      scroll-x
      enable-flex
      :show-scrollbar="false"
    >
      <view
        class="seckill-item"
        v-for="goods in seckillData.goods_list"
        :key="goods.id"
        @click="handleSelectGoods(goods)"
      >
        <!-- 商品图片 -->
        <view class="goods-image-wrap">
          <image
            :src="goods.image"
            mode="aspectFill"
            class="goods-image"
            :lazy-load="true"
          />
          <!-- 售罄标签 -->
          <view class="sold-out-tag" v-if="goods.stock <= 0">
            <text>已售罄</text>
          </view>
        </view>

        <!-- 商品价格 -->
        <view class="goods-price">
          <text class="current-price">¥{{ goods.price }}</text>
          <text class="original-price">¥{{ goods.original_price }}</text>
        </view>
      </view>

      <!-- 更多按钮 -->
      <view class="seckill-more" @click="handleMore">
        <text class="more-arrow">›</text>
        <text class="more-label">更多</text>
      </view>
    </scroll-view>
  </view>
</template>

<script setup>
/**
 * 秒杀活动组件
 * 功能：秒杀倒计时、横向商品滚动、点击跳转
 */
import { ref, computed, onMounted, onUnmounted } from 'vue'

// Props定义
const props = defineProps({
  // 秒杀数据
  seckillData: {
    type: Object,
    default: null
  }
})

// Emits定义
const emit = defineEmits(['selectGoods', 'more'])

// 倒计时状态
const timeLeft = ref({
  hours: '00',
  minutes: '00',
  seconds: '00'
})

let countdownTimer = null

// 计算倒计时
const updateCountdown = () => {
  if (!props.seckillData || !props.seckillData.end_time) return

  const now = new Date().getTime()
  const end = new Date(props.seckillData.end_time).getTime()
  const diff = end - now

  if (diff <= 0) {
    timeLeft.value = {
      hours: '00',
      minutes: '00',
      seconds: '00'
    }
    // 清除定时器
    if (countdownTimer) {
      clearInterval(countdownTimer)
      countdownTimer = null
    }
    return
  }

  const hours = Math.floor(diff / (1000 * 60 * 60))
  const minutes = Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60))
  const seconds = Math.floor((diff % (1000 * 60)) / 1000)

  timeLeft.value = {
    hours: String(hours).padStart(2, '0'),
    minutes: String(minutes).padStart(2, '0'),
    seconds: String(seconds).padStart(2, '0')
  }
}

// 启动倒计时
const startCountdown = () => {
  updateCountdown()
  countdownTimer = setInterval(updateCountdown, 1000)
}

// 点击选择商品
const handleSelectGoods = (goods) => {
  emit('selectGoods', goods)
  // 跳转秒杀商品详情
  uni.navigateTo({
    url: `/pagesSub/goods/seckill/seckillDetail?id=${goods.id}`
  })
}

// 点击查看更多
const handleMore = () => {
  emit('more')
  // 跳转秒杀活动页面
  uni.navigateTo({
    url: '/pagesSub/goods/seckill/seckillHome'
  })
}

// 监听数据变化
onMounted(() => {
  if (props.seckillData) {
    startCountdown()
  }
})

// 清理定时器
onUnmounted(() => {
  if (countdownTimer) {
    clearInterval(countdownTimer)
    countdownTimer = null
  }
})
</script>

<style lang="scss" scoped>
// 秒杀活动容器
.seckill-activity {
  width: 100%;
  background: $bg-card;
  margin-bottom: 16rpx;
}

// 秒杀标题栏
.seckill-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 24rpx;
  background: linear-gradient(135deg, $color-primary 0%, $color-primary-danger 100%);

  .header-left {
    display: flex;
    align-items: center;

    .seckill-icon {
      font-size: 36rpx;
      margin-right: 8rpx;
    }

    .seckill-title {
      font-size: 32rpx;
      font-weight: 700;
      color: #FFFFFF;
    }
  }

  .header-right {
    display: flex;
    align-items: center;

    .countdown-label {
      font-size: 24rpx;
      color: rgba(255, 255, 255, 0.9);
      margin-right: 12rpx;
    }

    .countdown {
      display: flex;
      align-items: center;

      .countdown-num {
        display: inline-block;
        width: 40rpx;
        height: 40rpx;
        background: #FFFFFF;
        border-radius: 8rpx;
        font-size: 28rpx;
        font-weight: 700;
        color: $color-primary-danger;
        text-align: center;
        line-height: 40rpx;
      }

      .countdown-sep {
        font-size: 28rpx;
        font-weight: 700;
        color: #FFFFFF;
        margin: 0 6rpx;
      }
    }

    .more-text {
      font-size: 24rpx;
      color: rgba(255, 255, 255, 0.9);
      margin-left: 20rpx;
    }

    .more-icon {
      font-size: 28rpx;
      color: rgba(255, 255, 255, 0.9);
      margin-left: 4rpx;
    }
  }
}

// 秒杀商品横向滚动
.seckill-scroll {
  display: flex;
  white-space: nowrap;
  padding: 24rpx;
  background: linear-gradient(135deg, $color-primary 0%, $color-primary-danger 100%);
}

// 秒杀商品项
.seckill-item {
  display: inline-flex;
  flex-direction: column;
  width: 200rpx;
  margin-right: 20rpx;
  background: #FFFFFF;
  border-radius: $radius-lg;
  overflow: hidden;
  box-shadow: 0 4rpx 12rpx rgba(0, 0, 0, 0.1);
  transition: all 0.2s ease;

  &:active {
    transform: scale(0.98);
  }

  // 商品图片容器
  .goods-image-wrap {
    position: relative;
    width: 100%;
    height: 200rpx;
    overflow: hidden;

    .goods-image {
      width: 100%;
      height: 100%;
    }

    // 售罄标签
    .sold-out-tag {
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background: rgba(0, 0, 0, 0.5);
      display: flex;
      align-items: center;
      justify-content: center;

      text {
        font-size: 28rpx;
        color: #FFFFFF;
        font-weight: 600;
      }
    }
  }

  // 商品价格
  .goods-price {
    padding: 16rpx;
    display: flex;
    flex-direction: column;

    .current-price {
      font-size: 32rpx;
      font-weight: 700;
      color: $color-primary-danger;
      margin-bottom: 8rpx;
    }

    .original-price {
      font-size: 22rpx;
      color: $text-weak;
      text-decoration: line-through;
    }
  }
}

// 更多按钮
.seckill-more {
  display: inline-flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  width: 200rpx;
  height: 232rpx;
  background: transparent;
  border-radius: $radius-lg;
  flex-shrink: 0;
  margin-top: 0;
  margin-right: 20rpx;
  transition: all 0.2s ease;
  border: 2rpx dashed rgba(255, 255, 255, 0.6);

  &:active {
    background: rgba(255, 255, 255, 0.1);
    border-color: rgba(255, 255, 255, 0.9);
  }

  .more-arrow {
    font-size: 48rpx;
    color: #FFFFFF;
    margin-bottom: 12rpx;
    font-weight: 300;
  }

  .more-label {
    font-size: 26rpx;
    color: #FFFFFF;
    opacity: 0.9;
  }
}
</style>
