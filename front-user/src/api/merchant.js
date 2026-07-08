import request from './base'

// ============ 数据规范化函数 ============

/**
 * 规范化商家主页详情数据(接口 2.9.1)
 */
const normalizeMerchantHomeData = (data) => {
  if (!data) return null
  return {
    merchantId: data.merchantId || null,
    merchantName: data.merchantName || '',
    logo: data.logo || '',
    shopAddress: data.shopAddress || '',
    businessHours: data.businessHours || '',
    introduction: data.introduction || '',
    contactPhone: data.contactPhone || '',
    status: Number(data.status ?? 0),
    statusText: data.statusText || '',
    statistics: {
      productCount: Number(data.statistics?.productCount ?? 0),
      totalSoldCount: Number(data.statistics?.totalSoldCount ?? 0)
    },
    couponList: Array.isArray(data.couponList) ? data.couponList.map(normalizeMerchantCoupon) : [],
    recommendProducts: Array.isArray(data.recommendProducts) ? data.recommendProducts.map(normalizeMerchantProduct) : []
  }
}

/**
 * 规范化商家基础信息数据(接口 2.9.2)
 */
const normalizeMerchantInfoData = (data) => {
  if (!data) return null
  return {
    merchantId: data.merchantId || null,
    merchantName: data.merchantName || '',
    logo: data.logo || '',
    shopAddress: data.shopAddress || '',
    businessHours: data.businessHours || '',
    introduction: data.introduction || '',
    contactName: data.contactName || '',
    contactPhone: data.contactPhone || '',
    status: Number(data.status ?? 0),
    statusText: data.statusText || '',
    createTime: data.createTime || ''
  }
}

/**
 * 规范化商家商品列表数据(接口 2.9.3)
 */
const normalizeMerchantProductsData = (data) => {
  if (!data) return { merchantId: null, merchantName: '', list: [], total: 0, pages: 0, page: 1, pageSize: 10 }
  return {
    merchantId: data.merchantId || null,
    merchantName: data.merchantName || '',
    list: Array.isArray(data.list) ? data.list.map(normalizeMerchantProduct) : [],
    total: Number(data.total) || 0,
    pages: Number(data.pages) || 0,
    page: Number(data.page) || 1,
    pageSize: Number(data.pageSize) || 10
  }
}

/**
 * 规范化商家优惠券数据(4.3.1 商家优惠券列表返回字段)
 */
const normalizeMerchantCoupon = (item) => ({
  couponId: item.couponId || null,
  title: item.title || '',
  type: Number(item.type ?? 0),
  typeText: item.typeText || '',
  minConsume: Number(item.minConsume ?? 0),
  discountAmount: Number(item.discountAmount ?? 0),
  totalCount: Number(item.totalCount ?? 0),
  receivedCount: Number(item.receivedCount ?? 0),
  remainingCount: Number(item.remainingCount ?? 0),
  perUserLimit: Number(item.perUserLimit ?? 1),
  alreadyReceived: !!item.alreadyReceived,
  validStart: item.validStart || '',
  validEnd: item.validEnd || ''
})

/**
 * 规范化商家优惠券列表响应数据(4.3.1)
 */
const normalizeMerchantCouponListData = (data) => {
  if (!data) return { merchantId: null, merchantName: '', list: [], total: 0, pages: 0, page: 1, pageSize: 10 }
  return {
    merchantId: data.merchantId || null,
    merchantName: data.merchantName || '',
    list: Array.isArray(data.list) ? data.list.map(normalizeMerchantCoupon) : [],
    total: Number(data.total) || 0,
    pages: Number(data.pages) || 0,
    page: Number(data.page) || 1,
    pageSize: Number(data.pageSize) || 10
  }
}

/**
 * 规范化领取商家优惠券响应数据(4.3.2)
 */
const normalizeReceiveCouponData = (data) => {
  if (!data) return null
  return {
    couponUserId: data.couponUserId || null,
    couponId: data.couponId || null,
    merchantId: data.merchantId || null,
    merchantName: data.merchantName || '',
    title: data.title || '',
    status: Number(data.status ?? 0),
    statusText: data.statusText || '未使用',
    receiveTime: data.receiveTime || '',
    validStart: data.validStart || '',
    validEnd: data.validEnd || '',
    // 是否为幂等响应(重复请求)
    idempotent: !!data.idempotent
  }
}

/**
 * 生成商家优惠券领取幂等键
 * 格式: merchant_coupon_receive_{userId}_{date}_{random}
 */
const generateIdempotentKey = () => {
  const userId = uni.getStorageSync('userId') || '0'
  const now = new Date()
  const dateStr = `${now.getFullYear()}${String(now.getMonth() + 1).padStart(2, '0')}${String(now.getDate()).padStart(2, '0')}`
  const random = Math.random().toString(36).substring(2, 14)
  return `merchant_coupon_receive_${userId}_${dateStr}_${random}`
}

/**
 * 规范化商家商品数据
 */
