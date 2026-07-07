// 分销员状态管理（Pinia）
// 缓存：申请状态、分销中心工作台数据
// 与 user store 协作：审核通过后同步 userStore.isDistributor

import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import {
  applyDistributorApi,
  getDistributorStatusApi,
  getDistributorDashboardApi,
  getPromotionProductsApi,
  promoteProductApi,
  generateShareLinkApi,
  getMyPromotionProductsApi,
  getMyPromotionProductDetailApi,
  disablePromotionProductApi,
  enablePromotionProductApi,
  getDistributorOrdersApi,
  getCommissionDetailApi,
  applyWithdrawApi,
  getWithdrawRecordsApi
} from '@/api/distributor'
import {
  AUDIT_STATUS,
  AUDIT_STATUS_MAP,
  DISTRIBUTOR_ERROR_CODE,
  PROMOTION_ERROR_CODE
} from '@/constants/distributor'

export const useDistributorStore = defineStore('distributor', () => {
  // ============ 状态 ============
  // 申请状态信息（5.1.2 接口返回）
  const statusInfo = ref(null)
  // 工作台数据（5.1.3 接口返回）
  const dashboardData = ref(null)
  // 加载状态
  const statusLoading = ref(false)
  const dashboardLoading = ref(false)
  const applyLoading = ref(false)

  // ============ 计算属性 ============
  // 是否已成为分销员
  const isDistributor = computed(() => {
    return !!(statusInfo.value && statusInfo.value.isDistributor)
  })

  // 审核状态
  const auditStatus = computed(() => {
    return statusInfo.value?.auditStatus ?? null
  })

  // 审核状态文案
  const auditStatusText = computed(() => {
    return statusInfo.value?.auditStatusText || '未申请'
  })

  // 审核状态映射信息（含颜色、图标、描述）
  const auditStatusInfo = computed(() => {
    const status = auditStatus.value
    if (status === null) return null
    return AUDIT_STATUS_MAP[status] || null
  })

  // 是否已申请（含待审核/通过/拒绝）
  const hasApplied = computed(() => {
    return statusInfo.value && statusInfo.value.auditStatus !== null
  })

  // 是否可以重新申请（审核拒绝后允许重新申请）
  const canReapply = computed(() => {
    return auditStatus.value === AUDIT_STATUS.REJECTED
  })

  // ============ Actions ============

  // 5.1.1 提交分销员申请
  const submitApply = async (data) => {
    applyLoading.value = true
    try {
      const res = await applyDistributorApi(data)
      // 申请成功后立即更新本地状态
      if (res?.data) {
        statusInfo.value = {
          isDistributor: false,
          auditStatus: res.data.auditStatus ?? AUDIT_STATUS.PENDING,
          auditStatusText: res.data.auditStatusText || '待审核',
          applyTime: res.data.applyTime || '',
          applyId: res.data.applyId
        }
      }
      return res
    } catch (error) {
      // 业务错误码特殊处理：已是分销员/重复申请
      const code = error?.code
      if (code === DISTRIBUTOR_ERROR_CODE.ALREADY_DISTRIBUTOR) {
        // 已是分销员，刷新状态
        await fetchStatus()
      }
      throw error
    } finally {
      applyLoading.value = false
    }
  }

  // 5.1.2 查询申请状态
  const fetchStatus = async () => {
    statusLoading.value = true
    try {
      const res = await getDistributorStatusApi()
      if (res?.data) {
        statusInfo.value = res.data
      }
      return res
    } catch (error) {
      console.error('查询分销员状态失败:', error)
      throw error
    } finally {
      statusLoading.value = false
    }
  }

  // 5.1.3 查询工作台数据
  const fetchDashboard = async () => {
    dashboardLoading.value = true
    try {
      const res = await getDistributorDashboardApi()
      if (res?.data) {
        dashboardData.value = res.data
      }
      return res
    } catch (error) {
      console.error('查询分销中心数据失败:', error)
      throw error
    } finally {
      dashboardLoading.value = false
    }
  }

  // ============ 5.2 推广商品状态 ============
  // 可推广商品列表（5.2.1）
  const promotionProducts = ref([])
  const promotionProductsTotal = ref(0)
  const promotionProductsPage = ref(1)
  const promotionProductsPages = ref(0)
  const promotionProductsLoading = ref(false)
  const promotionMerchantFilter = ref(null) // 商家筛选
  const promotionKeyword = ref('')

  // 我的推广商品列表（5.2.4）
  const myPromotionProducts = ref([])
  const myPromotionProductsTotal = ref(0)
  const myPromotionProductsPage = ref(1)
  const myPromotionProductsPages = ref(0)
  const myPromotionProductsLoading = ref(false)
  const myPromotionStatusFilter = ref('') // '' 全部 / 0 停用 / 1 启用
  const myPromotionKeyword = ref('')

  // 推广商品详情（5.2.5）
  const currentPromotionProduct = ref(null)
  const promotionDetailLoading = ref(false)

  // 推广操作 loading
  const promoteLoading = ref(false)
  const togglePromotionLoading = ref(false)

  // ============ 5.2 推广商品 Actions ============

  // 5.2.1 可推广商品列表
  const fetchPromotionProducts = async (params = {}, isLoadMore = false) => {
    promotionProductsLoading.value = true
    try {
      const page = isLoadMore ? promotionProductsPage.value + 1 : 1
      const reqParams = {
        page,
        pageSize: 10,
        keyword: promotionKeyword.value || undefined,
        merchantId: promotionMerchantFilter.value || undefined,
        ...params
      }
      const res = await getPromotionProductsApi(reqParams)
      if (res?.data?.list) {
        if (isLoadMore) {
          promotionProducts.value = [...promotionProducts.value, ...res.data.list]
        } else {
          promotionProducts.value = res.data.list
        }
        promotionProductsTotal.value = res.data.total || 0
        promotionProductsPage.value = res.data.page || page
        promotionProductsPages.value = res.data.pages || 0
      }
      return res
    } catch (error) {
      console.error('查询可推广商品失败:', error)
      throw error
    } finally {
      promotionProductsLoading.value = false
    }
  }

  // 5.2.2 申请推广商品分销
  const promoteProduct = async (distributionProductId) => {
    promoteLoading.value = true
    try {
      const res = await promoteProductApi(distributionProductId)
      // 申请成功后，更新本地列表中对应商品的 alreadyPromoted 状态
      if (res?.data) {
        const idx = promotionProducts.value.findIndex(
          p => p.distributionProductId === distributionProductId
        )
        if (idx >= 0) {
          promotionProducts.value[idx].alreadyPromoted = true
        }
      }
      return res
    } catch (error) {
      console.error('申请推广失败:', error)
      throw error
    } finally {
      promoteLoading.value = false
    }
  }

  // 5.2.3 生成推广链接
  const generateShareLink = async (distributorProductId) => {
    try {
      const res = await generateShareLinkApi({ distributorProductId })
      return res
    } catch (error) {
      console.error('生成推广链接失败:', error)
      throw error
    }
  }

  // 5.2.4 我的推广商品列表
  const fetchMyPromotionProducts = async (params = {}, isLoadMore = false) => {
    myPromotionProductsLoading.value = true
    try {
      const page = isLoadMore ? myPromotionProductsPage.value + 1 : 1
      const reqParams = {
        page,
        pageSize: 10,
        keyword: myPromotionKeyword.value || undefined,
        status: myPromotionStatusFilter.value === '' ? undefined : myPromotionStatusFilter.value,
        ...params
      }
      const res = await getMyPromotionProductsApi(reqParams)
      if (res?.data?.list) {
        if (isLoadMore) {
          myPromotionProducts.value = [...myPromotionProducts.value, ...res.data.list]
        } else {
          myPromotionProducts.value = res.data.list
        }
        myPromotionProductsTotal.value = res.data.total || 0
        myPromotionProductsPage.value = res.data.page || page
        myPromotionProductsPages.value = res.data.pages || 0
      }
      return res
    } catch (error) {
      console.error('查询我的推广商品失败:', error)
      throw error
    } finally {
      myPromotionProductsLoading.value = false
    }
  }

  // 5.2.5 我的推广商品详情
  const fetchPromotionProductDetail = async (distributorProductId) => {
    promotionDetailLoading.value = true
    try {
      const res = await getMyPromotionProductDetailApi(distributorProductId)
      if (res?.data) {
        currentPromotionProduct.value = res.data
      }
      return res
    } catch (error) {
      // 推广商品不存在 → 清空详情
      if (error?.code === PROMOTION_ERROR_CODE.NOT_FOUND) {
        currentPromotionProduct.value = null
      }
      console.error('查询推广商品详情失败:', error)
      throw error
    } finally {
      promotionDetailLoading.value = false
    }
  }

  // 5.2.6 取消推广商品
  const disablePromotionProduct = async (distributorProductId) => {
    togglePromotionLoading.value = true
    try {
      const res = await disablePromotionProductApi(distributorProductId)
      // 更新本地列表中对应商品的状态
      const updateItem = (item) => {
        if (item.distributorProductId === distributorProductId) {
          item.status = 0
          item.statusText = '已停用'
        }
      }
      myPromotionProducts.value.forEach(updateItem)
      if (currentPromotionProduct.value?.distributorProductId === distributorProductId) {
        currentPromotionProduct.value.status = 0
        currentPromotionProduct.value.statusText = '已停用'
      }
      return res
    } catch (error) {
      console.error('取消推广失败:', error)
      throw error
    } finally {
      togglePromotionLoading.value = false
    }
  }

  // 5.2.7 恢复推广商品
  const enablePromotionProduct = async (distributorProductId) => {
    togglePromotionLoading.value = true
    try {
      const res = await enablePromotionProductApi(distributorProductId)
      // 更新本地列表中对应商品的状态
      // 恢复推广后后端会清空推广链接和二维码，需重新生成
      const updateItem = (item) => {
        if (item.distributorProductId === distributorProductId) {
          item.status = 1
          item.statusText = '推广中'
          item.promotionUrl = ''
          item.qrCode = ''
        }
      }
      myPromotionProducts.value.forEach(updateItem)
      if (currentPromotionProduct.value?.distributorProductId === distributorProductId) {
        currentPromotionProduct.value.status = 1
        currentPromotionProduct.value.statusText = '推广中'
        currentPromotionProduct.value.promotionUrl = ''
        currentPromotionProduct.value.qrCode = ''
      }
      return res
    } catch (error) {
      console.error('恢复推广失败:', error)
      throw error
    } finally {
      togglePromotionLoading.value = false
    }
  }

  // 重置推广商品数据（页面卸载时调用）
  const resetPromotionData = () => {
    promotionProducts.value = []
    promotionProductsTotal.value = 0
    promotionProductsPage.value = 1
    promotionProductsPages.value = 0
    promotionMerchantFilter.value = null
    promotionKeyword.value = ''
    myPromotionProducts.value = []
    myPromotionProductsTotal.value = 0
    myPromotionProductsPage.value = 1
    myPromotionProductsPages.value = 0
    myPromotionStatusFilter.value = ''
    myPromotionKeyword.value = ''
    currentPromotionProduct.value = null
  }

  // ============ 5.3 佣金管理 State ============
  // 推广订单列表（5.3.1）
  const distributorOrders = ref([])
  const distributorOrdersTotal = ref(0)
  const distributorOrdersPage = ref(1)
  const distributorOrdersPages = ref(0)
  const distributorOrdersLoading = ref(false)
  const distributorOrderStatusFilter = ref('') // '' 全部 / 0 冻结 / 1 已结算
  const distributorOrderKeyword = ref('')

  // 佣金明细列表（5.3.2）
  const commissionRecords = ref([])
  const commissionRecordsTotal = ref(0)
  const commissionRecordsPage = ref(1)
  const commissionRecordsPages = ref(0)
  const commissionRecordsLoading = ref(false)
  const commissionRecordStatusFilter = ref('') // '' 全部 / 0 待结算 / 1 已结算

  // 提现申请（5.3.3）
  const withdrawApplyLoading = ref(false)
  const lastWithdrawResult = ref(null) // 最近一次提现申请结果

  // 提现记录列表（5.3.4）
  const withdrawRecords = ref([])
  const withdrawRecordsTotal = ref(0)
  const withdrawRecordsPage = ref(1)
  const withdrawRecordsPages = ref(0)
  const withdrawRecordsLoading = ref(false)
  const withdrawRecordStatusFilter = ref('') // '' 全部 / 0 处理中 / 1 成功 / 2 失败

  // ============ 5.3 佣金管理 Actions ============

  // 5.3.1 推广订单列表
  const fetchDistributorOrders = async (params = {}, isLoadMore = false) => {
    distributorOrdersLoading.value = true
    try {
      const page = isLoadMore ? distributorOrdersPage.value + 1 : 1
      const reqParams = {
        page,
        pageSize: 10,
        keyword: distributorOrderKeyword.value || undefined,
        status: distributorOrderStatusFilter.value === '' ? undefined : distributorOrderStatusFilter.value,
        ...params
      }
      const res = await getDistributorOrdersApi(reqParams)
      if (res?.data?.list) {
        if (isLoadMore) {
          distributorOrders.value = [...distributorOrders.value, ...res.data.list]
        } else {
          distributorOrders.value = res.data.list
        }
        distributorOrdersTotal.value = res.data.total || 0
        distributorOrdersPage.value = res.data.page || page
        distributorOrdersPages.value = res.data.pages || 0
      }
      return res
    } catch (error) {
      console.error('查询推广订单失败:', error)
      throw error
    } finally {
      distributorOrdersLoading.value = false
    }
  }

  // 5.3.2 佣金明细
  const fetchCommissionDetail = async (params = {}, isLoadMore = false) => {
    commissionRecordsLoading.value = true
    try {
      const page = isLoadMore ? commissionRecordsPage.value + 1 : 1
      const reqParams = {
        page,
        size: 10,
        status: commissionRecordStatusFilter.value === '' ? undefined : commissionRecordStatusFilter.value,
        ...params
      }
      const res = await getCommissionDetailApi(reqParams)
      if (res?.data?.list) {
        if (isLoadMore) {
          commissionRecords.value = [...commissionRecords.value, ...res.data.list]
        } else {
          commissionRecords.value = res.data.list
        }
        commissionRecordsTotal.value = res.data.total || 0
        // 佣金明细接口未返回 pages，前端计算
        commissionRecordsPage.value = page
        commissionRecordsPages.value = Math.ceil((res.data.total || 0) / 10)
      }
      return res
    } catch (error) {
      console.error('查询佣金明细失败:', error)
      throw error
    } finally {
      commissionRecordsLoading.value = false
    }
  }

  // 5.3.3 提现申请
  const submitWithdrawApply = async (data) => {
    withdrawApplyLoading.value = true
    try {
      const res = await applyWithdrawApi(data)
      if (res?.data) {
        lastWithdrawResult.value = res.data
        // 提现成功后同步扣减工作台的可提现佣金、增加冻结佣金
        if (dashboardData.value) {
          dashboardData.value = {
            ...dashboardData.value,
            availableCommission: Number(dashboardData.value.availableCommission || 0) - Number(res.data.amount || 0),
            frozenCommission: Number(dashboardData.value.frozenCommission || 0) + Number(res.data.amount || 0)
          }
        }
      }
      return res
    } catch (error) {
      console.error('提现申请失败:', error)
      throw error
    } finally {
      withdrawApplyLoading.value = false
    }
  }

  // 5.3.4 提现记录
  const fetchWithdrawRecords = async (params = {}, isLoadMore = false) => {
    withdrawRecordsLoading.value = true
    try {
      const page = isLoadMore ? withdrawRecordsPage.value + 1 : 1
      const reqParams = {
        page,
        size: 10,
        status: withdrawRecordStatusFilter.value === '' ? undefined : withdrawRecordStatusFilter.value,
        ...params
      }
      const res = await getWithdrawRecordsApi(reqParams)
      if (res?.data?.list) {
        if (isLoadMore) {
          withdrawRecords.value = [...withdrawRecords.value, ...res.data.list]
        } else {
          withdrawRecords.value = res.data.list
        }
        withdrawRecordsTotal.value = res.data.total || 0
        withdrawRecordsPage.value = page
        withdrawRecordsPages.value = Math.ceil((res.data.total || 0) / 10)
      }
      return res
    } catch (error) {
      console.error('查询提现记录失败:', error)
      throw error
    } finally {
      withdrawRecordsLoading.value = false
    }
  }

  // 重置佣金数据（页面卸载/退出登录时调用）
  const resetCommissionData = () => {
    distributorOrders.value = []
    distributorOrdersTotal.value = 0
    distributorOrdersPage.value = 1
    distributorOrdersPages.value = 0
    distributorOrderStatusFilter.value = ''
    distributorOrderKeyword.value = ''
    commissionRecords.value = []
    commissionRecordsTotal.value = 0
    commissionRecordsPage.value = 1
    commissionRecordsPages.value = 0
    commissionRecordStatusFilter.value = ''
    lastWithdrawResult.value = null
    withdrawRecords.value = []
    withdrawRecordsTotal.value = 0
    withdrawRecordsPage.value = 1
    withdrawRecordsPages.value = 0
    withdrawRecordStatusFilter.value = ''
  }

  // 重置数据（退出登录时调用）
  const resetDistributorData = () => {
    statusInfo.value = null
    dashboardData.value = null
    statusLoading.value = false
    dashboardLoading.value = false
    applyLoading.value = false
    resetPromotionData()
    resetCommissionData()
  }

  return {
    // state
    statusInfo,
    dashboardData,
    statusLoading,
    dashboardLoading,
    applyLoading,
    // 5.2 推广商品 state
    promotionProducts,
    promotionProductsTotal,
    promotionProductsPage,
    promotionProductsPages,
    promotionProductsLoading,
    promotionMerchantFilter,
    promotionKeyword,
    myPromotionProducts,
    myPromotionProductsTotal,
    myPromotionProductsPage,
    myPromotionProductsPages,
    myPromotionProductsLoading,
    myPromotionStatusFilter,
    myPromotionKeyword,
    currentPromotionProduct,
    promotionDetailLoading,
    promoteLoading,
    togglePromotionLoading,
    // computed
    isDistributor,
    auditStatus,
    auditStatusText,
    auditStatusInfo,
    hasApplied,
    canReapply,
    // actions
    submitApply,
    fetchStatus,
    fetchDashboard,
    resetDistributorData,
    // 5.2 推广商品 actions
    fetchPromotionProducts,
    promoteProduct,
    generateShareLink,
    fetchMyPromotionProducts,
    fetchPromotionProductDetail,
    disablePromotionProduct,
    enablePromotionProduct,
    resetPromotionData,
    // 5.3 佣金管理 state
    distributorOrders,
    distributorOrdersTotal,
    distributorOrdersPage,
    distributorOrdersPages,
    distributorOrdersLoading,
    distributorOrderStatusFilter,
    distributorOrderKeyword,
    commissionRecords,
    commissionRecordsTotal,
    commissionRecordsPage,
    commissionRecordsPages,
    commissionRecordsLoading,
    commissionRecordStatusFilter,
    withdrawApplyLoading,
    lastWithdrawResult,
    withdrawRecords,
    withdrawRecordsTotal,
    withdrawRecordsPage,
    withdrawRecordsPages,
    withdrawRecordsLoading,
    withdrawRecordStatusFilter,
    // 5.3 佣金管理 actions
    fetchDistributorOrders,
    fetchCommissionDetail,
    submitWithdrawApply,
    fetchWithdrawRecords,
    resetCommissionData
  }
})
