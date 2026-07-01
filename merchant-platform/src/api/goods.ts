import request from '@/utils/request'

// 商品列表
export const getGoodsList = (params: { status?: string; auditStatus?: string; pageNum?: number; pageSize?: number; keyword?: string; categoryId?: number }) => {
  return request.get('/merchant/products', { params })
}

// 商品详情
export const getGoodsDetail = (productId: number) => {
  return request.get(`/merchant/products/${productId}`)
}

// 发布商品 - 匹配后端 MerchantGoodsController
export const createGoods = (data: {
  title: string
  subTitle?: string
  categoryId1: number
  categoryId2?: number
  brandId?: number
  brandName?: string
  mainImage: string
  detailImages?: string[]
  detailDesc?: string
  saleType?: number
  skus: { specs: string; price: number; stock: number; skuCode?: string }[]
}) => {
  return request.post('/merchant/products', data)
}

// 编辑商品
export const updateGoods = (productId: number, data: {
  title?: string
  subTitle?: string
  categoryId1?: number
  categoryId2?: number
  brandId?: number
  brandName?: string
  mainImage?: string
  detailImages?: string[]
  detailDesc?: string
  saleType?: number
  skus?: { id?: number; specs: string; price: number; stock: number; skuCode?: string }[]
}) => {
  return request.put(`/merchant/products/${productId}`, data)
}

// 上下架
export const updateGoodsStatus = (productId: number, status: number) => {
  return request.patch(`/merchant/products/${productId}/status`, { status })
}

// 分类列表
export const getCategories = (parentId?: number) => {
  const params: any = {}
  if (parentId != null) params.parentId = parentId
  return request.get('/merchant/categories', { params })
}

// 图片上传
export const uploadImage = (file: File, folder = 'product') => {
  const form = new FormData()
  form.append('file', file)
  return request.post('/merchant/upload/image', form, {
    params: { folder }
  })
}
