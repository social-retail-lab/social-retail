<template>
  <view class="page-withdraw">
    <!-- 自定义导航栏 -->
    <view class="nav-bar" :style="{ paddingTop: statusBarHeight + 'px' }">
      <view class="nav-back" @click="handleBack">
        <text class="back-icon">‹</text>
      </view>
      <text class="nav-title">佣金提现</text>
      <view class="nav-right" @click="goRecords">
        <text class="right-text">提现记录</text>
      </view>
    </view>
    <view class="nav-placeholder" :style="{ height: (statusBarHeight + 44) + 'px' }"></view>

    <scroll-view scroll-y class="content-scroll">
      <!-- 可提现金额卡片 -->
      <view class="balance-card">
        <view class="balance-bg"></view>
        <view class="balance-content">
          <text class="balance-label">可提现佣金（元）</text>
          <text class="balance-value">{{ formatMoney(availableCommission) }}</text>
          <view class="balance-sub">
            <view class="sub-item">
              <text class="sub-label">累计佣金</text>
              <text class="sub-value">¥{{ formatMoney(dashboardData?.totalCommission) }}</text>
            </view>
            <view class="sub-divider"></view>
            <view class="sub-item">
              <text class="sub-label">冻结中</text>
              <text class="sub-value">¥{{ formatMoney(dashboardData?.frozenCommission) }}</text>
            </view>
          </view>
        </view>
      </view>

      <!-- 提现表单 -->
      <view class="form-card">
        <view class="card-title">
          <text class="title-text">提现信息</text>
        </view>

        <!-- 提现金额 -->
        <view class="form-item">
          <view class="form-label">
            <text class="label-text">提现金额</text>
            <text class="label-required">*</text>
          </view>
          <view class="amount-input-wrap">
            <text class="currency-symbol">¥</text>
            <input
              class="amount-input"
              type="digit"
              v-model="formData.amount"
              placeholder="请输入提现金额"
              placeholder-class="placeholder"
              :maxlength="10"
            />
            <view class="quick-btns">
              <view class="quick-btn" @click="setAllAmount">
                <text class="quick-text">全部</text>
              </view>
            </view>
          </view>
          <view class="form-tip">
            <text class="tip-text">最低提现金额 ¥10.00</text>
          </view>
        </view>

        <!-- 开户人姓名 -->
        <view class="form-item">
          <view class="form-label">
            <text class="label-text">开户人姓名</text>
            <text class="label-required">*</text>
          </view>
          <input
            class="form-input"
            v-model="formData.accountName"
            placeholder="请输入开户人姓名"
            placeholder-class="placeholder"
            :maxlength="20"
          />
        </view>

        <!-- 开户银行 -->
        <view class="form-item" @click="showBankPicker = true">
          <view class="form-label">
            <text class="label-text">开户银行</text>
            <text class="label-required">*</text>
          </view>
          <view class="form-picker">
            <text
              class="picker-text"
              :class="{ 'picker-placeholder': !formData.bankName }"
            >
              {{ formData.bankName || '请选择开户银行' }}
            </text>
            <text class="picker-arrow">›</text>
          </view>
        </view>

        <!-- 银行卡号 -->
        <view class="form-item">
          <view class="form-label">
            <text class="label-text">银行卡号</text>
            <text class="label-required">*</text>
          </view>
          <input
            class="form-input"
            v-model="formData.bankCardNo"
            placeholder="请输入16-19位银行卡号"
            placeholder-class="placeholder"
            type="number"
            :maxlength="19"
          />
        </view>
      </view>

      <!-- 温馨提示 -->
      <view class="tips-card">
        <view class="tips-title">
          <text class="tips-icon">💡</text>
          <text class="tips-title-text">温馨提示</text>
        </view>
        <view class="tips-list">
          <view class="tip-item">
            <text class="tip-dot">·</text>
            <text class="tip-content">提现申请提交后，预计 1-3 个工作日到账</text>
          </view>
          <view class="tip-item">
            <text class="tip-dot">·</text>
            <text class="tip-content">提现金额最低 ¥10.00，最高不超过可提现佣金</text>
          </view>
          <view class="tip-item">
            <text class="tip-dot">·</text>
            <text class="tip-content">提现申请处理中，对应佣金将暂时冻结</text>
          </view>
          <view class="tip-item">
            <text class="tip-dot">·</text>
            <text class="tip-content">请确认银行卡信息正确，避免提现失败</text>
          </view>
        </view>
      </view>

      <view class="safe-bottom"></view>
    </scroll-view>

    <!-- 底部提现按钮 -->
    <view class="bottom-bar">
      <view
        class="submit-btn"
        :class="{ 'btn-disabled': distributorStore.withdrawApplyLoading || !canSubmit }"
        @click="handleSubmit"
      >
        <text class="submit-text">
          {{ distributorStore.withdrawApplyLoading ? '提交中...' : '确认提现' }}
        </text>
      </view>
    </view>

    <!-- 银行选择弹窗 -->
    <view v-if="showBankPicker" class="bank-picker-mask" @click="showBankPicker = false">
      <view class="bank-picker" @click.stop>
        <view class="picker-header">
          <text class="picker-title">选择开户银行</text>
          <view class="picker-close" @click="showBankPicker = false">
            <text class="close-icon">✕</text>
          </view>
        </view>
        <scroll-view scroll-y class="bank-list">
          <view
            v-for="bank in bankList"
            :key="bank"
            class="bank-item"
            :class="{ 'bank-item-active': formData.bankName === bank }"
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
import { ref, computed } from 'vue'
import { onShow } from '@dcloudio/uni-app'
import { useDistributor } from '@/hooks/useDistributor'

