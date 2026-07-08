<template>
  <view class="page-change-password">
    <view class="navbar">
      <view class="navbar-left" @click="goBack">
        <text class="back-icon">‹</text>
      </view>
      <view class="navbar-title">修改登录密码</view>
      <view class="navbar-right"></view>
    </view>

    <view class="content">
      <view class="card">
        <view class="form-item">
          <text class="form-label">原密码</text>
          <view class="form-right">
            <input 
              class="form-input" 
              v-model="oldPassword" 
              type="password"
              placeholder="请输入原密码"
            />
          </view>
        </view>
        <view class="form-divider"></view>
        <view class="form-item">
          <text class="form-label">新密码</text>
          <view class="form-right">
            <input 
              class="form-input" 
              v-model="newPassword" 
              type="password"
              placeholder="请输入新密码"
            />
          </view>
        </view>
        <view class="form-divider"></view>
        <view class="form-item">
          <text class="form-label">确认密码</text>
          <view class="form-right">
            <input 
              class="form-input" 
              v-model="confirmPassword" 
              type="password"
              placeholder="请再次输入新密码"
            />
          </view>
        </view>
      </view>

      <view class="tip-card">
        <text class="tip-title">密码设置要求</text>
        <text class="tip-content">密码长度为6-20位，建议使用字母、数字和特殊字符组合，以提高安全性。</text>
      </view>

      <view class="submit-btn" @click="handleSubmit">
        <text class="submit-text">确认修改</text>
      </view>
    </view>
  </view>
</template>

<script setup>
import { ref } from "vue"
import { useUserProfile } from "@/hooks/useUserProfile"

const userProfileHook = useUserProfile()

const oldPassword = ref('')
const newPassword = ref('')
const confirmPassword = ref('')

const goBack = () => {
  uni.navigateBack()
}

const handleSubmit = () => {
  if (newPassword.value !== confirmPassword.value) {
    return uni.showToast({ title: '两次输入的密码不一致', icon: 'none' })
  }

  userProfileHook.loadUpdatePassword({ 
    oldPassword: oldPassword.value, 
    newPassword: newPassword.value 
  })
}
</script>

<style lang="scss" scoped>
.page-change-password {
  min-height: 100vh;
  background-color: #F8F8F8;
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
  padding: 24rpx;
}

.card {
  background-color: #FFFFFF;
  border-radius: 20rpx;
  padding: 0 32rpx;
}

.form-item {
  display: flex;
  align-items: center;
  justify-content: space-between;
  height: 100rpx;
}

.form-label {
  font-size: 32rpx;
  color: #333333;
  font-weight: 500;
}

.form-right {
  display: flex;
  align-items: center;
}

.form-input {
  font-size: 32rpx;
  color: #333333;
  text-align: right;
}

.form-divider {
  height: 2rpx;
  background-color: #F5F5F5;
}

.tip-card {
  margin-top: 32rpx;
  background-color: rgba(255, 106, 0, 0.05);
  border-radius: 12rpx;
  padding: 24rpx;
}

.tip-title {
  font-size: 28rpx;
  color: #FF6A00;
  font-weight: 500;
  display: block;
  margin-bottom: 12rpx;
}

.tip-content {
  font-size: 24rpx;
  color: #999999;
  line-height: 1.6;
}

.submit-btn {
  margin-top: 48rpx;
  height: 96rpx;
  background: linear-gradient(135deg, #FF6A00, #FF4D4F);
  border-radius: 48rpx;
  display: flex;
  align-items: center;
  justify-content: center;
}

.submit-text {
  font-size: 32rpx;
  color: #FFFFFF;
  font-weight: 600;
}
</style>