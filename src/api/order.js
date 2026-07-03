// 购物车、订单、售后接口
// 包含：购物车增删改查、订单创建、订单查询、订单状态、售后申请

import request from './base'

// 订单预览
export const orderPreviewApi = (data) => {
  const validateData = validateOrderPreviewParams(data)
  
  return request({
    url: '/api/orders/preview',
    method: 'post',
    data: validateData
  }).then(response => {
    if (response.code === 0) {
      return {
        ...response,
        data: normalizeOrderPreviewData(response.data)
      }
    }
    return response
  }).catch(error => {
    handleOrderPreviewError(error)
    throw error
  })
}

const validateOrderPreviewParams = (data) => {
  const validated = {
    cartItemIds: Array.isArray(data?.cartItemIds) ? data.cartItemIds : [],
    deliveryType: data?.deliveryType || 'DELIVERY',
    addressId: data?.addressId || null,
    pickupPointId: data?.pickupPointId || null,
    couponUserId: data?.couponUserId || null,
    usePoints: !!data?.usePoints,
    activityContext: {
      seckillId: data?.activityContext?.seckillId || null,
      bargainId: data?.activityContext?.bargainId || null
    },
    remark: data?.remark || ''
  }
  
  if (!validated.cartItemIds.length) {
    throw new Error('请选择要购买的商品')
  }
  
  if (validated.deliveryType === 'DELIVERY' && !validated.addressId) {
    throw new Error('配送方式下请选择收货地址')
  }
  
  if (validated.deliveryType === 'PICKUP' && !validated.pickupPointId) {
    throw new Error('自提方式下请选择自提点')
  }
  
  return validated
}

const normalizeOrderPreviewData = (data) => {
  if (!data) return null
  
  return {
    priceDetail: normalizePriceDetail(data.priceDetail),
    promotionDetail: normalizePromotionDetail(data.promotionDetail),
    promotionSnapshot: normalizePromotionSnapshot(data.promotionSnapshot),
    addressInfo: normalizeAddressInfo(data.addressInfo),
    itemList: normalizeItemList(data.itemList),
    couponInfo: normalizeCouponInfo(data.couponInfo),
    activityInfo: normalizeActivityInfo(data.activityInfo)
  }
}

const normalizePriceDetail = (priceDetail) => {
  if (!priceDetail) return {
    totalAmount: 0,
    seckillDiscount: 0,
    bargainDiscount: 0,
    couponDiscount: 0,
    pointsDeduction: 0,
    deliveryFee: 0,
    payAmount: 0
  }
  
  return {
    totalAmount: Number(priceDetail.totalAmount) || 0,
    seckillDiscount: Number(priceDetail.seckillDiscount) || 0,
    bargainDiscount: Number(priceDetail.bargainDiscount) || 0,
    couponDiscount: Number(priceDetail.couponDiscount) || 0,
    pointsDeduction: Number(priceDetail.pointsDeduction) || 0,
    deliveryFee: Number(priceDetail.deliveryFee) || 0,
    payAmount: Number(priceDetail.payAmount) || 0
  }
}

const normalizePromotionDetail = (promotionDetail) => {
  if (!Array.isArray(promotionDetail)) return []
  
  return promotionDetail.map(item => ({
    type: item.type || '',
    title: item.title || '',
    discount: Number(item.discount) || 0
  }))
}

const normalizePromotionSnapshot = (promotionSnapshot) => {
  if (!promotionSnapshot) return {}
  
  return {
    seckillId: promotionSnapshot.seckillId || null,
    bargainId: promotionSnapshot.bargainId || null,
    couponUserId: promotionSnapshot.couponUserId || null,
    seckillDiscount: Number(promotionSnapshot.seckillDiscount) || 0,
    bargainDiscount: Number(promotionSnapshot.bargainDiscount) || 0,
    couponDiscount: Number(promotionSnapshot.couponDiscount) || 0,
    pointsDeduction: Number(promotionSnapshot.pointsDeduction) || 0,
    finalPayAmount: Number(promotionSnapshot.finalPayAmount) || 0
  }
}

