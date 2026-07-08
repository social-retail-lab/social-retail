import request from "./base"

export const getAddressListApi = () => {
  return request({
    url: "/api/addresses",
    method: "get"
  })
}

export const getDefaultAddressApi = () => {
  return request({
    url: "/api/addresses/default",
    method: "get"
  })
}

const validateAddressParams = (data) => {
  if (!data.receiverName || !data.receiverName.trim()) {
    throw new Error('请输入收货人姓名')
  }
  if (!data.receiverPhone || !/^1[3-9]\d{9}$/.test(data.receiverPhone)) {
    throw new Error('请输入正确的11位手机号')
  }
  if (!data.province) {
    throw new Error('请选择省份')
  }
  if (!data.city) {
    throw new Error('请选择城市')
  }
  if (!data.district) {
    throw new Error('请选择区县')
  }
  if (!data.detailAddress || !data.detailAddress.trim()) {
    throw new Error('请输入详细地址')
  }
  return {
    receiverName: data.receiverName.trim(),
    receiverPhone: data.receiverPhone.trim(),
    province: data.province,
    city: data.city,
    district: data.district,
    detailAddress: data.detailAddress.trim(),
    isDefault: data.isDefault || false
  }
}

export const addAddressApi = (data) => {
  const validateData = validateAddressParams(data)
  return request({
    url: "/api/addresses",
    method: "post",
    data: validateData
  })
}

export const editAddressApi = (addressId, data) => {
  if (!addressId) {
    throw new Error('地址ID不能为空')
  }
  const validateData = validateAddressParams(data)
  return request({
    url: `/api/addresses/${addressId}`,
    method: "put",
    data: validateData
  })
}

export const getAddressDetailApi = (addressId) => {
  if (!addressId) {
    throw new Error('地址ID不能为空')
  }
  return request({
    url: `/api/addresses/${addressId}`,
    method: "get"
  })
}

export const deleteAddressApi = (addressId) => {
  if (!addressId) {
    throw new Error('地址ID不能为空')
  }
  return request({
    url: `/api/addresses/${addressId}`,
    method: "delete"
  })
}

export const setDefaultAddressApi = (addressId) => {
  if (!addressId) {
    throw new Error('地址ID不能为空')
  }
  return request({
    url: `/api/addresses/${addressId}/default`,
    method: "patch"
  })
}

export const normalizeAddressData = (address) => {
  if (!address) return null
  return {
    addressId: address.addressId || address.id,
    receiverName: address.receiverName || address.consignee || '',
    receiverPhone: address.receiverPhone || address.phone || '',
    province: address.province || '',
    city: address.city || '',
    district: address.district || '',
    detailAddress: address.detailAddress || '',
    isDefault: address.isDefault || false
  }
}

export const normalizeAddressList = (data) => {
  if (!data) return []
  let list = []
  if (Array.isArray(data)) {
    list = data
  } else if (Array.isArray(data.list)) {
    list = data.list
  } else if (Array.isArray(data.data)) {
    list = data.data
  } else {
    console.warn('地址列表数据格式未知:', data)
  }
  return list.map(normalizeAddressData).filter(Boolean)
}