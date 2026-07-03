<template>
  <view class="page-address-form">
    <view class="navbar">
      <view class="navbar-left" @click="goBack">
        <text class="back-icon">‹</text>
      </view>
      <view class="navbar-title">{{ isEdit ? '编辑地址' : '新增地址' }}</view>
      <view class="navbar-right" @click="handleSave">
        <text class="save-text" :class="{ disabled: saving }">保存</text>
      </view>
    </view>

    <scroll-view class="content" scroll-y>
      <view v-if="loading && isEdit" class="loading-state">
        <text class="loading-text">加载中...</text>
      </view>

      <template v-else>
        <view class="form-card">
          <view class="form-item">
            <view class="form-label">
              <text class="label-text">收货人</text>
              <text class="required">*</text>
            </view>
            <input
              class="form-input"
              v-model="form.receiverName"
              placeholder="请输入收货人姓名"
              placeholder-class="input-placeholder"
              maxlength="20"
            />
          </view>

          <view class="form-item">
            <view class="form-label">
              <text class="label-text">手机号</text>
              <text class="required">*</text>
            </view>
            <input
              class="form-input"
              v-model="form.receiverPhone"
              type="text"
              inputmode="numeric"
              placeholder="请输入11位手机号"
              placeholder-class="input-placeholder"
              maxlength="11"
            />
          </view>

          <view class="form-item">
            <view class="form-label">
              <text class="label-text">省份</text>
              <text class="required">*</text>
            </view>
            <input
              class="form-input"
              v-model="form.province"
              placeholder="请输入省份（如：广东省）"
              placeholder-class="input-placeholder"
              maxlength="20"
            />
          </view>

          <view class="form-item">
            <view class="form-label">
              <text class="label-text">城市</text>
              <text class="required">*</text>
            </view>
            <input
              class="form-input"
              v-model="form.city"
              placeholder="请输入城市（如：深圳市）"
              placeholder-class="input-placeholder"
              maxlength="20"
            />
          </view>

          <view class="form-item">
            <view class="form-label">
              <text class="label-text">区县</text>
              <text class="required">*</text>
            </view>
            <input
              class="form-input"
              v-model="form.district"
              placeholder="请输入区县（如：南山区）"
              placeholder-class="input-placeholder"
              maxlength="20"
            />
          </view>

          <view class="form-item textarea-item">
            <view class="form-label">
              <text class="label-text">详细地址</text>
              <text class="required">*</text>
            </view>
            <textarea
              class="form-textarea"
              v-model="form.detailAddress"
              placeholder="请输入街道、楼牌号等详细地址"
              placeholder-class="input-placeholder"
              maxlength="200"
              :auto-height="true"
            />
          </view>
        </view>

        <view class="default-card">
          <view class="default-left">
            <text class="default-title">设为默认地址</text>
            <text class="default-desc">下单时优先使用该地址</text>
          </view>
          <switch
            :checked="form.isDefault"
            color="#FF6A00"
            @change="handleDefaultChange"
          />
        </view>

        <view v-if="isEdit" class="delete-card">
          <view class="delete-btn" @click="handleDelete">
            <text>删除地址</text>
          </view>
        </view>

        <view class="tip-box">
          <text class="tip-icon">💡</text>
          <view class="tip-content">
            <text class="tip-title">温馨提示</text>
            <text class="tip-desc">请确保填写的收货信息准确无误，以便顺利收到商品。设为默认地址后，下单时将自动选中该地址。</text>
          </view>
        </view>
      </template>
    </scroll-view>
  </view>
</template>

<script setup>
import { ref, reactive, computed } from 'vue'
import { onLoad } from '@dcloudio/uni-app'
import { useAddress } from '@/hooks/useAddress'
import { useAddressStore } from '@/store/address'

const addressHook = useAddress()
const addressStore = useAddressStore()
const addressId = ref('')
const loading = ref(false)
const saving = ref(false)

const form = reactive({
  receiverName: '',
  receiverPhone: '',
  province: '',
  city: '',
  district: '',
  detailAddress: '',
  isDefault: false
})

const isEdit = computed(() => !!addressId.value)

onLoad((options) => {
  if (options.addressId) {
    addressId.value = options.addressId
    fillAddressFromStore()
  }
})

const fillAddressFromStore = async () => {
  loading.value = true
  let list = addressStore.addressList
  if (list.length === 0) {
    await addressHook.loadAddressList()
    list = addressStore.addressList
  }
  const data = list.find(a => String(a.addressId) === String(addressId.value))
  if (data) {
    form.receiverName = data.receiverName || ''
    form.receiverPhone = data.receiverPhone || ''
    form.province = data.province || ''
    form.city = data.city || ''
    form.district = data.district || ''
    form.detailAddress = data.detailAddress || ''
    form.isDefault = data.isDefault || false
  } else {
    uni.showToast({ title: '获取地址信息失败', icon: 'none' })
    setTimeout(() => uni.navigateBack(), 1500)
  }
  loading.value = false
}

const goBack = () => {
  uni.navigateBack()
}

const handleDefaultChange = (e) => {
  form.isDefault = e.detail.value
}

const validateForm = () => {
  if (!form.receiverName.trim()) {
    uni.showToast({ title: '请输入收货人姓名', icon: 'none' })
    return false
  }

  const phoneStr = String(form.receiverPhone).trim()
  const reg = /^1[3-9]\d{9}$/
  if (!reg.test(phoneStr)) {
    uni.showToast({ title: '请输入正确的11位手机号', icon: 'none' })
    return false
  }

  if (!form.province.trim()) {
    uni.showToast({ title: '请输入省份', icon: 'none' })
    return false
  }

  if (!form.city.trim()) {
    uni.showToast({ title: '请输入城市', icon: 'none' })
    return false
  }

  if (!form.district.trim()) {
    uni.showToast({ title: '请输入区县', icon: 'none' })
    return false
  }

  if (!form.detailAddress.trim()) {
    uni.showToast({ title: '请输入详细地址', icon: 'none' })
    return false
  }

  return true
}

