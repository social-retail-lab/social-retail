<template>
  <view class="page-container">
    <view class="search-bar">
      <view class="back-btn" @click="handleBack">
        <text class="back-icon">‹</text>
      </view>
      <view class="search-input-wrap">
        <image src="/static/fonts/search.svg" class="search-icon" mode="aspectFit" />
        <input
          v-model="keyword"
          class="search-input"
          placeholder="搜索商品/品牌"
          @confirm="handleSearch"
          @input="handleInput"
          focus
        />
        <view v-if="keyword" class="clear-btn" @click="clearKeyword">
          <text class="clear-icon">×</text>
        </view>
      </view>
      <view class="search-btn" @click="handleSearch">
        <text class="search-btn-text">搜索</text>
      </view>
    </view>

    <scroll-view scroll-y class="search-content">
      <view v-if="!keyword" class="search-history">
        <view class="history-header">
          <text class="history-title">搜索历史</text>
          <view class="history-clear" @click="clearHistory">
            <text class="clear-text">清空</text>
          </view>
        </view>
        <view v-if="historyList.length > 0" class="history-tags">
          <view
            v-for="item in historyList"
            :key="item"
            class="history-tag"
            @click="handleHistoryClick(item)"
          >
            <text class="tag-text">{{ item }}</text>
          </view>
        </view>
        <view v-else class="history-empty">
          <text class="empty-text">暂无搜索记录</text>
        </view>
      </view>

      <view v-if="!keyword" class="hot-search">
        <view class="hot-header">
          <text class="hot-title">热门搜索</text>
        </view>
        <view class="hot-tags">
          <view
            v-for="(item, index) in hotList"
            :key="item"
            class="hot-tag"
            :class="{ 'hot-tag-top': index < 3 }"
            @click="handleHotClick(item)"
          >
            <text class="hot-index" v-if="index < 3">{{ index + 1 }}</text>
            <text class="hot-text">{{ item }}</text>
          </view>
        </view>
      </view>

      <view v-if="keyword" class="search-suggest">
        <view class="suggest-header">
          <text class="suggest-title">搜索建议</text>
        </view>
        <view class="suggest-list">
          <view
            v-for="item in suggestList"
            :key="item"
            class="suggest-item"
            @click="handleSuggestClick(item)"
          >
            <image src="/static/fonts/search.svg" class="suggest-icon" mode="aspectFit" />
            <text class="suggest-text">{{ item }}</text>
          </view>
        </view>
      </view>
    </scroll-view>
  </view>
</template>

<script setup>
import { ref, onMounted } from 'vue'

const keyword = ref('')
const historyList = ref([])
const suggestList = ref([])

const hotList = [
  '蓝牙耳机',
  '手机壳',
  '充电宝',
  'T恤',
  '连衣裙',
  '护肤品',
  '智能手表',
  '零食',
  '家居用品',
  '运动鞋'
]

const handleInput = () => {
  if (keyword.value) {
    suggestList.value = hotList.filter(item => item.includes(keyword.value))
  } else {
    suggestList.value = []
  }
}

const clearKeyword = () => {
  keyword.value = ''
  suggestList.value = []
}

const handleSearch = () => {
  const searchKeyword = keyword.value.trim()
  if (!searchKeyword) {
    uni.showToast({ title: '请输入搜索关键词', icon: 'none' })
    return
  }
  saveHistory(searchKeyword)
  uni.navigateTo({
    url: `/pagesSub/goods/search/searchResult?keyword=${encodeURIComponent(searchKeyword)}`
  })
}

const handleHistoryClick = (item) => {
  keyword.value = item
  saveHistory(item)
  uni.navigateTo({
    url: `/pagesSub/goods/search/searchResult?keyword=${encodeURIComponent(item)}`
  })
}

const handleHotClick = (item) => {
  keyword.value = item
  saveHistory(item)
  uni.navigateTo({
    url: `/pagesSub/goods/search/searchResult?keyword=${encodeURIComponent(item)}`
  })
}

const handleSuggestClick = (item) => {
  keyword.value = item
  saveHistory(item)
  uni.navigateTo({
    url: `/pagesSub/goods/search/searchResult?keyword=${encodeURIComponent(item)}`
  })
}

const saveHistory = (keyword) => {
  let history = uni.getStorageSync('searchHistory') || []
  history = history.filter(item => item !== keyword)
  history.unshift(keyword)
  if (history.length > 10) {
    history = history.slice(0, 10)
  }
  uni.setStorageSync('searchHistory', history)
  historyList.value = history
}

const clearHistory = () => {
  uni.removeStorageSync('searchHistory')
  historyList.value = []
}

const loadHistory = () => {
  const history = uni.getStorageSync('searchHistory') || []
  historyList.value = history
}

