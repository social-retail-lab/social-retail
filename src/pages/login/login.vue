<template>
  <view class="login-page">
    <view class="header" @click="goBack">
      <view class="back-icon">
        <text class="icon-arrow">‹</text>
      </view>
    </view>
    
    <view class="page-content">
      
      <view class="top-section">
        <view class="login-header">
          <view class="logo">
            <text class="logo-icon">🛍️</text>
          </view>
          <text class="app-name">社交新零售</text>
          <text class="app-slogan">开启您的购物之旅</text>
        </view>
        
        <view class="tab-switch">
          <view 
            class="tab-item" 
            :class="{ 'active': isLoginMode }"
            @click="isLoginMode = true"
          >
            <text>登录</text>
          </view>
          <view 
            class="tab-item" 
            :class="{ 'active': !isLoginMode }"
            @click="isLoginMode = false"
          >
            <text>注册</text>
          </view>
        </view>
        
        <view class="form-card">
          <view class="input-item border-bottom">
            <text class="prefix">+86</text>
            <input
              v-model="formData.phone"
              type="tel"
              maxlength="11"
              placeholder="请输入手机号"
              placeholder-class="placeholder-style"
              class="phone-input font-numeric"
            />
          </view>
          
          <view class="input-item border-bottom">
            <input
              v-model="formData.code"
              type="number"
              maxlength="6"
              placeholder="请输入6位验证码"
              placeholder-class="placeholder-style"
              class="code-input font-numeric"
            />
            <button
              class="get-code-btn"
              :class="{ 'code-disabled': countdown > 0 }"
              @click="handleGetCode"
              :disabled="countdown > 0"
            >
              {{ countdown > 0 ? `${countdown}s 后重新获取` : '获取验证码' }}
            </button>
          </view>
          
          <view v-if="!isLoginMode" class="input-item border-bottom">
            <input
              v-model="formData.password"
              type="password"
              placeholder="请设置登录密码"
              placeholder-class="placeholder-style"
              class="password-input"
            />
          </view>
          
          <view v-if="!isLoginMode" class="input-item">
            <input
              v-model="formData.nickname"
              type="text"
              placeholder="请输入昵称（选填）"
              placeholder-class="placeholder-style"
              class="nickname-input"
            />
          </view>
        </view>
        
        <button
          class="login-btn"
          :class="{ 'btn-disabled': !agreeCheck }"
          :disabled="!agreeCheck"
          @click="handleSubmit"
        >
          {{ isLoginMode ? '登录' : '注册' }}
        </button>
        
        <view class="agree-section">
          <view
            class="checkbox"
            :class="{ 'checked': agreeCheck }"
            @click="agreeCheck = !agreeCheck"
          >
            <text v-if="agreeCheck" class="check-icon">✓</text>
          </view>
          <text class="agree-text">
            我已阅读并同意<text class="text-link" @click="showAgreement">《用户协议》</text>和<text class="text-link" @click="showPrivacy">《隐私政策》</text>
          </text>
        </view>
      </view>

      <view class="split-section">
        <view class="line"></view>
        <text class="split-txt">其他登录方式</text>
        <view class="line"></view>
      </view>
      
      <view class="bottom-section">
        <view class="wx-login-section" @click="wxAuthorize">
          <view class="wx-icon-wrap">
            <image src="/static/fonts/wechat.svg" class="wx-icon" mode="aspectFit" />
          </view>
          <text class="wx-txt">微信登录</text>
        </view>
      </view>

    </view>
    
    <view class="safe-bottom"></view>
    
    <view class="modal-overlay" v-if="bindVisible" @click="bindVisible = false">
      <view class="modal-content" @click.stop>
        <text class="modal-title">绑定手机号</text>
        <view class="modal-form">
          <view class="input-item border-bottom">
            <text class="prefix">+86</text>
            <input
              v-model="bindForm.phone"
              type="tel"
              maxlength="11"
              placeholder="请输入手机号"
              placeholder-class="placeholder-style"
              class="phone-input font-numeric"
            />
          </view>
          <view class="input-item border-bottom">
            <input
              v-model="bindForm.code"
              type="number"
              maxlength="6"
              placeholder="6位验证码"
              placeholder-class="placeholder-style"
              class="code-input font-numeric"
            />
            <button
              class="get-code-btn"
              :class="{ 'code-disabled': bindCountdown > 0 }"
              @click="getBindCode(bindForm.phone)"
              :disabled="bindCountdown > 0"
            >
              {{ bindCountdown > 0 ? `${bindCountdown}s 后重新获取` : '获取验证码' }}
            </button>
          </view>
        </view>
        <button class="confirm-btn" @click="bindSubmit(bindForm)">确认绑定</button>
        <button class="cancel-btn" @click="bindVisible = false">取消</button>
      </view>
    </view>
  </view>
