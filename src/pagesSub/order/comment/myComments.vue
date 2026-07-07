<template>
  <view class="page-my">
    <!-- 导航栏 -->
    <view class="nav-bar" :style="{ paddingTop: statusBarHeight + 'px' }">
      <view class="nav-back" @click="handleBack">
        <text class="back-icon">‹</text>
      </view>
      <text class="nav-title">我的评价</text>
      <view class="nav-placeholder-right"></view>
    </view>
    <view class="nav-placeholder" :style="{ height: (statusBarHeight + 44) + 'px' }"></view>

    <!-- 评价列表 -->
    <scroll-view
      scroll-y
      class="comment-scroll"
      :refresher-enabled="true"
      :refresher-triggered="refreshing"
      @refresherrefresh="onRefresh"
      @scrolltolower="onLoadMore"
    >
      <!-- 加载中 -->
      <view v-if="commentStore.myCommentsLoading && commentList.length === 0" class="loading-state">
        <text class="loading-text">加载中...</text>
      </view>

      <!-- 空状态 -->
      <view v-else-if="commentList.length === 0" class="empty-state">
        <text class="empty-text">暂无评价记录</text>
      </view>

      <!-- 评价列表 -->
      <view v-else class="comment-list">
        <view
          v-for="item in commentList"
          :key="item.commentId"
          class="comment-card"
        >
          <!-- 商品信息 -->
          <view class="card-product">
            <image
              :src="item.productImage"
              mode="aspectFill"
              class="product-thumb"
              lazy-load
            />
            <view class="product-info">
              <text class="product-name">{{ item.productName }}</text>
              <view class="score-row">
                <text
                  v-for="star in 5"
                  :key="star"
                  class="star-icon"
                  :class="{ 'star-active': star <= item.score }"
                >★</text>
              </view>
              <text class="create-time">{{ item.createTime }}</text>
            </view>
          </view>

          <!-- 评价内容 -->
          <view class="card-content" v-if="item.content">
            <text class="content-text">{{ item.content }}</text>
          </view>

          <!-- 评价图片 -->
          <view class="card-images" v-if="item.imageUrls && item.imageUrls.length > 0">
            <image
              v-for="(img, index) in item.imageUrls"
              :key="index"
              :src="img"
              mode="aspectFill"
              class="comment-image"
              @click="previewCommentImage(item.imageUrls, img)"
            />
          </view>

          <!-- 状态与操作 -->
          <view class="card-footer">
            <text class="status-text" :style="{ color: getStatusColor(item.status) }">
              {{ getStatusText(item.status) }}
            </text>
            <view class="action-group">
              <view class="action-btn" @click="goCommentDetail(item.commentId)">
                <text class="btn-text">查看详情</text>
              </view>
              <view
                v-if="item.status === 'SHOW'"
                class="action-btn action-btn-danger"
                @click="handleDelete(item.commentId)"
              >
                <text class="btn-text btn-text-danger">删除</text>
              </view>
            </view>
          </view>
        </view>

        <!-- 加载更多 -->
        <view v-if="commentList.length > 0" class="load-more">
          <text v-if="commentStore.myCommentsLoading" class="load-more-text">加载中...</text>
          <text v-else-if="hasMore" class="load-more-text">上拉加载更多</text>
          <text v-else class="load-more-text">没有更多了</text>
        </view>
      </view>

      <view class="safe-bottom"></view>
    </scroll-view>
  </view>
</template>

<script setup>
import { ref, computed } from 'vue'
import { onShow } from '@dcloudio/uni-app'
import { useComment } from '@/hooks/useComment'

const statusBarHeight = uni.getSystemInfoSync().statusBarHeight || 20

const {
  commentStore,
  loadMyComments,
  deleteComment,
  goCommentDetail,
  previewCommentImage,
  getStatusInfo
} = useComment()

const refreshing = ref(false)

const commentList = computed(() => commentStore.myComments)
const hasMore = computed(() => commentStore.myCommentsPage < commentStore.myCommentsPages)

const handleBack = () => {
  uni.navigateBack({
    delta: 1,
    animationType: 'slide-out-right',
    animationDuration: 200
  })
}

// 状态文案
const getStatusText = (status) => {
  return getStatusInfo(status)?.label || ''
}