const normalizeAddressInfo = (addressInfo) => {
  if (!addressInfo) return null
  
  return {
    addressId: addressInfo.addressId || null,
    receiverName: addressInfo.receiverName || '',
    receiverPhone: addressInfo.receiverPhone || '',
    fullAddress: addressInfo.fullAddress || ''
  }
}

const normalizeItemList = (itemList) => {
  if (!Array.isArray(itemList)) return []
  
  return itemList.map(item => ({
    cartItemId: item.cartItemId || null,
    skuId: item.skuId || null,
    productId: item.productId || null,
    productName: item.productName || '',
    productImage: item.productImage || '',
    skuSpecs: item.skuSpecs || '',
    originPrice: Number(item.originPrice) || 0,
    finalPrice: Number(item.finalPrice) || 0,
    quantity: Number(item.quantity) || 0,
    itemOriginAmount: Number(item.itemOriginAmount) || 0,
    itemFinalAmount: Number(item.itemFinalAmount) || 0,
    promotionType: item.promotionType || ''
  }))
}

const normalizeCouponInfo = (couponInfo) => {
  if (!couponInfo) return null
  
  return {
    couponUserId: couponInfo.couponUserId || null,
    couponTitle: couponInfo.couponTitle || '',
    couponType: couponInfo.couponType || '',
    discountAmount: Number(couponInfo.discountAmount) || 0
  }
}

const normalizeActivityInfo = (activityInfo) => {
  if (!activityInfo) return {}
  
  return {
    seckillActivityId: activityInfo.seckillActivityId || null,
    bargainActivityId: activityInfo.bargainActivityId || null
  }
}

const handleOrderPreviewError = (error) => {
  const errorCodeMap = {
    40911: '秒杀活动已结束',
    40912: '库存不足',
    40913: '优惠券不满足使用条件'
  }
  
  if (errorCodeMap[error?.code]) {
    console.error(`订单预览错误[${error.code}]:`, errorCodeMap[error.code])
  }
}

const generateIdempotentKey = () => {
  return `order-submit-${Date.now()}-${Math.random().toString(36).substring(2, 9)}`
}

export const submitOrderApi = (data) => {
  const validateData = validateSubmitOrderParams(data)
  const idempotentKey = generateIdempotentKey()
  
  return request({
    url: '/api/orders',
    method: 'post',
    data: validateData,
    headers: {
      'X-Idempotent-Key': idempotentKey
    }
  }).then(response => {
    if (response.code === 0) {
      return {
        ...response,
        data: normalizeSubmitOrderData(response.data)
      }
    }
    return response
  }).catch(error => {
    handleSubmitOrderError(error)
    throw error
  })
}

const validateSubmitOrderParams = (data) => {
  const validated = {
    cartItemIds: Array.isArray(data?.cartItemIds) ? data.cartItemIds : [],
    deliveryType: data?.deliveryType || 1,
    addressId: data?.addressId || null,
    pickupPointId: data?.pickupPointId || null,
    couponUserId: data?.couponUserId || null,
    usePoints: !!data?.usePoints,
    activityContext: {
      seckillId: data?.activityContext?.seckillId || null,
      bargainId: data?.activityContext?.bargainId || null,
      groupId: data?.activityContext?.groupId || null,
      promotionIds: Array.isArray(data?.activityContext?.promotionIds) ? data.activityContext.promotionIds : []
    },
    remark: data?.remark || ''
  }
  
  if (!validated.cartItemIds.length) {
    throw new Error('请选择要购买的商品')
  }
  
  if (validated.deliveryType === 1 && !validated.addressId) {
    throw new Error('配送方式下请选择收货地址')
  }
  
  if (validated.deliveryType === 2 && !validated.pickupPointId) {
    throw new Error('自提方式下请选择自提点')
  }
  
  return validated
}

const normalizeSubmitOrderData = (data) => {
  if (!data) return null
  
  return {
    orderId: data.orderId || null,
    orderSn: data.orderSn || '',
    status: data.status || 0,
    statusText: data.statusText || '',
    payAmount: Number(data.payAmount) || 0,
    expireTime: data.expireTime || ''
  }
}

