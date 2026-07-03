import { defineStore } from 'pinia'
import { ref } from 'vue'
import { 
  getAddressListApi, 
  getDefaultAddressApi, 
  addAddressApi, 
  editAddressApi, 
  deleteAddressApi, 
  setDefaultAddressApi,
  normalizeAddressData,
  normalizeAddressList
} from '@/api/address'

export const useAddressStore = defineStore('address', () => {
  const addressList = ref([])
  const defaultAddress = ref(null)

  const fetchAddressList = async () => {
    const res = await getAddressListApi()
    if (res.code === 0) {
      addressList.value = normalizeAddressList(res.data)
      return addressList.value
    }
    return []
  }

  const fetchDefaultAddress = async () => {
    const res = await getDefaultAddressApi()
    if (res.code === 0 && res.data) {
      defaultAddress.value = normalizeAddressData(res.data)
      return defaultAddress.value
    }
    return null
  }

  const fetchAddAddress = async (data) => {
    const res = await addAddressApi(data)
    if (res.code === 0 && res.data) {
      return normalizeAddressData(res.data)
    }
    return null
  }

  const fetchEditAddress = async (addressId, data) => {
    const res = await editAddressApi(addressId, data)
    if (res.code === 0 && res.data) {
      return normalizeAddressData(res.data)
    }
    return null
  }

  const fetchDeleteAddress = async (addressId) => {
    const res = await deleteAddressApi(addressId)
    if (res.code === 0) {
      return true
    }
    return false
  }

  const fetchSetDefaultAddress = async (addressId) => {
    const res = await setDefaultAddressApi(addressId)
    if (res.code === 0) {
      return true
    }
    return false
  }

  return {
    addressList,
    defaultAddress,
    fetchAddressList,
    fetchDefaultAddress,
    fetchAddAddress,
    fetchEditAddress,
    fetchDeleteAddress,
    fetchSetDefaultAddress
  }
})