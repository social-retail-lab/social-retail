import request from './base'

export const getProductListApi = (params = {}) => {
  const validatedParams = validateProductListParams(params)
  
  return request({
    url: '/api/products',
    method: 'get',
    params: validatedParams
  }).then(response => {
    if (response.code === 0) {
      return {
        ...response,
        data: normalizeProductListData(response.data)
      }
    }
    return response
  }).catch(error => {
    console.error('获取商品列表失败:', error)
    throw error
  })
}

const validateProductListParams = (params) => {
  return {
    page: Number(params?.page) || 1,
    pageSize: Number(params?.pageSize) || 10,
    categoryId: params?.categoryId || null,
    brandId: params?.brandId || null,
    minPrice: params?.minPrice || null,
    maxPrice: params?.maxPrice || null,
    sortField: params?.sortField || null,
    sortOrder: params?.sortOrder || null
  }
}

const normalizeProductListData = (data) => {
  if (!data) return { list: [], total: 0, pages: 0, page: 1, pageSize: 10 }
  
  return {
    list: Array.isArray(data.list) ? data.list.map(normalizeProductItem) : [],
    total: Number(data.total) || 0,
    pages: Number(data.pages) || 0,
    page: Number(data.page) || 1,
    pageSize: Number(data.pageSize) || 10
  }
}

const normalizeProductItem = (item) => {
  return {
    productId: item.productId || null,
    productName: item.title || item.productName || '',
    productImage: item.mainImage || item.productImage || '',
    price: Number(item.price) || 0,
    originalPrice: Number(item.originalPrice) || 0,
    soldCount: Number(item.sales) || Number(item.soldCount) || 0,
    stock: item.stock !== undefined && item.stock !== null ? Number(item.stock) : undefined,
    tags: Array.isArray(item.tags) ? item.tags : [],
    merchantId: item.merchantId || null,
    merchantName: item.merchantName || '',
    promotionTitle: item.promotionTitle || ''
  }
}

export const searchProductsApi = (params = {}) => {
  if (!params?.keyword) {
    return Promise.reject(new Error('请输入搜索关键词'))
  }

  const validatedParams = {
    ...validateProductListParams(params),
    keyword: params.keyword
  }

  return request({
    url: '/api/products/search',
    method: 'get',
    params: validatedParams
  }).then(response => {
    if (response.code === 0) {
      return {
        ...response,
        data: normalizeProductListData(response.data)
      }
    }
    return response
  }).catch(error => {
    console.error('搜索商品失败:', error)
    throw error
  })
}

export const getProductDetailApi = (productId) => {
  if (!productId) {
    return Promise.reject(new Error('商品ID不能为空'))
  }
  
  return request({
    url: `/api/products/${productId}`,
    method: 'get'
  }).then(response => {
    if (response.code === 0) {
      return {
        ...response,
        data: response.data ? normalizeProductDetailData(response.data) : null
      }
    }
    return response
  }).catch(error => {
    const errorCodeMap = {
      40402: '商品不存在或已下架'
    }
    if (errorCodeMap[error?.code]) {
      console.error(`获取商品详情错误[${error.code}]:`, errorCodeMap[error.code])
    }
    throw error
  })
}

const normalizeProductDetailData = (data) => {
  return {
    productId: data.productId || null,
    productName: data.productName || '',
    productImage: data.productImage || '',
    bannerImages: Array.isArray(data.bannerImages) ? data.bannerImages : [],
    detailImages: Array.isArray(data.detailImages) ? data.detailImages : [],
    description: data.description || '',
    categoryId: data.categoryId || null,
    categoryName: data.categoryName || '',
    brandId: data.brandId || null,
    brandName: data.brandName || '',
    price: Number(data.price) || 0,
    originalPrice: Number(data.originalPrice) || 0,
    soldCount: Number(data.soldCount) || 0,
    stock: Number(data.stock) || 0,
    status: data.status || '',
    tags: Array.isArray(data.tags) ? data.tags : [],
    merchantInfo: data.merchantInfo ? {
      merchantId: data.merchantInfo.merchantId || null,
      merchantName: data.merchantInfo.merchantName || '',
      merchantLogo: data.merchantInfo.merchantLogo || ''
    } : null,
    skuList: Array.isArray(data.skuList) ? data.skuList.map(sku => ({
      skuId: sku.skuId || null,
      skuName: sku.skuName || sku.specs?.规格 || sku.spec?.规格 || '',
      specs: sku.specs || sku.spec || {},
      price: Number(sku.price) || 0,
      originalPrice: Number(sku.originalPrice) || Number(sku.price) || 0,
      stock: Number(sku.stock) || 0,
      lockedStock: Number(sku.lockedStock) || 0,
      status: sku.status || 'ON_SALE'
    })) : []
  }
}

export const getProductSkusApi = (productId) => {
  if (!productId) {
    return Promise.reject(new Error('商品ID不能为空'))
  }
  
  return request({
    url: `/api/products/${productId}/skus`,
    method: 'get'
  }).then(response => {
    if (response.code === 0) {
      return {
        ...response,
        data: response.data ? normalizeProductSkusData(response.data) : null
      }
    }
    return response
  }).catch(error => {
    const errorCodeMap = {
      40402: '商品不存在或已下架'
    }
    if (errorCodeMap[error?.code]) {
      console.error(`获取SKU列表错误[${error.code}]:`, errorCodeMap[error.code])
    }
    throw error
  })
}