const statusBarHeight = uni.getSystemInfoSync().statusBarHeight || 20

const {
  distributorStore,
  loadDashboard,
  submitWithdraw,
  bankList,
  formatMoney
} = useDistributor()

// 表单数据
const formData = ref({
  amount: '',
  bankName: '',
  bankCardNo: '',
  accountName: ''
})

const showBankPicker = ref(false)

// 可提现佣金
const availableCommission = computed(() => {
  return Number(distributorStore.dashboardData?.availableCommission || 0)
})

// 是否可提交
const canSubmit = computed(() => {
  const amount = Number(formData.value.amount || 0)
  return amount >= 10 &&
    amount <= availableCommission.value &&
    !!formData.value.bankName &&
    !!formData.value.bankCardNo &&
    !!formData.value.accountName
})

const handleBack = () => {
  uni.navigateBack({
    delta: 1,
    animationType: 'slide-out-right',
    animationDuration: 200
  })
}

// 跳转提现记录
const goRecords = () => {
  uni.navigateTo({ url: '/pagesSub/distribution/commission/withdrawRecords' })
}

// 全部提现
const setAllAmount = () => {
  formData.value.amount = availableCommission.value.toFixed(2)
}

// 选择银行
const selectBank = (bank) => {
  formData.value.bankName = bank
  showBankPicker.value = false
}

// 提交提现申请
const handleSubmit = async () => {
  if (distributorStore.withdrawApplyLoading || !canSubmit.value) return

  const success = await submitWithdraw({
    amount: Number(formData.value.amount),
    bankName: formData.value.bankName,
    bankCardNo: formData.value.bankCardNo,
    accountName: formData.value.accountName
  })

  if (success) {
    // 提现成功，重置表单并刷新工作台数据
    formData.value = {
      amount: '',
      bankName: '',
      bankCardNo: '',
      accountName: ''
    }
    setTimeout(() => {
      uni.navigateBack()
    }, 1500)
  }
}

onShow(() => {
  // 加载工作台数据，获取最新可提现佣金
  if (!distributorStore.dashboardData) {
    loadDashboard()
  }
})
</script>

