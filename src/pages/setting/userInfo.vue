<template>
  <view class="page-user-info">
    <view class="navbar">
      <view class="navbar-left" @click="goBack">
        <text class="back-icon">‹</text>
      </view>
      <view class="navbar-title">个人信息</view>
      <view class="navbar-right" @click="handleSave">
        <text class="save-text">保存</text>
      </view>
    </view>

    <view class="content">
      <view class="card">
        <view class="form-item">
          <text class="form-label">头像</text>
          <view class="form-right">
            <view class="avatar-wrapper" @click="chooseAvatar">
              <image
                class="avatar"
                :src="avatar || userStore.userInfo.avatar || defaultAvatar"
                mode="aspectFill"
              />
              <view class="avatar-upload">
                <text class="upload-icon">+</text>
              </view>
            </view>
          </view>
        </view>
        <view class="form-divider"></view>
        <view class="form-item">
          <text class="form-label">昵称</text>
          <view class="form-right">
            <input 
              class="form-input" 
              v-model="nickname" 
              placeholder="请输入昵称"
              maxlength="20"
            />
          </view>
        </view>
      </view>

      <view class="tip-card">
        <text class="tip-title">温馨提示</text>
        <text class="tip-content">头像和昵称修改后将立即生效，请谨慎操作。</text>
      </view>
    </view>
  </view>
</template>

<script setup>
import { ref, onMounted } from "vue"
import { useUserStore } from '@/store/user'
import { showToast } from '@/utils/common'

const userStore = useUserStore()

const nickname = ref('')
const avatar = ref('')

const defaultAvatar = 'https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=simple%20user%20avatar%20icon%20neutral%20background&image_size=square'

onMounted(() => {
  nickname.value = userStore.userInfo.nickname || ''
  avatar.value = userStore.userInfo.avatar || ''
})

const goBack = () => {
  uni.navigateBack()
}

const chooseAvatar = () => {
  uni.chooseImage({
    count: 1,
    sizeType: ['compressed'],
    sourceType: ['album', 'camera'],
    success: (res) => {
      const tempFilePath = res.tempFilePaths[0]
      avatar.value = tempFilePath
      uni.showToast({ title: '头像已选择', icon: 'success' })
    },
    fail: () => {
      uni.showToast({ title: '选择图片失败', icon: 'none' })
    }
  })
}

const handleSave = async () => {
  try {
    const res = await userStore.fetchUpdateUserInfo({ 
      nickname: nickname.value, 
      avatar: avatar.value 
    })
    if (res) {
      userStore.updateUserInfo(res)
      await userStore.fetchUserInfo()
      showToast('修改成功')
      setTimeout(() => {
        uni.navigateBack()
      }, 1000)
    } else {
      showToast('修改失败')
    }
  } catch (error) {
    console.error('修改用户信息失败:', error)
    showToast('修改失败')
  }
}
</script>

<style lang="scss" scoped>
.page-user-info {
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
  display: flex;
  align-items: center;
  justify-content: flex-end;
}

.save-text {
  font-size: 30rpx;
  color: #FF6A00;
  font-weight: 500;
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

.avatar-wrapper {
  position: relative;
  width: 120rpx;
  height: 120rpx;
}

.avatar {
  width: 100%;
  height: 100%;
  border-radius: 50%;
}

.avatar-upload {
  position: absolute;
  bottom: 0;
  right: 0;
  width: 40rpx;
  height: 40rpx;
  background-color: #FF6A00;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
}

.upload-icon {
  font-size: 28rpx;
  color: #FFFFFF;
  font-weight: bold;
}

.form-input {
  font-size: 32rpx;
  color: #333333;
  text-align: right;
  width: 300rpx;
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
</style>