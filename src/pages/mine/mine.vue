<template>
  <view class="page-mine">
    <scroll-view 
      class="page-content"
      scroll-y
      enable-back-to-top
      :refresher-enabled="true"
      :refresher-triggered="refreshing"
      @refresherrefresh="handleRefresh"
    >
      <view v-if="loading" class="skeleton-container">
        <view class="skeleton-header">
          <view class="skeleton-avatar"></view>
          <view class="skeleton-info">
            <view class="skeleton-name"></view>
            <view class="skeleton-id"></view>
          </view>
          <view class="skeleton-icons">
            <view class="skeleton-icon"></view>
            <view class="skeleton-icon"></view>
          </view>
        </view>
        <view class="skeleton-card">
          <view class="skeleton-row">
            <view class="skeleton-badge"></view>
            <view class="skeleton-text"></view>
          </view>
          <view class="skeleton-bar"></view>
          <view class="skeleton-buttons">
            <view class="skeleton-btn"></view>
            <view class="skeleton-btn"></view>
          </view>
        </view>
        <view class="skeleton-assets">
          <view class="skeleton-asset-item">
            <view class="skeleton-asset-icon"></view>
            <view class="skeleton-asset-num"></view>
            <view class="skeleton-asset-text"></view>
          </view>
          <view class="skeleton-asset-item">
            <view class="skeleton-asset-icon"></view>
            <view class="skeleton-asset-num"></view>
            <view class="skeleton-asset-text"></view>
          </view>
          <view class="skeleton-asset-item">
            <view class="skeleton-asset-icon"></view>
            <view class="skeleton-asset-num"></view>
            <view class="skeleton-asset-text"></view>
          </view>
        </view>
        <view class="skeleton-card">
          <view class="skeleton-row">
            <view class="skeleton-text"></view>
            <view class="skeleton-arrow"></view>
          </view>
          <view class="skeleton-grid">
            <view v-for="i in 5" :key="i" class="skeleton-grid-item">
              <view class="skeleton-grid-icon"></view>
              <view class="skeleton-grid-text"></view>
            </view>
          </view>
        </view>
        <view class="skeleton-card skeleton-distribution"></view>
        <view class="skeleton-card">
          <view v-for="i in 4" :key="i" class="skeleton-cell">
            <view class="skeleton-cell-icon"></view>
            <view class="skeleton-cell-content">
              <view class="skeleton-cell-title"></view>
              <view class="skeleton-cell-subtitle"></view>
            </view>
            <view class="skeleton-cell-arrow"></view>
          </view>
        </view>
      </view>

      <template v-else>
        <view class="user-section" :class="{ 'logged-in': userStore.isLogin }">
          <view v-if="!userStore.isLogin" class="login-prompt" @click="handleLogin">
            <view class="login-avatar">
              <text class="avatar-icon">👤</text>
            </view>
            <view class="login-info">
              <text class="login-title">点击登录</text>
              <text class="login-subtitle">立即登录/注册</text>
            </view>
            <view class="login-arrow">
              <text>›</text>
            </view>
          </view>
          
          <view v-else class="user-info">
            <view class="user-left" @click="handleEditProfile">
              <view class="user-avatar">
                <image :src="userData.avatar || '/static/images/default-avatar.png'" mode="aspectFill" />
              </view>
              <view class="user-detail">
                <text class="user-name">{{ userData.nickname }}</text>
                <text class="user-id">ID：{{ userData.userId }}</text>
              </view>
            </view>
            <view class="user-right">
              <view class="user-icon-btn" @click="handleSettings">
                <text class="icon-gear">⚙️</text>
              </view>
              <view class="user-icon-btn message-btn" @click="handleMessage">
                <text class="icon-message">💬</text>
                <view v-if="unreadCount > 0" class="badge">
                  <text>{{ unreadCount > 99 ? '99+' : unreadCount }}</text>
                </view>
              </view>
            </view>
          </view>
        </view>

        <view class="content-area">
          <view class="member-card card-animate">
            <view class="member-left">
              <view class="member-icon">
                <text>{{ userStore.isMember ? '👑' : '👤' }}</text>
              </view>
              <view class="member-info">
                <text class="member-level">{{ memberData.levelName || '普通用户' }}</text>
                <text class="member-growth">成长值：{{ userStore.isLogin ? (Number(memberData.totalGrowth) || 0) : '--' }} / {{ userStore.isLogin ? (Number(memberData.nextLevelGrowth) || 0) : '--' }}</text>
                <view class="growth-bar">
                  <view class="growth-progress" :style="{ width: growthProgress + '%' }"></view>
                </view>
                <text class="growth-tip">{{ userStore.isLogin && memberData.nextLevelGrowth ? `距离升级还差 ${Number(memberData.nextLevelGrowth) - Number(memberData.totalGrowth)} 成长值` : '' }}</text>
              </view>
            </view>
            <view class="member-buttons">
              <view class="member-btn" @click="handleMemberActivity">
                <text>会员专属活动</text>
              </view>
              <view class="member-btn" @click="handleBirthdayGift">
                <text>生日礼包</text>
              </view>
            </view>
          </view>

          <view class="assets-card card-animate">
            <view class="asset-item" @click="handleCoupon">
              <view class="asset-icon coupon-icon">
                <text>🎫</text>
              </view>
              <view class="asset-info">
                <text class="asset-num">{{ userStore.isLogin ? assetStats.couponCount + '张' : '--' }}</text>
                <text class="asset-title">我的优惠券</text>
                <text v-if="userStore.isLogin" class="asset-subtitle">未使用</text>
              </view>
            </view>
            <view class="asset-divider"></view>
            <view class="asset-item" @click="handlePoints">
              <view class="asset-icon points-icon">
                <text>💰</text>
              </view>
              <view class="asset-info">
                <text class="asset-num">{{ userStore.isLogin ? assetStats.points : '--' }}</text>
                <text class="asset-title">我的积分</text>
                <text v-if="userStore.isLogin" class="asset-subtitle points-link">积分商城 ></text>
              </view>
            </view>
            <view class="asset-divider"></view>
            <view class="asset-item" @click="handleGrowth">
              <view class="asset-icon growth-icon">
                <text>📈</text>
              </view>
              <view class="asset-info">
                <text class="asset-num">{{ userStore.isLogin ? assetStats.growth : '--' }}</text>
                <text class="asset-title">成长值</text>
                <text v-if="userStore.isLogin" class="asset-subtitle">查看明细 ></text>
              </view>
            </view>
          </view>

          <view class="orders-card card-animate">
            <view class="orders-header">
              <text class="orders-title">我的订单</text>
              <view class="orders-all" @click="handleAllOrders">
                <text>查看全部订单 ></text>
              </view>
            </view>
            <view class="orders-grid">
              <view class="order-item" @click="handleOrder('pendingPayment')">
                <view class="order-icon-wrap">
                  <text class="order-icon">💳</text>
                  <view v-if="userStore.isLogin && orderStats.pendingPayment > 0" class="order-badge">
                    <text>{{ orderStats.pendingPayment }}</text>
                  </view>
                </view>
                <text class="order-name">待支付</text>
                <text v-if="userStore.isLogin" class="order-desc"></text>
              </view>
              <view class="order-item" @click="handleOrder('pendingShipment')">
                <view class="order-icon-wrap">
                  <text class="order-icon">📦</text>
                  <view v-if="userStore.isLogin && orderStats.pendingShipment > 0" class="order-badge">
                    <text>{{ orderStats.pendingShipment }}</text>
                  </view>
                </view>
                <text class="order-name">待发货</text>
                <text v-if="userStore.isLogin" class="order-desc"></text>
              </view>
              <view class="order-item" @click="handleOrder('pendingReceipt')">
                <view class="order-icon-wrap">
                  <text class="order-icon">🚚</text>
                  <view v-if="userStore.isLogin && orderStats.pendingReceipt > 0" class="order-badge">
                    <text>{{ orderStats.pendingReceipt }}</text>
                  </view>
                </view>
                <text class="order-name">待收货/自提</text>
                <text v-if="userStore.isLogin" class="order-desc"></text>
              </view>
              <view class="order-item" @click="handleOrder('pendingReview')">
                <view class="order-icon-wrap">
                  <text class="order-icon">⭐</text>
                  <view v-if="userStore.isLogin && orderStats.pendingReview > 0" class="order-badge">
                    <text>{{ orderStats.pendingReview }}</text>
                  </view>
                </view>
                <text class="order-name">待评价</text>
                <text v-if="userStore.isLogin" class="order-desc"></text>
              </view>
              <view class="order-item" @click="handleOrder('afterSale')">
                <view class="order-icon-wrap">
                  <text class="order-icon">🔄</text>
                  <view v-if="userStore.isLogin && orderStats.afterSale > 0" class="order-badge">
                    <text>{{ orderStats.afterSale }}</text>
                  </view>
                </view>
                <text class="order-name">退款/售后</text>
                <text v-if="userStore.isLogin" class="order-desc"></text>
              </view>
            </view>
          </view>

          <view class="distribution-banner card-animate" @click="handleDistribution">
            <view v-if="userStore.isDistributor" class="distributor-content">
              <view class="distributor-left">
                <text class="distributor-title">分销中心</text>
                <view class="distributor-stats">
                  <view class="distributor-stat">
                    <text class="stat-value">{{ distributorData.yesterdayCommission.toFixed(2) }}</text>
                    <text class="stat-label">昨日佣金(元)</text>
                  </view>
                  <view class="distributor-stat">
                    <text class="stat-value">{{ distributorData.totalCommission.toFixed(2) }}</text>
                    <text class="stat-label">累计佣金(元)</text>
                  </view>
                  <view class="distributor-stat">
                    <text class="stat-value">{{ distributorData.totalWithdrawn.toFixed(2) }}</text>
                    <text class="stat-label">累计提现(元)</text>
                  </view>
                  <view class="distributor-stat">
                    <text class="stat-value">{{ distributorData.pendingCommission.toFixed(2) }}</text>
                    <text class="stat-label">待结算佣金(元)</text>
                  </view>
                </view>
                <view class="distributor-btn">
                  <text>进入分销中心 ></text>
                </view>
              </view>
              <view class="distributor-right">
                <text class="distributor-illustration">💰💎</text>
              </view>
            </view>
            
            <view v-else class="normal-distribution">
              <view class="normal-left">
                <text class="normal-title">分销中心</text>
                <text class="normal-subtitle">分享商品赚佣金，轻松开启副业</text>
                <view class="normal-btn">
                  <text>申请成为分销员</text>
                </view>
              </view>
              <view class="normal-right">
                <text class="normal-illustration">🎁💰</text>
              </view>
            </view>
          </view>

          <view class="function-card card-animate">
            <view class="function-item" @click="handleMessageCenter">
              <view class="function-icon">
                <text>📩</text>
              </view>
              <view class="function-content">
                <text class="function-title">消息中心</text>
                <text class="function-subtitle">订单、活动、系统通知</text>
              </view>
              <view class="function-right">
                <view v-if="unreadCount > 0" class="function-badge">
                  <text>{{ unreadCount > 99 ? '99+' : unreadCount }}</text>
                </view>
                <text class="function-arrow">›</text>
              </view>
            </view>
            <view class="function-item" @click="handleAddress">
              <view class="function-icon">
                <text>📍</text>
              </view>
              <view class="function-content">
                <text class="function-title">收货地址管理</text>
                <text class="function-subtitle">新增、编辑、默认地址</text>
              </view>
              <view class="function-right">
                <text class="function-arrow">›</text>
              </view>
            </view>
            <view class="function-item" @click="handlePointsMall">
              <view class="function-icon">
                <text>🎁</text>
              </view>
              <view class="function-content">
                <text class="function-title">积分商城</text>
                <text class="function-subtitle">积分兑换商品</text>
              </view>
              <view class="function-right">
                <text class="function-arrow">›</text>
              </view>
            </view>
            <view class="function-item" @click="handleService">
              <view class="function-icon">
                <text>💬</text>
              </view>
              <view class="function-content">
                <text class="function-title">专属客服</text>
                <text class="function-subtitle">7×24小时在线客服</text>
              </view>
              <view class="function-right">
                <text class="function-arrow">›</text>
              </view>
            </view>
          </view>

          <view class="safe-bottom"></view>
        </view>
      </template>
    </scroll-view>

    <custom-tab-bar />
  </view>
