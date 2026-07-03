<template>
  <scroll-view scroll-y class="category-right">
    <view class="right-content">
      <!-- Banner轮播区域 -->
      <view v-if="banners && banners.length > 0" class="banner-section">
        <swiper 
          class="banner-swiper"
          :indicator-dots="true"
          :autoplay="true"
          :interval="4000"
          :duration="500"
          indicator-color="rgba(255,255,255,0.4)"
          indicator-active-color="#FFFFFF"
          @click="handleBannerClick"
        >
          <swiper-item v-for="banner in banners" :key="banner.id">
            <view class="banner-item">
              <image :src="banner.image" mode="aspectFill" class="banner-image" lazy-load />
              <view class="banner-mask"></view>
              <text class="banner-title">{{ banner.title }}</text>
            </view>
          </swiper-item>
        </swiper>
      </view>

      <!-- 二级分类宫格 -->
      <view v-if="secondCategories && secondCategories.length > 0" class="second-category-section">
        <view class="category-card">
          <view class="category-grid">
            <view 
              v-for="item in secondCategories" 
              :key="item.categoryId"
              class="category-item"
              @click="handleCategoryClick(item)"
            >
              <view class="category-icon-wrap">
                <image :src="item.icon" mode="aspectFit" class="category-icon" lazy-load />
              </view>
              <text class="category-name">{{ item.categoryName }}</text>
            </view>
          </view>
        </view>
      </view>

      <!-- 商品模块区域 -->
      <view v-if="modules && modules.length > 0" class="modules-section">
        <view 
          v-for="module in modules" 
          :key="module.id" 
          class="product-module"
        >
          <view class="module-header">
            <text class="module-title">{{ module.title }}</text>
            <view class="module-more" @click="handleModuleMore(module)">
              <text class="module-more-text">更多</text>
              <text class="module-more-arrow">></text>
            </view>
          </view>
          <scroll-view scroll-x class="module-scroll">
            <view class="module-goods">
              <view 
                v-for="goods in module.goods" 
                :key="goods.productId" 
                class="goods-item"
                @click="handleGoodsClick(goods)"
              >
                <view class="goods-image-wrap">
                  <image :src="goods.productImage" mode="aspectFill" class="goods-image" lazy-load />
                </view>
                <text class="goods-title">{{ goods.productName }}</text>
                <view class="goods-price-wrap">
                  <text class="goods-price">¥{{ goods.price }}</text>
                  <text class="goods-original-price">¥{{ goods.originalPrice }}</text>
                </view>
                <text class="goods-sales">{{ goods.soldCount }}人付款</text>
              </view>
            </view>
          </scroll-view>
        </view>
      </view>
    </view>
  </scroll-view>
</template>

<script setup>
defineProps({
  banners: { type: Array, default: () => [] },
  secondCategories: { type: Array, default: () => [] },
  modules: { type: Array, default: () => [] }
})

const emit = defineEmits(['selectBanner', 'selectCategory', 'selectGoods', 'selectModuleMore'])

const handleBannerClick = (e) => {
  emit('selectBanner', e)
}

const handleCategoryClick = (item) => {
  emit('selectCategory', item)
}

const handleGoodsClick = (goods) => {
  emit('selectGoods', goods)
}

const handleModuleMore = (module) => {
  emit('selectModuleMore', module)
}
</script>

<style lang="scss" scoped>
.category-right {
  flex: 1;
  height: 100%;
  background: $bg-page-light;
  overflow-y: auto;
  overscroll-behavior: contain;
}

.category-right::-webkit-scrollbar {
  display: none;
}

.right-content {
  padding: 20rpx;
  padding-bottom: calc(20rpx + 120rpx);
}

.banner-section {
  margin-bottom: 24rpx;
}

.banner-swiper {
  height: 280rpx;
  border-radius: $category-card-radius;
  overflow: hidden;
}

.banner-item {
  position: relative;
  width: 100%;
  height: 100%;
}

.banner-image {
  width: 100%;
  height: 100%;
}

