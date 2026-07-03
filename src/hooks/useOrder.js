import { ref } from 'vue'
import { useOrderStore } from '@/store/order'
import { useUserStore } from '@/store/user'

export const useOrder = () => {
  const orderStore = useOrderStore()
  const userStore = useUserStore()
  const loading = ref(false)
  const previewLoading = ref(false)
  const listLoading = ref(false)
  const detailLoading = ref(false)

  const checkLogin = () => {
    if (!userStore.isLogin) {
      uni.showToast({ title: '请先登录', icon: 'none' })
      setTimeout(() => {
        uni.navigateTo({ url: '/pages/login/login' })
      }, 1000)
      return false
    }
    return true
  }

  const loadOrderPreview = async (previewData) => {
    if (!checkLogin()) {
      return null
    }

    previewLoading.value = true

    try {
      if (!previewData || typeof previewData !== 'object') {
        uni.showToast({ title: '预览数据格式错误', icon: 'none' })
        return null
      }

      if (!Array.isArray(previewData.cartItemIds) || !previewData.cartItemIds.length) {
        uni.showToast({ title: '请选择要购买的商品', icon: 'none' })
        return null
      }

      if (previewData.deliveryType === 'DELIVERY' && !previewData.addressId) {
        uni.showToast({ title: '配送方式下请选择收货地址', icon: 'none' })
        return null
      }

      if (previewData.deliveryType === 'PICKUP' && !previewData.pickupPointId) {
        uni.showToast({ title: '自提方式下请选择自提点', icon: 'none' })
        return null
      }

      const res = await orderStore.fetchOrderPreview(previewData)

      if (res) {
        return res
      } else {
        uni.showToast({ title: '获取订单预览失败', icon: 'none' })
        return null
      }
    } catch (error) {
      console.error('订单预览失败:', error)

      const errorCodeMap = {
        40911: '秒杀活动已结束',
        40912: '库存不足',
        40913: '优惠券不满足使用条件'
      }

      if (errorCodeMap[error?.code]) {
        uni.showToast({ title: errorCodeMap[error.code], icon: 'none' })
      } else if (error?.message) {
        uni.showToast({ title: error.message, icon: 'none' })
      } else {
        uni.showToast({ title: '获取订单预览失败，请重试', icon: 'none' })
      }

      return null
    } finally {
      previewLoading.value = false
    }
  }

  const loadOrderList = async (params) => {
    if (!checkLogin()) {
      return null
    }

    listLoading.value = true

    try {
      const res = await orderStore.fetchOrderList(params)

      if (res) {
        return res
      } else {
        uni.showToast({ title: '获取订单列表失败', icon: 'none' })
        return null
      }
    } catch (error) {
      console.error('获取订单列表失败:', error)

      if (error?.message) {
        uni.showToast({ title: error.message, icon: 'none' })
      } else {
        uni.showToast({ title: '获取订单列表失败，请重试', icon: 'none' })
      }

      return null
    } finally {
      listLoading.value = false
    }
  }

  const loadOrderDetail = async (orderId) => {
    if (!checkLogin()) {
      return null
    }

    if (!orderId) {
      uni.showToast({ title: '订单ID不能为空', icon: 'none' })
      return null
    }

    detailLoading.value = true

    try {
      const res = await orderStore.fetchOrderDetail(orderId)

      if (res) {
        return res
      } else {
        uni.showToast({ title: '获取订单详情失败', icon: 'none' })
        return null
      }
    } catch (error) {
      console.error('获取订单详情失败:', error)

      const errorCodeMap = {
        40421: '订单不存在'
      }

      if (errorCodeMap[error?.code]) {
        uni.showToast({ title: errorCodeMap[error.code], icon: 'none' })
      } else if (error?.message) {
        uni.showToast({ title: error.message, icon: 'none' })
      } else {
        uni.showToast({ title: '获取订单详情失败，请重试', icon: 'none' })
      }

      return null
    } finally {
      detailLoading.value = false
    }
  }

  const createOrder = async (orderData) => {
    if (!checkLogin()) {
      return null
    }

    loading.value = true

    try {
      if (!orderData || typeof orderData !== 'object') {
        uni.showToast({ title: '订单数据格式错误', icon: 'none' })
        return null
      }
      
      if (!Array.isArray(orderData.cartItemIds) || !orderData.cartItemIds.length) {
        uni.showToast({ title: '请选择要购买的商品', icon: 'none' })
        return null
      }
      
      if (!orderData.addressId && orderData.deliveryType === 1) {
        uni.showToast({ title: '配送方式下请选择收货地址', icon: 'none' })
        return null
      }
      
      if (!orderData.pickupPointId && orderData.deliveryType === 2) {
        uni.showToast({ title: '自提方式下请选择自提点', icon: 'none' })
        return null
      }
      
      const res = await orderStore.submitOrder(orderData)
      
      if (res) {
        uni.showToast({ title: '订单创建成功', icon: 'success' })
        return res
      } else {
        uni.showToast({ title: '创建订单失败', icon: 'none' })
        return null
      }
    } catch (error) {
      console.error('创建订单失败:', error)
      
      const errorCodeMap = {
        40911: '秒杀活动已结束',
        40912: '库存不足',
        40913: '优惠券不满足使用条件',
        40914: '订单重复提交',
        40915: '活动已过期'
      }
      
      if (errorCodeMap[error?.code]) {
        uni.showToast({ title: errorCodeMap[error.code], icon: 'none' })
      } else if (error?.message) {
        uni.showToast({ title: error.message, icon: 'none' })
      } else {
        uni.showToast({ title: '创建订单失败，请重试', icon: 'none' })
      }
      
      return null
    } finally {
      loading.value = false
    }
  }

  const cancelOrder = async (orderId, reason) => {
    if (!checkLogin()) {
      return false
    }

    if (!orderId) {
      uni.showToast({ title: '订单ID不能为空', icon: 'none' })
      return false
    }

    return new Promise((resolve) => {
      uni.showModal({
        title: '确认取消',
        content: '确定要取消该订单吗？',
        success: async (res) => {
          if (res.confirm) {
            try {
              const result = await orderStore.cancelOrder(orderId, { cancelReason: reason || '' })
              if (result) {
                uni.showToast({ title: '订单已取消', icon: 'success' })
                resolve(true)
              } else {
                uni.showToast({ title: '取消失败', icon: 'none' })
                resolve(false)
              }
            } catch (error) {
              console.error('取消订单失败:', error)
              const errorCodeMap = {
                40921: '当前订单状态不允许取消'
              }
              if (errorCodeMap[error?.code]) {
                uni.showToast({ title: errorCodeMap[error.code], icon: 'none' })
              } else if (error?.message) {
                uni.showToast({ title: error.message, icon: 'none' })
              } else {
                uni.showToast({ title: '取消订单失败', icon: 'none' })
              }
              resolve(false)
            }
          } else {
            resolve(false)
          }
        }
      })
    })
  }

  const deleteOrder = async (orderId) => {
    if (!checkLogin()) {
      return false
    }

    if (!orderId) {
      uni.showToast({ title: '订单ID不能为空', icon: 'none' })
      return false
    }

    return new Promise((resolve) => {
      uni.showModal({
        title: '确认删除',
        content: '确定要删除该订单吗？',
        success: async (res) => {
          if (res.confirm) {
            try {
              const result = await orderStore.deleteOrder(orderId)
              if (result) {
                uni.showToast({ title: '删除成功', icon: 'success' })
                resolve(true)
              } else {
                uni.showToast({ title: '删除失败', icon: 'none' })
                resolve(false)
              }
            } catch (error) {
              console.error('删除订单失败:', error)
              const errorCodeMap = {
                40922: '当前订单状态不允许删除'
              }
              if (errorCodeMap[error?.code]) {
                uni.showToast({ title: errorCodeMap[error.code], icon: 'none' })
              } else if (error?.message) {
                uni.showToast({ title: error.message, icon: 'none' })
              } else {
                uni.showToast({ title: '删除订单失败', icon: 'none' })
              }
              resolve(false)
            }
          } else {
            resolve(false)
          }
        }
      })
    })
  }

  const confirmOrder = async (orderId) => {
    if (!checkLogin()) {
      return false
    }

    if (!orderId) {
      uni.showToast({ title: '订单ID不能为空', icon: 'none' })
      return false
    }

    return new Promise((resolve) => {
      uni.showModal({
        title: '确认收货',
        content: '确定已收到商品吗？',
        success: async (res) => {
          if (res.confirm) {
            try {
              const result = await orderStore.confirmOrder(orderId)
              if (result) {
                uni.showToast({ title: '确认收货成功', icon: 'success' })
                resolve(true)
              } else {
                uni.showToast({ title: '确认收货失败', icon: 'none' })
                resolve(false)
              }
            } catch (error) {
              console.error('确认收货失败:', error)
              const errorCodeMap = {
                40923: '当前订单状态不允许确认收货'
              }
              if (errorCodeMap[error?.code]) {
                uni.showToast({ title: errorCodeMap[error.code], icon: 'none' })
              } else if (error?.message) {
                uni.showToast({ title: error.message, icon: 'none' })
              } else {
                uni.showToast({ title: '确认收货失败', icon: 'none' })
              }
              resolve(false)
            }
          } else {
            resolve(false)
          }
        }
      })
    })
  }

  const applyAfterSale = async (orderId, data) => {
    if (!checkLogin()) {
      return
    }

    try {
      uni.showToast({ title: '售后功能开发中', icon: 'none' })
    } catch (error) {
      console.error('申请售后失败:', error)
    }
  }

  const loadOrderStatus = async (orderId) => {
    if (!checkLogin()) {
      return null
    }

    if (!orderId) {
      uni.showToast({ title: '订单ID不能为空', icon: 'none' })
      return null
    }

    try {
      const res = await orderStore.fetchOrderStatus(orderId)

      if (res) {
        return res
      } else {
        console.error('查询订单状态失败')
        return null
      }
    } catch (error) {
      console.error('查询订单状态失败:', error)

      const errorCodeMap = {
        40421: '订单不存在'
      }

      if (errorCodeMap[error?.code]) {
        uni.showToast({ title: errorCodeMap[error.code], icon: 'none' })
      }

      return null
    }
  }

  const payOrder = async (orderId, payType) => {
    if (!checkLogin()) {
      return
    }

    try {
      uni.showToast({ title: '支付功能开发中', icon: 'none' })
    } catch (error) {
      console.error('支付失败:', error)
    }
  }

  const calculateOrderAmount = (goodsList, coupon, point) => {
    let totalAmount = goodsList.reduce((sum, item) => sum + item.price * item.count, 0)

    if (coupon && coupon.value) {
      totalAmount -= coupon.value
    }

    if (point > 0) {
      totalAmount -= point * 0.01
    }

    const shippingFee = calculateShippingFee(goodsList)

    return {
      goodsAmount: goodsList.reduce((sum, item) => sum + item.price * item.count, 0),
      discountAmount: (coupon?.value || 0) + (point * 0.01),
      shippingFee,
      totalAmount: totalAmount + shippingFee
    }
  }

  const calculateShippingFee = (goodsList) => {
    return 0
  }

  return {
    loading,
    previewLoading,
    listLoading,
    detailLoading,
    loadOrderPreview,
    loadOrderList,
    loadOrderDetail,
    loadOrderStatus,
    createOrder,
    cancelOrder,
    deleteOrder,
    confirmOrder,
    applyAfterSale,
    payOrder,
    calculateOrderAmount,
    calculateShippingFee
  }
}