</template>

<script setup>
import { ref, onUnmounted } from 'vue'
import { useAuth } from '@/hooks/useAuth'

const {
  countdown,
  bindCountdown,
  bindVisible,
  getCode,
  phoneRegister,
  phoneLogin,
  wxAuthorize,
  getBindCode,
  bindSubmit,
  clearTimers
} = useAuth()

const isLoginMode = ref(true)

const formData = ref({
  phone: '',
  code: '',
  password: '',
  nickname: ''
})

const bindForm = ref({
  phone: '',
  code: ''
})

const agreeCheck = ref(false)

const goBack = () => uni.navigateBack()
const showAgreement = () => {}
const showPrivacy = () => {}

const handleGetCode = () => {
  const scene = isLoginMode.value ? 'LOGIN' : 'REGISTER'
  getCode(formData.value.phone, scene)
}

const validateForm = () => {
  const { phone, code, password } = formData.value
  
  if (!phone || !/^1[3-9]\d{9}$/.test(phone)) {
    uni.showToast({ title: '请输入正确的11位手机号', icon: 'none' })
    return false
  }
  
  if (!code || code.length !== 6 || !/^\d{6}$/.test(code)) {
    uni.showToast({ title: '请输入6位数字验证码', icon: 'none' })
    return false
  }
  
  if (!isLoginMode.value) {
    if (!password || password.length < 6) {
      uni.showToast({ title: '密码至少6位', icon: 'none' })
      return false
    }
  }
  
  return true
}

const handleSubmit = () => {
  if (!validateForm()) {
    return
  }
  
  if (isLoginMode.value) {
    phoneLogin(formData.value)
  } else {
    phoneRegister(formData.value)
  }
}

onUnmounted(() => {
  clearTimers()
})
</script>

<style lang="scss" scoped>
/* 引入现代化无衬线字体栈与抗锯齿，打底大厂高级骨架 */
.login-page {
  font-family: -apple-system, BlinkMacSystemFont, 'Helvetica Neue', 'PingFang SC', 'Microsoft YaHei', sans-serif;
  min-height: 100vh;
  background: $bg-page-light;
  display: flex;
  flex-direction: column;
  box-sizing: border-box;
  -webkit-font-smoothing: antialiased;
}

/* 专门针对数字输入的等宽西文字体设置，防止验证码和倒计时数字抖动 */
.font-numeric {
  font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif;
  font-variant-numeric: tabular-nums;
}

button {
  background: transparent;
  padding: 0;
  margin: 0;
  line-height: inherit;
  border-radius: 0;
  font-family: inherit;
  &::after {
    border: none;
  }
}

.header {
  padding: 40rpx 40rpx 10rpx;
  flex-shrink: 0;
}

.back-icon {
  width: 64rpx;
  height: 64rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba($text-main, 0.04);
  border-radius: 50%;
  transition: all 0.2s ease;
  &:active {
    background: rgba($text-main, 0.08);
    transform: scale(0.92);
  }
}

.icon-arrow {
  font-size: 52rpx;
  color: $text-main;
  font-weight: 200; 
  line-height: 1;
  margin-top: -6rpx;
}

.page-content {
  flex: 1;
  display: flex;
  flex-direction: column;
  padding: 0 64rpx; 
}

/* 适当压缩上半部分底边距，为下半部分上移腾出空间 */
.top-section {
  flex: 1;
  display: flex;
  flex-direction: column;
  justify-content: center;
  padding-bottom: 10rpx; 
}