<style lang="scss" scoped>
.page-withdraw {
  min-height: 100vh;
  background: $bg-page;
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
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(20rpx);
  z-index: 100;
  border-bottom: 1rpx solid rgba(0, 0, 0, 0.04);

  .nav-back {
    width: 64rpx;
    height: 64rpx;
    display: flex;
    align-items: center;
    justify-content: center;

    .back-icon {
      font-size: 48rpx;
      color: $text-main;
      line-height: 1;
    }
  }

  .nav-title {
    font-size: 32rpx;
    font-weight: 600;
    color: $text-main;
  }

  .nav-right {
    padding: 8rpx 16rpx;

    .right-text {
      font-size: 26rpx;
      color: $color-primary;
    }
  }
}

.nav-placeholder {
  width: 100%;
}

// ============ 内容区 ============
.content-scroll {
  flex: 1;
  padding-bottom: 160rpx;
}

// ============ 余额卡片 ============
.balance-card {
  position: relative;
  margin: 16rpx 24rpx;
  border-radius: 24rpx;
  overflow: hidden;

  .balance-bg {
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: linear-gradient(135deg, #FF6A00 0%, #FF9248 100%);
  }

  .balance-content {
    position: relative;
    padding: 40rpx 32rpx;
    z-index: 1;

    .balance-label {
      font-size: 24rpx;
      color: rgba(255, 255, 255, 0.85);
    }

    .balance-value {
      display: block;
      font-size: 64rpx;
      color: #FFFFFF;
      font-weight: 700;
      margin-top: 12rpx;
      letter-spacing: 2rpx;
    }

    .balance-sub {
      display: flex;
      align-items: center;
      margin-top: 24rpx;
      padding-top: 24rpx;
      border-top: 1rpx solid rgba(255, 255, 255, 0.2);

      .sub-item {
        flex: 1;
        display: flex;
        flex-direction: column;

        .sub-label {
          font-size: 22rpx;
          color: rgba(255, 255, 255, 0.7);
          margin-bottom: 4rpx;
        }

        .sub-value {
          font-size: 26rpx;
          color: #FFFFFF;
          font-weight: 500;
        }
      }

      .sub-divider {
        width: 1rpx;
        height: 48rpx;
        background: rgba(255, 255, 255, 0.2);
      }
    }
  }
}

// ============ 表单卡片 ============
.form-card {
  margin: 16rpx 24rpx;
  background: $bg-card;
  border-radius: 20rpx;
  padding: 24rpx;

  .card-title {
    padding-bottom: 16rpx;
    border-bottom: 1rpx solid rgba(0, 0, 0, 0.04);
    margin-bottom: 8rpx;

    .title-text {
      font-size: 30rpx;
      color: $text-main;
      font-weight: 600;
    }
  }
}

.form-item {
  padding: 20rpx 0;
  border-bottom: 1rpx solid rgba(0, 0, 0, 0.04);

  &:last-child {
    border-bottom: none;
  }

  .form-label {
    display: flex;
    align-items: center;
    margin-bottom: 16rpx;

    .label-text {
      font-size: 28rpx;
      color: $text-sub;
    }

    .label-required {
      font-size: 28rpx;
      color: #FF4D4F;
      margin-left: 4rpx;
    }
  }

  .form-input {
    width: 100%;
    height: 80rpx;
    font-size: 30rpx;
    color: $text-main;
    background: $bg-page;
    border-radius: 12rpx;
    padding: 0 24rpx;
    box-sizing: border-box;
  }

  .placeholder {
    color: $text-weak;
    font-size: 28rpx;
  }
}

// 金额输入框
.amount-input-wrap {
  display: flex;
  align-items: center;
  height: 96rpx;
  background: $bg-page;
  border-radius: 12rpx;
  padding: 0 24rpx;

  .currency-symbol {
    font-size: 40rpx;
    color: $text-main;
    font-weight: 600;
    margin-right: 12rpx;
  }

  .amount-input {
    flex: 1;
    height: 96rpx;
    font-size: 40rpx;
    color: $text-main;
    font-weight: 600;
  }

  .quick-btns {
    display: flex;
    align-items: center;

    .quick-btn {
      padding: 8rpx 20rpx;
      background: rgba($color-primary, 0.1);
      border-radius: 24rpx;

      .quick-text {
        font-size: 24rpx;
        color: $color-primary;
        font-weight: 500;
      }
    }
  }
}

.form-tip {
  margin-top: 12rpx;

  .tip-text {
    font-size: 22rpx;
    color: $text-weak;
  }
}

// 选择器
.form-picker {
  display: flex;
  align-items: center;
  justify-content: space-between;
  height: 80rpx;
  background: $bg-page;
  border-radius: 12rpx;
  padding: 0 24rpx;

  .picker-text {
    font-size: 30rpx;
    color: $text-main;

    &.picker-placeholder {
      color: $text-weak;
      font-size: 28rpx;
    }
  }

  .picker-arrow {
    font-size: 36rpx;
    color: $text-weak;
  }
}

// ============ 温馨提示 ============
.tips-card {
  margin: 16rpx 24rpx;
  background: $bg-card;
  border-radius: 20rpx;
  padding: 24rpx;

  .tips-title {
    display: flex;
    align-items: center;
    margin-bottom: 16rpx;

    .tips-icon {
      font-size: 28rpx;
      margin-right: 8rpx;
    }

    .tips-title-text {
      font-size: 28rpx;
      color: $text-main;
      font-weight: 600;
    }
  }

  .tips-list {
    display: flex;
    flex-direction: column;
    gap: 10rpx;
  }

  .tip-item {
    display: flex;
    align-items: flex-start;

    .tip-dot {
      font-size: 24rpx;
      color: $color-primary;
      margin-right: 8rpx;
      line-height: 1.5;
    }

    .tip-content {
      flex: 1;
      font-size: 24rpx;
      color: $text-sub;
      line-height: 1.6;
    }
  }
}

// ============ 底部按钮 ============
.bottom-bar {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  padding: 16rpx 24rpx;
  padding-bottom: calc(16rpx + env(safe-area-inset-bottom));
  background: $bg-card;
  box-shadow: 0 -4rpx 16rpx rgba(0, 0, 0, 0.04);
  z-index: 100;

  .submit-btn {
    height: 88rpx;
    background: linear-gradient(135deg, #FF6A00 0%, #FF9248 100%);
    border-radius: 44rpx;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: all 0.2s ease;

    &:active {
      transform: scale(0.98);
    }

    &.btn-disabled {
      background: #CCCCCC;
      opacity: 0.6;
    }

    .submit-text {
      font-size: 30rpx;
      color: #FFFFFF;
      font-weight: 600;
    }
  }
}

.safe-bottom {
  height: 32rpx;
}

// ============ 银行选择弹窗 ============
.bank-picker-mask {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.5);
  z-index: 1000;
  display: flex;
  align-items: flex-end;
}

.bank-picker {
  width: 100%;
  background: $bg-card;
  border-radius: 24rpx 24rpx 0 0;
  max-height: 80vh;
  display: flex;
  flex-direction: column;

  .picker-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 24rpx;
    border-bottom: 1rpx solid rgba(0, 0, 0, 0.04);

    .picker-title {
      font-size: 30rpx;
      color: $text-main;
      font-weight: 600;
    }

    .picker-close {
      width: 48rpx;
      height: 48rpx;
      display: flex;
      align-items: center;
      justify-content: center;

      .close-icon {
        font-size: 28rpx;
        color: $text-weak;
      }
    }
  }

  .bank-list {
    max-height: 60vh;
    padding: 8rpx 0;
  }

  .bank-item {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 24rpx;
    border-bottom: 1rpx solid rgba(0, 0, 0, 0.04);

    .bank-name {
      font-size: 28rpx;
      color: $text-main;
    }

    .bank-check {
      font-size: 32rpx;
      color: $color-primary;
    }

    &.bank-item-active {
      background: rgba($color-primary, 0.04);
    }
  }
}
</style>
