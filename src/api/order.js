// 订单接口模块
// 包含：订单预览、提交订单、订单列表、订单详情、订单状态查询、取消/确认收货/删除

import request from './base'

// ============ 订单预览接口 ============

// 订单预览 POST /api/orders/preview
// 仅做价格试算、商品/库存/优惠券/积分/活动前置校验，不生成真实订单
// 后端生成一次性 previewToken 存入 Redis，有效期 900 秒
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

// 订单预览参数校验
const validateOrderPreviewParams = (data) => {
  const cartItemIds = Array.isArray(data?.cartItemIds) ? data.cartItemIds : []
  const deliveryType = Number(data?.deliveryType) || 1
  
  if (!cartItemIds.length) {
    throw new Error('请选择要购买的商品')
  }
  
  const params = {
    cartItemIds,
    deliveryType
  }
  
  // 配送方式二选一：deliveryType=1 配送需传 addressId，deliveryType=2 自提需传 pickupPointId
  if (deliveryType === 1) {
    if (data?.addressId) {
      params.addressId = data.addressId
    }
    // 不传 addressId 后端自动取用户默认地址
  } else if (deliveryType === 2) {
    if (!data?.pickupPointId) {
      throw new Error('自提方式下请选择自提点')
    }
    params.pickupPointId = data.pickupPointId
  }
  
  // 平台优惠券：usePlatformCoupon=true 且 platformCouponUserId=null 自动选最优；传 ID 指定单张；false 不使用
  if (data?.usePlatformCoupon !== undefined) {
    params.usePlatformCoupon = !!data.usePlatformCoupon
    if (data.usePlatformCoupon && data?.platformCouponUserId) {
      params.platformCouponUserId = data.platformCouponUserId
    }
  }
  
  // 商家优惠券：useMerchantCoupon=true 且 merchantCouponUserId=null 自动选最优；传 ID 指定；false 不使用
  if (data?.useMerchantCoupon !== undefined) {
    params.useMerchantCoupon = !!data.useMerchantCoupon
    if (data.useMerchantCoupon && data?.merchantCouponUserId) {
      params.merchantCouponUserId = data.merchantCouponUserId
    }
  }
  
  // 积分抵扣：usePoints=true 且 usePointsAmount=null 自动填充最大可用；手动输入校验上限；false 关闭
  if (data?.usePoints !== undefined) {
    params.usePoints = !!data.usePoints
    if (data.usePoints) {
      params.usePointsAmount = data?.usePointsAmount !== undefined ? Number(data.usePointsAmount) || 0 : null
    }
  }
  
  // 活动上下文：不传活动 ID 后端自动匹配最优；传入指定 ID 则固定使用
  const activityContext = {}
  if (data?.activityContext?.seckillId) {
    activityContext.seckillId = data.activityContext.seckillId
  }
  if (data?.activityContext?.bargainId) {
    activityContext.bargainId = data.activityContext.bargainId
  }
  if (data?.activityContext?.groupId) {
    activityContext.groupId = data.activityContext.groupId
  }
  if (Array.isArray(data?.activityContext?.promotionIds) && data.activityContext.promotionIds.length > 0) {
    activityContext.promotionIds = data.activityContext.promotionIds
  }
  if (Object.keys(activityContext).length > 0) {
    params.activityContext = activityContext
  }
  
  if (data?.remark) {
    params.remark = data.remark
  }
  
  return params
}

// 订单预览数据规范化
const normalizeOrderPreviewData = (data) => {
  if (!data) return null
  
  return {
    previewToken: data.previewToken || '',
    previewExpireSeconds: Number(data.previewExpireSeconds) || 900,
    itemList: normalizeItemList(data.itemList),
    priceDetail: normalizePriceDetail(data.priceDetail),
    pointsInfo: normalizePointsInfo(data.pointsInfo),
    couponInfo: normalizeCouponInfo(data.couponInfo),
    promotionDetail: normalizePromotionDetail(data.promotionDetail),
    addressInfo: normalizeAddressInfo(data.addressInfo),
    pickupPointInfo: normalizePickupPointInfo(data.pickupPointInfo),
    activityInfo: normalizeActivityInfo(data.activityInfo),
    availableCoupons: normalizeAvailableCoupons(data.availableCoupons),
    availablePromotions: Array.isArray(data.availablePromotions) ? data.availablePromotions : [],
    totalQuantity: Number(data.totalQuantity) || 0
  }
}

