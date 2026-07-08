// 商品评价业务逻辑 Hook
// 封装：发布评价、列表加载、评分筛选、详情查看、删除、图片上传
// 异常处理：
//   40941 不允许评价 → 提示订单状态
//   40441 评价不存在 → 返回上一页
//   40304 无权限删除 → 提示

import { ref } from 'vue'
import { useCommentStore } from '@/store/comment'
import { useUserStore } from '@/store/user'
import { useFile } from '@/hooks/useFile'
import {
  COMMENT_SCORE,
  COMMENT_LIMIT,
  COMMENT_ERROR_CODE,
  SCORE_FILTER_TABS,
  SCORE_TEXT_MAP,
  ANONYMOUS,
  DEFAULT_AVATAR,
  ANONYMOUS_NICKNAME,
  COMMENT_STATUS_MAP
} from '@/constants/comment'
import { UPLOAD_TYPE } from '@/constants/file'

export const useComment = () => {
  const commentStore = useCommentStore()
  const userStore = useUserStore()
  const { chooseImage, uploadImage } = useFile()

  // ============ 发布评价表单 ============
  const formData = ref({
    orderId: null,
    orderItemId: null,
    productId: null,
    skuId: null,
    score: COMMENT_SCORE.FIVE,
    content: '',
    imageUrls: [],
    anonymous: ANONYMOUS.NO
  })

  // 评价图片本地预览路径
  const imagePreviews = ref([])

  // ============ 发布评价 ============
  const submitComment = async () => {
    if (!userStore.isLogin) {
      uni.showToast({ title: '请先登录', icon: 'none' })
      return false
    }

    // 校验评分
    if (!formData.value.score || formData.value.score < COMMENT_LIMIT.MIN_SCORE) {
      uni.showToast({ title: '请选择评分', icon: 'none' })
      return false
    }

    // 防重复提交
    if (commentStore.postLoading) return false

    try {
      await commentStore.postComment({ ...formData.value })
      uni.showToast({ title: '评价发布成功', icon: 'success' })
      return true
    } catch (error) {
      handleCommentError(error)
      return false
    }
  }

  // 评价异常处理
  const handleCommentError = (error) => {
    const code = error?.code
    switch (code) {
      case COMMENT_ERROR_CODE.NOT_ALLOW_COMMENT:
        uni.showToast({ title: error.message || '当前订单状态不允许评价', icon: 'none' })
        break
      case COMMENT_ERROR_CODE.COMMENT_NOT_FOUND:
        uni.showToast({ title: '评价不存在', icon: 'none' })
        setTimeout(() => uni.navigateBack(), 1500)
        break
      case COMMENT_ERROR_CODE.NO_PERMISSION_DELETE:
        uni.showToast({ title: '无权限删除该评价', icon: 'none' })
        break
      default:
        console.error('评价操作失败:', error)
    }
  }

  // ============ 评价图片上传 ============
  const addCommentImage = async () => {
    if (imagePreviews.value.length >= COMMENT_LIMIT.MAX_IMAGES) {
      uni.showToast({ title: `最多上传${COMMENT_LIMIT.MAX_IMAGES}张图片`, icon: 'none' })
      return
    }

    const filePaths = await chooseImage(1)
    if (filePaths.length === 0) return

    const filePath = filePaths[0]
    imagePreviews.value.push(filePath)

    uni.showLoading({ title: '上传中...' })
    const res = await uploadImage(filePath, UPLOAD_TYPE.COMMENT)
    uni.hideLoading()

    if (res && res.fileUrl) {
      formData.value.imageUrls.push(res.fileUrl)
    } else {
      // 上传失败，移除预览
      imagePreviews.value.pop()
      uni.showToast({ title: '上传失败，请重试', icon: 'none' })
    }
  }

  // 删除评价图片
  const removeCommentImage = (index) => {
    imagePreviews.value.splice(index, 1)
    formData.value.imageUrls.splice(index, 1)
  }

  // 预览评价图片
  const previewCommentImage = (urls, current) => {
    uni.previewImage({
      urls: urls,
      current: current
    })
  }

  // ============ 我的评价列表 ============
  const loadMyComments = async (isLoadMore = false) => {
    if (!userStore.isLogin) {
      uni.showToast({ title: '请先登录', icon: 'none' })
      return null
    }
    try {
      return await commentStore.fetchMyComments({}, isLoadMore)
    } catch (error) {
      console.error('加载我的评价失败:', error)
      return null
    }
  }

  // ============ 商品评价列表 ============
  const loadProductComments = async (productId, isLoadMore = false) => {
    try {
      return await commentStore.fetchProductComments(productId, {}, isLoadMore)
    } catch (error) {
      console.error('加载商品评价失败:', error)
      return null
    }
  }

  // 切换评分筛选
  const switchScoreFilter = (score) => {
    commentStore.setScoreFilter(score)
    // 返回 Promise 便于页面调用
    const productId = getCurrentProductId()
    if (productId) {
      return loadProductComments(productId, false)
    }
    return Promise.resolve(null)
  }

  // 获取当前商品ID（从页面路由）
  const getCurrentProductId = () => {
    const pages = getCurrentPages()
    const currentPage = pages[pages.length - 1]
    return currentPage?.options?.productId || currentPage?.options?.id || null
  }

  // ============ 评价详情 ============
  const loadCommentDetail = async (commentId) => {
    if (!commentId) return null
    try {
      return await commentStore.fetchCommentDetail(commentId)
    } catch (error) {
      handleCommentError(error)
      return null
    }
  }

  // ============ 删除评价 ============
  const deleteComment = (commentId) => {
    if (!commentId) return Promise.resolve(false)
    return new Promise((resolve) => {
      uni.showModal({
        title: '删除评价',
        content: '删除后评价无法恢复，确认删除？',
        confirmText: '删除',
        confirmColor: '#f56c6c',
        success: async (res) => {
          if (!res.confirm) {
            resolve(false)
            return
          }
          try {
            await commentStore.removeComment(commentId)
            uni.showToast({ title: '删除成功', icon: 'success' })
            resolve(true)
          } catch (error) {
            handleCommentError(error)
            resolve(false)
          }
        }
      })
    })
  }

  // ============ 重置表单 ============
  const resetForm = () => {
    formData.value = {
      orderId: null,
      orderItemId: null,
      productId: null,
      skuId: null,
      score: COMMENT_SCORE.FIVE,
      content: '',
      imageUrls: [],
      anonymous: ANONYMOUS.NO
    }
    imagePreviews.value = []
  }

  // ============ 工具方法 ============

  // 获取评分文案
  const getScoreText = (score) => {
    return SCORE_TEXT_MAP[score] || ''
  }

  // 获取状态信息
  const getStatusInfo = (status) => {
    return COMMENT_STATUS_MAP[status] || null
  }

  // 跳转到发布评价页
  const goPostComment = (params) => {
    const { orderId, orderItemId, productId, skuId, productName, productImage } = params
    const query = `orderId=${orderId}&orderItemId=${orderItemId}&productId=${productId}&skuId=${skuId}`
    uni.navigateTo({
      url: `/pagesSub/order/comment/postComment?${query}`
    })
  }

  // 跳转到我的评价列表
  const goMyComments = () => {
    uni.navigateTo({ url: '/pagesSub/order/comment/myComments' })
  }

  // 跳转到评价详情
  const goCommentDetail = (commentId) => {
    uni.navigateTo({ url: `/pagesSub/order/comment/commentDetail?commentId=${commentId}` })
  }

  return {
    // store
    commentStore,
    // 表单
    formData,
    imagePreviews,
    // 发布评价
    submitComment,
    addCommentImage,
    removeCommentImage,
    previewCommentImage,
    resetForm,
    // 列表
    loadMyComments,
    loadProductComments,
    switchScoreFilter,
    // 详情
    loadCommentDetail,
    // 删除
    deleteComment,
    // 工具
    getScoreText,
    getStatusInfo,
    goPostComment,
    goMyComments,
    goCommentDetail,
    // 常量
    COMMENT_SCORE,
    COMMENT_LIMIT,
    SCORE_FILTER_TABS,
    SCORE_TEXT_MAP,
    ANONYMOUS,
    DEFAULT_AVATAR,
    ANONYMOUS_NICKNAME,
    COMMENT_STATUS_MAP
  }
}