const normalizeProductSkusData = (data) => {
  return {
    productId: data.productId || null,
    skuList: Array.isArray(data.skuList) ? data.skuList.map(item => ({
      skuId: item.skuId || null,
      skuName: item.skuName || '',
      specs: item.specs || {},
      price: Number(item.price) || 0,
      originalPrice: Number(item.originalPrice) || 0,
      stock: Number(item.stock) || 0,
      lockedStock: Number(item.lockedStock) || 0,
      status: item.status || ''
    })) : []
  }
}

export const getCategoryTreeApi = () => {
  return request({
    url: '/api/categories/tree',
    method: 'get'
  }).then(response => {
    if (response.code === 0) {
      return {
        ...response,
        data: response.data ? normalizeCategoryTreeData(response.data) : null
      }
    }
    return response
  }).catch(error => {
    console.error('获取分类树失败:', error)
    throw error
  })
}

const normalizeCategoryTreeData = (data) => {
  const normalizeCategory = (item) => ({
    categoryId: item.categoryId || null,
    categoryName: item.categoryName || '',
    parentId: item.parentId || 0,
    level: Number(item.level) || 1,
    sort: Number(item.sort) || 0,
    children: Array.isArray(item.children) ? item.children.map(normalizeCategory) : []
  })
  
  return {
    list: Array.isArray(data.list) ? data.list.map(normalizeCategory) : []
  }
}

export const getCategoryProductsApi = (categoryId, params = {}) => {
  if (!categoryId) {
    return Promise.reject(new Error('分类ID不能为空'))
  }
  
  const validatedParams = validateProductListParams(params)
  
  return request({
    url: `/api/categories/${categoryId}/products`,
    method: 'get',
    params: validatedParams
  }).then(response => {
    if (response.code === 0) {
      return {
        ...response,
        data: response.data ? normalizeCategoryProductsData(response.data) : null
      }
    }
    return response
  }).catch(error => {
    const errorCodeMap = {
      40403: '分类不存在'
    }
    if (errorCodeMap[error?.code]) {
      console.error(`获取分类商品错误[${error.code}]:`, errorCodeMap[error.code])
    }
    throw error
  })
}

const normalizeCategoryProductsData = (data) => {
  return {
    categoryId: data.categoryId || null,
    categoryName: data.categoryName || '',
    list: Array.isArray(data.list) ? data.list.map(normalizeProductItem) : [],
    total: Number(data.total) || 0,
    pages: Number(data.pages) || 0,
    page: Number(data.page) || 1,
    pageSize: Number(data.pageSize) || 10
  }
}

export const getBrandListApi = (params = {}) => {
  const validatedParams = {
    categoryId: params?.categoryId || null,
    keyword: params?.keyword || null,
    page: Number(params?.page) || 1,
    pageSize: Number(params?.pageSize) || 20
  }

  return request({
    url: '/api/brands',
    method: 'get',
    params: validatedParams
  }).then(response => {
    if (response.code === 0) {
      return {
        ...response,
        data: normalizeBrandListData(response.data)
      }
    }
    return response
  }).catch(error => {
    console.error('获取品牌列表失败:', error)
    throw error
  })
}

const normalizeBrandListData = (data) => {
  if (!data) return { list: [], total: 0, pages: 0, page: 1, pageSize: 20 }
  
  return {
    list: Array.isArray(data.list) ? data.list.map(item => ({
      brandId: item.brandId || null,
      brandName: item.brandName || '',
      logo: item.logo || '',
      description: item.description || '',
      sort: Number(item.sort) || 0
    })) : [],
    total: Number(data.total) || 0,
    pages: Number(data.pages) || 0,
    page: Number(data.page) || 1,
    pageSize: Number(data.pageSize) || 20
  }
}

export const getBrandProductsApi = (brandId, params = {}) => {
  if (!brandId) {
    return Promise.reject(new Error('品牌ID不能为空'))
  }
  
  const validatedParams = validateProductListParams(params)
  
  return request({
    url: `/api/brands/${brandId}/products`,
    method: 'get',
    params: validatedParams
  }).then(response => {
    if (response.code === 0) {
      return {
        ...response,
        data: response.data ? normalizeBrandProductsData(response.data) : null
      }
    }
    return response
  }).catch(error => {
    const errorCodeMap = {
      40404: '品牌不存在'
    }
    if (errorCodeMap[error?.code]) {
      console.error(`获取品牌商品错误[${error.code}]:`, errorCodeMap[error.code])
    }
    throw error
  })
}

const normalizeBrandProductsData = (data) => {
  return {
    brandId: data.brandId || null,
    brandName: data.brandName || '',
    list: Array.isArray(data.list) ? data.list.map(normalizeProductItem) : [],
    total: Number(data.total) || 0,
    pages: Number(data.pages) || 0,
    page: Number(data.page) || 1,
    pageSize: Number(data.pageSize) || 10
  }
}