</template>

<script setup>
import { useMine } from '@/hooks/useMine'
import { useUserStore } from '@/store/user'
import CustomTabBar from '@/components/global/CustomTabBar.vue'

const userStore = useUserStore()

const {
  loading,
  refreshing,
  userData,
  memberData,
  distributorData,
  orderStats,
  assetStats,
  unreadCount,
  growthProgress,
  handleRefresh
} = useMine()

const formatTime = (minutes) => {
  if (minutes === 0) return '已完成'
  if (minutes < 60) return `00:${minutes.toString().padStart(2, '0')}`
  const h = Math.floor(minutes / 60)
  const m = minutes % 60
  return `${h.toString().padStart(2, '0')}:${m.toString().padStart(2, '0')}`
}

const handleLogin = () => {
  uni.navigateTo({ url: '/pages/login/login' })
}

const handleEditProfile = () => {
  if (!userStore.isLogin) return handleLogin()
  uni.showToast({ title: '编辑资料', icon: 'none' })
}

const handleSettings = () => {
  if (!userStore.isLogin) return handleLogin()
  uni.navigateTo({ url: '/pages/setting/setting' })
}

const handleMessage = () => {
  if (!userStore.isLogin) return handleLogin()
  uni.showToast({ title: '消息中心', icon: 'none' })
}