const handleSave = async () => {
  if (saving.value) return
  if (!validateForm()) return

  saving.value = true

  const params = {
    receiverName: form.receiverName.trim(),
    receiverPhone: String(form.receiverPhone).trim(),
    province: form.province.trim(),
    city: form.city.trim(),
    district: form.district.trim(),
    detailAddress: form.detailAddress.trim(),
    isDefault: form.isDefault
  }

  let result = null
  if (isEdit.value) {
    result = await addressHook.loadEditAddress(addressId.value, params)
  } else {
    result = await addressHook.loadAddAddress(params)
  }

  saving.value = false

  if (result) {
    setTimeout(() => {
      uni.navigateBack()
    }, 1500)
  }
}

const handleDelete = () => {
  uni.showModal({
    title: '删除地址',
    content: '确定删除该收货地址？删除后无法恢复',
    confirmText: '删除',
    confirmColor: '#FF4D4F',
    success: async (res) => {
      if (res.confirm) {
        const success = await addressHook.loadDeleteAddress(addressId.value)
        if (success) {
          setTimeout(() => {
            uni.navigateBack()
          }, 1500)
        }
      }
    }
  })
}
</script>

<style lang="scss" scoped>
.page-address-form {
  min-height: 100vh;
  background-color: #F5F5F5;
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
  box-shadow: 0 2rpx 8rpx rgba(0, 0, 0, 0.04);
}

.navbar-left {
  width: 80rpx;
  display: flex;
  align-items: center;
}

.back-icon {
  font-size: 52rpx;
  color: #333333;
  line-height: 1;
}

.navbar-title {
  font-size: 34rpx;
  font-weight: 600;
  color: #333333;
}

.navbar-right {
  width: 80rpx;
  text-align: right;
}

.save-text {
  font-size: 30rpx;
  color: #FF6A00;
  font-weight: 600;

  &.disabled {
    color: #CCCCCC;
  }
}

.content {
  flex: 1;
  padding: 24rpx;
  padding-bottom: calc(48rpx + env(safe-area-inset-bottom));
  height: 0;
}

.loading-state {
  display: flex;
  align-items: center;
  justify-content: center;
  padding-top: 300rpx;

  .loading-text {
    font-size: 28rpx;
    color: #999999;
  }
}

.form-card {
  background-color: #FFFFFF;
  border-radius: 24rpx;
  padding: 8rpx 32rpx;
  margin-bottom: 24rpx;
  box-shadow: 0 4rpx 20rpx rgba(0, 0, 0, 0.04);
}

.form-item {
  display: flex;
  flex-direction: column;
  padding: 28rpx 0;

  &:not(:last-child) {
    border-bottom: 1rpx solid #F5F5F5;
  }
}

.textarea-item {
  &:not(:last-child) {
    border-bottom: none;
  }
}

.form-label {
  display: flex;
  align-items: center;
  margin-bottom: 16rpx;

  .label-text {
    font-size: 28rpx;
    color: #333333;
    font-weight: 500;
  }

  .required {
    font-size: 28rpx;
    color: #FF4D4F;
    margin-left: 4rpx;
  }
}

.form-input {
  font-size: 30rpx;
  color: #333333;
  line-height: 1.5;
  padding: 0;
}

.input-placeholder {
  color: #CCCCCC;
  font-size: 30rpx;
}

.form-textarea {
  font-size: 30rpx;
  color: #333333;
  line-height: 1.6;
  min-height: 120rpx;
  padding: 0;
  width: 100%;
}

.default-card {
  background-color: #FFFFFF;
  border-radius: 24rpx;
  padding: 32rpx;
  margin-bottom: 24rpx;
  display: flex;
  align-items: center;
  justify-content: space-between;
  box-shadow: 0 4rpx 20rpx rgba(0, 0, 0, 0.04);

  .default-left {
    flex: 1;

    .default-title {
      font-size: 30rpx;
      color: #333333;
      font-weight: 500;
      display: block;
      margin-bottom: 8rpx;
    }

    .default-desc {
      font-size: 24rpx;
      color: #999999;
    }
  }
}

.delete-card {
  margin-bottom: 24rpx;

  .delete-btn {
    background-color: #FFFFFF;
    border-radius: 24rpx;
    padding: 32rpx;
    text-align: center;
    box-shadow: 0 4rpx 20rpx rgba(0, 0, 0, 0.04);

    &:active {
      background-color: #FFF5F5;
    }

    text {
      font-size: 30rpx;
      color: #FF4D4F;
      font-weight: 500;
    }
  }
}

.tip-box {
  display: flex;
  align-items: flex-start;
  background-color: rgba(255, 106, 0, 0.05);
  border-radius: 16rpx;
  padding: 24rpx;

  .tip-icon {
    font-size: 32rpx;
    margin-right: 16rpx;
    flex-shrink: 0;
  }

  .tip-content {
    flex: 1;

    .tip-title {
      font-size: 26rpx;
      color: #FF6A00;
      font-weight: 500;
      display: block;
      margin-bottom: 8rpx;
    }

    .tip-desc {
      font-size: 24rpx;
      color: #999999;
      line-height: 1.6;
    }
  }
}
</style>