const normalizeMerchantProduct = (item) => ({
  productId: item.productId || null,
  merchantId: item.merchantId || null,
  title: item.title || item.productName || '',
  subTitle: item.subTitle || '',
  mainImage: item.mainImage || item.productImage || '',
  saleType: Number(item.saleType ?? 0),
  saleTypeText: item.saleTypeText || '',
  status: Number(item.status ?? 0),
  auditStatus: Number(item.auditStatus ?? 0),
  soldCount: Number(item.soldCount ?? 0),
  createTime: item.createTime || ''
})

// ============ API 接口 ============

/**
 * 2.9.1 商家主页详情
 * GET /api/merchants/{merchantId}/home
 */
export const getMerchantHomeApi = (merchantId) => {
  if (!merchantId) {
    return Promise.reject(new Error('商家ID不能为空'))
  }
  return request({
    url: `/api/merchants/${merchantId}/home`,
    method: 'get'
  }).then(response => {
    if (response.code === 0) {
      return {
        ...response,
        data: response.data ? normalizeMerchantHomeData(response.data) : null
      }
    }
    return response
  }).catch(error => {
    console.error('获取商家主页失败:', error)
    throw error
  })
}

/**
 * 2.9.2 商家基础信息
 * GET /api/merchants/{merchantId}
 */
export const getMerchantInfoApi = (merchantId) => {
  if (!merchantId) {
    return Promise.reject(new Error('商家ID不能为空'))
  }
  return request({
    url: `/api/merchants/${merchantId}`,
    method: 'get'
  }).then(response => {
    if (response.code === 0) {
      return {
        ...response,
        data: response.data ? normalizeMerchantInfoData(response.data) : null
      }
    }
    return response
  }).catch(error => {
    console.error('获取商家信息失败:', error)
    throw error
  })
}

/**
 * 2.9.3 商家商品列表
 * GET /api/merchants/{merchantId}/products
 */
export const getMerchantProductsApi = (merchantId, params = {}) => {
  if (!merchantId) {
    return Promise.reject(new Error('商家ID不能为空'))
  }
  const validatedParams = {
    keyword: params?.keyword || null,
    saleType: params?.saleType ?? null,
    sort: params?.sort || 'DEFAULT',
    page: Number(params?.page) || 1,
    pageSize: Number(params?.pageSize) || 10
  }
  return request({
    url: `/api/merchants/${merchantId}/products`,
    method: 'get',
    params: validatedParams
  }).then(response => {
    if (response.code === 0) {
      return {
        ...response,
        data: response.data ? normalizeMerchantProductsData(response.data) : null
      }
    }
    return response
  }).catch(error => {
    console.error('获取商家商品列表失败:', error)
    throw error
  })
}

/**
 * 4.3.1 商家优惠券列表
 * GET /api/merchants/{merchantId}/coupons
 * 查询指定商家发布的、当前用户可领取的商家优惠券列表
 */
export const getMerchantCouponsApi = (merchantId, params = {}) => {
  if (!merchantId) {
    return Promise.reject(new Error('商家ID不能为空'))
  }
  const validatedParams = {
    page: Number(params?.page) || 1,
    pageSize: Number(params?.pageSize) || 10
  }
  return request({
    url: `/api/merchants/${merchantId}/coupons`,
    method: 'get',
    params: validatedParams
  }).then(response => {
    if (response.code === 0) {
      return {
        ...response,
        data: response.data ? normalizeMerchantCouponListData(response.data) : null
      }
    }
    return response
  }).catch(error => {
    console.error('获取商家优惠券列表失败:', error)
    throw error
  })
}

/**
 * 4.3.2 领取商家优惠券
 * POST /api/merchant-coupons/{couponId}/receive
 * 当前用户领取指定商家优惠券,需要 X-Idempotent-Key 幂等键
 */
export const receiveMerchantCouponApi = (couponId) => {
  if (!couponId) {
    return Promise.reject(new Error('优惠券ID不能为空'))
  }
  return request({
    url: `/api/merchant-coupons/${couponId}/receive`,
    method: 'post',
    headers: {
      'X-Idempotent-Key': generateIdempotentKey()
    }
  }).then(response => {
    if (response.code === 0) {
      return {
        ...response,
        data: response.data ? normalizeReceiveCouponData(response.data) : null
      }
    }
    return response
  }).catch(error => {
    console.error('领取商家优惠券失败:', error)
    throw error
  })
}

/**
 * 2.9.7 查询商家自提点列表
 * GET /api/merchants/{merchantId}/pickup-points
 * 查询指定商家的可用自提点列表，用于用户在订单确认页选择自提方式时展示
 */
export const getPickupPointsApi = (merchantId) => {
  if (!merchantId) {
    return Promise.reject(new Error('商家ID不能为空'))
  }

  return request({
    url: `/api/merchants/${merchantId}/pickup-points`,
    method: 'get'
  }).then(response => {
    if (response.code === 0) {
      return {
        ...response,
        data: Array.isArray(response.data) ? response.data.map(normalizePickupPoint) : []
      }
    }
    return response
  }).catch(error => {
    console.error('获取自提点列表失败:', error)
    throw error
  })
}

const normalizePickupPoint = (item) => {
  return {
    pickupPointId: item.pickupPointId || null,
    merchantId: item.merchantId || null,
    name: item.name || '',
    address: item.address || '',
    contactPhone: item.contactPhone || '',
    businessHours: item.businessHours || '',
    image: item.image || ''
  }
}