const normalizePriceDetail = (priceDetail) => {
  if (!priceDetail) return {
    totalAmount: 0,
    seckillDiscount: 0,
    bargainDiscount: 0,
    promotionDiscount: 0,
    merchantCouponDiscount: 0,
    platformCouponDiscount: 0,
    pointsDeduction: 0,
    deliveryFee: 0,
    payAmount: 0
  }
  
  return {
    totalAmount: Number(priceDetail.totalAmount) || 0,
    seckillDiscount: Number(priceDetail.seckillDiscount) || 0,
    bargainDiscount: Number(priceDetail.bargainDiscount) || 0,
    promotionDiscount: Number(priceDetail.promotionDiscount) || 0,
    merchantCouponDiscount: Number(priceDetail.merchantCouponDiscount) || 0,
    platformCouponDiscount: Number(priceDetail.platformCouponDiscount) || 0,
    pointsDeduction: Number(priceDetail.pointsDeduction) || 0,
    deliveryFee: Number(priceDetail.deliveryFee) || 0,
    payAmount: Number(priceDetail.payAmount) || 0
  }
}

const normalizePointsInfo = (pointsInfo) => {
  if (!pointsInfo) return {
    pointsBalance: 0,
    canUsePoints: false,
    maxUsablePoints: 0,
    usedPoints: 0,
    deductionAmount: 0,
    deductionRule: '',
    maxDeductionAmount: 0
  }
  
  return {
    pointsBalance: Number(pointsInfo.pointsBalance) || 0,
    canUsePoints: pointsInfo.canUsePoints !== false,
    maxUsablePoints: Number(pointsInfo.maxUsablePoints) || 0,
    usedPoints: Number(pointsInfo.usedPoints) || 0,
    deductionAmount: Number(pointsInfo.deductionAmount) || 0,
    deductionRule: pointsInfo.deductionRule || '',
    maxDeductionAmount: Number(pointsInfo.maxDeductionAmount) || 0
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
    stock: Number(item.stock) || 0,
    itemOriginAmount: Number(item.itemOriginAmount) || 0,
    itemFinalAmount: Number(item.itemFinalAmount) || 0,
    promotionType: item.promotionType || '',
    activityDiscount: Number(item.activityDiscount) || 0,
    isValid: item.isValid !== false,
    invalidReason: item.invalidReason || null
  }))
}

const normalizeCouponInfo = (couponInfo) => {
  if (!couponInfo) return { platformCoupon: null, merchantCoupon: null }
  
  return {
    platformCoupon: couponInfo.platformCoupon ? {
      couponUserId: couponInfo.platformCoupon.couponUserId || null,
      couponId: couponInfo.platformCoupon.couponId || null,
      title: couponInfo.platformCoupon.title || '',
      source: couponInfo.platformCoupon.source || '',
      sourceText: couponInfo.platformCoupon.sourceText || '',
      minConsume: Number(couponInfo.platformCoupon.minConsume) || 0,
      discountAmount: Number(couponInfo.platformCoupon.discountAmount) || 0,
      selected: couponInfo.platformCoupon.selected !== false,
      autoSelected: couponInfo.platformCoupon.autoSelected !== false
    } : null,
    merchantCoupon: couponInfo.merchantCoupon ? {
      couponUserId: couponInfo.merchantCoupon.couponUserId || null,
      couponId: couponInfo.merchantCoupon.couponId || null,
      merchantId: couponInfo.merchantCoupon.merchantId || null,
      merchantName: couponInfo.merchantCoupon.merchantName || '',
      title: couponInfo.merchantCoupon.title || '',
      source: couponInfo.merchantCoupon.source || '',
      sourceText: couponInfo.merchantCoupon.sourceText || '',
      minConsume: Number(couponInfo.merchantCoupon.minConsume) || 0,
      discountAmount: Number(couponInfo.merchantCoupon.discountAmount) || 0,
      selected: couponInfo.merchantCoupon.selected !== false,
      autoSelected: couponInfo.merchantCoupon.autoSelected !== false
    } : null
  }
}

