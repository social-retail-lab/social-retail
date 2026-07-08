<template>
  <view class="page-detail">
    <!-- 导航栏 -->
    <view class="nav-bar" :style="{ paddingTop: statusBarHeight + 'px' }">
      <view class="nav-back" @click="handleBack">
        <text class="back-icon">‹</text>
      </view>
      <text class="nav-title">评价详情</text>
      <view class="nav-placeholder-right"></view>
    </view>
    <view class="nav-placeholder" :style="{ height: (statusBarHeight + 44) + 'px' }"></view>

    <!-- 加载中 -->
    <view v-if="commentStore.commentDetailLoading && !commentDetail" class="loading-state">
      <text class="loading-text">加载中...</text>
    </view>

    <!-- 评价内容 -->
    <view v-else-if="commentDetail" class="detail-content">
      <!-- 顶部图片轮播 -->
      <view
        v-if="commentDetail.imageUrls && commentDetail.imageUrls.length > 0"
        class="image-swiper-wrap"
      >
        <swiper
          class="image-swiper"
          :indicator-dots="commentDetail.imageUrls.length > 1"
          :autoplay="false"
          indicator-color="rgba(255,255,255,0.4)"
          indicator-active-color="#FFFFFF"
        >
          <swiper-item
            v-for="(img, index) in commentDetail.imageUrls"
            :key="index"
          >
            <image
              :src="img"
              mode="aspectFill"
              class="swiper-image"
              @click="previewCommentImage(commentDetail.imageUrls, img)"
            />
          </swiper-item>
        </swiper>
      </view>

      <!-- 商品信息 -->
      <view class="section">
        <view class="product-row">
          <image
            v-if="commentDetail.productImage"
            :src="commentDetail.productImage"
            mode="aspectFill"
            class="product-thumb"
          />
          <view class="product-info">
            <text class="product-name">{{ commentDetail.productName }}</text>
            <text class="sku-specs" v-if="commentDetail.skuSpecs">{{ commentDetail.skuSpecs }}</text>
          </view>
        </view>
      </view>

      <!-- 评分与用户 -->
      <view class="section">
        <view class="user-row">
          <image
            :src="getUserAvatar()"
            mode="aspectFill"
            class="user-avatar"
          />
          <view class="user-info">
            <text class="user-name">{{ getUserNickname() }}</text>
            <view class="score-row">
              <text
                v-for="star in 5"
                :key="star"
                class="star-icon"
                :class="{ 'star-active': star <= commentDetail.score }"
              >★</text>
              <text class="score-label">{{ getScoreText(commentDetail.score) }}</text>
            </view>
          </view>
          <text class="create-time">{{ commentDetail.createTime }}</text>
        </view>
      </view>

      <!-- 评价文字 -->
      <view class="section" v-if="commentDetail.content">
        <text class="content-text">{{ commentDetail.content }}</text>
      </view>

      <!-- 规格/时间信息 -->
      <view class="section info-section">
        <view class="info-row" v-if="commentDetail.skuSpecs">
          <text class="info-label">购买规格</text>
          <text class="info-value">{{ commentDetail.skuSpecs }}</text>
        </view>
        <view class="info-row">
          <text class="info-label">发布时间</text>
          <text class="info-value">{{ commentDetail.createTime }}</text>
        </view>
        <view class="info-row" v-if="commentDetail.status">
          <text class="info-label">评价状态</text>
          <text class="info-value" :style="{ color: getStatusColor(commentDetail.status) }">
            {{ getStatusText(commentDetail.status) }}
          </text>
        </view>
      </view>
    </view>

    <!-- 不存在 -->
    <view v-else class="empty-state">
      <text class="empty-text">评价不存在或已删除</text>
    </view>

    <!-- 底部删除 -->
    <view v-if="commentDetail && commentDetail.status === 'SHOW'" class="bottom-bar">
      <view class="delete-btn" @click="handleDelete">
        <text class="delete-text">删除评价</text>
      </view>
    </view>
  </view>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useComment } from '@/hooks/useComment'

const statusBarHeight = uni.getSystemInfoSync().statusBarHeight || 20

const {
  commentStore,
  loadCommentDetail,
  deleteComment,
  previewCommentImage,
  getScoreText,
  getStatusInfo,
  DEFAULT_AVATAR,
  ANONYMOUS_NICKNAME
} = useComment()

