<template>
  <!-- 会员等级权益规则页面 -->
  <!-- 功能：各等级权益介绍、升级所需成长值、当前等级标识 -->
  <view class="page-equity">
    <!-- 自定义导航栏 -->
    <view class="navbar">
      <view class="navbar-left" @click="goBack">
        <text class="back-icon">‹</text>
      </view>
      <view class="navbar-title">会员等级权益规则</view>
      <view class="navbar-right"></view>
    </view>

    <!-- 可滚动内容区 -->
    <scroll-view class="content" scroll-y enable-back-to-top>
      <!-- 加载中 -->
      <view v-if="loading && !memberStore.memberLevels.length" class="state-wrap">
        <text class="state-icon">⏳</text>
        <text class="state-text">加载中...</text>
      </view>

      <!-- 空状态 -->
      <view v-else-if="!memberStore.memberLevels.length" class="state-wrap">
        <text class="state-icon">📭</text>
        <text class="state-text">暂无等级数据</text>
      </view>

      <!-- 等级卡片列表 -->
      <view v-else class="level-list">
        <view
          v-for="level in memberStore.memberLevels"
          :key="level.levelName"
          class="level-card"
          :class="{ 'is-current': isCurrentLevel(level) }"
        >
          <!-- 当前等级徽标 -->
          <view v-if="isCurrentLevel(level)" class="current-badge">
            <text>当前等级</text>
          </view>

          <!-- 等级头部：主题渐变背景 -->
          <view class="level-header" :style="{ background: getTheme(level).gradient }">
            <view class="level-icon">
              <text>{{ getLevelIcon(level.memberLevelName || level.levelName) }}</text>
            </view>
            <view class="level-info">
              <text class="level-name">{{ level.memberLevelName || level.levelName }}</text>
              <text class="level-growth">升级所需成长值: {{ level.requiredGrowthValue }}</text>
            </view>
          </view>

          <!-- 等级内容 -->
          <view class="level-body">
            <view v-if="level.description" class="level-desc">
              <text>{{ level.description }}</text>
            </view>

            <view v-if="level.benefits && level.benefits.length" class="benefits">
              <view class="benefits-title">
                <text>专属权益</text>
              </view>
              <view
                v-for="(benefit, idx) in level.benefits"
                :key="idx"
                class="benefit-item"
              >
                <text class="benefit-check">✓</text>
                <view class="benefit-content">
                  <text class="benefit-name">{{ benefit.name }}</text>
                  <text class="benefit-desc">{{ benefit.description }}</text>
                </view>
              </view>
            </view>
          </view>
        </view>
      </view>

      <!-- 底部安全区占位 -->
      <view class="safe-bottom"></view>
    </scroll-view>
  </view>
</template>

<script setup>
import { useMember } from '@/hooks/useMember'
import { onShow } from '@dcloudio/uni-app'
import { useMemberStore } from '@/store/member'

const memberStore = useMemberStore()
const { loading, loadMemberLevels } = useMember()

// 等级图标映射
const levelIconMap = {
  '普通': '👤',
  '银卡': '🥈',
  '金卡': '🥇',
  '钻石': '💎'
}

// 获取等级图标
const getLevelIcon = (levelName) => {
  if (!levelName) return '👤'
  if (levelName.includes('钻石')) return levelIconMap['钻石']
  if (levelName.includes('金')) return levelIconMap['金卡']
  if (levelName.includes('银')) return levelIconMap['银卡']
  return levelIconMap['普通']
}

// 获取等级主题色
const getTheme = (level) => {
  const name = level.memberLevelName || level.levelName || ''
  return memberStore.getLevelTheme(name)
}

// 判断是否为当前等级
const isCurrentLevel = (level) => {
  return memberStore.memberInfo && level.levelName === memberStore.memberInfo.memberLevelName
}

// 返回上一页
const goBack = () => {
  uni.navigateBack()
}

onShow(() => {
  loadMemberLevels()
})
</script>

<style lang="scss" scoped>
.page-equity {
  min-height: 100vh;
  background-color: $bg-page;
  display: flex;
  flex-direction: column;
}