const handleMemberActivity = () => {
  if (!userStore.isLogin) return handleLogin()
  uni.showToast({ title: '会员专属活动', icon: 'none' })
}

const handleBirthdayGift = () => {
  if (!userStore.isLogin) return handleLogin()
  uni.showToast({ title: '生日礼包', icon: 'none' })
}

const handleCoupon = () => {
  if (!userStore.isLogin) return handleLogin()
  uni.showToast({ title: '我的优惠券', icon: 'none' })
}

const handlePoints = () => {
  if (!userStore.isLogin) return handleLogin()
  uni.showToast({ title: '积分商城', icon: 'none' })
}

const handleGrowth = () => {
  if (!userStore.isLogin) return handleLogin()
  uni.showToast({ title: '成长值明细', icon: 'none' })
}

const handleAllOrders = () => {
  if (!userStore.isLogin) return handleLogin()
  uni.navigateTo({ url: '/pagesSub/order/orderList' })
}

const handleOrder = (type) => {
  if (!userStore.isLogin) return handleLogin()
  const statusMap = {
    pendingPayment: 'WAIT_PAY',
    pendingShipment: 'WAIT_SHIP',
    pendingReceipt: 'WAIT_RECEIVE',
    pendingReview: 'COMPLETED',
    afterSale: 'AFTER_SALE'
  }
  uni.navigateTo({ url: `/pagesSub/order/orderList?status=${statusMap[type] || ''}` })
}