const handleSubmitOrderError = (error) => {
  const errorCodeMap = {
    40911: '秒杀活动已结束',
    40912: '库存不足',
    40913: '优惠券不满足使用条件',
    40914: '订单重复提交',
    40915: '活动已过期'
  }
  
  if (errorCodeMap[error?.code]) {
    console.error(`提交订单错误[${error.code}]:`, errorCodeMap[error.code])
  }
}

// 获取订单列表
export const getOrderListApi = (params) => {
  const validatedParams = validateOrderListParams(params)
  
  return request({
    url: '/api/orders',
    method: 'get',
    params: validatedParams
  }).then(response => {
    if (response.code === 0) {
      return {
        ...response,
        data: normalizeOrderListData(response.data)
      }
    }
    return response
  }).catch(error => {
    handleOrderListError(error)
    throw error
  })
}

const validateOrderListParams = (params) => {
  return {
    status: params?.status || undefined,
    page: Number(params?.page) || 1,
    pageSize: Number(params?.pageSize) || 10
  }
}

const normalizeOrderListData = (data) => {
  if (!data) return { list: [], total: 0, pages: 0, page: 1, pageSize: 10 }
  
  return {
    list: Array.isArray(data.list) ? data.list.map(order => normalizeOrderListItem(order)) : [],
    total: Number(data.total) || 0,
    pages: Number(data.pages) || 0,
    page: Number(data.page) || 1,
    pageSize: Number(data.pageSize) || 10
  }
}

const normalizeOrderListItem = (order) => {
  return {
    orderId: order.orderId || null,
    orderSn: order.orderSn || '',
    status: order.status || '',
    statusText: order.statusText || '',
    totalAmount: Number(order.totalAmount) || 0,
    payAmount: Number(order.payAmount) || 0,
    deliveryType: order.deliveryType || 'DELIVERY',
    createTime: order.createTime || '',
    itemList: Array.isArray(order.itemList) ? order.itemList.map(item => ({
      productName: item.productName || '',
      productImage: item.productImage || '',
      skuSpecs: item.skuSpecs || '',
      quantity: Number(item.quantity) || 0,
      price: Number(item.price) || 0
    })) : []
  }
}

const handleOrderListError = (error) => {
  console.error('获取订单列表失败:', error?.message || error)
}

// 获取订单详情
export const getOrderDetailApi = (orderId) => {
  if (!orderId) {
    return Promise.reject(new Error('订单ID不能为空'))
  }
  
  return request({
    url: `/api/orders/${orderId}`,
    method: 'get'
  }).then(response => {
    if (response.code === 0) {
      return {
        ...response,
        data: normalizeOrderDetailData(response.data)
      }
    }
    return response
  }).catch(error => {
    handleOrderDetailError(error)
    throw error
  })
}

const normalizeOrderDetailData = (data) => {
  if (!data) return null
  
  return {
    orderId: data.orderId || null,
    orderSn: data.orderSn || '',
    status: data.status || '',
    statusText: data.statusText || '',
    totalAmount: Number(data.totalAmount) || 0,
    discountAmount: Number(data.discountAmount) || 0,
    deliveryFee: Number(data.deliveryFee) || 0,
    payAmount: Number(data.payAmount) || 0,
    deliveryType: data.deliveryType || 'DELIVERY',
    receiverInfo: data.receiverInfo ? {
      receiverName: data.receiverInfo.receiverName || '',
      receiverPhone: data.receiverInfo.receiverPhone || '',
      fullAddress: data.receiverInfo.fullAddress || ''
    } : null,
    paymentInfo: data.paymentInfo ? {
      paymentId: data.paymentInfo.paymentId || null,
      paySn: data.paymentInfo.paySn || '',
      payPlatform: data.paymentInfo.payPlatform || '',
      status: data.paymentInfo.status || '',
      payTime: data.paymentInfo.payTime || null
    } : null,
    deliveryInfo: data.deliveryInfo || null,
    itemList: Array.isArray(data.itemList) ? data.itemList.map(item => ({
      orderItemId: item.orderItemId || null,
      productId: item.productId || null,
      skuId: item.skuId || null,
      productName: item.productName || '',
      productImage: item.productImage || '',
      skuSpecs: item.skuSpecs || '',
      price: Number(item.price) || 0,
      quantity: Number(item.quantity) || 0,
      itemAmount: Number(item.itemAmount) || 0
    })) : [],
    createTime: data.createTime || '',
    payExpireTime: data.payExpireTime || ''
  }
}

