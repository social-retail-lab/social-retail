<template>
  <view class="page-container">
    <!-- 顶部搜索栏 -->
    <view class="search-bar">
      <view class="back-btn" @click="handleBack">
        <text class="back-icon">‹</text>
      </view>
      <view class="search-input-wrap">
        <image src="/static/fonts/search.svg" class="search-icon" mode="aspectFit" />
        <input
          v-model="keyword"
          class="search-input"
          placeholder="搜索商品/品牌/店铺"
          placeholder-class="placeholder"
          confirm-type="search"
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
      <!-- 搜索建议（输入关键词且有匹配建议时显示） -->
      <view v-if="keyword && suggestList.length > 0" class="search-suggest">
        <view class="suggest-list">
          <view
            v-for="item in suggestList"
            :key="item"
            class="suggest-item"
            @click="handleSuggestClick(item)"
          >
            <image src="/static/fonts/search.svg" class="suggest-icon" mode="aspectFit" />
            <text class="suggest-text" v-if="item.includes(keyword)">
              <text class="suggest-highlight">{{ keyword }}</text>{{ item.replace(keyword, '') }}
            </text>
            <text class="suggest-text" v-else>{{ item }}</text>
            <text class="suggest-arrow">›</text>
          </view>
        </view>
      </view>

      <!-- 搜索历史 + 热门搜索（未输入关键词或无匹配建议时显示） -->
      <view v-else class="search-panel">
        <!-- 搜索历史 -->
        <view class="section">
          <view class="section-header">
            <view class="section-title-wrap">
              <text class="section-icon">🕐</text>
              <text class="section-title">搜索历史</text>
            </view>
            <view v-if="historyList.length > 0" class="section-action" @click="showClearConfirm">
              <text class="action-icon">🗑</text>
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
          <view v-else class="empty-section">
            <text class="empty-section-text">暂无搜索记录</text>
          </view>
        </view>

        <!-- 热门搜索 -->
        <view class="section">
          <view class="section-header">
            <view class="section-title-wrap">
              <text class="section-icon">🔥</text>
              <text class="section-title">热门搜索</text>
            </view>
          </view>
          <view class="hot-list">
            <view
              v-for="(item, index) in hotList"
              :key="item"
              class="hot-item"
              @click="handleHotClick(item)"
            >
              <view class="hot-rank" :class="getRankClass(index)">
                <text class="rank-text">{{ index + 1 }}</text>
              </view>
              <text class="hot-text">{{ item }}</text>
              <text v-if="index < 3" class="hot-badge">{{ ['热搜', '热门', '推荐'][index] }}</text>
            </view>
          </view>
        </view>

        <!-- 大家都在买 -->
        <view class="section">
          <view class="section-header">
            <view class="section-title-wrap">
              <text class="section-icon">🛒</text>
              <text class="section-title">大家都在买</text>
            </view>
          </view>
          <view class="recommend-tags">
            <view
              v-for="item in recommendList"
              :key="item"
              class="recommend-tag"
              @click="handleHotClick(item)"
            >
              <text class="recommend-text">{{ item }}</text>
            </view>
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

// 热门搜索词
const hotList = [
  '新疆阿克苏苹果',
  '赣南脐橙',
  '智利车厘子',
  '五常大米',
  '内蒙古牛肉',
  '深海三文鱼',
  '有机蔬菜',
  '土鸡蛋',
  '宁夏枸杞',
  '云南普洱茶'
]

// 大家都在买
const recommendList = [
  '限时秒杀',
  '满减优惠',
  '新品上市',
  '产地直发',
  '绿色有机',
  '会员专享'
]

// 输入时生成搜索建议
const handleInput = () => {
  if (keyword.value) {
    // 从热门搜索 + 历史记录中匹配建议
    const allSuggestions = [...hotList, ...historyList.value]
    const matched = allSuggestions.filter(item => item.includes(keyword.value))
    // 去重
    suggestList.value = [...new Set(matched)].slice(0, 8)
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
    url: `/pagesSub/goods/search/searchResult?keyword=${searchKeyword}`
  })
}

const handleHistoryClick = (item) => {
  keyword.value = item
  saveHistory(item)
  uni.navigateTo({
    url: `/pagesSub/goods/search/searchResult?keyword=${item}`
  })
}