const handleDistribution = () => {
  if (!userStore.isLogin) return handleLogin()
  if (userStore.isDistributor) {
    uni.showToast({ title: '进入分销中心', icon: 'none' })
  } else {
    uni.showToast({ title: '申请成为分销员', icon: 'none' })
  }
}

const handleMessageCenter = () => {
  if (!userStore.isLogin) return handleLogin()
  uni.showToast({ title: '消息中心', icon: 'none' })
}

const handleAddress = () => {
  if (!userStore.isLogin) return handleLogin()
  uni.navigateTo({ url: '/pages/address/list' })
}

const handlePointsMall = () => {
  if (!userStore.isLogin) return handleLogin()
  uni.showToast({ title: '积分商城', icon: 'none' })
}

const handleService = () => {
  if (!userStore.isLogin) return handleLogin()
  uni.showToast({ title: '专属客服', icon: 'none' })
}
</script>

<style lang="scss" scoped>
.page-mine {
  min-height: 100vh;
  background-color: #F8F8F8;
  display: flex;
  flex-direction: column;
}

.page-content {
  flex: 1;
  height: calc(100vh - 100rpx);
}

.skeleton-container {
  padding: 24rpx;
  
  .skeleton-header {
    display: flex;
    align-items: center;
    padding: 40rpx 0;
    background: linear-gradient(180deg, #FFF3E8, #FFFFFF);
    
    .skeleton-avatar {
      width: 80rpx;
      height: 80rpx;
      border-radius: 50%;
      background: rgba(0,0,0,0.1);
      margin-right: 24rpx;
    }
    
    .skeleton-info {
      flex: 1;
      
      .skeleton-name {
        width: 200rpx;
        height: 32rpx;
        background: rgba(0,0,0,0.1);
        border-radius: 8rpx;
        margin-bottom: 16rpx;
      }
      
      .skeleton-id {
        width: 180rpx;
        height: 24rpx;
        background: rgba(0,0,0,0.08);
        border-radius: 8rpx;
      }
    }
    
    .skeleton-icons {
      display: flex;
      
      .skeleton-icon {
        width: 48rpx;
        height: 48rpx;
        background: rgba(0,0,0,0.1);
        border-radius: 50%;
        margin-left: 24rpx;
      }
    }
  }
  
  .skeleton-card {
    background: #FFFFFF;
    border-radius: 24rpx;
    padding: 32rpx;
    margin-bottom: 20rpx;
    
    .skeleton-row {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 24rpx;
      
      .skeleton-text {
        width: 150rpx;
        height: 32rpx;
        background: rgba(0,0,0,0.1);
        border-radius: 8rpx;
      }
      
      .skeleton-arrow {
        width: 40rpx;
        height: 40rpx;
        background: rgba(0,0,0,0.05);
        border-radius: 50%;
      }
    }
    
    .skeleton-bar {
      width: 100%;
      height: 12rpx;
      background: rgba(0,0,0,0.08);
      border-radius: 6rpx;
      margin-bottom: 24rpx;
    }
    
    .skeleton-buttons {
      display: flex;
      
      .skeleton-btn {
        flex: 1;
        height: 72rpx;
        background: rgba(0,0,0,0.05);
        border-radius: 36rpx;
        margin-right: 16rpx;
        
        &:last-child {
          margin-right: 0;
        }
      }
    }
    
    .skeleton-grid {
      display: flex;
      justify-content: space-between;
      
      .skeleton-grid-item {
        display: flex;
        flex-direction: column;
        align-items: center;
        
        .skeleton-grid-icon {
          width: 72rpx;
          height: 72rpx;
          background: rgba(0,0,0,0.08);
          border-radius: 50%;
          margin-bottom: 16rpx;
        }
        
        .skeleton-grid-text {
          width: 80rpx;
          height: 24rpx;
          background: rgba(0,0,0,0.08);
          border-radius: 8rpx;
        }
      }
    }
    
    .skeleton-cell {
      display: flex;
      align-items: center;
      padding: 24rpx 0;
      
      &:not(:last-child) {
        border-bottom: 1rpx solid rgba(0,0,0,0.05);
      }
      
      .skeleton-cell-icon {
        width: 48rpx;
        height: 48rpx;
        background: rgba(0,0,0,0.08);
        border-radius: 50%;
        margin-right: 24rpx;
      }
      
      .skeleton-cell-content {
        flex: 1;
        
        .skeleton-cell-title {
          width: 200rpx;
          height: 32rpx;
          background: rgba(0,0,0,0.1);
          border-radius: 8rpx;
          margin-bottom: 8rpx;
        }
        
        .skeleton-cell-subtitle {
          width: 300rpx;
          height: 24rpx;
          background: rgba(0,0,0,0.08);
          border-radius: 8rpx;
        }
      }
      
      .skeleton-cell-arrow {
        width: 40rpx;
        height: 40rpx;
        background: rgba(0,0,0,0.05);
        border-radius: 50%;
      }
    }
  }
  
  .skeleton-assets {
    display: flex;
    background: #FFFFFF;
    border-radius: 24rpx;
    padding: 32rpx;
    margin-bottom: 20rpx;
    
    .skeleton-asset-item {
      flex: 1;
      display: flex;
      flex-direction: column;
      align-items: center;
      
      .skeleton-asset-icon {
        width: 64rpx;
        height: 64rpx;
        background: rgba(0,0,0,0.08);
        border-radius: 50%;
        margin-bottom: 16rpx;
      }
      
      .skeleton-asset-num {
        width: 100rpx;
        height: 40rpx;
        background: rgba(0,0,0,0.1);
        border-radius: 8rpx;
        margin-bottom: 8rpx;
      }
      
      .skeleton-asset-text {
        width: 120rpx;
        height: 24rpx;
        background: rgba(0,0,0,0.08);
        border-radius: 8rpx;
      }
    }
  }
  
  .skeleton-distribution {
    height: 200rpx;
  }
}

.user-section {
  padding: 32rpx 24rpx;
  background: linear-gradient(180deg, #FFF3E8, #FFFFFF);
  
  .login-prompt {
    display: flex;
    align-items: center;
    padding: 24rpx;
    background: rgba(255,122,0,0.05);
    border-radius: 24rpx;
    
    .login-avatar {
      width: 80rpx;
      height: 80rpx;
      border-radius: 50%;
      background: #FFFFFF;
      display: flex;
      align-items: center;
      justify-content: center;
      margin-right: 24rpx;
      
      .avatar-icon {
        font-size: 40rpx;
      }
    }
    
    .login-info {
      flex: 1;
      
      .login-title {
        font-size: 32rpx;
        font-weight: 600;
        color: #333;
        display: block;
        margin-bottom: 8rpx;
      }
      
      .login-subtitle {
        font-size: 24rpx;
        color: #FF7A00;
      }
    }
    
    .login-arrow {
      font-size: 40rpx;
      color: #999;
    }
  }
  
  .user-info {
    display: flex;
    justify-content: space-between;
    align-items: center;
    
    .user-left {
      display: flex;
      align-items: center;
      
      .user-avatar {
        width: 80rpx;
        height: 80rpx;
        border-radius: 50%;
        overflow: hidden;
        margin-right: 24rpx;
        border: 2rpx solid rgba(255,122,0,0.2);
        position: relative;
        
        image {
          width: 100%;
          height: 100%;
          position: absolute;
          top: 50%;
          left: 50%;
          transform: translate(-50%, -50%);
        }
      }
      
      .user-detail {
        .user-name-row {
          display: flex;
          align-items: center;
          margin-bottom: 8rpx;
          
          .user-name {
            font-size: 32rpx;
            font-weight: 600;
            color: #333;
            margin-right: 16rpx;
          }
          
          .user-tag {
            padding: 4rpx 16rpx;
            border-radius: 20rpx;
            font-size: 20rpx;
            
            &.distributor {
              background: rgba(255,122,0,0.15);
              color: #FF7A00;
            }
            
            &.member {
              background: rgba(255,122,0,0.1);
              color: #FF7A00;
            }
            
            text {
              color: inherit;
            }
          }
        }
        
        .user-id {
          font-size: 24rpx;
          color: #999;
        }
      }
    }
    
    .user-right {
      display: flex;
      
      .user-icon-btn {
        width: 64rpx;
        height: 64rpx;
        display: flex;
        align-items: center;
        justify-content: center;
        margin-left: 24rpx;
        position: relative;
        
        &.message-btn {
          .badge {
            position: absolute;
            top: -4rpx;
            right: -4rpx;
            min-width: 32rpx;
            height: 32rpx;
            background: #FF4D4F;
            border-radius: 16rpx;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 0 8rpx;
            
            text {
              font-size: 20rpx;
              color: #FFFFFF;
            }
          }
        }
        
        text {
          font-size: 36rpx;
        }
      }
    }
  }
}

.content-area {
  padding: 0 24rpx;
  
  .card-animate {
    animation: cardFadeIn 0.3s ease-out forwards;
    opacity: 0;
  }
  
  .member-card {
    background: #FFFFFF;
    border-radius: 24rpx;
    padding: 32rpx;
    margin-bottom: 20rpx;
    box-shadow: 0 8rpx 24rpx rgba(0,0,0,0.05);
    
    .member-left {
      display: flex;
      
      .member-icon {
        width: 72rpx;
        height: 72rpx;
        border-radius: 50%;
        background: linear-gradient(135deg, #FF7A00, #FFA040);
        display: flex;
        align-items: center;
        justify-content: center;
        margin-right: 24rpx;
        
        text {
          font-size: 36rpx;
        }
      }
      
      .member-info {
        flex: 1;
        
        .member-level {
          font-size: 32rpx;
          font-weight: 600;
          color: #333;
          display: block;
          margin-bottom: 8rpx;
        }
        
        .member-growth {
          font-size: 24rpx;
          color: #666;
          display: block;
          margin-bottom: 16rpx;
        }
        
        .growth-bar {
          width: 100%;
          height: 12rpx;
          background: #F0F0F0;
          border-radius: 6rpx;
          overflow: hidden;
          margin-bottom: 8rpx;
          
          .growth-progress {
            height: 100%;
            background: linear-gradient(90deg, #FF7A00, #FFA040);
            border-radius: 6rpx;
            transition: width 0.5s ease;
          }
        }
        
        .growth-tip {
          font-size: 22rpx;
          color: #FF7A00;
        }
      }
    }
    
    .member-buttons {
      display: flex;
      margin-top: 24rpx;
      
      .member-btn {
        flex: 1;
        height: 72rpx;
        border: 1rpx solid #FF7A00;
        border-radius: 36rpx;
        display: flex;
        align-items: center;
        justify-content: center;
        margin-right: 16rpx;
        
        &:last-child {
          margin-right: 0;
        }
        
        &:active {
          transform: scale(0.96);
        }
        
        text {
          font-size: 26rpx;
          color: #FF7A00;
        }
      }
    }
  }
  
  .assets-card {
    background: #FFFFFF;
    border-radius: 24rpx;
    padding: 32rpx;
    margin-bottom: 20rpx;
    box-shadow: 0 8rpx 24rpx rgba(0,0,0,0.05);
    
    display: flex;
    
    .asset-item {
      flex: 1;
      display: flex;
      flex-direction: column;
      align-items: center;
      
      .asset-icon {
        width: 64rpx;
        height: 64rpx;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        margin-bottom: 16rpx;
        
        &.coupon-icon {
          background: rgba(255,122,0,0.1);
        }
        
        &.points-icon {
          background: rgba(255,193,7,0.1);
        }
        
        &.growth-icon {
          background: rgba(74,144,226,0.1);
        }
        
        text {
          font-size: 32rpx;
        }
      }
      
      .asset-info {
        text-align: center;
        
        .asset-num {
          font-size: 32rpx;
          font-weight: 600;
          color: #333;
          display: block;
          margin-bottom: 8rpx;
        }
        
        .asset-title {
          font-size: 26rpx;
          color: #666;
          display: block;
          margin-bottom: 8rpx;
        }
        
        .asset-subtitle {
          font-size: 22rpx;
          color: #999;
          
          &.points-link {
            color: #FF4D4F;
          }
        }
      }
    }
    
    .asset-divider {
      width: 1rpx;
      background: #F0F0F0;
      margin: 0 16rpx;
    }
  }
  
  .orders-card {
    background: #FFFFFF;
    border-radius: 24rpx;
    padding: 32rpx;
    margin-bottom: 20rpx;
    box-shadow: 0 8rpx 24rpx rgba(0,0,0,0.05);
    
    .orders-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 32rpx;
      
      .orders-title {
        font-size: 32rpx;
        font-weight: 600;
        color: #333;
      }
      
      .orders-all {
        text {
          font-size: 26rpx;
          color: #999;
        }
      }
    }
    
    .orders-grid {
      display: flex;
      justify-content: space-between;
      
      .order-item {
        flex: 1;
        display: flex;
        flex-direction: column;
        align-items: center;
        
        .order-icon-wrap {
          width: 72rpx;
          height: 72rpx;
          border-radius: 50%;
          background: #FFF7F0;
          display: flex;
          align-items: center;
          justify-content: center;
          margin-bottom: 16rpx;
          position: relative;
          
          .order-icon {
            font-size: 32rpx;
          }
          
          .order-badge {
            position: absolute;
            top: -8rpx;
            right: -8rpx;
            min-width: 36rpx;
            height: 36rpx;
            background: #FF4D4F;
            border-radius: 18rpx;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 0 10rpx;
            
            text {
              font-size: 22rpx;
              color: #FFFFFF;
            }
          }
        }
        
        .order-name {
          font-size: 26rpx;
          color: #333;
          margin-bottom: 8rpx;
        }
        
        .order-desc {
          font-size: 22rpx;
          color: #999;
        }
      }
    }
  }
  
  .distribution-banner {
    background: linear-gradient(135deg, #FFF7F0, #FFFFFF);
    border-radius: 24rpx;
    padding: 32rpx;
    margin-bottom: 20rpx;
    box-shadow: 0 8rpx 24rpx rgba(255,122,0,0.1);
    
    .distributor-content {
      display: flex;
      
      .distributor-left {
        flex: 1;
        
        .distributor-title {
          font-size: 32rpx;
          font-weight: 600;
          color: #333;
          display: block;
          margin-bottom: 20rpx;
        }
        
        .distributor-stats {
          display: flex;
          flex-wrap: wrap;
          
          .distributor-stat {
            width: 50%;
            margin-bottom: 16rpx;
            
            .stat-value {
              font-size: 36rpx;
              font-weight: 600;
              color: #FF7A00;
              display: block;
            }
            
            .stat-label {
              font-size: 22rpx;
              color: #999;
            }
          }
        }
        
        .distributor-btn {
          margin-top: 20rpx;
          display: inline-flex;
          padding: 16rpx 32rpx;
          background: linear-gradient(135deg, #FF7A00, #FFA040);
          border-radius: 32rpx;
          
          &:active {
            transform: scale(0.96);
          }
          
          text {
            font-size: 26rpx;
            color: #FFFFFF;
            font-weight: 500;
          }
        }
      }
      
      .distributor-right {
        display: flex;
        align-items: center;
        justify-content: center;
        padding-left: 32rpx;
        
        .distributor-illustration {
          font-size: 80rpx;
        }
      }
    }
    
    .normal-distribution {
      display: flex;
      
      .normal-left {
        flex: 1;
        
        .normal-title {
          font-size: 32rpx;
          font-weight: 600;
          color: #333;
          display: block;
          margin-bottom: 12rpx;
        }
        
        .normal-subtitle {
          font-size: 24rpx;
          color: #666;
          display: block;
          margin-bottom: 24rpx;
        }
        
        .normal-btn {
          display: inline-flex;
          padding: 16rpx 32rpx;
          background: linear-gradient(135deg, #FF7A00, #FFA040);
          border-radius: 32rpx;
          
          &:active {
            transform: scale(0.96);
          }
          
          text {
            font-size: 26rpx;
            color: #FFFFFF;
            font-weight: 500;
          }
        }
      }
      
      .normal-right {
        display: flex;
        align-items: center;
        justify-content: center;
        padding-left: 32rpx;
        
        .normal-illustration {
          font-size: 80rpx;
        }
      }
    }
  }
  
  .function-card {
    background: #FFFFFF;
    border-radius: 24rpx;
    padding: 8rpx 0;
    margin-bottom: 20rpx;
    box-shadow: 0 8rpx 24rpx rgba(0,0,0,0.05);
    
    .function-item {
      display: flex;
      align-items: center;
      padding: 28rpx 32rpx;
      
      &:not(:last-child) {
        border-bottom: 1rpx solid #F5F5F5;
      }
      
      &:active {
        background: #FAFAFA;
      }
      
      .function-icon {
        width: 48rpx;
        height: 48rpx;
        display: flex;
        align-items: center;
        justify-content: center;
        margin-right: 24rpx;
        
        text {
          font-size: 32rpx;
        }
      }
      
      .function-content {
        flex: 1;
        
        .function-title {
          font-size: 30rpx;
          color: #333;
          display: block;
          margin-bottom: 6rpx;
        }
        
        .function-subtitle {
          font-size: 22rpx;
          color: #999;
        }
      }
      
      .function-right {
        display: flex;
        align-items: center;
        
        .function-badge {
          min-width: 32rpx;
          height: 32rpx;
          background: #FF4D4F;
          border-radius: 16rpx;
          display: flex;
          align-items: center;
          justify-content: center;
          padding: 0 8rpx;
          margin-right: 16rpx;
          
          text {
            font-size: 20rpx;
            color: #FFFFFF;
          }
        }
        
        .function-arrow {
          font-size: 36rpx;
          color: #CCC;
        }
      }
    }
  }
  
  .safe-bottom {
    height: calc(120rpx + env(safe-area-inset-bottom));
  }
}

@keyframes cardFadeIn {
  from {
    opacity: 0;
    transform: translateY(20rpx);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}
</style>