import { defineStore } from 'pinia'
import { ref } from 'vue'
import { orderPreviewApi, submitOrderApi, getOrderListApi, getOrderDetailApi, getOrderStatusApi, cancelOrderApi, deleteOrderApi, confirmOrderApi } from '@/api/order'

export const useOrderStore = defineStore('order', () => {
  const orderList = ref([])
  const orderDetail = ref(null)
  const orderPreviewData = ref(null)

  const fetchOrderPreview = async (params) => {
    const res = await orderPreviewApi(params)
    if (res.code === 0 && res.data) {
      orderPreviewData.value = res.data
      return res.data
    }
    return null
  }

  const fetchOrderList = async (params) => {
    const res = await getOrderListApi(params)
    if (res.code === 0 && res.data) {
      orderList.value = res.data.list
      return res.data
    }
    return { list: [], total: 0, pages: 0, page: 1, pageSize: 10 }
  }

  const fetchOrderDetail = async (orderId) => {
    const res = await getOrderDetailApi(orderId)
    if (res.code === 0 && res.data) {
      orderDetail.value = res.data
      return res.data
    }
    return null
  }

  const fetchOrderStatus = async (orderId) => {
    const res = await getOrderStatusApi(orderId)
    if (res.code === 0 && res.data) {
      return res.data
    }
    return null
  }

  const submitOrder = async (params) => {
    const res = await submitOrderApi(params)
    if (res.code === 0 && res.data) {
      return res.data
    }
    return null
  }

  const cancelOrder = async (orderId, data) => {
    const res = await cancelOrderApi(orderId, data)
    if (res.code === 0) {
      return res.data
    }
    return null
  }

  const deleteOrder = async (orderId) => {
    const res = await deleteOrderApi(orderId)
    if (res.code === 0) {
      return res.data
    }
    return null
  }

  const confirmOrder = async (orderId) => {
    const res = await confirmOrderApi(orderId)
    if (res.code === 0) {
      return res.data
    }
    return null
  }

  return {
    orderList,
    orderDetail,
    orderPreviewData,
    fetchOrderPreview,
    fetchOrderList,
    fetchOrderDetail,
    fetchOrderStatus,
    submitOrder,
    cancelOrder,
    deleteOrder,
    confirmOrder
  }
})