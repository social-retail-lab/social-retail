<template>
  <view class="redirect-page">
    <text class="redirect-text">正在跳转...</text>
  </view>
</template>

<script setup>
import { onLoad } from '@dcloudio/uni-app'

onLoad((options) => {
  const opts = options || {}
  const params = Object.keys(opts)
    .map(key => `${key}=${encodeURIComponent(opts[key])}`)
    .join('&')

  const targetUrl = params
    ? `/pagesSub/goods/detail/goodsDetail?${params}`
    : '/pagesSub/goods/detail/goodsDetail'

  // 保存推广码到本地存储（URL 参数优先）
  if (opts.promotionCode) {
    uni.setStorageSync('promotionCode', opts.promotionCode)
  }

  // 免登录浏览：直接重定向到商品详情页
  uni.redirectTo({
    url: targetUrl,
    fail: () => {
      uni.reLaunch({ url: targetUrl })
    }
  })
})
</script>

<style lang="scss" scoped>
.redirect-page {
  display: flex;
  align-items: center;
  justify-content: center;
  height: 100vh;
  background: #FFFFFF;

  .redirect-text {
    font-size: 28rpx;
    color: #999;
  }
}
</style>
