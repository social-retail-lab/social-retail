// 商品评价状态管理（Pinia）
// 缓存：我的评价列表、商品评价列表、当前评价详情

import { defineStore } from 'pinia'
import { ref } from 'vue'
import {
  postCommentApi,
  getMyCommentsApi,
  getProductCommentsApi,
  getCommentDetailApi,
  deleteCommentApi
} from '@/api/comment'
import { COMMENT_ERROR_CODE } from '@/constants/comment'

export const useCommentStore = defineStore('comment', () => {
  // ============ 我的评价列表 ============
  const myComments = ref([])
  const myCommentsTotal = ref(0)
  const myCommentsPage = ref(1)
  const myCommentsPages = ref(0)
  const myCommentsLoading = ref(false)

  // ============ 商品评价列表 ============
  const productComments = ref([])
  const productCommentsTotal = ref(0)
  const productCommentsPage = ref(1)
  const productCommentsPages = ref(0)
  const productCommentsLoading = ref(false)
  const productCommentsScoreFilter = ref(0) // 0 全部 / 5 / 4 / 3

  // ============ 评价详情 ============
  const currentComment = ref(null)
  const commentDetailLoading = ref(false)

  // ============ 发布评价 ============
  const postLoading = ref(false)

  // ============ Actions ============

  // 3.5.1 发布评价
  const postComment = async (data) => {
    postLoading.value = true
    try {
      const res = await postCommentApi(data)
      return res
    } catch (error) {
      console.error('发布评价失败:', error)
      throw error
    } finally {
      postLoading.value = false
    }
  }

  // 3.5.2 我的评价列表
  const fetchMyComments = async (params = {}, isLoadMore = false) => {
    myCommentsLoading.value = true
    try {
      const page = isLoadMore ? myCommentsPage.value + 1 : 1
      const reqParams = {
        page,
        pageSize: 10,
        ...params
      }
      const res = await getMyCommentsApi(reqParams)
      if (res?.data?.list) {
        if (isLoadMore) {
          myComments.value = [...myComments.value, ...res.data.list]
        } else {
          myComments.value = res.data.list
        }
        myCommentsTotal.value = res.data.total || 0
        myCommentsPage.value = res.data.page || page
        myCommentsPages.value = res.data.pages || 0
      }
      return res
    } catch (error) {
      console.error('查询我的评价失败:', error)
      throw error
    } finally {
      myCommentsLoading.value = false
    }
  }

  // 3.5.3 商品评价列表
  const fetchProductComments = async (productId, params = {}, isLoadMore = false) => {
    productCommentsLoading.value = true
    try {
      const page = isLoadMore ? productCommentsPage.value + 1 : 1
      const reqParams = {
        page,
        pageSize: 10,
        score: productCommentsScoreFilter.value || undefined,
        ...params
      }
      const res = await getProductCommentsApi(productId, reqParams)
      if (res?.data?.list) {
        if (isLoadMore) {
          productComments.value = [...productComments.value, ...res.data.list]
        } else {
          productComments.value = res.data.list
        }
        productCommentsTotal.value = res.data.total || 0
        productCommentsPage.value = res.data.page || page
        productCommentsPages.value = res.data.pages || 0
      }
      return res
    } catch (error) {
      console.error('查询商品评价失败:', error)
      throw error
    } finally {
      productCommentsLoading.value = false
    }
  }

  // 设置评分筛选
  const setScoreFilter = (score) => {
    productCommentsScoreFilter.value = score
  }

  // 3.5.4 评价详情
  const fetchCommentDetail = async (commentId) => {
    commentDetailLoading.value = true
    try {
      const res = await getCommentDetailApi(commentId)
      if (res?.data) {
        currentComment.value = res.data
      }
      return res
    } catch (error) {
      if (error?.code === COMMENT_ERROR_CODE.COMMENT_NOT_FOUND) {
        currentComment.value = null
      }
      console.error('查询评价详情失败:', error)
      throw error
    } finally {
      commentDetailLoading.value = false
    }
  }

  // 3.5.5 删除评价
  const removeComment = async (commentId) => {
    try {
      const res = await deleteCommentApi(commentId)
      // 从本地列表中移除
      myComments.value = myComments.value.filter(item => item.commentId !== commentId)
      myCommentsTotal.value = Math.max(0, myCommentsTotal.value - 1)
      return res
    } catch (error) {
      console.error('删除评价失败:', error)
      throw error
    }
  }

  // 重置商品评价列表（切换商品时调用）
  const resetProductComments = () => {
    productComments.value = []
    productCommentsTotal.value = 0
    productCommentsPage.value = 1
    productCommentsPages.value = 0
    productCommentsScoreFilter.value = 0
  }

  // 重置所有数据
  const resetAllData = () => {
    myComments.value = []
    myCommentsTotal.value = 0
    myCommentsPage.value = 1
    myCommentsPages.value = 0
    resetProductComments()
    currentComment.value = null
  }

  return {
    // state
    myComments,
    myCommentsTotal,
    myCommentsPage,
    myCommentsPages,
    myCommentsLoading,
    productComments,
    productCommentsTotal,
    productCommentsPage,
    productCommentsPages,
    productCommentsLoading,
    productCommentsScoreFilter,
    currentComment,
    commentDetailLoading,
    postLoading,
    // actions
    postComment,
    fetchMyComments,
    fetchProductComments,
    setScoreFilter,
    fetchCommentDetail,
    removeComment,
    resetProductComments,
    resetAllData
  }
})