// 自定义导航栏
.navbar {
  height: 88rpx;
  padding-top: env(safe-area-inset-top);
  background-color: $bg-card;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding-left: 32rpx;
  padding-right: 32rpx;
  position: sticky;
  top: 0;
  z-index: 100;
  box-shadow: 0 2rpx 8rpx rgba(0, 0, 0, 0.04);

  .navbar-left {
    width: 80rpx;
    display: flex;
    align-items: center;

    .back-icon {
      font-size: 56rpx;
      color: $text-main;
      line-height: 1;
    }
  }

  .navbar-title {
    font-size: 34rpx;
    font-weight: 600;
    color: $text-main;
  }

  .navbar-right {
    width: 80rpx;
  }
}

// 内容滚动区
.content {
  flex: 1;
  padding: 24rpx;
  padding-bottom: calc(40rpx + env(safe-area-inset-bottom));
}

// 加载/空状态
.state-wrap {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 160rpx 0;

  .state-icon {
    font-size: 96rpx;
    margin-bottom: 24rpx;
  }

  .state-text {
    font-size: 28rpx;
    color: $text-weak;
  }
}

// 等级卡片列表
.level-list {
  .level-card {
    position: relative;
    background-color: $bg-card;
    border-radius: 24rpx;
    margin-bottom: 24rpx;
    overflow: hidden;
    opacity: 0.85;
    box-shadow: 0 4rpx 16rpx rgba(0, 0, 0, 0.04);
    transition: all 0.25s ease;

    // 当前等级高亮
    &.is-current {
      opacity: 1;
      border: 2rpx solid $color-primary;
      box-shadow: 0 8rpx 24rpx rgba(255, 106, 0, 0.15);
      transform: translateY(-2rpx);
    }

    // 当前等级徽标
    .current-badge {
      position: absolute;
      top: 0;
      right: 0;
      background: $color-primary;
      padding: 8rpx 20rpx;
      border-radius: 0 24rpx 0 16rpx;
      z-index: 2;

      text {
        color: #FFFFFF;
        font-size: 22rpx;
        font-weight: 500;
      }
    }

    // 等级头部
    .level-header {
      padding: 32rpx;
      display: flex;
      align-items: center;

      .level-icon {
        width: 80rpx;
        height: 80rpx;
        border-radius: 50%;
        background: rgba(255, 255, 255, 0.22);
        display: flex;
        align-items: center;
        justify-content: center;
        margin-right: 24rpx;

        text {
          font-size: 40rpx;
        }
      }

      .level-info {
        flex: 1;

        .level-name {
          font-size: 36rpx;
          font-weight: 600;
          color: #FFFFFF;
          display: block;
          margin-bottom: 8rpx;
        }

        .level-growth {
          font-size: 24rpx;
          color: rgba(255, 255, 255, 0.88);
        }
      }
    }

    // 等级内容
    .level-body {
      padding: 28rpx 32rpx 32rpx;

      .level-desc {
        margin-bottom: 24rpx;
        padding-bottom: 24rpx;
        border-bottom: 1rpx solid #F0F0F0;

        text {
          font-size: 26rpx;
          color: $text-sub;
          line-height: 1.6;
        }
      }

      .benefits {
        .benefits-title {
          margin-bottom: 16rpx;

          text {
            font-size: 28rpx;
            font-weight: 600;
            color: $text-main;
          }
        }

        .benefit-item {
          display: flex;
          align-items: flex-start;
          padding: 12rpx 0;

          .benefit-check {
            font-size: 28rpx;
            color: $color-success;
            margin-right: 16rpx;
            line-height: 1.6;
            flex-shrink: 0;
          }

          .benefit-content {
            flex: 1;

            .benefit-name {
              font-size: 28rpx;
              color: $text-main;
              font-weight: 500;
              display: block;
              margin-bottom: 4rpx;
            }

            .benefit-desc {
              font-size: 24rpx;
              color: $text-weak;
              line-height: 1.5;
            }
          }
        }
      }
    }
  }
}

.safe-bottom {
  height: 40rpx;
}
</style>
