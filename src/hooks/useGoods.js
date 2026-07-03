import { ref } from 'vue'
import { useGoodsStore } from '@/store/goods'
import { showToast, getValidImageUrl } from '@/utils/common'

const transformProductItem = (item) => ({
  id: item.productId,
  goodsId: item.productId,
  name: item.productName,
  image: getValidImageUrl(item.productImage),
  price: item.price,
  originalPrice: item.originalPrice,
  soldCount: item.soldCount,
  stock: item.stock,
  tags: item.tags || [],
  merchantId: item.merchantId,
  merchantName: item.merchantName,
  productId: item.productId,
  productName: item.productName,
  productImage: getValidImageUrl(item.productImage)
})

export const useGoods = () => {
  const goodsStore = useGoodsStore()
  const loading = ref(false)
  const detailLoading = ref(false)
  const searchLoading = ref(false)

  const loadProductList = async (params = {}) => {
    loading.value = true
    
    try {
      const res = await goodsStore.fetchProductList(params)
      if (res) {
        return {
          list: res.list.map(transformProductItem),
          total: res.total,
          pages: res.pages,
          page: res.page,
          pageSize: res.pageSize
        }
      }
      return { list: [], total: 0, pages: 0, page: 1, pageSize: 10 }
    } catch (error) {
      console.error('获取商品列表失败:', error)
      showToast('获取商品列表失败')
      return { list: [], total: 0, pages: 0, page: 1, pageSize: 10 }
    } finally {
      loading.value = false
    }
  }

  const loadSearchProducts = async (params = {}) => {
    if (!params?.keyword) {
      showToast('请输入搜索关键词')
      return { list: [], total: 0, pages: 0, page: 1, pageSize: 10 }
    }
    
    searchLoading.value = true
    
    try {
      const res = await goodsStore.fetchSearchProducts(params)
      if (res) {
        return {
          list: res.list.map(transformProductItem),
          total: res.total,
          pages: res.pages,
          page: res.page,
          pageSize: res.pageSize
        }
      }
      return { list: [], total: 0, pages: 0, page: 1, pageSize: 10 }
    } catch (error) {
      console.error('搜索商品失败:', error)
      showToast(error?.message || '搜索失败')
      return { list: [], total: 0, pages: 0, page: 1, pageSize: 10 }
    } finally {
      searchLoading.value = false
    }
  }

  const loadProductDetail = async (productId) => {
    if (!productId) {
      showToast('商品ID不能为空')
      return null
    }
    
    detailLoading.value = true
    
    try {
      const res = await goodsStore.fetchProductDetail(productId)
      if (res) {
        return {
          productId: res.productId,
          productName: res.productName,
          productImage: getValidImageUrl(res.productImage),
          bannerImages: res.bannerImages?.map(getValidImageUrl) || [],
          detailImages: res.detailImages?.map(getValidImageUrl) || [],
          description: res.description,
          categoryId: res.categoryId,
          categoryName: res.categoryName,
          brandId: res.brandId,
          brandName: res.brandName,
          price: res.price,
          originalPrice: res.originalPrice,
          soldCount: res.soldCount,
          stock: res.stock,
          status: res.status,
          tags: res.tags || [],
          merchantInfo: res.merchantInfo ? {
            merchantId: res.merchantInfo.merchantId,
            merchantName: res.merchantInfo.merchantName,
            merchantLogo: getValidImageUrl(res.merchantInfo.merchantLogo)
          } : null,
          skuList: res.skuList || []
        }
      }
      return null
    } catch (error) {
      console.error('获取商品详情失败:', error)
      
      const errorCodeMap = {
        40402: '商品不存在或已下架'
      }
      
      if (errorCodeMap[error?.code]) {
        showToast(errorCodeMap[error.code])
      } else if (error?.message) {
        showToast(error.message)
      } else {
        showToast('获取商品详情失败')
      }
      
      return null
    } finally {
      detailLoading.value = false
    }
  }

  const loadProductSkus = async (productId) => {
    if (!productId) {
      showToast('商品ID不能为空')
      return null
    }
    
    try {
      const res = await goodsStore.fetchProductSkus(productId)
      if (res) {
        return {
          productId: res.productId,
          skuList: res.skuList.map(item => ({
            skuId: item.skuId,
            skuName: item.skuName,
            specs: item.specs,
            price: item.price,
            originalPrice: item.originalPrice,
            stock: item.stock,
            lockedStock: item.lockedStock,
            status: item.status
          }))
        }
      }
      return null
    } catch (error) {
      console.error('获取SKU列表失败:', error)
      
      const errorCodeMap = {
        40402: '商品不存在或已下架'
      }
      
      if (errorCodeMap[error?.code]) {
        showToast(errorCodeMap[error.code])
      } else if (error?.message) {
        showToast(error.message)
      } else {
        showToast('获取SKU列表失败')
      }
      
      return null
    }
  }

  const loadCategoryTree = async () => {
    try {
      const res = await goodsStore.fetchCategoryTree()
      return res || []
    } catch (error) {
      console.error('获取分类树失败:', error)
      showToast('获取分类数据失败')
      return []
    }
  }

  const loadCategoryProducts = async (categoryId, params = {}) => {
    if (!categoryId) {
      showToast('分类ID不能为空')
      return { list: [], total: 0, pages: 0, page: 1, pageSize: 10 }
    }
    
    loading.value = true
    
    try {
      const res = await goodsStore.fetchCategoryProducts(categoryId, params)
      if (res) {
        return {
          categoryId: res.categoryId,
          categoryName: res.categoryName,
          list: res.list.map(transformProductItem),
          total: res.total,
          pages: res.pages,
          page: res.page,
          pageSize: res.pageSize
        }
      }
      return { list: [], total: 0, pages: 0, page: 1, pageSize: 10 }
    } catch (error) {
      console.error('获取分类商品失败:', error)
      
      const errorCodeMap = {
        40403: '分类不存在'
      }
      
      if (errorCodeMap[error?.code]) {
        showToast(errorCodeMap[error.code])
      } else if (error?.message) {
        showToast(error.message)
      } else {
        showToast('获取分类商品失败')
      }
      
      return { list: [], total: 0, pages: 0, page: 1, pageSize: 10 }
    } finally {
      loading.value = false
    }
  }

  const loadBrandList = async (params = {}) => {
    try {
      const res = await goodsStore.fetchBrandList(params)
      if (res) {
        return {
          list: res.list.map(item => ({
            brandId: item.brandId,
            brandName: item.brandName,
            logo: getValidImageUrl(item.logo),
            description: item.description,
            sort: item.sort
          })),
          total: res.total,
          pages: res.pages,
          page: res.page,
          pageSize: res.pageSize
        }
      }
      return { list: [], total: 0, pages: 0, page: 1, pageSize: 20 }
    } catch (error) {
      console.error('获取品牌列表失败:', error)
      showToast('获取品牌列表失败')
      return { list: [], total: 0, pages: 0, page: 1, pageSize: 20 }
    }
  }

  const loadBrandProducts = async (brandId, params = {}) => {
    if (!brandId) {
      showToast('品牌ID不能为空')
      return { list: [], total: 0, pages: 0, page: 1, pageSize: 10 }
    }
    
    loading.value = true
    
    try {
      const res = await goodsStore.fetchBrandProducts(brandId, params)
      if (res) {
        return {
          brandId: res.brandId,
          brandName: res.brandName,
          list: res.list.map(transformProductItem),
          total: res.total,
          pages: res.pages,
          page: res.page,
          pageSize: res.pageSize
        }
      }
      return { list: [], total: 0, pages: 0, page: 1, pageSize: 10 }
    } catch (error) {
      console.error('获取品牌商品失败:', error)
      
      const errorCodeMap = {
        40404: '品牌不存在'
      }
      
      if (errorCodeMap[error?.code]) {
        showToast(errorCodeMap[error.code])
      } else if (error?.message) {
        showToast(error.message)
      } else {
        showToast('获取品牌商品失败')
      }
      
      return { list: [], total: 0, pages: 0, page: 1, pageSize: 10 }
    } finally {
      loading.value = false
    }
  }

  return {
    loading,
    detailLoading,
    searchLoading,
    loadProductList,
    loadSearchProducts,
    loadProductDetail,
    loadProductSkus,
    loadCategoryTree,
    loadCategoryProducts,
    loadBrandList,
    loadBrandProducts
  }
}