<template>
  <view class="page-setting">
    <view class="navbar">
      <view class="navbar-left" @click="goBack">
        <text class="back-icon">‹</text>
      </view>
      <view class="navbar-title">设置</view>
      <view class="navbar-right"></view>
    </view>

    <scroll-view class="content" scroll-y>
      <view class="card">
        <view class="cell" @click="goUserInfo">
          <view class="cell-icon user-icon">
            <text class="icon-text">👤</text>
          </view>
          <view class="cell-content">
            <text class="cell-title">个人资料</text>
            <text class="cell-subtitle">修改昵称、头像等个人资料</text>
          </view>
          <text class="cell-arrow">›</text>
        </view>
        <view class="cell-divider"></view>
        <view class="cell">
          <view class="cell-icon phone-icon">
            <text class="icon-text">📱</text>
          </view>
          <view class="cell-content">
            <text class="cell-title">绑定手机号</text>
            <text class="cell-subtitle">{{ formatPhone(userStore.userInfo.phone) }}</text>
          </view>
          <text class="cell-value">{{ formatPhone(userStore.userInfo.phone) }}</text>
        </view>
        <view class="cell-divider"></view>
        <view class="cell">
          <view class="cell-icon id-icon">
            <text class="icon-text">🆔</text>
          </view>
          <view class="cell-content">
            <text class="cell-title">用户 ID</text>
            <text class="cell-subtitle">UID{{ userStore.userInfo.userId }}</text>
          </view>
          <text class="cell-value">UID{{ userStore.userInfo.userId }}</text>
        </view>
      </view>


      <view class="card">
        <view class="cell" @click="goChangePhone">
          <view class="cell-icon change-phone-icon">
            <text class="icon-text">📞</text>
          </view>
          <view class="cell-content">
            <text class="cell-title">修改绑定手机号</text>
            <text class="cell-subtitle">更换绑定的手机号</text>
          </view>
          <text class="cell-arrow">›</text>
        </view>
        <view class="cell-divider"></view>
        <view class="cell" @click="goChangePassword">
          <view class="cell-icon password-icon">
            <text class="icon-text">🔒</text>
          </view>
          <view class="cell-content">
            <text class="cell-title">登录密码修改/设置</text>
            <text class="cell-subtitle">修改或设置登录密码</text>
          </view>
          <text class="cell-arrow">›</text>
        </view>
      </view>

      <view class="card">
        <view class="cell" @click="goPaySetting">
          <view class="cell-icon pay-icon">
            <text class="icon-text">💳</text>
          </view>
          <view class="cell-content">
            <text class="cell-title">支付设置</text>
            <text class="cell-subtitle">管理支付方式、支付密码等</text>
          </view>
          <text class="cell-arrow">›</text>
        </view>
        <view class="cell-divider"></view>
        <view class="cell" @click="goThirdBind">
          <view class="cell-icon wx-icon">
            <text class="icon-text">💬</text>
          </view>
          <view class="cell-content">
            <text class="cell-title">第三方账号绑定</text>
            <text class="cell-subtitle">绑定/解绑微信号，快捷登录</text>
          </view>
          <view class="cell-right">
            <text class="cell-bind">已绑定</text>
            <text class="cell-arrow">›</text>
          </view>
        </view>
        <view class="cell-divider"></view>
        <view class="cell" @click="goAddress">
          <view class="cell-icon address-icon">
            <text class="icon-text">📍</text>
          </view>
          <view class="cell-content">
            <text class="cell-title">收货地址</text>
            <text class="cell-subtitle">管理我的收货地址</text>
          </view>
          <text class="cell-arrow">›</text>
        </view>
      </view>
    </scroll-view>

    <view class="footer">
      <view class="logout-btn" @click="handleLogout">
        <text class="logout-text">退出登录</text>
      </view>
    </view>
  </view>
</template>

<script setup>
import { useUserStore } from "@/store/user"
import { useAuth } from "@/hooks/useAuth"

const userStore = useUserStore()
const authHook = useAuth()

const goBack = () => {
  uni.navigateBack()
}

