<template>
  <view class="seckill-activity" v-if="seckillData">
    <!-- 秒杀标题栏 -->
    <view class="seckill-header">
      <view class="header-left">
        <view class="title-wrap">
          <text class="seckill-icon">⚡</text>
          <text class="seckill-title">限时秒杀</text>
        </view>
        <view class="seckill-status-tag" v-if="seckillData.statusText">
          <text>{{ seckillData.statusText }}</text>
        </view>
      </view>
      <view class="header-right">
        <view class="countdown-wrap" v-if="seckillData.countdownSeconds > 0">
          <text class="countdown-label">{{ countdownLabel }}</text>
          <view class="countdown">
            <text class="countdown-num">{{ timeLeft.hours }}</text>
            <text class="countdown-sep">:</text>
            <text class="countdown-num">{{ timeLeft.minutes }}</text>
            <text class="countdown-sep">:</text>
            <text class="countdown-num">{{ timeLeft.seconds }}</text>
          </view>
        </view>
        <view class="more-link" @click="handleMore">
          <text class="more-text">更多</text>
          <text class="more-icon">›</text>
        </view>
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
          <!-- 预热中标签 -->
          <view class="preheat-tag" v-else-if="!goods.canBuy">
            <text>即将开始</text>
          </view>
        </view>

        <!-- 商品信息 -->
        <view class="goods-info">
          <text class="goods-name">{{ goods.name }}</text>
          <view class="goods-price">
            <text class="price-symbol">¥</text>
            <text class="current-price">{{ goods.price }}</text>
            <text class="original-price">¥{{ goods.original_price }}</text>
          </view>
          <!-- 库存进度条 -->
          <view class="progress-bar" v-if="goods.stock > 0 && goods.canBuy">
            <view class="progress-track">
              <view class="progress-fill" :style="{ width: getProgress(goods) + '%' }"></view>
            </view>
            <text class="progress-text">已抢{{ getProgress(goods) }}%</text>
          </view>
          <!-- 抢购按钮 -->
          <view class="buy-btn" :class="{ 'disabled': goods.stock <= 0 || !goods.canBuy }">
            <text>{{ getButtonText(goods) }}</text>
          </view>
        </view>
      </view>
    </scroll-view>
  </view>
</template>

<script setup>
/**
 * 秒杀活动组件（首页横向滚动展示）
 * 功能：秒杀倒计时、横向商品滚动、点击跳转
 * 数据来源：useHome.js 中 loadCurrentSeckillActivity + loadCurrentSeckillProducts
 */
import { ref, computed, onMounted, onUnmounted, watch } from 'vue'