const handleHotClick = (item) => {
  keyword.value = item
  saveHistory(item)
  uni.navigateTo({
    url: `/pagesSub/goods/search/searchResult?keyword=${item}`
  })
}

const handleSuggestClick = (item) => {
  keyword.value = item
  saveHistory(item)
  uni.navigateTo({
    url: `/pagesSub/goods/search/searchResult?keyword=${item}`
  })
}

const saveHistory = (keyword) => {
  let history = uni.getStorageSync('searchHistory') || []
  history = history.filter(item => item !== keyword)
  history.unshift(keyword)
  if (history.length > 12) {
    history = history.slice(0, 12)
  }
  uni.setStorageSync('searchHistory', history)
  historyList.value = history
}

const showClearConfirm = () => {
  uni.showModal({
    title: '清空搜索历史',
    content: '确定要清空所有搜索记录吗？',
    confirmText: '清空',
    confirmColor: '#FF4D4F',
    success: (res) => {
      if (res.confirm) {
        uni.removeStorageSync('searchHistory')
        historyList.value = []
        uni.showToast({ title: '已清空', icon: 'none' })
      }
    }
  })
}

const loadHistory = () => {
  const history = uni.getStorageSync('searchHistory') || []
  historyList.value = history
}

const getRankClass = (index) => {
  if (index === 0) return 'rank-top-1'
  if (index === 1) return 'rank-top-2'
  if (index === 2) return 'rank-top-3'
  return 'rank-normal'
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
  display: flex;
  flex-direction: column;
}

/* ============ 搜索栏 ============ */
.search-bar {
  display: flex;
  align-items: center;
  padding: 16rpx 24rpx;
  padding-top: calc(16rpx + env(safe-area-inset-top));
  background: $bg-card;
  box-shadow: 0 2rpx 12rpx rgba(0, 0, 0, 0.04);
  flex-shrink: 0;
}

.back-btn {
  width: 64rpx;
  height: 64rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 16rpx;
  flex-shrink: 0;

  &:active {
    opacity: 0.6;
  }

  .back-icon {
    font-size: 52rpx;
    color: $text-main;
    font-weight: 300;
    line-height: 1;
    margin-top: -4rpx;
  }
}

.search-input-wrap {
  flex: 1;
  display: flex;
  align-items: center;
  height: 72rpx;
  padding: 0 20rpx;
  background: $bg-page;
  border-radius: $radius-full;
}

.search-icon {
  width: 36rpx;
  height: 36rpx;
  margin-right: 12rpx;
  opacity: 0.5;
}

.search-input {
  flex: 1;
  font-size: 28rpx;
  color: $text-main;
}

.placeholder {
  color: $text-weak;
  font-size: 28rpx;
}

.clear-btn {
  width: 40rpx;
  height: 40rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba($text-weak, 0.2);
  border-radius: 50%;
  margin-left: 8rpx;

  &:active {
    opacity: 0.6;
  }

  .clear-icon {
    font-size: 28rpx;
    color: $text-sub;
    line-height: 1;
  }
}

.search-btn {
  margin-left: 16rpx;
  padding: 0 32rpx;
  height: 72rpx;
  background: linear-gradient(135deg, $color-primary 0%, $color-primary-danger 100%);
  border-radius: $radius-full;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
  box-shadow: 0 4rpx 12rpx rgba($color-primary-danger, 0.2);

  &:active {
    opacity: 0.85;
    transform: scale(0.97);
  }

  .search-btn-text {
    font-size: 28rpx;
    color: #FFFFFF;
    font-weight: 600;
  }
}

/* ============ 内容区域 ============ */
.search-content {
  flex: 1;
  height: calc(100vh - 104rpx - env(safe-area-inset-top));
}

/* ============ 搜索建议 ============ */
.search-suggest {
  padding: 16rpx 24rpx;
}

.suggest-list {
  background: $bg-card;
  border-radius: $radius-lg;
  overflow: hidden;
  box-shadow: 0 2rpx 8rpx rgba(0, 0, 0, 0.03);
}

