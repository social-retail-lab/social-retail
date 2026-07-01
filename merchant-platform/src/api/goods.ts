import request from '@/utils/request'

export const getGoodsList = (params: {
  status?: string
  page?: number
  pageSize?: number
  keyword?: string
  categoryId?: number
}) => {
  return request.get('/merchant/products', { params })
}

export const getGoodsDetail = (productId: number) => {
  return request.get(`/merchant/products/${productId}`)
}

export const createGoods = (data: {
  productName: string
  description?: string
  categoryId: number
  brandId?: number
  price: number
  originalPrice?: number
  stock: number
  productImage: string
  bannerImages?: string[]
  detailImages?: string[]
}) => {
  return request.post('/merchant/products', data)
}

export const updateGoods = (productId: number, data: {
  productName?: string
  description?: string
  categoryId?: number
  brandId?: number
  price?: number
  originalPrice?: number
  stock?: number
  productImage?: string
  bannerImages?: string[]
  detailImages?: string[]
}) => {
  return request.put(`/merchant/products/${productId}`, data)
}

export const deleteGoods = (productId: number) => {
  return request.delete(`/merchant/products/${productId}`)
}

export const updateGoodsStatus = (productId: number, data: { status: string }) => {
  return request.patch(`/merchant/products/${productId}/status`, data)
}