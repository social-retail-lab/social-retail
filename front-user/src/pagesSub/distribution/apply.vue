<template>
  <view class="page-apply">
    <!-- 自定义导航栏 -->
    <view class="nav-bar" :style="{ paddingTop: statusBarHeight + 'px' }">
      <view class="nav-back" @click="handleBack">
        <text class="back-icon">‹</text>
      </view>
      <text class="nav-title">申请成为分销员</text>
      <view class="nav-placeholder-right"></view>
    </view>
    <view class="nav-placeholder" :style="{ height: (statusBarHeight + 44) + 'px' }"></view>

    <!-- 头部说明 -->
    <view class="header-banner">
      <view class="header-icon">🎓</view>
      <view class="header-text">
        <text class="header-title">加入分销员</text>
        <text class="header-desc">分享商品赚佣金，轻松开启副业</text>
      </view>
    </view>

    <!-- 表单 -->
    <view class="form-section">
      <!-- 身份信息 -->
      <view class="form-group">
        <view class="group-title">
          <text class="title-text">身份信息</text>
          <view class="title-line"></view>
        </view>

        <view class="form-item">
          <text class="item-label">真实姓名</text>
          <input
            class="item-input"
            v-model="formData.realName"
            placeholder="请输入真实姓名"
            placeholder-class="placeholder"
            maxlength="10"
          />
        </view>

        <view class="form-item">
          <text class="item-label">身份证号</text>
          <input
            class="item-input"
            v-model="formData.idCardNo"
            placeholder="请输入18位身份证号"
            placeholder-class="placeholder"
            maxlength="18"
          />
        </view>

        <view class="form-item form-item-column">
          <text class="item-label">身份证照片</text>
          <view class="id-card-upload">
            <view class="id-card-box" @click="uploadIdCardFront">
              <image
                v-if="idCardFrontPreview"
                :src="idCardFrontPreview"
                mode="aspectFill"
                class="id-card-img"
              />
              <view v-else class="id-card-placeholder">
                <text class="upload-icon">📷</text>
                <text class="upload-text">身份证正面</text>
              </view>
            </view>
            <view class="id-card-box" @click="uploadIdCardBack">
              <image
                v-if="idCardBackPreview"
                :src="idCardBackPreview"
                mode="aspectFill"
                class="id-card-img"
              />
              <view v-else class="id-card-placeholder">
                <text class="upload-icon">📷</text>
                <text class="upload-text">身份证反面</text>
              </view>
            </view>
          </view>
        </view>
      </view>

      <!-- 银行卡信息 -->
      <view class="form-group">
        <view class="group-title">
          <text class="title-text">银行卡信息</text>
          <view class="title-line"></view>
        </view>

        <view class="form-item" @click="showBankPicker">
          <text class="item-label">开户银行</text>
          <view class="item-select">
            <text :class="['select-text', { 'placeholder': !formData.bankName }]">
              {{ formData.bankName || '请选择开户银行' }}
            </text>
            <text class="select-arrow">›</text>
          </view>
        </view>

        <view class="form-item">
          <text class="item-label">银行卡号</text>
          <input
            class="item-input"
            v-model="formData.bankCardNo"
            placeholder="请输入银行卡号"
            placeholder-class="placeholder"
            type="number"
            maxlength="19"
          />
        </view>

        <view class="form-item">
          <text class="item-label">开户人姓名</text>
          <input
            class="item-input"
            v-model="formData.bankAccountName"
            placeholder="请输入开户人姓名"
            placeholder-class="placeholder"
            maxlength="10"
          />
        </view>
      </view>

      <!-- 提交按钮 -->
      <view class="submit-btn" :class="{ 'btn-loading': distributorStore.applyLoading }" @click="handleSubmit">
        <text class="submit-text">
          {{ distributorStore.applyLoading ? '提交中...' : '提交申请' }}
        </text>
      </view>

      <!-- 温馨提示 -->
      <view class="tips">
        <text class="tips-title">温馨提示</text>
        <text class="tips-content">1. 请确保填写信息真实有效，审核通过后不可修改</text>
        <text class="tips-content">2. 身份证照片需清晰可见，无遮挡</text>
        <text class="tips-content">3. 银行卡需为本人名下，用于佣金提现</text>
        <text class="tips-content">4. 审核周期一般为1-3个工作日</text>
      </view>
    </view>

    <!-- 银行选择弹窗 -->
    <view v-if="bankPickerVisible" class="picker-mask" @click="hideBankPicker">
      <view class="picker-content" @click.stop>
        <view class="picker-header">
          <text class="picker-cancel" @click="hideBankPicker">取消</text>
          <text class="picker-title">选择开户银行</text>
          <view class="picker-confirm"></view>
        </view>
        <scroll-view scroll-y class="picker-list">
          <view
            v-for="bank in bankList"
            :key="bank"
            class="picker-item"
            :class="{ 'item-active': formData.bankName === bank }"
            @click="selectBank(bank)"
          >
            <text class="bank-name">{{ bank }}</text>
            <text v-if="formData.bankName === bank" class="bank-check">✓</text>
          </view>
        </scroll-view>
      </view>
    </view>
  </view>