/* ✨ 调整：通过给底部分配更大Flex占比，并将内容整体靠上，实现微信登录区域整体上移 */
.bottom-section {
  flex: 1.2; 
  display: flex;
  flex-direction: column;
  justify-content: flex-start;
  padding-top: 10rpx; /* 缩紧顶部间隔 */
}

.login-header {
  display: flex;
  flex-direction: column;
  align-items: center;
  margin-bottom: 48rpx;
  
  .logo {
    width: 132rpx;
    height: 132rpx;
    /* ✨ 修改：直接采用与你登录按钮相同的双色渐变骨架 */
    background: linear-gradient(135deg, $color-primary, $color-primary-danger); 
    border-radius: 40rpx; 
    display: flex;
    align-items: center;
    justify-content: center;
    /* ✨ 修改：对应的主题色发光阴影 */
    box-shadow: 0 16rpx 40rpx rgba($color-primary, 0.2); 
    margin-bottom: 28rpx;
    transition: transform 0.3s ease;
    
    .logo-icon {
      font-size: 64rpx;
    }
  }
  
  .app-name {
    font-size: 44rpx;
    font-weight: 600; 
    color: $text-main;
    letter-spacing: 4rpx;
    text-indent: 4rpx;
    line-height: 1.3;
  }
  
  .app-slogan {
    font-size: 26rpx;
    color: rgba($text-sub, 0.45); 
    margin-top: 14rpx;
    letter-spacing: 2rpx;
    font-weight: 400;
  }
}

.form-card {
  background: transparent;
  margin-bottom: 56rpx;
}

.tab-switch {
  display: flex;
  justify-content: center;
  margin-bottom: 48rpx;
  
  .tab-item {
    padding: 16rpx 48rpx;
    font-size: 32rpx;
    font-weight: 500;
    color: rgba($text-sub, 0.5);
    border-radius: 40rpx;
    transition: all 0.3s ease;
    
    &.active {
      color: #FFFFFF;
      background: linear-gradient(135deg, $color-primary, $color-primary-danger);
      box-shadow: 0 8rpx 24rpx rgba($color-primary-danger, 0.2);
    }
  }
}

.input-item {
  display: flex;
  align-items: center;
  padding: 32rpx 0;
  height: 112rpx; 
  box-sizing: border-box;
  
  &.border-bottom {
    border-bottom: 1rpx solid rgba($text-weak, 0.15); 
  }
}

/* ✨ 修改：+86 降噪变细 */
.prefix {
  font-size: 32rpx;
  font-weight: 400; /* 从 600 改为 400 纤细体 */
  color: rgba($text-main, 0.9); /* 轻微调柔颜色 */
  margin-right: 32rpx;
  font-family: 'Helvetica Neue', Arial, sans-serif;
}

.phone-input,
.code-input {
  flex: 1;
  font-size: 34rpx; 
  color: $text-main;
  height: 100%;
  font-weight: 500;
}

.placeholder-style {
  color: rgba($text-weak, 0.45);
  font-size: 30rpx;
  font-weight: 400;
}

.get-code-btn {
  font-size: 26rpx;
  color: $color-primary;
  font-weight: 500;
  padding: 12rpx 24rpx;
  background: rgba($color-primary, 0.05); 
  border-radius: 32rpx;
  letter-spacing: 1rpx;
  transition: all 0.25s cubic-bezier(0.25, 1, 0.5, 1);
  
  &:active:not(.code-disabled) {
    background: rgba($color-primary, 0.12);
  }
  
  &.code-disabled {
    background: rgba($text-weak, 0.04);
    color: rgba($text-weak, 0.4);
    font-variant-numeric: tabular-nums;
  }
}

.login-btn {
  width: 100%;
  height: 100rpx;
  line-height: 100rpx;
  border-radius: 50rpx;
  background: linear-gradient(135deg, $color-primary 0%, $color-primary-danger 100%);
  color: #FFFFFF;
  font-size: 32rpx;
  font-weight: 600;
  text-align: center;
  letter-spacing: 8rpx; 
  text-indent: 8rpx; 
  box-shadow: 0 12rpx 32rpx rgba($color-primary-danger, 0.2);
  transition: all 0.2s ease;
  
  &:active:not(.btn-disabled) {
    transform: scale(0.98);
    opacity: 0.92;
  }
  
  &.btn-disabled {
    opacity: 0.3;
    box-shadow: none;
  }
}

