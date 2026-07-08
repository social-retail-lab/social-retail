import { ref } from 'vue'
import { useAddressStore } from '@/store/address'
import { showToast, showLoading, hideLoading } from '@/utils/common'

export const useAddress = () => {
  const addressStore = useAddressStore()
  const loading = ref(false)

  const loadAddressList = async () => {
    if (loading.value) return []
    loading.value = true
    try {
      const res = await addressStore.fetchAddressList()
      return res
    } catch (error) {
      console.error('获取地址列表失败:', error)
      showToast('获取地址列表失败')
      return []
    } finally {
      loading.value = false
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

  const loadAddressDetail = async (addressId) => {
    loading.value = true
    try {
      const res = await addressStore.fetchAddressDetail(addressId)
      return res
    } catch (error) {
      console.error('获取地址详情失败:', error)
      showToast('获取地址详情失败')
      return null
    } finally {
      loading.value = false
    }
  }

  const loadAddAddress = async (data) => {
    if (loading.value) return null
    loading.value = true
    showLoading('保存中...')
    try {
      const res = await addressStore.fetchAddAddress(data)
      if (res) {
        showToast('添加成功', 'success')
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
      hideLoading()
      loading.value = false
    }
  }

  const loadEditAddress = async (addressId, data) => {
    if (loading.value) return null
    loading.value = true
    showLoading('保存中...')
    try {
      const res = await addressStore.fetchEditAddress(addressId, data)
      if (res) {
        showToast('修改成功', 'success')
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
      hideLoading()
      loading.value = false
    }
  }

  const loadDeleteAddress = async (addressId) => {
    showLoading('删除中...')
    try {
      const success = await addressStore.fetchDeleteAddress(addressId)
      if (success) {
        showToast('删除成功', 'success')
        return true
      } else {
        showToast('删除失败')
        return false
      }
    } catch (error) {
      console.error('删除地址失败:', error)
      showToast('删除失败')
      return false
    } finally {
      hideLoading()
    }
  }

  const loadSetDefaultAddress = async (addressId) => {
    showLoading('设置中...')
    try {
      const success = await addressStore.fetchSetDefaultAddress(addressId)
      if (success) {
        showToast('设置成功', 'success')
        return true
      } else {
        showToast('设置失败')
        return false
      }
    } catch (error) {
      console.error('设置默认地址失败:', error)
      showToast('设置失败')
      return false
    } finally {
      hideLoading()
    }
  }

  return {
    loading,
    loadAddressList,
    loadDefaultAddress,
    loadAddressDetail,
    loadAddAddress,
    loadEditAddress,
    loadDeleteAddress,
    loadSetDefaultAddress
  }
}
