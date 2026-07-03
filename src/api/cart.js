import request from './base'

export const getCartItemsApi = () => {
  return request({
    url: '/api/cart/items',
    method: 'get'
  }).then(response => {
    if (response.code === 0) {
      return {
        ...response,
        data: normalizeCartListData(response.data)
      }
    }
    return response
  }).catch(error => {
    handleCartListError(error)
    throw error
  })
}

const normalizeCartListData = (data) => {
  if (!data) return { items: [], totalQuantity: 0, totalAmount: 0, checkedAmount: 0 }
  
  const items = Array.isArray(data.items) ? data.items : 
                Array.isArray(data.list) ? data.list : []
  
  return {
    items: items.map(item => normalizeCartItem(item)),
    totalQuantity: Number(data.totalQuantity) || Number(data.total) || 0,
    totalAmount: Number(data.totalAmount) || 0,
    checkedAmount: Number(data.checkedAmount) || 0
  }
}

const normalizeCartItem = (item) => {
  return {
    cartItemId: item.cartItemId || item.cartId || null,
    cartId: item.cartId || item.cartItemId || null,
    skuId: item.skuId || null,
    productId: item.productId || null,
    productName: item.productName || '',
    productImage: item.productImage || '',
    skuSpecs: item.skuSpec || item.skuSpecs || '',
    price: Number(item.price) || 0,
    quantity: Number(item.quantity) || 0,
    stock: Number(item.stock) || 0,
    checked: item.selected !== undefined ? !!item.selected : !!item.checked,
    valid: item.isValid !== undefined ? !!item.isValid : (item.valid !== false),
    invalidReason: item.invalidReason || null,
    merchantId: item.merchantId || null,
    merchantName: item.merchantName || '',
    itemAmount: Number(item.itemAmount) || 0
  }
}

const handleCartListError = (error) => {
  const errorCodeMap = {
    40101: '登录已过期，请重新登录'
  }
  
  if (errorCodeMap[error?.code]) {
    console.error(`购物车列表错误[${error.code}]:`, errorCodeMap[error.code])
  }
}

export const addCartItemApi = (data) => {
  const validatedData = validateAddCartParams(data)
  
  return request({
    url: '/api/cart/items',
    method: 'post',
    data: validatedData
  }).then(response => {
    if (response.code === 0) {
      return {
        ...response,
        data: response.data ? {
          cartItemId: response.data.cartItemId || null,
          skuId: response.data.skuId || null,
          quantity: Number(response.data.quantity) || 0
        } : null
      }
    }
    return response
  }).catch(error => {
    handleAddCartError(error)
    throw error
  })
}

const validateAddCartParams = (data) => {
  if (!data?.skuId) {
    throw new Error('商品SKU不能为空')
  }
  
  const quantity = Number(data?.quantity) || 1
  if (quantity <= 0) {
    throw new Error('加入数量必须大于0')
  }
  
  return {
    skuId: data.skuId,
    quantity
  }
}

const handleAddCartError = (error) => {
  const errorCodeMap = {
    40911: '商品库存不足',
    40101: '登录已过期，请重新登录'
  }
  
  if (errorCodeMap[error?.code]) {
    console.error(`加入购物车错误[${error.code}]:`, errorCodeMap[error.code])
  }
}

export const updateCartItemApi = (cartItemId, data) => {
  if (!cartItemId) {
    return Promise.reject(new Error('购物车商品ID不能为空'))
  }
  
  const quantity = Number(data?.quantity) || 0
  if (quantity <= 0) {
    return Promise.reject(new Error('商品数量必须大于0'))
  }
  
  return request({
    url: `/api/cart/items/${cartItemId}`,
    method: 'put',
    data: { quantity }
  }).then(response => {
    if (response.code === 0) {
      return {
        ...response,
        data: response.data ? {
          cartItemId: response.data.cartItemId || null,
          skuId: response.data.skuId || null,
          quantity: Number(response.data.quantity) || 0,
          price: Number(response.data.price) || 0,
          itemAmount: Number(response.data.itemAmount) || 0
        } : null
      }
    }
    return response
  }).catch(error => {
    const errorCodeMap = {
      40411: '购物车商品不存在',
      40911: '商品库存不足'
    }
    if (errorCodeMap[error?.code]) {
      console.error(`修改购物车数量错误[${error.code}]:`, errorCodeMap[error.code])
    }
    throw error
  })
}

export const deleteCartItemApi = (cartItemId) => {
  if (!cartItemId) {
    return Promise.reject(new Error('购物车商品ID不能为空'))
  }
  
  return request({
    url: `/api/cart/items/${cartItemId}`,
    method: 'delete'
  }).then(response => {
    return response
  }).catch(error => {
    const errorCodeMap = {
      40411: '购物车商品不存在'
    }
    if (errorCodeMap[error?.code]) {
      console.error(`删除购物车商品错误[${error.code}]:`, errorCodeMap[error.code])
    }
    throw error
  })
}

export const deleteCartItemsApi = (data) => {
  const cartItemIds = Array.isArray(data?.cartItemIds) ? data.cartItemIds : []
  
  if (!cartItemIds.length) {
    return Promise.reject(new Error('请选择要删除的商品'))
  }
  
  return request({
    url: '/api/cart/items',
    method: 'delete',
    data: { cartItemIds }
  }).then(response => {
    if (response.code === 0) {
      return {
        ...response,
        data: response.data ? {
          deletedCount: Number(response.data.deletedCount) || 0
        } : null
      }
    }
    return response
  }).catch(error => {
    const errorCodeMap = {
      40001: '请选择要删除的商品'
    }
    if (errorCodeMap[error?.code]) {
      console.error(`批量删除购物车错误[${error.code}]:`, errorCodeMap[error.code])
    }
    throw error
  })
}

