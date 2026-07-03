<template>
  <view class="page-address-form">
    <view class="navbar">
      <view class="navbar-left" @click="goBack">
        <text class="back-icon">‹</text>
      </view>
      <view class="navbar-title">{{ isEdit ? '编辑地址' : '新增地址' }}</view>
      <view class="navbar-right" @click="handleSave">
        <text class="save-text">保存</text>
      </view>
    </view>

    <scroll-view class="content" scroll-y>
      <view class="form-card">
        <view class="form-item">
          <view class="form-label">收货人</view>
          <input 
            class="form-input" 
            v-model="form.receiverName" 
            placeholder="请输入收货人姓名"
            maxlength="20"
          />
        </view>

        <view class="form-item">
          <view class="form-label">手机号</view>
          <input 
            class="form-input" 
            v-model="form.receiverPhone" 
            type="text"
            placeholder="请输入11位手机号"
            maxlength="11"
          />
        </view>

        <view class="form-item">
          <view class="form-label">省份</view>
          <input 
            class="form-input" 
            v-model="form.province" 
            placeholder="请输入省份"
            maxlength="20"
          />
        </view>

        <view class="form-item">
          <view class="form-label">城市</view>
          <input 
            class="form-input" 
            v-model="form.city" 
            placeholder="请输入城市"
            maxlength="20"
          />
        </view>

        <view class="form-item">
          <view class="form-label">区县</view>
          <input 
            class="form-input" 
            v-model="form.district" 
            placeholder="请输入区县"
            maxlength="20"
          />
        </view>

        <view class="form-item">
          <view class="form-label">详细地址</view>
          <textarea 
            class="form-textarea" 
            v-model="form.detailAddress" 
            placeholder="请输入详细地址"
            maxlength="200"
          />
        </view>

        <view class="form-item">
          <view class="form-label">设为默认地址</view>
          <switch 
            :checked="form.isDefault" 
            color="#FF6A00"
            @change="handleDefaultChange"
          />
        </view>
      </view>

      <view class="tip-box">
        <text class="tip-title">温馨提示</text>
        <text class="tip-desc">请确保填写的收货信息准确无误，以便顺利收到商品。</text>
      </view>
    </scroll-view>
  </view>
</template>

<script setup>
import { ref, reactive, computed, onMounted } from "vue"
import { useAddress } from "@/hooks/useAddress"

const addressHook = useAddress()
const addressId = ref('')

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

onMounted(() => {
  const pages = getCurrentPages()
  const currentPage = pages[pages.length - 1]
  const options = currentPage.options || {}
  
  if (options.addressId) {
    addressId.value = options.addressId
    loadAddressData()
  }
})

const loadAddressData = () => {
  addressHook.loadAddressList().then(data => {
    const addressList = Array.isArray(data) ? data : []
    const address = addressList.find(a => a.addressId === addressId.value)
    if (address) {
      form.receiverName = address.receiverName || ''
      form.receiverPhone = address.receiverPhone || ''
      form.province = address.province || ''
      form.city = address.city || ''
      form.district = address.district || ''
      form.detailAddress = address.detailAddress || ''
      form.isDefault = address.isDefault || false
    }
  })
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

  if (!form.province.trim() || !form.city.trim() || !form.district.trim()) {
    uni.showToast({ title: '请输入省市区', icon: 'none' })
    return false
  }

  if (!form.detailAddress.trim()) {
    uni.showToast({ title: '请输入详细地址', icon: 'none' })
    return false
  }

  return true
}

const handleSave = () => {
  if (!validateForm()) return

  const params = {
    receiverName: form.receiverName.trim(),
    receiverPhone: String(form.receiverPhone).trim(),
    province: form.province,
    city: form.city,
    district: form.district,
    detailAddress: form.detailAddress.trim(),
    isDefault: form.isDefault
  }

  const saveFn = isEdit.value 
    ? () => addressHook.loadEditAddress(addressId.value, params)
    : () => addressHook.loadAddAddress(params)

  saveFn().then(res => {
    if (res) {
      setTimeout(() => {
        uni.navigateBack()
      }, 1500)
    }
  })
}
</script>

<style lang="scss" scoped>
.page-address-form {
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
  text-align: right;
}

.save-text {
  font-size: 30rpx;
  color: #FF6A00;
  font-weight: 500;
}

.content {
  padding: 24rpx;
  padding-bottom: 160rpx;
  height: calc(100vh - 88rpx);
  box-sizing: border-box;
}

.form-card {
  background-color: #FFFFFF;
  border-radius: 20rpx;
  padding: 32rpx;
}

.form-item {
  display: flex;
  flex-direction: column;
  padding: 24rpx 0;
  
  &:not(:last-child) {
    border-bottom: 1rpx solid #F5F5F5;
  }
}

.form-label {
  font-size: 28rpx;
  color: #999999;
  margin-bottom: 16rpx;
}

.form-input {
  font-size: 32rpx;
  color: #333333;
  line-height: 1.5;
}

.form-textarea {
  font-size: 32rpx;
  color: #333333;
  line-height: 1.6;
  min-height: 160rpx;
  padding: 0;
}

.tip-box {
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

.tip-desc {
  font-size: 24rpx;
  color: #999999;
  line-height: 1.6;
}
</style>