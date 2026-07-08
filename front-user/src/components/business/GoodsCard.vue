// 用于商品推荐列表展示的商品卡片组件

<template>
  <view class="goods-card" @click="handleClick">
    <!-- 商品图片 -->
    <view class="goods-image-wrap">
      <image
        :src="goods.productImage"
        mode="aspectFill"
        class="goods-image"
        :lazy-load="true"
      />

      <!-- 商品标签 -->
      <view class="goods-tags" v-if="goods.tags && goods.tags.length > 0">
        <text
          v-for="(tag, index) in goods.tags.slice(0, 2)"
          :key="index"
          class="tag-item"
        >{{ tag }}</text>
      </view>

      <!-- 售罄标签 -->
      <view class="sold-out-overlay" v-if="goods.stock !== undefined && goods.stock !== null && goods.stock <= 0">
        <text class="sold-out-text">已售罄</text>
      </view>
    </view>

    <!-- 商品信息 -->
    <view class="goods-info">
      <!-- 商品名称 -->
      <text class="goods-title">{{ goods.productName }}</text>

      <!-- 价格和销量 -->
      <view class="goods-bottom">
        <!-- 价格 -->
        <view class="price-wrap">
          <text class="price-symbol">¥</text>
          <text class="price-value">{{ goods.price }}</text>
        </view>

        <!-- 销量 -->
        <view class="sales-wrap" v-if="goods.soldCount !== undefined && goods.soldCount !== null">
          <text class="sales-count">已售{{ goods.soldCount }}件</text>
        </view>
      </view>

      <!-- 原价 -->
      <view class="goods-meta">
        <text class="original-price" v-if="goods.originalPrice">
          ¥{{ goods.originalPrice }}
        </text>
      </view>
    </view>
  </view>
</template>

<script setup>
/**
 * 商品卡片组件
 * 功能：商品图片、名称、价格、分销佣金展示
 */
import { ref } from 'vue'

// Props定义
const props = defineProps({
  // 商品数据
  goods: {
    type: Object,
    required: true,
    default: () => ({
      productId: 0,
      productName: '',
      productImage: '',
      price: 0,
      originalPrice: 0,
      commission: 0,
      soldCount: 0,
      tags: [],
      stock: 999
    })
  }
})

// Emits定义
const emit = defineEmits(['click'])

// 点击商品卡片
const handleClick = () => {
  emit('click', props.goods)
}
</script>

<style lang="scss" scoped>
// 商品卡片容器
.goods-card {
  background: $bg-card;
  border-radius: $radius-xl;
  overflow: hidden;
  box-shadow: $shadow-sm;
  transition: transform $duration-base $ease-out-quart, box-shadow $duration-base $ease-out-quart;
  // GPU 加速
  transform: translateZ(0);

  &:active {
    transform: scale(0.97) translateY(2rpx);
    box-shadow: $shadow-xs;
  }
}

// 商品图片容器
.goods-image-wrap {
  position: relative;
  width: 100%;
  padding-top: 100%; // 1:1 比例
  overflow: hidden;
  background: $neutral-100;

  .goods-image {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    transition: transform $duration-slow $ease-out-quart;
  }

  // 商品标签
  .goods-tags {
    position: absolute;
    top: 0;
    left: 16rpx;
    display: flex;
    z-index: 1;
    flex-direction: column;
  }

  .tag-item {
    padding: 8rpx 16rpx;
    background: $gradient-warm;
    border-radius: 0 0 $radius-base $radius-base;
    font-size: 20rpx;
    color: #FFFFFF;
    font-weight: 600;
    letter-spacing: 0.5rpx;
    box-shadow: 0 4rpx 10rpx rgba(255, 77, 79, 0.25);

    &:not(:first-child) {
      margin-top: 8rpx;
    }
  }

  // 售罄遮罩
  .sold-out-overlay {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(0, 0, 0, 0.55);
    backdrop-filter: blur(8rpx);
    -webkit-backdrop-filter: blur(8rpx);
    display: flex;
    align-items: center;
    justify-content: center;
    z-index: 2;

    .sold-out-text {
      font-size: 28rpx;
      color: #FFFFFF;
      font-weight: 600;
      padding: 12rpx 28rpx;
      border: 2rpx solid rgba(255, 255, 255, 0.4);
      border-radius: $radius-full;
      letter-spacing: 2rpx;
    }
  }
}

// 商品信息
.goods-info {
  padding: 20rpx 18rpx 18rpx;
}

// 商品标题
.goods-title {
  display: block;
  font-size: 28rpx;
  color: $ink-800;
  line-height: 1.4;
  margin-bottom: 12rpx;
  overflow: hidden;
  text-overflow: ellipsis;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  line-clamp: 2;
  -webkit-box-orient: vertical;
  letter-spacing: 0.3rpx;
}

// 商品底部（价格和销量）
.goods-bottom {
  display: flex;
  align-items: baseline;
  justify-content: space-between;
  margin-bottom: 8rpx;

  // 价格容器
  .price-wrap {
    display: flex;
    align-items: baseline;

    .price-symbol {
      font-size: 22rpx;
      color: $color-primary-danger;
      font-weight: 600;
    }

    .price-value {
      font-size: 36rpx;
      color: $color-primary-danger;
      font-weight: 700;
      line-height: 1;
      letter-spacing: -0.5rpx;
    }
  }

  // 销量
  .sales-wrap {
    .sales-count {
      font-size: 22rpx;
      color: $text-weak;
    }
  }
}

// 商品元信息（原价的删除线价格）
.goods-meta {
  display: flex;
  align-items: center;
  justify-content: space-between;

  .original-price {
    font-size: 22rpx;
    color: $text-weak;
    text-decoration: line-through;
  }
}
</style>