.agree-section {
  display: flex;
  align-items: flex-start;
  justify-content: center;
  margin-top: 40rpx;
  
  .checkbox {
    width: 34rpx;
    height: 34rpx;
    border: 2rpx solid rgba($text-weak, 0.4);
    border-radius: 50%; 
    display: flex;
    align-items: center;
    justify-content: center;
    margin-right: 16rpx;
    margin-top: 2rpx;
    box-sizing: border-box;
    transition: all 0.2s cubic-bezier(0.25, 1, 0.5, 1);
    
    &.checked {
      background: $color-primary;
      border-color: $color-primary;
    }
  }
  
  .check-icon {
    font-size: 22rpx;
    color: #FFFFFF;
    font-weight: bold;
  }
  
  .agree-text {
    font-size: 24rpx;
    color: rgba($text-sub, 0.6);
    line-height: 38rpx;
  }
  
  .text-link {
    color: $color-assist;
    font-weight: 500;
    margin: 0 2rpx;
    &:active {
      opacity: 0.6;
    }
  }
}

/* ✨ 调整：压缩分割线垂直间距，协助整体上移 */
.split-section {
  flex-shrink: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 32rpx 0; /* 从 48rpx 减小至 32rpx */
  
  .line {
    width: 96rpx; 
    height: 1rpx;
    background: rgba($text-weak, 0.15);
  }
  
  .split-txt {
    font-size: 24rpx;
    color: rgba($text-weak, 0.5);
    margin: 0 28rpx;
    letter-spacing: 2rpx;
  }
}

.wx-login-section {
  display: flex;
  flex-direction: column;
  align-items: center;
  
  .wx-icon-wrap {
    width: 112rpx;
    height: 112rpx;
    border-radius: 50%;
    background: #FFFFFF;
    box-shadow: 0 12rpx 32rpx rgba(0, 0, 0, 0.04);
    display: flex;
    align-items: center;
    justify-content: center;
    transition: transform 0.25s cubic-bezier(0.34, 1.56, 0.64, 1);
    
    &:active {
      transform: scale(0.9);
    }
  }
  
  .wx-icon {
    width: 60rpx;
    height: 60rpx;
  }
  
  .wx-txt {
    font-size: 24rpx;
    color: rgba($text-sub, 0.5);
    margin-top: 20rpx;
    letter-spacing: 1rpx;
  }
}

.safe-bottom {
  padding-bottom: constant(safe-area-inset-bottom);
  padding-bottom: env(safe-area-inset-bottom);
}

/* 弹窗设计高级感统一 */
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.5);
  backdrop-filter: blur(5px); 
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 9999;
}

.modal-content {
  width: 620rpx;
  background: #FFFFFF;
  border-radius: 36rpx;
  padding: 56rpx 48rpx;
  box-shadow: 0 32rpx 80rpx rgba(0, 0, 0, 0.12);
  
  .modal-title {
    font-size: 38rpx;
    font-weight: 600;
    color: $text-main;
    text-align: center;
    display: block;
    margin-bottom: 48rpx;
    letter-spacing: 2rpx;
  }
  
  .modal-form {
    margin-bottom: 64rpx;
  }
  
  .confirm-btn {
    width: 100%;
    height: 96rpx;
    line-height: 96rpx;
    border-radius: 48rpx;
    background: linear-gradient(135deg, $color-primary 0%, $color-primary-danger 100%);
    color: #FFFFFF;
    font-size: 30rpx;
    font-weight: 600;
    letter-spacing: 4rpx;
    text-indent: 4rpx;
    box-shadow: 0 12rpx 28rpx rgba($color-primary-danger, 0.15);
    transition: all 0.2s ease;
    
    &:active {
      transform: scale(0.98);
      opacity: 0.92;
    }
  }
  
  .cancel-btn {
    width: 100%;
    height: 80rpx;
    line-height: 80rpx;
    color: rgba($text-sub, 0.45);
    font-size: 28rpx;
    margin-top: 24rpx;
    letter-spacing: 2rpx;
    
    &:active {
      color: $text-main;
    }
  }
}
</style>