</template>

<script setup>
import { onLoad } from '@dcloudio/uni-app'
import { useDistributor } from '@/hooks/useDistributor'

const statusBarHeight = uni.getSystemInfoSync().statusBarHeight || 20

const {
  distributorStore,
  formData,
  idCardFrontPreview,
  idCardBackPreview,
  bankPickerVisible,
  bankList,
  uploadIdCardFront,
  uploadIdCardBack,
  showBankPicker,
  hideBankPicker,
  selectBank,
  submitDistributorApply
} = useDistributor()

const handleBack = () => {
  uni.navigateBack({
    delta: 1,
    animationType: 'slide-out-right',
    animationDuration: 200
  })
}

const handleSubmit = async () => {
  await submitDistributorApply()
}

onLoad(() => {
  // 进入申请页时无需特殊处理
})
</script>

<style lang="scss" scoped>
.page-apply {
  min-height: 100vh;
  background: $bg-page;
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
  z-index: 999;
  background: rgba(255, 255, 255, 0.92);
  backdrop-filter: blur(40rpx) saturate(180%);
  -webkit-backdrop-filter: blur(40rpx) saturate(180%);
  border-bottom: 2rpx solid rgba(255, 255, 255, 0.6);
  box-shadow: $shadow-sm;

  .nav-back {
    width: 64rpx;
    height: 64rpx;
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: 50%;

    &:active {
      transform: scale(0.92);
      background: $neutral-100;
    }

    .back-icon {
      font-size: 56rpx;
      color: $ink-900;
      line-height: 1;
      font-weight: 300;
    }
  }

  .nav-title {
    font-size: 34rpx;
    font-weight: 600;
    color: $ink-900;
    letter-spacing: 0.5rpx;
  }

  .nav-placeholder-right {
    width: 64rpx;
  }
}

.nav-placeholder {
  width: 100%;
  flex-shrink: 0;
}