const formatPhone = (phone) => {
  if (!phone) return ''
  return phone.replace(/(\d{3})\d{4}(\d{4})/, '$1****$2')
}

const goUserInfo = () => {
  uni.navigateTo({ url: '/pages/setting/userInfo' })
}

const goChangePhone = () => {
  uni.navigateTo({ url: '/pages/setting/changePhone' })
}

const goChangePassword = () => {
  uni.navigateTo({ url: '/pages/setting/changePassword' })
}

const goPaySetting = () => {
  uni.showToast({ title: '支付设置功能开发中', icon: 'none' })
}

const goThirdBind = () => {
  uni.showToast({ title: '第三方账号绑定功能开发中', icon: 'none' })
}

const goAddress = () => {
  uni.navigateTo({ url: '/pages/address/list' })
}

const handleLogout = () => {
  uni.showModal({
    title: '确认退出',
    content: '确定要退出登录吗？',
    success: (res) => {
      if (res.confirm) {
        authHook.logout()
      }
    }
  })
}
</script>

<style lang="scss" scoped>
.page-setting {
  min-height: 100vh;
  background-color: #F8F8F8;
  display: flex;
  flex-direction: column;
}

.navbar {
  height: 88rpx;
  background-color: #FFFFFF;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 32rpx;
  position: sticky;
  top: 0;
  z-index: 100;
}

.navbar-left {
  width: 80rpx;
  display: flex;
  align-items: center;
}

.back-icon {
  font-size: 48rpx;
  color: #333333;
}

.navbar-title {
  font-size: 34rpx;
  font-weight: 600;
  color: #333333;
}

.navbar-right {
  width: 80rpx;
}

.content {
  flex: 1;
  padding: 24rpx;
}

.card {
  background-color: #FFFFFF;
  border-radius: 20rpx;
  margin-bottom: 24rpx;
  overflow: hidden;
}

.cell {
  display: flex;
  align-items: center;
  padding: 32rpx;
}

.cell-icon {
  width: 72rpx;
  height: 72rpx;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 24rpx;
}

.icon-text {
  font-size: 32rpx;
}

.user-icon {
  background-color: rgba(255, 106, 0, 0.1);
}

.phone-icon {
  background-color: rgba(24, 144, 255, 0.1);
}

.id-icon {
  background-color: rgba(250, 204, 21, 0.1);
}

.change-phone-icon {
  background-color: rgba(24, 144, 255, 0.15);
}

.password-icon {
  background-color: rgba(82, 196, 26, 0.15);
}

.pay-icon {
  background-color: rgba(255, 193, 7, 0.15);
}

.wx-icon {
  background-color: rgba(82, 196, 26, 0.15);
}

.address-icon {
  background-color: rgba(144, 19, 254, 0.15);
}

.cell-content {
  flex: 1;
  display: flex;
  flex-direction: column;
}

.cell-title {
  font-size: 32rpx;
  font-weight: 600;
  color: #333333;
  margin-bottom: 8rpx;
}

.cell-subtitle {
  font-size: 24rpx;
  color: #999999;
}

.cell-arrow {
  font-size: 32rpx;
  color: #CCCCCC;
  margin-left: 16rpx;
}

.cell-value {
  font-size: 28rpx;
  color: #666666;
  margin-left: 16rpx;
}

.cell-right {
  display: flex;
  align-items: center;
}

.cell-bind {
  font-size: 26rpx;
  color: #999999;
  margin-right: 8rpx;
}

.cell-divider {
  height: 2rpx;
  background-color: #F5F5F5;
  margin: 0 32rpx;
}

.hint-text {
  font-size: 24rpx;
  color: #999999;
  margin-top: -16rpx;
  margin-bottom: 32rpx;
  padding-left: 32rpx;
}

.footer {
  padding: 24rpx 32rpx 48rpx;
}

.logout-btn {
  height: 88rpx;
  background-color: #FFFFFF;
  border-radius: 12rpx;
  display: flex;
  align-items: center;
  justify-content: center;
}

.logout-text {
  font-size: 32rpx;
  color: #FF4D4F;
  font-weight: 500;
}
</style>