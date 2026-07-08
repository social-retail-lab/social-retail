import { defineStore } from 'pinia'
import { ref } from 'vue'
import { getProductListApi, searchProductsApi, getProductDetailApi, getProductSkusApi, getCategoryTreeApi, getCategoryProductsApi, getBrandListApi, getBrandProductsApi } from '@/api/goods'

export const useGoodsStore = defineStore('goods', () => {
  const productList = ref([])
  const productDetail = ref(null)
  const productSkus = ref([])
  const categoryTree = ref([])
  const brandList = ref([])

  const fetchProductList = async (params = {}) => {
    const res = await getProductListApi(params)
    if (res.code === 0 && res.data) {
      productList.value = res.data.list
      return res.data
    }
    return { list: [], total: 0, pages: 0, page: 1, pageSize: 10 }
  }

  const fetchSearchProducts = async (params = {}) => {
    const res = await searchProductsApi(params)
    if (res.code === 0 && res.data) {
      productList.value = res.data.list
      return res.data
    }
    return { list: [], total: 0, pages: 0, page: 1, pageSize: 10 }
  }

  const fetchProductDetail = async (productId, promotionCode = null) => {
    const res = await getProductDetailApi(productId, promotionCode)
    if (res.code === 0 && res.data) {
      productDetail.value = res.data
      return res.data
    }
    return null
  }

  const fetchProductSkus = async (productId) => {
    const res = await getProductSkusApi(productId)
    if (res.code === 0 && res.data) {
      productSkus.value = res.data.skuList
      return res.data
    }
    return null
  }

  const fetchCategoryTree = async () => {
    const res = await getCategoryTreeApi()
    if (res.code === 0 && res.data) {
      categoryTree.value = res.data.list
      return res.data.list
    }
    return []
  }

  const fetchCategoryProducts = async (categoryId, params = {}) => {
    const res = await getCategoryProductsApi(categoryId, params)
    if (res.code === 0 && res.data) {
      productList.value = res.data.list
      return res.data
    }
    return { list: [], total: 0, pages: 0, page: 1, pageSize: 10 }
  }

  const fetchBrandList = async (params = {}) => {
    const res = await getBrandListApi(params)
    if (res.code === 0 && res.data) {
      brandList.value = res.data.list
      return res.data
    }
    return { list: [], total: 0, pages: 0, page: 1, pageSize: 20 }
  }

  const fetchBrandProducts = async (brandId, params = {}) => {
    const res = await getBrandProductsApi(brandId, params)
    if (res.code === 0 && res.data) {
      productList.value = res.data.list
      return res.data
    }
    return { list: [], total: 0, pages: 0, page: 1, pageSize: 10 }
  }

  return {
    productList,
    productDetail,
    productSkus,
    categoryTree,
    brandList,
    fetchProductList,
    fetchSearchProducts,
    fetchProductDetail,
    fetchProductSkus,
    fetchCategoryTree,
    fetchCategoryProducts,
    fetchBrandList,
    fetchBrandProducts
  }
})