// ============ 头部横幅 ============
.header-banner {
  margin: 24rpx;
  padding: 40rpx 32rpx;
  background: linear-gradient(135deg, #FF6A00 0%, #FF4D4F 100%);
  border-radius: 24rpx;
  display: flex;
  align-items: center;
  box-shadow: 0 12rpx 32rpx rgba(255, 106, 0, 0.3);

  .header-icon {
    font-size: 80rpx;
    margin-right: 24rpx;
  }

  .header-text {
    display: flex;
    flex-direction: column;
    flex: 1;

    .header-title {
      font-size: 36rpx;
      font-weight: 700;
      color: #FFFFFF;
      margin-bottom: 8rpx;
    }

    .header-desc {
      font-size: 24rpx;
      color: rgba(255, 255, 255, 0.85);
    }
  }
}

// ============ 表单 ============
.form-section {
  padding: 0 24rpx 64rpx;
}

.form-group {
  background: $bg-card;
  border-radius: 20rpx;
  padding: 32rpx 24rpx;
  margin-bottom: 24rpx;
  box-shadow: $shadow-sm;
}

.group-title {
  display: flex;
  align-items: center;
  margin-bottom: 24rpx;

  .title-text {
    font-size: 30rpx;
    font-weight: 600;
    color: $ink-900;
    margin-right: 16rpx;
  }

  .title-line {
    flex: 1;
    height: 2rpx;
    background: linear-gradient(90deg, $color-primary 0%, transparent 100%);
    opacity: 0.3;
  }
}

.form-item {
  display: flex;
  align-items: center;
  padding: 24rpx 0;
  border-bottom: 2rpx solid $bg-page-light;

  &:last-child {
    border-bottom: none;
  }

  &.form-item-column {
    flex-direction: column;
    align-items: stretch;

    .item-label {
      margin-bottom: 20rpx;
    }
  }

  .item-label {
    width: 180rpx;
    font-size: 28rpx;
    color: $text-main;
    font-weight: 500;
    flex-shrink: 0;
  }

  .item-input {
    flex: 1;
    font-size: 28rpx;
    color: $ink-900;
  }

  .placeholder {
    color: $text-weak;
  }
}

.item-select {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: space-between;

  .select-text {
    font-size: 28rpx;
    color: $ink-900;

    &.placeholder {
      color: $text-weak;
    }
  }

  .select-arrow {
    font-size: 36rpx;
    color: $text-weak;
    line-height: 1;
  }
}

// ============ 身份证上传 ============
.id-card-upload {
  display: flex;
  gap: 24rpx;
  width: 100%;
}

.id-card-box {
  flex: 1;
  aspect-ratio: 1.6 / 1;
  border: 2rpx dashed $color-primary;
  border-radius: 16rpx;
  overflow: hidden;
  background: rgba(255, 106, 0, 0.04);
  display: flex;
  align-items: center;
  justify-content: center;

  &:active {
    opacity: 0.8;
  }

  .id-card-img {
    width: 100%;
    height: 100%;
  }

  .id-card-placeholder {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;

    .upload-icon {
      font-size: 48rpx;
      margin-bottom: 12rpx;
      opacity: 0.6;
    }

    .upload-text {
      font-size: 24rpx;
      color: $text-weak;
    }
  }
}

// ============ 提交按钮 ============
.submit-btn {
  margin: 32rpx 0;
  height: 96rpx;
  background: linear-gradient(135deg, $color-primary 0%, $color-primary-danger 100%);
  border-radius: 48rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 12rpx 24rpx rgba(255, 106, 0, 0.3);

  &:active {
    transform: scale(0.98);
    box-shadow: 0 6rpx 12rpx rgba(255, 106, 0, 0.3);
  }

  &.btn-loading {
    opacity: 0.7;
    pointer-events: none;
  }

  .submit-text {
    color: #FFFFFF;
    font-size: 32rpx;
    font-weight: 600;
    letter-spacing: 2rpx;
  }
}

// ============ 温馨提示 ============
.tips {
  padding: 24rpx;
  background: rgba(250, 173, 20, 0.06);
  border-radius: 16rpx;
  display: flex;
  flex-direction: column;

  .tips-title {
    font-size: 26rpx;
    color: #FAAD14;
    font-weight: 600;
    margin-bottom: 12rpx;
  }

  .tips-content {
    font-size: 24rpx;
    color: $text-sub;
    line-height: 1.6;
    margin-bottom: 4rpx;
  }
}

// ============ 银行选择弹窗 ============
.picker-mask {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.5);
  z-index: 9999;
  display: flex;
  align-items: flex-end;
}

.picker-content {
  width: 100%;
  background: $bg-card;
  border-radius: 32rpx 32rpx 0 0;
  max-height: 80vh;
  display: flex;
  flex-direction: column;
}

.picker-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 32rpx 24rpx;
  border-bottom: 2rpx solid $bg-page-light;

  .picker-title {
    font-size: 30rpx;
    font-weight: 600;
    color: $ink-900;
  }

  .picker-cancel {
    font-size: 28rpx;
    color: $text-sub;
  }

  .picker-confirm {
    width: 60rpx;
  }
}

.picker-list {
  max-height: 600rpx;
  padding: 16rpx 24rpx;
}

.picker-item {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 28rpx 16rpx;
  border-bottom: 2rpx solid $bg-page-light;

  &:last-child {
    border-bottom: none;
  }

  &:active {
    background: $bg-page-light;
  }

  &.item-active {
    .bank-name {
      color: $color-primary;
      font-weight: 600;
    }
  }

  .bank-name {
    font-size: 30rpx;
    color: $text-main;
  }

  .bank-check {
    color: $color-primary;
    font-size: 36rpx;
    font-weight: 600;
  }
}
</style>