// 状态颜色
const getStatusColor = (status) => {
  return getStatusInfo(status)?.color || '#999999'
}

// 删除评价
const handleDelete = async (commentId) => {
  await deleteComment(commentId)
}

// 下拉刷新
const onRefresh = async () => {
  refreshing.value = true
  await loadMyComments(false)
  refreshing.value = false
}

// 上拉加载
const onLoadMore = () => {
  if (hasMore.value && !commentStore.myCommentsLoading) {
    loadMyComments(true)
  }
}

onShow(() => {
  loadMyComments(false)
})
</script>

<style lang="scss" scoped>
.page-my {
  min-height: 100vh;
  background: #FFFFFF;
  display: flex;
  flex-direction: column;
}

// ============ 导航栏 ============
.nav-bar {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  height: 88rpx;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 24rpx;
  background: #FFFFFF;
  border-bottom: 1rpx solid #EEEEEE;
  z-index: 100;

  .nav-back {
    width: 64rpx;
    height: 64rpx;
    display: flex;
    align-items: center;
    justify-content: center;

    .back-icon {
      font-size: 48rpx;
      color: #333333;
      line-height: 1;
    }
  }

  .nav-title {
    font-size: 32rpx;
    font-weight: 500;
    color: #333333;
  }

  .nav-placeholder-right {
    width: 64rpx;
  }
}

.nav-placeholder {
  width: 100%;
}

// ============ 列表 ============
.comment-scroll {
  flex: 1;
  box-sizing: border-box;
}

.comment-list {
  display: flex;
  flex-direction: column;
}

.comment-card {
  background: #FFFFFF;
  padding: 24rpx;
  border-bottom: 1rpx solid #F5F5F5;
}

// 商品信息
.card-product {
  display: flex;
  align-items: flex-start;

  .product-thumb {
    width: 120rpx;
    height: 120rpx;
    border-radius: 8rpx;
    flex-shrink: 0;
    background: #F5F5F5;
  }

  .product-info {
    flex: 1;
    margin-left: 20rpx;
    display: flex;
    flex-direction: column;
    overflow: hidden;

    .product-name {
      font-size: 28rpx;
      color: #333333;
      line-height: 1.4;
      display: -webkit-box;
      -webkit-line-clamp: 2;
      -webkit-box-orient: vertical;
      overflow: hidden;
    }

    .score-row {
      display: flex;
      margin-top: 8rpx;

      .star-icon {
        font-size: 24rpx;
        color: #DDDDDD;
        margin-right: 2rpx;
      }

      .star-active {
        color: #FF9500;
      }
    }

    .create-time {
      font-size: 22rpx;
      color: #999999;
      margin-top: 8rpx;
    }
  }
}

// 评价内容
.card-content {
  margin-top: 16rpx;

  .content-text {
    font-size: 28rpx;
    color: #333333;
    line-height: 1.6;
  }
}

// 评价图片
.card-images {
  display: flex;
  flex-wrap: wrap;
  gap: 12rpx;
  margin-top: 16rpx;

  .comment-image {
    width: 160rpx;
    height: 160rpx;
    border-radius: 8rpx;
  }
}

// 底部操作
.card-footer {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-top: 16rpx;
  padding-top: 16rpx;
  border-top: 1rpx solid #F5F5F5;

  .status-text {
    font-size: 24rpx;
  }

  .action-group {
    display: flex;
    gap: 16rpx;
  }

  .action-btn {
    padding: 10rpx 24rpx;
    border: 1rpx solid #DDDDDD;
    border-radius: 6rpx;
    transition: background 200ms ease;

    &:active {
      background: #F5F5F5;
    }

    .btn-text {
      font-size: 24rpx;
      color: #666666;
    }

    &.action-btn-danger {
      border-color: #f56c6c;

      .btn-text-danger {
        color: #f56c6c;
      }
    }
  }
}

// ============ 加载/空状态 ============
.loading-state,
.empty-state {
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 200rpx 0;

  .loading-text {
    font-size: 28rpx;
    color: #999999;
  }

  .empty-text {
    font-size: 28rpx;
    color: #999999;
  }
}

.load-more {
  padding: 24rpx 0;
  text-align: center;

  .load-more-text {
    font-size: 24rpx;
    color: #999999;
  }
}

.safe-bottom {
  height: 32rpx;
}
</style>