const normalizePromotionDetail = (promotionDetail) => {
  if (!Array.isArray(promotionDetail)) return []
  
  return promotionDetail.map(item => ({
    type: item.type || '',
    title: item.title || '',
    discount: Number(item.discount) || 0,
    usedPoints: Number(item.usedPoints) || 0
  }))
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

const normalizePickupPointInfo = (pickupPointInfo) => {
  if (!pickupPointInfo) return null
  
  return {
    pickupPointId: pickupPointInfo.pickupPointId || null,
    name: pickupPointInfo.name || '',
    address: pickupPointInfo.address || '',
    phone: pickupPointInfo.phone || '',
    businessHours: pickupPointInfo.businessHours || ''
  }
}

const normalizeActivityInfo = (activityInfo) => {
  if (!activityInfo) return {}
  
  return {
    seckillProductId: activityInfo.seckillProductId || null,
    bargainRecordId: activityInfo.bargainRecordId || null,
    groupId: activityInfo.groupId || null,
    promotionIds: Array.isArray(activityInfo.promotionIds) ? activityInfo.promotionIds : []
  }
}

const normalizeAvailableCoupons = (availableCoupons) => {
  if (!availableCoupons) return { platformCoupons: [], merchantCoupons: [] }
  
  const normalizeCoupon = (coupon) => ({
    couponUserId: coupon.couponUserId || null,
    couponId: coupon.couponId || null,
    merchantId: coupon.merchantId || null,
    merchantName: coupon.merchantName || '',
    title: coupon.title || '',
    source: coupon.source || '',
    sourceText: coupon.sourceText || '',
    minConsume: Number(coupon.minConsume) || 0,
    discountAmount: Number(coupon.discountAmount) || 0,
    selected: coupon.selected !== false,
    autoSelected: coupon.autoSelected !== false
  })
  
  return {
    platformCoupons: Array.isArray(availableCoupons.platformCoupons) 
      ? availableCoupons.platformCoupons.map(normalizeCoupon) : [],
    merchantCoupons: Array.isArray(availableCoupons.merchantCoupons) 
      ? availableCoupons.merchantCoupons.map(normalizeCoupon) : []
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

// ============ 提交订单接口 ============

// 生成幂等键
const generateIdempotentKey = () => {
  return `order-submit-${Date.now()}-${Math.random().toString(36).substring(2, 9)}`
}

// 提交订单 POST /api/orders
// 仅接收预览返回的 previewToken，不接收商品、地址、优惠券、积分等业务参数
// 请求头必须携带 X-Idempotent-Key 幂等唯一键
export const submitOrderApi = (data) => {
  if (!data?.previewToken) {
    return Promise.reject(new Error('预览令牌不能为空，请重新预览'))
  }
  
  const idempotentKey = data?.idempotentKey || generateIdempotentKey()
  
  return request({
    url: '/api/orders',
    method: 'post',
    data: { previewToken: data.previewToken },
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

const normalizeSubmitOrderData = (data) => {
  if (!data) return null
  
  return {
    orderId: data.orderId || null,
    orderSn: data.orderSn || '',
    status: data.status || 'WAIT_PAY',
    statusText: data.statusText || '待支付',
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
    40915: '活动已过期',
    40916: '预览令牌已过期，请重新预览'
  }
  
  if (errorCodeMap[error?.code]) {
    console.error(`提交订单错误[${error.code}]:`, errorCodeMap[error.code])
  }
}

// ============ 订单列表接口 ============

// 获取订单列表 GET /api/orders
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
  const validated = {
    page: Number(params?.page) || 1,
    pageSize: Number(params?.pageSize) || 10
  }
  if (params?.status && params.status !== 'ALL') {
    validated.status = params.status
  }
  return validated
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
    deliveryType: order.deliveryType || 1,
    deliveryTypeText: order.deliveryTypeText || '',
    createTime: order.createTime || '',
    totalQuantity: Number(order.totalQuantity) || 0,
    itemList: Array.isArray(order.itemList) ? order.itemList.map(item => ({
      productName: item.productName || '',
      productImage: item.productImage || '',
      skuSpecs: item.skuSpecs || '',
      quantity: Number(item.quantity) || 0,
      price: Number(item.price) || 0,
      finalPrice: Number(item.finalPrice) || 0
    })) : []
  }
}

const handleOrderListError = (error) => {
  console.error('获取订单列表失败:', error?.message || error)
}

// ============ 订单详情接口 ============

// 获取订单详情 GET /api/orders/{orderId}
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
    deliveryType: data.deliveryType || 1,
    deliveryTypeText: data.deliveryTypeText || '',
    remark: data.remark || '',
    receiverInfo: data.receiverInfo ? {
      receiverName: data.receiverInfo.receiverName || '',
      receiverPhone: data.receiverInfo.receiverPhone || '',
      fullAddress: data.receiverInfo.fullAddress || ''
    } : null,
    pickupPointInfo: data.pickupPointInfo ? {
      pickupPointId: data.pickupPointInfo.pickupPointId || null,
      name: data.pickupPointInfo.name || '',
      address: data.pickupPointInfo.address || '',
      phone: data.pickupPointInfo.phone || '',
      businessHours: data.pickupPointInfo.businessHours || ''
    } : null,
    paymentInfo: data.paymentInfo ? {
      paymentId: data.paymentInfo.paymentId || null,
      paySn: data.paymentInfo.paySn || '',
      payPlatform: data.paymentInfo.payPlatform || '',
      status: data.paymentInfo.status || '',
      payTime: data.paymentInfo.payTime || null
    } : null,
    deliveryInfo: data.deliveryInfo || null,
    priceDetail: normalizePriceDetail(data.priceDetail),
    promotionDetail: normalizePromotionDetail(data.promotionDetail),
    couponInfo: data.couponInfo ? {
      platformCoupon: data.couponInfo.platformCoupon || null,
      merchantCoupon: data.couponInfo.merchantCoupon || null
    } : null,
    pointsInfo: data.pointsInfo ? {
      usedPoints: Number(data.pointsInfo.usedPoints) || 0,
      deductionAmount: Number(data.pointsInfo.deductionAmount) || 0,
      deductionRule: data.pointsInfo.deductionRule || ''
    } : null,
    itemList: Array.isArray(data.itemList) ? data.itemList.map(item => ({
      orderItemId: item.orderItemId || null,
      productId: item.productId || null,
      skuId: item.skuId || null,
      productName: item.productName || '',
      productImage: item.productImage || '',
      skuSpecs: item.skuSpecs || '',
      originPrice: Number(item.originPrice) || 0,
      finalPrice: Number(item.finalPrice) || 0,
      price: Number(item.price) || 0,
      quantity: Number(item.quantity) || 0,
      itemAmount: Number(item.itemAmount) || 0,
      promotionType: item.promotionType || ''
    })) : [],
    createTime: data.createTime || '',
    payExpireTime: data.payExpireTime || '',
    payTime: data.payTime || '',
    completeTime: data.completeTime || ''
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

// ============ 订单操作接口 ============

// 取消订单 POST /api/orders/{orderId}/cancel
// 仅 WAIT_PAY、WAIT_ACCEPT 可调用
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
          status: response.data.status || 'CANCELLED',
          statusText: response.data.statusText || '已取消'
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

// 确认收货 POST /api/orders/{orderId}/confirm
// 仅 IN_PROGRESS 状态可用
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
          statusText: response.data.statusText || '已完成',
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

// 删除订单 DELETE /api/orders/{orderId}
// 仅 COMPLETED、CANCELLED、CLOSED 可删除
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

// 查询订单状态 GET /api/orders/{orderId}/status
// 轻量化接口，仅返回订单最新状态，用于支付页、待支付详情页轮询
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
