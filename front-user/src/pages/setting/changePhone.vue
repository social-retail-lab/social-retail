<template>
  <view class="page-change-phone">
    <view class="navbar">
      <view class="navbar-left" @click="goBack">
        <text class="back-icon">‹</text>
      </view>
      <view class="navbar-title">更换绑定手机号</view>
      <view class="navbar-right"></view>
    </view>

    <view class="content">
      <view class="card">
        <view class="form-item">
          <text class="form-label">新手机号</text>
          <view class="form-right">
            <input 
              class="form-input" 
              v-model="newPhone" 
              type="number"
              placeholder="请输入新手机号"
              maxlength="11"
            />
          </view>
        </view>
        <view class="form-divider"></view>
        <view class="form-item">
          <text class="form-label">验证码</text>
          <view class="form-right">
            <input 
              class="form-input code-input" 
              v-model="code" 
              type="number"
              placeholder="请输入验证码"
              maxlength="6"
            />
            <view 
              class="send-btn" 
              :class="{ disabled: userProfileHook.countdown.value > 0 }"
              @click="handleSendCode"
            >
              <text class="send-text">{{ userProfileHook.countdown.value > 0 ? userProfileHook.countdown.value + 's' : '获取验证码' }}</text>
            </view>
          </view>
        </view>
      </view>

      <view class="tip-card">
        <text class="tip-title">温馨提示</text>
        <text class="tip-content">请确保您能正常接收短信，更换手机号后将使用新号码登录。</text>
      </view>

      <view class="submit-btn" @click="handleSubmit">
        <text class="submit-text">确认更换</text>
      </view>
    </view>
  </view>
</template>

<script setup>
import { ref, onUnmounted } from "vue"
import { useUserProfile } from "@/hooks/useUserProfile"

const userProfileHook = useUserProfile()

const newPhone = ref('')
const code = ref('')

const goBack = () => {
  uni.navigateBack()
}

const handleSendCode = () => {
  userProfileHook.loadSendChangePhoneCode(newPhone.value)
}

const handleSubmit = () => {
  userProfileHook.loadUpdatePhone({ newPhone: newPhone.value, code: code.value })
}

onUnmounted(() => {
  userProfileHook.clearTimer()
})
</script>

<style lang="scss" scoped>
.page-change-phone {
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

.code-input {
  width: 200rpx;
  margin-right: 20rpx;
}

.send-btn {
  padding: 16rpx 32rpx;
  background-color: #FF6A00;
  border-radius: 32rpx;
}

.send-btn.disabled {
  background-color: #CCCCCC;
}

.send-text {
  font-size: 26rpx;
  color: #FFFFFF;
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