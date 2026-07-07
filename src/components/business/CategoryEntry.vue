<template>
  <view class="category-entry">
    <view class="kingkong-grid">
      <view
        v-for="item in entryList"
        :key="item.key"
        class="kingkong-item"
        @click="handleClick(item)"
      >
        <view class="kingkong-icon-wrap">
          <image
            v-if="item.icon"
            :src="item.icon"
            mode="aspectFit"
            class="kingkong-icon-img"
            lazy-load
          />
          <text v-else class="kingkong-icon-emoji">{{ item.emoji || '📦' }}</text>
        </view>
        <text class="kingkong-name">{{ item.name }}</text>
      </view>
    </view>
  </view>
</template>

<script setup>
import { useTabBarStore } from '@/store/tabBar'

const tabBarStore = useTabBarStore()

// 金刚区入口配置：2 行 × 4 列 = 8 个入口
// 6 个一级分类 + 2 个功能入口（积分商城 / 促销优惠）
const entryList = [
  {
    key: 'baby',
    name: '母婴孕童',
    icon: '/static/images/common/Baby_icon.png',
    type: 'category',
    matchName: '母婴'
  },
  {
    key: 'beauty',
    name: '美妆护肤',
    icon: '/static/images/common/Beauty_icon.png',
    type: 'category',
    matchName: '美妆'
  },
  {
    key: 'bev',
    name: '食品饮料',
    icon: '/static/images/common/Bev_icon.png',
    type: 'category',
    matchName: '食品'
  },
  {
    key: 'fresh',
    name: '生鲜果蔬',
    icon: '/static/images/common/Fresh_icon.png',
    type: 'category',
    matchName: '生鲜'
  },
  {
    key: 'home',
    name: '家居百货',
    icon: '/static/images/common/Home_icon.png',
    type: 'category',
    matchName: '家居'
  },
  {
    key: 'kitchen',
    name: '厨具餐具',
    icon: '/static/images/common/Kitchen_icon.png',
    type: 'category',
    matchName: '厨具'
  },
  {
    key: 'pointMall',
    name: '积分商城',
    emoji: '🎁',
    type: 'page',
    url: '/pagesSub/member/point/pointMall'
  },
  {
    key: 'coupon',
    name: '促销优惠',
    emoji: '🏷️',
    type: 'page',
    url: '/pagesSub/promotion/coupon/myCoupon'
  }
]

const handleClick = (item) => {
  if (item.type === 'category') {
    // 跳转到分类页（TabBar 页面）并指定一级分类
    tabBarStore.setPendingCategoryName(item.matchName)
    tabBarStore.switchTab(1) // 索引 1 = 分类页
  } else if (item.type === 'page') {
    uni.navigateTo({ url: item.url })
  }
}
</script>

<style lang="scss" scoped>
.category-entry {
  width: 100%;
  background: $bg-card;
  border-bottom: 1rpx solid rgba($text-weak, 0.1);
}

.kingkong-grid {
  display: flex;
  flex-wrap: wrap;
  padding: 16rpx 24rpx;
}

.kingkong-item {
  width: 25%;
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 8rpx 0;
  transition: all 0.2s ease;

  &:active {
    transform: scale(0.92);
    opacity: 0.85;
  }
}

.kingkong-icon-wrap {
  width: 120rpx;
  height: 120rpx;
  margin-bottom: 8rpx;
  display: flex;
  align-items: center;
  justify-content: center;
}

.kingkong-icon-img {
  width: 100%;
  height: 100%;
}

.kingkong-icon-emoji {
  font-size: 60rpx;
}

.kingkong-name {
  font-size: 22rpx;
  color: $text-sub;
  text-align: center;
  max-width: 140rpx;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}
</style>