// Props定义
const props = defineProps({
  // 秒杀数据（包含活动信息 + goods_list 商品列表）
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
// 剩余秒数（基于后端 countdownSeconds 递减）
let remainSeconds = 0

// 倒计时标签：预热中显示"距开始"，进行中显示"距结束"
const countdownLabel = computed(() => {
  if (!props.seckillData) return '距结束'
  // status: 0=预热中, 1=进行中, 2=已结束
  if (props.seckillData.status === 0) return '距开始'
  if (props.seckillData.status === 1) return '距结束'
  return '已结束'
})

// 计算抢购进度（已售数量 / 总库存）
const getProgress = (goods) => {
  const sold = Number(goods.soldCount) || 0
  const stock = Number(goods.stock) || 0
  const total = sold + stock
  if (total <= 0) return 0
  const progress = Math.round((sold / total) * 100)
  return Math.min(Math.max(progress, 0), 100)
}

// 获取按钮文字
const getButtonText = (goods) => {
  if (goods.stock <= 0) return '已抢光'
  if (!goods.canBuy) return '即将开始'
  return '马上抢'
}

// 计算倒计时
const updateCountdown = () => {
  if (remainSeconds <= 0) {
    timeLeft.value = { hours: '00', minutes: '00', seconds: '00' }
    if (countdownTimer) {
      clearInterval(countdownTimer)
      countdownTimer = null
    }
    return
  }

  const hours = Math.floor(remainSeconds / 3600)
  const minutes = Math.floor((remainSeconds % 3600) / 60)
  const seconds = remainSeconds % 60

  timeLeft.value = {
    hours: String(hours).padStart(2, '0'),
    minutes: String(minutes).padStart(2, '0'),
    seconds: String(seconds).padStart(2, '0')
  }
  remainSeconds--
}

// 启动倒计时
const startCountdown = () => {
  if (!props.seckillData || !props.seckillData.countdownSeconds) return
  remainSeconds = Number(props.seckillData.countdownSeconds) || 0
  updateCountdown()
  countdownTimer = setInterval(updateCountdown, 1000)
}

// 停止倒计时
const stopCountdown = () => {
  if (countdownTimer) {
    clearInterval(countdownTimer)
    countdownTimer = null
  }
}

// 点击选择商品
const handleSelectGoods = (goods) => {
  emit('selectGoods', goods)
  // 跳转秒杀活动页面
  uni.navigateTo({
    url: '/pagesSub/goods/seckill/seckillHome'
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

// 监听数据变化，重新启动倒计时
watch(() => props.seckillData, (newVal) => {
  stopCountdown()
  if (newVal && newVal.countdownSeconds > 0) {
    startCountdown()
  }
}, { immediate: false })

onMounted(() => {
  if (props.seckillData) {
    startCountdown()
  }
})

onUnmounted(() => {
  stopCountdown()
})
</script>

<style lang="scss" scoped>
// 秒杀活动容器
.seckill-activity {
  width: 100%;
  background: $bg-card;
  margin-bottom: 16rpx;
  border-radius: $radius-lg;
  overflow: hidden;
  box-shadow: 0 2rpx 12rpx rgba(0, 0, 0, 0.04);
}

// 秒杀标题栏
.seckill-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 24rpx 24rpx 20rpx;
  background: linear-gradient(135deg, #FF6A00 0%, #FF4D4F 100%);
  position: relative;

  // 装饰光效
  &::before {
    content: '';
    position: absolute;
    top: -40rpx;
    right: -20rpx;
    width: 200rpx;
    height: 200rpx;
    background: radial-gradient(circle, rgba(255, 255, 255, 0.15) 0%, transparent 70%);
    border-radius: 50%;
    pointer-events: none;
  }

  .header-left {
    display: flex;
    align-items: center;
    flex: 1;
    min-width: 0;

    .title-wrap {
      display: flex;
      align-items: center;
      flex-shrink: 0;

      .seckill-icon {
        font-size: 32rpx;
        margin-right: 8rpx;
        filter: drop-shadow(0 2rpx 4rpx rgba(0, 0, 0, 0.15));
      }

      .seckill-title {
        font-size: 34rpx;
        font-weight: 800;
        color: #FFFFFF;
        letter-spacing: 2rpx;
        text-shadow: 0 2rpx 4rpx rgba(0, 0, 0, 0.1);
      }
    }

    .seckill-status-tag {
      margin-left: 16rpx;
      padding: 4rpx 14rpx;
      background: rgba(255, 255, 255, 0.25);
      border-radius: $radius-full;
      backdrop-filter: blur(4rpx);

      text {
        font-size: 20rpx;
        color: #FFFFFF;
        font-weight: 600;
      }
    }
  }

  .header-right {
    display: flex;
    align-items: center;
    flex-shrink: 0;

    .countdown-wrap {
      display: flex;
      align-items: center;

      .countdown-label {
        font-size: 22rpx;
        color: rgba(255, 255, 255, 0.9);
        margin-right: 8rpx;
      }

      .countdown {
        display: flex;
        align-items: center;

        .countdown-num {
          display: inline-block;
          min-width: 36rpx;
          height: 36rpx;
          padding: 0 6rpx;
          background: rgba(0, 0, 0, 0.35);
          border-radius: 6rpx;
          font-size: 24rpx;
          font-weight: 700;
          color: #FFFFFF;
          text-align: center;
          line-height: 36rpx;
          box-shadow: inset 0 1rpx 2rpx rgba(0, 0, 0, 0.2);
        }

        .countdown-sep {
          font-size: 24rpx;
          font-weight: 700;
          color: #FFFFFF;
          margin: 0 4rpx;
          line-height: 36rpx;
        }
      }
    }

    .more-link {
      display: flex;
      align-items: center;
      margin-left: 16rpx;
      padding: 6rpx 12rpx 6rpx 16rpx;
      background: rgba(255, 255, 255, 0.2);
      border-radius: $radius-full;
      transition: all 0.2s ease;

      &:active {
        background: rgba(255, 255, 255, 0.35);
        transform: scale(0.96);
      }

      .more-text {
        font-size: 22rpx;
        color: #FFFFFF;
        font-weight: 500;
      }

      .more-icon {
        font-size: 24rpx;
        color: #FFFFFF;
        margin-left: 2rpx;
        line-height: 1;
      }
    }
  }
}

// 秒杀商品横向滚动
.seckill-scroll {
  display: flex;
  white-space: nowrap;
  padding: 20rpx 16rpx 24rpx;
  background: $bg-card;
}

// 秒杀商品项
.seckill-item {
  display: inline-flex;
  flex-direction: column;
  width: 200rpx;
  margin-right: 16rpx;
  background: $bg-card;
  border-radius: $radius-base;
  overflow: hidden;
  transition: all 0.2s ease;

  &:active {
    transform: scale(0.97);
  }

  // 商品图片容器
  .goods-image-wrap {
    position: relative;
    width: 100%;
    height: 200rpx;
    overflow: hidden;
    background: $bg-page-light;
    border-radius: $radius-base $radius-base 0 0;

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
      background: rgba(0, 0, 0, 0.55);
      display: flex;
      align-items: center;
      justify-content: center;

      text {
        font-size: 26rpx;
        color: #FFFFFF;
        font-weight: 600;
        padding: 8rpx 20rpx;
        background: rgba($text-sub, 0.85);
        border-radius: $radius-full;
      }
    }

    // 预热中标签
    .preheat-tag {
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background: rgba(0, 0, 0, 0.45);
      display: flex;
      align-items: center;
      justify-content: center;

      text {
        font-size: 24rpx;
        color: #FFFFFF;
        font-weight: 600;
        padding: 6rpx 18rpx;
        background: linear-gradient(135deg, #FF6A00, #FF4D4F);
        border-radius: $radius-full;
        box-shadow: 0 2rpx 8rpx rgba(255, 77, 79, 0.3);
      }
    }
  }

  // 商品信息
  .goods-info {
    padding: 12rpx 14rpx 16rpx;
    display: flex;
    flex-direction: column;

    .goods-name {
      font-size: 24rpx;
      color: $text-main;
      line-height: 1.3;
      overflow: hidden;
      text-overflow: ellipsis;
      white-space: nowrap;
      margin-bottom: 8rpx;
    }

    .goods-price {
      display: flex;
      align-items: baseline;
      margin-bottom: 10rpx;

      .price-symbol {
        font-size: 22rpx;
        font-weight: 600;
        color: $color-primary-danger;
        margin-right: 2rpx;
      }

      .current-price {
        font-size: 32rpx;
        font-weight: 800;
        color: $color-primary-danger;
        line-height: 1;
      }

      .original-price {
        font-size: 20rpx;
        color: $text-weak;
        text-decoration: line-through;
        margin-left: 8rpx;
      }
    }

    // 库存进度条
    .progress-bar {
      display: flex;
      align-items: center;
      margin-bottom: 10rpx;

      .progress-track {
        flex: 1;
        height: 12rpx;
        background: rgba($color-primary-danger, 0.1);
        border-radius: $radius-full;
        overflow: hidden;
        margin-right: 8rpx;

        .progress-fill {
          height: 100%;
          background: linear-gradient(90deg, #FF9500 0%, #FF4D4F 100%);
          border-radius: $radius-full;
          transition: width 0.3s ease;
        }
      }

      .progress-text {
        font-size: 18rpx;
        color: $color-primary-danger;
        font-weight: 600;
        flex-shrink: 0;
      }
    }

    // 抢购按钮
    .buy-btn {
      display: flex;
      align-items: center;
      justify-content: center;
      height: 44rpx;
      background: linear-gradient(135deg, #FF6A00 0%, #FF4D4F 100%);
      border-radius: $radius-full;
      box-shadow: 0 2rpx 6rpx rgba(255, 77, 79, 0.25);

      text {
        font-size: 22rpx;
        color: #FFFFFF;
        font-weight: 700;
        letter-spacing: 1rpx;
      }

      &.disabled {
        background: $bg-page-light;
        box-shadow: none;

        text {
          color: $text-weak;
          font-weight: 500;
        }
      }

      &:not(.disabled):active {
        opacity: 0.85;
      }
    }
  }
}
</style>
