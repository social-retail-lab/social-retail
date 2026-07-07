// 商品评价接口模块
// 包含：发布评价(3.5.1)、我的评价列表(3.5.2)、商品评价列表(3.5.3)、评价详情(3.5.4)、删除评价(3.5.5)

import { http } from './base'

// ============ 3.5.1 发布评价 ============
// POST /api/comments
// data: { orderId, orderItemId, productId, skuId, score, content, imageUrls, anonymous }
export const postCommentApi = (data) => {
  return http.post('/api/comments', data)
}

// ============ 3.5.2 我的评价列表 ============
// GET /api/comments/my
// params: { page, pageSize }
export const getMyCommentsApi = (params) => {
  return http.get('/api/comments/my', params)
}

// ============ 3.5.3 商品评价列表 ============
// GET /api/products/{productId}/comments
// params: { score, page, pageSize }
export const getProductCommentsApi = (productId, params) => {
  return http.get(`/api/products/${productId}/comments`, params)
}

// ============ 3.5.4 评价详情 ============
// GET /api/comments/{commentId}
export const getCommentDetailApi = (commentId) => {
  return http.get(`/api/comments/${commentId}`)
}

// ============ 3.5.5 删除评价 ============
// DELETE /api/comments/{commentId}
export const deleteCommentApi = (commentId) => {
  return http.delete(`/api/comments/${commentId}`)
}

export default {
  postCommentApi,
  getMyCommentsApi,
  getProductCommentsApi,
  getCommentDetailApi,
  deleteCommentApi
}
