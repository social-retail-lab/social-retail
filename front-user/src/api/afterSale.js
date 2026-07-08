// 售后接口模块
// 包含：提交售后申请、查询售后列表、查询售后详情、取消售后、上传凭证

import request from './base'

// ============ 通用文件上传接口 ============

// 通用文件上传 POST /api/upload
// 返回图片URL，用于售后凭证图片
export const uploadFileApi = (filePath) => {
  return new Promise((resolve, reject) => {
    const token = uni.getStorageSync('token')
    
    uni.uploadFile({
      url: `${process.env.NODE_ENV === 'development' ? '' : 'http://172.20.10.11:8081'}/api/upload`,
      filePath,
      name: 'file',
      header: {
        'Authorization': token ? `Bearer ${token}` : ''
      },
      success: (res) => {
        try {
          const data = JSON.parse(res.data)
          if (data.code === 0) {
            resolve(data.data)
          } else {
            reject(data)
          }
        } catch (e) {
          reject({ message: '上传失败，响应格式错误' })
        }
      },
      fail: (err) => {
        reject(err)
      }
    })
  })
}

// ============ 提交售后申请 ============

// POST /api/after-sales
// 用户发起仅退款/退货退款售后工单
export const submitAfterSaleApi = (data) => {
  const validated = validateSubmitAfterSaleParams(data)
  
  return request({
    url: '/api/after-sales',
    method: 'post',
    data: validated
  }).then(response => {
    if (response.code === 0) {
      return {
        ...response,
        data: normalizeAfterSaleData(response.data)
      }
    }
    return response
  }).catch(error => {
    handleSubmitAfterSaleError(error)
    throw error
  })
}

const validateSubmitAfterSaleParams = (data) => {
  // orderId 必填(接口文档 3.4.1 要求)
  if (!data?.orderId) {
    throw new Error('订单ID不能为空')
  }

  if (!data?.orderItemId) {
    throw new Error('订单商品ID不能为空')
  }

  if (!data?.type || !['REFUND_ONLY', 'RETURN_REFUND'].includes(data.type)) {
    throw new Error('请选择售后类型')
  }

  const refundAmount = Number(data?.refundAmount)
  if (!refundAmount || refundAmount <= 0) {
    throw new Error('退款金额必须大于0')
  }

  if (!data?.reason) {
    throw new Error('请选择售后原因')
  }

  const params = {
    orderId: data.orderId,
    orderItemId: data.orderItemId,
    type: data.type,
    refundAmount,
    reason: data.reason
  }

  if (data?.reasonDesc) {
    params.reasonDesc = data.reasonDesc
  }

  if (Array.isArray(data?.evidenceImages) && data.evidenceImages.length > 0) {
    params.evidenceImages = data.evidenceImages
  }

  return params
}

// ============ 查询售后列表 ============

// GET /api/after-sales
// 售后列表分页、状态筛选
export const getAfterSaleListApi = (params) => {
  const validated = validateListParams(params)
  
  return request({
    url: '/api/after-sales',
    method: 'get',
    params: validated
  }).then(response => {
    if (response.code === 0) {
      return {
        ...response,
        data: normalizeAfterSaleListData(response.data)
      }
    }
    return response
  }).catch(error => {
    console.error('获取售后列表失败:', error?.message || error)
    throw error
  })
}

const validateListParams = (params) => {
  const validated = {
    page: Number(params?.page) || 1,
    pageSize: Number(params?.pageSize) || 10
  }
  
  if (params?.status && params.status !== 'ALL') {
    validated.status = params.status
  }
  
  return validated
}

const normalizeAfterSaleListData = (data) => {
  if (!data) return { list: [], total: 0, pages: 0, page: 1, pageSize: 10 }
  
  return {
    list: Array.isArray(data.list) ? data.list.map(item => normalizeAfterSaleListItem(item)) : [],
    total: Number(data.total) || 0,
    pages: Number(data.pages) || 0,
    page: Number(data.page) || 1,
    pageSize: Number(data.pageSize) || 10
  }
}

const normalizeAfterSaleListItem = (item) => {
  return {
    afterSaleId: item.afterSaleId || item.id || null,
    afterSaleSn: item.afterSaleSn || item.sn || '',
    status: item.status || '',
    statusText: item.statusText || getStatusText(item.status),
    type: item.type || '',
    typeText: item.typeText || getTypeText(item.type),
    orderId: item.orderId || null,
    orderSn: item.orderSn || '',
    orderItemId: item.orderItemId || null,
    productId: item.productId || null,
    productName: item.productName || '',
    productImage: item.productImage || '',
    skuSpecs: item.skuSpecs || '',
    refundAmount: Number(item.refundAmount || item.amount) || 0,
    reason: item.reason || '',
    applyTime: item.applyTime || item.createTime || '',
    handleTime: item.handleTime || '',
    auditRemark: item.auditRemark || '',
    rejectReason: item.rejectReason || ''
  }
}