export const checkoutPreviewApi = (data) => {
  const validatedData = validateCheckoutPreviewParams(data)
  
  return request({
    url: '/api/cart/checkout-preview',
    method: 'post',
    data: validatedData
  }).then(response => {
    if (response.code === 0) {
      return {
        ...response,
        data: normalizeCheckoutPreviewData(response.data)
      }
    }
    return response
  }).catch(error => {
    handleCheckoutPreviewError(error)
    throw error
  })
}

const validateCheckoutPreviewParams = (data) => {
  const cartItemIds = Array.isArray(data?.cartItemIds) ? data.cartItemIds : []
  
  if (!cartItemIds.length) {
    throw new Error('请选择要结算的商品')
  }
  
  return {
    cartItemIds,
    couponUserId: data?.couponUserId || null,
    usePoints: !!data?.usePoints,
    activityContext: {
      seckillId: data?.activityContext?.seckillId || null,
      bargainId: data?.activityContext?.bargainId || null,
      groupId: data?.activityContext?.groupId || null,
      promotionIds: Array.isArray(data?.activityContext?.promotionIds) ? data.activityContext.promotionIds : []
    }
  }
}

const normalizeCheckoutPreviewData = (data) => {
  if (!data) return null
  
  return {
    items: Array.isArray(data.items) ? data.items.map(item => ({
      cartItemId: item.cartItemId || null,
      skuId: item.skuId || null,
      productId: item.productId || null,
      productName: item.productName || '',
      productImage: item.productImage || '',
      skuSpec: item.skuSpec || '',
      originalPrice: Number(item.originalPrice) || 0,
      salePrice: Number(item.salePrice) || 0,
      quantity: Number(item.quantity) || 0,
      stock: Number(item.stock) || 0,
      itemOriginalAmount: Number(item.itemOriginalAmount) || 0,
      itemPayableAmount: Number(item.itemPayableAmount) || 0,
      activityType: item.activityType || null,
      activityDiscount: Number(item.activityDiscount) || 0,
      isValid: item.isValid !== false,
      invalidReason: item.invalidReason || null
    })) : [],
    priceDetail: data.priceDetail ? {
      originalAmount: Number(data.priceDetail.originalAmount) || 0,
      seckillDiscount: Number(data.priceDetail.seckillDiscount) || 0,
      bargainDiscount: Number(data.priceDetail.bargainDiscount) || 0,
      promotionDiscount: Number(data.priceDetail.promotionDiscount) || 0,
      couponDiscount: Number(data.priceDetail.couponDiscount) || 0,
      pointsDeduction: Number(data.priceDetail.pointsDeduction) || 0,
      deliveryFee: Number(data.priceDetail.deliveryFee) || 0,
      payableAmount: Number(data.priceDetail.payableAmount) || 0
    } : null,
    promotionDetail: Array.isArray(data.promotionDetail) ? data.promotionDetail : [],
    couponInfo: data.couponInfo || null,
    activityInfo: data.activityInfo ? {
      seckillActivityId: data.activityInfo.seckillActivityId || null,
      bargainActivityId: data.activityInfo.bargainActivityId || null,
      groupActivityId: data.activityInfo.groupActivityId || null,
      promotionIds: Array.isArray(data.activityInfo.promotionIds) ? data.activityInfo.promotionIds : []
    } : {},
    availablePromotions: Array.isArray(data.availablePromotions) ? data.availablePromotions : [],
    availableCoupons: Array.isArray(data.availableCoupons) ? data.availableCoupons : [],
    totalQuantity: Number(data.totalQuantity) || 0
  }
}

const handleCheckoutPreviewError = (error) => {
  const errorCodeMap = {
    40101: '登录已过期，请重新登录',
    40911: '商品库存不足',
    40912: '部分商品已失效'
  }
  
  if (errorCodeMap[error?.code]) {
    console.error(`结算预览错误[${error.code}]:`, errorCodeMap[error.code])
  }
}

export const getInvalidCartItemsApi = () => {
  return request({
    url: '/api/cart/invalid-items',
    method: 'get'
  }).then(response => {
    if (response.code === 0) {
      return {
        ...response,
        data: response.data ? {
          list: Array.isArray(response.data.list) ? response.data.list.map(item => ({
            cartItemId: item.cartItemId || null,
            skuId: item.skuId || null,
            productId: item.productId || null,
            productName: item.productName || '',
            productImage: item.productImage || '',
            quantity: Number(item.quantity) || 0,
            invalidReason: item.invalidReason || ''
          })) : []
        } : null
      }
    }
    return response
  }).catch(error => {
    if (error.statusCode === 404) {
      console.warn('失效商品接口不存在，返回空数据:', error)
      return { code: 0, data: { list: [] } }
    }
    
    const errorCodeMap = {
      40101: '登录已过期，请重新登录'
    }
    
    if (errorCodeMap[error?.code]) {
      console.error(`失效商品列表错误[${error.code}]:`, errorCodeMap[error.code])
    }
    throw error
  })
}
