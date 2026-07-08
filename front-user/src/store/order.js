import { defineStore } from 'pinia'
import { ref } from 'vue'
import { orderPreviewApi, submitOrderApi, getOrderListApi, getOrderDetailApi, getOrderStatusApi, cancelOrderApi, deleteOrderApi, confirmOrderApi } from '@/api/order'

export const useOrderStore = defineStore('order', () => {
  const orderList = ref([])
  const orderDetail = ref(null)
  const orderPreviewData = ref(null)
  const previewToken = ref('')
  const previewExpireSeconds = ref(0)

  // 订单预览
  const fetchOrderPreview = async (params) => {
    const res = await orderPreviewApi(params)
    if (res.code === 0 && res.data) {
      orderPreviewData.value = res.data
      previewToken.value = res.data.previewToken || ''
      previewExpireSeconds.value = res.data.previewExpireSeconds || 900
      return res.data
    }
    return null
  }

  // 提交订单（仅传 previewToken）
  const submitOrder = async (params) => {
    const res = await submitOrderApi(params)
    if (res.code === 0 && res.data) {
      // 提交成功后清空预览令牌
      previewToken.value = ''
      orderPreviewData.value = null
      return res.data
    }
    return null
  }

  // 获取订单列表
  const fetchOrderList = async (params) => {
    const res = await getOrderListApi(params)
    if (res.code === 0 && res.data) {
      orderList.value = res.data.list
      return res.data
    }
    return { list: [], total: 0, pages: 0, page: 1, pageSize: 10 }
  }

  // 获取订单详情
  const fetchOrderDetail = async (orderId) => {
    const res = await getOrderDetailApi(orderId)
    if (res.code === 0 && res.data) {
      orderDetail.value = res.data
      return res.data
    }
    return null
  }

  // 查询订单状态
  const fetchOrderStatus = async (orderId) => {
    const res = await getOrderStatusApi(orderId)
    if (res.code === 0 && res.data) {
      return res.data
    }
    return null
  }

  // 取消订单
  const cancelOrder = async (orderId, data) => {
    const res = await cancelOrderApi(orderId, data)
    if (res.code === 0) {
      return res.data
    }
    return null
  }

  // 删除订单
  const deleteOrder = async (orderId) => {
    const res = await deleteOrderApi(orderId)
    if (res.code === 0) {
      return res.data
    }
    return null
  }

  // 确认收货
  const confirmOrder = async (orderId) => {
    const res = await confirmOrderApi(orderId)
    if (res.code === 0) {
      return res.data
    }
    return null
  }

  // 清空预览数据
  const clearPreviewData = () => {
    orderPreviewData.value = null
    previewToken.value = ''
    previewExpireSeconds.value = 0
  }

  return {
    orderList,
    orderDetail,
    orderPreviewData,
    previewToken,
    previewExpireSeconds,
    fetchOrderPreview,
    fetchOrderList,
    fetchOrderDetail,
    fetchOrderStatus,
    submitOrder,
    cancelOrder,
    deleteOrder,
    confirmOrder,
    clearPreviewData
  }
})