const commentId = ref(null)

const commentDetail = computed(() => commentStore.currentComment)

const handleBack = () => {
  uni.navigateBack({
    delta: 1,
    animationType: 'slide-out-right',
    animationDuration: 200
  })
}

// 获取用户头像（匿名用户用默认头像）
const getUserAvatar = () => {
  const detail = commentDetail.value
  if (!detail) return DEFAULT_AVATAR
  if (detail.anonymous === 1) return DEFAULT_AVATAR
  return detail.userInfo?.avatar || DEFAULT_AVATAR
}

// 获取用户昵称（匿名用户显示"匿名用户"）
const getUserNickname = () => {
  const detail = commentDetail.value
  if (!detail) return ANONYMOUS_NICKNAME
  if (detail.anonymous === 1) return ANONYMOUS_NICKNAME
  return detail.userInfo?.nickname || ANONYMOUS_NICKNAME
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
const handleDelete = async () => {
  const success = await deleteComment(commentId.value)
  if (success) {
    setTimeout(() => uni.navigateBack(), 1500)
  }
}

onMounted(() => {
  const pages = getCurrentPages()
  const currentPage = pages[pages.length - 1]
  const options = currentPage.options || {}
  commentId.value = Number(options.commentId) || null

  if (commentId.value) {
    loadCommentDetail(commentId.value)
  }
})
</script>

<style lang="scss" scoped>
.page-detail {
  min-height: 100vh;
  background: #FFFFFF;
  padding-bottom: 160rpx;
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

// ============ 顶部图片轮播 ============
.image-swiper-wrap {
  width: 100%;
  background: #000000;

  .image-swiper {
    width: 100%;
    height: 600rpx;
  }

  .swiper-image {
    width: 100%;
    height: 100%;
  }
}

// ============ 内容 ============
.detail-content {
  padding: 16rpx;
}

.section {
  background: #FFFFFF;
  padding: 24rpx;
  margin-bottom: 16rpx;
  border-bottom: 1rpx solid #F5F5F5;

  &:last-child {
    border-bottom: none;
  }
}

// 商品信息
.product-row {
  display: flex;
  align-items: center;

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

    .sku-specs {
      font-size: 24rpx;
      color: #999999;
      margin-top: 8rpx;
    }
  }
}

// 用户评分
.user-row {
  display: flex;
  align-items: center;

  .user-avatar {
    width: 64rpx;
    height: 64rpx;
    border-radius: 50%;
    flex-shrink: 0;
    background: #F5F5F5;
  }

  .user-info {
    flex: 1;
    margin-left: 16rpx;

    .user-name {
      font-size: 28rpx;
      color: #333333;
      font-weight: 500;
    }

    .score-row {
      display: flex;
      align-items: center;
      margin-top: 6rpx;

      .star-icon {
        font-size: 24rpx;
        color: #DDDDDD;
        margin-right: 2rpx;
      }

      .star-active {
        color: #FF9500;
      }

      .score-label {
        font-size: 22rpx;
        color: #999999;
        margin-left: 8rpx;
      }
    }
  }

  .create-time {
    font-size: 22rpx;
    color: #999999;
  }
}

// 评价文字
.content-text {
  font-size: 30rpx;
  color: #333333;
  line-height: 1.8;
}

// 信息区
.info-section {
  .info-row {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 12rpx 0;
    border-bottom: 1rpx solid #F5F5F5;

    &:last-child {
      border-bottom: none;
    }

    .info-label {
      font-size: 26rpx;
      color: #999999;
    }

    .info-value {
      font-size: 26rpx;
      color: #333333;
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

  .loading-text,
  .empty-text {
    font-size: 28rpx;
    color: #999999;
  }
}

// ============ 底部删除 ============
.bottom-bar {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  padding: 16rpx 24rpx;
  padding-bottom: calc(16rpx + env(safe-area-inset-bottom));
  background: #FFFFFF;
  border-top: 1rpx solid #EEEEEE;
  z-index: 100;

  .delete-btn {
    height: 88rpx;
    background: #FFFFFF;
    border: 1rpx solid #f56c6c;
    border-radius: 6rpx;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: background 200ms ease;

    &:active {
      background: #FFF5F5;
    }

    .delete-text {
      font-size: 30rpx;
      color: #f56c6c;
      font-weight: 500;
    }
  }
}
</style>
