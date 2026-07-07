<template>
  <view class="redirect-page">
    <text class="redirect-text">正在跳转...</text>
  </view>
</template>

<script setup>
import { onMounted } from 'vue'
import { onLoad } from '@dcloudio/uni-app'

// 兼容后端生成的旧版推广链接路径 /pages/product/detail
// 自动重定向到真实商品详情页 /pagesSub/goods/detail/goodsDetail
onLoad((options) => {
  const opts = options || {}
  const params = Object.keys(opts)
    .map(key => `${key}=${encodeURIComponent(opts[key])}`)
    .join('&')

  const targetUrl = params
    ? `/pagesSub/goods/detail/goodsDetail?${params}`
    : '/pagesSub/goods/detail/goodsDetail'

  console.log('推广链接重定向:', targetUrl)

  // 使用 redirectTo 替换当前页面，避免页面栈中残留中转页
  uni.redirectTo({
    url: targetUrl,
    fail: () => {
      // 如果 redirectTo 失败（如目标页是 tabBar），使用 reLaunch
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