const handleBack = () => {
  uni.navigateBack({
    fail: () => {
      uni.switchTab({
        url: '/pages/index/index'
      })
    }
  })
}

onMounted(() => {
  loadHistory()
})
</script>

<style lang="scss" scoped>
.page-container {
  min-height: 100vh;
  background-color: $bg-page;
}

.search-bar {
  display: flex;
  align-items: center;
  padding: 20rpx;
  padding-top: calc(20rpx + env(safe-area-inset-top));
  background: $bg-card;
  box-shadow: 0 2rpx 8rpx rgba(0, 0, 0, 0.06);
}

.back-btn {
  width: 60rpx;
  height: 60rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 16rpx;

  &:active {
    opacity: 0.6;
  }
}

.back-icon {
  font-size: 48rpx;
  color: $text-main;
}

.search-input-wrap {
  flex: 1;
  display: flex;
  align-items: center;
  height: 88rpx;
  padding: 0 24rpx;
  background: $bg-page;
  border-radius: $radius-full;
}

.search-icon {
  width: 48rpx;
  height: 48rpx;
  margin-right: 16rpx;
}

.search-input {
  flex: 1;
  font-size: 30rpx;
  color: $text-main;
}

.clear-btn {
  width: 48rpx;
  height: 48rpx;
  display: flex;
  align-items: center;
  justify-content: center;
}

.clear-icon {
  font-size: 40rpx;
  color: $text-weak;
}

.search-btn {
  margin-left: 20rpx;
  padding: 0 32rpx;
  height: 88rpx;
  background: linear-gradient(135deg, $color-primary 0%, $color-primary-danger 100%);
  border-radius: $radius-full;
  display: flex;
  align-items: center;
  justify-content: center;

  &:active {
    opacity: 0.8;
  }
}

.search-btn-text {
  font-size: 30rpx;
  color: #FFFFFF;
  font-weight: 600;
}

.search-content {
  height: calc(100vh - 128rpx - env(safe-area-inset-top));
  padding: 20rpx;
}

.search-history {
  margin-bottom: 32rpx;
}

.history-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 20rpx;
}

.history-title {
  font-size: 30rpx;
  font-weight: 600;
  color: $text-main;
}

.history-clear {
  padding: 8rpx 20rpx;
}

.clear-text {
  font-size: 26rpx;
  color: $text-sub;
}

.history-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 16rpx;
}

.history-tag {
  padding: 16rpx 24rpx;
  background: $bg-card;
  border-radius: $radius-full;

  &:active {
    opacity: 0.6;
  }
}

.tag-text {
  font-size: 28rpx;
  color: $text-sub;
}

.history-empty {
  padding: 40rpx;
  text-align: center;
}

.empty-text {
  font-size: 28rpx;
  color: $text-weak;
}

.hot-search {
  margin-bottom: 32rpx;
}

.hot-header {
  margin-bottom: 20rpx;
}

.hot-title {
  font-size: 30rpx;
  font-weight: 600;
  color: $text-main;
}

.hot-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 16rpx;
}

.hot-tag {
  display: flex;
  align-items: center;
  padding: 16rpx 24rpx;
  background: $bg-card;
  border-radius: $radius-full;

  &:active {
    opacity: 0.6;
  }
}

.hot-tag-top {
  background: linear-gradient(135deg, rgba($color-primary, 0.1) 0%, rgba($color-primary-danger, 0.1) 100%);

  .hot-text {
    color: $color-primary;
  }
}

.hot-index {
  width: 36rpx;
  height: 36rpx;
  border-radius: 50%;
  background: $color-primary-danger;
  color: #FFFFFF;
  font-size: 22rpx;
  text-align: center;
  line-height: 36rpx;
  margin-right: 12rpx;
}

.hot-text {
  font-size: 28rpx;
  color: $text-sub;
}

.search-suggest {
  margin-top: 20rpx;
}

.suggest-header {
  margin-bottom: 20rpx;
}

.suggest-title {
  font-size: 30rpx;
  font-weight: 600;
  color: $text-main;
}

.suggest-list {
  background: $bg-card;
  border-radius: $radius-lg;
  overflow: hidden;
}

.suggest-item {
  display: flex;
  align-items: center;
  padding: 24rpx;
  border-bottom: 1rpx solid rgba($text-weak, 0.1);

  &:last-child {
    border-bottom: none;
  }

  &:active {
    background: $bg-page-light;
  }
}

.suggest-icon {
  width: 40rpx;
  height: 40rpx;
  margin-right: 16rpx;
  opacity: 0.5;
}

.suggest-text {
  font-size: 30rpx;
  color: $text-main;
}
</style>