// ============ 查询售后详情 ============

// GET /api/after-sales/{afterSaleId}
// 展示售后完整进度、商品、凭证、审核结果
export const getAfterSaleDetailApi = (afterSaleId) => {
  if (!afterSaleId) {
    return Promise.reject(new Error('售后ID不能为空'))
  }
  
  return request({
    url: `/api/after-sales/${afterSaleId}`,
    method: 'get'
  }).then(response => {
    if (response.code === 0) {
      return {
        ...response,
        data: normalizeAfterSaleData(response.data)
      }
    }
    return response
  }).catch(error => {
    const errorCodeMap = {
      40431: '售后不存在'
    }
    if (errorCodeMap[error?.code]) {
      console.error(`售后详情错误[${error.code}]:`, errorCodeMap[error.code])
    }
    throw error
  })
}

// ============ 取消售后 ============

// POST /api/after-sales/{afterSaleId}/cancel
// 申请中状态用户主动取消售后
export const cancelAfterSaleApi = (afterSaleId, data) => {
  if (!afterSaleId) {
    return Promise.reject(new Error('售后ID不能为空'))
  }
  
  return request({
    url: `/api/after-sales/${afterSaleId}/cancel`,
    method: 'post',
    data: { cancelReason: data?.cancelReason || '' }
  }).then(response => {
    if (response.code === 0) {
      return {
        ...response,
        data: response.data ? normalizeAfterSaleData(response.data) : null
      }
    }
    return response
  }).catch(error => {
    const errorCodeMap = {
      40932: '当前状态不允许取消'
    }
    if (errorCodeMap[error?.code]) {
      console.error(`取消售后错误[${error.code}]:`, errorCodeMap[error.code])
    }
    throw error
  })
}

// ============ 补充上传凭证 ============

// POST /api/after-sales/{afterSaleId}/images
// 售后详情页追加举证图片
export const uploadAfterSaleImagesApi = (afterSaleId, imageUrls) => {
  if (!afterSaleId) {
    return Promise.reject(new Error('售后ID不能为空'))
  }
  
  if (!Array.isArray(imageUrls) || imageUrls.length === 0) {
    return Promise.reject(new Error('图片不能为空'))
  }
  
  return request({
    url: `/api/after-sales/${afterSaleId}/images`,
    method: 'post',
    data: { imageUrls }
  }).then(response => {
    if (response.code === 0) {
      return {
        ...response,
        data: response.data ? normalizeAfterSaleData(response.data) : null
      }
    }
    return response
  }).catch(error => {
    console.error('上传凭证失败:', error?.message || error)
    throw error
  })
}

// ============ 数据规范化 ============

const normalizeAfterSaleData = (data) => {
  if (!data) return null
  
  return {
    afterSaleId: data.afterSaleId || data.id || null,
    afterSaleSn: data.afterSaleSn || data.sn || '',
    status: data.status || '',
    statusText: data.statusText || getStatusText(data.status),
    type: data.type || '',
    typeText: data.typeText || getTypeText(data.type),
    orderId: data.orderId || null,
    orderSn: data.orderSn || '',
    orderItemId: data.orderItemId || null,
    productId: data.productId || null,
    productName: data.productName || '',
    productImage: data.productImage || '',
    skuSpecs: data.skuSpecs || '',
    originPrice: Number(data.originPrice) || 0,
    refundAmount: Number(data.refundAmount || data.amount) || 0,
    reason: data.reason || '',
    reasonDesc: data.reasonDesc || '',
    evidenceImages: Array.isArray(data.evidenceImages) ? data.evidenceImages : [],
    applyTime: data.applyTime || data.createTime || '',
    handleTime: data.handleTime || '',
    auditRemark: data.auditRemark || '',
    rejectReason: data.rejectReason || '',
    cancelReason: data.cancelReason || ''
  }
}

// ============ 辅助函数 ============

const getStatusText = (status) => {
  const statusMap = {
    APPLYING: '申请中',
    CANCELLED: '已取消',
    REFUNDED: '已退款'
  }
  return statusMap[status] || status || ''
}

const getTypeText = (type) => {
  const typeMap = {
    REFUND_ONLY: '仅退款',
    RETURN_REFUND: '退货退款'
  }
  return typeMap[type] || type || ''
}

const handleSubmitAfterSaleError = (error) => {
  const errorCodeMap = {
    40931: '当前订单状态不允许申请售后',
    40932: '当前状态不允许取消'
  }
  
  if (errorCodeMap[error?.code]) {
    console.error(`提交售后错误[${error.code}]:`, errorCodeMap[error.code])
  }
}
