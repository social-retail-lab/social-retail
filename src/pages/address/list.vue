<template>
  <view class="page-address-list">
    <view class="navbar">
      <view class="navbar-left" @click="goBack">
        <text class="back-icon">‹</text>
      </view>
      <view class="navbar-title">收货地址</view>
      <view class="navbar-right" @click="toggleManage">
        <text class="manage-text" :class="{ active: isManage }">{{ isManage ? '退出' : '管理' }}</text>
      </view>
    </view>

    <view class="content" v-if="addressHook.loading">
      <view class="loading">
        <text class="loading-text">加载中...</text>
      </view>
    </view>

    <view class="content" v-else-if="addressList.length === 0">
      <view class="empty">
        <text class="empty-icon">📍</text>
        <text class="empty-title">暂无收货地址</text>
        <text class="empty-desc">点击下方按钮添加您的第一个收货地址</text>
      </view>
    </view>

    <scroll-view class="content" v-else scroll-y>
      <SwipeAction auto-close>
        <SwipeActionItem 
          v-for="item in addressList" 
          :key="item.addressId"
          :name="item.addressId"
          :options="getSwipeOptions(item)"
          @click="handleSwipeClick"
          :disabled="isManage"
        >
          <view class="address-card" @click="handleEdit(item)">
            <view class="card-main">
              <view 
                class="checkbox" 
                :class="{ checked: selectedIds.includes(item.addressId) }"
                v-if="isManage"
                @click.stop="toggleSelect(item.addressId)"
              >
                <text class="check-icon" v-if="selectedIds.includes(item.addressId)">✓</text>
              </view>
              
              <view class="address-info">
                <view class="info-header">
                  <text class="receiver-name">{{ item.receiverName }}</text>
                  <text class="receiver-phone">{{ formatPhone(item.receiverPhone) }}</text>
                  <view class="default-tag" v-if="item.isDefault">
                    <text class="tag-text">默认</text>
                  </view>
                </view>
                <text class="full-address">
                  {{ item.province }}{{ item.city }}{{ item.district }}{{ item.detailAddress }}
                </text>
              </view>
            </view>
            
            <view class="card-action">
              <text class="edit-icon">✎</text>
            </view>
          </view>
        </SwipeActionItem>
      </SwipeAction>
    </scroll-view>

    <view class="footer">
      <view class="batch-footer" v-if="isManage">
        <view class="batch-left">
          <text class="batch-info">已选择 {{ selectedIds.length }} 个地址</text>
        </view>
        <view class="batch-right">
          <view 
            class="batch-delete-btn" 
            :class="{ disabled: selectedIds.length === 0 }"
            @click="handleBatchDelete"
          >
            <text class="batch-delete-text">批量删除</text>
          </view>
        </view>
      </view>
      <view class="add-footer" v-else>
        <view class="add-btn" @click="handleAdd">
          <text class="add-icon">+</text>
          <text class="add-text">添加新地址</text>
        </view>
      </view>
    </view>
  </view>
</template>

<script setup>
import { ref, computed, onMounted } from "vue"
import { onShow } from "@dcloudio/uni-app"
import { useAddress } from "@/hooks/useAddress"
import { useAddressStore } from "@/store/address"
import SwipeAction from "uview-plus/components/u-swipe-action/u-swipe-action.vue"
import SwipeActionItem from "uview-plus/components/u-swipe-action-item/u-swipe-action-item.vue"

const addressHook = useAddress()
const addressStore = useAddressStore()
const addressList = computed(() => addressStore.addressList)
const isManage = ref(false)
const selectedIds = ref([])

const goBack = () => {
  uni.navigateBack()
}

const formatPhone = (phone) => {
  if (!phone) return ''
  return phone.replace(/(\d{3})\d{4}(\d{4})/, '$1****$2')
}

const getSwipeOptions = (item) => {
  return [
    {
      text: item.isDefault ? '已是默认' : '设为默认',
      style: {
        backgroundColor: '#1890FF',
        color: '#FFFFFF'
      },
      type: 'default'
    },
    {
      text: '删除',
      style: {
        backgroundColor: '#FF4D4F',
        color: '#FFFFFF'
      },
      type: 'delete'
    }
  ]
}

const loadAddressList = async () => {
  try {
    await addressHook.loadAddressList()
  } catch (error) {
    console.error('加载地址列表失败:', error)
  }
}

onMounted(() => {
  loadAddressList()
})

onShow(() => {
  loadAddressList()
  isManage.value = false
  selectedIds.value = []
})

const toggleManage = () => {
  isManage.value = !isManage.value
  if (!isManage.value) {
    selectedIds.value = []
  }
}

const toggleSelect = (addressId) => {
  const index = selectedIds.value.indexOf(addressId)
  if (index > -1) {
    selectedIds.value.splice(index, 1)
  } else {
    selectedIds.value.push(addressId)
  }
}

const handleAdd = () => {
  uni.navigateTo({ url: '/pages/address/form' })
}

const handleEdit = (item) => {
  uni.navigateTo({ 
    url: `/pages/address/form?addressId=${item.addressId}` 
  })
}