const handleOrderDetailError = (error) => {
  const errorCodeMap = {
    40421: '订单不存在'
  }
  
  if (errorCodeMap[error?.code]) {
    console.error(`订单详情错误[${error.code}]:`, errorCodeMap[error.code])
  }
}

// 取消订单
export const cancelOrderApi = (orderId, data) => {
  if (!orderId) {
    return Promise.reject(new Error('订单ID不能为空'))
  }
  
  return request({
    url: `/api/orders/${orderId}/cancel`,
    method: 'post',
    data: { cancelReason: data?.cancelReason || '' }
  }).then(response => {
    if (response.code === 0) {
      return {
        ...response,
        data: response.data ? {
          orderId: response.data.orderId || null,
          orderSn: response.data.orderSn || '',
          status: response.data.status || 'CANCELLED'
        } : null
      }
    }
    return response
  }).catch(error => {
    const errorCodeMap = {
      40921: '当前订单状态不允许取消'
    }
    if (errorCodeMap[error?.code]) {
      console.error(`取消订单错误[${error.code}]:`, errorCodeMap[error.code])
    }
    throw error
  })
}

// 删除订单记录
export const deleteOrderApi = (orderId) => {
  if (!orderId) {
    return Promise.reject(new Error('订单ID不能为空'))
  }
  
  return request({
    url: `/api/orders/${orderId}`,
    method: 'delete'
  }).then(response => {
    return response
  }).catch(error => {
    const errorCodeMap = {
      40922: '当前订单状态不允许删除'
    }
    if (errorCodeMap[error?.code]) {
      console.error(`删除订单错误[${error.code}]:`, errorCodeMap[error.code])
    }
    throw error
  })
}

// 确认收货
export const confirmOrderApi = (orderId) => {
  if (!orderId) {
    return Promise.reject(new Error('订单ID不能为空'))
  }
  
  return request({
    url: `/api/orders/${orderId}/confirm`,
    method: 'post',
    data: {}
  }).then(response => {
    if (response.code === 0) {
      return {
        ...response,
        data: response.data ? {
          orderId: response.data.orderId || null,
          orderSn: response.data.orderSn || '',
          status: response.data.status || 'COMPLETED',
          completeTime: response.data.completeTime || ''
        } : null
      }
    }
    return response
  }).catch(error => {
    const errorCodeMap = {
      40923: '当前订单状态不允许确认收货'
    }
    if (errorCodeMap[error?.code]) {
      console.error(`确认收货错误[${error.code}]:`, errorCodeMap[error.code])
    }
    throw error
  })
}

// 查询订单状态
export const getOrderStatusApi = (orderId) => {
  if (!orderId) {
    return Promise.reject(new Error('订单ID不能为空'))
  }
  
  return request({
    url: `/api/orders/${orderId}/status`,
    method: 'get'
  }).then(response => {
    if (response.code === 0) {
      return {
        ...response,
        data: response.data ? {
          orderId: response.data.orderId || null,
          orderSn: response.data.orderSn || '',
          status: response.data.status || '',
          statusText: response.data.statusText || '',
          updateTime: response.data.updateTime || ''
        } : null
      }
    }
    return response
  }).catch(error => {
    const errorCodeMap = {
      40421: '订单不存在'
    }
    if (errorCodeMap[error?.code]) {
      console.error(`查询订单状态错误[${error.code}]:`, errorCodeMap[error.code])
    }
    throw error
  })
}


