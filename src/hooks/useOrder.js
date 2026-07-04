import { ref } from 'vue'
import { useOrderStore } from '@/store/order'
import { useUserStore } from '@/store/user'
import {
  createAlipayApi,
  getPayStatusApi,
  mockPaySuccessApi,
  mockPayFailApi,
  getPaymentDetailApi
} from '@/api/pay'

export const useOrder = () => {
  const orderStore = useOrderStore()
  const userStore = useUserStore()
  const loading = ref(false)
  const previewLoading = ref(false)
  const listLoading = ref(false)
  const detailLoading = ref(false)
  const submitting = ref(false)

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

  // 加载订单预览
  // 结算页面任何条件变更都必须重新调用预览接口刷新全套价格、优惠、token
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

      const res = await orderStore.fetchOrderPreview(previewData)

      if (res) {
        return res
      } else {
        // base.js handleError 已弹出 toast，不重复弹
        return null
      }
    } catch (error) {
      console.error('订单预览失败:', error)

      const errorCodeMap = {
        40911: '秒杀活动已结束',
        40912: '库存不足',
        40913: '优惠券不满足使用条件'
      }

      // 仅在 base.js 未处理时弹 toast（非200状态码的错误）
      if (error?.statusCode && error?.message && !error?.code) {
        uni.showToast({ title: error.message, icon: 'none' })
      } else if (errorCodeMap[error?.code]) {
        uni.showToast({ title: errorCodeMap[error.code], icon: 'none' })
      }
      // base.js handleError 已处理过的业务错误不重复弹 toast

      return null
    } finally {
      previewLoading.value = false
    }
  }

  // 加载订单列表
  const loadOrderList = async (params) => {
    if (!checkLogin()) {
      return null
    }

    listLoading.value = true

    try {
      const res = await orderStore.fetchOrderList(params)
      return res
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

  // 加载订单详情
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
      const errorCodeMap = { 40421: '订单不存在' }
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

  // 提交订单（仅传 previewToken）
  // 后端从 Redis 读取预览快照，二次校验后生成订单
  const createOrder = async (previewToken) => {
    if (!checkLogin()) {
      return null
    }

    if (!previewToken) {
      uni.showToast({ title: '预览令牌已失效，请重新预览', icon: 'none' })
      return null
    }

    if (submitting.value) {
      return null
    }

    submitting.value = true
    loading.value = true

    try {
      const res = await orderStore.submitOrder({ previewToken })

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
        40915: '活动已过期',
        40916: '预览令牌已过期，请重新预览'
      }

      if (errorCodeMap[error?.code]) {
        uni.showToast({ title: errorCodeMap[error.code], icon: 'none' })
      } else if (error?.message) {
        uni.showToast({ title: error.message, icon: 'none' })
      } else {
        uni.showToast({ title: '创建订单失败，请重试', icon: 'none' })
      }

      // 报错后清空当前 previewToken，强制用户重新修改条件并重新预览
      orderStore.clearPreviewData()
      return null
    } finally {
      submitting.value = false
      loading.value = false
    }
  }

  // 取消订单
  // 仅 WAIT_PAY 可调用（后端限制：仅待支付订单可以取消）
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
              const errorCodeMap = { 40921: '当前订单状态不允许取消' }
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

  // 删除订单
  // 仅 COMPLETED、CANCELLED、CLOSED 可删除
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
        content: '确定要删除该订单吗？删除后不可恢复',
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
              const errorCodeMap = { 40922: '当前订单状态不允许删除' }
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

  // 确认收货
  // 仅 IN_PROGRESS 状态可用
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
              const errorCodeMap = { 40923: '当前订单状态不允许确认收货' }
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

  // 查询订单状态（轻量化接口，用于轮询）
  const loadOrderStatus = async (orderId) => {
    if (!checkLogin()) {
      return null
    }

    if (!orderId) {
      return null
    }

    try {
      const res = await orderStore.fetchOrderStatus(orderId)
      return res
    } catch (error) {
      console.error('查询订单状态失败:', error)
      return null
    }
  }

  // ============ 支付相关方法 ============

  // 创建支付宝支付
  const createAlipay = async (orderId, payType = 'WAP') => {
    if (!checkLogin()) return null

    try {
      const params = { orderId, payType }

      // #ifdef H5
      // 构建支付完成后返回前端页面的地址
      // 注意:支付宝回调参数必须放在 # 前面,否则会被 uni-app hash 路由吞掉
      // 正确格式: https://域名?orderId=xxx&支付宝回调参数#/pagesSub/order/orderList
      // 错误格式: https://域名/#/pagesSub/order/orderList?orderId=xxx&支付宝回调参数
      if (typeof window !== 'undefined' && window.location) {
        params.returnUrl = `${window.location.origin}${window.location.pathname}?orderId=${orderId}#/pagesSub/order/orderList`
      }
      // #endif

      const res = await createAlipayApi(params)
      if (res.code === 0 && res.data) {
        return res.data
      }
      return null
    } catch (error) {
      console.error('创建支付宝支付失败:', error)
      const errorCodeMap = {
        40924: '当前订单状态不允许支付'
      }
      if (errorCodeMap[error?.code]) {
        uni.showToast({ title: errorCodeMap[error.code], icon: 'none' })
      } else if (error?.message && !error?.code) {
        uni.showToast({ title: error.message, icon: 'none' })
      }
      return null
    }
  }

  // 查询支付状态
  const loadPayStatus = async (orderId) => {
    if (!checkLogin()) return null

    try {
      const res = await getPayStatusApi(orderId)
      if (res.code === 0 && res.data) {
        return res.data
      }
      return null
    } catch (error) {
      console.error('查询支付状态失败:', error)
      return null
    }
  }

  // 模拟支付成功
  const mockPaySuccess = async (orderId, payAmount) => {
    if (!checkLogin()) return null

    try {
      const res = await mockPaySuccessApi({ orderId, payAmount })
      if (res.code === 0 && res.data) {
        return res.data
      }
      return null
    } catch (error) {
      console.error('模拟支付成功失败:', error)
      const errorCodeMap = {
        40925: '支付金额与订单应付金额不一致'
      }
      if (errorCodeMap[error?.code]) {
        uni.showToast({ title: errorCodeMap[error.code], icon: 'none' })
      } else if (error?.message && !error?.code) {
        uni.showToast({ title: error.message, icon: 'none' })
      }
      return null
    }
  }

  // 模拟支付失败
  const mockPayFail = async (orderId, failReason) => {
    if (!checkLogin()) return null

    try {
      const res = await mockPayFailApi({ orderId, failReason })
      if (res.code === 0 && res.data) {
        return res.data
      }
      return null
    } catch (error) {
      console.error('模拟支付失败:', error)
      return null
    }
  }

  // 查询支付流水详情
  const loadPaymentDetail = async (paymentId) => {
    if (!checkLogin()) return null

    try {
      const res = await getPaymentDetailApi(paymentId)
      if (res.code === 0 && res.data) {
        return res.data
      }
      return null
    } catch (error) {
      console.error('查询支付流水失败:', error)
      return null
    }
  }

  return {
    loading,
    previewLoading,
    listLoading,
    detailLoading,
    submitting,
    loadOrderPreview,
    loadOrderList,
    loadOrderDetail,
    loadOrderStatus,
    createOrder,
    cancelOrder,
    deleteOrder,
    confirmOrder,
    createAlipay,
    loadPayStatus,
    mockPaySuccess,
    mockPayFail,
    loadPaymentDetail
  }
}