.suggest-item {
  display: flex;
  align-items: center;
  padding: 28rpx 24rpx;
  border-bottom: 2rpx solid rgba($text-weak, 0.06);

  &:last-child {
    border-bottom: none;
  }

  &:active {
    background: $bg-page-light;
  }

  .suggest-icon {
    width: 36rpx;
    height: 36rpx;
    margin-right: 16rpx;
    opacity: 0.4;
  }

  .suggest-text {
    flex: 1;
    font-size: 30rpx;
    color: $text-main;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }

  .suggest-highlight {
    color: $color-primary-danger;
    font-weight: 600;
  }

  .suggest-arrow {
    font-size: 32rpx;
    color: $text-weak;
    margin-left: 12rpx;
  }
}

/* ============ 搜索面板（历史+热门） ============ */
.search-panel {
  padding: 24rpx;
}

.section {
  background: $bg-card;
  border-radius: $radius-lg;
  padding: 28rpx 24rpx;
  margin-bottom: 20rpx;
  box-shadow: 0 2rpx 8rpx rgba(0, 0, 0, 0.03);
}

.section-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 24rpx;
}

.section-title-wrap {
  display: flex;
  align-items: center;

  .section-icon {
    font-size: 32rpx;
    margin-right: 12rpx;
  }

  .section-title {
    font-size: 30rpx;
    font-weight: 700;
    color: $text-main;
  }
}

.section-action {
  padding: 8rpx 16rpx;

  &:active {
    opacity: 0.6;
  }

  .action-icon {
    font-size: 28rpx;
  }
}

/* 搜索历史标签 */
.history-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 16rpx;
}

.history-tag {
  padding: 14rpx 28rpx;
  background: $bg-page-light;
  border-radius: $radius-full;
  border: 2rpx solid transparent;
  transition: all 0.2s;

  &:active {
    background: rgba($color-primary, 0.06);
    border-color: rgba($color-primary, 0.2);
  }

  .tag-text {
    font-size: 26rpx;
    color: $text-sub;
  }
}

.empty-section {
  padding: 32rpx 0;
  text-align: center;

  .empty-section-text {
    font-size: 26rpx;
    color: $text-weak;
  }
}

/* 热门搜索列表 */
.hot-list {
  display: flex;
  flex-direction: column;
}

.hot-item {
  display: flex;
  align-items: center;
  padding: 20rpx 0;
  border-bottom: 2rpx solid rgba($text-weak, 0.04);

  &:last-child {
    border-bottom: none;
  }

  &:active {
    opacity: 0.7;
  }
}

.hot-rank {
  width: 40rpx;
  height: 40rpx;
  border-radius: 8rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 20rpx;
  flex-shrink: 0;

  .rank-text {
    font-size: 24rpx;
    font-weight: 700;
    color: #FFFFFF;
  }

  &.rank-top-1 {
    background: linear-gradient(135deg, #FF6A00, #FF4D4F);
    box-shadow: 0 4rpx 8rpx rgba(255, 77, 79, 0.25);
  }

  &.rank-top-2 {
    background: linear-gradient(135deg, #FF9500, #FF6A00);
    box-shadow: 0 4rpx 8rpx rgba(255, 149, 0, 0.2);
  }

  &.rank-top-3 {
    background: linear-gradient(135deg, #FFB800, #FF9500);
    box-shadow: 0 4rpx 8rpx rgba(255, 184, 0, 0.2);
  }

  &.rank-normal {
    background: $bg-page-light;

    .rank-text {
      color: $text-weak;
    }
  }
}

.hot-text {
  flex: 1;
  font-size: 28rpx;
  color: $text-main;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.hot-badge {
  font-size: 20rpx;
  color: $color-primary-danger;
  padding: 4rpx 12rpx;
  background: rgba($color-primary-danger, 0.08);
  border-radius: $radius-sm;
  flex-shrink: 0;
}

/* 大家都在买 */
.recommend-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 16rpx;
}

.recommend-tag {
  padding: 14rpx 28rpx;
  background: linear-gradient(135deg, rgba($color-primary, 0.06) 0%, rgba($color-primary-danger, 0.06) 100%);
  border-radius: $radius-full;
  border: 2rpx solid rgba($color-primary, 0.12);

  &:active {
    background: linear-gradient(135deg, rgba($color-primary, 0.12) 0%, rgba($color-primary-danger, 0.12) 100%);
  }

  .recommend-text {
    font-size: 26rpx;
    color: $color-primary;
    font-weight: 500;
  }
}
</style>
