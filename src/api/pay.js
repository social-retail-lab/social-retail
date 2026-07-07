// 支付接口模块
// 包含：创建支付宝支付、支付状态查询、模拟支付成功/失败、支付流水详情

import request from './base'

// ============ 创建支付宝沙箱支付 ============

// POST /api/pay/alipay/create
// 根据订单编号创建支付宝沙箱支付请求，返回沙箱支付页面地址或支付表单
export const createAlipayApi = (data) => {
  if (!data?.orderId) {
    return Promise.reject(new Error('订单ID不能为空'))
  }

  const params = {
    orderId: Number(data.orderId),
    payType: data.payType || 'WAP'
  }

  // 传递返回地址，让后端设置支付宝的 return_url
  if (data.returnUrl) {
    params.returnUrl = data.returnUrl
  }

  return request({
    url: '/api/pay/alipay/create',
    method: 'post',
    data: params
  }).then(response => {
    if (response.code === 0) {
      return {
        ...response,
        data: normalizeAlipayData(response.data)
      }
    }
    return response
  }).catch(error => {
    const errorCodeMap = {
      40924: '当前订单状态不允许支付'
    }
    if (errorCodeMap[error?.code]) {
      console.error(`创建支付错误[${error.code}]:`, errorCodeMap[error.code])
    }
    throw error
  })
}

const normalizeAlipayData = (data) => {
  if (!data) return null

  return {
    paymentId: data.paymentId || null,
    paySn: data.paySn || '',
    orderId: data.orderId || null,
    orderSn: data.orderSn || '',
    payAmount: Number(data.payAmount) || 0,
    payPlatform: data.payPlatform || 'ALIPAY_SANDBOX',
    payType: data.payType || 'WAP',
    payPayload: data.payPayload || ''
  }
}

// ============ 支付状态查询 ============

// GET /api/pay/orders/{orderId}/status
// 查询订单支付状态，用于支付结果页主动刷新支付结果
export const getPayStatusApi = (orderId) => {
  if (!orderId) {
    return Promise.reject(new Error('订单ID不能为空'))
  }

  return request({
    url: `/api/pay/orders/${orderId}/status`,
    method: 'get'
  }).then(response => {
    if (response.code === 0) {
      return {
        ...response,
        data: normalizePayStatusData(response.data)
      }
    }
    return response
  }).catch(error => {
    console.error('查询支付状态失败:', error?.message || error)
    throw error
  })
}

const normalizePayStatusData = (data) => {
  if (!data) return null

  return {
    orderId: data.orderId || null,
    orderSn: data.orderSn || '',
    paymentId: data.paymentId || null,
    paySn: data.paySn || '',
    payPlatform: data.payPlatform || '',
    payStatus: data.payStatus || '',
    orderStatus: data.orderStatus || '',
    payAmount: Number(data.payAmount) || 0,
    payTime: data.payTime || ''
  }
}

// ============ 模拟支付成功 ============

// POST /api/pay/mock/success
// 开发测试使用的模拟支付成功接口
export const mockPaySuccessApi = (data) => {
  if (!data?.orderId) {
    return Promise.reject(new Error('订单ID不能为空'))
  }

  const params = {
    orderId: Number(data.orderId)
  }
  if (data.payAmount !== undefined) {
    params.payAmount = Number(data.payAmount)
  }

  return request({
    url: '/api/pay/mock/success',
    method: 'post',
    data: params
  }).then(response => {
    if (response.code === 0) {
      return {
        ...response,
        data: normalizeMockPayData(response.data)
      }
    }
    return response
  }).catch(error => {
    const errorCodeMap = {
      40925: '支付金额与订单应付金额不一致',
      40931: '自提点不可用或不属于当前商家'
    }
    if (errorCodeMap[error?.code]) {
      console.error(`模拟支付错误[${error.code}]:`, errorCodeMap[error.code])
    }
    throw error
  })
}

// ============ 模拟支付失败 ============

// POST /api/pay/mock/fail
// 模拟用户取消支付或支付失败场景
export const mockPayFailApi = (data) => {
  if (!data?.orderId) {
    return Promise.reject(new Error('订单ID不能为空'))
  }

  return request({
    url: '/api/pay/mock/fail',
    method: 'post',
    data: {
      orderId: Number(data.orderId),
      failReason: data.failReason || '用户主动取消支付'
    }
  }).then(response => {
    if (response.code === 0) {
      return {
        ...response,
        data: normalizeMockPayData(response.data)
      }
    }
    return response
  }).catch(error => {
    console.error('模拟支付失败:', error?.message || error)
    throw error
  })
}

const normalizeMockPayData = (data) => {
  if (!data) return null

  return {
    orderId: data.orderId || null,
    orderSn: data.orderSn || '',
    paymentId: data.paymentId || null,
    paySn: data.paySn || '',
    payStatus: data.payStatus || '',
    orderStatus: data.orderStatus || '',
    payAmount: Number(data.payAmount) || 0,
    payTime: data.payTime || '',
    failReason: data.failReason || '',
    // 配送方式：1-配送，2-自提
    deliveryType: Number(data.deliveryType) || 1,
    // 自提点ID（配送订单为 null）
    pickupPointId: data.pickupPointId || null,
    // 六位自提码（仅自提订单返回，配送订单为 null）
    pickupCode: data.pickupCode || ''
  }
}

// ============ 支付流水详情 ============

// GET /api/pay/payments/{paymentId}
// 查询指定支付流水详情
export const getPaymentDetailApi = (paymentId) => {
  if (!paymentId) {
    return Promise.reject(new Error('支付流水ID不能为空'))
  }

  return request({
    url: `/api/pay/payments/${paymentId}`,
    method: 'get'
  }).then(response => {
    if (response.code === 0) {
      return {
        ...response,
        data: normalizePaymentDetailData(response.data)
      }
    }
    return response
  }).catch(error => {
    console.error('查询支付流水失败:', error?.message || error)
    throw error
  })
}

const normalizePaymentDetailData = (data) => {
  if (!data) return null

  return {
    paymentId: data.paymentId || null,
    orderId: data.orderId || null,
    orderSn: data.orderSn || '',
    paySn: data.paySn || '',
    thirdTradeNo: data.thirdTradeNo || '',
    payPlatform: data.payPlatform || '',
    amount: Number(data.amount) || 0,
    status: data.status || '',
    payTime: data.payTime || '',
    callbackTime: data.callbackTime || ''
  }
}
