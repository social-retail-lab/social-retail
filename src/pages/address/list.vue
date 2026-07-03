<template>
  <view class="page-address-list">
    <view class="navbar">
      <view class="navbar-left" @click="goBack">
        <text class="back-icon">‹</text>
      </view>
      <view class="navbar-title">收货地址</view>
      <view class="navbar-right" @click="toggleManage">
        <text class="manage-text" :class="{ active: isManage }">{{ isManage ? '完成' : '管理' }}</text>
      </view>
    </view>

    <scroll-view
      class="content"
      scroll-y
      :refresher-enabled="true"
      :refresher-triggered="refreshing"
      @refresherrefresh="onRefresh"
    >
      <view v-if="addressHook.loading && sortedAddressList.length === 0" class="loading-state">
        <text class="loading-text">加载中...</text>
      </view>

      <view v-else-if="sortedAddressList.length === 0" class="empty-state">
        <view class="empty-icon-wrap">
          <text class="empty-icon">📍</text>
        </view>
        <text class="empty-title">暂无收货地址</text>
        <text class="empty-desc">添加地址后即可享受便捷购物体验</text>
      </view>

      <view v-else class="address-list">
        <view v-if="isSelectMode" class="select-tip">
          <text class="select-tip-text">选择收货地址</text>
        </view>
        <view
          v-for="item in sortedAddressList"
          :key="item.addressId"
          class="address-card"
          :class="{ 'is-default': item.isDefault, 'is-selected': isSelectMode && selectedAddressId === item.addressId }"
          @click="handleCardClick(item)"
        >
          <view class="card-left" v-if="isManage || isSelectMode">
            <view
              v-if="isSelectMode"
              class="radio"
              :class="{ checked: selectedAddressId === item.addressId }"
            >
              <view v-if="selectedAddressId === item.addressId" class="radio-dot"></view>
            </view>
            <view
              v-else
              class="checkbox"
              :class="{ checked: selectedIds.includes(item.addressId) }"
              @click.stop="toggleSelect(item.addressId)"
            >
              <text v-if="selectedIds.includes(item.addressId)" class="check-icon">✓</text>
            </view>
          </view>

          <view class="card-body">
            <view class="card-header">
              <text class="receiver-name">{{ item.receiverName }}</text>
              <view v-if="item.isDefault" class="default-tag">
                <text>默认</text>
              </view>
            </view>

            <view class="card-phone">
              <text class="phone-text">{{ item.receiverPhone }}</text>
            </view>

            <view class="card-address">
              <text class="address-text">{{ item.province }}{{ item.city }}{{ item.district }}{{ item.detailAddress }}</text>
            </view>

            <view v-if="!isManage && !isSelectMode" class="card-actions">
              <view
                v-if="!item.isDefault"
                class="action-btn set-default-btn"
                @click.stop="handleSetDefault(item)"
              >
                <text>设为默认</text>
              </view>
              <view
                class="action-btn edit-btn"
                @click.stop="handleEdit(item)"
              >
                <text>编辑</text>
              </view>
              <view
                class="action-btn delete-btn"
                @click.stop="handleDelete(item)"
              >
                <text>删除</text>
              </view>
            </view>
          </view>
        </view>

        <view class="list-bottom-tip" v-if="sortedAddressList.length > 0">
          <text>最多可保存20个收货地址</text>
        </view>
      </view>
    </scroll-view>

    <view class="footer-bar">
      <template v-if="isSelectMode">
        <view
          class="confirm-select-btn"
          :class="{ disabled: !selectedAddressId }"
          @click="confirmSelectAddress"
        >
          <text>确认选择</text>
        </view>
      </template>
      <template v-else-if="isManage">
        <view class="manage-footer">
          <view class="select-all" @click="toggleSelectAll">
            <view class="checkbox" :class="{ checked: isAllSelected }">
              <text v-if="isAllSelected" class="check-icon">✓</text>
            </view>
            <text class="select-all-text">全选</text>
          </view>
          <view class="manage-info">
            <text class="selected-count">已选 {{ selectedIds.length }} 个</text>
          </view>
          <view
            class="batch-delete"
            :class="{ disabled: selectedIds.length === 0 }"
            @click="handleBatchDelete"
          >
            <text>删除</text>
          </view>
        </view>
      </template>
      <template v-else>
        <view class="add-btn" @click="handleAdd">
          <text class="add-icon">+</text>
          <text class="add-text">添加新地址</text>
        </view>
      </template>
    </view>
  </view>
