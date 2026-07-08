<template>
  <view class="goods-recommend">
    <!-- 标题栏 -->
    <view class="recommend-header">
      <text class="header-title">猜你喜欢</text>
      <view class="header-right" @click="handleMore">
        <text class="more-text">查看更多</text>
        <text class="more-icon">›</text>
      </view>
    </view>

    <!-- 商品网格列表 -->
    <view class="goods-grid">
      <view
        class="goods-item"
        v-for="goods in goodsList"
        :key="goods.productId"
        @click="handleSelectGoods(goods)"
      >
        <!-- 商品卡片 -->
        <goods-card :goods="goods" />
      </view>
    </view>

    <!-- 加载状态 -->
    <view class="loading-status" v-if="goodsList.length > 0">
      <!-- 加载中 -->
      <view class="loading" v-if="loading && !finished">
        <text class="loading-text">加载中...</text>
      </view>

      <!-- 没有更多了 -->
      <view class="no-more" v-if="finished">
        <view class="divider"></view>
        <text class="no-more-text">我是有底线的</text>
        <view class="divider"></view>
      </view>
    </view>

    <!-- 空状态 -->
    <empty-view
      v-if="!loading && goodsList.length === 0"
      text="暂无推荐商品"
    />
  </view>
</template>

<script setup>
/**
 * 商品推荐组件
 * 功能：双列商品网格、下拉刷新、上拉加载更多
 */
import { ref } from 'vue'
import GoodsCard from '@/components/business/GoodsCard.vue'
import EmptyView from '@/components/global/EmptyView.vue'

// Props定义
const props = defineProps({
  // 商品列表
  goodsList: {
    type: Array,
    default: () => []
  },
  // 加载状态
  loading: {
    type: Boolean,
    default: false
  },
  // 是否加载完成
  finished: {
    type: Boolean,
    default: false
  }
})

// Emits定义
const emit = defineEmits(['selectGoods', 'loadMore', 'refresh', 'more'])

// 选择商品
const handleSelectGoods = (goods) => {
  emit('selectGoods', goods)
  // 跳转商品详情
  uni.navigateTo({
    url: `/pagesSub/goods/detail/goodsDetail?productId=${goods.productId}`
  })
}

// 查看更多
const handleMore = () => {
  emit('more')
  // 跳转商品列表或搜索结果页
  uni.navigateTo({
    url: '/pagesSub/goods/list/list'
  })
}
</script>

<style lang="scss" scoped>
// 商品推荐容器
.goods-recommend {
  width: 100%;
  background: $bg-page;
  padding-bottom: constant(safe-area-inset-bottom);
  padding-bottom: env(safe-area-inset-bottom);
}

// 标题栏
.recommend-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 32rpx 24rpx;
  background: $bg-card;
  border-bottom: 1rpx solid rgba($text-weak, 0.1);

  .header-title {
    font-size: 32rpx;
    font-weight: 700;
    color: $text-main;
  }

  .header-right {
    display: flex;
    align-items: center;

    .more-text {
      font-size: 24rpx;
      color: $text-sub;
    }

    .more-icon {
      font-size: 28rpx;
      color: $text-sub;
      margin-left: 4rpx;
    }
  }
}

// 商品网格
.goods-grid {
  display: flex;
  flex-wrap: wrap;
  padding: 20rpx;
  background: $bg-page;

  .goods-item {
    width: calc(50% - 10rpx);
    margin-bottom: 20rpx;

    &:nth-child(odd) {
      margin-right: 20rpx;
    }
  }
}

// 加载状态
.loading-status {
  padding: 32rpx 0;

  .loading {
    text-align: center;

    .loading-text {
      font-size: 24rpx;
      color: $text-weak;
    }
  }

  .no-more {
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 32rpx 0;

    .divider {
      width: 120rpx;
      height: 1rpx;
      background: rgba($text-weak, 0.3);
    }

    .no-more-text {
      font-size: 24rpx;
      color: $text-weak;
      margin: 0 24rpx;
      white-space: nowrap;
    }
  }
}
</style>