const handleSwipeClick = (options) => {
  const { name, type } = options
  const item = addressList.value.find(a => a.addressId === name)
  if (!item) return
  
  if (type === 'delete') {
    handleDelete(item)
  } else if (type === 'default') {
    handleSetDefault(item)
  }
}

const handleDelete = (item) => {
  addressHook.loadDeleteAddress(item.addressId).then(success => {
    if (success) {
      loadAddressList()
    }
  })
}

const handleSetDefault = (item) => {
  if (item.isDefault) {
    return uni.showToast({ title: '已是默认地址', icon: 'none' })
  }
  addressHook.loadSetDefaultAddress(item.addressId).then(success => {
    if (success) {
      loadAddressList()
    }
  })
}

const handleBatchDelete = () => {
  if (selectedIds.value.length === 0) {
    return uni.showToast({ title: '请选择要删除的地址', icon: 'none' })
  }
  
  uni.showModal({
    title: '批量删除',
    content: `确定要删除选中的 ${selectedIds.value.length} 个地址吗？`,
    success: (res) => {
      if (res.confirm) {
        uni.showLoading({ title: '删除中...' })
        let successCount = 0
        selectedIds.value.forEach((id, index) => {
          addressHook.loadDeleteAddress(id).then(() => {
            successCount++
            if (index === selectedIds.value.length - 1) {
              uni.hideLoading()
              loadAddressList()
              isManage.value = false
              selectedIds.value = []
            }
          })
        })
      }
    }
  })
}
</script>

<style lang="scss" scoped>
.page-address-list {
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

.manage-text {
  font-size: 30rpx;
  color: #666666;
}

.manage-text.active {
  color: #FF6A00;
}

.content {
  flex: 1;
  padding: 24rpx;
}

.loading {
  height: 400rpx;
  display: flex;
  align-items: center;
  justify-content: center;
}

.loading-text {
  font-size: 28rpx;
  color: #999999;
}

.empty {
  height: 600rpx;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
}

.empty-icon {
  font-size: 120rpx;
  margin-bottom: 32rpx;
}

.empty-title {
  font-size: 32rpx;
  color: #333333;
  font-weight: 500;
  margin-bottom: 16rpx;
}

.empty-desc {
  font-size: 26rpx;
  color: #999999;
}

.address-card {
  background-color: #FFFFFF;
  border-radius: 20rpx;
  padding: 28rpx 32rpx;
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 20rpx;
  box-shadow: 0 4rpx 20rpx rgba(0, 0, 0, 0.05);
}

.card-main {
  display: flex;
  align-items: center;
  flex: 1;
  overflow: hidden;
}

.checkbox {
  width: 48rpx;
  height: 48rpx;
  border: 2rpx solid #DDDDDD;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 24rpx;
  flex-shrink: 0;
  transition: all 0.2s;
}

.checkbox.checked {
  background-color: #FF6A00;
  border-color: #FF6A00;
}

.check-icon {
  font-size: 24rpx;
  color: #FFFFFF;
  font-weight: bold;
}

.address-info {
  flex: 1;
  overflow: hidden;
}

.info-header {
  display: flex;
  align-items: center;
  flex-wrap: wrap;
  margin-bottom: 12rpx;
}

.receiver-name {
  font-size: 32rpx;
  font-weight: 600;
  color: #333333;
  margin-right: 20rpx;
}

.receiver-phone {
  font-size: 26rpx;
  color: #666666;
  margin-right: 16rpx;
}

.default-tag {
  background-color: rgba(255, 106, 0, 0.1);
  padding: 6rpx 16rpx;
  border-radius: 8rpx;
}

.tag-text {
  font-size: 22rpx;
  color: #FF6A00;
}

.full-address {
  font-size: 26rpx;
  color: #999999;
  line-height: 1.5;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.card-action {
  margin-left: 24rpx;
  flex-shrink: 0;
}

.edit-icon {
  font-size: 32rpx;
  color: #CCCCCC;
}

.footer {
  padding: 24rpx 32rpx 48rpx;
}

.batch-footer {
  display: flex;
  align-items: center;
  justify-content: space-between;
  height: 96rpx;
  background-color: #FFFFFF;
  border-radius: 16rpx;
  padding: 0 32rpx;
  box-shadow: 0 4rpx 20rpx rgba(0, 0, 0, 0.05);
}

.batch-info {
  font-size: 28rpx;
  color: #666666;
}

.batch-delete-btn {
  padding: 16rpx 48rpx;
  background-color: #FF4D4F;
  border-radius: 32rpx;
  transition: opacity 0.2s;
}

.batch-delete-btn.disabled {
  opacity: 0.5;
}

.batch-delete-text {
  font-size: 28rpx;
  color: #FFFFFF;
}

.add-footer {
  display: flex;
}

.add-btn {
  flex: 1;
  height: 96rpx;
  background: linear-gradient(135deg, #FF6A00, #FF4D4F);
  border-radius: 48rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 8rpx 30rpx rgba(255, 106, 0, 0.3);
}

.add-icon {
  font-size: 40rpx;
  color: #FFFFFF;
  font-weight: 300;
  margin-right: 12rpx;
}

.add-text {
  font-size: 32rpx;
  color: #FFFFFF;
  font-weight: 600;
}
</style>