</template>

<script setup>
import { ref, computed } from 'vue'
import { onShow, onLoad } from '@dcloudio/uni-app'
import { useAddress } from '@/hooks/useAddress'
import { useAddressStore } from '@/store/address'

const addressHook = useAddress()
const addressStore = useAddressStore()
const isManage = ref(false)
const selectedIds = ref([])
const refreshing = ref(false)
const isSelectMode = ref(false)
const selectedAddressId = ref(null)

const sortedAddressList = computed(() => {
  const list = [...addressStore.addressList]
  return list.sort((a, b) => {
    if (a.isDefault && !b.isDefault) return -1
    if (!a.isDefault && b.isDefault) return 1
    return 0
  })
})

const isAllSelected = computed(() => {
  return sortedAddressList.value.length > 0 &&
    sortedAddressList.value.every(item => selectedIds.value.includes(item.addressId))
})

onLoad((options) => {
  if (options.select === '1') {
    isSelectMode.value = true
    selectedAddressId.value = options.addressId ? Number(options.addressId) : null
  }
})

const goBack = () => {
  uni.navigateBack()
}

const loadList = async () => {
  await addressHook.loadAddressList()
}

const onRefresh = async () => {
  refreshing.value = true
  await loadList()
  refreshing.value = false
}

onShow(() => {
  loadList()
  if (!isSelectMode.value) {
    isManage.value = false
    selectedIds.value = []
  }
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

const toggleSelectAll = () => {
  if (isAllSelected.value) {
    selectedIds.value = []
  } else {
    selectedIds.value = sortedAddressList.value.map(item => item.addressId)
  }
}

const handleCardClick = (item) => {
  if (isSelectMode.value) {
    selectedAddressId.value = item.addressId
  } else if (isManage.value) {
    toggleSelect(item.addressId)
  } else {
    handleEdit(item)
  }
}

const confirmSelectAddress = () => {
  if (!selectedAddressId.value) {
    uni.showToast({ title: '请选择收货地址', icon: 'none' })
    return
  }
  const item = sortedAddressList.value.find(a => a.addressId === selectedAddressId.value)
  if (!item) return
  const addressData = {
    addressId: item.addressId,
    receiverName: item.receiverName,
    receiverPhone: item.receiverPhone,
    province: item.province,
    city: item.city,
    district: item.district,
    detailAddress: item.detailAddress,
    isDefault: item.isDefault,
    fullAddress: `${item.province}${item.city}${item.district}${item.detailAddress}`
  }
  const pages = getCurrentPages()
  const prevPage = pages[pages.length - 2]
  if (prevPage && prevPage.$vm) {
    const prevVm = prevPage.$vm
    if (prevVm.onSelectAddress) {
      prevVm.onSelectAddress(addressData)
    }
  }
  uni.navigateBack()
}

const handleAdd = () => {
  uni.navigateTo({ url: '/pages/address/form' })
}

const handleEdit = (item) => {
  uni.navigateTo({
    url: `/pages/address/form?addressId=${item.addressId}`
  })
}

const handleDelete = (item) => {
  if (sortedAddressList.value.length <= 1) {
    uni.showToast({ title: '至少保留一条收货地址', icon: 'none' })
    return
  }

  uni.showModal({
    title: '删除地址',
    content: '确定删除该收货地址？删除后无法恢复',
    confirmText: '删除',
    confirmColor: '#FF4D4F',
    success: async (res) => {
      if (res.confirm) {
        const success = await addressHook.loadDeleteAddress(item.addressId)
        if (success) {
          await loadList()
        }
      }
    }
  })
}

const handleSetDefault = (item) => {
  if (item.isDefault) {
    uni.showToast({ title: '已是默认地址', icon: 'none' })
    return
  }
  addressHook.loadSetDefaultAddress(item.addressId).then(success => {
    if (success) {
      loadList()
    }
  })
}

const handleBatchDelete = () => {
  if (selectedIds.value.length === 0) {
    uni.showToast({ title: '请选择要删除的地址', icon: 'none' })
    return
  }

  const remaining = sortedAddressList.value.length - selectedIds.value.length
  if (remaining < 1) {
    uni.showToast({ title: '至少保留一条收货地址', icon: 'none' })
    return
  }

  uni.showModal({
    title: '批量删除',
    content: `确定要删除选中的 ${selectedIds.value.length} 个地址吗？`,
    confirmText: '删除',
    confirmColor: '#FF4D4F',
    success: async (res) => {
      if (res.confirm) {
        for (const id of selectedIds.value) {
          await addressHook.loadDeleteAddress(id)
        }
        isManage.value = false
        selectedIds.value = []
        await loadList()
      }
    }
  })
}
</script>

<style lang="scss" scoped>
.page-address-list {
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

.manage-text {
  font-size: 30rpx;
  color: #666666;

  &.active {
    color: #FF6A00;
  }
}

.content {
  flex: 1;
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

.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding-top: 260rpx;

  .empty-icon-wrap {
    width: 180rpx;
    height: 180rpx;
    border-radius: 50%;
    background: #FFFFFF;
    display: flex;
    align-items: center;
    justify-content: center;
    margin-bottom: 40rpx;
    box-shadow: 0 8rpx 32rpx rgba(0, 0, 0, 0.06);
  }

  .empty-icon {
    font-size: 80rpx;
  }

  .empty-title {
    font-size: 34rpx;
    color: #333333;
    font-weight: 600;
    margin-bottom: 16rpx;
  }

  .empty-desc {
    font-size: 26rpx;
    color: #999999;
  }
}

.address-list {
  padding: 24rpx 24rpx 140rpx;
}

.select-tip {
  background: rgba(255, 106, 0, 0.06);
  border-radius: 16rpx;
  padding: 20rpx 24rpx;
  margin-bottom: 20rpx;

  .select-tip-text {
    font-size: 26rpx;
    color: #FF6A00;
  }
}

.address-card {
  background-color: #FFFFFF;
  border-radius: 24rpx;
  margin-bottom: 20rpx;
  padding: 32rpx;
  display: flex;
  box-shadow: 0 4rpx 20rpx rgba(0, 0, 0, 0.04);
  transition: all 0.2s ease;

  &:active {
    transform: scale(0.98);
  }

  &.is-default {
    border: 2rpx solid rgba(255, 106, 0, 0.3);
  }

  &.is-selected {
    border: 2rpx solid #FF6A00;
    background-color: rgba(255, 106, 0, 0.02);
  }
}

.card-left {
  margin-right: 24rpx;
  display: flex;
  align-items: flex-start;
  padding-top: 4rpx;
}

.checkbox {
  width: 44rpx;
  height: 44rpx;
  border: 2rpx solid #DDDDDD;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.2s;

  &.checked {
    background-color: #FF6A00;
    border-color: #FF6A00;
  }

  .check-icon {
    font-size: 24rpx;
    color: #FFFFFF;
    font-weight: bold;
  }
}

.radio {
  width: 44rpx;
  height: 44rpx;
  border: 2rpx solid #DDDDDD;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.2s;

  &.checked {
    border-color: #FF6A00;
  }

  .radio-dot {
    width: 24rpx;
    height: 24rpx;
    border-radius: 50%;
    background-color: #FF6A00;
  }
}

.card-body {
  flex: 1;
  overflow: hidden;
}

.card-header {
  display: flex;
  align-items: center;
  margin-bottom: 12rpx;

  .receiver-name {
    font-size: 34rpx;
    font-weight: 600;
    color: #333333;
    margin-right: 16rpx;
  }

  .default-tag {
    background: linear-gradient(135deg, #FF6A00, #FF4D4F);
    padding: 4rpx 16rpx;
    border-radius: 8rpx;

    text {
      font-size: 20rpx;
      color: #FFFFFF;
      font-weight: 500;
    }
  }
}

.card-phone {
  margin-bottom: 12rpx;

  .phone-text {
    font-size: 28rpx;
    color: #666666;
  }
}

.card-address {
  .address-text {
    font-size: 28rpx;
    color: #333333;
    line-height: 1.6;
    word-break: break-all;
  }
}

.card-actions {
  display: flex;
  justify-content: flex-end;
  gap: 16rpx;
  margin-top: 24rpx;
  padding-top: 20rpx;
  border-top: 1rpx solid #F5F5F5;

  .action-btn {
    padding: 12rpx 32rpx;
    border-radius: 28rpx;
    transition: all 0.2s;

    &:active {
      transform: scale(0.94);
    }

    text {
      font-size: 26rpx;
    }

    &.set-default-btn {
      background-color: rgba(24, 144, 255, 0.08);

      text {
        color: #1890FF;
      }
    }

    &.edit-btn {
      background-color: rgba(255, 106, 0, 0.08);

      text {
        color: #FF6A00;
      }
    }

    &.delete-btn {
      background-color: rgba(255, 77, 79, 0.08);

      text {
        color: #FF4D4F;
      }
    }
  }
}

.list-bottom-tip {
  text-align: center;
  padding: 24rpx 0;

  text {
    font-size: 24rpx;
    color: #CCCCCC;
  }
}

.footer-bar {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  padding: 20rpx 32rpx;
  padding-bottom: calc(20rpx + env(safe-area-inset-bottom));
  background: #FFFFFF;
  box-shadow: 0 -4rpx 20rpx rgba(0, 0, 0, 0.06);
  z-index: 100;
}

.manage-footer {
  display: flex;
  align-items: center;
  justify-content: space-between;
  height: 88rpx;

  .select-all {
    display: flex;
    align-items: center;

    .select-all-text {
      font-size: 28rpx;
      color: #333333;
      margin-left: 12rpx;
    }
  }

  .manage-info {
    flex: 1;
    text-align: center;

    .selected-count {
      font-size: 26rpx;
      color: #999999;
    }
  }

  .batch-delete {
    padding: 16rpx 48rpx;
    background-color: #FF4D4F;
    border-radius: 32rpx;
    transition: opacity 0.2s;

    &.disabled {
      opacity: 0.4;
    }

    text {
      font-size: 28rpx;
      color: #FFFFFF;
      font-weight: 500;
    }
  }
}

.confirm-select-btn {
  height: 96rpx;
  background: linear-gradient(135deg, #FF6A00, #FF4D4F);
  border-radius: 48rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 8rpx 30rpx rgba(255, 106, 0, 0.3);
  transition: all 0.2s;

  &:active {
    transform: scale(0.97);
  }

  &.disabled {
    background: #CCCCCC;
    box-shadow: none;
  }

  text {
    font-size: 32rpx;
    font-weight: 600;
    color: #FFFFFF;
  }
}

.add-btn {
  height: 96rpx;
  background: linear-gradient(135deg, #FF6A00, #FF4D4F);
  border-radius: 48rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 8rpx 30rpx rgba(255, 106, 0, 0.3);
  transition: all 0.2s;

  &:active {
    transform: scale(0.97);
    box-shadow: 0 4rpx 16rpx rgba(255, 106, 0, 0.3);
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
}
</style>