.banner-mask {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  height: 120rpx;
  background: linear-gradient(transparent, rgba(0, 0, 0, 0.4));
}

.banner-title {
  position: absolute;
  bottom: 30rpx;
  left: 30rpx;
  font-size: 32rpx;
  color: #FFFFFF;
  font-weight: 600;
}

.second-category-section {
  margin-bottom: 32rpx;
}

.category-card {
  background: $bg-card;
  border-radius: $category-card-radius;
  padding: 32rpx 24rpx;
  box-shadow: $category-shadow-sm;
}

.category-grid {
  display: flex;
  flex-wrap: wrap;
  justify-content: space-between;
}

.category-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  width: calc(33.333% - 12rpx);
  margin-bottom: 28rpx;
  transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);

  &:active {
    transform: scale(0.95);
  }
}

.category-icon-wrap {
  width: 128rpx;
  height: 128rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 16rpx;
  border-radius: 20rpx;
  background: $bg-page-light;
  box-shadow: 0 4rpx 12rpx rgba(0, 0, 0, 0.04);
}

.category-icon {
  width: 80rpx;
  height: 80rpx;
}

.category-name {
  font-size: 26rpx;
  color: $text-main;
  text-align: center;
  font-weight: 400;
  max-width: 100%;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.modules-section {
  display: flex;
  flex-direction: column;
  gap: 32rpx;
}

.product-module {
  background: $bg-card;
  border-radius: $category-card-radius;
  padding: 28rpx;
  box-shadow: 0 2rpx 16rpx rgba(0, 0, 0, 0.04);
}

.module-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 24rpx;
}

.module-title {
  font-size: 32rpx;
  font-weight: 600;
  color: $text-main;
}

.module-more {
  display: flex;
  align-items: center;
  padding: 8rpx 20rpx;
  border-radius: 24rpx;
  background: rgba($color-primary, 0.08);
  transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);

  &:active {
    background: rgba($color-primary, 0.15);
    transform: scale(0.96);
  }
}

.module-more-text {
  font-size: 24rpx;
  color: $color-primary;
  margin-right: 4rpx;
}

.module-more-arrow {
  font-size: 24rpx;
  color: $color-primary;
}

.module-scroll {
  white-space: nowrap;
  margin: 0 -28rpx;
  padding: 0 28rpx;
  width: calc(100% + 56rpx);
}

.module-scroll::-webkit-scrollbar {
  display: none;
}

.module-goods {
  display: inline-flex;
  gap: 20rpx;
  padding-right: 28rpx;
}

.goods-item {
  display: inline-block;
  width: 240rpx;
  flex-shrink: 0;
  transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);

  &:active {
    transform: scale(0.97);
  }
}

.goods-image-wrap {
  width: 240rpx;
  height: 240rpx;
  border-radius: 16rpx;
  overflow: hidden;
  margin-bottom: 16rpx;
  background: $bg-page-light;
  box-shadow: 0 4rpx 16rpx rgba(0, 0, 0, 0.06);
}

.goods-image {
  width: 100%;
  height: 100%;
  transition: transform 0.3s ease;

  .goods-item:active & {
    transform: scale(1.05);
  }
}

.goods-title {
  font-size: 26rpx;
  color: $text-main;
  font-weight: 500;
  line-height: 1.45;
  height: 74rpx;
  overflow: hidden;
  text-overflow: ellipsis;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  line-clamp: 2;
  -webkit-box-orient: vertical;
  margin-bottom: 12rpx;
}

.goods-price-wrap {
  display: flex;
  align-items: baseline;
  gap: 8rpx;
  margin-bottom: 8rpx;
}

.goods-price {
  font-size: 32rpx;
  font-weight: 700;
  color: $color-primary-danger;
}

.goods-original-price {
  font-size: 22rpx;
  color: $text-weak;
  text-decoration: line-through;
}

.goods-sales {
  font-size: 22rpx;
  color: $text-weak;
}
</style>