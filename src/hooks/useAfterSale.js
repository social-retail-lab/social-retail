import { ref, computed } from 'vue'
import { useAfterSaleStore } from '@/store/afterSale'
import {
  AFTER_SALE_ERROR_MSG,
  AFTER_SALE_ERROR_CODE,
  isAfterSaleCancellable
} from '@/constants/afterSale'
import { showToast, showLoading, hideLoading } from '@/utils/common'

/**
 * 售后业务 Hook
 * 封装异步逻辑、loading、try-catch、toast、错误码处理
 */
export const useAfterSale = () => {
  const afterSaleStore = useAfterSaleStore()
  const loading = ref(false)
  const submitting = ref(false)
  const refreshing = ref(false)
  const uploading = ref(false)

  // ============ 错误处理 ============
  const handleAfterSaleError = (error, defaultMsg = '操作失败') => {
    console.error('售后操作失败:', error)
    if (!error) {
      showToast(defaultMsg)
      return
    }
    // 优先用错误码映射
    const mappedMsg = AFTER_SALE_ERROR_MSG[error.code]
    if (mappedMsg) {
      showToast(mappedMsg)
      return
    }
    showToast(error.message || defaultMsg)
  }

  // ============ 3.4.1 提交售后申请 ============
  const submitAfterSaleApply = async (data) => {
    if (submitting.value) return null
    submitting.value = true
    showLoading('提交中...')
    try {
      const res = await afterSaleStore.submitAfterSale(data)
      if (res.code === 0) {
        hideLoading()
        showToast('售后申请提交成功', 'success')
        return res.data
      }
      hideLoading()
      handleAfterSaleError({ code: res.code, message: res.message }, '提交失败')
      return null
    } catch (error) {
      hideLoading()
      handleAfterSaleError(error, '提交失败')
      return null
    } finally {
      submitting.value = false
    }
  }

  // ============ 3.4.2 查询售后列表 ============
  const loadAfterSaleList = async (params = {}, isLoadMore = false) => {
    if (!isLoadMore) {
      loading.value = true
    }
    try {
      const res = await afterSaleStore.fetchAfterSaleList(params)
      return res
    } catch (error) {
      handleAfterSaleError(error, '获取售后列表失败')
      return { list: [], total: 0, pages: 0 }
    } finally {
      loading.value = false
    }
  }

  // ============ 3.4.3 查询售后详情 ============
  const loadAfterSaleDetail = async (afterSaleId) => {
    if (!afterSaleId) {
      showToast('售后ID不能为空')
      return null
    }
    loading.value = true
    try {
      const res = await afterSaleStore.fetchAfterSaleDetail(afterSaleId)
      if (!res) {
        // 售后不存在
        uni.showModal({
          title: '提示',
          content: '售后单不存在或已删除',
          showCancel: false,
          confirmText: '返回列表',
          success: () => {
            uni.redirectTo({ url: '/pagesSub/order/afterSaleList' })
          }
        })
        return null
      }
      return res
    } catch (error) {
      // 40431 售后不存在
      if (error?.code === AFTER_SALE_ERROR_CODE.NOT_FOUND) {
        uni.showModal({
          title: '提示',
          content: '售后单不存在或已删除',
          showCancel: false,
          confirmText: '返回列表',
          success: () => {
            uni.redirectTo({ url: '/pagesSub/order/afterSaleList' })
          }
        })
        return null
      }
      handleAfterSaleError(error, '获取售后详情失败')
      return null
    } finally {
      loading.value = false
    }
  }

  // ============ 3.4.4 取消售后 ============
  const cancelAfterSaleApply = async (afterSaleId, cancelReason) => {
    if (!afterSaleId) {
      showToast('售后ID不能为空')
      return false
    }
    if (!cancelReason || !cancelReason.trim()) {
      showToast('请输入取消原因')
      return false
    }
    showLoading('取消中...')
    try {
      const res = await afterSaleStore.cancelAfterSale(afterSaleId, { cancelReason: cancelReason.trim() })
      if (res.code === 0) {
        hideLoading()
        showToast('已取消售后', 'success')
        return true
      }
      hideLoading()
      handleAfterSaleError({ code: res.code, message: res.message }, '取消失败')
      return false
    } catch (error) {
      hideLoading()
      handleAfterSaleError(error, '取消失败')
      return false
    }
  }

  // ============ 3.4.5 上传售后凭证 ============
  const supplementEvidence = async (afterSaleId, imageUrls) => {
    if (!afterSaleId) {
      showToast('售后ID不能为空')
      return false
    }
    if (!Array.isArray(imageUrls) || imageUrls.length === 0) {
      showToast('请选择要上传的图片')
      return false
    }
    uploading.value = true
    showLoading('上传中...')
    try {
      const res = await afterSaleStore.uploadAfterSaleImages(afterSaleId, imageUrls)
      if (res.code === 0) {
        hideLoading()
        showToast('凭证上传成功', 'success')
        return true
      }
      hideLoading()
      handleAfterSaleError({ code: res.code, message: res.message }, '上传失败')
      return false
    } catch (error) {
      hideLoading()
      handleAfterSaleError(error, '上传失败')
      return false
    } finally {
      uploading.value = false
    }
  }

  // ============ 业务方法 ============

  /**
   * 弹窗确认取消售后
   */
  const confirmCancelAfterSale = async (afterSaleId) => {
    return new Promise((resolve) => {
      uni.showModal({
        title: '取消售后',
        editable: true,
        placeholderText: '请输入取消原因',
        confirmText: '确认取消',
        cancelText: '再想想',
        success: async (res) => {
          if (!res.confirm) {
            resolve(false)
            return
          }
          const cancelReason = (res.content || '').trim()
          if (!cancelReason) {
            showToast('请填写取消原因')
            resolve(false)
            return
          }
          const success = await cancelAfterSaleApply(afterSaleId, cancelReason)
          resolve(success)
        }
      })
    })
  }

  /**
   * 跳转售后详情
   */
  const goAfterSaleDetail = (afterSaleId) => {
    if (!afterSaleId) {
      showToast('售后ID缺失')
      return
    }
    uni.navigateTo({
      url: `/pagesSub/order/afterSale/afterSaleDetail?afterSaleId=${afterSaleId}`,
      animationType: 'slide-in-right',
      animationDuration: 200
    })
  }

  /**
   * 跳转售后申请页
   * @param {Object} item 订单商品项 { orderId, orderItemId, productName, productImage, skuSpecs, originPrice }
   */
  const goAfterSaleApply = (item) => {
    if (!item?.orderItemId) {
      showToast('订单商品信息缺失')
      return
    }
    const params = [
      `orderId=${item.orderId || ''}`,
      `orderItemId=${item.orderItemId}`,
      `productName=${encodeURIComponent(item.productName || '')}`,
      `productImage=${encodeURIComponent(item.productImage || '')}`,
      `skuSpecs=${encodeURIComponent(item.skuSpecs || '')}`,
      `originPrice=${item.originPrice || 0}`
    ].join('&')
    uni.navigateTo({
      url: `/pagesSub/order/afterSale/afterSaleApply?${params}`,
      animationType: 'slide-in-right',
      animationDuration: 200
    })
  }

  /**
   * 跳转售后列表
   */
  const goAfterSaleList = () => {
    uni.navigateTo({
      url: '/pagesSub/order/afterSaleList',
      animationType: 'slide-in-right',
      animationDuration: 200
    })
  }

  /**
   * 重置售后数据
   */
  const resetAfterSaleData = () => {
    afterSaleStore.resetAfterSaleData()
  }

  return {
    afterSaleStore,
    loading,
    submitting,
    refreshing,
    uploading,
    // 异步方法
    submitAfterSaleApply,
    loadAfterSaleList,
    loadAfterSaleDetail,
    cancelAfterSaleApply,
    supplementEvidence,
    // 业务方法
    confirmCancelAfterSale,
    goAfterSaleApply,
    goAfterSaleDetail,
    goAfterSaleList,
    resetAfterSaleData,
    // 辅助
    isAfterSaleCancellable
  }
}
