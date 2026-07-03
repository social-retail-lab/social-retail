import { ref } from 'vue'
import { useAddressStore } from '@/store/address'
import { showToast } from '@/utils/common'

export const useAddress = () => {
  const addressStore = useAddressStore()
  const loading = ref(false)
  let pendingRequest = null

  const loadAddressList = async () => {
    if (loading.value) return []
    loading.value = true
    pendingRequest = addressStore.fetchAddressList()
    try {
      const res = await pendingRequest
      return res
    } catch (error) {
      if (error.aborted) {
        console.warn('地址列表请求被中止:', error)
        return []
      }
      console.error('获取地址列表失败:', error)
      showToast('获取地址列表失败')
      return []
    } finally {
      loading.value = false
      pendingRequest = null
    }
  }

  const loadDefaultAddress = async () => {
    try {
      const res = await addressStore.fetchDefaultAddress()
      return res
    } catch (error) {
      console.error('获取默认地址失败:', error)
      return null
    }
  }

  const loadAddAddress = async (data) => {
    loading.value = true
    try {
      const res = await addressStore.fetchAddAddress(data)
      if (res) {
        showToast('添加成功')
        return res
      } else {
        showToast('添加失败')
        return null
      }
    } catch (error) {
      console.error('添加地址失败:', error)
      showToast('添加失败')
      return null
    } finally {
      loading.value = false
    }
  }

  const loadEditAddress = async (addressId, data) => {
    loading.value = true
    try {
      const res = await addressStore.fetchEditAddress(addressId, data)
      if (res) {
        showToast('修改成功')
        return res
      } else {
        showToast('修改失败')
        return null
      }
    } catch (error) {
      console.error('修改地址失败:', error)
      showToast('修改失败')
      return null
    } finally {
      loading.value = false
    }
  }

  const loadDeleteAddress = async (addressId) => {
    return new Promise((resolve) => {
      uni.showModal({
        title: '确认删除',
        content: '确定要删除该地址吗？',
        success: async (res) => {
          if (res.confirm) {
            try {
              const success = await addressStore.fetchDeleteAddress(addressId)
              if (success) {
                showToast('删除成功')
                resolve(true)
              } else {
                showToast('删除失败')
                resolve(false)
              }
            } catch (error) {
              console.error('删除地址失败:', error)
              showToast('删除失败')
              resolve(false)
            }
          } else {
            resolve(false)
          }
        }
      })
    })
  }

  const loadSetDefaultAddress = async (addressId) => {
    try {
      const success = await addressStore.fetchSetDefaultAddress(addressId)
      if (success) {
        showToast('设置成功')
        return true
      } else {
        showToast('设置失败')
        return false
      }
    } catch (error) {
      console.error('设置默认地址失败:', error)
      showToast('设置失败')
      return false
    }
  }

  return {
    loading,
    loadAddressList,
    loadDefaultAddress,
    loadAddAddress,
    loadEditAddress,
    loadDeleteAddress,
    loadSetDefaultAddress
  }
}