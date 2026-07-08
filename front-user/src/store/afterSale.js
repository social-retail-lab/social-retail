import { defineStore } from 'pinia'
import { ref } from 'vue'
import {
  submitAfterSaleApi,
  getAfterSaleListApi,
  getAfterSaleDetailApi,
  cancelAfterSaleApi,
  uploadAfterSaleImagesApi
} from '@/api/afterSale'

/**
 * 售后 Store
 * 只负责调用 API 和维护全局状态,不处理 toast/loading/页面跳转
 */
export const useAfterSaleStore = defineStore('afterSale', () => {
  // ============ State ============
  const afterSaleList = ref([])         // 售后列表
  const afterSaleDetail = ref(null)     // 售后详情
  const totalCount = ref(0)             // 总数
  const currentPage = ref(1)            // 当前页
  const totalPages = ref(0)             // 总页数
  const pageSize = ref(10)              // 每页数量

  // ============ Actions ============

  /**
   * 3.4.1 提交售后申请
   */
  const submitAfterSale = async (data) => {
    const res = await submitAfterSaleApi(data)
    return res
  }

  /**
   * 3.4.2 查询售后列表
   */
  const fetchAfterSaleList = async (params) => {
    const res = await getAfterSaleListApi(params)
    if (res.code === 0 && res.data) {
      // 第一页覆盖,后续页追加
      const isRefresh = !params.page || Number(params.page) === 1
      if (isRefresh) {
        afterSaleList.value = res.data.list
      } else {
        afterSaleList.value = [...afterSaleList.value, ...res.data.list]
      }
      totalCount.value = res.data.total
      totalPages.value = res.data.pages
      currentPage.value = res.data.page
      pageSize.value = res.data.pageSize
      return res.data
    }
    return { list: [], total: 0, pages: 0, page: 1, pageSize: 10 }
  }

  /**
   * 3.4.3 查询售后详情
   */
  const fetchAfterSaleDetail = async (afterSaleId) => {
    const res = await getAfterSaleDetailApi(afterSaleId)
    if (res.code === 0 && res.data) {
      afterSaleDetail.value = res.data
      return res.data
    }
    return null
  }

  /**
   * 3.4.4 取消售后
   */
  const cancelAfterSale = async (afterSaleId, data) => {
    const res = await cancelAfterSaleApi(afterSaleId, data)
    return res
  }

  /**
   * 3.4.5 上传售后凭证
   */
  const uploadAfterSaleImages = async (afterSaleId, imageUrls) => {
    const res = await uploadAfterSaleImagesApi(afterSaleId, imageUrls)
    return res
  }

  /**
   * 重置售后数据
   */
  const resetAfterSaleData = () => {
    afterSaleList.value = []
    afterSaleDetail.value = null
    totalCount.value = 0
    currentPage.value = 1
    totalPages.value = 0
  }

  return {
    afterSaleList,
    afterSaleDetail,
    totalCount,
    currentPage,
    totalPages,
    pageSize,
    submitAfterSale,
    fetchAfterSaleList,
    fetchAfterSaleDetail,
    cancelAfterSale,
    uploadAfterSaleImages,
    resetAfterSaleData
  }
})
